//
//  SearchFilterViewController.h
//  LiteralWord
//
//  Created by Albert Liu on 4/22/12.
//

#define FILTER_BUTTON_HEIGHT 35
#define SELECT_BUTTON_TAG 50
#import <UIKit/UIKit.h>

@interface SearchFilterBook : UITableViewController {
    NSMutableArray * _filterResults;
    NSMutableArray * _filterBooks;

    int nCategory;
    NSMutableArray * categoryArray;
}

// these 2 should match up in size 
@property (nonatomic, retain) NSMutableArray * filterResults;
@property (nonatomic, retain) NSMutableArray * filterBooks;

- (id) initWithCategory:(NSArray *) categories;
@end
