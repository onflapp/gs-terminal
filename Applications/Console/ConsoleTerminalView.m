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

  NSUserDefaults* cfg = [NSUserDefaults standardUserDefaults];

  Defaults* prefs = [[Defaults alloc] init];
  [prefs setScrollBackEnabled:NO];
  [prefs setWindowBackgroundColor:[NSColor whiteColor]];
  [prefs setTextNormalColor:[NSColor blackColor]];
  [prefs setTextBoldColor:[NSColor greenColor]];
  [prefs setCursorColor:[NSColor controlBackgroundColor]];
  [prefs setScrollBottomOnInput:NO];
  [prefs setUseBoldTerminalFont:NO];

  [self setCursorStyle:[prefs cursorStyle]];
  [self updateColors:prefs];

  [wrapLines setState:[cfg integerForKey:@"wrap_lines"]];

  return self;
}

- (void) runLogView {
  NSUserDefaults* cfg = [NSUserDefaults standardUserDefaults];
  NSMutableArray* args = [NSMutableArray new];
  NSString* filter = [filterField stringValue];

  [args addObject:[[cfg objectForKey:@"max_lines"]description]];
  
  if ([cfg integerForKey:@"wrap_lines"] == 1) [args addObject:@"1"];
  else [args addObject:@"0"];

  if ([filter length] > 0) {
    [args addObject:filter];
  }

  NSString* vp = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"logview"];
  NSString* exec = [vp stringByAppendingPathComponent:@"start_console.sh"];

  [self clearBuffer:self];

  [pauseButton setTitle:@"Pause"];

  [self runProgram:exec
     withArguments:args
      initialInput:nil];

}

- (void) filter:(id) sender {
  NSUserDefaults* cfg = [NSUserDefaults standardUserDefaults];

  if (sender == wrapLines) {
    [cfg setInteger:[sender state] forKey:@"wrap_lines"];
    [self runLogView];
  }
  else if (sender == pauseButton) {
    if ([self isWaitingForData]) {
      [self ts_sendCString:""];
      [pauseButton setTitle:@"Follow"];
  
      [[self window] makeFirstResponder:self];
    }
    else {
      [self ts_sendCString:"F"];
      [pauseButton setTitle:@"Pause"];
    }
  }
  else if (sender == filterField) {
    [self runLogView];
  }
}

- (BOOL) isWaitingForData {
  NSString* status = [self stringAtPoint:NSMakePoint(5,5) granularity:3];
  if ([status hasPrefix:@"Waiting for data... (interrupt to abort)"]) return YES;
  else return NO;
}

- (void) keyDown:(NSEvent *)e {
  if ([self isWaitingForData]) {
    [self ts_sendCString:""];
    [pauseButton setTitle:@"Follow"];
  }

  [super keyDown:e];
}

- (void) ts_handleXOSC:(NSString *)new_cmd {
  NSLog(@"[%@]", new_cmd);
}

- (void) dealloc {
  [self closeProgram];

  [super dealloc];
}

@end
