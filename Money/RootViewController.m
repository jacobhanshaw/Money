//
//  RootViewController.m
//  Money
//
//  Created by Jacob Hanshaw on 1/24/13.
//  Copyright (c) 2013 Jacob Hanshaw. All rights reserved.
//

#import "RootViewController.h"

@implementation RootViewController

@synthesize bumpResult;

+ (id)sharedRootViewController
{
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] initWithFrame:[UIScreen mainScreen].bounds];
    });
    return _sharedObject;
}

- (IBAction)addButtonPressed:(id)sender {
    PaymentViewController *payController = [[PaymentViewController alloc] init];
    [self presentViewController:payController animated:YES completion:nil];
}

- (IBAction)payNowButtonPressed:(id)sender {
    PaymentViewController *payController = [[PaymentViewController alloc] init];
    [self presentViewController:payController animated:YES completion:nil];
}

- (id)initWithFrame:(CGRect)frame {
    self = [super init];
    if (self) {
        self.view.frame = frame;
        
        //Init UserDefaults
		NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        if([defaults objectForKey:@"id"] == nil) [defaults setObject:@"" forKey:@"id"];
        if([defaults objectForKey:@"first_name"] == nil) [defaults setObject:@"" forKey:@"first_name"];
        if([defaults objectForKey:@"last_name"] == nil) [defaults setObject:@"" forKey:@"last_name"];
        if([defaults objectForKey:@"email"] == nil) [defaults setObject:@"" forKey:@"email"];
        [defaults synchronize];
    }
    return self;
}

- (void) configureBump {
    [BumpClient configureWithAPIKey:@"9e4909806e1144959884ad8f06ace7fd" andUserID:[[UIDevice currentDevice] name]];
    
    [BumpClient sharedClient].bumpable = YES;
    
    [[BumpClient sharedClient] setMatchBlock:^(BumpChannelID channel) {
        NSLog(@"Matched with user: %@", [[BumpClient sharedClient] userIDForChannel:channel]);
        [[BumpClient sharedClient] confirmMatch:YES onChannel:channel];
    }];
    
    [[BumpClient sharedClient] setChannelConfirmedBlock:^(BumpChannelID channel) {
        NSLog(@"Channel with %@ confirmed.", [[BumpClient sharedClient] userIDForChannel:channel]);
        [[BumpClient sharedClient] sendData:[[[NSUserDefaults standardUserDefaults] objectForKey:@"email"] dataUsingEncoding:NSUTF8StringEncoding] toChannel:channel];
    }];
    
    [[BumpClient sharedClient] setDataReceivedBlock:^(BumpChannelID channel, NSData *data) {
        NSLog(@"Data received from %@: %@",
              [[BumpClient sharedClient] userIDForChannel:channel],
              [NSString stringWithCString:[data bytes] encoding:NSUTF8StringEncoding]);
        bumpResult = [NSString stringWithCString:[data bytes] encoding:NSUTF8StringEncoding];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"bumpReceived" object:nil];
    }];
    
    [[BumpClient sharedClient] setConnectionStateChangedBlock:^(BOOL connected) {
        if (connected) {
            NSLog(@"Bump connected...");
        } else {
            NSLog(@"Bump disconnected...");
        }
    }];
    
    [[BumpClient sharedClient] setBumpEventBlock:^(bump_event event) {
        switch(event) {
            case BUMP_EVENT_BUMP:
                NSLog(@"Bump detected.");
                break;
            case BUMP_EVENT_NO_MATCH:
                NSLog(@"No match.");
                break;
        }
    }];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self configureBump];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self populateRecentTransactionsTable];
}

-(void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if([[defaults objectForKey:@"id"] isEqualToString:@""]){
        WelcomeViewController *welcome = [[WelcomeViewController alloc] init];
        [self presentViewController:welcome animated:YES completion:nil];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

# pragma mark TableView Delegate/Datasource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[AppModel sharedAppModel].currentTransactions count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell == nil) cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell"];
    
    if(((Transaction *)[[AppModel sharedAppModel].currentTransactions objectAtIndex:indexPath.row]).isLoaner) {
        cell.textLabel.text = [NSString stringWithFormat:@"%@ owes you", ((Transaction *)[[AppModel sharedAppModel].currentTransactions objectAtIndex:indexPath.row]).otherParty];
        cell.detailTextLabel.textColor = [UIColor greenColor];
    }
    else {
        cell.textLabel.text = [NSString stringWithFormat:@"You owe %@", ((Transaction *)[[AppModel sharedAppModel].currentTransactions objectAtIndex:indexPath.row]).otherParty];
        cell.detailTextLabel.textColor = [UIColor redColor];
    }
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"$%.2f", ((Transaction *)[[AppModel sharedAppModel].currentTransactions objectAtIndex:indexPath.row]).amount];
    
    return cell;
}

- (void) populateRecentTransactionsTable {
    
    activityIndicator.hidden = NO;
    [activityIndicator startAnimating];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://uselessinter.net/money/api/getRecentTransactions?id=%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"id"]]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        [self parseRecentTransactions:JSON];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id result){
        NSLog(@"ERROR: %@", [error localizedDescription]);
    }];
    
    [operation start];
}

- (void) parseRecentTransactions: (id) JSON {
    totalAmount = 0;
    [[AppModel sharedAppModel].currentTransactions removeAllObjects];
    NSArray *transactions = [[NSArray alloc] init];
    transactions = [JSON valueForKeyPath:@"transactions"];
    for(int i = 0; i < [transactions count]; ++i){
        Transaction *transaction = [[Transaction alloc] init];
        transaction.transactionId = [[[transactions objectAtIndex:i] valueForKeyPath:@"id"] intValue];
        transaction.isLoaner = [@"You" isEqualToString:[[transactions objectAtIndex:i] valueForKeyPath:@"creditor"]];
        transaction.hasBeenPayed = NO; //BASED ON query ran
        transaction.otherParty = transaction.isLoaner ? [[transactions objectAtIndex:i] valueForKeyPath:@"debtor"] : [[transactions objectAtIndex:i] valueForKeyPath:@"creditor"];
        transaction.amount = [[[transactions objectAtIndex:i] valueForKeyPath:@"amount"] floatValue];
        transaction.currency = [[transactions objectAtIndex:i] valueForKeyPath:@"currency"];
        [[AppModel sharedAppModel].currentTransactions addObject:transaction];
        
        if(transaction.isLoaner) totalAmount += transaction.amount;
        else totalAmount -= transaction.amount;
    }
    if(totalAmount < 0) lbl_debtValue.text = [NSString stringWithFormat:@"-$%.2f", 0-totalAmount];
    else lbl_debtValue.text = [NSString stringWithFormat:@"$%.2f", totalAmount];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    lbl_userName.text = [NSString stringWithFormat:@"%@ %@", [defaults objectForKey:@"first_name"], [defaults objectForKey:@"last_name"]];
    [debtsTableView reloadData];
    [activityIndicator stopAnimating];
}

- (void)viewDidUnload {
    debtsTableView = nil;
    payNowButton = nil;
    lbl_nameLabel = nil;
    lbl_userName = nil;
    lbl_debtLabel = nil;
    lbl_debtValue = nil;
    addButton = nil;
    activityIndicator = nil;
    [super viewDidUnload];
}
@end
