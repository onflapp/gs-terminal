/* 
   Project: vim

   Author: Ondrej Florian,,,

   Created: 2022-04-16 19:27:41 +0200 by oflorian
   
   Application Controller
*/

#import "AppController.h"
#import "Document.h"

@implementation AppController

+ (void) initialize {
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

- (id) init {
  if ((self = [super init])) {
  }
  return self;
}

- (void) dealloc {
  [super dealloc];
}

- (void) awakeFromNib {
}

- (void) applicationDidFinishLaunching: (NSNotification *)aNotif {
  NSArray* types = [NSArray arrayWithObjects:NSStringPboardType, nil];
  [NSApp registerServicesMenuSendTypes:types returnTypes:nil];
}

- (BOOL) applicationShouldTerminate: (id)sender {
  return YES;
}

- (void) applicationWillTerminate: (NSNotification *)aNotif {
}

- (BOOL) application: (NSApplication *)application openFile: (NSString *)fileName {
  Document* doc = [[Document alloc] initWithFile:fileName];
  [[doc window] setFrameAutosaveName:@"document_window"];
  [[doc window] makeKeyAndOrderFront:self];
  return NO;
}

- (void) showPrefPanel: (id)sender {
  if (preferencesPanel == nil) {
    NSString *bundlePath;
    NSBundle *bundle;

    bundlePath = [[[NSBundle mainBundle] resourcePath]
                     stringByAppendingPathComponent:@"Preferences.bundle"];

    bundle = [[NSBundle alloc] initWithPath:bundlePath];

    preferencesPanel = [[[bundle principalClass] alloc] init];
  }
  [preferencesPanel activatePanel];
}

- (void) newDocument: (id)sender {
  Document* doc = [[Document alloc] initWithFile:nil];
  [[doc window] setFrameAutosaveName:@"document_window"];
  [[doc window] makeKeyAndOrderFront:self];
}

- (void) openDocument: (id)sender {
  NSOpenPanel* panel = [NSOpenPanel openPanel];
  [panel setAllowsMultipleSelection: NO];
  [panel setCanChooseDirectories: NO];

  if ([panel runModalForTypes:nil] == NSOKButton) {
    NSString* fileName = [[panel filenames] firstObject];
    Document* doc = [[Document alloc] initWithFile:fileName];
    [[doc window] setFrameAutosaveName:@"document_window"];
    [[doc window] makeKeyAndOrderFront:self];
  }
}

@end
