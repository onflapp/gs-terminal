/* 
   Project: Console

   Author: Ondrej Florian,,,

   Created: 2022-09-27 11:42:32 +0200 by oflorian
   
   Application Controller
*/
 
#ifndef _PCAPPPROJ_APPCONTROLLER_H
#define _PCAPPPROJ_APPCONTROLLER_H

#import <AppKit/AppKit.h>
#import "ConsoleTerminalView.h"

@interface AppController : NSObject
{
  IBOutlet NSWindow* window;
  IBOutlet ConsoleTerminalView* terminalView;
}

+ (void)  initialize;

- (id) init;
- (void) dealloc;

- (void) awakeFromNib;

- (void) applicationDidFinishLaunching: (NSNotification *)aNotif;
- (BOOL) applicationShouldTerminate: (id)sender;
- (void) applicationWillTerminate: (NSNotification *)aNotif;
- (BOOL) application: (NSApplication *)application
	    openFile: (NSString *)fileName;

- (void) showPrefPanel: (id)sender;

- (ConsoleTerminalView*) terminalView;
@end

#endif
