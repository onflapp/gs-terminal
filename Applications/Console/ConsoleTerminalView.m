/*
   Project: Console

   Copyright (C) 2022 Free Software Foundation

   Author: onflapp

   Created: 2022-04-19 08:52:45 +0200 by onflapp

   This application is free software; you can redistribute it and/or
   modify it under the terms of the GNU General Public
   License as published by the Free Software Foundation; either
   version 2 of the License, or (at your option) any later version.

   This application is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   Library General Public License for more details.

   You should have received a copy of the GNU General Public
   License along with this library; if not, write to the Free
   Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111 USA.
*/

#import "ConsoleTerminalView.h"

@implementation ConsoleTerminalView

- (id) initWithFrame:(NSRect) frame {
  [super initWithFrame:frame];

  Defaults* prefs = [[Defaults alloc] init];
  [prefs setScrollBackEnabled:YES];
  [prefs setWindowBackgroundColor:[NSColor blackColor]];
  [prefs setWindowBackgroundColor:[NSColor whiteColor]];
  [prefs setTextNormalColor:[NSColor grayColor]];
  [prefs setTextNormalColor:[NSColor blackColor]];
  [prefs setCursorColor:[NSColor controlBackgroundColor]];

  [self setCursorStyle:[prefs cursorStyle]];
  [self updateColors:prefs];

  return self;
}

- (void) runLogView {
  NSUserDefaults* config = [NSUserDefaults standardUserDefaults];
  NSMutableArray* args = [NSMutableArray new];
  NSString* filter = [filterField stringValue];

  if ([filter length] > 0) {
    [args addObject:filter];
  }

  NSString* vp = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"logview"];
  NSString* exec = [vp stringByAppendingPathComponent:@"start.sh"];

  [self runProgram:exec
     withArguments:args
      initialInput:nil];

}

- (void) filter:(id) sender {
  NSUserDefaults* config = [NSUserDefaults standardUserDefaults];

  if (sender == filterField) {
    [self runLogView];
  }
}

- (void)ts_handleXOSC:(NSString *)new_cmd {
  NSLog(@"[%@]", new_cmd);
}

- (void) dealloc {
  [self closeProgram];

  [super dealloc];
}

@end
