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

#import "Configuration.h"

static Configuration* instance = nil;

@implementation Configuration

@synthesize targetCIProductName,url,username,password,useXpath,hudsonVersion,productVersion,portNumber,savePassword,syncTimeout,productName,hudsonHostname;
@synthesize connected,lastUpdate,viewToUpdateOnConnectionChange,description,connectionTimeout;
@synthesize hudsonInstances, selectedConfigurationInstance,iOSVersion,maxBuildsNumberToLoadAtTime,suffix;
@synthesize overrideHudsonURLWithConfiguredOne, maxConsoleOutputSize,eulaAccepted,auditAccepted,isWallLoaded;
@synthesize isIPhone;

- (id) init{

    self = [super init];
    if (self) {
		
		NSString* sysver = [[UIDevice currentDevice] systemVersion];
		if([sysver hasPrefix:@"5"]){
			iOSVersion = 5;
		}else if([sysver hasPrefix:@"4"]){
			iOSVersion = 4;
		}else if([sysver hasPrefix:@"3"]){
			iOSVersion = 3;
		}
		
		hudsonInstances = [[NSMutableArray alloc] init];
		
		[self loadConfiguration];
	}
	
	return self;
}

-(void)checkConnections{

    sendAliveConnection = YES;
    
    if([[Configuration getInstance] auditAccepted]){
    
        connected = [Reachability canReachHost:WWW_HUDSON_MOBI_COM
                                          :self
                                          :@selector(onNetworkStatusChange:)];
    }else{
        connected = [Reachability canReachHost:WWW_GOOGLE_COM
                                              :self
                                              :@selector(onNetworkStatusChange:)];
    }
}

//Called by Reachability whenever status changes.
-(void)onNetworkStatusChange:(NSNotification* )note{
	
	Reachability* curReach = [note object];
	
	[Logger info:@"Network status change occurs"];
    
	if([curReach currentReachabilityStatus]==NotReachable){
		
		[Logger info:@"Network disconnected"];
		connected = NO;
	}else{
		[Logger info:@"Network connected"];		
		connected = YES;
	}
	
	if(viewToUpdateOnConnectionChange!=nil){
		
		[viewToUpdateOnConnectionChange performSelector:@selector(onNetworkStatusChange)];
	}
	
	//if there is a network connection try to issue a GET request to http://www.hudson-mobi.com
	if(connected && sendAliveConnection){
		
        if([[Configuration getInstance] auditAccepted]){
            if(shg==nil){
                shg=[[SimpleHTTPGetter alloc] init];
            }
            [Logger info:@"Connecting to http://www.hudso-mobi.com to say we are alive"];
            [shg setCheckOnlyStatusCode:YES];
            [shg setForceNotUseCredentials:YES];
            [shg httpGET:[NSString stringWithFormat:@"http://%@",WWW_HUDSON_MOBI_COM] :nil];
        }
		
		sendAliveConnection = NO;
	}
}

+ (Configuration*) getInstance{

	if(instance==nil){
	
		instance  = [[Configuration alloc] init];
	}
	
	return instance;
}

-(void)setSelectedConfigurationInstance:(int)selection{

	selectedConfigurationInstance = selection;
	
	if(selectedConfigurationInstance < [hudsonInstances count]){
		currentConfigurationObject = [hudsonInstances objectAtIndex:selectedConfigurationInstance];
	}
}

-(void)setSelectedConfigurationInstanceByHostname:(NSString*)hostname{
	
	selectedConfigurationInstance = 0;
	
	for (ConfigurationObject* hudsonInstance in hudsonInstances) {
		
		if([[hudsonInstance hudsonHostname] isEqualToString:hostname]){
			
			break;
		}else{
		
			selectedConfigurationInstance++;
		}
	}
	
	if(selectedConfigurationInstance<[hudsonInstances count]){

		currentConfigurationObject = [hudsonInstances objectAtIndex:selectedConfigurationInstance];
	}
}

-(int)maxBuildsNumberToLoadAtTime{
	
	return [currentConfigurationObject maxBuildsNumberToLoadAtTime];
}

-(void)setMaxBuildsNumberToLoadAtTime:(int)size{
    [currentConfigurationObject setMaxBuildsNumberToLoadAtTime:size];
}


-(int)maxConsoleOutputSize{

    return [currentConfigurationObject maxConsoleOutputSize];
}

-(void)setMaxConsoleOutputSize:(int)size{

    [currentConfigurationObject setMaxConsoleOutputSize:size];
}

-(NSString*)url{

	return [currentConfigurationObject url];
}

-(NSString*)suffix{
	
	return [currentConfigurationObject suffix];
}

-(NSString*)hudsonHostname{
	
	return [currentConfigurationObject hudsonHostname];
}

-(NSString*)hudsonVersion{
	
	return [currentConfigurationObject hudsonVersion];
}

-(void)setHudsonVersion:(NSString*)version{
	
	[currentConfigurationObject setHudsonVersion:version];
}

-(NSString*)description{
	
	return [currentConfigurationObject description];
}

-(NSString*)username{
	
	return [currentConfigurationObject username];
}

-(NSString*)password{
	
	return [currentConfigurationObject password];
}

-(int)connectionTimeout{

	return [currentConfigurationObject connectionTimeout];
}

-(void)setPassword:(NSString*)newPassword{
	
	return [currentConfigurationObject setPassword:newPassword];
}

-(NSString*)portNumber{
	
	return [currentConfigurationObject portNumber];
}

-(BOOL)useXpath{
	
	return [currentConfigurationObject useXpath];
}

-(BOOL)savePassword{
	
	return [currentConfigurationObject savePassword];
}

-(BOOL)overrideHudsonUrlWithTheConfiguredOne{
	
	return [currentConfigurationObject overrideHudsonURLWithConfiguredOne];
}

-(void)loadConfiguration{
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString* path = [NSString stringWithFormat:@"%@/%@",[paths objectAtIndex:0], CONFIGURATION_FILENAME];
	NSFileManager* fman=[NSFileManager defaultManager];
	
	NSDictionary* plistDictionary = [[NSBundle mainBundle] infoDictionary];
	[self setProductVersion:[plistDictionary objectForKey:@"CFBundleVersion"]];
	[self setProductName:[plistDictionary objectForKey:@"CFBundleName"]];
    
    if([[self productName] isEqualToString:@"JenkinsMobi"]){
    
        [self setTargetCIProductName:@"Jenkins"];
    }else{
        [self setTargetCIProductName:@"Hudson"];
    }
    
    UIDevice* device = [UIDevice currentDevice];
    isIPhone = [[device model] hasPrefix:@"iPhone"];
    
    
#ifdef FORCE_CI_TARGET
    [self setTargetCIProductName:FORCE_CI_TARGET];
#endif
	
	hudsonInstancesNumber = 0;
	selectedConfigurationInstance = 0;
	
	if([fman fileExistsAtPath:path]){
		
		NSDictionary* configurationProperties = [NSDictionary dictionaryWithContentsOfFile:path];
		hudsonInstancesNumber = [[configurationProperties valueForKey:KEY_HUDSON_INSTANCES_NUM] intValue];
        eulaAccepted = [[configurationProperties valueForKey:KEY_EULA_ACCEPTED] boolValue];
        if([configurationProperties valueForKey:KEY_AUDIT_ACCEPTED]!=nil){
            auditAccepted = [[configurationProperties valueForKey:KEY_AUDIT_ACCEPTED] boolValue];
        }else{
            auditAccepted = YES;
        }
		
		//now load the files
		for (int i = 0; i < hudsonInstancesNumber; i++) {
			
			NSString* filename = [NSString stringWithFormat:@"%@.%d",CONFIGURATION_FILENAME,i];
			
			ConfigurationObject* confObject = [[ConfigurationObject alloc] init];
			[confObject loadConfiguration:filename];
			[hudsonInstances addObject:confObject];
			[confObject release];
		}
		
		[self setSelectedConfigurationInstance:[[configurationProperties valueForKey:KEY_LAST_SELECTED_HUDSON_INSTANCE] intValue]];
		
	}else{
	
		//default instance
        
        ConfigurationObject* confObject = [self createDefaultJenkinsInstance];
        [hudsonInstances addObject:confObject];
        hudsonInstancesNumber++;
		
		[self saveAllConfiguration];
		[self setSelectedConfigurationInstance:0];
	}
}

-(ConfigurationObject*)createDefaultJenkinsInstance{
	
	NSString* filename = [NSString stringWithFormat:@"%@.%d",CONFIGURATION_FILENAME,0];
	ConfigurationObject* confObject = [[[ConfigurationObject alloc] init] autorelease];
	
	[confObject setFilename:filename];
	[confObject setHudsonHostname: @"ci.jenkins-ci.org"];
	[confObject setUrl:@"http://ci.jenkins-ci.org"];
    [confObject setDescription:@"Jenkins@jenkins-ci"];
	
	return confObject;
}

-(void)saveConfiguration{
	
	hudsonInstancesNumber = [hudsonInstances count];
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString* path = [NSString stringWithFormat:@"%@/%@",[paths objectAtIndex:0], CONFIGURATION_FILENAME];
	
	NSMutableDictionary* configurationProperties = [[NSMutableDictionary alloc] initWithCapacity:1];
	[configurationProperties setObject:[NSString stringWithFormat:@"%d", auditAccepted] forKey:KEY_AUDIT_ACCEPTED];
	[configurationProperties setObject:[NSString stringWithFormat:@"%d", eulaAccepted] forKey:KEY_EULA_ACCEPTED];
    [configurationProperties setObject:[NSString stringWithFormat:@"%d", hudsonInstancesNumber] forKey:KEY_HUDSON_INSTANCES_NUM];
	[configurationProperties setObject:[NSString stringWithFormat:@"%d", selectedConfigurationInstance] forKey:KEY_LAST_SELECTED_HUDSON_INSTANCE];
	
	[configurationProperties writeToFile:path atomically:YES];
	[configurationProperties release];
}

-(void)saveAllConfiguration{
	
	hudsonInstancesNumber = [hudsonInstances count];
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString* path = [NSString stringWithFormat:@"%@/%@",[paths objectAtIndex:0], CONFIGURATION_FILENAME];
	
	NSMutableDictionary* configurationProperties = [[NSMutableDictionary alloc] initWithCapacity:1];
    [configurationProperties setObject:[NSString stringWithFormat:@"%d", auditAccepted] forKey:KEY_AUDIT_ACCEPTED];
    [configurationProperties setObject:[NSString stringWithFormat:@"%d", eulaAccepted] forKey:KEY_EULA_ACCEPTED];
    [configurationProperties setObject:[NSString stringWithFormat:@"%d", hudsonInstancesNumber] forKey:KEY_HUDSON_INSTANCES_NUM];
	[configurationProperties setObject:[NSString stringWithFormat:@"%d", selectedConfigurationInstance] forKey:KEY_LAST_SELECTED_HUDSON_INSTANCE];
	[configurationProperties writeToFile:path atomically:YES];
	[configurationProperties release];
	
	int i=0;
	for (ConfigurationObject* confObject in hudsonInstances) {
	 
		NSString* filename = [NSString stringWithFormat:@"%@.%d",CONFIGURATION_FILENAME,i];
		[confObject setFilename:filename];
		[confObject saveConfiguration];
		i++;
	}
}

- (void) dealloc
{
	if(shg!=nil){
		[shg release];
	}
	[hudsonInstances release];
	[super dealloc];
}


@end
