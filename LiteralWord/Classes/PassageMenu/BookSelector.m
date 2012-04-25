#import "BookSelector.h"
#import "../BibleUtils/BibleDataBaseController.h"
#import <QuartzCore/QuartzCore.h>

@implementation BookSelector


-(BookSelector *) initWithFrame:(CGRect) f RootView:(id) del Book:(int)bk{ 
    initBook = bk;
    bookData = [[NSArray alloc] initWithArray:[BibleDataBaseController listBibleContents]];
	return [super initWithFrame: f RootView:del];
}

- (void) loadView {

	[super loadView];

	[self loadClearView];
	myHeight = self.view.frame.size.height - 2 * 50;
    myWidth = BOOK_TABLE_WIDTH;

	UIView * viewFrame = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 2 - myWidth / 2 - BOOK_TABLE_BORDER, self.view.frame.size.height / 2 - myHeight / 2 - BOOK_TABLE_BORDER, myWidth + 2*BOOK_TABLE_BORDER, myHeight + 2*BOOK_TABLE_BORDER)];
	viewFrame.autoresizingMask = ( UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleHeight) ; 
	[viewFrame setBackgroundColor: [UIColor SHEET_BLUE]];

	[viewFrame.layer setCornerRadius:8.0f];
	[viewFrame.layer setMasksToBounds:YES];

	[self.view addSubview:viewFrame];
	[viewFrame release];

	UITableView * tableView = [[UITableView alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 2 - myWidth / 2, self.view.frame.size.height / 2 - myHeight / 2, myWidth, myHeight) style:UITableViewStylePlain] ;
	[tableView setDataSource:self];
	[tableView setDelegate:self];
	[tableView setBackgroundColor: [UIColor whiteColor]];
	tableView.autoresizingMask = ( UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleHeight) ; 
    tableView.rowHeight = BOOK_TABLE_ROW_HEIGHT;
	[tableView reloadData];
    [tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:initBook inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
	[self.view addSubview:tableView];	
	[tableView release];


}


#pragma mark Table View Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

	return [bookData count]; 
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"CELL AT %d", indexPath.row);
	static NSString *MyIdentifier = @"MyIdentifier";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    
    // Set up the cell...
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifier] autorelease];
	}
	 
    BookName * book = [bookData objectAtIndex:indexPath.row];
	cell.textLabel.text = book.name;

	cell.accessoryType = UITableViewCellSelectionStyleNone;
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

	[self.rootview selectedbook:[indexPath row] chapter:1];
    [self dismissMyView];
}

- (void) dealloc {
    [bookData release];
    [super dealloc];
}

@end
