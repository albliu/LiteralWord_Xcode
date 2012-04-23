#import "BibleViewController.h"
#import "ViewControllers/ViewControllers.h"
#import "VersesDataBase/VersesDataBase.h"
#import "NotesUtils/NotesUtils.h"

#define BORDER_OFFSET 2

#define PASSAGE_MENU_WIDTH 200
#define SPLIT_BUTTON_WIDTH 15
#define SPLIT_RIGHT_SPACE 8

enum {
    HISTORY_VIEW = 900,
    BOOKMARK_VIEW,
    MEMORYVERSE_VIEW,
    SEARCH_VIEW,
    MYNOTE_VIEW,
    
};
@interface SplitScreenViewController: UIViewController <BibleViewDelegate, UIPopoverControllerDelegate, VersesTableViewDelegate> {
	BibleViewController * _bibleView;
	BibleViewController * _secbibleView;
	SearchViewController * _searchView;

    UIPopoverController * popover;
    int popover_currview;

	NotesData * notes;
	HistoryData * history;
	BookmarkData * bookmarks;
	MemoryVersesData * memory;

}

@property (nonatomic) BOOL dualView;
@property (nonatomic, retain) BibleViewController * bibleView;
@property (nonatomic, retain) BibleViewController * secbibleView;
@property (nonatomic, retain) SearchViewController * searchView;

@end

