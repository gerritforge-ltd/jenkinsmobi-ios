//
//  BeesClientBase.m
//  HudsonMobile
//
//  Created by simone on 5/28/11.
//  Copyright 2011 LMIT ltd. All rights reserved.
//

#import "BeesClientBase.h"

#include <CommonCrypto/CommonDigest.h>

@implementation BeesClientBase

-(id)initWithApiUrl:(NSString*)_serverApiUrl andApiKey:(NSString*)_apiKey andSecret:(NSString*)_secret andFormat:(NSString*)_format andVersion:(NSString*)_version{
    
    self = [super init];
    if (self) {
        
        serverApiUrl = @"http://localhost:8080/api";
        version = @"1.0";
        sigVersion = @"1";
        format = @"xml";
        
        if(_serverApiUrl!=nil){
            serverApiUrl = _serverApiUrl;
        }
        if(_version!=nil){
            version = _version;
        }
        if(_format!=nil){
            format = _format;
        }
        if(_secret!=nil){
            secret = _secret;
        }
        if(_apiKey!=nil){
            api_key = _apiKey;
        }
    }
    return self;
}

-(NSString*) getRequestUrl:(NSString*) method andMethodParams:(NSDictionary*)params {
    
    NSDictionary* urlParams = [self defaultParameters];
    
    NSMutableString* requestURL = [[[NSMutableString alloc] initWithString:[self apiUrl:nil]] autorelease];
    [requestURL appendString:@"?"];
    
    if(params!=nil){
        NSEnumerator* paramsKeyEnum = [params keyEnumerator];
        NSString* paramName = [paramsKeyEnum nextObject];
        while(paramName!=nil){
            [urlParams setValue:[params valueForKey:paramName] forKey:paramName];
            paramName = [paramsKeyEnum nextObject];
        }
    }
    
    //if (asActionParam){ always YES for now
        [urlParams setValue:method forKey:@"action"];
    //}
    
    NSString* signature = [self calculateSignature:urlParams];
    
    NSEnumerator* entryNameEnumerator = [urlParams keyEnumerator];
    NSString* entryName = [entryNameEnumerator nextObject];
    int i=0;
    while(entryName!=nil) {
        
        NSString* key = entryName;
        NSString* value = [urlParams valueForKey:entryName];
        if (i > 0){
            [requestURL appendString:@"&"];
        }
        [requestURL appendString:key];
        [requestURL appendString:@"="];
        [requestURL appendString:value];
        i++;
        entryName = [entryNameEnumerator nextObject];
    }
    
    [requestURL appendString:@"&"];
    [requestURL appendString:@"sig"];
    [requestURL appendString:@"="];
    [requestURL appendString:signature];
    
    return requestURL;     
}     

-(NSDictionary*) defaultParameters{
    
    NSDictionary* result  = [[[NSMutableDictionary alloc] init] autorelease];
    
    NSString* timestamp = [NSString stringWithFormat:@"%d",(int)([[NSDate date] timeIntervalSince1970])];
    [result setValue:format forKey:@"format"];
    [result setValue:version forKey:@"v"];
    [result setValue:api_key forKey:@"api_key"];
    [result setValue:timestamp forKey:@"timestamp"];
    [result setValue:sigVersion forKey:@"sig_version"];
    
    return result;
}

-(NSString*) apiUrl:(NSString*) method {
    
    NSMutableString* result = [[[NSMutableString alloc] init] autorelease];
    
    [result appendString:serverApiUrl];
    
    if(method!=nil){
        
        [result appendString:@"/"];
        [result appendString:method];
    }
    
    return result;
}

-(NSString*) getSignature:(NSString*) data :(NSString*) secret{
    
    NSString* s = [NSString stringWithFormat:@"%@%@",data,secret];
    
    NSString* result = [self md5:s];             
    
    return result;
}

-(NSString*) md5:(NSString*) message{
    
    // Initialize the hash object
    CC_MD5_CTX hashObject;
    CC_MD5_Init(&hashObject);
    
    const char* cString = [message cStringUsingEncoding:NSWindowsCP1252StringEncoding];
    
    CC_MD5_Update(&hashObject, 
                  (const void *)cString, 
                  (CC_LONG)[message length]);
    
    // Compute the hash digest
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5_Final(digest, &hashObject);
    
    NSMutableString* result = [[NSMutableString alloc] init];
    
    int j;
    for(j=0;j<CC_MD5_DIGEST_LENGTH;j++){
        
        [result appendFormat:@"%02x",digest[j]];
    }
    
    return result;
}

-(NSString*) calculateSignature:(NSDictionary*) entries{
    
    NSMutableString* sigData = [[NSMutableString alloc] init];
    
    NSMutableArray* unsortedEntriesKeys = [[NSMutableArray alloc] init];
    NSEnumerator* keyEnum = [entries keyEnumerator];
    id key = [keyEnum nextObject];
    while(key!=nil){
        
        [unsortedEntriesKeys addObject:key];
        key = [keyEnum nextObject];
    }
    NSArray* sortedKeys = [unsortedEntriesKeys sortedArrayUsingComparator:(NSComparator)^(id obj1, id obj2){
        NSString *strobj1 = (NSString*)obj1;
        NSString *strobj2 = (NSString*)obj2;
        return [strobj1 caseInsensitiveCompare:strobj2]; }];
    
    
    for (int i=0; i<[sortedKeys count]; i++) {
    
        [sigData appendString:[sortedKeys objectAtIndex:i]];
        [sigData appendString:[entries valueForKey:[sortedKeys objectAtIndex:i]]];
    }
    
    NSString* signature = [self getSignature:sigData :secret];
    
    [sigData release];
    [unsortedEntriesKeys release];
    
    return signature;
}

-(void) executeRequest:(NSString*) url withReceiver:(id<IWSDataReceiver>)dataReceiver{
    
    [Logger debug:[NSString stringWithFormat:@"API call: %@", url]];    
    
    SimpleHTTPGetter* httpGetter = [[SimpleHTTPGetter alloc] init];
    [httpGetter httpGETNoAuth:url :dataReceiver];
}                   

@end
