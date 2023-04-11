/* 
   Project: vim

   Author: Ondrej Florian,,,

   Created: 2022-04-16 19:27:41 +0200 by oflorian
   
   Application Controller
*/
 
#ifndef _PCAPPPROJ_APPCONTROLLER_H
#define _PCAPPPROJ_APPCONTROLLER_H

#import <AppKit/AppKit.h>
#import "Preferences.h"

@interface AppController : NSObject
{
  Preferences           *preferencesPanel;
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

- (void) openDocument: (id)sender;
- (void) openSystemLog: (id)sender;
- (void) openDesktopLog: (id)sender;

@end

#endif
