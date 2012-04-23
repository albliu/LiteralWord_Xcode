//
//  SearchFilterViewController.m
//  LiteralWord
//
//  Created by Albert Liu on 4/22/12.
//

#import "SearchFilterBook.h"
#import "../BibleUtils/BibleDataBaseController.h"

@implementation SearchFilterBook

@synthesize filterResults = _filterResults;

- (id)init
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        self.filterResults = [[NSMutableArray alloc] initWithCapacity:1];
        myData = [BibleDataBaseController listBibleContents];
    }
    return self;
}

- (void) loadView {
    [super loadView];
    
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationItem.title = @"Books";
    
    
	UIBarButtonItem * switchCat = [[UIBarButtonItem alloc] initWithTitle:@"Category" style:UIBarButtonItemStyleDone target:self action:@selector(switchCat:)];
    
	self.navigationItem.rightBarButtonItem = switchCat;
	[switchCat release];
    
    
    self.tableView.rowHeight = FILTER_BUTTON_HEIGHT;
    [self.tableView reloadData];
    
    
    
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [myData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    BookName * book = [myData objectAtIndex:indexPath.row];
    cell.textLabel.text = book.name;
    
    // Configure the cell...
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *thisCell = [tableView cellForRowAtIndexPath:indexPath];
    
    
    if (thisCell.accessoryType == UITableViewCellAccessoryNone) {
        thisCell.accessoryType = UITableViewCellAccessoryCheckmark;
        
    }else{
        thisCell.accessoryType = UITableViewCellAccessoryNone;
        
    }
}

- (UITableViewCellAccessoryType)tableView:(UITableView *)tableView accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath {
    
    //add your own code to set the cell accesory type.
    return UITableViewCellAccessoryNone;
}



@end
