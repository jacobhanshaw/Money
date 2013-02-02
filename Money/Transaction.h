//
//  Transaction.h
//  Money
//
//  Created by Jacob Hanshaw on 2/2/13.
//  Copyright (c) 2013 Jacob Hanshaw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Transaction : NSObject {
    int transactionId;
    BOOL isLoaner;
    BOOL hasBeenPayed;
    NSString *otherParty;
    float amount;
    NSString *currency;
}

@property (readwrite) int transactionId;
@property (readwrite) BOOL isLoaner;
@property (readwrite) BOOL hasBeenPayed;
@property (nonatomic) NSString *otherParty;
@property (readwrite) float amount;
@property (nonatomic) NSString *currency;

@end
