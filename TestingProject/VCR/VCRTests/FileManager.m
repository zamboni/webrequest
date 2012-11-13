//
//  FileManager.m
//  VCR
//
//  Created by Fletcher Fowler on 11/13/12.
//  Copyright (c) 2012 Zamboni Dev. All rights reserved.
//

#import "FileManager.h"
#import "SpecName.h"

@implementation FileManager

+ (NSDictionary *)cassetteForRequest:(NSURLRequest *)request;
{
    if(![[NSFileManager defaultManager] fileExistsAtPath:[self urlFilePath]])
    {
        return NULL;
    }
    else
    {
        NSData *fileContents = [NSData dataWithContentsOfFile:[self urlFilePath]];
        NSDictionary *cassetteDictionary = [NSJSONSerialization JSONObjectWithData:fileContents options:0 error:nil];
        return [cassetteDictionary objectForKey:[self.class getKey:request]];
    }
}

+ (BOOL)writeToFileWithResponse:(NSURLResponse *)response andRequest:(NSURLRequest *)request andData:(NSData *)data
{
    NSInteger status            = [response isKindOfClass:[NSHTTPURLResponse class]] ? [(NSHTTPURLResponse *)response statusCode] : 200;
    NSString *statusString      = [NSString stringWithFormat: @"%d", status];
    NSString *key               = [NSString stringWithFormat: @"%@:%@", [request URL], [request HTTPBody]];
    NSString *responseString    = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    //    [self->data writeToFile:[self.class urlFilePath] atomically:TRUE];
    NSData *urlData = [NSData dataWithContentsOfFile:[FileManager urlFilePath]];
    
    NSDictionary *cassetteDictionary;
    
    if(urlData == nil)
    {
        cassetteDictionary = @{ key : @{@"code" : statusString, @"data" : responseString }};
    }
    else
    {
        NSMutableDictionary *cassetteDictionary = [NSJSONSerialization JSONObjectWithData:urlData options:0 error:nil];
        [cassetteDictionary setObject:@{@"code" : statusString, @"data" : responseString } forKey:key];
    }
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:(NSDictionary *)cassetteDictionary options:kNilOptions error:nil];
    return [jsonData writeToFile:[FileManager urlFilePath] atomically:TRUE];
}

+ (NSString *)getKey:(NSURLRequest *)request
{
    return [NSString stringWithFormat: @"%@?%@", [request URL], [request HTTPBody]];
}

+ (NSURL *)documentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

+ (NSString *)urlFilePath
{
    return [[[self documentsDirectory] path] stringByAppendingPathComponent:[[SpecName sharedInstance] specName]];
}

@end
