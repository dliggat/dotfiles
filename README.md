# Dave Liggat's dotfiles

A place to store my dotfiles. Mostly symlink based.


## Home Directory symlinks
```bash
lrwxr-xr-x    1 dliggat  staff      43 29 Aug 20:42 .bash_profile -> /Users/dliggat/git/me/dotfiles/bash_profile
lrwxr-xr-x    1 dliggat  staff      37 29 Aug 20:42 .bashrc -> /Users/dliggat/git/me/dotfiles/bashrc
lrwxr-xr-x    1 dliggat  staff      40 29 Aug 20:42 .gitconfig -> /Users/dliggat/git/me/dotfiles/gitconfig
lrwxr-xr-x    1 dliggat  staff      40 29 Aug 20:42 .gitignore -> /Users/dliggat/git/me/dotfiles/gitignore
lrwxr-xr-x    1 dliggat  staff      36 29 Aug 20:42 .vimrc -> /Users/dliggat/git/me/dotfiles/vimrc
lrwxr-xr-x    1 dliggat  staff      36 30 Aug 21:34 .zshrc -> /Users/dliggat/git/me/dotfiles/zshrc
```

## Sublime symlinks
```bash
$ pwd
/Users/dliggat/Library/Application Support/Sublime Text 3/Packages/User

$ ln -s /Users/dliggat/git/me/dotfiles/Preferences.sublime-settings Preferences.sublime-settings
```
