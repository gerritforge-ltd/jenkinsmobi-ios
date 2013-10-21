//
//  BeesTOSAgreeCell.m
//  HudsonMobile
//
//  Created by simone on 5/26/11.
//  Copyright 2011 LMIT ltd. All rights reserved.
//

#import "BeesTOSAgreeCell.h"
#import "GenericHTMLViewer.h"

@implementation BeesTOSAgreeCell

@synthesize descLabel, onoffSwitch, parent, inputCellUpdateSelector;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}

- (IBAction) onOffSwitchValueChanged: (id) sender{
    
    [parent performSelector:inputCellUpdateSelector withObject:onoffSwitch];
}

- (IBAction) onShowTOSButtonClick: (id) sender{
    
	GenericHTMLViewer *anotherViewController = [[GenericHTMLViewer alloc] initWithNibName:@"GenericHTMLViewer" bundle:nil andFileName:@"bees_tos" andTitle:NSLocalizedString(@"Terms Of Service",@"Terms Of Service") andURL:nil andData:nil];
	[[(UITableViewController*)parent navigationController] pushViewController:anotherViewController animated:YES];
	[anotherViewController release];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)dealloc
{
    [super dealloc];
}

@end
