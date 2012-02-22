Weekling
========

[![Build Status](https://secure.travis-ci.org/aef/weekling.png)](
https://secure.travis-ci.org/aef/weekling)

* [Documentation][1]
* [Project][2]

   [1]: http://rdoc.info/projects/aef/weekling/
   [2]: http://github.com/aef/weekling/

Description
-----------

Weekling is a Ruby library which provides class representations to make date
calculations using years, weeks and week-days much easier. Years, weeks and
week-days are interpreted as in ISO 8601.

Features / Problems
-------------------

This projects tries to conform to:

* [Semantic Versioning (2.0.0-rc.1)][5]
* [Ruby Packaging Standard (0.5-draft)][6]
* [Ruby Style Guide][7]
* [Gem Packaging: Best Practices][8]

   [5]: http://semver.org/
   [6]: http://chneukirchen.github.com/rps/
   [7]: https://github.com/bbatsov/ruby-style-guide
   [8]: http://weblog.rubyonrails.org/2009/9/1/gem-packaging-best-practices

Additional facts:

* Written purely in Ruby.
* Intended to be used with Ruby 1.9.2 or compatible.
* Extends core classes. This can be disabled through bare mode.

Synopsis
--------

This documentation defines the public interface of the library. Don't rely
on elements marked as private. Those should be hidden in the documentation
by default.

### Loading

In most cases you want to load the library by the following command:

    require 'weekling'

In a bundler Gemfile you should use the following:

    gem 'weekling'

By default, Weekling extends the Date, DateTime and Time classes to allow their
objects to be castable to Week and Week::Day. Additionally the Aef namespace is
included into Object, so that you don't have to type the fully-qualified names
of the classes. Should you really don't want this, use the following:

    require 'weekling/bare'

Or for bundler Gemfiles:

    gem 'weekling', require: 'weekling/bare'

The following examples are written for those who use the normal mode. If you
use the bare mode, you need to add Aef::Weekling in front of every class name.

### Years

A Year object is constructed either by a date-like or and integer-like object:

```ruby
year = Year.new(Time.new(2014, 3, 12))
# => #<Aef::Weekling::Year: 2014>

year = Year.new(2014)
# => #<Aef::Weekling::Year: 2014>
```

To get an Integer or String representation simply use the following:

    year.to_i
    # => 2014

    year.to_s
    # => "2014"

The next or previous years can be accessed by the respective methods:

    year.next
    # => #<Aef::Weekling::Year: 2015>

    year.previous
    # => #<Aef::Weekling::Year: 2013>

You can also add or subtract amounts of years to get another year object:

    year + 5
    # => #<Aef::Weekling::Year: 2019>

    year - 7
    # => #<Aef::Weekling::Year: 2007>

The year is also able to tell you if it is even or odd:

    year.even?
    # => true

    year.odd?
    # => false

The year also knows how many weeks it has:

    year.week_count
    # => 52

Or if it is a leap year:

    year.leap?
    # => false

### Weeks

You can either get an enumerable list of weeks from an existing year:

    year.weeks
    # => #<Aef::Weekling::Week: 2014-W01>..#<Aef::Weekling::Week: 2014-W52>

Or request individual weeks from a year object:

    year.week(30)
    # => #<Aef::Weekling::Week: 2014-W30>

Or you can construct a week by year and index (week number):

    week = Week.new(2012, 37)
    # => #<Aef::Weekling::Week: 2012-W37>

To regain the year or index you can simply access the attributes:

    week.year
    # => #<Aef::Weekling::Year: 2012>

    week.index
    # => 37

The next or previous weeks can be accessed by the respective methods:

    week.next
    # => #<Aef::Weekling::Week: 2012-W38>

    week.previous
    # => #<Aef::Weekling::Week: 2012-W36>

You can also add or subtract amounts of weeks to get another week object:

    week + 5
    # => #<Aef::Weekling::Week: 2012-W42>

    week - 7
    # => #<Aef::Weekling::Week: 2012-W30>

The week is also able to tell you if it is even or odd:

    week.even?
    # => false

    week.odd?
    # => true

You can also construct a range of weeks starting with the current, which can be
iterated through or which can be easily converted to an Array. The range will
run until given index in the future is reached. Notice that this means, if the
given index is lower or equal to the current, the end of the range will be in
the following year:

    week.until_index(45)
    # => #<Aef::Weekling::Week: 2012-W37>..#<Aef::Weekling::Week: 2012-W45>

    week.until_index(11)
    # => #<Aef::Weekling::Week: 2012-W37>..#<Aef::Weekling::Week: 2013-W11>

### Week-days

You can either get an enumerable list of week-days from an existing week:

    week.days
    # => #<Aef::Weekling::WeekDay: 2012-W37-1>..#<Aef::Weekling::WeekDay: 2012-W37-7>

    week.weekend
    # => [#<Aef::Weekling::WeekDay: 2012-W37-6>, #<Aef::Weekling::WeekDay: 2012-W37-7>]

Or request individual week-days from a week object:

    week.day(3)
    # => #<Aef::Weekling::WeekDay: 2012-W37-3>

    week.day(:friday)
    # => #<Aef::Weekling::WeekDay: 2012-W37-5>

    week.monday
    # => #<Aef::Weekling::WeekDay: 2012-W37-1>

Or you can create a week-day by year, week and day. The day can be an index
between 1 and 7 (monday to sunday), or the lower-case english name of the day
as symbol. Example below:

    week_day = WeekDay.new(2012, 37, 4)
    # => #<Aef::Weekling::WeekDay: 2012-W37-4>

    week_day = WeekDay.new(2012, 37, :thursday)
    # => #<Aef::Weekling::WeekDay: 2012-W37-4>

To regain the week and the index you can access the attributes:

    week_day.week
    # => #<Aef::Weekling::Week: 2012-W37>

    week_day.index
    # => 4

If you want the symbolized name instead, use the following:

    week_day.to_sym
    # => :thursday

As in weeks you can get the next and previous day the following way:

    week_day.next
    # => #<Aef::Weekling::WeekDay: 2012-W37-5>

    week_day.previous
    # => #<Aef::Weekling::WeekDay: 2012-W37-3>

You can also add or subtract amounts of week-days to get another week-day object:

    week_day + 5
    # => #<Aef::Weekling::WeekDay: 2012-W38-2>

    week_day - 7
    # => #<Aef::Weekling::WeekDay: 2012-W36-4>

Each week-day can be converted to a regular date easily:

    week_day.to_date
    # => #<Date: 2012-09-13 (…)>

You can ask a week-day if it is a specific day in week:

    week_day.tuesday?
    # => false

    week_day.thursday?
    # => true

Requirements
------------

None

Installation
------------

On *nix systems you may need to prefix the command with sudo to get root
privileges.

### High security (recommended)

There is a high security installation option available through rubygems. It is
highly recommended over the normal installation, although it may be a bit less
comfortable. To use the installation method, you will need my public key, which
I use for cryptographic signatures on all my gems. You can find the public key
here: http://aef.name/crypto/aef-gem.pem

Add the key to your rubygems' trusted certificates by the following command:

    gem cert --add aef-gem.pem

Now you can install the gem while automatically verifying it's signature by the
following command:

    gem install weekling -P HighSecurity

Please notice that you may need other keys for dependent libraries, so you may
have to install dependencies manually.  

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

This software is developed in the source code management system git hosted
at github.com. You can download the most recent sourcecode through the
following command:

    git clone https://github.com/aef/weekling.git

Help on making this software better is always very appreciated. If you want
your changes to be included in the official release, please clone my project
on github.com, create a named branch to commit and push your changes in and
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

THE SOFTWARE IS PROVIDED "AS IS" AND ISC DISCLAIMS ALL WARRANTIES WITH REGARD
TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND
FITNESS. IN NO EVENT SHALL ISC BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR
CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE,
DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS
ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS
SOFTWARE.
