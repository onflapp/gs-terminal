lf := '/tmp/terminal.log'.

term := currentTerminal.
term dumpScrollBuffer:lf.

ws := NSWorkspace sharedWorkspace.
ws openFile:lf.
