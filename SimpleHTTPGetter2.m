// Copyright (C) 2012 LMIT Limited
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and 
// limitations under the License.

#import "SimpleHTTPGetter2.h"

#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "Logger.h"

@implementation SimpleHTTPGetter2

@synthesize followRedirect;

+(void)clearSession{
    [ASIHTTPRequest clearSession];
}

- (id)init {
    self = [super init];
    if (self) {
        followRedirect = YES;
    }
    return self;
}

-(void)httpGET:(NSString*)url withTarget:(id<IWSDataReceiver>)_target{

    [self httpGET:url withTarget:_target withUsername:nil andPassword:nil];
}

-(void)httpGET:(NSString*)url withTarget:(id<IWSDataReceiver>)_target withUsername:(NSString*)username andPassword:(NSString*)password{
    target =  _target;
    
    NSURL *nsurl = [NSURL URLWithString:url];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:nsurl];
    [request setShouldRedirect:followRedirect];
    [request setDelegate:self];
    
    if(username!=nil){
        [request setUsername:username];
        [request setPassword:password];
    }
    
    [request startAsynchronous];
}

-(void)httpGET:(NSString*)url withTarget:(id<IWSDataReceiver>)_target withUsername:(NSString*)username andPassword:(NSString*)password andHeaders:(NSMutableDictionary*)headers{
    target =  _target;
    
    NSURL *nsurl = [NSURL URLWithString:url];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:nsurl];
    [request setShouldRedirect:followRedirect];
    [request setDelegate:self];
    [request setRequestHeaders:headers];
    
    if(username!=nil){
        [request setUsername:username];
        [request setPassword:password];
    }
    
    [request startAsynchronous];
}

-(void)httpPOST:(NSString*)url withTarget:(id<IWSDataReceiver>)_target andParams:(NSDictionary*)params{

    [self httpPOST:url withTarget:_target andParams:params withUsername:nil andPassword:nil];
}

-(void)httpPOST:(NSString*)url withTarget:(id<IWSDataReceiver>)_target andParams:(NSDictionary*)params
   withUsername:(NSString*)username andPassword:(NSString*)password{
    target =  _target;
    
    NSURL *nsurl = [NSURL URLWithString:url];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:nsurl];
    [request setShouldRedirect:followRedirect];
    
    if(params!=nil && [params count]>0){
        NSEnumerator* paramNamesEmum = [params keyEnumerator];
        
        NSString* paramName = [paramNamesEmum nextObject];
        
        while(paramName!=nil){
            
            [request setPostValue:[params objectForKey:paramName] forKey:paramName];
            paramName = [paramNamesEmum nextObject];
        }
    }
    
    if(username!=nil){
        [request setUsername:username];
        [request setPassword:password];
    }
    
    [request setDelegate:self];
    [request startAsynchronous];
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    
    int httpErrCode  = [request responseStatusCode];
    
    [Logger info:[NSString stringWithFormat:@"SimpleHTTPGetter2 HTTP code: [%d]",httpErrCode]];
    
#ifdef DEBUG
    NSString *responseString = [request responseString];
    [Logger info:responseString];
#endif    
    
    NSData *responseData = [request responseData];
    if(target!=nil){
        
        if([(id)target respondsToSelector:@selector(receiveData:andHeaders:)]){
        
            [target receiveData:responseData andHeaders:[request responseHeaders]];
        }else{
            [target receiveData:responseData];
        }
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    int httpErrCode  = [request responseStatusCode];
    
    [Logger error:[NSString stringWithFormat:@"SimpleHTTPGetter2 failure HTTP code: [%d]",httpErrCode]];
}

@end
