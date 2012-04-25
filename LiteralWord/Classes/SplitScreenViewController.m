#import "SplitScreenViewController.h"
#import "BibleUtils/BibleUtils.h"


@implementation SplitScreenViewController

@synthesize dualView;
@synthesize bibleView=_bibleView;
@synthesize secbibleView=_secbibleView;
@synthesize searchView=_searchView;

-(SearchViewController *) searchView {

	if (!_searchView) {
		_searchView = [[SearchViewController alloc] initWithDelegate: self.bibleView Data:nil];
		_searchView.title = @"Search"; 
	}
	return _searchView;

}

-(BibleViewController *) bibleView{
	if (!_bibleView) {
		_bibleView = [[BibleViewController alloc] initWithFrame:CGRectMake(BORDER_OFFSET,0, self.view.bounds.size.width - 2*BORDER_OFFSET, self.view.bounds.size.height)];
		_bibleView.myDelegate = self;
	}
	return _bibleView;
}


- (void) setUpToolBar {

	self.navigationController.navigationBar.tintColor = [UIColor SHEET_BLUE ];


	UIBarButtonItem *myhistory = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"history.png"] style:UIBarButtonItemStylePlain target:self action:@selector(subViews:)];
    myhistory.tag = HISTORY_VIEW;
	myhistory.width = 35.0f;


	UIBarButtonItem *bookmark = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"bookmark.png"] style:UIBarButtonItemStylePlain target:self action:@selector(subViews:)];
    bookmark.tag = BOOKMARK_VIEW;
	bookmark.width = 35.0f;


	UIBarButtonItem *memoryverse = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"memory.png"] style:UIBarButtonItemStylePlain target:self action:@selector(subViews:)];
    memoryverse.tag = MEMORYVERSE_VIEW;
	memoryverse.width = 35.0f;

	
	UIBarButtonItem *fullscreen = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"split.png"] style:UIBarButtonItemStylePlain target:self action:@selector(fullscreen:)];
	fullscreen.width = 35.0f;


	UIBarButtonItem *search = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"search.png"] style:UIBarButtonItemStylePlain target:self action:@selector(subViews:)];
    search.tag = SEARCH_VIEW;
	search.width = 35.0f;



	UIBarButtonItem *mynotes = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"edit.png"] style:UIBarButtonItemStylePlain target:self action:@selector(notes:)];
    mynotes.tag = MYNOTE_VIEW;
	mynotes.width = 35.0f;


	self.navigationItem.titleView = self.bibleView.passageTitle;

    
    UIToolbar *tools = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 120.0f, 44.01f)];
	tools.barStyle = -1;
	tools.autoresizingMask = (UIViewAutoresizingFlexibleHeight);
    [tools setItems:[NSArray arrayWithObjects:search, myhistory, bookmark, nil]];
    
    UIBarButtonItem * sidebar = [[UIBarButtonItem alloc] initWithCustomView:tools];
    [tools release];
    self.navigationItem.leftBarButtonItem = sidebar;
    [sidebar release];
    
    tools = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 135.0f, 44.01f)];
	tools.barStyle = -1;
	tools.autoresizingMask = (UIViewAutoresizingFlexibleHeight);
    [tools setItems:[NSArray arrayWithObjects:fullscreen, memoryverse, mynotes, nil]];
    
    sidebar = [[UIBarButtonItem alloc]initWithCustomView:tools];
    [tools release];
    self.navigationItem.rightBarButtonItem = sidebar;
    
    [sidebar release];

	[myhistory release];
	[bookmark release];
	[memoryverse release];
	[fullscreen release];
	[search release];
	[mynotes release];


}


#pragma mark Navigation Bar functions

-(void) allowNavigationController:(BOOL) b {
	if (b) 
		self.navigationController.navigationBar.userInteractionEnabled = YES;
	else
		self.navigationController.navigationBar.userInteractionEnabled = NO;

}

#pragma mark BibleView Delegates

- (VerseEntry *) initPassage {
	return [[history lastPassage] copy];

}
- (void) addToHist:(int) book Chapter:(int) chapter {
	[history addToHistory:book Chapter:chapter];
}

- (void) addToMem:(int) book Chapter:(int) chapter Verses:(NSArray *) ver Text:(NSString *) txt {
	[memory addToMemoryVerses:book Chapter:chapter Verses:ver Text:txt];   

}

- (void) addToBmarks:(int) book Chapter:(int) chapter Verses:(NSArray *) ver {
	[bookmarks addToBookmarks:book Chapter:chapter Verses:ver Text:nil];   
}

- (void) lockScreen {
	[self allowNavigationController:NO];
}

- (void) unLockScreen{
	[self allowNavigationController:YES];
}
#pragma mark - Button Actions

- (void) clearPopovers {
    if (popover_currview != -1) {
        [self SelectedEntry];
    }
    
}

- (void) subViews:(UIBarButtonItem *) but{
    
    BOOL ret = (popover_currview == but.tag);
    [self clearPopovers];
    if (ret) return;
    
    
    VersesViewController * myView;
    switch (but.tag) {
        case SEARCH_VIEW:
            myView = self.searchView;
            break;
        case MEMORYVERSE_VIEW:
            myView = [[[VersesViewController alloc] initWithDelegate:self.bibleView Data:memory] autorelease];
            myView.title = @"Memory Verses"; 
            break;
        case BOOKMARK_VIEW:
            myView = [[[BookmarkViewController alloc] initWithDelegate: self.bibleView Data:bookmarks] autorelease];
            myView.title = @"Bookmarks";
            if (dualView) myView.delegate = self.secbibleView;
            break;
        case HISTORY_VIEW:
            myView = [[[HistoryViewController alloc] initWithDelegate: self.bibleView Data:history] autorelease];
            myView.title = @"History"; 
            if (dualView) myView.delegate = self.secbibleView;
            break;
        default:
            return;
            break;
    }
    
    popover_currview = but.tag;
    myView.rootview = self;
    UINavigationController * navView= [[UINavigationController alloc] initWithRootViewController:myView];
        
    popover = [[UIPopoverController alloc] initWithContentViewController:navView];
    [navView release];
    popover.delegate = self;
    
    [popover presentPopoverFromBarButtonItem:but permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];    
}

-(void) SelectedEntry {
    
    [popover dismissPopoverAnimated:YES];
    [popover release];
    popover = nil;
    popover_currview = -1;
}


- (void) notes:(id)ignored {

    [self clearPopovers];
	NotesViewController * myView = [[[NotesViewController alloc] initWithNotes:notes] autorelease];
	myView.title = @"Notes"; 
	[self.navigationController pushViewController:myView animated:YES];
	

}


- (UIView *) splitscreenSelector {
    
    // figure out what to do with split view
    UIView * mySelector = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 2*PASSAGE_MENU_WIDTH + SPLIT_BUTTON_WIDTH + SPLIT_RIGHT_SPACE, 44.01f)];
    mySelector.autoresizingMask = (UIViewAutoresizingFlexibleHeight);
    
    UIToolbar *tools = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, PASSAGE_MENU_WIDTH, 44.01f)];
    tools.barStyle = -1;
    tools.autoresizingMask = (UIViewAutoresizingFlexibleHeight);	
    
    UIBarButtonItem *flex = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem * leftPassage = [[UIBarButtonItem alloc] initWithCustomView:self.bibleView.passageTitle];
    [self.bibleView.passageTitle.titleLabel setTextAlignment:UITextAlignmentRight];
    [tools setItems:[NSArray arrayWithObjects:flex, leftPassage, nil]];
    [leftPassage release]; 
    [flex release];
    
    [mySelector addSubview:tools];
    [tools release];
    
    UIBarButtonItem * div = flex = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    div.width = SPLIT_BUTTON_WIDTH;
    tools = [[UIToolbar alloc] initWithFrame:CGRectMake(PASSAGE_MENU_WIDTH, 0.0f, SPLIT_BUTTON_WIDTH, 44.01f)];
    tools.barStyle = -1;
    tools.autoresizingMask = (UIViewAutoresizingFlexibleHeight); 
    [tools setItems:[NSArray arrayWithObject:div]];
    [div release];
    
    [mySelector addSubview:tools];
    [tools release];
    
    tools = [[UIToolbar alloc] initWithFrame:CGRectMake(PASSAGE_MENU_WIDTH + SPLIT_BUTTON_WIDTH + SPLIT_RIGHT_SPACE, 0.0f, PASSAGE_MENU_WIDTH, 44.01f)];
    tools.barStyle = -1;
    tools.autoresizingMask = (UIViewAutoresizingFlexibleHeight);	
    
    flex = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    UIBarButtonItem * rightPassage = [[UIBarButtonItem alloc] initWithCustomView:self.secbibleView.passageTitle];
    [self.secbibleView.passageTitle.titleLabel setTextAlignment:UITextAlignmentLeft];
    
    [tools setItems:[NSArray arrayWithObjects:rightPassage, flex, nil]];
    [rightPassage release]; 
    [flex release];
    
    [mySelector addSubview:tools];
    [tools release];

    return [mySelector autorelease];
}

- (void) fullscreen:(id)ignored {


	if (dualView == YES) {
		self.bibleView.view.frame = CGRectMake(BORDER_OFFSET, 0, self.view.bounds.size.width - 2 * BORDER_OFFSET, self.view.bounds.size.height);
        self.secbibleView.view.hidden = YES;
        
        self.navigationItem.titleView = self.bibleView.passageTitle;
        [self.bibleView.passageTitle.titleLabel setTextAlignment:UITextAlignmentCenter];
		
        dualView = NO;
        
        self.searchView.delegate = self.bibleView;
        
        
	} else {
		self.bibleView.view.frame = CGRectMake(BORDER_OFFSET, 0, self.view.bounds.size.width/2 - 2 * BORDER_OFFSET, self.view.bounds.size.height);
        
        if (_secbibleView == nil) {
            _secbibleView = [[BibleViewController alloc] initWithFrame:CGRectMake(self.view.bounds.size.width/2 + BORDER_OFFSET, 0, self.view.bounds.size.width/2 - 2 * BORDER_OFFSET, self.view.bounds.size.height)];
            _secbibleView.myDelegate = self;
            [self.view addSubview:_secbibleView.view];
            
        } else {
            self.secbibleView.view.hidden = NO;
            
        }
        
        self.navigationItem.titleView = [self splitscreenSelector];
        
        dualView = YES;

        self.searchView.delegate = self.secbibleView;

        
    }

}
#pragma mark UIPopoverController delegate
- (BOOL) popoverControllerShouldDismissPopover:(UIPopoverController *)popoverController {
    popover_currview = -1;
    return YES;
}

#pragma mark UIViewController delegate
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // we support rotation in this view controller
    return YES;
}

- (id) init {

    id me = [super init];
    
    if (me) {
        history = [[HistoryData alloc] init];
        bookmarks = [[BookmarkData alloc] init];
        memory = [[MemoryVersesData alloc] init];
        notes = [[NotesData alloc] init];
        dualView = NO;
    }
	return me;
}	

- (void)loadView {

	[super loadView];

	self.view.backgroundColor = [UIColor SHEET_BLUE];

	[self.view addSubview:self.bibleView.view];

    dualView = NO;

}
-(void) viewDidLoad {
	[super viewDidLoad];

	[self setUpToolBar];
}

- (void)dealloc {
	[history release]; 
	[bookmarks release];
	[memory release];
	[notes release];
	[_bibleView release];	
	[_secbibleView release];	
	[_searchView release];	
	[super dealloc];
}


@end

