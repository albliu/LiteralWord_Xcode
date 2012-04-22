#import "SelectorViewController.h"
#import "BibleViewController.h"

#define BOOK_TABLE_FONT_SIZE 16
#define BOOK_TABLE_ROW_HEIGHT 40
#define BOOK_TABLE_WIDTH 200
#define BOOK_TABLE_BORDER 5


@interface BookSelector: SelectorViewController <UITableViewDelegate, UITableViewDataSource> {
	int myHeight;
	int myWidth;
    int initBook;
    NSArray * bookData;

}

-(BookSelector *) initWithFrame:(CGRect) f RootView:(id) del Book:(int)bk;
@end
