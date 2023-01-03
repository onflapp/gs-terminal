/* 
   Project: Console

   Author: Ondrej Florian,,,

   Created: 2022-09-27 11:42:32 +0200 by oflorian
   
   Application Controller
*/

#import "AppController.h"
#import "TerminalFinder.h"

@implementation AppController

+ (void) initialize
{
  NSMutableDictionary *defaults = [NSMutableDictionary dictionary];

  [defaults setObject:[NSNumber numberWithInteger:1000] forKey:@"max_lines"];
  
  [[NSUserDefaults standardUserDefaults] registerDefaults: defaults];
  [[NSUserDefaults standardUserDefaults] synchronize];
}

- (id) init
{
  if ((self = [super init])) {
  }
  return self;
}

- (void) dealloc 
{
  [super dealloc];
}

- (void) awakeFromNib
{
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(viewBecameIdle:)
                                               name:TerminalViewBecameIdleNotification
                                             object:terminalView];
}

- (void) applicationDidFinishLaunching: (NSNotification *)aNotif
{
  [window setFrameAutosaveName:@"console_window"];
  [window makeKeyAndOrderFront:self];
  [terminalView runLogView];
}

- (BOOL) applicationShouldTerminate: (id)sender
{
  return YES;
}

- (void) applicationWillTerminate: (NSNotification *)aNotif
{
  [terminalView closeProgram];
}

- (BOOL) application: (NSApplication *)application
	    openFile: (NSString *)fileName
{
  return NO;
}

- (ConsoleTerminalView*) terminalView
{
  return terminalView;
}

- (void) windowWillClose:(id) not 
{
  [terminalView closeProgram];
  [NSApp terminate:nil];
}

- (void) viewBecameIdle:(id) not 
{
  [terminalView closeProgram];
  [window close];
  [NSApp terminate:nil];
}

- (void) showPrefPanel: (id)sender
{
}

// "Font" menu
- (void)orderFrontFontPanel:(id)sender
{
  NSFontManager *fm = [NSFontManager sharedFontManager];
  TerminalView  *tv = [self terminalView];

  Defaults *prefs = [tv preferences];
  
  [fm setSelectedFont:[prefs terminalFont] isMultiple:NO];
  [fm orderFrontFontPanel:sender];
}

// Larger and Smaller
- (void)modifyFont:(id)sender
{
  NSFontManager *fm = [NSFontManager sharedFontManager];
  TerminalView  *tv = [self terminalView];

  Defaults *prefs = [tv preferences];

  [fm setSelectedFont:[prefs terminalFont] isMultiple:NO];
  [fm modifyFont:sender];

  [self changeFont:nil];
}

- (void)changeFont:(id)sender
{
  NSFontManager *fm = [NSFontManager sharedFontManager];
  TerminalView  *tv = [self terminalView];

  Defaults *prefs = [tv preferences];
  NSFont *font = [fm convertFont:[fm selectedFont]];

  [prefs setTerminalFont:font];
  [tv setFont:font];
  [tv setBoldFont:font];
  [tv setNeedsDisplay:YES];
}

// Edit > Find > Find Panel...
- (void)openFindPanel:(id)sender
{
  [[TerminalFinder sharedInstance] orderFrontFindPanel:self];
}
- (void)findNext:(id)sender
{
  [[TerminalFinder sharedInstance] findNext:self];
}
- (void)findPrevious:(id)sender
{
  [[TerminalFinder sharedInstance] findPrevious:self];
}
- (void)enterSelection:(id)sender
{
  TerminalFinder *finder = [TerminalFinder sharedInstance];
  NSString	 *string;
  TerminalView   *tv;

  tv = [self terminalView];
  string = [[tv stringRepresentation] substringFromRange:[tv selectedRange]];
  [finder setFindString:string];
}
- (void)jumpToSelection:(id)sender
{
  TerminalView *tv;

  tv = [self terminalView];
  [tv scrollRangeToVisible:[tv selectedRange]];
}


@end
