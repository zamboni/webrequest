//
//  SMWebRequest+VCR.m
//  VCR
//
//  Created by Fletcher Fowler on 11/3/12.
//  Copyright (c) 2012 Zamboni Dev. All rights reserved.
//

#import "SMWebRequest+VCR.h"

@implementation SMWebRequest (VCR)

+(NSString *)documentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSString *)urlFilePath
{
    return [[[self.class documentsDirectory] path] stringByAppendingPathComponent:[[SpecName sharedInstance] specName]];
//    return [docDir stringByAppendingPathComponent:[[self.request URL] absoluteString]];
}

- (void)start {
    NSData *urlData = [NSData dataWithContentsOfFile:[self urlFilePath]];
    NSLog(@"%@", [[NSString alloc] initWithData:urlData encoding:NSUTF8StringEncoding]);
    
    [self realStart];
}

- (void)realStart {
    if (requestFlags.started) return; // subsequent calls to this method won't do anything
    
    requestFlags.started = YES;
    
    //NSLog(@"Requesting %@", self);
    
    self->data = [NSMutableData data];
    self->connection = [NSURLConnection connectionWithRequest:request delegate:self];    
}

- (void)connectionDidFinishLoading:(NSURLConnection *)conn {
    [self realConnectionDidFinishLoading:conn];
}

- (void)realConnectionDidFinishLoading:(NSURLConnection *)conn {
    
//    NSLog(@"Finished loading %@", self);
    
    [self retain]; // we must retain ourself before we call handlers, in case they release us!
    
    NSInteger status = [response isKindOfClass:[NSHTTPURLResponse class]] ? [(NSHTTPURLResponse *)response statusCode] : 200;
    
    [self->data writeToFile:[self urlFilePath] atomically:TRUE];
    
    if (conn && response && (status < 200 || (status >= 300 && status != 304))) {
        NSLog(@"Failed with HTTP status code %i while loading %@", (int)status, self);
        
        SMErrorResponse *error = [[[SMErrorResponse alloc] init] autorelease];
        error.response = (NSHTTPURLResponse *)response;
        error.data = data;
        
        NSMutableDictionary* details = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                        @"Received an HTTP status code indicating failure.", NSLocalizedDescriptionKey,
                                        error, SMErrorResponseKey,
                                        nil];
        [self dispatchError:[NSError errorWithDomain:@"SMWebRequest" code:status userInfo:details]];
    }
    else {
        if ([delegate respondsToSelector:@selector(webRequest:resultObjectForData:context:)]) {
            
            // neither us nor our delegate can get dealloced whilst processing on the background
            // thread or else the background thread could try to do stuff with pointers to garbage.
            // thus we need have a mechanism for keeping ourselves alive during the background
            // processing.
            [self retain];
            [delegate retain];
            
            [self performSelectorInBackground:@selector(processDataInBackground:) withObject:data];
        }
        else
            [self dispatchComplete:data];
    }
    
    self->connection = nil;
    self->data = nil; // don't keep this!
    [self release];
}


@end
