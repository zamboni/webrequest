//
//  FileManager.m
//  VCR
//
//  Created by Fletcher Fowler on 11/13/12.
//  Copyright (c) 2012 Zamboni Dev. All rights reserved.
//

#import "FileManager.h"
#import "SpecHelper.h"

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
        NSString *key = [self.class getKey:request];
        return [cassetteDictionary objectForKey:[self.class getKey:request]];
    }
}

+ (BOOL)writeToFileWithResponse:(NSURLResponse *)response andRequest:(NSURLRequest *)request andData:(NSData *)data
{
    NSInteger status            = [response isKindOfClass:[NSHTTPURLResponse class]] ? [(NSHTTPURLResponse *)response statusCode] : 200;
    NSString *statusString      = [NSString stringWithFormat: @"%d", status];
    NSString *key               = [self.class getKey:request];
    NSString *responseString    = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    //    [self->data writeToFile:[self.class urlFilePath] atomically:TRUE];
    NSData *urlData = [NSData dataWithContentsOfFile:[FileManager urlFilePath]];
    
    NSMutableDictionary *cassetteDictionary = [[NSMutableDictionary alloc] init];
    
    if(urlData == nil)
    {
        cassetteDictionary = [@{ key : @{@"code" : statusString, @"data" : responseString }} mutableCopy];
    }
    else
    {
        cassetteDictionary = [NSJSONSerialization JSONObjectWithData:urlData options:NSJSONReadingMutableContainers error:nil];
        [cassetteDictionary setObject:@{@"code" : statusString, @"data" : responseString } forKey:key];
    }
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:cassetteDictionary options:kNilOptions error:nil];
    [self checkCassettesDirectory];
    return [jsonData writeToFile:[self urlFilePath] atomically:TRUE];
}

+ (void)checkCassettesDirectory
{
    BOOL dirExists = [[NSFileManager defaultManager] fileExistsAtPath:[self cassettesDirectory]];
    if(!dirExists){
        [[NSFileManager defaultManager] createDirectoryAtPath:[self cassettesDirectory] withIntermediateDirectories:NO attributes:nil error:nil];
    }
}

+ (NSString *)getKey:(NSURLRequest *)request
{
//    TODO: Fix this to paramerterize HTTPBody
//    NSString *body = [[NSString alloc] initWithData:[request HTTPBody] encoding:NSUTF8StringEncoding];
    return [NSString stringWithFormat: @"%@?%@", [request URL], [request HTTPBody]];
}

+ (NSURL *)documentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

+ (NSString *)cassettesDirectory
{
    return [[[self documentsDirectory] path] stringByAppendingPathComponent:@"/Cassettes"];
}

+ (NSString *)urlFilePath
{
    return [[self cassettesDirectory] stringByAppendingPathComponent:[[SpecHelper sharedInstance] SpecHelper]];
}

+ (NSString *)printData:(NSData *)data
{
    NSLog(@"Print data: %@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
}
@end
