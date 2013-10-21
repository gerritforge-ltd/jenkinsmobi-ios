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

#import "HudsonVersion.h"

@implementation HudsonVersion

-(id)init{
	
    self = [super init];
    
	if(self){
		
		[self setUrl:[[Configuration getInstance] url]];
		loginRequested = NO;
	}
	
	return self;
}

-(void)checkVersion{
	
	if(url!=nil){
		[[Configuration getInstance] setHudsonVersion:nil];
		
		[httpGetter setCheckOnlyStatusCode:YES];
		[httpGetter httpGET:url :self];
	}
}

-(void)receiveData:(NSData*)data{
	
	NSString* response = [[NSString alloc] initWithBytes: [data bytes] length:[data length] encoding:NSUTF8StringEncoding];
	[Logger info:[NSString stringWithFormat:@"Response from hudson is:\n %@",response]];
	int code  = [response intValue];
	[response release];
	
	if((code == 403 && loginRequested == NO) || 
		([[Configuration getInstance] hudsonVersion]==nil)){
		
		loginRequested = YES;
		
		//we need to login
		login = [[HudsonLoginObject alloc] init];
		[login setDelegate:self];
		[login doLogin];
	}else{
		[delegate performSelector:@selector(onVersionCheckFinisched)];
	}
}

-(void)onAuthorizationGranted{
	
	[login doLogout];
	[delegate performSelector:@selector(onVersionCheckFinisched)];
}

-(void)onAuthorizationDenied{
	
	[delegate performSelector:@selector(onVersionCheckFinisched)];
}

- (void) dealloc
{
	if(login!=nil){
		[login release];
	}
	[super dealloc];
}


@end
