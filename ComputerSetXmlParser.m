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

#import "ComputerSetXmlParser.h"


@implementation ComputerSetXmlParser

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *) namespaceURI qualifiedName:(NSString *)qName
   attributes: (NSDictionary *)attributeDict{
	
	if(currentReadCharacters!=nil){
		
		[currentReadCharacters release];
		currentReadCharacters = nil;
	}
	
	if([elementName isEqualToString:@"computer"]){
		
		currentSubObject = [[ComputerSet alloc] init];
	}
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
	
	if([elementName isEqualToString:@"busyExecutors"]){
		
		[currentObject setBusyExecutors:[currentReadCharacters intValue]];
	}else if([elementName isEqualToString:@"displayName"]){
		
		if(currentSubObject!=nil){
			[currentSubObject setDisplayName:currentReadCharacters];
		}
	}else if([elementName isEqualToString:@"icon"]){
		if(currentSubObject!=nil){
			[currentSubObject setColorName:currentReadCharacters];
		}
	}else if([elementName isEqualToString:@"idle"]){
		if(currentSubObject!=nil){
			[currentSubObject setIdle:[currentReadCharacters boolValue]];	
		}
	}else if([elementName isEqualToString:@"jnlpAgent"]){
		if(currentSubObject!=nil){
			[currentSubObject setJnlpAgent:[currentReadCharacters boolValue]];		
		}
	}else if([elementName isEqualToString:@"launchSupported"]){
		if(currentSubObject!=nil){
			[currentSubObject setLaunchSupported:[currentReadCharacters boolValue]];		
		}
	}else if([elementName isEqualToString:@"manualLaunchAllowed"]){
		if(currentSubObject!=nil){
			[currentSubObject setManualLaunchAllowed:[currentReadCharacters boolValue]];
		}
	}else if([elementName isEqualToString:@"availablePhysicalMemory"]){
		if(currentSubObject!=nil){
			[currentSubObject setAvailablePhysicalMemory:[currentReadCharacters intValue]];
		}
	}else if([elementName isEqualToString:@"availableSwapSpace"]){
		if(currentSubObject!=nil){
			[currentSubObject setAvailableSwapSpace:[currentReadCharacters intValue]];
		}
	}else if([elementName isEqualToString:@"totalPhysicalMemory"]){
		if(currentSubObject!=nil){
			[currentSubObject setTotalPhysicalMemory:[currentReadCharacters intValue]];
		}
	}else if([elementName isEqualToString:@"totalSwapSpace"]){
		if(currentSubObject!=nil){
			[currentSubObject setTotalSwapSpace:[currentReadCharacters intValue]];
		}
	}else if([elementName isEqualToString:@"hudson.node_monitors.ArchitectureMonitor"]){
		if(currentSubObject!=nil){
			[currentSubObject setArchitecture:currentReadCharacters];
		}
	}else if([elementName isEqualToString:@"numExecutors"]){
		if(currentSubObject!=nil){
			[currentSubObject setNumExecutors:[currentReadCharacters intValue]];
		}
	}else if([elementName isEqualToString:@"offline"]){
		
		if(currentSubObject!=nil){
			[currentSubObject setOffline:[currentReadCharacters boolValue]];
		}
	}else if([elementName isEqualToString:@"temporarilyOffline"]){
		if(currentSubObject!=nil){
			[currentSubObject setTemporarilyOffline:[currentReadCharacters boolValue]];
		}
	}else if([elementName isEqualToString:@"computer"]){
		
		[[currentObject computers] addObject:currentSubObject];
		currentSubObject = nil;
	}
}

@end
