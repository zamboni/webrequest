//
//  FileManager.h
//  VCR
//
//  Created by Fletcher Fowler on 11/13/12.
//  Copyright (c) 2012 Zamboni Dev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileManager : NSObject

+ (NSDictionary *)cassetteForRequest:(NSURLRequest *)request;
+ (NSString *)urlFilePath;
+ (BOOL)writeToFileWithResponse:(NSURLResponse *)response andRequest:(NSURLRequest *)request andData:(NSData *)data;

@end
