/* 
   Project: vim

   Author: Ondrej Florian,,,

   Created: 2022-04-16 19:27:41 +0200 by oflorian
   
   Application Controller
*/

#import "AppController.h"
#import "Document.h"

#import "STScriptingSupport.h"

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
  NSRange r = [fileName rangeOfString:@":"];
  if (r.location != NSNotFound) {
    NSString* line = [fileName substringFromIndex:r.location+1];

    Document* doc = [self documentForFile:fileName];
    if ([[doc window] isVisible]) {
      [doc showWindow];
      [doc goToLine:[line integerValue]];
    }
    else {
      [doc showWindow];
    }
  }
  else {
    Document* doc = [self documentForFile:fileName];
    [doc showWindow];
  }
  return NO;
}

- (Document*) currentDocument {
  return [Document lastActiveDocument];
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

- (Document*) documentForFile:(NSString*) fileName {
  Document* doc = nil;
  NSString* path = fileName;

  NSRange r = [fileName rangeOfString:@":"];
  if (r.location != NSNotFound) {
    path = [fileName substringToIndex:r.location];
  }

  for (NSWindow* win in [NSApp windows]) {
    if ([[win delegate] isKindOfClass:[Document class]]) {
      doc = (Document*) [win delegate];
      if ([[doc fileName] isEqualToString: path]) {
        return doc;
      }
    }
  }

  doc = [[Document alloc] initWithFile:fileName];
  return doc;
}

- (void) newDocument: (id)sender {
  Document* doc = [[Document alloc] initWithFile:nil];
  [doc showWindow];
}

- (void) openDocument: (id)sender {
  NSOpenPanel* panel = [NSOpenPanel openPanel];
  [panel setAllowsMultipleSelection: NO];
  [panel setCanChooseDirectories: NO];

  if ([panel runModalForTypes:nil] == NSOKButton) {
    NSString* fileName = [[panel filenames] firstObject];
    Document* doc = [self documentForFile:fileName];
    [doc showWindow];
  }
}

@end
