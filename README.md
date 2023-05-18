# Terminal

Terminal is the main terminal app for [GNUstep Desktop](https://github.com/onflapp/gs-desktop) but also great way to make a command line utility into GNUstep app.

Terminal's code originally comes from NEXTSPACE's [Terminal.app](https://github.com/trunkmaster/nextspace/tree/master/Applications/Terminal), which in turn comes from [GAP project](https://github.com/gnustep/gap/blob/master/system-apps/Terminal/README) created by Alexander Malmberg.

Notable changes and features:

# The terminal view as a framework

It makes it much easier to embed terminal application in a GNUstep app or create a wrapper (e.g. see VimGS as an example)

# mouse support

The mouse support is compatible with XTerm
- mouse tracking
- mouse scroll wheel

# Escape codes for changing cursor

Great for vim!
cursor blinking

# Special escape codes for inter-process communication

Send commands back to your GNUstep wrapper.

The wrapped program can print special escape sequence in form of `^[]X;<CMD>^G`
where `<CMD>` is a string.

This will cause `- (void)ts_handleXOSC:(NSString *)cmd` to be called on your TerminalView.

Similar approach can be used to communicate the other way around where GNUstep wrapper sends
escape codes (either real or made up ones) to trigger functionality in the wrapped program.

Good example how this could works in practice is VimGS project, `vimrc` file in particular.

# terminfo file

Although the Terminal is originally based on Linux console terminal, it now includes support for codes used by Xterm and other terminals.

To make sure terminal apps knows about all of its functions, it comes with its own terminfo file which needs to be installed for things to work properly.

`TERM=gsterm`
