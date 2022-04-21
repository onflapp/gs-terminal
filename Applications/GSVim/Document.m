/*
   Project: WebBrowser

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
  [window setFrameAutosaveName:@"document_window"];

  Defaults* defs = [Defaults shared];
  [defs setScrollBackEnabled:NO];
  [defs setWindowBackgroundColor:[NSColor blackColor]];

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

  
/*
  for (NSView* view in [[window contentView] subviews]) {
    if ([view isKindOfClass:[ChromeWebView class]]) {
      webView = view;
      break;
    }
  }
*/
  NSArray* args = nil;
  if (path) args = [NSArray arrayWithObject:path];

  [window makeFirstResponder:terminalView];
  [window makeKeyAndOrderFront:self];

  NSString* vp = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"vimview"];
  NSString* exec = [vp stringByAppendingPathComponent:@"start.sh"];

  [terminalView runProgram:exec
             withArguments:args
              initialInput:nil];

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

- (void) updateTitleBar:(NSNotification*) n {
  NSString* title = [terminalView xtermTitle];
  if (!title) title = @"untitled";

  [window setTitle:title];
}

@end
