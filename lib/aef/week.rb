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

require 'time'
require 'aef/week/day'

# Namespace for projects of Alexander E. Fischer <aef@raxys.net>
#
# If you want to be able to simply type Example instead of Aef::Example to
# address classes in this namespace simply write the following before using the
# classes:
#
#  include Aef
module Aef
  
  # Immutable object representing a calendar week (according to ISO8601)
  class Aef::Week
    include Comparable
  
    # The currently loaded library version
    VERSION = '0.1.0'

    # Regular expression for Date extraction from strings
    #
    # @private
    PARSE_PATTERN = /(0|-?\d+)-W(0[1-9]|(?:1|2|3|4)\d|5(?:0|1|2|3))/
  
    # Calculates the amount of weeks in a given year
    #
    # @example Acquire the amount of weeks for 2015
    #   Aef::Week.weeks_in_year(2015)
    #   # => 53
    #
    # @param [Integer] year the year for which the amount of weeks is returned
    # @return [Integer] the amount of weeks
    def self.weeks_in_year(year)
      date = Date.new(year, 12, 31)
  
      date = date - 7 if date.cweek == 1
  
      date.cweek
    end
  
    # Initializes the current week
    #
    # @return [Aef::Week] the current week
    def self.today
      today = Date.today
  
      new(today.year, today.cweek)
    end
  
    class << self
      alias now today
    end
  
    # Parses the first week out of a string
    #
    # @note Looks for patterns like this:
    #   2011-W03
    # @param [String] string a string containing a week representation
    # @return [Aef::Week] the week parsed from input
    # @raise [ArgumentError] if pattern cannot be found
    def self.parse(string)
      if sub_matches = PARSE_PATTERN.match(string.to_s)
        original, year, index = *sub_matches
        new(year.to_i, index.to_i)
      else
        raise ArgumentError, 'No week found for parsing'
      end
    end
  
    class << self
      alias [] new
    end
  
    # @return [Integer] the year the week is part of
    attr_reader :year

    # @return [Integer] the number of the week in its year
    attr_reader :index
  
    # @overload initialize(week)
    #   Initialize by a week-like object
    #   @param [#year, #index] week a week-like object
    #
    # @overload initialize(date)
    #   Initialize by a date-like object
    #   @param [#to_date] date a date-like object like Date, DateTime or Time
    #
    # @overload initialize(year, index)
    #   Initialize by year and week number
    #   @param [#to_i] year
    #   @param [#to_i] index
    def initialize(*arguments)
      case arguments.count
      when 1
        object = arguments.first
        if [:year, :index].all?{|method| object.respond_to?(method) }
          @year  = object.year.to_i
          @index = object.index.to_i
        elsif object.respond_to?(:to_date)
          date = object.to_date
          @year  = date.year
          @index = date.cweek
        else
          raise ArgumentError, 'A single argument must either respond to year and index or to to_date'
        end
      when 2
        year, index = *arguments
        @year  = year.to_i
        @index = index.to_i
      else
        raise ArgumentError, "wrong number of arguments (#{arguments.count} for 1..2)"
      end
  
      if not (1..52).include?(@index)
        if @index == 53
          if self.class.weeks_in_year(year) == 52
            raise ArgumentError, "Index #{@index} is invalid. Year #{year} has only 52 weeks"
          end
        else
          raise ArgumentError, "Index #{@index} is invalid. Index can never be lower than 1 or higher than 53"
        end
      end
  
    end
  
    # Represents a week as String in ISO8601 format (without day)
    #
    # @example Output of the 13th week in 2012
    #   Aef::Week.new(2012, 13).to_s
    #   # => "2012-W13"
    #
    # @return [String] a character representation of the week
    def to_s
      "#{'%04i' % year}-W#{'%02i' % index}"
    end
  
    # @return [Aef::Week] self reference
    def to_week
      self
    end
  
    # @param [Object] other another object to be compared
    # @return [true, false] true if other lies in the same year and has the
    #   same index
    def ==(other)
      [:year, :index].all?{|method| other.respond_to?(method) } and
        year == other.year and index == other.index
    end
  
    # @param [Object] other another object to be compared
    # @return [true, false] true if other lies in the same year, has the same
    #   index and is of the same or a descending class
    def eql?(other)
      other.is_a?(self.class) and self == other
    end
  
    # @return [see Array#hash] identity hash for hash table usage
    def hash
      [year, index].hash
    end
  
    # Compares the week with another to determine its relative position
    #
    # @param [#year, #index] other another object to be compared
    # @return [-1, 0, 1] -1 if other is greater, 0 if other is equal and 1 if
    #   other is lesser than self
    def <=>(other)
      year_comparison = year <=> other.year
  
      return index <=> other.index if year_comparison == 0
      return year_comparison
    end
  
    # Finds the following week
    #
    # @example The week after some other week
    #   some_week = Aef::Week.new(2012, 5)
    #   some_week.next
    #   # => 2012-W05
    #
    # @example The week after the last week of a year
    #   last_week_in_year = Aef::Week.new(2012, 52)
    #   last_week_in_year.next
    #   # => 2013-W01
    #
    # @return [Aef::Week] the following week
    def next
      if index < 52
        self.class.new(year, index + 1)
      elsif self.class.weeks_in_year(year) == 53 and index == 52
        self.class.new(year, index + 1)
      else
        self.class.new(year + 1, 1)
      end
    end
  
    alias succ next
  
    # Find the previous week
    #
    # @example The week before some other week
    #   some_week = Aef::Week.new(2012, 5)
    #   some_week.previous
    #   # => 2012-W04
    #
    # @example The week before the first week of a year
    #   first_week_in_year = Aef::Week.new(2016, 1)
    #   first_week_in_year.previous
    #   # => 2015-W53
    #
    # @return [Aef::Week] the previous week
    def previous
      if index > 1
        self.class.new(year, index - 1)
      elsif self.class.weeks_in_year(year - 1) == 53
        self.class.new(year - 1, 53)
      else
        self.class.new(year - 1, 52)
      end
    end
  
    alias pred previous
  
    # Returns a range of weeks beginning with self and ending with the first
    # following week with the given index
    #
    # @example End index higher than start index
    #   Aef::Week.new(2012, 35).until_index(50)
    #   # => 2012-W35..2012-W50
    #
    # @example End index lower or equal than start index
    #   Aef::Week.new(2012, 35).until_index(11)
    #   # => 2012-W35..2013-W11
    #
    # @param [#to_i] end_index the number of the last week in the result
    # @return [Range<Aef::Week, Aef::Week>] range from self to the first
    #   following week with the given index
    def until_index(end_index)
      if end_index <= index
        self .. self.class.new(year + 1, end_index)
      else
        self .. self.class.new(year, end_index)
      end
    end
  
    # States if the week's index is odd
    #
    # @return [true, false] true if the week is odd
    def odd?
      index.odd?
    end
  
    # States if the week's index is even
    #
    # @return [true, false] true if the week is even
    def even?
      index.even?
    end
  
    # Returns the week's monday
    #
    # @return [Aef::Week::Day] monday of the week
    def monday
      Day.new(self, :monday)
    end
  
    # Returns the week's tuesday
    #
    # @return [Aef::Week::Day] tuesday of the week
    def tuesday
      Day.new(self, :tuesday)
    end
  
    # Returns the week's wednesday
    #
    # @return [Aef::Week::Day] wednesday of the week
    def wednesday
      Day.new(self, :wednesday)
    end
  
    # Returns the week's thursday
    #
    # @return [Aef::Week::Day] thursday of the week
    def thursday
      Day.new(self, :thursday)
    end
  
    # Returns the week's friday
    #
    # @return [Aef::Week::Day] friday of the week
    def friday
      Day.new(self, :friday)
    end
  
    # Returns the week's saturday
    #
    # @return [Aef::Week::Day] saturday of the week
    def saturday
      Day.new(self, :saturday)
    end
  
    # Returns the week's sunday
    #
    # @return [Aef::Week::Day] sunday of the week
    def sunday
      Day.new(self, :sunday)
    end
  
    # Returns the week's saturday and sunday in an Array
    #
    # @return [Array<Aef::Week::Day>] the saturday and sunday of a week
    def weekend
      [saturday, sunday]
    end
  
    # Returns a range from monday to sunday
    #
    # @return [Range<Aef::Week::Day, Aef::Week::Day>] the days of the week
    def days
      monday..sunday
    end
  
    # @overload day(index)
    #   Returns a weekday by given index
    #   @param [#to_i] the index between 1 for monday and 7 for sunday
    # @overload day(symbol)
    #   Returns a weekday by given symbol
    #   @param [#to_sym] the English name of the day in lowercase
    # @return [Aef::Week::Day] the specified day of the week
    def day(index_or_symbol)
      Day.new(self, index_or_symbol)
    end

  end
end
