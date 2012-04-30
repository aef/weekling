Weekling
========

[![Build Status](https://secure.travis-ci.org/aef/weekling.png)](
https://secure.travis-ci.org/aef/weekling)

* [Documentation][docs]
* [Project][project]

   [docs]:    http://rdoc.info/projects/aef/weekling/
   [project]: https://github.com/aef/weekling/

Description
-----------

Weekling is a Ruby library which provides class representations to make date
calculations using years, weeks and week-days much easier. Years, weeks and
week-days are interpreted as in ISO 8601.

Features / Problems
-------------------

This project tries to conform to:

* [Semantic Versioning (2.0.0-rc.1)][semver]
* [Ruby Packaging Standard (0.5-draft)][rps]
* [Ruby Style Guide][style]
* [Gem Packaging: Best Practices][gem]

   [semver]: http://semver.org/
   [rps]:    http://chneukirchen.github.com/rps/
   [style]:  https://github.com/bbatsov/ruby-style-guide
   [gem]:    http://weblog.rubyonrails.org/2009/9/1/gem-packaging-best-practices

Additional facts:

* Written purely in Ruby.
* Documented with YARD.
* Intended to be used with Ruby 1.9.2 or compatible.
* Extends core classes. This can be disabled through bare mode.
* Cryptographically signed gem and git tags.

Synopsis
--------

This documentation defines the public interface of the software. Don't rely
on elements marked as private. Those should be hidden in the documentation
by default.

### Loading

In most cases you want to load the library by the following command:

~~~~~ ruby
require 'weekling'
~~~~~

In a bundler Gemfile you should use the following:

~~~~~ ruby
gem 'weekling'
~~~~~

By default, Weekling extends the Date, DateTime and Time classes to allow their
objects to be castable to Week and Week::Day. Additionally the Aef namespace is
included into Object, so that you don't have to type the fully-qualified names
of the classes. Should you really don't want this, use the following:

~~~~~ ruby
require 'weekling/bare'
~~~~~

Or for bundler Gemfiles:

~~~~~ ruby
gem 'weekling', require: 'weekling/bare'
~~~~~

The following examples are written for those who use the normal mode. If you
use the bare mode, you need to add Aef::Weekling in front of every class name.

### Years

A Year object is constructed either by a date-like or and integer-like object:

~~~~~ ruby
year = Year.new(Time.new(2014, 3, 12))
# => #<Aef::Weekling::Year: 2014>

year = Year.new(2014)
# => #<Aef::Weekling::Year: 2014>
~~~~~

To get an Integer or String representation simply use the following:

~~~~~ ruby
year.to_i
# => 2014

year.to_s
# => "2014"
~~~~~

The next or previous years can be accessed by the respective methods:

~~~~~ ruby
year.next
# => #<Aef::Weekling::Year: 2015>

year.previous
# => #<Aef::Weekling::Year: 2013>
~~~~~

You can also add or subtract amounts of years to get another year object:

~~~~~ ruby
year + 5
# => #<Aef::Weekling::Year: 2019>

year - 7
# => #<Aef::Weekling::Year: 2007>
~~~~~

The year is also able to tell you if it is even or odd:

~~~~~ ruby
year.even?
# => true

year.odd?
# => false
~~~~~

The year also knows how many weeks it has:

~~~~~ ruby
year.week_count
# => 52
~~~~~

Or if it is a leap year:

~~~~~ ruby
year.leap?
# => false
~~~~~

### Weeks

You can either get an enumerable list of weeks from an existing year:

~~~~~ ruby
year.weeks
# => #<Aef::Weekling::Week: 2014-W01>..#<Aef::Weekling::Week: 2014-W52>
~~~~~

Or request individual weeks from a year object:

~~~~~ ruby
year.week(30)
# => #<Aef::Weekling::Week: 2014-W30>
~~~~~

Or you can construct a week by year and index (week number):

~~~~~ ruby
week = Week.new(2012, 37)
# => #<Aef::Weekling::Week: 2012-W37>
~~~~~

To regain the year or index you can simply access the attributes:

~~~~~ ruby
week.year
# => #<Aef::Weekling::Year: 2012>

week.index
# => 37
~~~~~

The next or previous weeks can be accessed by the respective methods:

~~~~~ ruby
week.next
# => #<Aef::Weekling::Week: 2012-W38>

week.previous
# => #<Aef::Weekling::Week: 2012-W36>
~~~~~

You can also add or subtract amounts of weeks to get another week object:

~~~~~ ruby
week + 5
# => #<Aef::Weekling::Week: 2012-W42>

week - 7
# => #<Aef::Weekling::Week: 2012-W30>
~~~~~

The week is also able to tell you if it is even or odd:

~~~~~ ruby
week.even?
# => false

week.odd?
# => true
~~~~~

You can also construct a range of weeks starting with the current, which can be
iterated through or which can be easily converted to an Array. The range will
run until given index in the future is reached. Notice that this means, if the
given index is lower or equal to the current, the end of the range will be in
the following year:

~~~~~ ruby
week.until_index(45)
# => #<Aef::Weekling::Week: 2012-W37>..#<Aef::Weekling::Week: 2012-W45>

week.until_index(11)
# => #<Aef::Weekling::Week: 2012-W37>..#<Aef::Weekling::Week: 2013-W11>
~~~~~

### Week-days

You can either get an enumerable list of week-days from an existing week:

~~~~~ ruby
week.days
# => #<Aef::Weekling::WeekDay: 2012-W37-1>..#<Aef::Weekling::WeekDay: 2012-W37-7>

week.weekend
# => [#<Aef::Weekling::WeekDay: 2012-W37-6>, #<Aef::Weekling::WeekDay: 2012-W37-7>]
~~~~~

Or request individual week-days from a week object:

~~~~~ ruby
week.day(3)
# => #<Aef::Weekling::WeekDay: 2012-W37-3>

week.day(:friday)
# => #<Aef::Weekling::WeekDay: 2012-W37-5>

week.monday
# => #<Aef::Weekling::WeekDay: 2012-W37-1>
~~~~~

Or you can create a week-day by year, week and day. The day can be an index
between 1 and 7 (monday to sunday), or the lower-case english name of the day
as symbol. Example below:

~~~~~ ruby
week_day = WeekDay.new(2012, 37, 4)
# => #<Aef::Weekling::WeekDay: 2012-W37-4>

week_day = WeekDay.new(2012, 37, :thursday)
# => #<Aef::Weekling::WeekDay: 2012-W37-4>
~~~~~

To regain the week and the index you can access the attributes:

~~~~~ ruby
week_day.week
# => #<Aef::Weekling::Week: 2012-W37>

week_day.index
# => 4
~~~~~

If you want the symbolized name instead, use the following:

~~~~~ ruby
week_day.to_sym
# => :thursday
~~~~~

As in weeks you can get the next and previous day the following way:

~~~~~ ruby
week_day.next
# => #<Aef::Weekling::WeekDay: 2012-W37-5>

week_day.previous
# => #<Aef::Weekling::WeekDay: 2012-W37-3>
~~~~~

You can also add or subtract amounts of week-days to get another week-day object:

~~~~~ ruby
week_day + 5
# => #<Aef::Weekling::WeekDay: 2012-W38-2>

week_day - 7
# => #<Aef::Weekling::WeekDay: 2012-W36-4>
~~~~~

Each week-day can be converted to a regular date easily:

~~~~~ ruby
week_day.to_date
# => #<Date: 2012-09-13 (…)>
~~~~~

You can ask a week-day if it is a specific day in week:

~~~~~ ruby
week_day.tuesday?
# => false

week_day.thursday?
# => true
~~~~~

Requirements
------------

* Ruby 1.9.2 or compatible

Installation
------------

On *nix systems you may need to prefix the command with sudo to get root
privileges.

### High security (recommended)

There is a high security installation option available through rubygems. It is
highly recommended over the normal installation, although it may be a bit less
comfortable. To use the installation method, you will need my [gem signing
public key][gemkey], which I use for cryptographic signatures on all my gems.

Add the key to your rubygems' trusted certificates by the following command:

    gem cert --add aef-gem.pem

Now you can install the gem while automatically verifying it's signature by the
following command:

    gem install weekling -P HighSecurity

Please notice that you may need other keys for dependent libraries, so you may
have to install dependencies manually.

   [gemkey]: https://aef.name/crypto/aef-gem.pem

### Normal

    gem install weekling

### Automated testing

Go into the root directory of the installed gem and run the following command
to fetch all development dependencies:

    bundle

Afterwards start the test runner:

    rake spec

If something goes wrong you should be noticed through failing examples.

Development
-----------

### Bugs Reports and Feature Requests

Please use the [issue tracker][issues] on github.com to let me know about errors
or ideas for improvement of this software.

   [issues]: https://github.com/aef/weekling/issues/

### Source code

This software is developed in the source code management system git hosted
at github.com. You can download the most recent sourcecode through the
following command:

    git clone https://github.com/aef/weekling.git

The final commit before each released gem version will be marked by a tag
named like the version with a prefixed lower-case "v", as required by Semantic
Versioning. Every tag will be signed by my [OpenPGP public key][openpgp] which
enables you to verify your copy of the code cryptographically.

   [openpgp]: https://aef.name/crypto/aef-openpgp.asc

Add the key to your GnuPG keyring by the following command:

    gpg --import aef-openpgp.asc

This command will tell you if your code is of integrity and authentic:

    git tag -v [TAG NAME]

### Contribution

Help on making this software better is always very appreciated. If you want
your changes to be included in the official release, please clone my project
on github.com, create a named branch to commit and push your changes into and
send me a pull request afterwards.

Please make sure to write tests for your changes so that I won't break them
when changing other things on the library. Also notice that I can't promise
to include your changes before reviewing them.

License
-------

Copyright Alexander E. Fischer <aef@raxys.net>, 2012

This file is part of Weekling.

Permission to use, copy, modify, and/or distribute this software for any
purpose with or without fee is hereby granted, provided that the above
copyright notice and this permission notice appear in all copies.

THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH
REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND
FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT,
INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM
LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR
OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR
PERFORMANCE OF THIS SOFTWARE.
