#import "TerminalWindow.h"

@implementation TerminalWindowController(scripting)

- (NSString*) currentDirectory {
  return [tView currentDir];
}

- (void) sendCommandKeys:(NSString*) cmd {
  if ([cmd length]) {
    const char *c = [cmd cString];
    [tView ts_sendCString:c];
  }
}

- (void) runCommand:(NSString*) cmd {
  if (![cmd length]) return;

  NSMutableArray *args;
  NSString *prog;
  
  args = [NSMutableArray
           arrayWithArray:[cmd componentsSeparatedByString:@" "]];

  prog = [args objectAtIndex:0];
  [args removeObjectAtIndex:0];
  
  TerminalView* tv = [self terminalView];
  [tv runProgram:prog withArguments:args initialInput:nil];
}

- (void) dumpScrollBuffer:(NSString*) path {
  if (!path) return;

  [tView writeScrollBufferToFile:path];
}

@end
