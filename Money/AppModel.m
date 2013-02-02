//
//  AppModel.m
//  Money
//
//  Created by Jacob Hanshaw on 1/24/13.
//  Copyright (c) 2013 Jacob Hanshaw. All rights reserved.
//

#import "AppModel.h"

@implementation AppModel

+ (id)sharedAppModel
{
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init]; // or some other init method
    });
    return _sharedObject;
}

#pragma mark Init/dealloc
-(id)init {
    self = [super init];
    if (self) {
		//Init UserDefaults
		//NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        //NSNotificationCenter *dispatcher = [NSNotificationCenter defaultCenter];

	}
    return self;
}

- (void)dealloc {
   // [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
