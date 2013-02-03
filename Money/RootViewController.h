//
//  RootViewController.h
//  Money
//
//  Created by Jacob Hanshaw on 1/24/13.
//  Copyright (c) 2013 Jacob Hanshaw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PaymentViewController.h"
#import "AppModel.h"
#import "Transaction.h"
#import "AFJSONRequestOperation.h"
#import "WelcomeViewController.h"
#import "BumpClient.h"

@interface RootViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    
    IBOutlet UILabel *lbl_nameLabel;
    IBOutlet UILabel *lbl_userName;
    
    IBOutlet UILabel *lbl_debtLabel;
    IBOutlet UILabel *lbl_debtValue;
    
    IBOutlet UITableView *debtsTableView;
    IBOutlet UIButton *addButton;
    IBOutlet UIButton *payNowButton;
   
    IBOutlet UIActivityIndicatorView *activityIndicator;
    
    float totalAmount;
    NSString *bumpResult;
}

@property (nonatomic) NSString *bumpResult;

+ (RootViewController *)sharedRootViewController;

- (IBAction)addButtonPressed:(id)sender;
- (IBAction)payNowButtonPressed:(id)sender;

@end
