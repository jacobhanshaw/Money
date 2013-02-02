//
//  RootViewController.h
//  Money
//
//  Created by Jacob Hanshaw on 1/24/13.
//  Copyright (c) 2013 Jacob Hanshaw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PaymentViewController.h"

@interface RootViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    
    IBOutlet UILabel *lbl_nameLabel;
    IBOutlet UILabel *lbl_userName;
    
    IBOutlet UILabel *lbl_debtLabel;
    IBOutlet UILabel *lbl_debtValue;
    
    IBOutlet UITableView *debtsTableView;
    IBOutlet UIButton *addButton;
    IBOutlet UIButton *payNowButton;
}

+ (RootViewController *)sharedRootViewController;

- (IBAction)addButtonPressed:(id)sender;
- (IBAction)payNowButtonPressed:(id)sender;

@end
