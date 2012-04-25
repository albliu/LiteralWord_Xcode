#import "MemoryVersesData.h"

@implementation MemoryVersesData

- (id) init {

    _myDB = [[VersesDataBaseController alloc] initDataBase:DATABASE_MEMVERSE_TABLE];
    NSArray * tmp =  [[NSArray alloc] initWithArray:[self.myDB findAllVerses]];
    _myVerses = [tmp mutableCopy];
    [tmp release];
		
    return self;
}

- (int) existsInVerses:(VerseEntry *) ver {
	return -1;
}


- (NSString *) formatVerses:(NSArray *) arr {
	return [VerseEntry VerseArrayToString:arr];
}

- (void) addToMemoryVerses:(int) book Chapter:(int) chap Verses:(NSArray *) ver Text:(NSString *) txt {

	[self addToVerses:book Chapter:chap Verses:[self formatVerses:ver] Text:txt];	
}

@end
