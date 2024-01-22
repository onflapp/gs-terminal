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

#import "Preferences.h"
#import "ColorsPrefs.h"

// This class manages key/main window state for FontPanel opening
@implementation PreferencesPanel
- (BOOL)canBecomeMainWindow
{
  return NO;
}
- (void)fontPanelOpened:(BOOL)isOpened
{
  if (isOpened == NO) {
    [mainWindow makeMainWindow];
    [self makeKeyAndOrderFront:mainWindow];
  }
}
@end

@implementation Preferences

static Preferences *shared = nil;

+ shared
{
  if (shared == nil)
    {
      shared = [self new];
    }
  return shared;
}

- init
{
  self = shared = [super init];
  
  prefModules = [NSDictionary dictionaryWithObjectsAndKeys:
                                [ColorsPrefs new], [ColorsPrefs name],
                              nil];
  [prefModules retain];

  mainWindow = [NSApp mainWindow];

  return self;
}

- (void)activatePanel
{
  if (window == nil)
    {
      [NSBundle loadNibNamed:@"PreferencesPanel" owner:self];
    }
  else
    {
      [self switchMode:modeBtn];
    }
  [window makeKeyAndOrderFront:nil];
}

- (void)awakeFromNib
{
  [window setFrameAutosaveName:@"Preferences"];
  [modeBtn selectItemAtIndex:0];
  [self switchMode:modeBtn];
}

- (void)closePanel
{
  [window close];
}

- (void)switchMode:(id)sender
{
  id <PrefsModule> module;
  NSView           *mView;

  module = [prefModules objectForKey:[sender titleOfSelectedItem]];
  mView = [module view];
  if ([modeContentBox contentView] != mView)
    {
      [(NSBox *)modeContentBox setContentView:mView];
    }
  [module showWindow];
}

@end
