//
//  SearchFilterViewController.h
//  LiteralWord
//
//  Created by Albert Liu on 4/22/12.
//

#import <UIKit/UIKit.h>
#import "SearchFilterBook.h"
#import "SearchFilterCategory.h"

@interface SearchFilterViewController : UIViewController {
    SearchFilterCategory * _myCategoryView;
    SearchFilterBook * _myBookView;
}

@property (nonatomic) BOOL filterCategory;
@property (nonatomic, retain) SearchFilterCategory * myCategoryView;
@property (nonatomic, retain) SearchFilterBook * myBookView;

@end
