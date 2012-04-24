#import "NotesDbController.h"

@interface NotesData : NSObject {

	NSMutableArray * _myNotes;
	NotesDbController * _myDB;

}

@property (nonatomic, retain) NSMutableArray * myNotes;
@property (nonatomic, retain) NotesDbController * myDB;


- (int) addNewNote:(NSString *) title Body:(NSString *) body ID:(int) i; 
- (int) addToList:(NoteEntry *) note; 
- (void) removeFromList:(int) index; 
- (void) clear;
@end
