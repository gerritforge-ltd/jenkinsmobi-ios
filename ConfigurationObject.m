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

#import "ConfigurationObject.h"

@implementation ConfigurationObject

@synthesize url,username,password,useXpath,hudsonVersion,portNumber,lastTimeWasOnline,hudsonHostname,filename;
@synthesize description, protocol,suffix,connectionTimeout, maxBuildsNumberToLoadAtTime,overrideHudsonURLWithConfiguredOne;
@synthesize maxConsoleOutputSize;

-(id)init{
    self = [super init];
    if (self) {
        
        [self setUsername:@""];
        [self setPassword:@""];
        [self setHudsonHostname:@""];
        [self setHudsonVersion:@""];
		[self setUseXpath:YES];
		[self setDescription:@""];
		[self setProtocol:@"http"];
		[self setSuffix:@""];
		[self setPortNumber:@""];
        [self setOverrideHudsonURLWithConfiguredOne:YES];
		[self setConnectionTimeout:60];
        [self setMaxConsoleOutputSize:51200];//50KB
        [self setMaxBuildsNumberToLoadAtTime:10];
        [self setLastTimeWasOnline:@"U"]; //unknown: can U(nknown), Y(es), N(o)
	}
	
	return self;
}

-(BOOL)isEqual:(id)anOtherObject{
	
	BOOL result = NO;
	
	if(anOtherObject != nil){
        
		if([anOtherObject hudsonHostname] != nil && 
		   [[anOtherObject hudsonHostname] isEqualToString:hudsonHostname]){
            
			result  = YES;
		}
	}
	
	return result;
}

-(void)loadConfiguration:(NSString*)_filename{
	
	[self setFilename:_filename];
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString* path = [NSString stringWithFormat:@"%@/%@",[paths objectAtIndex:0], filename];
	NSFileManager* fman=[NSFileManager defaultManager];
	
	hudsonVersion = @"";
	
	if([fman fileExistsAtPath:path]){
		
		NSDictionary* configurationProperties = [NSDictionary dictionaryWithContentsOfFile:path];
		
		[self setPortNumber:[configurationProperties valueForKey:KEY_SERVICE_PORT]];
        [self setHudsonVersion:[configurationProperties valueForKey:KEY_API_VERSION]];
        [self setHudsonHostname:[configurationProperties valueForKey:KEY_SERVICE_HOSTNAME]];
        [self setUrl:[configurationProperties valueForKey:KEY_SERVICE_URL]];
        [self setUsername:[configurationProperties valueForKey:KEY_USERNAME]];
        [self setPassword:[configurationProperties valueForKey:KEY_PASSWORD]];
        [self setUseXpath:[[configurationProperties valueForKey:KEY_USE_XPATH] boolValue]];
        [self setDescription:[configurationProperties valueForKey:KEY_DESCRIPTION]];
        [self setProtocol:[configurationProperties valueForKey:KEY_SERVICE_PROTOCOL]];
        [self setSuffix:[configurationProperties valueForKey:KEY_SERVICE_HOSTNAME_SUFFIX]];
        [self setConnectionTimeout:[[configurationProperties valueForKey:KEY_CONNECTION_TIMEOUT] intValue]];
		
        if([configurationProperties valueForKey:KEY_MAX_CONSOLE_LOG_SIZE]!=nil){
            [self setMaxConsoleOutputSize:[[configurationProperties valueForKey:KEY_MAX_CONSOLE_LOG_SIZE] intValue]];
        }
        
        if([configurationProperties valueForKey:KEY_MAX_LOAD_OBJECTS_NUMBER]!=nil){
            [self setMaxBuildsNumberToLoadAtTime:[[configurationProperties valueForKey:KEY_MAX_LOAD_OBJECTS_NUMBER] intValue]];
        }
        
        if([configurationProperties valueForKey:KEY_OVERRIDE_HUDSON_URL]!=nil){
            [self setOverrideHudsonURLWithConfiguredOne:[[configurationProperties valueForKey:KEY_OVERRIDE_HUDSON_URL] boolValue]];
        }
        
        if(portNumber!=nil && [portNumber isEqualToString:@"-1"]){
            [self setPortNumber:@""];
        }
        
		if(connectionTimeout==0){
			connectionTimeout = 60;
		}
		
		if(description==nil){
			description = hudsonHostname;
		}
	}
}

-(void)remove{
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString* path = [NSString stringWithFormat:@"%@/%@",[paths objectAtIndex:0], filename];
	NSError* error = nil;
	NSFileManager* fman=[NSFileManager defaultManager];
	[fman removeItemAtPath:path error:&error];
}

-(NSString*)getCompleteURL{
	
	NSString* result = nil;
	
	if(suffix==nil){
		suffix = @"";
	}
	
	if(portNumber==nil || [portNumber length]==0){
		
		if([suffix isEqualToString:@""]){
			result = [NSString stringWithFormat:@"%@://%@", protocol, hudsonHostname];
		}else{
			result = [NSString stringWithFormat:@"%@://%@/%@", protocol, hudsonHostname, suffix];
		}
	}else{
		
		if([suffix isEqualToString:@""]){
			result = [NSString stringWithFormat:@"%@://%@:%@", protocol, hudsonHostname, portNumber];
		}else {
			result = [NSString stringWithFormat:@"%@://%@:%@/%@", protocol, hudsonHostname, portNumber, suffix];
		}
	}
	
	return result;
}

-(void)saveConfiguration{
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString* path = [NSString stringWithFormat:@"%@/%@",[paths objectAtIndex:0], filename];
	
	if(suffix==nil){
		suffix = @"";
	}
	
	if(connectionTimeout==0){
		connectionTimeout = 60;
	}
	
    [self setUrl:[self getCompleteURL]];
	
	NSMutableDictionary* configurationProperties = [[NSMutableDictionary alloc] initWithCapacity:6];
	if(hudsonVersion!=nil){
		[configurationProperties setObject:hudsonVersion forKey:KEY_API_VERSION];
	}
	
	if(portNumber!=nil){
		[configurationProperties setObject:portNumber forKey:KEY_SERVICE_PORT];
	}
	
	if(url!=nil){
		[configurationProperties setObject:url forKey:KEY_SERVICE_URL];
	}
	
	if(description!=nil){
		[configurationProperties setObject:description forKey:KEY_DESCRIPTION];
	}
	
	if(hudsonHostname!=nil){
		[configurationProperties setObject:hudsonHostname forKey:KEY_SERVICE_HOSTNAME];
	}
	
	if(protocol!=nil){
		[configurationProperties setObject:protocol forKey:KEY_SERVICE_PROTOCOL];
	}
	
	if(suffix!=nil){
		[configurationProperties setObject:suffix forKey:KEY_SERVICE_HOSTNAME_SUFFIX];
	}
	
	if(username!=nil){
		[configurationProperties setObject:username forKey:KEY_USERNAME];
	}
	
	if(password!=nil){
		[configurationProperties setObject:password forKey:KEY_PASSWORD];
	}
	
	[configurationProperties setObject:[NSString stringWithFormat:@"%d",connectionTimeout] forKey:KEY_CONNECTION_TIMEOUT];
	
	[configurationProperties setObject:[NSString stringWithFormat:@"%d",useXpath] forKey:KEY_USE_XPATH];
    
    [configurationProperties setObject:[NSString stringWithFormat:@"%d",overrideHudsonURLWithConfiguredOne] forKey:KEY_OVERRIDE_HUDSON_URL];
    
    [configurationProperties setObject:[NSString stringWithFormat:@"%d",maxConsoleOutputSize] forKey:KEY_MAX_CONSOLE_LOG_SIZE];
    
    [configurationProperties setObject:[NSString stringWithFormat:@"%d",maxBuildsNumberToLoadAtTime] forKey:KEY_MAX_LOAD_OBJECTS_NUMBER];
	
	[configurationProperties writeToFile:path atomically:YES];
	
	[configurationProperties release];
}

- (void) dealloc
{
	[super dealloc];
}



@end
