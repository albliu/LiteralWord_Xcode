#import "PassageSelector.h"
#import "../BibleUtils/BibleDataBaseController.h"
#import "BookSelector.h"
#import "ChapterSelector.h"

@interface PassageSelector() {
    BookSelector * selectBooks;
    ChapterSelector * selectChapters;
}

@end 

@implementation PassageSelector

-(id) initWithFrame:(CGRect) f RootView:(id) v Book:(int) book Chapter:(int) chapter { 
		
    id me = [self initWithFrame:f RootView:v];
    if (me) {
        select_book = book;
        select_chapter = chapter;	
        dismiss = YES;
        //self.modalPresentationStyle = UIModalPresentationFormSheet;
    }
    return me;
}

- (void) loadView {

	[super loadView];
    self.view.frame = myframe;
    selectBooks = [[BookSelector alloc] initWithFrame:myframe RootView:self Book:select_book] ;
    selectBooks.view.tag = BOOK_SELECTOR_VIEW;
	[self.view addSubview:selectBooks.view];
    
	
}

- (void) commit {
    [self.rootview selectedbook:select_book chapter:select_chapter];
    dismiss = YES;
}

- (void) selectedbook:(int)bk chapter:(int)ch {
    // if bk = -1, we're coming from chapter selector
    dismiss = NO;
    
    if (bk == -1) {
        select_chapter = ch;
        // commit
        [self commit];
    } else {
        // book select
        
        select_book = bk;
        int ch_count = [BibleDataBaseController getBookChapterCountAt:bk];
        
        
        if (ch_count == 1) {
            select_chapter = 1;
            [self commit];
        } else {
            if (ch_count < select_chapter) {
                select_chapter = ch_count;
            }
            selectChapters = [[ChapterSelector alloc] initWithFrame:myframe RootView:self Numbers:ch_count];
            [self.view addSubview:selectChapters.view];
            
        }
    }
    
}

- (void) SelectorViewDismissed : (SelectorViewController *) selectorView {
    [selectorView release];
    
    if (dismiss == YES) // side button first
        [self dismissMyView];
    
    dismiss = YES;
}

- (void) dealloc {

/*  
    // these will be dealloced in dismissMyView in BibleViewController    
    [selectBooks release];
    [selectChapters release];
*/  
    [super dealloc];
}
@end
