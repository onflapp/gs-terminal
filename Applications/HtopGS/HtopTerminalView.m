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

  return self;
}

- (void) runHtop {
  NSMutableArray* args = [NSMutableArray new];

  NSString* vp = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"htopview"];
  NSString* exec = [vp stringByAppendingPathComponent:@"start.sh"];

  [self runProgram:exec
     withArguments:args
      initialInput:nil];

}

- (void) kill:(id) sender {
 [self ts_sendCString:"k"];
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
  [self ts_sendCString:"\e\ej"];
}

- (void) moveLineUp:(id) sender {
  [self ts_sendCString:"\e\ek"];
}

- (void) quit:(id) sender {
  [self ts_sendCString:"\e\e:q!\r"];
  //NSDate* limit = [NSDate dateWithTimeIntervalSinceNow:0.1];
  //[[NSRunLoop currentRunLoop] runUntilDate: limit];
}

- (void)ts_handleXOSC:(NSString *)new_cmd {
  NSLog(@"[%@]", new_cmd);
}

- (void) dealloc {
  [self closeProgram];

  [super dealloc];
}

@end
