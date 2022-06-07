/*
   Project: VimGS

   Copyright (C) 2020 Free Software Foundation

   Author: onflapp

   Created: 2020-07-22 12:41:08 +0300 by root

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

#import "Document.h"

@implementation Document
- (id) initWithFile:(NSString*) path {
  self = [super init];
  [NSBundle loadNibNamed:@"Document" owner:self];

  Defaults* defs = [[Defaults alloc] init];
  [defs setScrollBackEnabled:NO];

  [terminalView updateColors:defs];

  [[NSNotificationCenter defaultCenter] 
    addObserver:self
       selector:@selector(updateTitleBar:)
           name:TerminalViewTitleDidChangeNotification
         object:terminalView];

  [[NSNotificationCenter defaultCenter]
    addObserver:self
       selector:@selector(viewBecameIdle:)
           name:TerminalViewBecameIdleNotification
         object:terminalView];

  [[NSNotificationCenter defaultCenter]
    addObserver:self
       selector:@selector(preferencesDidChange:)
           name:TerminalPreferencesDidChangeNotification
         object:[NSApp delegate]];

  [terminalView runVimWithFile:path];

  return self;
}

- (void) dealloc {
  [super dealloc];
}

- (void) goToLine:(NSInteger) line {
  [terminalView goToLine:line];
}

- (void) viewBecameIdle:(NSNotification*) n {
  [window close];
}

- (void) preferencesDidChange:(NSNotification *)notif {
  Defaults* prefs = [[Defaults alloc] init];

  NSFont* font = [prefs terminalFont];
  if (font) {
    [terminalView setFont:font];
    if ([prefs useBoldTerminalFont] == YES)
      [terminalView setBoldFont:[Defaults boldTerminalFontForFont:font]];
    else
      [terminalView setBoldFont:font];
  }
  [terminalView setCursorStyle:[prefs cursorStyle]];
  [terminalView updateColors:prefs];

  [terminalView setNeedsDisplayInRect:[terminalView frame]];
  [[terminalView superview] setFrame:[[terminalView superview] frame]];
}

- (NSWindow*) window {
  return window;
}

- (void) updateTitleBar:(NSNotification*) n {
  NSString* title = [terminalView xtermTitle];
  if (!title) title = @"untitled";

  [window setTitle:title];
}

@end
