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

#import "HudsonLoginObject.h"

@implementation HudsonLoginObject

-(id)init{

    self = [super init];
    
	if(self){
	
		[self setUrl:[[Configuration getInstance] url]];
	}
	
	return self;
}

-(void)doLogout{
	
	logoutRequested=YES;
	[httpGetter setCheckOnlyStatusCode:YES];
	[httpGetter httpGET:[NSString stringWithFormat:@"%@/logout",url] :self];
}

-(void)doLogin{

    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies]) {
        [storage deleteCookie:cookie];
    }
    
	username = [[Configuration getInstance] username];
	password = [[Configuration getInstance] password];
	[self doLoginWithUsernane:username andPassword:password];
}

-(void)doLoginWithUsernane:(NSString*)_username andPassword:(NSString*)_password{
    
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies]) {
        [storage deleteCookie:cookie];
    }
    
	username = _username;
	password = _password;
	
	[Logger info:[NSString stringWithFormat:@"Loggin in with username '%@' and password 'xxxxx'",username]];
	loginFirstTryRequested=NO;
	
	[httpGetter setCheckOnlyStatusCode:YES];
	//[httpGetter httpGET:url :self];WWWW
    
    [httpGetter setCheckOnlyStatusCode:YES];
    if([httpGetter httpGET:url withUsername:username andPassword:password andDataReceiver:self]==1){	
        if(delegate!=nil){
            [delegate performSelector:@selector(onAuthorizationDenied)];
        }
    }
}

-(void)receiveData:(NSData*)data{

	/*
     if(loginFirstTryRequested==NO){
		loginFirstTryRequested = YES;
		
		[httpGetter setCheckOnlyStatusCode:YES];
		if([httpGetter httpGET:url withUsername:username andPassword:password andDataReceiver:self]==1){	
			if(delegate!=nil){
				[delegate performSelector:@selector(onAuthorizationDenied)];
			}
		}
		return;
	}
	*/
    
	if(data==nil || logoutRequested==YES){
		
		if(delegate!=nil && logoutRequested==NO){
			[delegate performSelector:@selector(onAuthorizationDenied)];
		}else if(logoutRequested==YES){
        
            [delegate performSelector:@selector(onAuthorizationGranted)];
        }
		
		logoutRequested=NO;
		return;
	}
	
	NSString* response = [[NSString alloc] initWithBytes: [data bytes] length:[data length] encoding:NSUTF8StringEncoding];
	[Logger info:[NSString stringWithFormat:@"Response from hudson is:\n %@",response]];
	int code  = [response intValue];
	[response release];
	
	if(code == 403){
	
		//give up
		if(delegate!=nil){
			[delegate performSelector:@selector(onAuthorizationDenied)];
		}
	}else{
		
		if(code==200 && delegate!=nil){
			
			[delegate performSelector:@selector(onAuthorizationGranted)];
		}else if(delegate!=nil){
		
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Connection error",nil) 
															message:[SimpleHTTPGetter getLastHttpStatusMsg]
														   delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
			[alert show];
			[alert release];
			
			[delegate performSelector:@selector(onLoadFinischedWithErrors)];
		}
	}
}

- (void) dealloc
{
	[super dealloc];
}


@end
