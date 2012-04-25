#import "MemoryVersesData.h"

@implementation MemoryVersesData

- (id) init {

    id me = [super init];
    if (me) {
        // super init will have allocated NSArray already;
        [_myVerses release];
        
        _myDB = [[VersesDataBaseController alloc] initDataBase:DATABASE_MEMVERSE_TABLE];
        _myVerses = [[NSMutableArray alloc] initWithArray:[self.myDB findAllVerses]];
    }
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
