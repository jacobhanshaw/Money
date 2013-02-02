//
//  PaymentViewController.m
//  Money
//
//  Created by Jacob Hanshaw on 1/24/13.
//  Copyright (c) 2013 Jacob Hanshaw. All rights reserved.
//

#import "PaymentViewController.h"

@interface PaymentViewController ()

@end

@implementation PaymentViewController

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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bumpReceived:) name:@"bumpReceived" object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    lbl_nameLabel = nil;
    lbl_emailPhoneLabel = nil;
    recipientNameTextField = nil;
    recipientEmailPhoneTextField = nil;
    dollarPicker = nil;
    centPicker = nil;
    payNowButton = nil;
    saveButton = nil;
    [super viewDidUnload];
}

- (IBAction)saveButtonPressed:(id)sender {

}

- (IBAction)payNowButtonPressed:(id)sender {

}

- (void)bumpReceived {
    NSLog(@"I GOT ALL THE DATA: %@", ((AppDelegate *)[[UIApplication sharedApplication] delegate]).bumpStringReceived);
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
- (void)paymentSuccessWithKey:
(NSString *)payKey andStatus:
(PayPalPaymentStatus)paymentStatus {
    status = PAYMENTSTATUS_SUCCESS;
}

//paymentFailedWithCorrelationID:andErrorCode:andErrorMessage:
// Record the payment as failed and perform associated bookkeeping.
// Make no UI updates.
//
//correlationID is a string that uniquely identifies to PayPal the failed transaction.
//errorCode is generally (but not always) a numerical code associated with the error.
//errorMessage is a human-readable string describing the error that occurred.
- (void)paymentFailedWithCorrelationID:
(NSString *)correlationID andErrorCode:
(NSString *)errorCode andErrorMessage:
(NSString *)errorMessage {
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
	payment.recipient = @"example-merchant-1@paypal.com";
	payment.paymentCurrency = @"USD";
	payment.description = @"Teddy Bear";
	payment.merchantName = @"Joe's Bear Emporium";
	
	//subtotal of all items, without tax and shipping
	payment.subTotal = [NSDecimalNumber decimalNumberWithString:@"10"];
	
	//invoiceData is a PayPalInvoiceData object which contains tax, shipping, and a list of PayPalInvoiceItem objects
	payment.invoiceData = [[PayPalInvoiceData alloc] init];
	payment.invoiceData.totalShipping = [NSDecimalNumber decimalNumberWithString:@"2"];
	payment.invoiceData.totalTax = [NSDecimalNumber decimalNumberWithString:@"0.35"];
	
	//invoiceItems is a list of PayPalInvoiceItem objects
	//NOTE: sum of totalPrice for all items must equal payment.subTotal
	//NOTE: example only shows a single item, but you can have more than one
	payment.invoiceData.invoiceItems = [NSMutableArray array];
	PayPalInvoiceItem *item = [[PayPalInvoiceItem alloc] init];
	item.totalPrice = payment.subTotal;
	item.name = @"Teddy";
	[payment.invoiceData.invoiceItems addObject:item];
    
    [[PayPal getPayPalInst] checkoutWithPayment:payment];
}

#pragma mark TextField Methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [recipientNameTextField resignFirstResponder];
    [recipientEmailPhoneTextField resignFirstResponder];
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
    
}


@end
