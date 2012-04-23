//
//  BibleCategory.h
//  LiteralWord
//
//  Created by Albert Liu on 4/22/12.
//

#import <Foundation/Foundation.h>

typedef enum bookcategory{
    All_Bible = 0, 
    Pentateuch,
    History,
    Wisdom_and_Poetry,
    Major_Prophets,
    Minor_Prophets, 
    Gospels_and_Acts,
    Paul_Letters,
    General_Letters,
    CATEGORY_FILTER_SIZE
} bibleCategory;

    
@interface BibleCategory : NSObject {
}

+ (int) getHashHigh: (bibleCategory) book;
+ (int) getHashLow: (bibleCategory) book;
+ (NSString *) getName:(bibleCategory)book;
@end
