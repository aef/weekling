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

# Namespace for projects of Alexander E. Fischer <aef@raxys.net>.
# 
# If you want to be able to simply type Example instead of Aef::Example to
# address classes in this namespace simply write the following before using the
# classes.
#
# @example Including the namespace
#   include Aef
# @author Alexander E. Fischer
module Aef
  
  # Namespace for components of the weekling gem  
  module Weekling

    # The currently loaded library version
    #
    # Using Semantic Versioning (2.0.0-rc.1) rules
    # @see http://semver.org/
    VERSION = '1.0.1'.freeze

  end
end

require 'time'
require 'aef/weekling/year'
require 'aef/weekling/week'
require 'aef/weekling/week_day'
require 'aef/weekling/core_extensions/to_year'
require 'aef/weekling/core_extensions/to_week_and_week_day'
