//
//  AppModel.h
//  Money
//
//  Created by Jacob Hanshaw on 1/24/13.
//  Copyright (c) 2013 Jacob Hanshaw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppModel : NSObject {
    NSMutableArray *currentTransactions;
}

@property (nonatomic) NSMutableArray *currentTransactions;

+ (AppModel *)sharedAppModel;

@end
