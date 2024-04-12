/*
  Copyright 2002, 2003 Alexander Malmberg <alexander@malmberg.org>
  Copyright 2005 forkpty replacement, Riccardo Mottola <rmottola@users.sf.net>
  Copyright 2015-2017 Sergii Stoian <stoyan255@gmail.com>

  This file is a part of Terminal.app. Terminal.app is free software; you
  can redistribute it and/or modify it under the terms of the GNU General
  Public License as published by the Free Software Foundation; version 2
  of the License. See COPYING or main.m for more information.
*/

#import <TerminalKit/TerminalKit.h>

#import "TerminalViewX.h"
#import "TerminalWindow.h"

@implementation TerminalViewX

- initWithPreferences:(id)preferences
{
  self = [super initWithPreferences:preferences];
  return self;
}

- initWithFrame:(NSRect)frame
{
  self = [super initWithFrame:frame];
  return self;
}

- dealloc {
  RELEASE(currentDir);
  [super dealloc];
}

// ---
// Drag and drop
// ---
+ (void)registerPasteboardTypes
{
  NSArray *types;
  
  types = [NSArray arrayWithObjects:NSStringPboardType, NSFilenamesPboardType, NSFontPboardType, nil];
  
  [NSApp registerServicesMenuSendTypes:types returnTypes:nil];
}

- (NSString*)_guessFilename:(NSString*) path withSelection:(NSString*) text {
  NSFileManager *fm = [NSFileManager defaultManager];
  BOOL isDir = NO;
  BOOL exists = [fm fileExistsAtPath:path isDirectory:&isDir];
  NSString *sel = [text stringByTrimmingCharactersInSet:
	   [NSCharacterSet whitespaceAndNewlineCharacterSet]];

  if (exists) {
    if (isDir && [sel length]) {
      NSString *p = [path stringByAppendingPathComponent:sel];
      exists = [fm fileExistsAtPath:p isDirectory:&isDir];

      NSLog(@"guessing %@ -> %d", p, exists);
      if (exists) return p;
      else return path;
    }
    else {
      return path;
    }
  }
  else {
    return nil;
  }
}

// ---
// Menu (Edit: Copy, Paste, Select All, Clear Buffer)
// ---
- (BOOL)validateMenuItem:(id <NSMenuItem>)menuItem
{
  NSString *itemTitle = [menuItem title];

  if ([itemTitle isEqualToString:@"Clear Buffer"] && (sb_length <= 0))
    return NO;
  if ([itemTitle isEqualToString:@"Copy"] && (selection.length <= 0))
    return NO;
  if ([itemTitle isEqualToString:@"Paste Selection"] && (selection.length <= 0))
    return NO;
  if ([itemTitle isEqualToString:@"Copy Font"])
    {
      // TODO
    }
  if ([itemTitle isEqualToString:@"Paste Font"])
    {
      NSPasteboard *pb = [NSPasteboard pasteboardWithName:NSFontPboard];
      if ([pb dataForType:NSFontPboardType] == nil)
        return NO;
    }

  return YES;
}

// Menu item "Font > Copy Font"
- (void)copyFont:(id)sender
{
  NSPasteboard *pb = [NSPasteboard pasteboardWithName:NSFontPboard];
  NSDictionary *dict;
  NSData       *data;

  if (pb)
    [pb declareTypes:[NSArray arrayWithObject:NSFontPboardType] owner:nil];
  else
    return;

  // NSLog(@"Copy font to Pasteboard: %@", pb);
  dict = [NSDictionary dictionaryWithObject:font forKey:@"NSFont"];
  if (dict != nil)
    {
      data = [NSArchiver archivedDataWithRootObject:dict];
      if (data != nil)
        {
          [pb setData:data forType:NSFontPboardType];
          // NSLog(@"Terminal: %@ | Font copied: %@", [self deviceName], data);
        }
    }
}

// Menu item "Font > Paste Font"
- (void)pasteFont:(id)sender
{
  NSPasteboard *pb = [NSPasteboard pasteboardWithName:NSFontPboard];
  NSData       *data;
  NSDictionary *dict;

  if (pb)
    data = [pb dataForType:NSFontPboardType];
  else
    return;
  
  if (data)
    dict = [NSUnarchiver unarchiveObjectWithData:data];
  else
    return;
  
  // NSLog(@"TerminalView: %@ pasted font with attributes: %@",
  //       [self deviceName], dict);

  if (dict != nil)
    {
      NSFont *f = [dict objectForKey:@"NSFont"];
      if (f != nil)
        {
          [(TerminalWindowController *)[[self window] delegate]
              setFont:f
              updateWindowSize:YES];
        }
    }
}

- (NSString*) currentDir
{
  return currentDir;
}

- (void)ts_setFilename:(NSString *)path
{
  ASSIGN(currentDir, path);
}

- (void)ts_handleXOSC:(NSString *)new_cmd
{
  NSLog(@"unhandled XOSC command [%@]", new_cmd);
}

- (id)validRequestorForSendType:(NSString *)st
                     returnType:(NSString *)rt
{
  NSString* sel = [self _selectionAsString];

  if (sel && [st isEqual:NSStringPboardType])
    return self;

  if ([currentDir length] && [st isEqual:NSFilenamesPboardType])
    return self;

  return nil;
}

- (BOOL)writeSelectionToPasteboard:(NSPasteboard *)pb
                             types:(NSArray *)t
{
  NSString* currentFilename = currentDir;
  NSString* currentSelection = [self _selectionAsString];

  if ([currentSelection length]) {
    if (currentFilename) {
      NSString *path = [self _guessFilename:currentFilename withSelection:currentSelection];
      if (path) {
        [pb declareTypes:[NSArray arrayWithObjects:NSStringPboardType, NSFilenamesPboardType, nil] owner:nil];
        [pb setString:currentSelection forType:NSStringPboardType];
        [pb setPropertyList:[NSArray arrayWithObject:path] forType:NSFilenamesPboardType];
        return YES;
      }
    }
    [pb declareTypes:[NSArray arrayWithObject:NSStringPboardType] owner:nil];
    [pb setString:currentSelection forType:NSStringPboardType];
    return YES;
  }
  else if (currentFilename) {
    [pb declareTypes:[NSArray arrayWithObject:NSFilenamesPboardType] owner:nil];
    [pb setPropertyList:[NSArray arrayWithObject:currentFilename] forType:NSFilenamesPboardType];
    return YES;
  }
  else {
    return NO;
  }
}

@end
