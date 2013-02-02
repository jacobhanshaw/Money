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
    else return [NSString stringWithFormat:@".%d", row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
}


@end
