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

#import "VimTerminalView.h"

@implementation VimTerminalView

- (id) initWithFrame:(NSRect) frame {
  [super initWithFrame:frame];
  return self;
}

//ignore mouse selection, use vim selection commands instead
- (void)_setSelection:(struct selection_range)s {
}

- (void) help:(id) sender {
  [self ts_sendCString:"\e\e:help\r"];
}

- (void) saveDocument:(id) sender {
  [self ts_sendCString:"\e\e:w\r"];
}

- (void) moveLineDown:(id) sender {
  [self ts_sendCString:"\e\ej"];
}

- (void) moveLineUp:(id) sender {
  [self ts_sendCString:"\e\ek"];
}

- (void) selectAll:(id) sender {
  [self ts_sendCString:"\e\eggVG"];
}

- (void) undo:(id) sender {
  [self ts_sendCString:"\e\eu"];
}

- (void) cut:(id) sender {
  [self ts_sendCString:"\e[1;0X~"];
}

- (void) copy:(id) sender {
  [self ts_sendCString:"\e[1;0C~"];
}

- (void) paste:(id) sender {
  [self ts_sendCString:"\e[1;0P~"];
}

- (void) quit:(id) sender {
  [self ts_sendCString:"\e\e:q\r"];
}

@end
