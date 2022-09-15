/*
  Copyright (c) 2015-2017 Sergii Stoian <stoyan255@gmail.com>

  This program is free software; you can redistribute it and/or modify
  it under the terms of the GNU General Public License as published by
  the Free Software Foundation; either version 2 of the License, or
  (at your option) any later version.

  This program is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU General Public License for more details.

  You should have received a copy of the GNU General Public License
  along with this program; if not, write to the Free Software
  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
*/

#include "ColorsPrefs.h"
#import <TerminalKit/Defaults.h>

@implementation ColorsPrefs


// <PrefsModule>
+ (NSString *)name
{
  return @"Colors";
}

- init
{
  self = [super init];

  [NSBundle loadNibNamed:@"Colors" owner:self];

  return self;
}

- (void)awakeFromNib
{
  [[cursorStyleMatrix cellWithTag:0] setRefusesFirstResponder:YES];
  [[cursorStyleMatrix cellWithTag:1] setRefusesFirstResponder:YES];
  [[cursorStyleMatrix cellWithTag:2] setRefusesFirstResponder:YES];
  [[cursorStyleMatrix cellWithTag:3] setRefusesFirstResponder:YES];
  
  [view retain];
}

- (NSView *)view
{
  return view;
}

- (void)setFont:(id)sender
{
  NSFontManager *fm = [NSFontManager sharedFontManager];
  NSFontPanel   *fp = [fm fontPanel:YES];
  
  [fm setSelectedFont:[fontField font] isMultiple:NO];
  [[view window] setDelegate:self];
  [fp orderFront:self];

 //[[self window] makeFirstResponder:fontField];
}

- (void)changeFont:(id)sender // Font panel callback
{
  NSFont *f = [sender convertFont:[fontField font]];

  if (!f) return;

  [fontField setStringValue:[NSString stringWithFormat: @"%@ %0.1f pt.",
                                      [f fontName], [f pointSize]]];
  [fontField setFont:f];

  return;
}

- (void)showCursorColorPanel:(id)sender
{
  [[NSColorPanel sharedColorPanel] setShowsAlpha:YES];
}

- (void)_updateControls:(Defaults *)defs
{
  //Font
  NSFont* font = [defs terminalFont];
  [fontField setFont:font];
  [fontField setStringValue:[NSString stringWithFormat:@"%@ %.1f pt.",
                                      [font fontName], [font pointSize]]];

  //Window
  [windowBGColorBtn setColor:[defs windowBackgroundColor]];
  [windowSelectionColorBtn setColor:[defs windowSelectionColor]];
  [normalTextColorBtn setColor:[defs textNormalColor]];
  [blinkTextColorBtn setColor:[defs textBlinkColor]];
  [boldTextColorBtn setColor:[defs textBoldColor]];
  
  [inverseTextBGColorBtn setColor:[defs textInverseBackground]];
  [inverseTextFGColor setColor:[defs textInverseForeground]];
  
  [useBoldBtn setState:([defs useBoldTerminalFont] == YES)];

  // Cursor
  [cursorBlinkingBtn setState: [defs isCursorBlinking]];
  [cursorColorBtn setColor:[defs cursorColor]];
  [cursorStyleMatrix selectCellWithTag:[defs cursorStyle]];
}
  
- (void)showWindow
{
  Defaults* defs = [[Defaults alloc] init];
  [self _updateControls:defs];
}

- (void)setWindow:(id)sender
{
  Defaults     *prefs;
  NSDictionary *uInfo;

  if (![sender isKindOfClass:[NSButton class]]) return;
  
  prefs = [[Defaults alloc] init];
  
  [prefs setUseBoldTerminalFont:[useBoldBtn state]?YES:NO];

  // Cursor
  [prefs setCursorBlinking:[cursorBlinkingBtn state]?YES:NO];
  [prefs setCursorColor:[cursorColorBtn color]];
  [prefs setCursorStyle:[[cursorStyleMatrix selectedCell] tag]];

  // Window
  [prefs setWindowBackgroundColor:[windowBGColorBtn color]];
  [prefs setWindowSelectionColor:[windowSelectionColorBtn color]];

  // Text
  [prefs setTextNormalColor:[normalTextColorBtn color]];
  [prefs setTextBlinklColor:[blinkTextColorBtn color]];
  [prefs setTextBoldColor:[boldTextColorBtn color]];
  
  [prefs setTextInverseBackground:[inverseTextBGColorBtn color]];
  [prefs setTextInverseForeground:[inverseTextFGColor color]];

  // Font
  [prefs setTerminalFont:[fontField font]];

  [prefs synchronize];

  [[NSNotificationCenter defaultCenter]
    postNotificationName:TerminalPreferencesDidChangeNotification
                  object:[NSApp delegate]
                userInfo:nil];
}

@end
