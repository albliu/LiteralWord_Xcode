#import "PassageSelector.h"
#import "BibleDataBaseController.h"
#import "BookSelector.h"
#import "ChapterSelector.h"

@implementation PassageSelector

-(id) initWithFrame:(CGRect) f RootView:(id) v Book:(int) book Chapter:(int) chapter { 
		
	select_book = book;
	select_chapter = chapter;	
    selected = NO;
	self.modalPresentationStyle = UIModalPresentationFormSheet;
	return [self initWithFrame:f RootView:v];
}

- (void) loadView {

	[super loadView];
    self.view.frame = myframe;
    BookSelector * myView = [[BookSelector alloc] initWithFrame:myframe RootView:self Book:select_book];
    myView.view.tag = BOOK_SELECTOR_VIEW;
	[self.view addSubview:myView.view];
    //[myView dealloc];
	
}

- (void) commit {
    [self.rootview selectedbook:select_book chapter:select_chapter];
    [self dismissMyView];
}

- (void) selectedbook:(int)bk chapter:(int)ch {
    // if bk = -1, we're coming from chapter selector
    selected = YES;
    
    if (bk == -1) {
        select_chapter = ch;
        // commit
        [self commit];
    } else {
        // book select
        
        select_book = bk;
        int ch_count = [[BibleDataBaseController getBookChapterCountAt:bk] intValue];
        
        
        if (ch_count == 1) {
            select_chapter = 1;
            [self commit];
        } else {
            if (ch_count < select_chapter) {
                select_chapter = ch_count;
            }
            ChapterSelector * myView = [[ChapterSelector alloc] initWithFrame:myframe RootView:self Numbers:ch_count];
            [self.view addSubview:myView.view];
            //[myView dealloc];
        }
    }
    
}

- (void) SelectorViewDismissed {
    [self.rootview SelectorViewDismissed];
    
    if (selected == NO) // side button first
        [self dismissMyView];
    
    selected = NO;
}

@end
