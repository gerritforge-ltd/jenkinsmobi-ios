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

#import "HudsonProjectTrendItem.h"

@implementation HudsonProjectTrendItem

@synthesize result,totalTests,totalFailed, totalSkipped, timestamp, number, parent, failedTests;

-(id)initWithBuild:(HudsonBuild*)build{
    
    self = [super init];
    
	if(self){
		
        [httpGetter setIgnore404Error:YES];
        
		parent = build;
		[self setUrl:[parent url]];
		
		failedTests = [[NSMutableArray alloc] init];
		
		xmlDataParser = [[ProjectTrendsXmlDataParser alloc] initWithCaller:self andObjectToStore:self];
        
		if([[Configuration getInstance] useXpath]){
			[self setXPathQueryString:[QueryStringNormalizer normalize:@"xpath=//*/number|//*/timestamp|//*/result|//*/action/failCount|//*/action/skipCount|//*/action/totalCount&wrapper=stats"]];
		}
	}
	
	return self;
}

-(void)loadFailedTests:(int)from:(int)to{
	
	[url release];
	[self setUrl:[NSString stringWithFormat:@"%@/testReport",[parent url]]];
	if(xmlDataParser!=nil){
		[xmlDataParser release];
		xmlDataParser = nil;
	}
	xmlDataParser = [[HudsonTestListXmlDataParser alloc] initWithCaller:self andObjectToStore:self];
	
	if([[Configuration getInstance] useXpath]){
        
		if (from > -1 && to > -1) {
			[self setXPathQueryString:[QueryStringNormalizer normalize:@"xpath=//*/child|//*/case[status='FAILED']|//*/case[status='REGRESSION']&exclude=//*/case/stdout&exclude=//*/case/stderr&exclude=//*/case/errorStackTrace&wrapper=failedTests"]];
		} else {
			
			[self setXPathQueryString:[QueryStringNormalizer normalize:[NSString stringWithFormat:@"xpath=//*/child|//*/case[status='FAILED' and position()>=%d and position()<%d]|//*/case[status='REGRESSION' and position()>=%d and position()<%d]&exclude=//*/case/stdout&exclude=//*/case/stderr&exclude=//*/case/errorStackTrace&wrapper=failedTests",from,to,from,to]]];
		}
        
	}	
}
-(void)loadFailedTests{
    
	[self loadFailedTests:-1 :-1];
}

-(NSString*)buildDate{
    
	NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
	NSDate* date = [NSDate dateWithTimeIntervalSince1970:(([timestamp longLongValue]/1000))];
	[formatter setDateFormat:@"dd-MM-YYYY HH:mm"];
	NSString* stringResult = [formatter stringFromDate:date];
	[formatter release];
	return stringResult;
}

- (void) dealloc
{
	[failedTests release];
	
	if(result!=nil){
		[result release];
	}
	if(timestamp!=nil){
		[timestamp release];
	}
    
	[super dealloc];
}


@end
