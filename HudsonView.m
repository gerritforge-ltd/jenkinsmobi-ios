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

#import "HudsonView.h"

@implementation HudsonView

@synthesize jobs, filter;

-(id)init{
	
    self = [super init];
    
	if(self){
		
		jobs = [[NSMutableArray alloc] init];
		xmlDataParser = [[ViewXmlParser alloc] initWithCaller:self andObjectToStore:self];
		
		if([[Configuration getInstance] useXpath]){
			[self setXPathQueryString:[QueryStringNormalizer normalize:@"xpath=//*/job&wrapper=jobs"]];
		}
	}
	
	return self;
}

-(void)loadHudsonObject{

	[jobs release];
		
	jobs = [[NSMutableArray alloc] init];
	
	[super loadHudsonObject];
}

- (BOOL)isEqual:(id)anObject{

	return [name isEqualToString:[anObject name]];
}

-(NSMutableArray*)jobs{
	
	NSMutableArray* result = nil;
	
	if(filter==nil || [filter isEqualToString:@"all"]){
	
		result = jobs;
	}else{
	
        filteredJobList = [[[NSMutableArray alloc] init] autorelease];
		
		for (HudsonProject* job in jobs) {
			
			if([filter isEqualToString:@"inprogress"] && [[job colorName] hasSuffix:@"_anime"]){
			
				[filteredJobList addObject:job];
			}else if([filter isEqualToString:@"failed"] && [[job colorName] hasPrefix:@"red"]){
				
				[filteredJobList addObject:job];
			}else if([filter isEqualToString:@"stable"] && [[job colorName] hasPrefix:@"blue"]){
				
				[filteredJobList addObject:job];
			}else if([filter isEqualToString:@"unstable"] && [[job colorName] hasPrefix:@"yellow"]){
				
				[filteredJobList addObject:job];
			}else if([filter isEqualToString:@"aborted"] && [[job colorName] hasPrefix:@"grey"]){
				
				[filteredJobList addObject:job];
			}else {
				
				//filter created by a serach bar search
				if([[job name] rangeOfString:filter options:NSCaseInsensitiveSearch].location!=NSNotFound){
                    
					[filteredJobList addObject:job];
				}
			}
		}
		
		result =  filteredJobList;
	}
	
	return result;
}

- (void) dealloc
{	
	[jobs release];
	
	[super dealloc];
}


@end
