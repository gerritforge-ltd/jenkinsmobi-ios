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

#import "HudsonTestListXmlDataParser.h"

@implementation HudsonTestListXmlDataParser

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *) namespaceURI qualifiedName:(NSString *)qName
   attributes: (NSDictionary *)attributeDict{
	
	if(currentReadCharacters!=nil){
		
		[currentReadCharacters release];
		currentReadCharacters = nil;
	}
	
	if([elementName isEqualToString:@"case"]){
		
		currentSubObject = [[HudsonTest alloc] init];
        if(currentChildReportUrl!=nil){
            [currentSubObject setUrl:[NSString stringWithFormat:@"%@/testReport",currentChildReportUrl]];
        }
	}
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
	
    if([elementName isEqualToString:@"url"]){
        
        currentChildReportUrl = [NSString stringWithString:currentReadCharacters];
        
    }else if([elementName isEqualToString:@"name"]){
		
		if(currentSubObject!=nil){
			[currentSubObject setName:currentReadCharacters];
		}
	}else if([elementName isEqualToString:@"age"]){
		if(currentSubObject!=nil){
			[currentSubObject setAge:[currentReadCharacters intValue]];
		}
	}else if([elementName isEqualToString:@"failedSince"]){
		if(currentSubObject!=nil){
			[currentSubObject setFailedSince:[currentReadCharacters intValue]];
		}
	}else if([elementName isEqualToString:@"skipped"]){
		if(currentSubObject!=nil){
			[currentSubObject setSkipped:[currentReadCharacters boolValue]];
		}
	}else if([elementName isEqualToString:@"status"]){
		if(currentSubObject!=nil){
			[currentSubObject setStatus:currentReadCharacters];
		}
	}else if([elementName isEqualToString:@"className"]){
		if(currentSubObject!=nil){
			[currentSubObject setClassName:currentReadCharacters];
		}
	}else if([elementName isEqualToString:@"duration"]){
		if(currentSubObject!=nil){
			[currentSubObject setDuration:[currentReadCharacters doubleValue]];
		}
	}else if([elementName isEqualToString:@"case"]){
		
		[[currentObject failedTests] addObject:currentSubObject];
		currentSubObject = nil;
	}
}

@end
