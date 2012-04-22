#import "VerseSelector.h"


@implementation VerseSelector


-(void) selectedVerse:(id) sender 
{
	UIButton * buttonView = (UIButton *) sender;
	int verse = buttonView.tag;
	[self.rootview gotoVerse:verse];
	[self dismissMyView];

}


@end
