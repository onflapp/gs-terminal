/*
   Project: HtopGS

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

#import "HtopTerminalView.h"

@implementation HtopTerminalView

- (id) initWithFrame:(NSRect) frame {
  [super initWithFrame:frame];

  Defaults* prefs = [[Defaults alloc] init];
  [prefs setScrollBackEnabled:NO];
  [prefs setWindowBackgroundColor:[NSColor controlBackgroundColor]];
  //[prefs setWindowBackgroundColor:[NSColor whiteColor]];
  [prefs setTextNormalColor:[NSColor blackColor]];
  [prefs setCursorColor:[NSColor controlBackgroundColor]];

  [self setCursorStyle:[prefs cursorStyle]];
  [self updateColors:prefs];

  [self overrideTermColor:3 color:[NSColor colorWithCalibratedHue:0.0 saturation:0.0 brightness:0.5 alpha:1.0]];
  [self overrideTermColor:2 color:[NSColor colorWithCalibratedRed:0.0 green:1.0 blue:0.0 alpha:1.0]];

  return self;
}

- (void) scrollWheel:(NSEvent *)e {
  if ([e buttonNumber] == 4) {
    [self moveLineUp:self];
  }
  if ([e buttonNumber] == 5) {
    [self moveLineDown:self];
  }
}

- (void) printExitMessage {

}

- (void) runHtop {
  [statusField setStringValue:@""];

  NSUserDefaults* config = [NSUserDefaults standardUserDefaults];
  NSMutableArray* args = [NSMutableArray new];
  NSString* filter = [filterField stringValue];

  if ([config integerForKey:@"user_processes"] == 1) {
    [args addObject:@"user"];
  }
  else if ([config integerForKey:@"user_processes"] == 2) {
    [args addObject:@"apps"];
  }
  else {
    [args addObject:@"all"];
  }
  if ([filter length] > 0) {
    [args addObject:filter];
  }

  NSString* vp = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"htopview"];
  NSString* exec = [vp stringByAppendingPathComponent:@"start.sh"];

  [self runProgram:exec
     withArguments:args
      initialInput:nil];

  running = YES;
}

- (void) terminateHtop {
  if (![self isProgramClosed] && running) {
    running = NO;
    NSLog(@"closing");
    [self ts_sendCString:"\e[21~\e[21~"];
    NSDate* limit = [NSDate dateWithTimeIntervalSinceNow:0.3];
    [[NSRunLoop currentRunLoop] runUntilDate: limit];
  }
  [super closeProgram];
}

- (void) kill:(id) sender {
 [self ts_sendCString:"k"];
}

- (void) filter:(id) sender {
  NSUserDefaults* config = [NSUserDefaults standardUserDefaults];

  if (sender == filterField) {
    [self runHtop];
  }
  else if ([sender selectedTag] == 1) {
    [config setInteger:1 forKey:@"user_processes"];
    [self runHtop];
  }
  else if ([sender selectedTag] == 2) {
    [config setInteger:2 forKey:@"user_processes"];
    [self runHtop];
  }
  else {
    [config setInteger:0 forKey:@"user_processes"];
    [self runHtop];
  }
}

- (void) setup:(id) sender {
 [self ts_sendCString:"S"];
}

- (void) movePageDown:(id) sender {
 [self ts_sendCString:""];
}

- (void) movePageUp:(id) sender {
  [self ts_sendCString:""];
}

- (void) moveLineDown:(id) sender {
  [self ts_sendCString:"\e[B"];
}

- (void) moveLineUp:(id) sender {
  [self ts_sendCString:"\e[A"];
}

- (void)mouseUp:(NSEvent *)e {
  [super mouseUp:e];
  NSPoint p = [e locationInWindow];
  p = [self convertPoint:p fromView:nil];

  NSString* str = [self stringAtPoint:p granularity:3];
  [statusField setStringValue:str];
}

- (void) sortBy:(id) sender {
  NSInteger tag = [[sender selectedItem] tag];
  if (tag == 0) {
    [self ts_sendCString:"N"];
  }
  else if (tag == 1) {
    [self ts_sendCString:"P"];
  }
  else if (tag == 2) {
    [self ts_sendCString:"M"];
  }
  else if (tag == 3) {
    [self ts_sendCString:"T"];
  }
}

- (void) pause:(id) sender {
  [self ts_sendCString:"Z"];
}

- (void)ts_handleXOSC:(NSString *)new_cmd {
  NSLog(@"[%@]", new_cmd);
}

- (void) dealloc {
  [self closeProgram];

  [super dealloc];
}

@end
