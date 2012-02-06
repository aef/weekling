# encoding: UTF-8
=begin
Copyright Alexander E. Fischer <aef@raxys.net>, 2012

This file is part of Weekling.

Weekling is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

Weekling is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with Weekling.  If not, see <http://www.gnu.org/licenses/>.
=end

require 'aef/week'

module Aef
  class Week

    # Immutable object representing a calendar week day (according to ISO8601)
    class Day
      include Comparable
    
      # Table to translate symbolic lowercase english day names to day numbers
      #
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
    
      # Initializes the current week day
      #
      # @return [Aef::Week::Day] the current week day
      def self.today
        today = Date.today
        
        new(today, ((today.wday - 1) % 7) + 1)
      end
    
      class << self
        alias now today
      end
    
      # Parses the first week day out of a string
      #
      # @note Looks for patterns like this:
      #   2011-W03-5
      # @param [String] string a string containing a week-day representation
      # @return [Aef::Week::Day] the week day parsed from input
      # @raise [ArgumentError] if pattern cannot be found
      def self.parse(string)
        if sub_matches = /#{Week::PARSE_PATTERN}-([1-7])/.match(string.to_s)
          original, year, week_index, day_index = *sub_matches
          new(year.to_i, week_index.to_i, day_index.to_i)
        else
          raise ArgumentError, 'No week day found for parsing'
        end
      end
    
      class << self
        alias [] new
      end
    
      # @return [Aef::Week] the week the day is part of
      attr_reader :week

      # @return [Integer] the number of the day in its week
      attr_reader :index
    
      # Initializes a week day object
      # @overload initialize(week_day)
      #   Initialize by a week-day-like object
      #   @param [#week, #index] week_day a week-day-like object
      #
      # @overload initialize(date)
      #   Initialize by a date-like object
      #   @param [#to_date] date a date-like object like Date, DateTime or Time
      #
      # @overload initialize(week, day)
      #   Initialize by week-like-object and a day
      #   @param [#year, #index, #to_date] week a week-like object
      #   @param [#to_i, #to_sym] day either a day number or a lowercase
      #     english day name 
      #
      # @overload initialize(year, week_index, day)
      #   Initialize by year, week number and day
      #   @param [#to_i] year a year
      #   @param [#to_i] week_number a weeks index
      #   @param [#day] day either a day number or a lowercase english day name
      def initialize(*arguments)
        case arguments.count
        when 1
          object = arguments.first
          if [:week, :index].all?{|method| object.respond_to?(method) }
            @week  = Week.new(object.week)
            @index = object.index.to_i
          elsif object.respond_to?(:to_date)
            date = object.to_date
            @week  = Week.new(date)
            @index = ((date.wday - 1) % 7) + 1
          else
            raise ArgumentError, 'A single argument must either respond to week and index or to to_date'
          end
        when 2
          week, day = *arguments
          @week  = Week.new(week)
          if day.respond_to?(:to_i)
            @index = day.to_i
          else
            raise ArgumentError, 'Invalid day symbol' unless @index = SYMBOL_TO_INDEX_TABLE[day.to_sym]
          end
        when 3
          year, week_index, day = *arguments
          @week  = Week.new(year, week_index)
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
    
      # Represents a week as String in ISO8601 format
      #
      # @example Output of friday in 42nd week of 2525
      #   Aef::Week::Day.new(2525, 42, 5)
      #   # => 2525-W42-5
      #
      # @return [String] a character representation of the week day
      def to_s
        "#{week}-#{index}"
      end
    
      # @return [Symbol] a symbolic representation of the week day
      def to_sym
        SYMBOL_TO_INDEX_TABLE.invert[index]
      end
    
      # Returns the Date of the week day
      #
      # @return [Aef::Week] the week, the day belongs to
      def to_date
        date = Date.new(week.year, 1, 1)
    
        days_to_add = 7 * week.index
        days_to_add -= 7 if date.cweek == 1
        days_to_add -= ((date.wday - 1) % 7) + 1
        days_to_add += index
    
        date + days_to_add
      end
    
      # @return [Aef::Week::Day] self reference
      def to_week_day
        self
      end
   
      # @param [Object] other another object to be compared
      # @return [true, false] true if other lies in the same week and has the
      #   same index
      def ==(other)
        [:week, :index].all?{|method| other.respond_to?(method) } and
          week == other.week and index == other.index
      end
    
      # @param [Object] other another object to be compared
      # @return [true, false] true if other lies in the same year, has the same
      #   index and is of the same or a descending class
      def eql?(other)
        other.is_a?(self.class) and self == other
      end
    
      # @return [see Array#hash] identity hash for hash table usage
      def hash
        [week, index].hash
      end
    
      # Compares the week day with another to determine its relative position
      #
      # @param [#week, #index] other another object to be compared
      # @return [-1, 0, 1] -1 if other is greater, 0 if other is equal and 1 if
      #   other is lesser than self
      def <=>(other)
        week_comparison = week <=> other.week
    
        return index <=> other.index if week_comparison == 0
        return week_comparison
      end
    
      # Finds the following week day
      #
      # @example The thursday after some wednesday
      #   some_day = Aef::Week::Day.new(2013, 33, 3)
      #   some_day.next
      #   # => 2013-W33-4
      #
      # @example The week day after a year's last week day
      #   last_week_day_in_year = Aef::Week::Day.new(1998, 53, 7)
      #   last_week_day_in_year.next
      #   # => 1999-W01-1
      #
      # @return [Aef::Week::Day] the following week day
      def next
        if index == 7
          self.class.new(week.next, 1)
        else
          self.class.new(week, index + 1)
        end
      end
    
      alias succ next
      # Find the previous week day
      #
      # @example The sunday before some monday
      #   some_week = Aef::Week::Day.new(1783, 16, 1)
      #   some_week.previous
      #   # => 1783-W15-7
      #
      # @example The week day before first week day of a year
      #   first_week_in_year = Aef::Week::Day.new(2014, 1, 1)
      #   first_week_in_year.previous
      #   # => 2013-W52-7
      #
      # @return [Aef::Week::Day] the previous week day
      def previous
        if index == 1
          self.class.new(week.previous, 7)
        else
          self.class.new(week, index - 1)
        end
      end
    
      alias pred previous
    
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
