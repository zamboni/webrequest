//
//  SpecName.m
//  VCR
//
//  Created by Fletcher Fowler on 11/8/12.
//  Copyright (c) 2012 Zamboni Dev. All rights reserved.
//

#import "SpecName.h"

@implementation SpecName

@synthesize specName;
static SpecName *instance = nil;

+ (SpecName *)sharedInstance
{
    @synchronized(self)
    {
        if(instance == nil)
        {
            instance = [SpecName new];
        }
    }
    return instance;    
}

@end
