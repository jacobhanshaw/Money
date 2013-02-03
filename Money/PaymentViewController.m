//
//  PaymentViewController.m
//  Money
//
//  Created by Jacob Hanshaw on 1/24/13.
//  Copyright (c) 2013 Jacob Hanshaw. All rights reserved.
//

#import "PaymentViewController.h"

@implementation PaymentViewController

@synthesize bumpEmail;

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
    
    UIButton *button = [[PayPal getPayPalInst]
                        getPayButtonWithTarget:self
                        andAction:@selector(payWithPayPal)
                        andButtonType:BUTTON_278x43
                        andButtonText:BUTTON_TEXT_PAY];
    
    CGRect frame = button.frame;
	frame.origin.x = round((self.view.frame.size.width - button.frame.size.width) / 2.);
	frame.origin.y = round([[UIScreen mainScreen] bounds].size.height - frame.size.height - 20);
    
    button.frame = frame;
    
    [self.view addSubview:button];
    
    isPositive = YES;
    payNowButton.hidden = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bumpReceived) name:@"bumpReceived" object:nil];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    bumpEmail = @"";
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
   // [self configureBump];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    lbl_descriptionLabel = nil;
    lbl_emailPhoneLabel = nil;
    descriptionTextField = nil;
    recipientEmailPhoneTextField = nil;
    dollarPicker = nil;
    centPicker = nil;
    saveButton = nil;
    backButton = nil;
    payNowButton = nil;
    lbl_whoOwesWho = nil;
    posNegButton = nil;
    activityIndicator = nil;
    [super viewDidUnload];
}

- (IBAction)saveButtonPressed:(id)sender {
    float total;
	float dollars = [dollarPicker selectedRowInComponent:0];
    float change = [centPicker selectedRowInComponent:0];
    total = dollars + change/100;
    
    if([recipientEmailPhoneTextField.text isEqualToString:@""] || recipientEmailPhoneTextField.text == nil || !([self NSStringIsValidEmail:recipientEmailPhoneTextField.text] || [self NSStringIsValidPhoneNumber:recipientEmailPhoneTextField.text])){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Payment Failed"
                                                        message:@"A Payment Cannot Be Made Without a Valid Phone or Email Address"
                                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    else [self addPaymentTo:recipientEmailPhoneTextField.text for:total thatIsPayed:NO];
}

- (IBAction)backButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)payNowButtonPressed:(id)sender {
    //NOT USED
}

- (IBAction)posNegButtonPressed:(id)sender {
    isPositive = !isPositive;
    [self updateButtonAndLabel];
}

- (void)updateButtonAndLabel {
    float total;
	float dollars = [dollarPicker selectedRowInComponent:0];
    float change = [centPicker selectedRowInComponent:0];
    total = dollars + change/100;
    
    if(isPositive){
        [posNegButton setTitle:@"+" forState:UIControlStateNormal];
        [posNegButton setTitle:@"+" forState:UIControlStateHighlighted];
   //     if(!([descriptionTextField.text isEqualToString:@""] || descriptionTextField..text == nil)) lbl_whoOwesWho.text = [NSString stringWithFormat:@"%@ owes you: $%.2f", lbl_descriptionLabel.text, total];
        lbl_whoOwesWho.text = [NSString stringWithFormat:@"This person owes you: $%.2f", total];
    }
    else{
        [posNegButton setTitle:@"-" forState:UIControlStateNormal];
        [posNegButton setTitle:@"-" forState:UIControlStateHighlighted];
       // if(!([descriptionTextField..text isEqualToString:@""] || descriptionTextField..text == nil)) lbl_whoOwesWho.text = [NSString stringWithFormat:@"You owe %@: $%.2f", lbl_descriptionLabel.text, total];
        lbl_whoOwesWho.text = [NSString stringWithFormat:@"You owe this person: $%.2f", total];
    }
}

- (void)bumpReceived {
    //NSLog(@"I GOT ALL THE DATA: %@", [RootViewController sharedRootViewController].bumpResult);
    bumpEmail = [RootViewController sharedRootViewController].bumpResult;
    recipientEmailPhoneTextField.text = bumpEmail;
    //[self payWithPayPal];
}

//ADD CURRENCY
- (void)addPaymentTo:(NSString *)recipient for:(float)amount thatIsPayed:(BOOL)payed {
    
    if (amount <= 0){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"You Cannot Save or Add a Transaction for Zero Dollars"
                                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    else {
        
        activityIndicator.hidden = NO;
        [activityIndicator startAnimating];
        
        NSString *amountString;
        if(isPositive) amountString = [NSString stringWithFormat:@"%.2f", amount];
        else amountString = [NSString stringWithFormat:@"neg%.2f", amount];
        
        int payedNumber = payed ? 2 : 0;
        
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://uselessinter.net/money/api/add?e=%@&a=%@&d=%@&p=%d&me=%@",[recipientEmailPhoneTextField.text lowercaseString],amountString, descriptionTextField.text,payedNumber, [[NSUserDefaults standardUserDefaults] objectForKey:@"id"]]];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        
        AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            
            //ADD PERSON TO LIST
            
            [activityIndicator stopAnimating];
            
            int id_num = [[JSON valueForKeyPath:@"success"] intValue];
            
            NSLog(@"ID: %d", id_num);
            
            UIAlertView *alert = [[UIAlertView alloc]
                                      initWithTitle:@"Congratulations" message:@"Transaction Added" delegate:self
                                      cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
                
            [self dismissViewControllerAnimated:YES completion:nil];
            
            
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id result){
            [activityIndicator stopAnimating];
            NSLog(@"ERROR: %@", [error localizedDescription]);
        }];
        
        [operation start];
    }
    
    //NEED ID BACK IF AVAILABLE
}

#pragma mark -
#pragma mark PayPalPaymentDelegate methods

-(void)RetryInitialization
{
    [PayPal initializeWithAppID:@"APP-80W284485P519543T" forEnvironment:ENV_SANDBOX];
    
    //DEVPACKAGE
    //	[PayPal initializeWithAppID:@"your live app id" forEnvironment:ENV_LIVE];
    //	[PayPal initializeWithAppID:@"anything" forEnvironment:ENV_NONE];
}

//PayPalPaymentDelegate methods:

//paymentSuccessWithKey:andStatus: is required. Record the payment status
// as successful and perform associated bookkeeping. Make no UI updates.
//
//payKey is a string that uniquely identifies the transaction.
//paymentStatus is an enum: STATUS_COMPLETED, STATUS_CREATED, or STATUS_OTHER
- (void)paymentSuccessWithKey:(NSString *)payKey andStatus:(PayPalPaymentStatus)paymentStatus {
    status = PAYMENTSTATUS_SUCCESS;
}

//paymentFailedWithCorrelationID:andErrorCode:andErrorMessage:
// Record the payment as failed and perform associated bookkeeping.
// Make no UI updates.
//
//correlationID is a string that uniquely identifies to PayPal the failed transaction.
//errorCode is generally (but not always) a numerical code associated with the error.
//errorMessage is a human-readable string describing the error that occurred.
- (void)paymentFailedWithCorrelationID:(NSString *)correlationID andErrorCode:(NSString *)errorCode andErrorMessage:(NSString *)errorMessage {
    status = PAYMENTSTATUS_FAILED;
}

//paymentFailedWithCorrelationID is a required method. in it, you should
//record that the payment failed and perform any desired bookkeeping. you should not do any user interface updates.
//correlationID is a string which uniquely identifies the failed transaction, should you need to contact PayPal.
//errorCode is generally (but not always) a numerical code associated with the error.
//errorMessage is a human-readable string describing the error that occurred.
- (void)paymentFailedWithCorrelationID:(NSString *)correlationID {
    
    NSString *severity = [[PayPal getPayPalInst].responseMessage objectForKey:@"severity"];
	NSLog(@"severity: %@", severity);
	NSString *category = [[PayPal getPayPalInst].responseMessage objectForKey:@"category"];
	NSLog(@"category: %@", category);
	NSString *errorId = [[PayPal getPayPalInst].responseMessage objectForKey:@"errorId"];
	NSLog(@"errorId: %@", errorId);
	NSString *message = [[PayPal getPayPalInst].responseMessage objectForKey:@"message"];
	NSLog(@"message: %@", message);
    
	status = PAYMENTSTATUS_FAILED;
}

//paymentCanceled is a required method. in it, you should record that the payment was canceled by
//the user and perform any desired bookkeeping. you should not do any user interface updates.
- (void)paymentCanceled {
	status = PAYMENTSTATUS_CANCELED;
}

//paymentLibraryExit is a required method. this is called when the library is finished with the display
//and is returning control back to your app. you should now do any user interface updates such as
//displaying a success/failure/canceled message.
- (void)paymentLibraryExit {
	UIAlertView *alert = nil;
	switch (status) {
		case PAYMENTSTATUS_SUCCESS:
	//		[self.navigationController pushViewController:[[[SuccessViewController alloc] init] autorelease] animated:TRUE];
            [self addPaymentTo:payPayRecipient for:payPalAmount thatIsPayed:YES];
			break;
		case PAYMENTSTATUS_FAILED:
			alert = [[UIAlertView alloc] initWithTitle:@"Order failed"
											   message:@"Your order failed. Touch \"Pay with PayPal\" to try again."
											  delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
			break;
		case PAYMENTSTATUS_CANCELED:
			alert = [[UIAlertView alloc] initWithTitle:@"Order canceled"
											   message:@"You canceled your order. Touch \"Pay with PayPal\" to try again."
											  delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
			break;
	}
	[alert show];
}

- (void)payWithPayPal {
    
    
    float total;
	float dollars = [dollarPicker selectedRowInComponent:0];
    float change = [centPicker selectedRowInComponent:0];
    total = dollars + change/100;
    
    if(![self NSStringIsValidEmail:recipientEmailPhoneTextField.text] && ![self NSStringIsValidPhoneNumber:recipientEmailPhoneTextField.text]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"Not a Valid Email or Phone Number"
                                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    else if(total <= 0){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"You Cannot Save or Add a Transaction for Zero Dollars"
                                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    else if(!isPositive){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Payment Failed"
                                                        message:@"Nice Try. You Cannot Pay People Negative Amounts"
                                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    else {
    //dismiss any native keyboards
    //	[preapprovalField resignFirstResponder];
	
	//optional, set shippingEnabled to TRUE if you want to display shipping
	//options to the user, default: TRUE
	[PayPal getPayPalInst].shippingEnabled = NO;
	
	//optional, set dynamicAmountUpdateEnabled to TRUE if you want to compute
	//shipping and tax based on the user's address choice, default: FALSE
	[PayPal getPayPalInst].dynamicAmountUpdateEnabled = NO;
	
	//optional, choose who pays the fee, default: FEEPAYER_EACHRECEIVER
	[PayPal getPayPalInst].feePayer = FEEPAYER_SENDER;
    
	//for a payment with a single recipient, use a PayPalPayment object
	PayPalPayment *payment = [[PayPalPayment alloc] init];
    if(![bumpEmail isEqualToString:@""]) payment.recipient = bumpEmail;
    else{
        if(![self NSStringIsValidEmail:recipientEmailPhoneTextField.text] && ![self NSStringIsValidPhoneNumber:recipientEmailPhoneTextField.text]){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
											   message:@"Not a Valid Email or Phone Number"
											  delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
        else{
            payment.recipient = recipientEmailPhoneTextField.text;
        }
    }
	payment.paymentCurrency = @"USD";
	payment.description = @"Spot™ Friend Pay Back";
    payment.merchantName = payment.recipient;
    
    //ADD IN PAY PAYPAL FEE CALCULATION
    
    NSString *totalString = [NSString stringWithFormat:@"%.2f", total];
    
    NSDecimalNumber *totalPrice = [NSDecimalNumber decimalNumberWithString:totalString];
    
    payment.subTotal = totalPrice;
    
	//invoiceItems is a list of PayPalInvoiceItem objects
	//NOTE: sum of totalPrice for all items must equal payment.subTotal
	//NOTE: example only shows a single item, but you can have more than one
	payment.invoiceData.invoiceItems = [NSMutableArray array];
	PayPalInvoiceItem *item = [[PayPalInvoiceItem alloc] init];
	item.totalPrice = totalPrice;
	item.name = @"Spot™ Friend Pay Back";
	[payment.invoiceData.invoiceItems addObject:item];
    
    [[PayPal getPayPalInst] checkoutWithPayment:payment];
    
        payPayRecipient = payment.recipient;
        payPalAmount = total;
  //  [self addPaymentTo:payment.recipient for:total thatIsPayed:YES];
    }
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

-(BOOL) NSStringIsValidPhoneNumber:(NSString *)checkString
{
    NSString *phoneRegex = @"[235689][0-9]{6}([0-9]{3})?";
    NSPredicate *test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    return [test evaluateWithObject:checkString];
}

#pragma mark TextField Methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [descriptionTextField resignFirstResponder];
    [recipientEmailPhoneTextField resignFirstResponder];
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    [self performSelector:@selector(updateButtonAndLabel) withObject:nil afterDelay:0.1];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    [self performSelector:@selector(updateButtonAndLabel) withObject:nil afterDelay:0.1];
    if (textField.text.length >= MAXDESCRIPTIONLENGTH && range.length == 0) return NO; // return NO to not change text
    return YES;
}

#pragma mark Picker Methods

//could do 2 components in 1 picker, just different style; might have to calculate width
//- (NSInteger)selectedRowInComponent:(NSInteger)component called through picker

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if(pickerView == dollarPicker) return 2000;
    else return 100;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if(pickerView == dollarPicker) return [NSString stringWithFormat:@"$%d", row];
    else if(row > 9) return [NSString stringWithFormat:@".%d", row];
    else return [NSString stringWithFormat:@".0%d", row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    [self updateButtonAndLabel];
}


@end
