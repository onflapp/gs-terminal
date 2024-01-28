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

  [defaults setObject:[NSNumber numberWithInt:4000] forKey:@"max_lines"];
  
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
  [NSApp setServicesProvider:self];
  
  if([NSApp isScriptingSupported]) {
    [NSApp initializeApplicationScripting];
  }
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

- (void) openDocument: (id)sender {
  NSOpenPanel* panel = [NSOpenPanel openPanel];
  [panel setAllowsMultipleSelection: NO];
  [panel setCanChooseDirectories: NO];

  if ([panel runModalForTypes:nil] == NSOKButton) {
    NSString* fileName = [[panel filenames] firstObject];
    Document* doc = [Document documentForFile:fileName];
    [[doc window] setFrameAutosaveName:@"document_window"];
    [[doc window] makeKeyAndOrderFront:self];
  }
}

- (Document*) currentDocument {
  return [Document lastActiveDocument];
}

- (void) openSystemLog: (id)sender {
  Document* doc = [Document documentForFile:SYSTEMLOG];
  [[doc window] setFrameAutosaveName:@"systemlog_window"];
  [[doc window] makeKeyAndOrderFront:self];
}

- (void) openDesktopLog: (id)sender {
  Document* doc = [Document documentForFile:DESKTOPLOG];
  [[doc window] setFrameAutosaveName:@"desktoplog_window"];
  [[doc window] makeKeyAndOrderFront:self];
}

- (void) openXServerLog: (id)sender {
  NSString* logfileA = @"/var/log/Xorg.0.log";
  NSString* logfileB = [@"~/.local/share/xorg/Xorg.0.log" stringByStandardizingPath];
  Document* doc = nil;

  if ([[NSFileManager defaultManager] fileExistsAtPath:logfileA]) {
    doc = [Document documentForFile:logfileA];
  }
  else if ([[NSFileManager defaultManager] fileExistsAtPath:logfileB]) {
    doc = [Document documentForFile:logfileB];
  }

  if (doc) {
    [[doc window] setFrameAutosaveName:@"xserverlog_window"];
    [[doc window] makeKeyAndOrderFront:self];
  }
}

@end
