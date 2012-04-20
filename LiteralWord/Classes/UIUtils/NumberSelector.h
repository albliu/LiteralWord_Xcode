#import "SelectorViewController.h"


#define NUMBER_TABLE_SHORT 200 
#define NUMBER_TABLE_LONG 200
#define NUMBER_CELL_SIDE 40
#define NUMBER_TABLE_BORDER 5

@interface NumberSelector: SelectorViewController <UITableViewDelegate, UITableViewDataSource> {
	int myHeight;
	int myWidth;
	int cols;
	int rows;
	int num;
}

-(NumberSelector *) initWithFrame:(CGRect) f RootView:(id) del Numbers:(int) v ;
@end
