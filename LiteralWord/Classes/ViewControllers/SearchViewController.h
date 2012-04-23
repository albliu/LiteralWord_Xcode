#import "VersesViewController.h"
#import "SearchFilterViewController.h"

#define CELL_SPACING 4
#define LOAD_REFRESH_RATE 50 
#define VERSE_LABEL_HEIGHT 10 
#define VERSE_LABEL_FONT_SIZE 10
#define VERSE_TEXT_FONT_SIZE 14
#define VERSE_TEXT_HEIGHT 40 

#define SEARCHBAR_HEIGHT 44
#define CELLTEXTVIEW 300
#define CELLLABELVIEW 301

@interface SearchViewController : VersesViewController <UIWebViewDelegate, UISearchBarDelegate, UITableViewDelegate>
{
    NSMutableArray *searchData;
    NSArray * searchResults;
    UIActivityIndicatorView * myLoading;
    UISearchBar * mySearchBar;
    SearchFilterViewController * searchFilter;
 }

@end
