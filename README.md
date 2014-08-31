# Dave Liggat's dotfiles

A place to store my dotfiles. Mostly symlink based.


## Home Directory symlinks
```bash
lrwxr-xr-x    1 dliggat  staff      43 29 Aug 20:42 .bash_profile -> /Users/dliggat/git/me/dotfiles/bash_profile
lrwxr-xr-x    1 dliggat  staff      37 29 Aug 20:42 .bashrc -> /Users/dliggat/git/me/dotfiles/bashrc
lrwxr-xr-x    1 dliggat  staff      40 29 Aug 20:42 .gitconfig -> /Users/dliggat/git/me/dotfiles/gitconfig
lrwxr-xr-x    1 dliggat  staff      40 29 Aug 20:42 .gitignore -> /Users/dliggat/git/me/dotfiles/gitignore
lrwxr-xr-x    1 dliggat  staff      43 30 Aug 21:57 .shell_common -> /Users/dliggat/git/me/dotfiles/shell_common
lrwxr-xr-x    1 dliggat  staff      36 29 Aug 20:42 .vimrc -> /Users/dliggat/git/me/dotfiles/vimrc
lrwxr-xr-x    1 dliggat  staff      36 30 Aug 21:34 .zshrc -> /Users/dliggat/git/me/dotfiles/zshrc
```

## Sublime symlinks
```bash
$ pwd
/Users/dliggat/Library/Application Support/Sublime Text 2/Packages/User

$ ln -s /Users/dliggat/code/boxen/dotfiles/sublime_text_2/Packages/User/Ruby.sublime-settings Ruby.sublime-settings

$ ls -l
total 48
-rw-r--r--  1 dliggat  staff   4 10 Nov  2013 Default (Linux).sublime-keymap
-rw-r--r--  1 dliggat  staff   4 10 Nov  2013 Default (OSX).sublime-keymap
-rw-r--r--  1 dliggat  staff   4 10 Nov  2013 Default (Windows).sublime-keymap
lrwxr-xr-x  1 dliggat  staff  92 10 Nov  2013 Preferences.sublime-settings -> /Users/dliggat/code/boxen/dotfiles/sublime_text_2/Packages/User/Preferences.sublime-settings
lrwxr-xr-x  1 dliggat  staff  85 14 Aug 12:20 Ruby.sublime-settings -> /Users/dliggat/code/boxen/dotfiles/sublime_text_2/Packages/User/Ruby.sublime-settings
-rw-r--r--  1 dliggat  staff  36 10 Nov  2013 Side Bar.sublime-settings
```
