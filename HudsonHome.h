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

#import <Foundation/Foundation.h>
#import "AbstractHudsonObject.h"
#import "HomeHudsonXmlParser.h"
#import "HudsonView.h"
#import "HudsonViewList.h"

@interface HudsonHome : AbstractHudsonObject {

	HudsonViewList* viewList;
	NSString* assignedLabel;
	NSString* mode;
	NSString* nodeDescription;
	NSString* nodeName;
	int numExecutors;
}

@property (assign) HudsonViewList* viewList;
@property (assign) NSString* assignedLabel;
@property (assign) NSString* mode;
@property (assign) NSString* nodeDescription;
@property (assign) NSString* nodeName;
@property (assign) int numExecutors;

@end
