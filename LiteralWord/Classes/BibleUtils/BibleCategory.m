//
//  BibleCategory.m
//  LiteralWord
//
//  Created by Albert Liu on 4/22/12.
//

#import "BibleCategory.h"

@implementation BibleCategory

+ (int) getHash: (bibleCategory) book{
    
    switch (book) {
        case All_Bible:
            return 0;
        case Pentateuch:
            return 5;
        case History:
            return 17;
        case Wisdom_and_Poetry:
            return 22;
        case Major_Prophets:
            return 27;
        case Minor_Prophets:
            return 39;
        case Gospels_and_Acts:
            return 44;
        case Paul_Letters:
            return 57;
        case General_Letters:
            return 66;
        default:
            return -1;
    }
}


+ (int) getHashLow: (bibleCategory) book{
    if (book == All_Bible) return 0;
    else return [self getHash: (book - 1)];
}

+ (int) getHashHigh: (bibleCategory) book{
    if (book == All_Bible) return [self getHash:General_Letters];
    else return [self getHash: (book)];
}

+ (NSString *) getName:(bibleCategory)book {
    switch (book) {
        case All_Bible:
            return [NSString stringWithUTF8String:"All"];
        case Pentateuch:
            return [NSString stringWithUTF8String:"Pentateuch"];
        case History:
            return [NSString stringWithUTF8String:"History"];
        case Wisdom_and_Poetry:
            return [NSString stringWithUTF8String:"Wisdom and Poetry"];
        case Major_Prophets:
            return [NSString stringWithUTF8String:"Major Prophets"];
        case Minor_Prophets:
            return [NSString stringWithUTF8String:"Minor Prophets"];
        case Gospels_and_Acts:
            return [NSString stringWithUTF8String:"Gospels and Acts"];
        case Paul_Letters:
            return [NSString stringWithUTF8String:"Paul's Letters"];
        case General_Letters:
            return [NSString stringWithUTF8String:"General Letters"];
        default:
            return [NSString stringWithUTF8String:"NULL"];
    }

}
@end
