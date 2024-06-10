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
#include <stdio.h>

void file_write(NSString* path, NSString* txt, BOOL append) {
  FILE* f = fopen([path fileSystemRepresentation], (append?"a":"w"));
  const char *buff = [txt cString];
  int sz = strlen(buff);
  fwrite(buff, 1, sz, f);
  fclose(f);
}

@implementation ConsoleTerminalView

- (id) initWithFrame:(NSRect) frame {
  [super initWithFrame:frame];

  NSUserDefaults* cfg = [NSUserDefaults standardUserDefaults];

  Defaults* prefs = [[Defaults alloc] init];
  [prefs setScrollBackEnabled:NO];
  [prefs setWindowBackgroundColor:[NSColor blackColor]];
  [prefs setTextNormalColor:[NSColor grayColor]];
  [prefs setTextBoldColor:[NSColor whiteColor]];
  //[prefs setCursorColor:[NSColor controlBackgroundColor]];
  //[prefs setUseBoldTerminalFont:NO];
  [prefs setScrollBottomOnInput:NO];
  
  [self setCursorStyle:[prefs cursorStyle]];
  [self updateColors:prefs];

  [wrapLines setState:[cfg integerForKey:@"wrap_lines"]];

  return self;
}

- (void) setLogPath:(NSString*) path {
  [logPath release];
  logPath = [path retain];
}

- (NSString*) liveConsolePath {
  NSString* lf = [NSString stringWithFormat:@"/tmp/console-%d.log", [self programPID]];
  return lf;
}

- (void) runLogView {
  NSUserDefaults* cfg = [NSUserDefaults standardUserDefaults];
  NSMutableArray* args = [NSMutableArray new];
  NSString* filter = [filterField stringValue];

  
  if ([cfg integerForKey:@"wrap_lines"] == 1) [args addObject:@"1"];
  else [args addObject:@"0"];
  
  [args addObject:[[cfg objectForKey:@"max_lines"]description]];

  if ([filter length] > 0) {
    [args addObject:filter];
  }
  else {
    [args addObject:@""];
  }

  NSString* vp = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"logview"];
  NSString* exec = nil;
  
  if ([logPath isEqualToString:DESKTOPLOG]) {
    exec = [vp stringByAppendingPathComponent:@"start_desktoplog.sh"];
  }
  else if ([logPath isEqualToString:SYSTEMLOG]) {
    exec = [vp stringByAppendingPathComponent:@"start_systemlog.sh"];
  }
  else if (logPath) {
    exec = [vp stringByAppendingPathComponent:@"start_less.sh"];
    [args addObject:logPath];
  }

  [self clearBuffer:self];

  [pauseButton setTitle:@"Pause"];

  [self runProgram:exec
     withArguments:args
      initialInput:nil];
}

- (void) appendToTiveConsole:(NSString*) txt {
  NSString* lf = [self liveConsolePath];
  file_write(lf, txt, YES);
}

- (void) writeToTiveConsole:(NSString*) txt {
  NSString* lf = [self liveConsolePath];
  file_write(lf, txt, NO);
}

- (void) mark:(id) sender {
  NSString* ms = [NSString stringWithFormat:@"\e[44m\e[36m=== %ld\e[0m\n", markcount];
  markcount++;
  [self appendToTiveConsole:ms];
}

- (void) clear:(id) sender {
  NSString* ms = @"\n";
  markcount = 0;
  [self writeToTiveConsole:ms];
}

- (void) filter:(id) sender {
  NSUserDefaults* cfg = [NSUserDefaults standardUserDefaults];

  if (sender == wrapLines) {
    [cfg setInteger:[sender state] forKey:@"wrap_lines"];
    [self runLogView];
  }
  else if (sender == pauseButton) {
    if ([self isWaitingForData]) {
      [self ts_sendCString:""];
      [pauseButton setState:1];
  
      [[self window] makeFirstResponder:self];
    }
    else {
      [self ts_sendCString:"F"];
      [pauseButton setState:0];
    }
  }
  else if (sender == filterField) {
    [self runLogView];
  }
}

- (BOOL) isWaitingForData {
  if (mode == 1) return YES;
  else return NO;
}

- (void) scrollWheel: (NSEvent *)e {
  if ([self isWaitingForData]) {
    [self ts_sendCString:""];
    [pauseButton setState:1];
  }

  NSUserDefaults* cfg = [NSUserDefaults standardUserDefaults];
  int i = (int)[cfg integerForKey:@"GSMouseScrollMultiplier"];
  if (i == 0) i = 1;

  if ([e buttonNumber] == 4) {
    [self ts_sendCString:"k" repeat:i];
  }
  else if ([e buttonNumber] == 5) {
    [self ts_sendCString:"j" repeat:i];
  }
}  

- (void) keyDown:(NSEvent *)e {
  if ([self isWaitingForData]) {
    [self ts_sendCString:""];
    [pauseButton setState:1];
  }

  [super keyDown:e];
}

- (void) ts_sendCString:(const char *)msg repeat:(int) r {
  int x;
  for (x = 0; x < r; x++) {
    [self ts_sendCString:msg];
  }
}

- (void) ts_handleXOSC:(NSString *)cmd {
  if ([cmd isEqualToString:@"F"]) {
    mode = 1;
    [pauseButton setState:0];
  }
  else {
    mode = 0;
    [pauseButton setState:1];
  }
}

- (void) dealloc {
  [logPath release];
  [self closeProgram];

  [super dealloc];
}

@end
