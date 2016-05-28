# alfi [![Build Status](https://travis-ci.org/cesarferreira/alfi.svg?branch=master)](https://travis-ci.org/cesarferreira/alfi) [![Gem Version](http://img.shields.io/gem/v/alfi.svg?style=flat)](http://badge.fury.io/rb/alfi) [![Dependency Status](https://gemnasium.com/cesarferreira/alfi.svg)](https://gemnasium.com/cesarferreira/alfi)


**A**ndroid **L**ibrary **Fi**nder

Search through thousands of android libraries that can help you scale your projects elegantly

## Usage

Search for `something`

```bash
alfi picasso
```

<p align="center">
<img src="https://raw.github.com/cesarferreira/alfi/master/extras/images/terminal01.gif" />
</p>


Search for `something` by repository

```bash
alfi picasso --repository maven
```

This will search picasso only on maven, you can also define multiple repositories like:

```bash
alfi picasso -r mavenCentral -r jCenter
```

This will search picasso on mavenCentral and jCenter

**Final step:** Copy the library you want to your `build.gradle` and sync it

## Installation

Install it via terminal:

    $ gem install alfi


## Contributing

1. Fork it ( https://github.com/cesarferreira/alfi/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request


## Thanks
To [@joaquimadraz](https://github.com/joaquimadraz) for the ruby pro-tips
