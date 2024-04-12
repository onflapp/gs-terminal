/*
  Copyright (c) 2002 Alexander Malmberg <alexander@malmberg.org>
  Copyright (c) 2015-2017 Sergii Stoian <stoyan255@gmail.com>

  This file is a part of Terminal.app. Terminal.app is free software; you
  can redistribute it and/or modify it under the terms of the GNU General
  Public License as published by the Free Software Foundation; version 2
  of the License. See COPYING or main.m for more information.
*/

#ifndef TerminalViewX_h
#define TerminalViewX_h

#import <TerminalKit/TerminalView.h>

@interface TerminalViewX : TerminalView
{
  NSString *currentDir;
}

- initWithPreferences:(id)preferences;
- (NSString*) currentDir;
@end

#endif

