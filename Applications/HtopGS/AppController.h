/* 
   Project: HtopGS

   Author: Ondrej Florian,,,

   Created: 2022-09-27 11:42:32 +0200 by oflorian
   
   Application Controller
*/
 
#ifndef _PCAPPPROJ_APPCONTROLLER_H
#define _PCAPPPROJ_APPCONTROLLER_H

#import <AppKit/AppKit.h>
#import "HtopTerminalView.h"

@interface AppController : NSObject
{
  IBOutlet NSWindow* window;
  IBOutlet HtopTerminalView* terminalView;
  IBOutlet NSTextField* statusField;
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

@end

#endif
