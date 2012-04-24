//
//  SearchFilterViewController.m
//  LiteralWord
//
//  Created by Albert Liu on 4/22/12.
//

#import "SearchFilterViewController.h"


@implementation SearchFilterViewController

@synthesize filterCategory;
@synthesize myBookView = _myBookView;
@synthesize myCategoryView = _myCategoryView;

- (SearchFilterCategory *) myCategoryView {
    if (_myCategoryView == nil) {
        _myCategoryView = [[SearchFilterCategory alloc] init];
    }
    return _myCategoryView;
}

- (id) init {
    id me = [super init];
    if (me)  {
        filterCategory = YES;
    }
    return me;
}

- (void) switchFilter {
    
    if (filterCategory) {
        filterCategory = NO;
        self.myBookView = [[SearchFilterBook alloc] initWithCategory:self.myCategoryView.filterResults];
        self.view = self.myBookView.view;
        [self.navigationItem.rightBarButtonItem setTitle:@"Categories"];
        self.navigationItem.title = @"Books";
        
    } else {
        filterCategory = YES;
        self.view = self.myCategoryView.view;
        [self.navigationItem.rightBarButtonItem setTitle:@"Books"];
        self.navigationItem.title = @"Categories";
        [self.myBookView release];
        self.myBookView = nil;
    }
    
}
- (void) loadView {
    [super loadView];
    
    if (filterCategory) self.view = self.myCategoryView.view;
    else {
        self.myBookView = [[SearchFilterBook alloc] initWithCategory:self.myCategoryView.filterResults];
        self.view = self.myBookView.view;
        
    }
    
    self.navigationItem.title = @"Categories";
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    UIBarButtonItem * filter = [[UIBarButtonItem alloc] initWithTitle:@"Books" style:UIBarButtonItemStyleDone target:self action:@selector(switchFilter)];
    
	self.navigationItem.rightBarButtonItem = filter;
	[filter release];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (void) dealloc {
    
    
    [self.myBookView release];
    [self.myCategoryView release];
    [super dealloc];
}
@end
