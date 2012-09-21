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

require 'aef/weekling'

module Aef
  module Weekling

    # Immutable object representing a calendar week (according to ISO 8601).
    class Week
      include Comparable
    
      # Regular expression for week extraction from strings.
      # @private
      PARSE_PATTERN = /(0|-?\d+)-W(0[1-9]|(?:1|2|3|4)\d|5(?:0|1|2|3))/
    
      class << self
        # Initializes the current week.
        #
        # @return [Aef::Weekling::Week] the current week
        def today
          today = Date.today

          new(today.year, today.cweek)
        end

        alias now today

        # Parses the first week out of a string.
        #
        # @note Looks for patterns like this:
        #   2011-W03
        # @param [String] string a string containing a week representation
        # @return [Aef::Weekling::Week] the week parsed from input
        # @raise [ArgumentError] if pattern cannot be found
        def parse(string)
          if sub_matches = PARSE_PATTERN.match(string.to_s)
            original, year, index = *sub_matches
            new(year.to_i, index.to_i)
          else
            raise ArgumentError, 'No week found for parsing'
          end
        end
      end
    
      # @return [Aef::Weekling::Year] the year the week is part of
      attr_reader :year
  
      # @return [Integer] the number of the week in its year
      attr_reader :index
    
      # @overload initialize(week)
      #   Initialize by a week-like object.
      #   @param [Aef::Weekling::Week] week a week-like object
      #
      # @overload initialize(date)
      #   Initialize by a date-like object.
      #   @param [Date, DateTime, Time] date a date-like object
      #
      # @overload initialize(year, index)
      #   Initialize by year and week number.
      #   @param [Integer, Aef::Weekling::Year] year a year
      #   @param [Integer] index a week index
      def initialize(*arguments)
        case arguments.count
        when 1
          object = arguments.first
          if [:year, :index].all?{|method_name| object.respond_to?(method_name) }
            @year  = object.year.to_year
            @index = object.index.to_i
          elsif object.respond_to?(:to_date)
            date = object.to_date
            @year  = Year.new(date.cwyear)
            @index = date.cweek
          else
            raise ArgumentError, 'A single argument must either respond to #year and #index or to #to_date'
          end
        when 2
          year, index = *arguments
          @year  = Year.new(year)
          @index = index.to_i
        else
          raise ArgumentError, "wrong number of arguments (#{arguments.count} for 1..2)"
        end
    
        if not (1..52).include?(@index)
          if @index == 53
            if @year.week_count == 52
              raise ArgumentError, "Index #{@index} is invalid. Year #{@year} has only 52 weeks"
            end
          else
            raise ArgumentError, "Index #{@index} is invalid. Index can never be lower than 1 or higher than 53"
          end
        end
    
      end
    
      # Represents a week as String in ISO 8601 format.
      #
      # @example Output of the 13th week in 2012
      #   Aef::Weekling::Week.new(2012, 13).to_s
      #   # => "2012-W13"
      #
      # @return [String] a character representation of the week
      def to_s
        "#{'%04i' % year}-W#{'%02i' % index}"
      end

      # Represents a week as String for debugging.
      #
      # @example Output of the 13th week in 2012
      #   Aef::Weekling::Week.new(2012, 13).inspect
      #   # => "#<Aef::Weekling::Week: 2012-W13>"
      #
      # @return [String] a character representation for debugging
      def inspect
        "#<#{self.class.name}: #{to_s}>"
      end
    
      # @return [Aef::Weekling::Week] self reference
      def to_week
        self
      end
    
      # @param [Aef::Weekling::Week] other a week-like object to be compared
      # @return [true, false] true if other lies in the same year and has the
      #   same index
      def ==(other)
        other_week = self.class.new(other)
        
        year == other_week.year and index == other_week.index
      end
    
      # @param [Aef::Weekling::Week] other a week object to be compared
      # @return [true, false] true if other lies in the same year, has the same
      #   index and is of the same or a descending class
      def eql?(other)
        other.is_a?(self.class) and self == other
      end
    
      # @return [see Array#hash] identity hash for hash table usage
      def hash
        [year, index].hash
      end
    
      # Compares the week with another to determine its relative position.
      #
      # @param [Aef::Weekling::Week] other a week-like object to be compared
      # @return [-1, 0, 1] -1 if other is greater, 0 if other is equal and 1 if
      #   other is lesser than self
      def <=>(other)
        other_week = self.class.new(other)
        
        year_comparison = year <=> other_week.year
    
        return index <=> other_week.index if year_comparison == 0
        return year_comparison
      end
    
      # Finds the following week.
      #
      # @example The week after some other week
      #   some_week = Aef::Weekling::Week.new(2012, 5)
      #   some_week.next
      #   # => #<Aef::Weekling::Week: 2012-W06>
      #
      # @example The week after the last week of a year
      #   last_week_in_year = Aef::Weekling::Week.new(2012, 52)
      #   last_week_in_year.next
      #   # => #<Aef::Weekling::Week: 2013-W01>
      #
      # @return [Aef::Weekling::Week] the following week
      def next
        if index < 52
          self.class.new(year, index + 1)
        elsif year.week_count == 53 and index == 52
          self.class.new(year, index + 1)
        else
          self.class.new(year.next, 1)
        end
      end
    
      alias succ next
    
      # Find the previous week.
      #
      # @example The week before some other week
      #   some_week = Aef::Weekling::Week.new(2012, 5)
      #   some_week.previous
      #   # => #<Aef::Weekling::Week: 2012-W04>
      #
      # @example The week before the first week of a year
      #   first_week_in_year = Aef::Weekling::Week.new(2016, 1)
      #   first_week_in_year.previous
      #   # => #<Aef::Weekling::Week: 2015-W53>
      #
      # @return [Aef::Weekling::Week] the previous week
      def previous
        if index > 1
          self.class.new(year, index - 1)
        elsif year.previous.week_count == 53
          self.class.new(year.previous, 53)
        else
          self.class.new(year.previous, 52)
        end
      end
    
      alias pred previous

      # Adds weeks to the week.
      #
      # @example 28 weeks after 2007-W01
      #   Aef::Weekling::Week.new(2007, 1) + 28
      #   # => #<Aef::Weekling::Week: 2007-W29>
      #
      # @param [Integer] other number of weeks to add
      # @return [Aef::Weekling::Week] the resulting week
      def +(other)
        result = self
        number = other.to_i

        number.abs.times do
          if number < 0
            result = result.previous
          else
            result = result.next
          end
        end

        result
      end

      # Subtracts weeks from the week.
      #
      # @example 3 weeks before 2000-W03
      #   Aef::Weekling::Week.new(2000, 3) - 3
      #   # => #<Aef::Weekling::Week: 1999-W52>
      #
      # @param [Integer] other number of weeks to subtract
      # @return [Aef::Weekling::Week] the resulting week
      def -(other)
        self + -other.to_i
      end

      # Returns a range of weeks beginning with self and ending with the first
      # following week with the given index.
      #
      # @example End index higher than start index
      #   Aef::Weekling::Week.new(2012, 35).until_index(50)
      #   # => #<Aef::Weekling::Week: 2012-W35>..#<Aef::Weekling::Week: 2012-W50>
      #
      # @example End index lower or equal than start index
      #   Aef::Weekling::Week.new(2012, 35).until_index(11)
      #   # => #<Aef::Weekling::Week: 2012-W35>..#<Aef::Weekling::Week:2013-W11>
      #
      # @param [Integer] end_index the number of the last week in the result
      # @return [Range<Aef::Weekling::Week>] range from self to the first
      #   following week with the given index
      def until_index(end_index)
        if end_index <= index
          self .. self.class.new(year.next, end_index)
        else
          self .. self.class.new(year, end_index)
        end
      end
    
      # States if the week's index is odd.
      #
      # @return [true, false] true if the week is odd
      def odd?
        @index.odd?
      end
    
      # States if the week's index is even.
      #
      # @return [true, false] true if the week is even
      def even?
        @index.even?
      end
    
      # @overload day(index)
      #   Returns a week-day by given index.
      #   @param [Integer] the index between 1 for monday and 7 for sunday
      # @overload day(symbol)
      #   Returns a week-day by given symbol.
      #   @param [Symbol] the English name of the day in lowercase
      # @return [Aef::Weekling::WeekDay] the specified day of the week
      def day(index_or_symbol)
        WeekDay.new(self, index_or_symbol)
      end

      # Returns the week's monday.
      #
      # @return [Aef::Weekling::WeekDay] monday of the week
      def monday
        day(:monday)
      end
    
      # Returns the week's tuesday.
      #
      # @return [Aef::Weekling::WeekDay] tuesday of the week
      def tuesday
        day(:tuesday)
      end
    
      # Returns the week's wednesday.
      #
      # @return [Aef::Weekling::WeekDay] wednesday of the week
      def wednesday
        day(:wednesday)
      end
    
      # Returns the week's thursday.
      #
      # @return [Aef::Weekling::WeekDay] thursday of the week
      def thursday
        day(:thursday)
      end

      # Returns the week's friday.
      #
      # @return [Aef::Weekling::WeekDay] friday of the week
      def friday
        day(:friday)
      end
    
      # Returns the week's saturday.
      #
      # @return [Aef::Weekling::WeekDay] saturday of the week
      def saturday
        day(:saturday)
      end
    
      # Returns the week's sunday.
      #
      # @return [Aef::Weekling::WeekDay] sunday of the week
      def sunday
        day(:sunday)
      end
    
      # Returns the week's saturday and sunday in an Array.
      #
      # @return [Array<Aef:Weekling::WeekDay>] the saturday and sunday of a week
      def weekend
        [saturday, sunday]
      end
    
      # Returns a range from monday to sunday.
      #
      # @return [Range<Aef::Weekling::WeekDay>] the days of the week
      def days
        monday..sunday
      end
  
    end
  end
end
