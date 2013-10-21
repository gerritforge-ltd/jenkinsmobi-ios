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

#import "FreeStyleProjectXmlParser.h"

@implementation FreeStyleProjectXmlParser

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *) namespaceURI qualifiedName:(NSString *)qName
   attributes: (NSDictionary *)attributeDict{
	
	if(currentReadCharacters!=nil){
		
		[currentReadCharacters release];
		currentReadCharacters = nil;
	}
	
	if([elementName isEqualToString:@"build"]){
		
		currentSubObject = [[HudsonBuild alloc] init];
	}else if([elementName isEqualToString:@"lastBuild"]){
		
		currentSubObject = [[HudsonBuild alloc] init];
	}else if([elementName isEqualToString:@"healthReport"]){
		
		currentSubObject = [[HudsonHealthReport alloc] init];
	}else if([elementName isEqualToString:@"module"]){
		
		currentSubObject = [[HudsonMaven2Project alloc] init];
	}else if([elementName isEqualToString:@"queueItem"]){
		
		currentSubObject = [[HudsonQueueItem alloc] init];
	}
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
	
	if([elementName isEqualToString:@"description"]){
		
		if(skipFurtherTags) return;
		
		if(currentSubObject!=nil){
			
			[currentSubObject setDescription:currentReadCharacters];
		}else{
			
			[currentObject setDescription:currentReadCharacters];
		}
	}else if([elementName isEqualToString:@"iconUrl"]){
		
		if(skipFurtherTags) return;
		
		if(currentSubObject!=nil){
			[currentSubObject setColorName:currentReadCharacters];
		}
	}else if([elementName isEqualToString:@"url"]){
		
		if(skipFurtherTags) return;
		
		if(currentSubObject!=nil){
			
			[currentSubObject setUrl:currentReadCharacters];
		}else{
			
			//[currentObject setUrl:currentReadCharacters];
		}
	}else if([elementName isEqualToString:@"score"]){
		
		if(skipFurtherTags) return;
		
		if(currentSubObject!=nil){
			[currentSubObject setScore:[currentReadCharacters intValue]];
		}
	}else if([elementName isEqualToString:@"displayName"]){
		
		if(skipFurtherTags) return;
		
		if(currentSubObject!=nil){
			
			[currentSubObject setDisplayName:currentReadCharacters];
		}else{
			
			[currentObject setDisplayName:currentReadCharacters];
		}
	}else if([elementName isEqualToString:@"name"]){
		
		if(skipFurtherTags) return;
		
		if(currentSubObject!=nil){
			
			[currentSubObject setName:currentReadCharacters];
		}else{
			
			[currentObject setName:currentReadCharacters];
		}
	}else if([elementName isEqualToString:@"url"]){
		
		if(skipFurtherTags) return;
		
		if(currentSubObject!=nil){
			[currentSubObject setUrl:currentReadCharacters];
		}
	}else if([elementName isEqualToString:@"buildable"]){
		
		if(skipFurtherTags) return;
		
		[currentObject setIsBuildable:[currentReadCharacters boolValue]];		
	}else if([elementName isEqualToString:@"color"]){
		
		if(skipFurtherTags) return;
		
		if(currentSubObject!=nil){
			
			[currentSubObject setColorName:currentReadCharacters];
		}else{
			
			[currentObject setColorName:currentReadCharacters];
		}
	}else if([elementName isEqualToString:@"blocked"]){
		
		if(skipFurtherTags) return;
		
		if(currentSubObject!=nil){
			[currentSubObject setBlocked:[currentReadCharacters boolValue]];
		}
	}else if([elementName isEqualToString:@"buildable"]){
		
		if(skipFurtherTags) return;
		
		if(currentSubObject!=nil){
			[currentSubObject setBuildable:[currentReadCharacters boolValue]];
		}
	}else if([elementName isEqualToString:@"stuck"]){
		
		if(skipFurtherTags) return;
		
		if(currentSubObject!=nil){
			[currentSubObject setStuck:[currentReadCharacters boolValue]];
		}
	}else if([elementName isEqualToString:@"why"]){
		
		if(skipFurtherTags) return;
		
		if(currentSubObject!=nil){
			[currentSubObject setReasonInQueue:currentReadCharacters];
		}
	}else if([elementName isEqualToString:@"inQueue"]){
		
		if(skipFurtherTags) return;
		
		[currentObject setIsInQueue:[currentReadCharacters boolValue]];
	}else if([elementName isEqualToString:@"build"]){
		
		if(skipFurtherTags) return;
		
		[[currentObject recentBuilds] addObject:currentSubObject];
		[currentSubObject release];
		currentSubObject = nil;
	}else if([elementName isEqualToString:@"number"]){
		
		if(skipFurtherTags) return;
		
        if(currentSubObject!=nil){
        
            [(HudsonBuild*)currentSubObject setNumber:[currentReadCharacters intValue]];
        }
	}else if([elementName isEqualToString:@"lastBuild"]){
		
		if(skipFurtherTags) return;
		
		[currentObject setLastBuild:currentSubObject];
		currentSubObject = nil;
	}else if([elementName isEqualToString:@"healthReport"]){
		
		if(skipFurtherTags) return;
		
		if([[currentSubObject description] hasPrefix:@"Build"]){
			[currentObject setBuildStabilityReport:currentSubObject];
		}else{
			[currentObject setTestStabilityReport:currentSubObject];		
		}
		currentSubObject = nil;
	}else if([elementName isEqualToString:@"module"]){
		
		if(skipFurtherTags) return;
		
		[[currentObject mavenModules] addObject:currentSubObject];
		[currentSubObject release];
		currentSubObject = nil;
	}else if([elementName isEqualToString:@"queueItem"]){
		
		if(skipFurtherTags) return;
		
		[currentObject setQueueDescriptor: currentSubObject];	
		currentSubObject = nil;
	}
}


@end
