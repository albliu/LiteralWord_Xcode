#import "ChapterSelector.h"


@implementation ChapterSelector


-(void) selectedVerse:(id) sender 
{
	UIButton * buttonView = (UIButton *) sender;
	int verse = buttonView.tag;
	[self.rootview selectedbook:-1 chapter:verse];
	[self dismissMyView];

}


@end
