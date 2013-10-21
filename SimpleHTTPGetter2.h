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

#import <Foundation/Foundation.h>
#import "IWSDataReceiver.h"

@interface SimpleHTTPGetter2 : NSObject {
    
    id<IWSDataReceiver> target;
    bool followRedirect;
}

@property (assign) bool followRedirect;

+(void)clearSession;

-(void)httpGET:(NSString*)url withTarget:(id<IWSDataReceiver>)_target;
-(void)httpGET:(NSString*)url withTarget:(id<IWSDataReceiver>)_target withUsername:(NSString*)username andPassword:(NSString*)password;
-(void)httpGET:(NSString*)url withTarget:(id<IWSDataReceiver>)_target withUsername:(NSString*)username andPassword:(NSString*)password andHeaders:(NSMutableDictionary*)headers;

-(void)httpPOST:(NSString*)url withTarget:(id<IWSDataReceiver>)_target andParams:(NSDictionary*)params;
-(void)httpPOST:(NSString*)url withTarget:(id<IWSDataReceiver>)_target andParams:(NSDictionary*)params withUsername:(NSString*)username andPassword:(NSString*)password;

@end
