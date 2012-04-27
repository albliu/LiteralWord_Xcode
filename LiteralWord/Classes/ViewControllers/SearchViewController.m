#import "SearchViewController.h"
#import "BibleViewController.h"



@implementation SearchViewController

int loadedCount;
int currRotation;

- (NSString *) formatResultText : (NSString *) txt {
    
	txt = [txt stringByReplacingOccurrencesOfString:@"<fn>" withString:@"<!--"];
	txt = [txt stringByReplacingOccurrencesOfString:@"</fn>" withString:@"-->"];
	txt = [txt stringByReplacingOccurrencesOfString:@"<h1>" withString:@"<!--"];
	txt = [txt stringByReplacingOccurrencesOfString:@"</h1>" withString:@"-->"];
	txt = [txt stringByReplacingOccurrencesOfString:@"<vn>" withString:@"<!--"];
	txt = [txt stringByReplacingOccurrencesOfString:@"</vn>" withString:@"-->"];
	txt = [txt stringByReplacingOccurrencesOfString:@"<sv>" withString:@"<!--"];
	txt = [txt stringByReplacingOccurrencesOfString:@"</sv>" withString:@"-->"];
    txt = [txt stringByReplacingOccurrencesOfString:@"<p></p>" withString:@""];
	
	NSScanner *scanner = nil; 
	NSString *text = nil;
	scanner = [NSScanner scannerWithString:txt];
    
	// get rid of comments first
	while (![scanner isAtEnd]) 
	{
		[scanner scanUpToString:@"<!--" intoString:NULL];
		[scanner scanUpToString:@"-->" intoString:&text];
		txt = [txt stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@-->", text] withString:@""];
        
	}
	
	scanner = nil;
	text = nil;
	// restart scanner
	scanner = [NSScanner scannerWithString:txt];
	
    
	while (![scanner isAtEnd])
    {
		[scanner scanUpToString:@"<" intoString:NULL];
		[scanner scanUpToString:@">" intoString:&text];
        txt = [txt stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>", text] withString:@""];	
    }
  
    
	return txt;
}




#pragma mark - View lifecycle
- (void) loadView {
	[super loadView];
    currRotation = 0;
	
}

- (void)viewDidLoad
{
 
    [super viewDidLoad];
    
    if (!myTableView && [self.view isKindOfClass:[UITableView class]]) {
        myTableView = (UITableView *) self.view;
    }
    
    
    self.view = [[[UIView alloc] initWithFrame:myTableView.frame] autorelease];
    NSLog(@"frame: %@", NSStringFromCGRect(self.view.frame));
    // a little hackish, but change the width to 320 manually
    mySearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 320, SEARCHBAR_HEIGHT)];
    mySearchBar.delegate = self;
    [mySearchBar becomeFirstResponder];
    [mySearchBar setShowsCancelButton:YES];
    
    myTableView.frame = CGRectMake(0, SEARCHBAR_HEIGHT, myTableView.frame.size.width, myTableView.frame.size.height - SEARCHBAR_HEIGHT);

    
    
    searchData = [[NSMutableArray alloc] initWithCapacity:1];
    loadedCount =0;
    
    
    [self.view addSubview:myTableView];
    [self.view addSubview:mySearchBar];
    
    myTableView.rowHeight = (VERSE_LABEL_HEIGHT + VERSE_TEXT_HEIGHT + 2*CELL_SPACING);
    //self.tableView.tableHeaderView = mySearchBar;
   
    myLoading = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
	myLoading.center = self.view.center;
	[self.view addSubview:myLoading];

    searchFilter = [[SearchFilterViewController alloc] init];
    
    UIBarButtonItem * filter = [[UIBarButtonItem alloc] initWithTitle:@"Filter" style:UIBarButtonItemStylePlain target:self action:@selector(filterView:)];
	self.navigationItem.rightBarButtonItem = filter;
    [filter release];

    [myTableView reloadData];	// populate our table's data
    
}

- (void) viewWillAppear:(BOOL)animated {
    
    
    [self searchBarSearchButtonClicked:mySearchBar];
}

#pragma mark - Table view data source

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
	return NO;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	VerseEntry * entry = [searchResults objectAtIndex:[indexPath row]];
	// we assume search results will always only have 1 verse
    
    NSLog(@"text: %@", entry.text);
	if (entry != nil) {
		[self.delegate selectedbook:entry.book_index chapter:entry.chapter 
						verse:[entry.verses intValue] highlights:[NSArray arrayWithObject:entry.verses]];
	}

	[self.navigationController popToRootViewControllerAnimated:YES];

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{    
    NSString* CellIdentifier = @"resultCell";
    UILabel * textLabel = nil;
    UILabel* verseLabel = nil;
    
    
    //NSLog(@"drawing cell : %d", indexPath.row);
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier: CellIdentifier];
    if ( cell == nil ) 
    {
        cell = [[[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault 
                                       reuseIdentifier: CellIdentifier] autorelease];
        textLabel = [[UILabel alloc] initWithFrame:CGRectMake(CELL_SPACING, VERSE_LABEL_HEIGHT + CELL_SPACING, self.view.frame.size.width - CELL_SPACING, VERSE_TEXT_HEIGHT)]; 
        textLabel.tag = CELLTEXTVIEW;
        textLabel.font = [UIFont systemFontOfSize:VERSE_TEXT_FONT_SIZE];
        //textLabel.lineBreakMode = UILineBreakModeWordWrap;
        textLabel.numberOfLines = 2;
	textLabel.autoresizingMask = (UIViewAutoresizingFlexibleWidth);
        [cell.contentView addSubview: textLabel];
        [textLabel release];
        
        verseLabel = [[[UILabel alloc] initWithFrame: CGRectMake( CELL_SPACING, CELL_SPACING, self.view.frame.size.width - CELL_SPACING, VERSE_LABEL_HEIGHT )] autorelease];
        verseLabel.tag = CELLLABELVIEW; 
        verseLabel.font = [UIFont boldSystemFontOfSize: VERSE_LABEL_FONT_SIZE];
        verseLabel.textAlignment = UITextAlignmentLeft;
        verseLabel.textColor = [UIColor darkTextColor];
        verseLabel.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview: verseLabel];
    }
    else
    {
        textLabel = (UILabel*)[cell.contentView viewWithTag: CELLTEXTVIEW];
        verseLabel = (UILabel*)[cell.contentView viewWithTag: CELLLABELVIEW];
    }
    
    
    VerseEntry * entry = [searchResults objectAtIndex:[indexPath row]];
    verseLabel.text = [NSString stringWithFormat:@"%@ %d:%@", entry.book, entry.chapter,entry.verses ];
    textLabel.text = [self formatResultText:entry.text];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [searchResults count];
}
- (void) clear:(id) ignore {
    mySearchBar.text = nil;
    [searchResults release];
    searchResults = nil;
	[myTableView reloadData];
    [myTableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
}

- (void) enableCancelButton:(UISearchBar *) searchBar {
    for (id subview in [searchBar subviews]) {
        if ([subview isKindOfClass:[UIButton class]]) [subview setEnabled:YES];
    }
}

- (void) searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    
    [searchBar resignFirstResponder];
    [self performSelector:@selector(enableCancelButton:) withObject:searchBar afterDelay:0.0];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{

    NSArray * filter;
    
    [myLoading startAnimating];
    
    if (searchFilter.filterCategory) filter = [searchFilter.myCategoryView filterArray];    
    else filter = [searchFilter.myBookView filterArray];
    
       
    searchResults = [[NSArray alloc] initWithArray:[BibleDataBaseController searchString:[searchBar.text UTF8String] withFilter:filter isCat:searchFilter.filterCategory]];

    [searchBar resignFirstResponder];
  
    [myTableView reloadData];
    
    [myLoading stopAnimating];

}

- (void) searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [self clear:nil];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)activeScrollView {
        [mySearchBar resignFirstResponder];
}

- (void)dealloc {
    [searchData release];
     [mySearchBar release];
    if (searchResults) [searchResults release];
    [searchFilter release];
    [myLoading release];
    [super dealloc];
}


- (void) filterView:(id) ignored {
    [self.navigationController pushViewController:searchFilter animated:YES];
}


@end




