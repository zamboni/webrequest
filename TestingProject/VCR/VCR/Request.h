//
//  Request.h
//  VCR
//
//  Created by Fletcher Fowler on 11/2/12.
//  Copyright (c) 2012 Zamboni Dev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SMWebRequest.h"

@interface Request : NSObject
{
    SMWebRequest *webRequest;
    NSData *response;
}

@property (nonatomic, retain) NSData *response;

- (void)callRequest;
- (void)printResponse:(NSData *)data;

@end
