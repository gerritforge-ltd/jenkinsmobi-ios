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

#import "ProjectListTableViewCell.h"


@implementation ProjectListTableViewCell

-(void)setCurrentProject:(HudsonProject*)project{

	if(currentProject!=nil){
	
		[nameLabel removeFromSuperview];
		[buildStatusImageView removeFromSuperview];
	}
	
	currentProject = project;

	buildStatusImageView  = [[UIImageView alloc]
										  initWithFrame:CGRectMake(15.f, 7.f, 32.f, 32.f)];
	nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(50.f, 6.f, 250.f, 32.f)];
	
	[nameLabel setFont:[UIFont boldSystemFontOfSize:17.f]];
	[nameLabel setText:[currentProject name]];
	
	if([[project colorName] hasSuffix:@"_anime"]){
		AnimatedGif2* animatedGif = [[AnimatedGif2 alloc] initWithImageBasename:[project colorName]];
		[animatedGif storeAnimation:buildStatusImageView];
		[animatedGif release];
		
	}else{
		[buildStatusImageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.png",[project colorName]]]];
	}
	
	[self addSubview:nameLabel];
	[self addSubview:buildStatusImageView];
	
	[nameLabel release];
	[buildStatusImageView release];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)dealloc {
    [super dealloc];
}


@end
