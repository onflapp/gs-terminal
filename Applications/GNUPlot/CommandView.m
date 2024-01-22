/*
   Project: vim

   Copyright (C) 2022 Free Software Foundation

   Author: Ondrej Florian,,,

   Created: 2022-04-19 08:52:45 +0200 by oflorian

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

#import "CommandView.h"

@implementation CommandView

- (id) initWithFrame:(NSRect) frame {
  [super initWithFrame:frame];

  return self;
}

- (void) runWithFile:(NSString*) path windowID:(NSString*) xid {
  NSMutableArray* args = [NSMutableArray new];
  NSString* td = NSTemporaryDirectory();
  NSString* cf = [NSString stringWithFormat:@"%@/gnuplot-%@.cmd", td, xid];

  ASSIGN(cmdfile, cf);

  [args addObject:xid];
  [args addObject:cf];

  NSString* vp = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"plotview"];
  NSString* exec = [vp stringByAppendingPathComponent:@"start.sh"];

  if (path) {
    [self sendCommand:[NSString stringWithFormat:@"L:%@\n", path]];
  }
  else {
    [self sendCommand:@""];
  }

  NSLog(@">>>%@ %@", exec, args);
  
  [self runProgram:exec
     withArguments:args
      initialInput:nil];
}

- (void) quit:(id) sender {
  //[self ts_sendCString:"\e\e:q!\r"];
  NSDate* limit = [NSDate dateWithTimeIntervalSinceNow:0.1];
  [[NSRunLoop currentRunLoop] runUntilDate: limit];
}

- (void) sendCommand:(NSString*) cmd {
  [cmd writeToFile:cmdfile atomically:NO];
}

- (void)ts_handleXOSC:(NSString *)new_cmd {
  NSLog(@"[%@]", new_cmd);

  if ([new_cmd isEqualToString:@"COPY"]) {
    NSString* path = [NSString stringWithFormat:@"%@-data.png", cmdfile];
    NSLog(@">%@", path);
    NSImage* img = [[NSImage alloc] initWithContentsOfFile:path];
    NSLog(@">%@", img);
      
    if (img) {
      NSPasteboard* pb = [NSPasteboard generalPasteboard];

      [pb declareTypes:[NSArray arrayWithObject:NSTIFFPboardType] owner:nil];
      [pb setData:[img TIFFRepresentation] forType:NSTIFFPboardType];
      [img release];
    }
  }
  else if ([new_cmd isEqualToString:@"SELECTION"]) {
  }
}

- (void) dealloc {
  RELEASE(cmdfile);

  [self closeProgram];

  [super dealloc];
}

@end
