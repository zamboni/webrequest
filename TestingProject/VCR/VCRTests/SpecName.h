//
//  SpecName.h
//  VCR
//
//  Created by Fletcher Fowler on 11/8/12.
//  Copyright (c) 2012 Zamboni Dev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SpecName : NSObject
{
    NSString *specName;
}
@property (nonatomic, retain) NSString *specName;

+ (SpecName *)sharedInstance;

@end
