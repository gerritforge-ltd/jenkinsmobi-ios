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

#import "HudsonTest.h"
#import "HudsonTestXmlDataParser.h"

@implementation HudsonTest

@synthesize age,status,failedSince,errorDetails,errorStackTrace,errorStdOut,errorStdErr,skipped,className,duration;


-(void)loadHudsonObject{

	if(xmlDataParser!=nil){
		[xmlDataParser release];
		xmlDataParser = nil;
	}
    
	xmlDataParser = [[HudsonTestXmlDataParser alloc] initWithCaller:self andObjectToStore:self];
	
	if([[Configuration getInstance] useXpath]){
        
        NSString* queryString = [NSString stringWithFormat:@"xpath=//*/case[name='%@' and className='%@']",name,className];
        [self setXPathQueryString:[QueryStringNormalizer normalize:queryString]];
	}
    
    [super loadHudsonObject];
}

- (void) dealloc
{
	[super dealloc];
}


@end
