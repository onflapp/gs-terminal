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

@implementation NSMutableData (replaceNullChars)

- (void) replaceNullChars {
  char* buff = [self mutableBytes];
  for (NSInteger i = 0; i < [self length];i++) {
    if (*(buff+i) == '\0') {
      *(buff+i) = '\n';
    }
  }
}

@end

@implementation VimTerminalView

- (id) initWithFrame:(NSRect) frame {
  [super initWithFrame:frame];
  mode = '?';

  return self;
}

//ignore mouse selection, use vim selection commands instead
- (void)_setSelection:(struct selection_range)s {
  if (!mouse_tracking) {
    [super _setSelection:s];
  }
}

- (void) runVimWithFile:(NSString*) path {
  NSMutableArray* args = [NSMutableArray new];
  NSString* td = NSTemporaryDirectory();
  NSString* cf = [td stringByAppendingString:[NSString stringWithFormat:@"/VimGS-copy.%lx", [self hash]]];
  NSString* pf = [td stringByAppendingString:[NSString stringWithFormat:@"/VimGS-paste.%lx", [self hash]]];

  copyDataFile = RETAIN(cf);
  pasteDataFile = RETAIN(pf);

  [args addObject:cf];
  [args addObject:pf];

  if (path) [args addObject:path];

  NSString* vp = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"vimview"];
  NSString* exec = [vp stringByAppendingPathComponent:@"start.sh"];

  [self runProgram:exec
     withArguments:args
      initialInput:nil];

  mode = 'n';
}

- (void) help:(id) sender {
  [self ts_sendCString:"\e\e:help\r"];
}

- (void) saveDocument:(id) sender {
  [self ts_sendCString:"\e\e:w\r"];
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

- (void) splitWindow:(id) sender {
  [self ts_sendCString:"\e\e:sp\r"];
}

- (void) closeWindow:(id) sender {
  [self ts_sendCString:"c"];
}

- (void) editAlternative:(id) sender {
  [self ts_sendCString:""];
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
  if (mode == 'v' || mode == 'i') {
    [self ts_sendCString:"\e[1;0C~"];
  }
  else {
    [super copy:sender];
    [self ts_sendCString:"\e"];
  }
}

- (void) paste:(id) sender {
  if (mode == 'v' || mode == 'i' || mode == 'n') {
    NSPasteboard* pb = [NSPasteboard generalPasteboard];
    NSString* txt = [pb stringForType:NSStringPboardType];
    if (txt) {
      [txt writeToFile:pasteDataFile atomically:NO];
      [self ts_sendCString:"\e[1;0P~"];
    }
  }
  else {
    [super paste:sender];
  }
}

- (void) quit:(id) sender {
  [self ts_sendCString:"\e\e:q!\r"];
  NSDate* limit = [NSDate dateWithTimeIntervalSinceNow:0.1];
  [[NSRunLoop currentRunLoop] runUntilDate: limit];
}

- (void)ts_handleXOSC:(NSString *)new_cmd {
  //NSLog(@"[%@]", new_cmd);

  if ([new_cmd isEqualToString:@"COPY"]) {
    NSMutableData* data = [NSMutableData dataWithContentsOfFile:copyDataFile];
    [data replaceNullChars];
    NSString* txt = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];

    NSPasteboard* pb = [NSPasteboard generalPasteboard];

    [pb declareTypes:[NSArray arrayWithObject:NSStringPboardType] owner:nil];
    [pb setString:txt forType:NSStringPboardType];
    [txt release];
  }
  else if ([new_cmd isEqualToString:@"SELECTION"]) {
    NSMutableData* data = [NSMutableData dataWithContentsOfFile:copyDataFile];
    [data replaceNullChars];

    NSString* txt = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];

    ASSIGN(currentSelection, txt);
    [txt release];
  }
  else if ([new_cmd hasPrefix:@"MODE-"]) {
    if ([new_cmd isEqualToString:@"MODE-i"]) {
      mode = 'i';
      [self ts_setMouseTracking:YES];
    }
    else if ([new_cmd hasPrefix:@"MODE-v"] || [new_cmd hasPrefix:@"MODE-V"]) {
      mode = 'v';
      [self ts_setMouseTracking:YES];
    }
    else if ([new_cmd hasPrefix:@"MODE-n"]) {
      mode = 'n';
      [self ts_setMouseTracking:YES];
    }
    else if ([new_cmd hasPrefix:@"MODE-c"]) {
      mode = 'c';
      [self ts_setMouseTracking:NO];
    }
    else {
      mode = '?';
      [self ts_setMouseTracking:NO];
    }
  }
}

- (void) goToLine:(NSInteger) line {
  NSString* txt = [NSString stringWithFormat:@"\e\e:%ld\r", line];
  [self ts_sendCString:[txt UTF8String]];
}

- (id)validRequestorForSendType:(NSString *)st
                     returnType:(NSString *)rt {
  if (mode == 'v') {
    if ([st isEqual:NSStringPboardType]) return self;
  }
  return nil;
}

- (BOOL)writeSelectionToPasteboard:(NSPasteboard *)pb
                             types:(NSArray *)types {

  ASSIGN(currentSelection, @"");
  [self ts_sendCString:"\e[1;0S~"];

  //we should probably loop instead
  NSDate* limit = [NSDate dateWithTimeIntervalSinceNow:0.5];
  [[NSRunLoop currentRunLoop] runUntilDate: limit];

  if ([currentSelection length]) {
    [pb declareTypes:[NSArray arrayWithObject:NSStringPboardType] owner:nil];
    [pb setString:currentSelection forType:NSStringPboardType];
    return YES;
  }
  else {
    return NO;
  }
}

- (void) dealloc {
  [self closeProgram];

  RELEASE(copyDataFile);
  RELEASE(pasteDataFile);
  RELEASE(currentSelection);

  [super dealloc];
}

@end
