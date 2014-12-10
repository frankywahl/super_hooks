# SuperHooks

SuperHooks is a quick way to have hooks apply across multiple projects. 

Hooks are defined at three levels:

  * Global hooks: hooks available everywhere
  * User hooks: hooks used for your own user
  * Project hooks: hooks used only for a project

## Installation

To install it yourself do:

```bash
	$ gem install super_hooks
```

Then from any git project you can use

```bash
	$ super_hooks --install
```

## Usage

Install `super_hooks` into a git repository: 

```bash
	$ super_hooks --install
```

You can also send a template directory if you want all future projects to include `super_hooks`

## Getting help: 

	$ super_hooks --help

## Code Status
[![Build Status](https://travis-ci.org/frankywahl/super_hooks.svg?branch=master)](https://travis-ci.org/frankywahl/super_hooks)
[![Code Climate](https://codeclimate.com/github/frankywahl/super_hooks/badges/gpa.svg)](https://codeclimate.com/github/frankywahl/super_hooks)
[![Test Coverage](https://codeclimate.com/github/frankywahl/super_hooks/badges/coverage.svg)](https://codeclimate.com/github/frankywahl/super_hooks)

## Contributing

1. Fork it ( https://github.com/[my-github-username]/super_hooks/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request


## Copyright

Copyright (c) 2014 Franky W.

See LICENSE.txt for details.


## Credits

A great thanks to [icefox git-hooks](https://github.com/icefox/git-hooks) which was greatly used for this project and his [blogpost](http://benjamin-meyer.blogspot.com/2010/06/managing-project-user-and-global-git.html)
