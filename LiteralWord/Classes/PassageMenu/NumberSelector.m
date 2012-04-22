#import "NumberSelector.h"
#import <QuartzCore/QuartzCore.h>
#import "BibleViewController.h"
@implementation NumberSelector



- (void) setMyFrames {
	
	if (UIInterfaceOrientationIsLandscape(self.interfaceOrientation)) {
		myWidth = NUMBER_TABLE_LONG;
		myHeight = NUMBER_TABLE_SHORT;
	} else { 
		myWidth = NUMBER_TABLE_SHORT;
		myHeight = NUMBER_TABLE_LONG;
	}

	cols = myWidth / NUMBER_CELL_SIDE;
	rows = num / cols;
	if ( (num % cols) != 0) rows += 1;


}
-(NumberSelector *) initWithFrame:(CGRect) f RootView:(id) del Numbers:(int) v { 

	num = v;
	return [self initWithFrame: f RootView:del];
}

- (void) loadView {

	[super loadView];

	[self setMyFrames];

	[self loadClearView];
	int myheight = ( (myHeight + NUMBER_CELL_SIDE/2) > ( rows * NUMBER_CELL_SIDE) ) ? (rows * NUMBER_CELL_SIDE) : myHeight + NUMBER_CELL_SIDE/2;	
    int mywidth = (num < cols) ? num * NUMBER_CELL_SIDE : myWidth;


	UIView * viewFrame = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 2 - mywidth / 2 - NUMBER_TABLE_BORDER, self.view.frame.size.height / 2 - myheight / 2 - NUMBER_TABLE_BORDER, mywidth + 2*NUMBER_TABLE_BORDER, myheight + 2*NUMBER_TABLE_BORDER)];
	viewFrame.autoresizingMask = ( UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin| UIViewAutoresizingFlexibleBottomMargin) ; 
	[viewFrame setBackgroundColor: [UIColor SHEET_BLUE]];

	[viewFrame.layer setCornerRadius:8.0f];
	[viewFrame.layer setMasksToBounds:YES];

	[self.view addSubview:viewFrame];
	[viewFrame release];

	UITableView * tableView = [[UITableView alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 2 - mywidth / 2, self.view.frame.size.height / 2 - myheight / 2, mywidth, myheight) style:UITableViewStylePlain] ;
	[tableView setDataSource:self];
	[tableView setDelegate:self];
	[tableView setBackgroundColor: [UIColor clearColor]];
	tableView.separatorColor = [UIColor clearColor];
	tableView.autoresizingMask = ( UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin| UIViewAutoresizingFlexibleBottomMargin) ; 
	[tableView reloadData];

	[self.view addSubview:tableView];	
	[tableView release];



}


#pragma mark Table View Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

	return rows; 
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return NUMBER_CELL_SIDE;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *MyIdentifier = @"MyIdentifier";

	int row = indexPath.row;
	UITableViewCell * cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifier] autorelease];
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	[cell setBackgroundColor: [UIColor clearColor]];
	for (int i = 0; i < cols; i++) {
		int value = (row * cols) + i + 1;	
		
		UIButton * tmp = [UIButton buttonWithType:UIButtonTypeCustom];
		tmp.frame = CGRectMake(i*NUMBER_CELL_SIDE, 0, NUMBER_CELL_SIDE, NUMBER_CELL_SIDE);
		tmp.tag = value;
		tmp.backgroundColor = [UIColor whiteColor]; 
        if (value <= num) {
            [tmp setTitle:[NSString stringWithFormat:@"%d", value] forState: UIControlStateNormal];	
            [tmp setTitleColor:[UIColor blackColor] forState: UIControlStateNormal];	
            [tmp addTarget:self action:@selector(selectedVerse:) forControlEvents:UIControlEventTouchUpInside];
        }
		[cell.contentView addSubview:tmp];
	}

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

	// do nothing
	return;
}

-(void) selectedVerse:(id) sender 
{
	
	[self dismissMyView];

}


@end
