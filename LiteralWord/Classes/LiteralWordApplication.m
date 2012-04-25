#import "LiteralWordApplication.h"
#import "SplitScreenViewController.h"
#import "SingleScreenViewController.h"

@implementation NavViewController

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
}
@end

@implementation LiteralWordApplication
@synthesize window = _window;
@synthesize rootview = _rootview;

- (UIWindow *) window {
	if (_window == nil) 
		_window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
	return _window;
}



- (NavViewController *) rootview {
	if (_rootview == nil) { 
		UIViewController * bibleView;	
		if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
			bibleView = [[SplitScreenViewController alloc] init];
		}
		else {
			bibleView = [[SingleScreenViewController alloc] init];
		}

		_rootview = [[NavViewController alloc] initWithRootViewController: bibleView];
		[bibleView release];
	}
	return _rootview;
}

- (void)applicationDidFinishLaunching:(UIApplication *)application {

	[VersesDataBaseController openDataBase];
	[BibleDataBaseController initBibleDataBase];
	[NotesDbController openDataBase];
	application.statusBarHidden = YES;	

	[self.window addSubview: self.rootview.view];
	[self.window makeKeyAndVisible];
}

- (void)applicationWillTerminate:(UIApplication *)application {
        // Save data if appropriate

        [VersesDataBaseController closeDataBase];
	[BibleDataBaseController closeBibleDataBase];
        [NotesDbController closeDataBase];
}



- (void)dealloc {
	[_rootview release];	
	[_window release];
	[super dealloc];
}
@end

// vim:ft=objc
