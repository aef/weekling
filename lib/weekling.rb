# encoding: UTF-8
=begin
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
=end

# Helper file to allow loading by gem name. Includes namespace Aef::Weekling
# into Object and extends Date, DateTime and Time to support to_year, to_week
# and to_week_day.

require 'aef/weekling'

Object.method(:include).call(Aef::Weekling)

Integer.method(:include).call(Aef::Weekling::CoreExtensions::ToYear)

[Date, Time, DateTime].each do |klass|
  klass.method(:include).call(Aef::Weekling::CoreExtensions::ToYear)
  klass.method(:include).call(Aef::Weekling::CoreExtensions::ToWeekAndWeekDay)
end
