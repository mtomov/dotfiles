# dotfiles

Martin Tomov' dotfiles for Zsh, Ruby, git, ElementaryOS and MacOS.


## Installation

    $ git clone https://github.com:mtomov/dotfiles.git ~/projects/dotfiles
    $ cd ~/projects/dotfiles

    // On MacOS
    $ ./setup/osx/install.sh

    // On ElementaryOS
    $ ./setup/elementary/install.sh

It will install [rcm] and use that to safely symlink the dotfiles, prompting you
if a file already exists (like if you already have `~/.zshrc`).

[rcm]: http://thoughtbot.github.io/rcm/rcm.7.html

## Organization

`rcm` will symlink all files into place, keeping the folder structure relative
to the tag root. However, non-configuration files and folders like `system/`,
`Brewfile`, `README.md`, etc will not be linked because they are in the
`EXCLUDES` section of the [`rcrc`](/rcrc) file.

## Tags

`rcm` has the concept of tags: items under `tag-git/` are in the `git` tag, and
so on. Used for organization.

## Zsh

All of the Zsh configuration is in [`zshrc`](/zshrc).

## Attribution
Started as off Gabriel Berke-Williams's dotfiles. Thank you for the inspiration!

[Gabriel Berke-Williams]: https://github.com/gabebw/dotfiles
