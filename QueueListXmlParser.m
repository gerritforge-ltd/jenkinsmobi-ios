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

#import "QueueListXmlParser.h"


@implementation QueueListXmlParser

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *) namespaceURI qualifiedName:(NSString *)qName
   attributes: (NSDictionary *)attributeDict{
	
	if(currentReadCharacters!=nil){
		
		[currentReadCharacters release];
		currentReadCharacters = nil;
	}
	
	if([elementName isEqualToString:@"item"]){
		
		currentSubObject = [[HudsonQueueItem alloc] init];
	}
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
	
	if([elementName isEqualToString:@"blocked"]){
		
		if(currentSubObject!=nil){
			[currentSubObject setBlocked:[currentReadCharacters boolValue]];
		}
	}else if([elementName isEqualToString:@"buildable"]){
		
		if(currentSubObject!=nil){
			[currentSubObject setBuildable:[currentReadCharacters boolValue]];
		}
	}else if([elementName isEqualToString:@"stuck"]){
		
		if(currentSubObject!=nil){
			[currentSubObject setStuck:[currentReadCharacters boolValue]];
		}
	}else if([elementName isEqualToString:@"why"]){
		
		if(currentSubObject!=nil){
			[currentSubObject setReasonInQueue:currentReadCharacters];	
		}
	}else if([elementName isEqualToString:@"name"]){
		
		if(currentSubObject!=nil){
			[currentSubObject setName:currentReadCharacters];		
		}
	}else if([elementName isEqualToString:@"buildableStartMilliseconds"]){
		
		if(currentSubObject!=nil){
			[currentSubObject setBuildableStartMilliseconds:[currentReadCharacters intValue]];		
		}
	}else if([elementName isEqualToString:@"color"]){
		if(currentSubObject!=nil){
			[currentSubObject setColorName:currentReadCharacters];
		}
	}else if([elementName isEqualToString:@"url"]){
		
		if(currentSubObject!=nil){
			[currentSubObject setUrl:currentReadCharacters];
		}
	}else if([elementName isEqualToString:@"shortDescription"]){
		
		if(currentSubObject!=nil){
			[currentSubObject setShortDescription:currentReadCharacters];
		}
	}else if([elementName isEqualToString:@"item"]){
		
		[[currentObject queueItems] addObject:currentSubObject];
		currentSubObject=nil;
	}
}

@end
