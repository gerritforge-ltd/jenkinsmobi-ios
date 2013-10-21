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

#import "MonitorConfiguration.h"

static MonitorConfiguration* instance = nil;

@implementation MonitorConfiguration

@synthesize monitoredProjectList;

+(MonitorConfiguration*)getInstance{

	if(instance == nil){
	
		instance = [[MonitorConfiguration alloc] init];
		[instance loadConfiguration];
	}
	
	return instance;
}

-(void)loadConfiguration{
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString* path = [NSString stringWithFormat:@"%@/%@",[paths objectAtIndex:0], MONITOR_CONFIGURATION_FILENAME];
	NSFileManager* fman=[NSFileManager defaultManager];

	
	if([fman fileExistsAtPath:path]){
		
		NSDictionary* configurationProperties = [NSDictionary dictionaryWithContentsOfFile:path];
		
		int count = [[configurationProperties valueForKey:KEY_MONITORED_OBJECTS_COUNT] intValue];
		monitoredProjectList = [[NSMutableArray alloc] initWithCapacity:count];
		
		for (int i = 0; i < count; i++) {
			
			[monitoredProjectList addObject:[configurationProperties valueForKey:
			  [NSString stringWithFormat:@"%@.%d",KEY_MONITORED_OBJECTS_COUNT,i]]];
		}
	}
}

-(void)saveConfiguration{
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString* path = [NSString stringWithFormat:@"%@/%@",[paths objectAtIndex:0], MONITOR_CONFIGURATION_FILENAME];
	
	int count = [monitoredProjectList count];
	NSMutableDictionary* configurationProperties = [[NSMutableDictionary alloc] initWithCapacity:count+1];
	
	[configurationProperties setInteger:count forKey:KEY_MONITORED_OBJECTS_COUNT];
	
	for (int i = 0; i < count; i++) {
		[configurationProperties setObject:[monitoredProjectList objectAtIndex:i] 
									 forKey:[NSString stringWithFormat:@"%@.%d",KEY_MONITORED_OBJECT_URL,i]];
	}
	
	
	[configurationProperties writeToFile:path atomically:YES];
	[configurationProperties release];
}

@end
