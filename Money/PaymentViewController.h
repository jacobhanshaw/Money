//
//  PaymentViewController.h
//  Money
//
//  Created by Jacob Hanshaw on 1/24/13.
//  Copyright (c) 2013 Jacob Hanshaw. All rights reserved.
//

#import "RootViewController.h"
#import "PayPal.h"
#import "PayPalPayment.h"
#import "PayPalInvoiceItem.h"

#define MAXDESCRIPTIONLENGTH 32

typedef enum PaymentStatuses {
	PAYMENTSTATUS_SUCCESS,
	PAYMENTSTATUS_FAILED,
	PAYMENTSTATUS_CANCELED,
} PaymentStatus;

@interface PaymentViewController : UIViewController  <UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate, PayPalPaymentDelegate> {
    
    IBOutlet UILabel *lbl_descriptionLabel;
    IBOutlet UILabel *lbl_emailPhoneLabel;
    IBOutlet UILabel *lbl_whoOwesWho;

    IBOutlet UITextField *descriptionTextField;
    IBOutlet UITextField *recipientEmailPhoneTextField;
    
    IBOutlet UIPickerView *dollarPicker;
    IBOutlet UIPickerView *centPicker;
    
    
    IBOutlet UIButton *saveButton;
    IBOutlet UIButton *backButton;
    IBOutlet UIButton *payNowButton;
    IBOutlet UIButton *posNegButton;
    
    IBOutlet UIActivityIndicatorView *activityIndicator;
    
    PaymentStatus status;
    NSString *bumpEmail;
    BOOL isPositive;
    
    NSString *payPayRecipient;
    float payPalAmount;
}

@property (nonatomic) NSString *bumpEmail;

- (IBAction)saveButtonPressed:(id)sender;
- (IBAction)backButtonPressed:(id)sender;
- (IBAction)payNowButtonPressed:(id)sender;
- (IBAction)posNegButtonPressed:(id)sender;



@end
