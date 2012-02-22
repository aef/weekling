# encoding: UTF-8
=begin
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
=end

require 'aef/weekling'

module Aef
  module Weekling

    # Immutable object representing a calendar year (according to ISO 8601).
    class Year
      include Comparable

      # Regular expression for Year extraction from strings.
      # @private
      PARSE_PATTERN = /(0|-?\d+)/
  
      class << self
        # Initializes the current year.
        #
        # @return [Aef::Weekling::Year] the current year
        def today
          today = Date.today
  
          new(today.year)
        end
  
        alias now today
  
        # Parses the first year out of a string.
        #
        # @note Looks for patterns like this:
        #   2011
        # @param [String] string a string containing a year representation
        # @return [Aef::Weekling::Year] the year parsed from input
        # @raise [ArgumentError] if pattern cannot be found
        def parse(string)
          if sub_matches = PARSE_PATTERN.match(string.to_s)
            original, year = *sub_matches
            new(year.to_i)
          else
            raise ArgumentError, 'No year found for parsing'
          end
        end
      end
  
      # @return [Integer] the number of the year
      attr_reader :index
  
      # @overload initialize(index)
      #   Initialize by number.
      #   @param [Integer] index the year's number
      #
      # @overload initialize(date)
      #   Initialize by a date-like object.
      #   @param [Date, DateTime, Time] date a date-like object
      def initialize(index_or_date)
        if index_or_date.respond_to?(:to_date)
          date = index_or_date.to_date
          @index = date.year
        elsif index_or_date.respond_to?(:to_i)
          @index = index_or_date.to_i
        else
          raise ArgumentError, 'A single argument must either respond to #to_date or to #to_i'
        end
      end
  
      # Represents the year as Integer.
      #
      # @return [Integer] the year's number
      def to_i
        @index
      end
  
      # Represents the year as String in ISO 8601 format.
      #
      # @example Output of the year 2012
      #   Aef::Weekling::Year.new(2012).to_s
      #   # => "2012"
      #
      # @return [String] a character representation of the year
      def to_s
        @index.to_s
      end
      
      # Represents a week as String for debugging.
      #
      # @example Output of the year 2012
      #   Aef::Weekling::Year.new(2012).inspect
      #   # => "<#Aef::Weekling::Year: 2012>"
      def inspect
        "#<#{self.class.name}: #{to_s}>"
      end
  
      # @return [Aef::Weekling::Year] self reference
      def to_year
        self
      end

      # @param [Aef::Weekling::Year] other a year-like object to be compared
      # @return [true, false] true if other has the same index
      def ==(other)
        other_year = self.class.new(other)
  
        self.index == other_year.index
      end

      # @param [Aef::Weekling::Year] other a year object to be compared
      # @return [true, false] true if other has the same index and is of the
      #   same or descending class
      def eql?(other)
        self == other and other.is_a?(self.class)
      end

      # @return [see Integer#hash] identity hash for hash table usage
      def hash
        @index.hash
      end
      
      # Compares the year with another to determine its relative position.
      #
      # @param [Aef::Weekling::Year] other a year-like object to be compared
      # @return [-1, 0, 1] -1 if other is greater, 0 if other is equal and 1 if
      #   other is lesser than self
      def <=>(other)
        other_year = other.to_year
  
        self.index <=> other_year.index
      end
  
      # Finds the following year.
      #
      # @example The year after some other year
      #   some_year = Aef::Weekling::Year.new(2012)
      #   some_year.next
      #   # => #<Aef::Weekling::Year: 2013>
      #
      # @return [Aef::Weekling::Year] the following year
      def next
        self.class.new(@index + 1)
      end
  
      alias succ next

      # Finds the previous year.
      #
      # @example The year before some other year
      #   some_year = Aef::Weekling::Year.new(2012)
      #   some_year.previous
      #   # => #<Aef::Weekling::Year: 2011>
      #
      # @return [Aef::Weekling::Year] the previous year
      def previous
        self.class.new(@index - 1)
      end

      alias pred previous

      # Adds years to the year.
      #
      # @example 3 year after 2000
      #   Aef::Weekling::Year.new(2000) + 3
      #   # => #<Aef::Weekling::Year: 2003>
      #
      # @param [Integer] other number of years to add
      # @return [Aef::Weekling::Year] the resulting year
      def +(other)
        self.class.new(@index + other.to_i)
      end

      # Subtracts years from the year.
      #
      # @example 3 before 2000
      #   Aef::Weekling::Year.new(2000) - 3
      #   # => #<Aef::Weekling::Year: 1997>
      #
      # @param [Integer] other number of years to subtract
      # @return [Aef::Weekling::Year] the resulting year
      def -(other)
        self.class.new(@index - other.to_i)
      end

      # States if the year's index is odd.
      #
      # @return [true, false] true if the year is odd
      def odd?
        @index.odd?
      end

      # States if the year's index is even.
      #
      # @return [true, false] true if the year is even
      def even?
        @index.even?
      end

      # States if the year is a leap year.
      #
      # @return [true, false] true is the year is a leap year
      def leap?
        Date.leap?(to_i)
      end

      # Calculates the amount of weeks in year.
      #
      # @example Acquire the amount of weeks for 2015
      #   Aef::Weekling::Year.new(2015).week_count
      #   # => 53
      #
      # @return [Integer] the amount of weeks
      def week_count
        date = Date.new(index, 12, 31)
  
        date = date - 7 if date.cweek == 1
  
        date.cweek
      end
  
      # Finds a week in the year.
      #
      # @param [Integer] index the week's index
      # @return [Aef::Weekling::Week] the week in year with the given index
      def week(index)
        Week.new(self, index.to_i)
      end

      # Returns a range of all weeks in year.
      #
      # @return [Range<Aef::Weekling::Week>] all weeks in year
      def weeks
        week(1)..week(week_count)
      end

    end
  end
end
