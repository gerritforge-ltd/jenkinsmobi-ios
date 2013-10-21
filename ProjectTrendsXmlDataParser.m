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

#import "ProjectTrendsXmlDataParser.h"

@implementation ProjectTrendsXmlDataParser

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *) namespaceURI qualifiedName:(NSString *)qName
   attributes: (NSDictionary *)attributeDict{
	
	if(currentReadCharacters!=nil){
		
		[currentReadCharacters release];
		currentReadCharacters = nil;
	}
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
	
	if([elementName isEqualToString:@"result"]){
		
		[currentObject setResult:currentReadCharacters];
	}else if([elementName isEqualToString:@"skipCount"]){
		
		[currentObject setTotalSkipped:[currentReadCharacters intValue]];
	}else if([elementName isEqualToString:@"totalCount"]){
		
		[currentObject setTotalTests:[currentReadCharacters intValue]];
	}else if([elementName isEqualToString:@"failCount"]){
		
		[currentObject setTotalFailed:[currentReadCharacters intValue]];
	}else if([elementName isEqualToString:@"timestamp"]){
		
		[currentObject setTimestamp:currentReadCharacters];
	}else if([elementName isEqualToString:@"number"]){
		
		[currentObject setNumber:[currentReadCharacters intValue]];
	}
	
}
 
 
@end
