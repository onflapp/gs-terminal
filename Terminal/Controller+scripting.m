#import "Controller.h"

@implementation Controller(scripting)

- (TerminalWindowController *)newTerminal
{
  TerminalWindowController *twc = [self newWindowWithShell];
  [twc showWindow:self];

  return twc;
}

- (void)runCommand:(NSString*) cmd
{
  [self runProgram:cmd];
}

@end
