//
//  PaymentViewController.h
//  Money
//
//  Created by Jacob Hanshaw on 1/24/13.
//  Copyright (c) 2013 Jacob Hanshaw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PaymentViewController : UIViewController  <UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate> {
    
    IBOutlet UILabel *lbl_nameLabel;
    IBOutlet UILabel *lbl_emailPhoneLabel;

    IBOutlet UITextField *recipientNameTextField;
    IBOutlet UITextField *recipientEmailPhoneTextField;
    
    IBOutlet UIPickerView *dollarPicker;
    IBOutlet UIPickerView *centPicker;
    
    
    IBOutlet UIButton *saveButton;
    IBOutlet UIButton *payNowButton;
    
}

- (IBAction)saveButtonPressed:(id)sender;
- (IBAction)payNowButtonPressed:(id)sender;


@end
