//
//  main.m
//  VCR
//
//  Created by Fletcher Fowler on 11/2/12.
//  Copyright (c) 2012 Zamboni Dev. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AppDelegate.h"

int main(int argc, char *argv[])
{
    @autoreleasepool {
        @try {
            return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
        } @catch (NSException *e) {
            NSLog(@"Exception was caught: %@\n%@", e, [e callStackSymbols]);
        }
    }
}
