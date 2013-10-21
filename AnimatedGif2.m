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

#import "AnimatedGif2.h"


@implementation AnimatedGif2

static NSString* blueFrameArray[]={@"blue_anime_1",@"blue_anime_2",@"blue_anime_3",@"blue_anime_4"};
static NSString* redFrameArray[]={@"red_anime_1",@"red_anime_2",@"red_anime_3",@"red_anime_4"};
static NSString* grayFrameArray[]={@"gray_anime_1",@"gray_anime_2",@"gray_anime_3",@"gray_anime_4"};
static NSString* yellowFrameArray[]={@"yellow_anime_1",@"yellow_anime_2",@"yellow_anime_3",@"yellow_anime_4"};

-(id)initWithImageBasename:(NSString*)imageBasename{
		
	if(self = [super init]){
	
		if([@"blue_anime" isEqualToString:imageBasename]){
			frameArray = blueFrameArray;
		}else if([@"red_anime" isEqualToString:imageBasename]){
			frameArray = redFrameArray;
		}else if([@"yellow_anime" isEqualToString:imageBasename]){
			frameArray = yellowFrameArray;
		}else{
			frameArray = grayFrameArray;
		}
	}
	
	return self;
}

//Frame array must be set as: 1 2 3 4 3 2 1 with 200 millis delay
- (void) storeAnimation:(UIImageView*)imageView
{

	UIImage *frame1 = [UIImage imageNamed:frameArray[0]];
	UIImage *frame2 = [UIImage imageNamed:frameArray[1]];
	UIImage *frame3 = [UIImage imageNamed:frameArray[2]];
	UIImage *frame4 = [UIImage imageNamed:frameArray[3]];
	UIImage *frame5 = [UIImage imageNamed:frameArray[2]];
	UIImage *frame6 = [UIImage imageNamed:frameArray[1]];
	UIImage *frame7 = [UIImage imageNamed:frameArray[0]];
	
	frames = [[NSArray alloc] initWithObjects:frame1,frame2,frame3,frame4,frame5,frame6,frame7,nil];
	
	[imageView setImage:frame1];
	[imageView setAnimationImages:frames];
	[imageView setAnimationDuration:1.0];
	[imageView setAnimationRepeatCount:0];// which means infinite loop
	[imageView startAnimating];
}

- (void) dealloc
{
	[frames release];
	[super dealloc];
}


@end
