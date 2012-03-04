//
//  OptiCadeViewController.m
//  iFBA
//
//  Created by Yohann Magnien on 28/02/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "OptiCadeViewController.h"
#import "BTstack/BTstackManager.h"
#import "BTstack/BTDiscoveryViewController.h"
#import "BTstackManager.h"
#import "OptConGetiCadeViewController.h"
#import "fbaconf.h"

extern int iCadePress;
static int mButtonSelected;

typedef struct {
    char btn_name[16];
    unsigned char dev_btn;
} t_button_map;
t_button_map iCade[10]={
    {"Start",4},
    {"Select/Coin",8},
    {"Menu",0},
    {"Turbo",0},
    {"Fire 1",1},
    {"Fire 2",2},
    {"Fire 3",3},
    {"Fire 4",5},
    {"Fire 5",6},
    {"Fire 6",7},    
};

@implementation OptiCadeViewController
@synthesize tabView;
@synthesize optgetButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title=NSLocalizedString(@"iCade",@"");
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //
    // Change the properties of the imageView and tableView (these could be set
    // in interface builder instead).
    //
    //self.tabView.style=UITableViewStyleGrouped;
    optgetButton=[[OptConGetiCadeViewController alloc] initWithNibName:@"OptConGetiCadeViewController" bundle:nil];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [optgetButton release];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    BTstackManager *bt = [BTstackManager sharedInstance];
    if (ifba_conf.btstack_on&&bt) {
        UIAlertView *aboutMsg=[[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Warning",@"") message:NSLocalizedString(@"Warning iCade BTStack",@"") delegate:self cancelButtonTitle:@"Close" otherButtonTitles:nil] autorelease];
        [aboutMsg show];
    }
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (iCadePress) {
        iCadePress=0;
    }
}

#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
	return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if (section==0) return 10;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *title=nil;
    switch (section) {
        case 0:title=@"";
            break;
    }
    return title;
}


- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    NSString *footer=nil;
    switch (section) {
        case 0://Mapping
            footer=NSLocalizedString(@"Mapping info",@"");
            break;
    }
    return footer;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UILabel *lblview;
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];                
    }
    cell.accessoryType=UITableViewCellAccessoryNone;
    switch (indexPath.section) {
        case 0://Mapping
            cell.textLabel.text=[NSString stringWithFormat:@"%s",iCade[indexPath.row].btn_name];
            lblview=[[UILabel alloc] initWithFrame:CGRectMake(0,0,100,30)];
            lblview.text=[NSString stringWithFormat:@"Button %d",iCade[indexPath.row].dev_btn];
            lblview.backgroundColor=[UIColor clearColor];
            cell.accessoryView=lblview;
            [lblview release];
            break;
    }
    
	
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
            mButtonSelected=indexPath.row;
            [self presentSemiModalViewController:optgetButton];
            [tabView reloadData];            
            break;
    }
}


@end
