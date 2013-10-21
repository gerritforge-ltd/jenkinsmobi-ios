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

#import "HudsonBuild.h"

@implementation HudsonBuild

@synthesize number, isBuilding, duration, fullDisplayName, buildId, result, timestamp, keepLog, builtOn, artifacts;
@synthesize testFailCount,testReportUrl,testSkipCount,testTotalCount;

-(id)init{
	
    self = [super init];
    
	if(self){
		
		artifacts = [[NSMutableArray alloc] init];
		xmlDataParser = [[FreeStyleBuildXmlParser alloc] initWithCaller:self andObjectToStore:self];
		
		if([[Configuration getInstance] useXpath]){
			[self setXPathQueryString:[QueryStringNormalizer normalize:@"tree=actions[causes[shortDescription]],bulding,duration,fullDisplayName,id,keepLog,number,result,timestamp,url,builtOn,artifacts[displayPath,fileName,relativePath]"]];
		}
	}
	
	return self;
}

-(void)loadHudsonObject{

	if(fullDisplayName!=nil){
		[fullDisplayName release];
		fullDisplayName = nil;
	}
	if(buildId!=nil){
		[buildId release];
		buildId = nil;
	}
	if(result!=nil){
		[result release];
		result = nil;
	}
	if(timestamp != nil){
		[timestamp release];
		timestamp = nil;
	}
	if(builtOn!=nil){
		[builtOn release];
		builtOn = nil;
	}
	if(testReportUrl!=nil){
		[testReportUrl release];
		testReportUrl = nil;
	}
	
	[artifacts release];
	artifacts = [[NSMutableArray alloc] init];
	
	[super loadHudsonObject];
}

-(long) builtSince{

	long now = (long)[[NSDate date] timeIntervalSince1970];
	return now - [timestamp longLongValue];
}

-(NSString*) durationeHumanReadable{
	
	return [self humanReadableElapsed:duration/1000];
}

-(NSString*) builtSinceHumanReadable{
	
	long now = (long)[[NSDate date] timeIntervalSince1970];
	long seconds = now - ([timestamp longLongValue]/1000);
	
    if(seconds<0){
    
        return NSLocalizedString(@"very few seconds", nil);
    }else{
    
        return [self humanReadableElapsed:seconds];
    }
}

-(NSString*)humanReadableElapsed:(long)seconds{
	
	if(seconds > 60){
		
		long minutes = seconds/60;
		
		if(minutes > 60){
			
			long hours = minutes/60;
			
			if(hours>24){
				
				long days = hours/24;
				
				if(days > 30){
					
					long months = days/30;
					days = days % 30;
					
					return [NSString stringWithFormat:NSLocalizedString(@"%d months and %d days",nil),months,days];
					
				}else{
					
					hours = hours%24;
					return [NSString stringWithFormat:NSLocalizedString(@"%d days and %d hours",nil),days, hours];
				}
				
			}else{
				
				minutes = minutes % 60;
				return [NSString stringWithFormat:NSLocalizedString(@"%d hours and %d minutes",nil),hours,minutes];
			}
		}else{
			
			seconds = seconds % 60;
			return [NSString stringWithFormat:NSLocalizedString(@"%d minutes and %d seconds",nil), minutes,seconds];
		}
	}else{
		
		return [NSString stringWithFormat:NSLocalizedString(@"%d seconds",nil),seconds];
	}
}

- (void) dealloc
{

	if(fullDisplayName!=nil){
		[fullDisplayName release];
	}
	if(buildId!=nil){
		[buildId release];
	}
	if(result!=nil){
		[result release];
	}
	if(timestamp != nil){
		[timestamp release];
	}
	if(builtOn!=nil){
		[builtOn release];
	}
	if(testReportUrl!=nil){
		[testReportUrl release];
	}

	if(artifacts!=nil){
		[artifacts release];
		artifacts = nil;
	}
	
	[super dealloc];
}


@end
