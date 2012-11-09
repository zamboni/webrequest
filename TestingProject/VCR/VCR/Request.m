//
//  Request.m
//  VCR
//
//  Created by Fletcher Fowler on 11/2/12.
//  Copyright (c) 2012 Zamboni Dev. All rights reserved.
//

#import "Request.h"

@implementation Request

@synthesize response;

- (void)callRequest
{
    webRequest = [SMWebRequest requestWithURL:[NSURL URLWithString:@"http://google.com"]];
    [webRequest addTarget:self action:@selector(printResponse:) forRequestEvents:SMWebRequestEventComplete];
    [webRequest start];
}

- (void)printResponse:(NSData *)data
{
    response = data;
}

@end
