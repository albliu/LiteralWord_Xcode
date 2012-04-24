//
//  SearchFilterViewController.m
//  LiteralWord
//
//  Created by Albert Liu on 4/22/12.
//

#import "SearchFilterBook.h"
#import "../BibleUtils/BibleDataBaseController.h"
#import "../BibleUtils/BibleCategory.h"

@implementation SearchFilterBook

@synthesize filterBooks = _filterBooks;
@synthesize filterResults = _filterResults;

- (id) initWithCategory:(NSArray *) categories {
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        
        self.filterResults = [[NSMutableArray alloc] initWithCapacity:1];
        self.filterBooks = [[NSMutableArray alloc] initWithCapacity:1];
        for (int i = 0; i < [categories count]; i++) {
            NSNumber * obj = [categories objectAtIndex:i];
            if ([obj boolValue] == NO) continue;
            
            if (categoryArray == nil) categoryArray = [[NSMutableArray alloc] initWithCapacity:1];
            
            // have to add 1 to category since the array index starts at 0
            bibleCategory cat = i + 1;
            [categoryArray addObject:[NSNumber numberWithInt:cat]];
            
            for (int j = [BibleCategory getHashLow:cat] ; j < [BibleCategory getHashHigh:cat]; j++) {
                
                [self.filterBooks addObject:[NSNumber numberWithInt:j]];
                [self.filterResults addObject:[NSNumber numberWithBool:NO]];
                
            }
            
        }
        
        if ([self.filterResults count] == 0) {
            int i = 0;
            for (NSObject * ignore in [BibleDataBaseController listBibleContents]) {
                [self.filterBooks addObject:[NSNumber numberWithInt:i++]];
                [self.filterResults addObject:[NSNumber numberWithBool:NO]];
            }
            
            
        }
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
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    if (categoryArray == nil) return nil;
    
    NSNumber * nCat = [categoryArray objectAtIndex:section];
    
    return [BibleCategory getName:[nCat intValue]];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    if (categoryArray == nil)
        return 1;
     
    return [categoryArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (categoryArray == nil)
        return [self.filterBooks count];
  
    NSNumber * nCat = [categoryArray objectAtIndex:section];
    bibleCategory cat = [nCat intValue];
    
    return ([BibleCategory getHashHigh:cat] - [BibleCategory getHashLow:cat]);
    
}

- (int) getIndexfromPath: (NSIndexPath *) indexPath {
    if (categoryArray == nil) return indexPath.row;
    
    int offset = 0;
    for (int i = 0; i < indexPath.section; i++) {
    
        NSNumber * nCat = [categoryArray objectAtIndex:i];
        bibleCategory cat = [nCat intValue];
        
        offset += ([BibleCategory getHashHigh:cat] - [BibleCategory getHashLow:cat]);
    
    }
    return (offset + indexPath.row);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    NSNumber * book = [self.filterBooks objectAtIndex:[self getIndexfromPath:indexPath]];
    cell.textLabel.text = [BibleDataBaseController getBookNameAt:[book intValue]];
    
    // Configure the cell...
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *thisCell = [tableView cellForRowAtIndexPath:indexPath];
    
    
    if (thisCell.accessoryType == UITableViewCellAccessoryNone) {
        thisCell.accessoryType = UITableViewCellAccessoryCheckmark;
        [self.filterResults replaceObjectAtIndex:[self getIndexfromPath:indexPath] withObject:[NSNumber numberWithBool:YES]];
        
    }else{
        thisCell.accessoryType = UITableViewCellAccessoryNone;
        [self.filterResults replaceObjectAtIndex:[self getIndexfromPath:indexPath] withObject:[NSNumber numberWithBool:NO]];
    }
}


@end
