#import "SelectorViewController.h"


enum {
    BOOK_SELECTOR_VIEW = 600,
    CHAPTER_SELECTOR_VIEW,
};

@interface PassageSelector: SelectorViewController <SelectorViewDelegate> {
	int select_book;
	int select_chapter;
    
    BOOL dismiss;
    
}

-(id) initWithFrame:(CGRect) f RootView:(id) v Book:(int) book Chapter:(int) chapter; 

@end
