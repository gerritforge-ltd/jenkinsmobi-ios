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

#import <UIKit/UIKit.h>
#import "AbstractViewController.h"
#import "IWSDataReceiver.h"
#import "HudsonProject.h"
#import "HudsonBuild.h"
#import "AnimatedGif2.h"
#import "GenericHTMLViewer.h"
#import "BuildConsoleOutputViewController.h"
#import "HudsonBuildChangesListViewController.h"
#import "FailedTestListTableViewController.h"
#import "ProjectTrendViewController.h"
#import "Maven2ModulesListViewController.h"
#import "BuildArtifactListViewController.h"
#import "Maven2DetailHeaderView.h"


@class LoadingView;

@interface ProjectDetailViewController : AbstractViewController <IWSDataReceiver> {
	
	HudsonProject* currentProject;
	int buildStopOrStart;
	bool isMavenModuleDetail;
	bool lastBuildLoadRequested;
    bool loadingLastTrend;
    bool neverRunJob;
	LoadingView* loadingView;
	SimpleHTTPGetter* getter;
}

@property (assign) 	bool isMavenModuleDetail;

-(void)doBuildAction;
- (id)initWithNibName:(NSString*)nibName bundle:(NSBundle*)bundle andProject:(HudsonProject*)project;

@end
