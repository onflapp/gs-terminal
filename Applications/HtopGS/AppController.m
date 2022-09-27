/* 
   Project: HtopGS

   Author: Ondrej Florian,,,

   Created: 2022-09-27 11:42:32 +0200 by oflorian
   
   Application Controller
*/

#import "AppController.h"

@implementation AppController

+ (void) initialize
{
  NSMutableDictionary *defaults = [NSMutableDictionary dictionary];

  /*
   * Register your app's defaults here by adding objects to the
   * dictionary, eg
   *
   * [defaults setObject:anObject forKey:keyForThatObject];
   *
   */
  
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
  [window setFrameAutosaveName:@"terminal_window"];
  [window makeKeyAndOrderFront:self];
  [terminalView runHtop];
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

@end
