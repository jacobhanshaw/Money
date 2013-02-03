//
//  WelcomeViewController.m
//  Money
//
//  Created by Jacob Hanshaw on 2/2/13.
//  Copyright (c) 2013 Jacob Hanshaw. All rights reserved.
//

#import "WelcomeViewController.h"

BOOL processingLogin;

@interface WelcomeViewController ()

@end

@implementation WelcomeViewController

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
    processingLogin = NO;
 //   activityIndicator = [[UIActivityIndicatorView alloc] init];
    returnPressed = NO;
  //  activityIndicator.hidden = YES;
}

#pragma mark TableView Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)table cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [table dequeueReusableCellWithIdentifier:@"Cell"];
    if( cell == nil)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    
    
    if (indexPath.row == 0) {
        fNameTextField = [[UITextField alloc] initWithFrame:CGRectMake(5, 0, 280, 21)];
        fNameTextField.delegate = self;
        fNameTextField.placeholder = @"First Name";
        fNameTextField.autocorrectionType = UITextAutocorrectionTypeNo;
        [fNameTextField setClearButtonMode:UITextFieldViewModeWhileEditing];
        cell.accessoryView = fNameTextField;
        [table addSubview:fNameTextField];
    }
    else if (indexPath.row == 1) {
        lNameTextField = [[UITextField alloc] initWithFrame:CGRectMake(5, 0, 280, 21)];
        lNameTextField.delegate = self;
        lNameTextField.placeholder = @"Last Name";
        lNameTextField.autocorrectionType = UITextAutocorrectionTypeNo;
        [lNameTextField setClearButtonMode:UITextFieldViewModeWhileEditing];
        cell.accessoryView = lNameTextField;
        [table addSubview:lNameTextField];
    }
    else if (indexPath.row == 2) {
        emailTextField = [[UITextField alloc] initWithFrame:CGRectMake(5, 0, 280, 21)];
        emailTextField.delegate = self;
        emailTextField.placeholder = @"Paypal Email Address";
        emailTextField.autocorrectionType = UITextAutocorrectionTypeNo;
        [emailTextField setClearButtonMode:UITextFieldViewModeWhileEditing];
        cell.accessoryView = emailTextField;
        [table addSubview:emailTextField];
    }
    else NSLog(@"OH NOEZ: THE ERRORZ");
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

#pragma mark TextField Methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    if(textField == [alertWithTextView textFieldAtIndex:0]){
        [self submitConfirmationPasswordForApproval:[alertWithTextView textFieldAtIndex:0].text];
        returnPressed = YES;
        [alertWithTextView dismissWithClickedButtonIndex:alertWithTextView.cancelButtonIndex animated:YES];
    }
    
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    [self performSelector:@selector(updateLabel) withObject:nil afterDelay:0.1];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    [self performSelector:@selector(updateLabel) withObject:nil afterDelay:0.1];
    return YES;
}

- (void) updateLabel {
    NSString *firstName = fNameTextField.text == nil ? @"" : fNameTextField.text;
    NSString *lastName = lNameTextField.text == nil ? @"" : lNameTextField.text;
    if(lastName != nil && ![lastName isEqualToString:@""] && firstName != nil && ![firstName isEqualToString:@""]) lbl_name.text = [NSString stringWithFormat:@"%@ %@!", firstName, lastName];
    else if(firstName != nil && ![firstName isEqualToString:@""]) lbl_name.text = [NSString stringWithFormat:@"%@!", firstName];
    else if(lastName != nil && ![lastName isEqualToString:@""]) lbl_name.text = [NSString stringWithFormat:@"%@!", lastName];
    else lbl_name.text = @"";
}

//Makes keyboard disappear on touch outside of keyboard or textfield
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [emailTextField resignFirstResponder];
    [fNameTextField resignFirstResponder];
    [lNameTextField resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    lbl_name = nil;
    fNameTextField = nil;
    lNameTextField = nil;
    emailTextField = nil;
    goButton = nil;
    createUserTableView = nil;
    activityIndicator = nil;
    [super viewDidUnload];
}

- (IBAction)goButtonPressed:(id)sender {
    activityIndicator.hidden = NO;
    [activityIndicator startAnimating];
    goButton.hidden = YES;
    
    if(fNameTextField.text == nil || [fNameTextField.text isEqualToString:@""]){
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Error" message:@"Please Enter a First Name" delegate:self
                              cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    else if(lNameTextField.text == nil || [lNameTextField.text isEqualToString:@""]){
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Error" message:@"Please Enter a Last Name" delegate:self
                              cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    else if(![self NSStringIsValidEmail:emailTextField.text]){
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Error" message:@"Please Enter a Valid Email Address" delegate:self
                              cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    else {
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://uselessinter.net/money/api/newUser?f=%@&l=%@&e=%@",fNameTextField.text,lNameTextField.text, [emailTextField.text lowercaseString]]];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        
        AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            
            [activityIndicator stopAnimating];
            goButton.hidden = NO;
            
            int id_num = [[JSON valueForKeyPath:@"id_num"] intValue];
            
            NSLog(@"ID: %d", id_num);
            
            if(id_num == -1){
                UIAlertView *alert = [[UIAlertView alloc]
                                      initWithTitle:@"Email in Use" message:@"Email Address is Already in Use" delegate:self
                                      cancelButtonTitle:@"Cancel" otherButtonTitles:@"Claim Account", nil];
                [alert show];
            }
            else if(id_num < 0) {
                UIAlertView *alert = [[UIAlertView alloc]
                                      initWithTitle:@"Error" message:@"Error Creating User Profile. Please Try Again" delegate:self
                                      cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
            }
            else {
            [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d", id_num] forKey:@"id"];
            [[NSUserDefaults standardUserDefaults] setObject:fNameTextField.text forKey:@"first_name"];
            [[NSUserDefaults standardUserDefaults] setObject:lNameTextField.text forKey:@"last_name"];
            [[NSUserDefaults standardUserDefaults] setObject:emailTextField.text forKey:@"email"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [self dismissViewControllerAnimated:YES completion:nil];
            }
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id result){
            NSLog(@"ERROR: %@", [error localizedDescription]);
        }];
        
        [operation start];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	NSString *title = [alertView title];
    
    if([title isEqualToString:@"Email in Use"]) {
        if (buttonIndex == 1) {
            //CLAIM EMAIL ADDRESS
            [self performSelector:@selector(promptForEmailAuthentication) withObject:nil afterDelay:0.1];
        }
    }
    else if([title isEqualToString:@"Email Confirmation"]) {
        if(!returnPressed)[self submitConfirmationPasswordForApproval:[alertWithTextView textFieldAtIndex:0].text];
    }
}

- (void)promptForEmailAuthentication {
    alertWithTextView = [[UIAlertView alloc]
                          initWithTitle:@"Email Confirmation" message:@"Please Enter Your Confirmation Number" delegate:self
                          cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    [alertWithTextView setAlertViewStyle:UIAlertViewStylePlainTextInput];
    [[alertWithTextView textFieldAtIndex:0] setDelegate:self];
    [[alertWithTextView textFieldAtIndex:0] setKeyboardType:UIKeyboardTypeNumberPad];
    [alertWithTextView show];
}

- (void)submitConfirmationPasswordForApproval:(NSString *)confirmation{
    activityIndicator.hidden = NO;
    [activityIndicator startAnimating];
    goButton.hidden = YES;
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://uselessinter.net/money/api/confirmUser?c=%@&e=%@&f=%@&l=%@",confirmation,emailTextField.text, fNameTextField.text, lNameTextField.text]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        [activityIndicator stopAnimating];
        goButton.hidden = NO;
        
        int id_num = [[JSON valueForKeyPath:@"id_num"] intValue];
        
        NSLog(@"ID: %d", id_num);
        
        if(id_num == -1){
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:@"Invalid Confirmation Code" message:@"Code Entered Was Not Correct" delegate:self
                                  cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
        else {
            [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d", id_num] forKey:@"id"];
            [[NSUserDefaults standardUserDefaults] setObject:fNameTextField.text forKey:@"first_name"];
            [[NSUserDefaults standardUserDefaults] setObject:lNameTextField.text forKey:@"last_name"];
            [[NSUserDefaults standardUserDefaults] setObject:emailTextField.text forKey:@"email"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id result){
        NSLog(@"ERROR: %@", [error localizedDescription]);
    }];
    
    [operation start];
}


-(BOOL) NSStringIsValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = YES; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSString *laxString = @".+@.+\\.[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

@end
