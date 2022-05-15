# gs-terminal
GNUStep Terminal

Notable changes and features:

# The terminal view as a framework

It makes it much easier to embed terminal application in a GNUstep app or create a wrapper (e.g. see VimGS as an example)

# mouse support

The mouse support is compatible with XTerm
- mouse tracking
- mouse scroll wheel

# Escape codes for changing cursor

Great for vim!

# Escape codes for communication with your wrapper

Send commands back to your GNUstep wrapper

# terminfo file

Although the Terminal is originally based on Linux console terminal, it now includes support for codes used by Xterm and other terminals.

To make sure terminal apps knows about all of its functions, it comes with its own terminfo file which needs to be installed for things to work properly.

`TERM=gsterm`
