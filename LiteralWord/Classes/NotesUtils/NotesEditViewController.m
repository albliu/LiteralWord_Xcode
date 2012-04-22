//
//  NotesEditViewController.m
//  LiteralWord
//
//  Created by Albert Liu on 4/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NotesEditViewController.h"

enum {
	NOT_NEEDED = 500,
	BOLD_BUTTON = 501,
	ITALICS_BUTTON,
	UNDERLINE_BUTTON,
};

@interface NotesEditViewController (edit) {
}
- (UIToolbar * ) setupEditToolBar; 
@end

@implementation NotesEditViewController(edit) 


- (void) addButtonToToolBar:(NSMutableArray *) toolbar Title:(NSString *) title Tag:(int) t Action:(SEL) act {

	UIBarButtonItem *btn = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStyleBordered target:self action:act];
	btn.width = NOTES_TOOLBAR_HEIGHT;
	btn.tag = t;
	[toolbar addObject:btn];
	[btn release];
}

- (UIToolbar * ) setupEditToolBar {

	UIToolbar* toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0, 0, self.view.frame.size.width, NOTES_TOOLBAR_HEIGHT)]; 
	toolbar.barStyle = UIBarStyleBlackTranslucent;
	toolbar.tintColor = [UIColor grayColor]; 
	toolbar.autoresizingMask = (UIViewAutoresizingFlexibleWidth );
	
	NSMutableArray * items = [[NSMutableArray alloc] initWithCapacity:1];
	
	[self addButtonToToolBar:items Title:@"B" Tag:BOLD_BUTTON Action:@selector(stylin:)];
	[self addButtonToToolBar:items Title:@"I" Tag:ITALICS_BUTTON Action:@selector(stylin:)];
	[self addButtonToToolBar:items Title:@"U" Tag:UNDERLINE_BUTTON Action:@selector(stylin:)];
	UIBarButtonItem *flex = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
	[items addObject:flex];
	[flex release];
		
    
	[toolbar setItems:items];	
	[items release];

	
	return toolbar;

}

- (void) stylin: (id) sender {

	UIBarButtonItem * button = (UIBarButtonItem *) sender;
	
	NSString *jsString;
	BOOL clicked = (button.style == UIBarButtonItemStyleDone) ? YES : NO; 
	
	if (button.tag == BOLD_BUTTON) {
		if (clicked) jsString = [[NSString alloc] initWithUTF8String:"editor.removeBold()"];
		else jsString = [[NSString alloc] initWithUTF8String:"editor.bold()"];
			
	} else if (button.tag == ITALICS_BUTTON) {
		if (clicked) jsString = [[NSString alloc] initWithUTF8String:"editor.removeItalic()"];
		else jsString = [[NSString alloc] initWithUTF8String:"editor.italic()"];

	} else if ( button.tag == UNDERLINE_BUTTON) {
		if (clicked) jsString = [[NSString alloc] initWithUTF8String:"editor.removeUnderline()"];
		else jsString = [[NSString alloc] initWithUTF8String:"editor.underline()"];

	} else {
		return;
	}

	if (clicked) button.style = UIBarButtonItemStyleBordered;
	else button.style = UIBarButtonItemStyleDone;

	[self.editView stringByEvaluatingJavaScriptFromString:jsString];  
	[jsString release];
	

}

- (void) undo:(id) ignored {

	NSString *jsString = [[NSString alloc] initWithUTF8String:"editor.undo()"];
	[self.editView stringByEvaluatingJavaScriptFromString:jsString];  
	[jsString release];
}

- (void) redo:(id) ignored {

	NSString *jsString = [[NSString alloc] initWithUTF8String:"editor.redo()"];
	[self.editView stringByEvaluatingJavaScriptFromString:jsString];  
	[jsString release];
}

@end

@implementation NotesEditViewController

@synthesize editView;   
@synthesize myDelegate;   

-(UIWebView *) editView{
	if (_editView == nil) { 
		_editView = [[UIWebView alloc] initWithFrame:CGRectMake(0, NOTES_TOOLBAR_HEIGHT, self.view.frame.size.width, self.view.frame.size.height)];
		_editView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
		[_editView setDelegate:self];
	}
	return _editView;

}

- (id) initWithFrame :(CGRect) f {
	currNote_id = NEW_NOTE;
	myinitFrame = f;
	return [self init];

}

- (void)loadView {

    [super loadView];
    self.view.frame = myinitFrame;


    [self.view addSubview:self.editView];

    UIToolbar * toolbar = [self setupEditToolBar];
    [self.view addSubview:toolbar]; 
    [toolbar release];
    
   
    UIButton * title = [UIButton buttonWithType:UIButtonTypeCustom]; 
    [title setTitle:@"Click to Change title" forState:UIControlStateNormal];
    [title setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [title.titleLabel setFont: [UIFont systemFontOfSize:14]];
    [title addTarget:self action:@selector(changeTitle:) forControlEvents:UIControlEventTouchUpInside];
    [title sizeToFit];
    title.backgroundColor = [UIColor clearColor];
    self.navigationItem.titleView = title;
    

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    
    [self.editView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"document" ofType:@"html"]isDirectory:NO]]];	
    [self.navigationController setToolbarHidden:YES];
    
    
    UIBarButtonItem *save = [[UIBarButtonItem alloc] initWithTitle:@"save" style:UIBarButtonItemStyleBordered target:self action:@selector(save:)];
    self.navigationItem.rightBarButtonItem = save;
    [save release];
}

- (void) changeTitle:(UIButton *) button {
    UIAlertView *prompt = [[[UIAlertView alloc]initWithTitle:@"Title" message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Done", nil] autorelease];
    [prompt setAlertViewStyle:UIAlertViewStylePlainTextInput];

    [prompt show];

}

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != [alertView cancelButtonIndex])
    {
        UITextField *entered = [(UIAlertView *) alertView textFieldAtIndex:0];
        UIButton * title = (UIButton *) self.navigationItem.titleView;
        [title setTitle:entered.text forState:UIControlStateNormal];
    }
}

- (void) newNote {

    UIButton * title = (UIButton *) self.navigationItem.titleView;
    [title setTitle:@"Click to Change title" forState:UIControlStateNormal];
    currNote_id = NEW_NOTE;
    
    NSString *jsString = [[NSString alloc] initWithFormat:@"editor.setHTML('<div><br></div>')"];
    [self.editView stringByEvaluatingJavaScriptFromString:jsString];  
    [jsString release];

    
    
}
- (void)loadNote:(NoteEntry *)note {

 
   // [[[[UIAlertView alloc] initWithTitle: note.title message:note.body delegate:nil cancelButtonTitle:@"Done" otherButtonTitles:nil] autorelease] show];

       	currNote_id = note.rowid; 
        UIButton * title = (UIButton *) self.navigationItem.titleView;
        [title setTitle:note.title forState:UIControlStateNormal];
        
        NSString *jsString = [[NSString alloc] initWithFormat:@"editor.setHTML(\"%@\")", note.body];
        [self.editView stringByEvaluatingJavaScriptFromString:jsString];  
        [jsString release];



}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void) save:(id) ignored {
    
	NSString *jsString = [[NSString alloc] initWithUTF8String:"editor.getHTML()"];
	NSString * obj = [self.editView stringByEvaluatingJavaScriptFromString:jsString];  
	[jsString release];

    UIButton * title = (UIButton *) self.navigationItem.titleView; 
	[[self myDelegate] saveNote:title.titleLabel.text Body:obj ID:currNote_id];

    [self.editView resignFirstResponder];

    UIAlertView * alert = [[[UIAlertView alloc] initWithTitle:@"Saved" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
    [alert show];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
       NSLog(@"didFinish: %@; stillLoading:%@", [[webView request]URL],
            (webView.loading?@"NO":@"YES"));
}

@end
