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

#import "UIConfigurationViewController.h"

@implementation UIConfigurationViewController

@synthesize currentEditingTextField;

-(id)initWithNibName:(NSString*)nib bundle:(NSBundle*)bunble andConfigurationObject:(ConfigurationObject*)confObject{
	
    self = [self initWithNibName:nib bundle:bunble];
    
	if(self){
		
		currentConfigurationObject = confObject;
        
        //11 items        
        cellValues = [[NSMutableArray alloc] initWithObjects:
                    [currentConfigurationObject description],
                    [currentConfigurationObject hudsonHostname],
                    [currentConfigurationObject suffix],
                    [[currentConfigurationObject protocol] isEqualToString:@"https"]?@"1":@"0",
                    [currentConfigurationObject portNumber],
                    [currentConfigurationObject useXpath]?@"1":@"0",
                    [NSString stringWithFormat:@"%d",[currentConfigurationObject connectionTimeout]],
                    [currentConfigurationObject overrideHudsonURLWithConfiguredOne]?@"1":@"0",
                    [NSString stringWithFormat:@"%d",[currentConfigurationObject maxBuildsNumberToLoadAtTime]],
                    [NSString stringWithFormat:@"%d",([currentConfigurationObject maxConsoleOutputSize]/1024)],
                    [currentConfigurationObject username],
                    [currentConfigurationObject password],nil];
        
		configurationItems = [[NSArray alloc] initWithObjects:NSLocalizedString(@"Description",nil),//section 0
                              NSLocalizedString(@"Host",nil),//section  0
                              NSLocalizedString(@"Path suffix",nil),//section  0					  
                              NSLocalizedString(@"HTTP/S",nil),//section 0
                              NSLocalizedString(@"Port",nil),//section 0
                              NSLocalizedString(@"XPath",nil),//section 0
                              NSLocalizedString(@"Timeout",nil), // seconds section  0
                              [NSString stringWithFormat:NSLocalizedString(@"Override %@ URL",nil),[[Configuration getInstance] targetCIProductName]], // seconds section  0
                              NSLocalizedString(@"Load max items",nil),//section 0
                              NSLocalizedString(@"Build log max size",nil),//KB section 0
                              NSLocalizedString(@"Username",nil),//section  1
                              NSLocalizedString(@"Password",nil),//section  1
                              nil];
	}
	
	return self;
}

-(void)onInputCellStartEditing:(UITextField*)textView{

    if(currentEditingTextField!=nil){
        [[self currentEditingTextField] resignFirstResponder];
        [self setCurrentEditingTextField:nil];
        [textView becomeFirstResponder];
    }
    
    [self setCurrentEditingTextField:textView];
    
    if([textView tag]==6){
            
        [currentEditingTextField setText:[cellValues objectAtIndex:6]];
    }else if([textView tag]==9){
    
        [currentEditingTextField setText:[cellValues objectAtIndex:9]];
    }
}

-(void)onInputCellUpdate:(UITextField*)textView{
    
    [self setCurrentEditingTextField:textView];
    
    [cellValues replaceObjectAtIndex:textView.tag withObject:textView.text];
    
    if([textView tag]==6){
        
        [currentEditingTextField setText:[NSString stringWithFormat:NSLocalizedString(@"%@ seconds",nil),[cellValues objectAtIndex:6]]];    
    }else if([textView tag]==9){
        
        [currentEditingTextField setText:[NSString stringWithFormat:@"%@ KB",[cellValues objectAtIndex:9]]];    
    }
}

-(void)onInputSwitchCellUpdate:(UISwitch*)uiSwitch{
    
    [cellValues replaceObjectAtIndex:uiSwitch.tag withObject:[uiSwitch isOn]?@"1":@"0"];
 
    if(currentEditingTextField!=nil){
        [uiSwitch resignFirstResponder];
        [[self currentEditingTextField] becomeFirstResponder];
        [[self currentEditingTextField] resignFirstResponder];
        [self setCurrentEditingTextField:nil];
    }
}

- (void)viewDidLoad {
	
    [super viewDidLoad];
	
	[self.tableView setSectionHeaderHeight:25.f];
	[self.tableView setSectionFooterHeight:5.f];
    
    self.navigationItem.title = NSLocalizedString(@"Settings",nil);
	
	[[self navigationItem] setHidesBackButton:YES];
	
	UIBarButtonItem* cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
																	target:self action:@selector(cancelClick:)];
    
	UIBarButtonItem* doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                  target:self action:@selector(saveClick:)];
	[[self navigationItem] setRightBarButtonItem:doneButton];
	[[self navigationItem] setLeftBarButtonItem:cancelButton];
	[cancelButton release];
	[doneButton release];
}

-(IBAction)saveClick:(id)sender{
    
	if(testingConnection==YES){
		return;
	}
    
    if(currentEditingTextField!=nil){
        [[self currentEditingTextField] resignFirstResponder];
        [self setCurrentEditingTextField:nil];
    }
	
	[self saveConfiguration:currentConfigurationObject];
	
	[currentConfigurationObject saveConfiguration];
	
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)saveConfiguration:(ConfigurationObject*)confObject{

	int currentCellIndex = 0;
    
	[confObject setDescription:[cellValues objectAtIndex:currentCellIndex]];
	
    currentCellIndex++;
	[confObject setHudsonHostname:[cellValues objectAtIndex:currentCellIndex]];
	
    currentCellIndex++;
	[confObject setSuffix:[cellValues objectAtIndex:currentCellIndex]];
	
    currentCellIndex++;
    [confObject setProtocol:[[cellValues objectAtIndex:currentCellIndex] isEqualToString:@"1"]?@"https":@"http"];
	
    currentCellIndex++;
    [confObject setPortNumber:[cellValues objectAtIndex:currentCellIndex]];
	
    currentCellIndex++;
    [confObject setUseXpath:[[cellValues objectAtIndex:currentCellIndex] isEqualToString:@"1"]];
	
    currentCellIndex++;
	[confObject setConnectionTimeout:[[cellValues objectAtIndex:currentCellIndex] intValue]];
    
    currentCellIndex++;
    [confObject setOverrideHudsonURLWithConfiguredOne:[[cellValues objectAtIndex:currentCellIndex] isEqualToString:@"1"]];
    
    currentCellIndex++;
    [confObject setMaxBuildsNumberToLoadAtTime:[[cellValues objectAtIndex:currentCellIndex] intValue]];
    
    currentCellIndex++;
    [confObject setMaxConsoleOutputSize:([[cellValues objectAtIndex:currentCellIndex] intValue]*1024)];
	
    currentCellIndex++;
	[confObject setUsername:[cellValues objectAtIndex:currentCellIndex]];
	
    currentCellIndex++;
	[confObject setPassword:[cellValues objectAtIndex:currentCellIndex]];
}

-(IBAction)cancelClick:(id)sender{
	
	if(testingConnection==YES){
		return;
	}
	
	[self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)manageCloudBeesAccountClick:(id)sender{
    
    if(testingConnection==YES){
		return;
	}
  /*  
    if([[currentConfigurationObject hudsonHostname] rangeOfString:@"cloudbees"].location!=NSNotFound){
        
        CloudBeesValidateActivateView *anotherViewController = [[CloudBeesValidateActivateView alloc] initWithNibName:@"CloudBeesValidateActivateView" bundle:nil andBeesConfiguration:currentConfigurationObject];
        [self.navigationController pushViewController:anotherViewController animated:YES];
        [anotherViewController release];
    }*/
}

-(IBAction)trashClick:(id)sender{
    
	if(testingConnection==YES){
		return;
	}
	
	//ask if sure to remove
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil 
													message:NSLocalizedString(@"Do you really want to remove this instance?",nil)
												   delegate:self cancelButtonTitle:NSLocalizedString(@"No",nil) otherButtonTitles:NSLocalizedString(@"Yes",nil),nil];
	[alert setTag:1];
	[alert show];
	[alert release];
}

-(IBAction)testClick:(id)sender{
    
	if(testingConnection==YES){
		return;
	}
	
	testingConnection = YES;
	
	oldSelectedConfigurationObject = [[Configuration getInstance] selectedConfigurationInstance];
	int testConfIndex = [[[Configuration getInstance] hudsonInstances] count];
	
	testConfigurationObject = [[ConfigurationObject alloc] init];
	[testConfigurationObject setFilename:[NSString stringWithFormat:@"%s_testing",[currentConfigurationObject filename]]]; 
	[[[Configuration getInstance] hudsonInstances] addObject:testConfigurationObject];
	[[Configuration getInstance] saveConfiguration];
	
	[self saveConfiguration:testConfigurationObject];
	
	loadingView = [LoadingView loadingViewInView:[self view] andTitle:NSLocalizedString(@"Connecting...",nil)];
	
	if([testConfigurationObject username]!=nil && [[testConfigurationObject username] length] > 0 && 
	   ([testConfigurationObject password]==nil || [[testConfigurationObject password] length]==0)){
		
		[loadingView removeView];
		
		AlertPrompt *alert = [[AlertPrompt alloc] initWithTitle:NSLocalizedString(@"Insert password",nil) 
														message:@"      "
													   delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel",nil) okButtonTitle:@"OK"];
		[alert setSecureTextEntry:YES];
		[alert show];
		[alert release];
	}else {
		
		[testConfigurationObject saveConfiguration];
		
		[[Configuration getInstance] setSelectedConfigurationInstance:testConfIndex];
		
		if(confTester!=nil){
			[confTester release];
		}
		confTester = [[ConfigurationObjectTester alloc] initWithConfigurationToTest:testConfigurationObject];
		[confTester setDelegate:self];
		[confTester test];
	}
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
	
	switch(buttonIndex) {
		case 0:
		{
			//tag=1 --> remove configuration
			if([alertView tag]==1){
				
				;
				
			}else{
                
				testingConnection = NO;
				
				[testConfigurationObject remove];
				[[[Configuration getInstance] hudsonInstances] removeLastObject];
				[[Configuration getInstance] saveAllConfiguration];
				[[Configuration getInstance] setSelectedConfigurationInstance:oldSelectedConfigurationObject];
			}
		}
			break;
		case 1:
		{
			//tag=1 --> remove configuration
			if([alertView tag]==1){	
				
				if([[[Configuration getInstance] hudsonInstances] count]==1){
                    
					UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil 
																	message:NSLocalizedString(@"You can't remove the last instance",nil)
																   delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
					[alert setTag:1];
					[alert show];
					[alert release];
					return;
					
				}
				
				[currentConfigurationObject remove];
				
				[[[Configuration getInstance] hudsonInstances] removeObject:currentConfigurationObject];
				[[Configuration getInstance] saveAllConfiguration];
				
				[self.navigationController popViewControllerAnimated:YES];
			}else{
                
				loadingView = [LoadingView loadingViewInView:[self view] andTitle:[NSString stringWithFormat:NSLocalizedString(@"Connecting...\n%@",nil),
																				   [testConfigurationObject getCompleteURL]]];
				
				NSString* enteredText = [alertView enteredText];
				int testConfIndex = [[[Configuration getInstance] hudsonInstances] count];
				[testConfigurationObject setPassword:enteredText];
				[testConfigurationObject saveConfiguration];
				
				[[Configuration getInstance] setSelectedConfigurationInstance:testConfIndex-1];
				
                confTester = [[ConfigurationObjectTester alloc] initWithConfigurationToTest:testConfigurationObject];
				[confTester setDelegate:self];
				[confTester test];
			}
			
		}
			break;
	}
}

-(void)configurationTestFailed:(NSString*)errmsg{
    
	[loadingView removeView];
	
	[testConfigurationObject remove];
	[[[Configuration getInstance] hudsonInstances] removeLastObject];
	[[Configuration getInstance] saveAllConfiguration];
	[[Configuration getInstance] setSelectedConfigurationInstance:oldSelectedConfigurationObject];
	
	//alert failure
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Connection FAILED",nil)
													message:errmsg
												   delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
	[alert show];
	[alert release];
	
	testingConnection = NO;
}

-(void)configurationTestPassed:(NSString*)errmsg{
	
	[loadingView removeView];
    
	[testConfigurationObject remove];
	[[[Configuration getInstance] hudsonInstances] removeLastObject];
	[[Configuration getInstance] saveAllConfiguration];
	[[Configuration getInstance] setSelectedConfigurationInstance:oldSelectedConfigurationObject];
	
	//alert ok
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Connection SUCCEEDED",nil)
													message:errmsg
												   delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
	[alert show];
	[alert release];
	
	testingConnection = NO;	
}

#pragma mark Table view methods

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{

    if([self currentEditingTextField]!=nil){
        [[self currentEditingTextField] resignFirstResponder];
        [self setCurrentEditingTextField:nil];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	
	if([indexPath section]==2||
	   [indexPath section]==3){
		return 43.f;
	}else{
        
		return 40.f;
	}
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
	
	if(section==3 || section==2){
		
		return 20.f;
	}else{
		return 30.f;
	}
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
	
	UILabel* label = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
	[label setBackgroundColor:[UIColor lightGrayColor]];
	[label setFont:[UIFont boldSystemFontOfSize:15.f]];
	[label setTextColor:[UIColor whiteColor]];
	
	switch (section) {
		case 0:
		{
			[label setText:NSLocalizedString(@"Network settings",nil)];
		}
			break;
		case 1:
		{
			[label setText:NSLocalizedString(@"Security settings",nil)];
		}
			break;
		case 2:
		case 3:
        case 4:
            [label setBackgroundColor:[UIColor whiteColor]];
			break;
		default:
			break;
	}
	
	return label;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
	return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
	NSInteger count = 0;
	
	switch (section) {
		case 0:
			count = 11;
			break;
		case 1:
			count = 2;
			break;
		case 2:
			count = 1;
			break;	
		case 3:
			count = 1;
			break;	
		case 4:
			count = 1;
			break;				
		default:
			break;
	}
	return count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *inputTableViewCell3=@"InputTableViewCell3";
    static NSString *OnOffCellIdentifier = @"OnOffCell";
	static NSString *PreviewURLCellIdentifier = @"PreviewURLCellIdentifier";
	static NSString *ActionButtonCellIdentifier = @"ActionButtonCell";
	
	UITableViewCell* cell = nil;
    
	switch ([indexPath section]) {
		case 0:
            switch ([indexPath row]) {
                case 0:
                case 1:
                case 2:
                case 4:
                case 6:   
                case 8:
                case 9:
                    cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:inputTableViewCell3];
                    if (cell == nil) {
                        
                        cell = (InputTableViewCell4*) [[[NSBundle mainBundle] loadNibNamed:@"InputTableViewCell4" 
                                                                                     owner:self 
                                                                                   options:nil] objectAtIndex:0];
                        [(InputTableViewCell4*)cell setParent:self];
                        [(InputTableViewCell4*)cell setInputCellUpdateSelector:@selector(onInputCellUpdate:)];
                        [(InputTableViewCell4*)cell setStartEditingSel:@selector(onInputCellStartEditing:)];                         
                    }
                    [[(InputTableViewCell4*)cell textField] setTag:[indexPath row]];
                    break;
                case 3:
                case 5:
                case 7:
                    cell = [tableView dequeueReusableCellWithIdentifier:OnOffCellIdentifier];
                    if (cell == nil) {
                        cell = (OnOffTableViewCell3*) [[[NSBundle mainBundle] loadNibNamed:@"OnOffTableViewCell3" 
                                                                                  owner:self 
                                                                                options:nil] objectAtIndex:0];
                        
                        [(OnOffTableViewCell3*)cell setParent:self];
                        [(OnOffTableViewCell3*)cell setInputCellUpdateSelector:@selector(onInputSwitchCellUpdate:)];
                    }
                    [[(OnOffTableViewCell3*)cell onoffSwitch] setTag:[indexPath row]];
                    break;
                case 10:
                    previewCellToUpdate = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:PreviewURLCellIdentifier];
                    if (previewCellToUpdate == nil) {
                        
                        previewCellToUpdate = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:PreviewURLCellIdentifier] autorelease];
                        [[previewCellToUpdate textLabel] setTextAlignment:UITextAlignmentCenter];
                        [[previewCellToUpdate textLabel] setFont:[UIFont systemFontOfSize:14.f]];
                        [[previewCellToUpdate textLabel] setText:NSLocalizedString(@"<<tap for preview>>",nil)];
                    }
                    cell = previewCellToUpdate;
                    break;
                default:
                    break;
            }
            break;
		case 1:
            switch ([indexPath row]) {
                case 0:
                case 1:
                    cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:inputTableViewCell3];
                    if (cell == nil) {
                        
                        cell = (InputTableViewCell4*) [[[NSBundle mainBundle] loadNibNamed:@"InputTableViewCell4" 
                                                                                     owner:self 
                                                                                   options:nil] objectAtIndex:0];
                        [(InputTableViewCell4*)cell setParent:self];
                        [(InputTableViewCell4*)cell setInputCellUpdateSelector:@selector(onInputCellUpdate:)];
                        [(InputTableViewCell4*)cell setStartEditingSel:@selector(onInputCellStartEditing:)];
                    }
                    [[(InputTableViewCell3*)cell textField] setTag:[indexPath row]+10];
                    break;
                default:
                    break;
            }
            break;
		case 2:
		{
			cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:ActionButtonCellIdentifier];
			if (cell == nil) {
				
				cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ActionButtonCellIdentifier] autorelease];
				[cell setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
			}
            
			UIButton* btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
			[[btn titleLabel]setFont:[UIFont boldSystemFontOfSize:20.f]];
			[btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
			[btn setFrame:CGRectMake(10.f, 0.f, 302.f, 43.f)];
			[btn setTitle:NSLocalizedString(@"Test connection",nil) forState:UIControlStateNormal];
			[btn setBackgroundImage:[UIImage imageNamed: @"graybutton.png"] forState:UIControlStateNormal];
			[btn addTarget:self action:@selector(testClick:) forControlEvents:UIControlEventTouchUpInside];
			[cell addSubview:btn];
		}
			break;
		case 3:
		{
			cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:ActionButtonCellIdentifier];
			if (cell == nil) {
				
				cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ActionButtonCellIdentifier] autorelease];
				[cell setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
			}
			
			UIButton* btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
			[[btn titleLabel ]setFont:[UIFont boldSystemFontOfSize:20.f]];
			[btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
			[btn setFrame:CGRectMake(10.f, 0.f,302.f,43.f)];
			[btn setTitle:NSLocalizedString(@"Delete instance",nil) forState:UIControlStateNormal];
			[btn setBackgroundImage: [UIImage imageNamed: @"redbutton.png"] forState:UIControlStateNormal];
			[btn addTarget:self action:@selector(trashClick:) forControlEvents:UIControlEventTouchUpInside];
			[cell addSubview:btn];
		}
			break;	
		case 4:
		{
			cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:ActionButtonCellIdentifier];
			if (cell == nil) {
				
				cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ActionButtonCellIdentifier] autorelease];
				[cell setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
			}
			
			UIButton* btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
			[[btn titleLabel ]setFont:[UIFont boldSystemFontOfSize:20.f]];
			[btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
			[btn setFrame:CGRectMake(10.f, 0.f,302.f,43.f)];
			[btn setTitle:NSLocalizedString(@"Manage CloudBees Account",nil) forState:UIControlStateNormal];
			[btn setBackgroundImage: [UIImage imageNamed: @"redbutton.png"] forState:UIControlStateNormal];
			[btn addTarget:self action:@selector(manageCloudBeesAccountClick:) forControlEvents:UIControlEventTouchUpInside];
			[cell addSubview:btn];
		}
			break;	            
		default:
			break;
	}
                
    switch ([indexPath section]) {
        case 0:   
            
            switch ([indexPath row]) {
                case 0:
                    [[(InputTableViewCell4*)cell descLabel] setText:[configurationItems objectAtIndex:0]];
                    [[(InputTableViewCell4*)cell textField] setPlaceholder:NSLocalizedString(@"example@sample",nil)];
                    [[(InputTableViewCell4*)cell textField] setText:[cellValues objectAtIndex:0]];                 
                    [[(InputTableViewCell4*)cell textField] setSecureTextEntry:NO];
                    [[(InputTableViewCell4*)cell textField] setAutocapitalizationType:UITextAutocapitalizationTypeNone];
                    [[(InputTableViewCell4*)cell textField] setKeyboardType:UIKeyboardTypeDefault];
                    break;
                case 1:
                    [[(InputTableViewCell4*)cell descLabel] setText:[configurationItems objectAtIndex:1]];
                    [[(InputTableViewCell4*)cell textField] setPlaceholder:NSLocalizedString(@"www.example-ci.org",nil)];
                    [[(InputTableViewCell4*)cell textField] setText:[cellValues objectAtIndex:1]];
                    [[(InputTableViewCell4*)cell textField] setSecureTextEntry:NO];
                    [[(InputTableViewCell4*)cell textField] setAutocapitalizationType:UITextAutocapitalizationTypeNone];
                    [[(InputTableViewCell4*)cell textField] setKeyboardType:UIKeyboardTypeURL];
                    break;
                case 2:
                    [[(InputTableViewCell4*)cell descLabel] setText:[configurationItems objectAtIndex:2]];
                    [[(InputTableViewCell4*)cell textField] setPlaceholder:NSLocalizedString(@"optional url suffix",nil)]; 
                    [[(InputTableViewCell4*)cell textField] setText:[cellValues objectAtIndex:2]];
                    [[(InputTableViewCell4*)cell textField] setSecureTextEntry:NO];
                    [[(InputTableViewCell4*)cell textField] setAutocapitalizationType:UITextAutocapitalizationTypeNone];
                    [[(InputTableViewCell4*)cell textField] setKeyboardType:UIKeyboardTypeURL];
                    break;
                case 3:
                    [[(OnOffTableViewCell3*)cell descLabel] setText:[configurationItems objectAtIndex:3]];
                    [[(OnOffTableViewCell3*)cell onoffSwitch] setOn:[[cellValues objectAtIndex:3] isEqualToString:@"1"]];
                    break;
                case 4:
                    [[(InputTableViewCell4*)cell descLabel] setText:[configurationItems objectAtIndex:4]];
                    [[(InputTableViewCell4*)cell textField] setPlaceholder:NSLocalizedString(@"empty for default port",nil)];                    
                    [[(InputTableViewCell4*)cell textField] setText:[cellValues objectAtIndex:4]];
                    [[(InputTableViewCell4*)cell textField] setSecureTextEntry:NO];
                    [[(InputTableViewCell4*)cell textField] setAutocapitalizationType:UITextAutocapitalizationTypeNone];
                    [[(InputTableViewCell4*)cell textField] setKeyboardType:UIKeyboardTypeNumberPad];
                    break;
                case 5:
                    [[(OnOffTableViewCell3*)cell descLabel] setText:[configurationItems objectAtIndex:5]];
                    [[(OnOffTableViewCell3*)cell onoffSwitch] setOn:[[cellValues objectAtIndex:5] isEqualToString:@"1"]];
                    break;
                case 6:
                    [[(InputTableViewCell4*)cell descLabel] setText:[configurationItems objectAtIndex:6]];
                    [[(InputTableViewCell4*)cell textField] setText:[NSString stringWithFormat:NSLocalizedString(@"%@ seconds",nil),[cellValues objectAtIndex:6]]];
                    [[(InputTableViewCell4*)cell textField] setSecureTextEntry:NO];
                    [[(InputTableViewCell4*)cell textField] setAutocapitalizationType:UITextAutocapitalizationTypeNone];
                    [[(InputTableViewCell4*)cell textField] setKeyboardType:UIKeyboardTypeNumberPad];
                    break;
                case 7:
                    [[(OnOffTableViewCell3*)cell descLabel] setText:[configurationItems objectAtIndex:7]];
                    [[(OnOffTableViewCell3*)cell onoffSwitch] setOn:[[cellValues objectAtIndex:7] isEqualToString:@"1"]];
                    break;
                case 8:
                    [[(InputTableViewCell4*)cell descLabel] setText:[configurationItems objectAtIndex:8]];
                    [[(InputTableViewCell4*)cell textField] setText:[cellValues objectAtIndex:8]];
                    [[(InputTableViewCell4*)cell textField] setSecureTextEntry:NO];
                    [[(InputTableViewCell4*)cell textField] setAutocapitalizationType:UITextAutocapitalizationTypeNone];
                    [[(InputTableViewCell4*)cell textField] setKeyboardType:UIKeyboardTypeNumberPad];
                    break;
                case 9:
                    [[(InputTableViewCell4*)cell descLabel] setText:[configurationItems objectAtIndex:9]];
                    [[(InputTableViewCell4*)cell textField] setText:[NSString stringWithFormat:@"%@ KB",[cellValues objectAtIndex:9]]];
                    [[(InputTableViewCell4*)cell textField] setSecureTextEntry:NO];
                    [[(InputTableViewCell4*)cell textField] setAutocapitalizationType:UITextAutocapitalizationTypeNone];
                    [[(InputTableViewCell4*)cell textField] setKeyboardType:UIKeyboardTypeNumberPad];
                    break;
                default:
                    break;
            }
            
            break;
        case 1:
            switch ([indexPath row]) {
                case 0:
                    [[(InputTableViewCell4*)cell descLabel] setText:[configurationItems objectAtIndex:10]];
                    [[(InputTableViewCell4*)cell textField] setText:[cellValues objectAtIndex:10]];
                    [[(InputTableViewCell4*)cell textField] setSecureTextEntry:NO];
                    [[(InputTableViewCell4*)cell textField] setText:[cellValues objectAtIndex:10]];
                    break;
                case 1:
                    [[(InputTableViewCell4*)cell descLabel] setText:[configurationItems objectAtIndex:11]];
                    [[(InputTableViewCell4*)cell textField] setText:[cellValues objectAtIndex:11]];
                    [[(InputTableViewCell4*)cell textField] setSecureTextEntry:YES];
                    [[(InputTableViewCell4*)cell textField] setText:[cellValues objectAtIndex:11]];
                    break;
            }
            break;
        default:
            break;
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
    if(currentEditingTextField!=nil){
        [[self currentEditingTextField] resignFirstResponder];
        [self setCurrentEditingTextField:nil];
    }
    
	if(indexPath.section==0 && indexPath.row==10){
        
		if(previewCellToUpdate!=nil){			
			ConfigurationObject* confObject = [[ConfigurationObject alloc] init];
			[self saveConfiguration:confObject];
			[[previewCellToUpdate textLabel] setText:[confObject getCompleteURL]];
			[confObject release];
		}
	}
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    
}


- (void)dealloc {
	
    [cellValues release];

	[configurationItems release];

	if(testConfigurationObject!=nil){
		[testConfigurationObject release];
	}
	
	if(confTester!=nil){
		[confTester release];
	}
	
    [super dealloc];
}


@end
