# encoding: UTF-8
=begin
Copyright Alexander E. Fischer <aef@raxys.net>, 2012

This file is part of Weekling.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this
   list of conditions and the following disclaimer.
2. Redistributions in binary form must reproduce the above copyright notice,
   this list of conditions and the following disclaimer in the documentation
   and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

The views and conclusions contained in the software and documentation are those
of the authors and should not be interpreted as representing official policies,
either expressed or implied, of the Weekling Project.
=end

require 'aef/weekling'

module Aef
  module Weekling

    # Immutable object representing a calendar week day (according to ISO 8601).
    class WeekDay
      include Comparable
    
      # Table to translate symbolic lowercase english day names to day numbers.
      # @private
      SYMBOL_TO_INDEX_TABLE = {
        :monday    => 1,
        :tuesday   => 2,
        :wednesday => 3,
        :thursday  => 4,
        :friday    => 5,
        :saturday  => 6,
        :sunday    => 7
      }.freeze

      # Regular expression for week-day extraction from strings.
      # @private
      PARSE_PATTERN = /(0|-?\d+)-W(0[1-9]|(?:1|2|3|4)\d|5(?:0|1|2|3))-([1-7])/

      class << self
        # Initializes the current week day.
        #
        # @return [Aef::Weekling::WeekDay] the current week day
        def today
          today = Date.today

          new(today, ((today.wday - 1) % 7) + 1)
        end

        alias now today

        # Parses the first week day out of a string.
        #
        # @note Looks for patterns like this:
        #   2011-W03-5
        # @param [String] string a string containing a week-day representation
        # @return [Aef::Weekling::WeekDay] the week day parsed from input
        # @raise [ArgumentError] if pattern cannot be found
        def parse(string)
          if sub_matches = PARSE_PATTERN.match(string.to_s)
            original, year, week_index, day_index = *sub_matches
            new(year.to_i, week_index.to_i, day_index.to_i)
          else
            raise ArgumentError, 'No week day found for parsing'
          end
        end
      end
    
      # @return [Aef::Weekling::Week] the week the day is part of
      attr_reader :week

      # @return [Integer] the number of the day in its week
      attr_reader :index
    
      # @overload initialize(week_day)
      #   Initialize by a week-day-like object.
      #   @param [Aef::Weekling::WeekDay] week_day a week-day-like object
      #
      # @overload initialize(date)
      #   Initialize by a date-like object.
      #   @param [Date, DateTime, Time] date a date-like object
      #
      # @overload initialize(week, day)
      #   Initialize by week-like-object and a day.
      #   @param [Aef::Weekling::Week] week a week-like object
      #   @param [Integer, Symbol] day either a day number or a lowercase
      #     english day name 
      #
      # @overload initialize(year, week_index, day)
      #   Initialize by year, week number and day.
      #   @param [Integer, Aef::Weekling::Year] year a year
      #   @param [Integer] week_number a weeks index
      #   @param [Integer, Symbol] day either a day number or a lowercase english day name
      def initialize(*arguments)
        case arguments.count
        when 1
          object = arguments.first
          if [:week, :index].all?{|method_name| object.respond_to?(method_name) }
            @week  = object.week.to_week
            @index = object.index.to_i
          elsif object.respond_to?(:to_date)
            date = object.to_date
            @week  = Week.new(date)
            @index = ((date.wday - 1) % 7) + 1
          else
            raise ArgumentError, 'A single argument must either respond to #week and #index or to #to_date'
          end
        when 2
          week, day = *arguments
          @week = week.to_week
          if day.respond_to?(:to_i)
            @index = day.to_i
          else
            raise ArgumentError, 'Invalid day symbol' unless @index = SYMBOL_TO_INDEX_TABLE[day.to_sym]
          end
        when 3
          year, week_index, day = *arguments
          @week = Week.new(year, week_index)
          if day.respond_to?(:to_i)
            @index = day.to_i
          else
            raise ArgumentError, 'Invalid day symbol' unless @index = SYMBOL_TO_INDEX_TABLE[day.to_sym]
          end
        else
          raise ArgumentError, "wrong number of arguments (#{arguments.count} for 1..3)"
        end
    
        raise ArgumentError, 'Index must be in 1..7' unless (1..7).include?(index)
      end
    
      # Represents a week-day as String in ISO 8601 format.
      #
      # @example Output of friday in 42nd week of 2525
      #   Aef::Weekling::WeekDay.new(2525, 42, 5).to_s
      #   # => "2525-W42-5"
      #
      # @return [String] a character representation of the week day
      def to_s
        "#{week}-#{index}"
      end

      # Represents a week-day as String for debugging.
      #
      # @example Output of friday in 42nd week of 2525
      #   Aef::Weekling::WeekDay.new(2525, 42, 5)
      #   # => "#<Aef::Weekling::WeekDay: 2525-W42-5>"
      #
      # @return [String] a character representation for debugging
      def inspect
        "#<#{self.class.name}: #{to_s}>"
      end

      # @return [Symbol] a symbolic representation of the week day
      def to_sym
        SYMBOL_TO_INDEX_TABLE.invert[index]
      end
    
      # Returns the date of the week-day.
      #
      # @return [Date] the date of the week-day
      def to_date
        date = Date.new(week.year.to_i, 1, 1)
    
        days_to_add = 7 * week.index
        days_to_add -= 7 if date.cweek == 1
        days_to_add -= ((date.wday - 1) % 7) + 1
        days_to_add += index
    
        date + days_to_add
      end
    
      # @return [Aef::Weekling::WeekDay] self reference
      def to_week_day
        self
      end
   
      # @param [Aef::Weekling::WeekDay] other a week-day-like object to be compared
      # @return [true, false] true if other lies in the same week and has the
      #   same index
      def ==(other)
        other_week_day = self.class.new(other)

        week == other_week_day.week and index == other_week_day.index
      end
    
      # @param [Aef::Weekling::WeekDay] other a week-day object to be compared
      # @return [true, false] true if other lies in the same year, has the same
      #   index and is of the same or a descending class
      def eql?(other)
        other.is_a?(self.class) and self == other
      end
    
      # @return [see Array#hash] identity hash for hash table usage
      def hash
        [week, index].hash
      end
    
      # Compares the week-day with another to determine its relative position.
      #
      # @param [Aef::Weekling::WeekDay] other a week-day-like object to be compared
      # @return [-1, 0, 1] -1 if other is greater, 0 if other is equal and 1 if
      #   other is lesser than self
      def <=>(other)
        other_week_day = self.class.new(other)

        week_comparison = week <=> other_week_day.week
    
        return index <=> other_week_day.index if week_comparison == 0
        return week_comparison
      end
    
      # Finds the following week-day.
      #
      # @example The thursday after some wednesday
      #   some_day = Aef::Weekling::WeekDay.new(2013, 33, 3)
      #   some_day.next
      #   # => #<Aef::Weekling::WeekDay: 2013-W33-4>
      #
      # @example The week-day after a year's last week-day
      #   last_week_day_in_year = Aef::Weekling::WeekDay.new(1998, 53, 7)
      #   last_week_day_in_year.next
      #   # => #<Aef::Weekling::WeekDay: 1999-W01-1>
      #
      # @return [Aef::Weekling::WeekDay] the following week-day
      def next
        if index == 7
          self.class.new(week.next, 1)
        else
          self.class.new(week, index + 1)
        end
      end
    
      alias succ next
      # Find the previous week-day
      #
      # @example The sunday before some monday
      #   some_week = Aef::Weekling::WeekDay.new(1783, 16, 1)
      #   some_week.previous
      #   # => #<Aef::Weekling::WeekDay: 1783-W15-7>
      #
      # @example The week-day before first week-day of a year
      #   first_week_in_year = Aef::Weekling::WeekDay.new(2014, 1, 1)
      #   first_week_in_year.previous
      #   # => #<Aef::Weekling::WeekDay: 2013-W52-7>
      #
      # @return [Aef::Weekling::WeekDay] the previous week-day
      def previous
        if index == 1
          self.class.new(week.previous, 7)
        else
          self.class.new(week, index - 1)
        end
      end
    
      alias pred previous

      # Adds days to the week-day.
      #
      # @example 28 days after 2007-W01-1
      #   Aef::Weekling::WeekDay.new(2007, 1, 1) + 28
      #   # => #<Aef::Weekling::WeekDay: 2007-W05-1>
      #
      # @param [Integer] other number of days to add
      # @return [Aef::Weekling::WeekDay] the resulting week-day
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

      # Subtracts days from the week-day.
      #
      # @example 5 days before 2012-W45-3
      #   Aef::Weekling::WeekDay.new(2012, 45, 3) - 5
      #   # => #<Aef::Weekling::WeekDay: 2012-W44-5>
      #
      # @param [Integer] other number of days to subtract
      # @return [Aef::Weekling::WeekDay] the resulting week-day
      def -(other)
        self + -other.to_i
      end

      # @return [true, false] true if week day is monday
      def monday?
        to_sym == :monday
      end
    
      # @return [true, false] true if week day is tuesday
      def tuesday?
        to_sym == :tuesday
      end
    
      # @return [true, false] true if week day is wednesday
      def wednesday?
        to_sym == :wednesday
      end
    
      # @return [true, false] true if week day is thursday
      def thursday?
        to_sym == :thursday
      end
    
      # @return [true, false] true if week day is friday
      def friday?
        to_sym == :friday
      end
    
      # @return [true, false] true if week day is saturday
      def saturday?
        to_sym == :saturday
      end
    
      # @return [true, false] true if week day is sunday
      def sunday?
        to_sym == :sunday
      end
    
      # @return [true, false] true if week day is saturday or sunday
      def weekend?
        saturday? or sunday?
      end
  
    end
  end
end
