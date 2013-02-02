//
//  WelcomeViewController.h
//  Money
//
//  Created by Jacob Hanshaw on 2/2/13.
//  Copyright (c) 2013 Jacob Hanshaw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WelcomeViewController : UIViewController<UITextFieldDelegate> {
    
    IBOutlet UILabel *lbl_name;
    IBOutlet UITextField *fNameTextField;
    IBOutlet UITextField *lNameTextField;
    IBOutlet UITextField *emailTextField;
    IBOutlet UIButton *goButton;
    
}

@end
