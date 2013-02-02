//
//  RootViewController.m
//  Money
//
//  Created by Jacob Hanshaw on 1/24/13.
//  Copyright (c) 2013 Jacob Hanshaw. All rights reserved.
//

#import "RootViewController.h"

@implementation RootViewController

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
    
}

- (id)initWithFrame:(CGRect)frame {
    self = [super init];
    if (self) {
        self.view.frame = frame;
    }
    return self;
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
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell == nil) cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    
    cell.textLabel.text = [NSString stringWithFormat:@"Row: %d", indexPath.row];
    
    return cell;
}

- (void)viewDidUnload {
    debtsTableView = nil;
    payNowButton = nil;
    lbl_nameLabel = nil;
    lbl_userName = nil;
    lbl_debtLabel = nil;
    lbl_debtValue = nil;
    addButton = nil;
    [super viewDidUnload];
}
@end
