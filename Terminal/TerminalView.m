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

#import "TerminalWindow.h"

@implementation TerminalView (extra)

// ---
// Drag and drop
// ---
+ (void)registerPasteboardTypes
{
  NSArray *types;
  
  types = [NSArray arrayWithObjects:NSStringPboardType, NSFilenamesPboardType, NSFontPboardType, nil];
  
  [NSApp registerServicesMenuSendTypes:types returnTypes:nil];
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

@end
