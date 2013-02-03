//
//  WelcomeViewController.h
//  Money
//
//  Created by Jacob Hanshaw on 2/2/13.
//  Copyright (c) 2013 Jacob Hanshaw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFJSONRequestOperation.h"

@interface WelcomeViewController : UIViewController<UITableViewDataSource, UITextFieldDelegate, UITextFieldDelegate> {
    
    IBOutlet UILabel *lbl_name;
    IBOutlet UITextField *fNameTextField;
    IBOutlet UITextField *lNameTextField;
    IBOutlet UITextField *emailTextField;
    IBOutlet UIButton *goButton;
    IBOutlet UITableView *createUserTableView;
    IBOutlet UIActivityIndicatorView *activityIndicator;
    
}

- (IBAction)goButtonPressed:(id)sender;

@end
