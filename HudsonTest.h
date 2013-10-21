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

@interface HudsonTest : AbstractHudsonObject {

	int age;
	int failedSince;
    double duration;
    bool skipped;
	NSString* className;
	NSString* errorDetails;
	NSString* errorStackTrace;
    NSString* errorStdOut;
    NSString* errorStdErr;
	NSString* status;
}

@property (assign) int age;
@property (assign) int failedSince;
@property (assign) double duration;
@property (assign) bool skipped;
@property (nonatomic,retain) NSString* className;
@property (nonatomic,retain) NSString* errorDetails;
@property (nonatomic,retain) NSString* errorStackTrace;
@property (nonatomic,retain) NSString* errorStdOut;
@property (nonatomic,retain) NSString* errorStdErr;
@property (nonatomic,retain) NSString* status;


@end
