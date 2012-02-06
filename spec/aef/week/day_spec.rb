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

require 'spec_helper'
require 'aef/week/day'
require 'ostruct'

describe Aef::Week::Day do
  [:today, :now].each do |method|
    context ".#{method}" do
      it "should generate a representation of the current day as week day" do
        today = Date.today

        week_day = described_class.method(method).call

        week_day.week.year.should  == today.year
        week_day.week.index.should == today.cweek
        week_day.index.should      == ((today.wday - 1) % 7) + 1
      end
    end
  end
  
  context ".parse" do
    it "should recognize an ancient week day" do
      week_day = described_class.parse('-1503-W50-6')

      week_day.week.should  == Aef::Week.new(-1503, 50)
      week_day.index.should == 6
    end

    it "should recognize a normal week day" do
      week_day = described_class.parse('2011-W30-1')

      week_day.week.should  == Aef::Week.new(2011, 30)
      week_day.index.should == 1
    end

    it "should recognize a post apocalyptic week day" do
      week_day = described_class.parse('50023-W03-7')

      week_day.week.should  == Aef::Week.new(50023, 3)
      week_day.index.should == 7
    end

    it "should report being unable to parse the given String" do
      lambda{
        described_class.parse('no week day!')
      }.should raise_error(ArgumentError, 'No week day found for parsing')
    end
  end

  [:new, :[]].each do |method|
    context ".#{method}" do
      it "should allow to create a weekday by a given year, week index and day index" do
        week_day = described_class.method(method).call(2011, 1, 6)
        week_day.week.should  == Aef::Week.new(2011, 1)
        week_day.index.should == 6
      end

      it "should allow to create a weekday by a given year, week index and day symbol" do
        week_day = described_class.method(method).call(2011, 1, :saturday)
        week_day.week.should  == Aef::Week.new(2011, 1)
        week_day.index.should == 6
      end

      it "should allow to create a weekday by a given Week::Day object" do
        old_week_day = described_class.new(2011, 1, 6)

        week_day = described_class.method(method).call(old_week_day)
        week_day.week.should  == Aef::Week.new(2011, 1)
        week_day.index.should == 6
      end

      it "should allow to create a weekday by a given Week object and day index" do
        week_day = described_class.method(method).call(Aef::Week.new(2011, 1), 3)
        week_day.week.should  == Aef::Week.new(2011, 1)
        week_day.index.should == 3
      end

      it "should allow to create a weekday by a given Week object and day symbol" do
        week_day = described_class.method(method).call(Aef::Week.new(2011, 1), :wednesday)
        week_day.week.should  == Aef::Week.new(2011, 1)
        week_day.index.should == 3
      end

      it "should allow to create a weekday by a given Date object" do
        date = Date.new(2011, 04, 06)

        week_day = described_class.method(method).call(date)
        week_day.week.should  == Aef::Week.new(2011, 14)
        week_day.index.should == 3
      end

      it "should allow to create a weekday by a given DateTime object" do
        datetime = DateTime.new(2011, 04, 06, 16, 45, 30)

        week_day = described_class.method(method).call(datetime)
        week_day.week.should  == Aef::Week.new(2011, 14)
        week_day.index.should == 3
      end

      it "should allow to create a weekday by a given Time object" do
        datetime = Time.new(2011, 04, 06, 16, 45, 30)

        week_day = described_class.method(method).call(datetime)
        week_day.week.should  == Aef::Week.new(2011, 14)
        week_day.index.should == 3
      end

      it "should complain about a day index below 1" do
        lambda {
          described_class.method(method).call(Aef::Week.today, 0)
        }.should raise_error(ArgumentError)
      end

      it "should complain about a day index above 7" do
        lambda {
          described_class.method(method).call(Aef::Week.today, 8)
        }.should raise_error(ArgumentError)
      end

      it "should complain about an invalid day symbol" do
        lambda {
          described_class.method(method).call(Aef::Week.today, :poopsday)
        }.should raise_error(ArgumentError)
      end
    end
  end
  
  context "#== (type independent equality)" do
    it "should be true if week and index match" do
      week =  described_class.new(2012, 1, 3)
      other = described_class.new(2012, 1, 3)

      week.should == other
    end

    it "should be true if week and index match, independent of the other object's type" do
      week = described_class.new(2012, 1, 3)

      other = OpenStruct.new
      other.week = Aef::Week.new(2012, 1)
      other.index = 3

      week.should == other
    end

    it "should be false if week matches but not index" do
      week  = described_class.new(2012, 1, 2)
      other = described_class.new(2012, 1, 4)

      week.should_not == other
    end

    it "should be false if week matches but not index, independent of the other object's type" do
      week = described_class.new(2012, 1, 2)

      other = OpenStruct.new
      other.week = Aef::Week.new(2012, 1)
      other.index = 4

      week.should_not == other
    end

    it "should be false if index matches but not week" do
      week = described_class.new(2011, 15, 1)
      other = described_class.new(2011, 17, 1)

      week.should_not == other
    end

    it "should be false if index matches but not week, independent of the other object's type" do
      week = described_class.new(2011, 15, 1)

      other = OpenStruct.new
      other.week = Aef::Week.new(2011, 17)
      other.index = 1

      week.should_not == other
    end

    it "should be false if both index and week do not match" do
      week = described_class.new(2012, 23, 1)
      other = described_class.new(2005, 14, 5)

      week.should_not == other
    end

    it "should be false if both index and year do not match, independent of the other object's type" do
      week = described_class.new(2012, 23, 1)

      other = OpenStruct.new
      other.week = Aef::Week.new(2005, 14)
      other.index = 13

      week.should_not == other
    end
  end

  context "#eql? (type dependent equality)" do
    it "should be true if week and index match" do
      week =  described_class.new(2012, 1, 3)
      other = described_class.new(2012, 1, 3)

      week.should == other
    end

    it "should be false if week matches but not index" do
      week  = described_class.new(2012, 1, 2)
      other = described_class.new(2012, 1, 4)

      week.should_not == other
    end

    it "should be false if index matches but not week" do
      week = described_class.new(2011, 15, 1)
      other = described_class.new(2011, 17, 1)

      week.should_not == other
    end

    it "should be false if both index and week do not match" do
      week = described_class.new(2012, 23, 1)
      other = described_class.new(2005, 14, 4)

      week.should_not == other
    end
  end

  context "#<=>" do
    it "should correctly determine the order of week days based on week" do
      lower_week_day = described_class.new(2011, 13, 3)
      higher_week_day = described_class.new(2012, 50, 3)

      lower_week_day.should < higher_week_day
    end

    it "should correctly determine the order of week days based on year, independent of type" do
      lower_week_day = described_class.new(2011, 13, 3)

      higher_week_day = OpenStruct.new
      higher_week_day.week = Aef::Week.new(2012, 50)
      higher_week_day.index = 3

      lower_week_day.should < higher_week_day
    end

    it "should correctly determine the order of week days based on index" do
      lower_week_day = described_class.new(2011, 15, 2)
      higher_week_day = described_class.new(2011, 15, 3)

      lower_week_day.should < higher_week_day
    end

    it "should correctly determine the order of week days based on index, independent of type" do
      lower_week_day = described_class.new(2011, 15, 2)

      higher_week_day = OpenStruct.new
      higher_week_day.week = Aef::Week.new(2011, 15)
      higher_week_day.index = 3

      lower_week_day.should < higher_week_day
    end

    it "should prioritize the order weeks when determining the order of week days" do
      lower_week_day = described_class.new(2012, 13, 4)
      higher_week_day = described_class.new(2012, 14, 3)

      lower_week_day.should < higher_week_day
    end

    it "should prioritize the order weeks when determining the order of week days, independent of type" do
      lower_week_day = described_class.new(2012, 13, 4)

      higher_week_day = OpenStruct.new
      higher_week_day.week = Aef::Week.new(2012, 14)
      higher_week_day.index = 3

      lower_week_day.should < higher_week_day
    end
  end

  context "#to_s" do
    it "should be able to display an ancient week day" do
      week_day = described_class.new(-1503, 50, 3)

      week_day.to_s.should == '-1503-W50-3'
    end

    it "should be able to display a normal week" do
      week_day = described_class.new(2011, 30, 7)

      week_day.to_s.should == '2011-W30-7'
    end

    it "should be able to display a post apocalyptic week" do
      week_day = described_class.new(50023, 3, 1)

      week_day.to_s.should == '50023-W03-1'
    end
  end

  context "#to_date" do
    it "should translate to the Date of the day" do
      week_day = described_class.new(2011, 30, 3)

      week_day.to_date.should == Date.new(2011, 7, 27)
    end

    it "should translate to the Date of the day in edge cases early in the year" do
      week_day = described_class.new(2010, 52, 6)

      week_day.to_date.should == Date.new(2011, 1, 1)
    end

    it "should translate to the Date of the day in edge cases late in the year" do
      week_day = described_class.new(2011, 52, 7)

      week_day.to_date.should == Date.new(2012, 1, 1)
    end
  end

  context "#to_week_date" do
    it "should return itself" do
      week_day = described_class.new(2011, 30, 6)
      week_day.to_week_day.should equal(week_day)
    end
  end

  [:next, :succ].each do |method|
    context "##{method}" do
      it "should return the next week day" do
        described_class.new(2011, 19, 3).method(method).call.should == described_class.new(2011, 19, 4)
      end

      it "should return the next week day at the end of a week" do
        described_class.new(2011, 30, 7).method(method).call.should == described_class.new(2011, 31, 1)
      end
    end
  end

  [:previous, :pred].each do |method|
    context "##{method}" do
      it "should return the previous week day" do
        described_class.new(2011, 20, 3).method(method).call.should == described_class.new(2011, 20, 2)
      end

      it "should return the previous week day at the beginning of a week" do
        described_class.new(2011, 9, 1).method(method).call.should == described_class.new(2011, 8, 7)
      end
    end
  end

  context "weekday methods" do
    it "should report monday" do
      week_day = described_class.new(2011, 17, 1)
      week_day.monday?.should be_true
      week_day.tuesday?.should be_false
      week_day.wednesday?.should be_false
      week_day.thursday?.should be_false
      week_day.friday?.should be_false
      week_day.saturday?.should be_false
      week_day.sunday?.should be_false
      week_day.weekend?.should be_false
      week_day.to_sym.should == :monday
    end

    it "should report tuesday" do
      week_day = described_class.new(2011, 17, 2)
      week_day.monday?.should be_false
      week_day.tuesday?.should be_true
      week_day.wednesday?.should be_false
      week_day.thursday?.should be_false
      week_day.friday?.should be_false
      week_day.saturday?.should be_false
      week_day.sunday?.should be_false
      week_day.weekend?.should be_false
      week_day.to_sym.should == :tuesday
    end

    it "should report wednesday" do
      week_day = described_class.new(2011, 17, 3)
      week_day.monday?.should be_false
      week_day.tuesday?.should be_false
      week_day.wednesday?.should be_true
      week_day.thursday?.should be_false
      week_day.friday?.should be_false
      week_day.saturday?.should be_false
      week_day.sunday?.should be_false
      week_day.weekend?.should be_false
      week_day.to_sym.should == :wednesday
    end

    it "should report thursday" do
      week_day = described_class.new(2011, 17, 4)
      week_day.monday?.should be_false
      week_day.tuesday?.should be_false
      week_day.wednesday?.should be_false
      week_day.thursday?.should be_true
      week_day.friday?.should be_false
      week_day.saturday?.should be_false
      week_day.sunday?.should be_false
      week_day.weekend?.should be_false
      week_day.to_sym.should == :thursday
    end

    it "should report friday" do
      week_day = described_class.new(2011, 17, 5)
      week_day.monday?.should be_false
      week_day.tuesday?.should be_false
      week_day.wednesday?.should be_false
      week_day.thursday?.should be_false
      week_day.friday?.should be_true
      week_day.saturday?.should be_false
      week_day.sunday?.should be_false
      week_day.weekend?.should be_false
      week_day.to_sym.should == :friday
    end

    it "should report saturday" do
      week_day = described_class.new(2011, 17, 6)
      week_day.monday?.should be_false
      week_day.tuesday?.should be_false
      week_day.wednesday?.should be_false
      week_day.thursday?.should be_false
      week_day.friday?.should be_false
      week_day.saturday?.should be_true
      week_day.sunday?.should be_false
      week_day.weekend?.should be_true
      week_day.to_sym.should == :saturday
    end

    it "should report sunday" do
      week_day = described_class.new(2011, 17, 7)
      week_day.monday?.should be_false
      week_day.tuesday?.should be_false
      week_day.wednesday?.should be_false
      week_day.thursday?.should be_false
      week_day.friday?.should be_false
      week_day.saturday?.should be_false
      week_day.sunday?.should be_true
      week_day.weekend?.should be_true
      week_day.to_sym.should == :sunday
    end
  end
end
