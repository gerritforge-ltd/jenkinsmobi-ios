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

#import "FreeStyleBuildXmlParser.h"

@implementation FreeStyleBuildXmlParser

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *) namespaceURI qualifiedName:(NSString *)qName attributes: (NSDictionary *)attributeDict{
	
	if(currentReadCharacters!=nil){
		
		[currentReadCharacters release];
		currentReadCharacters = nil;
	}
	
	if([elementName isEqualToString:@"artifact"]){
		
		currentSubObject = [[HudsonArtifact alloc] init];
	}
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
	if([elementName isEqualToString:@"shortDescription"]){
		
		[currentObject setDescription:currentReadCharacters];
	}else if([elementName isEqualToString:@"building"]){
		
		[currentObject setIsBuilding:[currentReadCharacters boolValue]];
	}else if([elementName isEqualToString:@"duration"]){
		
		[currentObject setDuration:[currentReadCharacters intValue]];	
	}else if([elementName isEqualToString:@"fullDisplayName"]){
		
		[currentObject setFullDisplayName:currentReadCharacters];		
	}else if([elementName isEqualToString:@"id"]){
		
		[currentObject setBuildId:currentReadCharacters];		
	}else if([elementName isEqualToString:@"keepLog"]){
		
		[currentObject setKeepLog:[currentReadCharacters boolValue]];		
	}else if([elementName isEqualToString:@"number"]){
		
		[currentObject setNumber:[currentReadCharacters intValue]];
	}else if([elementName isEqualToString:@"result"]){
		
		[currentObject setResult:currentReadCharacters];
	}else if([elementName isEqualToString:@"timestamp"]){
		
		[currentObject setTimestamp:currentReadCharacters];
	}else if([elementName isEqualToString:@"url"]){
		
		[currentObject setUrl:currentReadCharacters];
	}else if([elementName isEqualToString:@"builtOn"]){
		
		[currentObject setBuiltOn:currentReadCharacters];
	}else if([elementName isEqualToString:@"displayPath"]){
		
		if(currentSubObject!=nil){
			[currentSubObject setDisplayPath:currentReadCharacters];
		}
	}else if([elementName isEqualToString:@"fileName"]){
		if(currentSubObject!=nil){
			[currentSubObject setFileName:currentReadCharacters];
		}
	}else if([elementName isEqualToString:@"relativePath"]){
		if(currentSubObject!=nil){
			[currentSubObject setRelativePath:currentReadCharacters];
		}
	}else if([elementName isEqualToString:@"artifact"]){
		
		[[currentObject artifacts] addObject:currentSubObject];
		[currentSubObject release];
	}	
}

@end
