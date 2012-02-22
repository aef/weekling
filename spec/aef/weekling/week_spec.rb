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

require 'spec_helper'
require 'aef/weekling/week'
require 'ostruct'

describe Aef::Weekling::Week do
  [:today, :now].each do |method|
    context ".#{method}" do
      it "should find the current week" do
        week = described_class.method(method).call
        today = Date.today

        week.year.should eql Aef::Weekling::Year.new(today.year)
        week.index.should eql today.cweek
      end
    end
  end

  context ".parse" do
    it "should recognize an ancient week" do
      week = described_class.parse('-1503-W50')

      week.year.should eql Aef::Weekling::Year.new(-1503)
      week.index.should eql 50
    end

    it "should recognize a normal week" do
      week = described_class.parse('2011-W30')

      week.year.should eql Aef::Weekling::Year.new(2011)
      week.index.should eql 30
    end

    it "should recognize a post apocalyptic week" do
      week = described_class.parse('50023-W03')

      week.year.should eql Aef::Weekling::Year.new(50023)
      week.index.should eql 3
    end

    it "should report being unable to parse the given String" do
      lambda{
        described_class.parse('no week!')
      }.should raise_error(ArgumentError, 'No week found for parsing')
    end
  end

  context ".new" do
    it "should complain about a param of invalid type" do
      lambda {
        described_class.new(123)
      }.should raise_error(ArgumentError, 'A single argument must either respond to #year and #index or to #to_date')
    end

    it "should complain about less than one argument" do
      lambda {
        described_class.new
      }.should raise_error(ArgumentError, 'wrong number of arguments (0 for 1..2)')
    end

    it "should complain about more than two arguments" do
      lambda {
        described_class.new(123, 456, 789)
      }.should raise_error(ArgumentError, 'wrong number of arguments (3 for 1..2)')
    end

    it "should be able to initialize an ancient week by year and index" do
      week = described_class.new(-1691, 11)

      week.year.should eql Aef::Weekling::Year.new(-1691)
      week.index.should eql 11
    end

    it "should be able to initialize a normal week by year and index" do
      week = described_class.new(2012, 40)

      week.year.should eql Aef::Weekling::Year.new(2012)
      week.index.should eql 40
    end

    it "should be able to initialize a post apocalyptic week by year and index" do
      week = described_class.new(23017, 29)

      week.year.should eql Aef::Weekling::Year.new(23017)
      week.index.should eql 29
    end

    it "should be able to initialize a week by a given Week object" do
      old_week = described_class.new(2011, 30)
      week = described_class.new(old_week)

      week.year.should  eql old_week.year
      week.index.should eql old_week.index
    end

    it "should be able to initialize a week by a given Date object" do
      date = Date.today
      week = described_class.new(date)

      week.year.should eql Aef::Weekling::Year.new(date.year)
      week.index.should eql date.cweek
    end

    it "should be able to initialize a week by a given DateTime object" do
      date = DateTime.now
      week = described_class.new(date)

      week.year.should eql Aef::Weekling::Year.new(date.year)
      week.index.should eql date.cweek
    end

    it "should be able to initialize a week by a given Time object" do
      time = Time.now
      week = described_class.new(time)

      date = time.to_date

      week.year.should eql Aef::Weekling::Year.new(date.year)
      week.index.should eql date.cweek
    end

    it "should accept week 53 for year in which one exists" do
      lambda{
        described_class.new(2015, 53)
      }.should_not raise_error
    end

    it "should report week 53 doesn't exist in the given year" do
      lambda{
        described_class.new(2011, 53)
      }.should raise_error(ArgumentError, /Index .* is invalid. Year .* has only 52 weeks/)
    end

    it "should always report if weeks below index 1 are given" do
      lambda{
        described_class.new(2011, 0)
      }.should raise_error(ArgumentError, /Index .* is invalid. Index can never be lower than 1 or higher than 53/)
    end

    it "should always report if weeks above index 53 are given" do
      lambda{
        described_class.new(2011, 54)
      }.should raise_error(ArgumentError, /Index .* is invalid. Index can never be lower than 1 or higher than 53/)
    end
  end

  context "#== (type independent equality)" do
    it "should be true if year and index match" do
      week = described_class.new(2012, 1)
      other = described_class.new(2012, 1)

      week.should == other
    end

    it "should be true if year and index match, independent of the other object's type" do
      week = described_class.new(2012, 1)

      other = OpenStruct.new
      other.year = Aef::Weekling::Year.new(2012)
      other.index = 1

      week.should == other
    end

    it "should be false if year matches but not index" do
      week = described_class.new(2012, 1)
      other = described_class.new(2012, 13)

      week.should_not == other
    end

    it "should be false if year matches but not index, independent of the other object's type" do
      week = described_class.new(2012, 1)

      other = OpenStruct.new
      other.year = Aef::Weekling::Year.new(2012)
      other.index = 13

      week.should_not == other
    end

    it "should be false if index matches but not year" do
      week = described_class.new(2012, 1)
      other = described_class.new(2005, 1)

      week.should_not == other
    end

    it "should be false if index matches but not year, independent of the other object's type" do
      week = described_class.new(2012, 1)

      other = OpenStruct.new
      other.year = Aef::Weekling::Year.new(2005)
      other.index = 1

      week.should_not == other
    end

    it "should be false if both index and year do not match" do
      week = described_class.new(2012, 1)
      other = described_class.new(2005, 13)

      week.should_not == other
    end

    it "should be false if both index and year do not match, independent of the other object's type" do
      week = described_class.new(2012, 1)

      other = OpenStruct.new
      other.year = Aef::Weekling::Year.new(2005)
      other.index = 13

      week.should_not == other
    end
  end

  context "#eql? (type dependant equality)" do
    it "should be true if year and index and type matches and of same class" do
      week = described_class.new(2012, 1)
      other = described_class.new(2012, 1)

      week.should eql other
    end

    it "should be true if year and index and type matches and of inheriting class" do
      week = described_class.new(2012, 1)

      inheriting_class = Class.new(described_class)

      other = inheriting_class.new(2012, 1)

      week.should eql other
    end

    it "should be false if year and index match but type differs" do
      week = described_class.new(2012, 1)

      other = OpenStruct.new
      other.year = Aef::Weekling::Year.new(2012)
      other.index = 1

      week.should_not eql other
    end

    it "should be false if year matches but not index" do
      week = described_class.new(2012, 1)
      other = described_class.new(2012, 13)

      week.should_not eql other
    end

    it "should be false if index matches but not year" do
      week = described_class.new(2012, 1)
      other = described_class.new(2005, 1)

      week.should_not eql other
    end

    it "should be false if both index and year do not match" do
      week = described_class.new(2012, 1)
      other = described_class.new(2005, 13)

      week.should_not eql other
    end
  end

  context "#hash" do
    it "should return Integers" do
      a_week = described_class.new(2012, 5)
      another_week = described_class.new(2012, 6)

      a_week.hash.should be_a(Integer)
      another_week.hash.should be_a(Integer)
    end

    it "should discriminate a week from another one" do
      a_week = described_class.new(2012, 5)
      another_week = described_class.new(2012, 6)

      a_week.hash.should_not == another_week.hash
    end
  end

  context "#<=>" do
    it "should correctly determine the order of weeks based on year" do
      lower_week = described_class.new(2011, 14)
      higher_week = described_class.new(2012, 14)

      lower_week.should < higher_week
    end

    it "should correctly determine the order of weeks based on year, independent of type" do
      lower_week = described_class.new(2011, 14)
      
      higher_week = OpenStruct.new
      higher_week.year = Aef::Weekling::Year.new(2012)
      higher_week.index = 14

      lower_week.should < higher_week
    end

    it "should correctly determine the order of weeks based on index" do
      lower_week = described_class.new(2011, 14)
      higher_week = described_class.new(2011, 15)

      lower_week.should < higher_week
    end

    it "should correctly determine the order of weeks based on index, independent of type" do
      lower_week = described_class.new(2011, 14)

      higher_week = OpenStruct.new
      higher_week.year = Aef::Weekling::Year.new(2011)
      higher_week.index = 15

      lower_week.should < higher_week
    end

    it "should prioritize the order years when determining the order of weeks" do
      lower_week = described_class.new(2011, 14)
      higher_week = described_class.new(2012, 13)

      lower_week.should < higher_week
    end

    it "should prioritize the order years when determining the order of weeks, independent of type" do
      lower_week = described_class.new(2011, 14)

      higher_week = OpenStruct.new
      higher_week.year = Aef::Weekling::Year.new(2012)
      higher_week.index = 13

      lower_week.should < higher_week
    end
  end

  context "#to_s" do
    it "should be able to display an ancient week" do
      week = described_class.new(-1503, 50)

      week.to_s.should eql '-1503-W50'
    end

    it "should be able to display a normal week" do
      week = described_class.new(2011, 30)

      week.to_s.should eql '2011-W30'
    end

    it "should be able to display a post apocalyptic week" do
      week = described_class.new(50023, 3)

      week.to_s.should eql '50023-W03'
    end
  end

  context "#inspect" do
    it "should be able to display an ancient week" do
      week = described_class.new(-1503, 50)

      week.inspect.should eql '#<Aef::Weekling::Week: -1503-W50>'
    end

    it "should be able to display a normal week" do
      week = described_class.new(2011, 30)

      week.inspect.should eql '#<Aef::Weekling::Week: 2011-W30>'
    end

    it "should be able to display a post apocalyptic week" do
      week = described_class.new(50023, 3)

      week.inspect.should eql '#<Aef::Weekling::Week: 50023-W03>'
    end
  end

  context "#to_week" do
    it "should return itself" do
      week = described_class.new(2011, 30)
      week.to_week.should equal(week)
    end
  end

  [:next, :succ].each do |method|
    context "##{method}" do
      it "should return the next week" do
        described_class.new(2011, 19).method(method).call.should eql described_class.new(2011, 20)
      end

      it "should return the next week at the end of a year" do
        described_class.new(2011, 52).method(method).call.should eql described_class.new(2012, 1)
      end

      it "should return the next week one week before the end of a year with 53 weeks" do
        described_class.new(2015, 52).method(method).call.should eql described_class.new(2015, 53)
      end

      it "should return the next week at the end of a year with 53 weeks" do
        described_class.new(2015, 53).method(method).call.should eql described_class.new(2016, 1)
      end
    end
  end

  [:previous, :pred].each do |method|
    context "##{method}" do
      it "should return the previous week" do
        described_class.new(2011, 20).method(method).call.should eql described_class.new(2011, 19)
      end

      it "should return the previous week at the beginning of a year" do
        described_class.new(2012, 1).method(method).call.should eql described_class.new(2011, 52)
      end

      it "should return the previous week at the beginning of a year after one with 53 weeks" do
        described_class.new(2016, 1).method(method).call.should eql described_class.new(2015, 53)
      end

      it "should return the previous week at the end of a year with 53 weeks" do
        described_class.new(2015, 53).method(method).call.should eql described_class.new(2015, 52)
      end
    end
  end

  context "#+" do
    it "should be able to add a positive amount of weeks" do
      (described_class.new(1998, 10) + 15).should eql described_class.new(1998, 25)
    end

    it "should be able to add a positive amount of weeks so that the result isn't in the year anymore" do
      (described_class.new(1996, 48) + 8).should eql described_class.new(1997, 4)
    end

    it "should be able to add a positive amount of weeks so that the result isn't in the year with 53 weeks anymore" do
      (described_class.new(2004, 48) + 8).should eql described_class.new(2005, 3)
    end

    it "should be able to add a negative amount of weeks" do
      (described_class.new(1998, 20) + -15).should eql described_class.new(1998, 5)
    end

    it "should be able to add a negative amount of weeks so that the result isn't in the year anymore" do
      (described_class.new(1998, 10) + -12).should eql described_class.new(1997, 50)
    end

    it "should be able to add a negative amount of weeks so that the result is in the previous year which has 53 weeks" do
      (described_class.new(2005, 23) + -25).should eql described_class.new(2004, 51)
    end
  end

  context "#-" do
    it "should be able to subtract a positive amount of weeks" do
      (described_class.new(1998, 37) - 15).should eql described_class.new(1998, 22)
    end

    it "should be able to subtract a positive amount of weeks so that the result isn't in the year anymore" do
      (described_class.new(1998, 48) - 53).should eql described_class.new(1997, 47)
    end

    it "should be able to subtract a positive amount of weeks so that the result is in the previous year which has 53 weeks" do
      (described_class.new(2005, 16) - 32).should eql described_class.new(2004, 37)
    end

    it "should be able to subtract a negative amount of weeks" do
      (described_class.new(1998, 20) - -15).should eql described_class.new(1998, 35)
    end

    it "should be able to subtract a negative amount of weeks so that the result isn't in the year anymore" do
      (described_class.new(1996, 40) - -23).should eql described_class.new(1997, 11)
    end

    it "should be able to subtract a negative amount of weeks so that the result isn't in the year with 53 weeks anymore" do
      (described_class.new(2004, 49) - -31).should eql described_class.new(2005, 27)
    end
  end
    
  context "#until_index" do
    it "should return a range ending in the current year if the given index is greater to the weeks index" do
      week = described_class.new(2011, 13)

      week.until_index(46).should eql (week .. described_class.new(2011, 46))
    end

    it "should return a range ending in the next year if the given index is equal to the weeks index" do
      week = described_class.new(2011, 13)

      week.until_index(13).should eql (week .. described_class.new(2012, 13))
    end

    it "should return a range ending in the next year if the given index is equal to the weeks index" do
      week = described_class.new(2011, 13)

      week.until_index(3).should eql (week .. described_class.new(2012, 3))
    end
  end

  context "#even?" do
    it "should be true if the index is even" do
      described_class.new(420, 6).should be_even
      described_class.new(2011, 42).should be_even
      described_class.new(25043, 28).should be_even
    end

    it "should be false if the index is odd" do
      described_class.new(420, 7).should_not be_even
      described_class.new(2011, 43).should_not be_even
      described_class.new(25043, 29).should_not be_even
    end
  end

  context "#odd?" do
    it "should be true if the index is odd" do
      described_class.new(420, 7).should be_odd
      described_class.new(2011, 43).should be_odd
      described_class.new(25043, 29).should be_odd
    end

    it "should be false if the index is even" do
      described_class.new(420, 6).should_not be_odd
      described_class.new(2011, 42).should_not be_odd
      described_class.new(25043, 28).should_not be_odd
    end
  end

  context "#days" do
    it "should return a range of the weeks days" do
      described_class.new(2011, 15).days.should eql(
        (Aef::Weekling::WeekDay.new(2011, 15, 1)..Aef::Weekling::WeekDay.new(2011, 15, 7)))
    end
  end

  context "#day" do
    it "should return a day by index" do
      described_class.new(2011, 15).day(1).should eql Aef::Weekling::WeekDay.new(2011, 15, 1)
    end

    it "should return a day by symbol" do
      described_class.new(2011, 15).day(:friday).should eql Aef::Weekling::WeekDay.new(2011, 15, 5)
    end
  end

  context "weekday methods" do
    before(:all) do
      @week = described_class.new(2011, 17)
    end

    it "should deliver monday" do
      @week.monday.should eql Aef::Weekling::WeekDay.new(@week, 1)
    end

    it "should deliver tuesday" do
      @week.tuesday.should eql Aef::Weekling::WeekDay.new(@week, 2)
    end

    it "should deliver wednesday" do
      @week.wednesday.should eql Aef::Weekling::WeekDay.new(@week, 3)
    end

    it "should deliver thursday" do
      @week.thursday.should eql Aef::Weekling::WeekDay.new(@week, 4)
    end

    it "should deliver friday" do
      @week.friday.should eql Aef::Weekling::WeekDay.new(@week, 5)
    end

    it "should deliver saturday" do
      @week.saturday.should eql Aef::Weekling::WeekDay.new(@week, 6)
    end

    it "should deliver sunday" do
      @week.sunday.should eql Aef::Weekling::WeekDay.new(@week, 7)
    end

    it "should deliver the weekend" do
      @week.weekend.should eql [Aef::Weekling::WeekDay.new(@week, 6), Aef::Weekling::WeekDay.new(@week, 7)]
    end
  end
end
