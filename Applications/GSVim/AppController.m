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
}

- (BOOL) applicationShouldTerminate: (id)sender {
  return YES;
}

- (void) applicationWillTerminate: (NSNotification *)aNotif {
}

- (BOOL) application: (NSApplication *)application openFile: (NSString *)fileName {
  NSInteger x = [fileName rangeOfString:@":"].location;
  NSInteger line = -1;
  if (x != NSNotFound) {
    line = [[fileName substringFromIndex:x+1] integerValue];
    fileName = [fileName substringToIndex:x];
  }

  Document* doc = [[Document alloc] initWithFile:fileName];
  NSLog(@"file name: %@ line:%ld", fileName, line);
  return NO;
}

- (void) showPrefPanel: (id)sender {
}

- (void) newDocument: (id)sender {
  Document* doc = [[Document alloc] initWithFile:nil];
}

- (void) openDocument: (id)sender {
  NSOpenPanel* panel = [NSOpenPanel openPanel];
  [panel setAllowsMultipleSelection: NO];
  [panel setCanChooseDirectories: NO];

  if ([panel runModalForTypes:nil] == NSOKButton) {
    NSString* fileName = [[panel filenames] firstObject];
    Document* doc = [[Document alloc] initWithFile:fileName];
  }
}

@end
