#import "../VersesDataBase/VersesData.h"

@protocol VersesTableViewDelegate <NSObject>
- (void) SelectedEntry;
@end

@interface VersesViewController: UITableViewController {
	VersesData * _myData;
    id <VersesTableViewDelegate> rootview;
}
@property (nonatomic, assign) id <VersesTableViewDelegate> rootview;
@property (nonatomic, assign) id delegate;
@property (nonatomic, retain) VersesData * myData;

- (id) initWithDelegate:(id) bibleView Data:(VersesData *) data;
@end
