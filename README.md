# SuperHooks

***SuperHooks*** is a quick way to have hooks apply across multiple projects.
It allows you to decouple the hooks you use from the projects you use them in by pacing the hooks into separate folders.

Hooks are defined at three levels:

  * Global hooks  : hooks available everywhere
  * User hooks    : hooks used for your own user
  * Project hooks : hooks used only for a project

Once a hook gets invoked from `git`, all the different types of hook will run.

## Installation

```bash
brew tap frankywahl/tap
brew install frankywahl/tap/super_hooks
```

### Installation from source

#### Requirements

  * [go](https://golang.org): to install it yourself from source

#### Procedure

```bash
make install
```

This will create a binary tagged with the commit you're currently on

## Usage

Install `super_hooks` into a git repository:

```bash
super_hooks install
```

List the current hooks:

``` bash
super_hooks list
```

See the other options with:

```bash
super_hooks help
```

### Creating hooks

#### Locations

| Hook Type           | Location                                       |
| ---                 | ---                                            |
| ***User Hooks***    | indicated by your `hooks.user` configuration   |
| ***Project Hooks*** | indicated by your `hooks.local` configuration  |
| ***Global Hooks***  | indicated by your `hooks.global` configuration |


The way most people work is to have a single folder with all hooks for them.

```bash
git config --global hooks.global `pwd`
```


Note: You can have multiple `hooks.global` configurations by either:

  1. adding them with the command: `git config --add hooks.global </path/to/hooks/directory>`
  1. adding the paths in a comma separated value way

#### Examples

Once `super_hooks` is installed, you can easily create hooks by placing executables files (`chmod 755`) under a folder with the hook name.
For example, if you were to create a pre-commit hook for your user, you would do the following:

```bash
mkdir -p ~/.git_hooks/pre-commit/
git config hooks.user ~/.git_hooks
touch ~/.git_hooks/pre-commit/cool_hook
chmod 755 ~/.git_hooks/pre-commit/cool_hook
```

Note: having a `--about` option when running your executable will allow you to have a short description when listing hooks. See my [rake example](https://github.com/frankywahl/super_hooks/blob/master/git_hooks/pre-commit/rake.sh) for this project.

Example: I have [my own hooks](https://github.com/frankywahl/git_hooks) which I have installed for all of my projects:

```bash
git clone git@github.com:frankywahl/git_hooks.git somewhere
cd somewhere
git config --global hooks.global `pwd`
```

#### Help

You can get help on the command line to see supported commands:

```bash
super_hooks --help
```

Then for a specific operation example

```bash
super_hooks install --help
```

## Code Status
![](https://github.com/frankywahl/super_hooks/workflows/Run%20tests/badge.svg?branch=master)

## Contributing

1. Fork it ( https://github.com/[my-github-username]/super_hooks/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Copyright

Copyright (c) 2020 Franky W.

## Credits

A great thanks to [icefox git-hooks](https://github.com/icefox/git-hooks) which was greatly used for this project and his [blogpost](http://benjamin-meyer.blogspot.com/2010/06/managing-project-user-and-global-git.html)
