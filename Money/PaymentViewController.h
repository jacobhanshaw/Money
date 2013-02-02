//
//  PaymentViewController.h
//  Money
//
//  Created by Jacob Hanshaw on 1/24/13.
//  Copyright (c) 2013 Jacob Hanshaw. All rights reserved.
//

#import "AppDelegate.h"
#import "PayPal.h"
#import "PayPalPayment.h"
#import "PayPalInvoiceItem.h"

typedef enum PaymentStatuses {
	PAYMENTSTATUS_SUCCESS,
	PAYMENTSTATUS_FAILED,
	PAYMENTSTATUS_CANCELED,
} PaymentStatus;

@interface PaymentViewController : UIViewController  <UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate, PayPalPaymentDelegate> {
    
    IBOutlet UILabel *lbl_nameLabel;
    IBOutlet UILabel *lbl_emailPhoneLabel;

    IBOutlet UITextField *recipientNameTextField;
    IBOutlet UITextField *recipientEmailPhoneTextField;
    
    IBOutlet UIPickerView *dollarPicker;
    IBOutlet UIPickerView *centPicker;
    
    
    IBOutlet UIButton *saveButton;
    IBOutlet UIButton *backButton;
    IBOutlet UIButton *payNowButton;
    
    PaymentStatus status;
}

- (IBAction)saveButtonPressed:(id)sender;
- (IBAction)backButtonPressed:(id)sender;
- (IBAction)payNowButtonPressed:(id)sender;



@end
