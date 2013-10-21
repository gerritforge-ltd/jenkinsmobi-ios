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

#import "SimpleReachabiliyChecker.h"
#import "Logger.h"

@implementation SimpleReachabiliyChecker

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

-(BOOL)isHostAlive:(NSString*)host:(SEL)__onResponseSelector:(id)__delegate:(int)__tag{
    
    BOOL result = NO;
    [Logger info:[NSString stringWithFormat:@"Checking if '%@' alive",host]];
    
    onResponseSelector = __onResponseSelector;
    delegate = __delegate;
    tag = __tag;
    
    NSMutableURLRequest* urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:host]];
    [urlRequest setValue:@"Close" forHTTPHeaderField:@"Connection"];
    [urlRequest setTimeoutInterval:1000*15];

    /*
    NSURLResponse* response = nil;
    NSError* error = nil;
    [NSURLConnection sendAsynchronousRequest:urlRequest returningResponse:&response error:&error];
    
    if(error!=nil){
    
        result = NO;
    }else{
        
        result = YES;
    }
     */
    
    NSURLConnection* conn = [NSURLConnection connectionWithRequest:urlRequest delegate:self];
    
    if(!conn){
        [delegate performSelector:onResponseSelector withObject:@"error" withObject:tag];
    }
    
    return result;
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
        [delegate performSelector:onResponseSelector withObject:@"error" withObject:tag];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    [delegate performSelector:onResponseSelector withObject:@"ok" withObject:tag];
}

@end
