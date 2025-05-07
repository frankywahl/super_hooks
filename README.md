# SuperHooks

***SuperHooks*** is a quick way to have hooks apply across multiple projects.
It allows you to decouple the hooks you use from the projects you use them in by placing the hooks into separate folders.

Hooks folders are defined in the git config under `superhooks.path`

## Usage

<details>
<summary>Usage of the CLI</summary>

```bash
super_hooks install       # Install `super_hooks` into a git repository
super_hooks list          # List the current hooks
super_hooks help          # See the other options
super_hook run pre-commit # Run all pre-commit hooks manually
```
</details>

### Creating hooks

If you have a folder with the following structure

```tree
./~
└── hooks
    ├── pre-commit
    │   ├── script1.sh
    │   └── script2.rb
    └── pre-push
        └── prevent-force
            └── main.sh
```

All executables are placed under their respective folders.

You would run `git config --global --add superhooks.path ~/hooks`. The hooks inside that folder would then run on all git repositories that have `super_hooks` installed. If you have project specific hooks, you can have them ran as well by adding to the project's git config with `git config --add ./path/to/hook/folder`

#### Examples

Once `super_hooks` is installed, you can easily create hooks by placing executables files (`chmod 755`) under a folder with the hook name.
For example, if you were to create a pre-commit hook for your user, you would do the following:

```bash
mkdir -p ~/.git_hooks/pre-commit/
git config --add superhooks.path ~/.git_hooks
touch ~/.git_hooks/pre-commit/cool_hook
chmod 755 ~/.git_hooks/pre-commit/cool_hook
```

Note: having a `--about` option when running your executable will allow you to have a short description when listing hooks. See my [rake example](https://github.com/frankywahl/super_hooks/blob/470e7dfedc0818644d9bded3afb48a8ecc7f51ae/git_hooks/pre-commit/rake.sh) for this project.

Example: I have [my own hooks](https://github.com/frankywahl/git_hooks) which I have installed for all of my projects:

```bash
git clone git@github.com:frankywahl/git_hooks.git somewhere
cd somewhere
git config --global --add superhooks.path `pwd`
```

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
[![Run tests](https://github.com/frankywahl/super_hooks/actions/workflows/ci.yml/badge.svg)](https://github.com/frankywahl/super_hooks/actions/workflows/ci.yml)

## Contributing

1. Fork it ( https://github.com/[my-github-username]/super_hooks/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Copyright

Copyright (c) 2022 Franky W.
