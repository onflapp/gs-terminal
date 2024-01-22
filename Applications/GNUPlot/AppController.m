/* 
   Project: GNUPlot

   Author: ,,,

   Created: 2024-01-05 15:51:32 +0100 by pi
   
   Application Controller
*/

#import "AppController.h"
#import "Document.h"

@implementation AppController

+ (void) initialize {
  NSMutableDictionary *defaults = [NSMutableDictionary dictionary];

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
  if([NSApp isScriptingSupported]) {
    [NSApp initializeApplicationScripting];
  }

  [NSApp setServicesProvider:self];
}

- (BOOL) applicationShouldTerminate: (id)sender {
  return YES;
}

- (void) applicationWillTerminate: (NSNotification *)aNotif {
}

- (BOOL) application: (NSApplication *)application openFile: (NSString *)fileName {
  Document* doc = [self documentForFile:fileName];
  [doc showWindow];
  return NO;
}

- (void) plotSelectionService:(NSPasteboard *)pboard
                       userData:(NSString *)userData
                          error:(NSString **)error {
  NSString *text = [pboard stringForType:NSStringPboardType];
  if (!text) return;

  [NSApp activateIgnoringOtherApps:YES];
  Document* doc = [self currentDocument];
  if (!doc) {
    doc = [[Document alloc] initWithFile:nil];
    [doc showWindow];
  }
  [doc performSelector:@selector(plotData:) withObject:text afterDelay:0.3];
}

- (void) evalSelectionService:(NSPasteboard *)pboard
                     userData:(NSString *)userData
                        error:(NSString **)error {
  NSString *text = [pboard stringForType:NSStringPboardType];
  if (!text) return;

  [NSApp activateIgnoringOtherApps:YES];
  Document* doc = [self currentDocument];
  if (!doc) {
    doc = [[Document alloc] initWithFile:nil];
    [doc showWindow];
  }

  [doc performSelector:@selector(evaluateScript:) withObject:text afterDelay:0.5];
}

- (Document*) currentDocument {
  return [Document lastActiveDocument];
}

- (Document*) documentForFile:(NSString*) fileName {
  Document* doc = nil;
  NSString* path = fileName;

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

- (void) showPrefPanel: (id)sender {
}

@end
