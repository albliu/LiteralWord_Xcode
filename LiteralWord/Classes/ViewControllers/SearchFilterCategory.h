//
//  SearchFilterViewController.h
//  LiteralWord
//
//  Created by Albert Liu on 4/22/12.
//

#define FILTER_BUTTON_HEIGHT 35
#define SELECT_BUTTON_TAG 50
#import <UIKit/UIKit.h>

@interface SearchFilterCategory : UITableViewController {
    NSMutableArray * _filterResults;
    NSMutableArray * myData;
}

@property (nonatomic, retain) NSMutableArray * filterResults;
@end
