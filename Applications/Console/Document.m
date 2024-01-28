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

static NSWindow* _lastMainWindow;
static NSMutableArray* _documents = nil;
+ (void) initialize {
  _documents = [[NSMutableArray alloc] init];
}

+ (Document*) lastActiveDocument {
  return (Document*)[_lastMainWindow delegate];
}

+ (id) documentForFile:(NSString*) path {
  for (Document* doc in _documents) {
    if ([[doc filePath] isEqualToString:path]) {
      return doc;
    }
  }
  
  Document* doc = [[Document alloc] initWithFile:path];
  [_documents addObject:doc];

  return doc;
}

- (id) initWithFile:(NSString*) path {
  self = [super init];

  [NSBundle loadNibNamed:@"Document" owner:self];

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

  if ([path isEqualToString:SYSTEMLOG]) {
    [window setTitle:@"System Log - Console"];
  }
  else if ([path isEqualToString:DESKTOPLOG]) {
    [window setTitle:@"Desktop Log - Console"];
  }
  else {
    [window setTitle:[NSString stringWithFormat:@"%@ - Console", path]];
  }
  
  _filePath = [path retain];

  [terminalView setLogPath:path];
  [terminalView runLogView];

  return self;
}

- (void) dealloc {
  [_documents removeObject:self];
  [_filePath release];

  [[NSNotificationCenter defaultCenter]
    removeObserver:self];

  [super dealloc];
}

- (void) viewBecameIdle:(NSNotification*) n {
  [terminalView closeProgram];
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

- (NSString*) filePath {
  return _filePath;
}

- (void) windowDidBecomeMain:(NSNotification *)notification {
  _lastMainWindow = [self window];
}

- (void) windowWillClose:(NSNotification *)notification {
  [_documents removeObject:self];

  [terminalView closeProgram];

  if (_lastMainWindow == window) _lastMainWindow = nil;

  [window setDelegate: nil];
  [self release];
}

@end
