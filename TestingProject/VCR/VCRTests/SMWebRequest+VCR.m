//
//  SMWebRequest+VCR.m
//  VCR
//
//  Created by Fletcher Fowler on 11/3/12.
//  Copyright (c) 2012 Zamboni Dev. All rights reserved.
//

#import "SMWebRequest+VCR.h"
#import "FileManager.h"

@implementation SMWebRequest (VCR)

- (void)start {
    NSDictionary *cassetteDictionary = [FileManager cassetteForRequest:request];
    if(cassetteDictionary != nil)
    {
        NSURLConnection *conn = [NSURLConnection connectionWithRequest:request delegate:self];
        [self connectionDidFinishLoading:conn];
    }
    else
    {
        [self realStart];
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)conn {
    NSLog(@"Finished loading data: %@", [[NSString alloc] initWithData:self->data encoding:NSUTF8StringEncoding]);
    NSDictionary *cassetteDictionary = [FileManager cassetteForRequest:request];
    
    if(cassetteDictionary)
    {
        self->data = [cassetteDictionary objectForKey:@"data"];
    }
    else
    {
        [FileManager writeToFileWithResponse:response andRequest:request andData:self->data];
    }
    
    [self realConnectionDidFinishLoading:conn];
}

- (void)realStart {
    if (requestFlags.started) return; // subsequent calls to this method won't do anything
    
    requestFlags.started = YES;
    
    //NSLog(@"Requesting %@", self);
    
    self->data          = [NSMutableData data];
    self->connection    = [NSURLConnection connectionWithRequest:request delegate:self];    
}

- (void)realConnectionDidFinishLoading:(NSURLConnection *)conn {
    
//    NSLog(@"Finished loading %@", self);
    
    [self retain]; // we must retain ourself before we call handlers, in case they release us!
    
    NSInteger status = [response isKindOfClass:[NSHTTPURLResponse class]] ? [(NSHTTPURLResponse *)response statusCode] : 200;
  
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
