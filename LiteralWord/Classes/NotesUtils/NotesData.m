#import "NotesData.h"
#import "NotesEditViewController.h"

@implementation NotesData

@synthesize myNotes = _myNotes;
@synthesize myDB = _myDB;

- (id) init {
    self.myDB = [[NotesDbController alloc] init];
    self.myNotes = [[NSMutableArray alloc] initWithCapacity:10];

    NSArray * tmp = [self.myDB findAllNotes];
    for (NoteEntry * obj in tmp) {
        [self.myNotes addObject:obj];
    }	
    return self;
}

- (void) clear {
	[self.myDB deleteAllNotes];
	[self.myNotes removeAllObjects];
}

- (void) removeFromList:(int) index {

	NoteEntry * note = [self.myNotes objectAtIndex:index];
	[self.myNotes removeObjectAtIndex:index];
	[self.myDB deleteNote:note.rowid];	
}


- (int) findNote:(int) rowid {
   
    int i = 0; 
    for (NoteEntry * obj in self.myNotes) {
        if (obj.rowid == rowid) return i;
        i++;
    }
    
    return -1;
    
}

- (void) addToList:(NoteEntry *) note {
	if (note.rowid != NEW_NOTE) {
	    [self.myDB updateNote:note];
            [self.myNotes replaceObjectAtIndex:[self findNote:note.rowid] withObject:note];
	} else {
            note.rowid = [self.myDB addNote:[note.title UTF8String] Body:[note.body UTF8String]];
            [self.myNotes addObject:note];
        }
}


- (void) addNewNote:(NSString *) title Body:(NSString *) body ID:(int) i {
		
	NoteEntry * entry = [[NoteEntry alloc] initWithTitle:title Body: body ID:i];
	[self addToList:entry];
	[entry release];	

}

- (void) dealloc {
	[self.myDB release];	
	[self.myNotes release];
	[super dealloc];
}


@end
