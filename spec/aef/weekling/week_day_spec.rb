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

require 'spec_helper'
require 'aef/weekling/week_day'
require 'ostruct'

describe Aef::Weekling::WeekDay do
  [:today, :now].each do |method|
    context ".#{method}" do
      it "should generate a representation of the current day as week day" do
        today = Date.today

        week_day = described_class.method(method).call

        week_day.week.year.should  eql Aef::Weekling::Year.new(today.year)
        week_day.week.index.should eql today.cweek
        week_day.index.should      eql ((today.wday - 1) % 7) + 1
      end
    end
  end
  
  context ".parse" do
    it "should recognize an ancient week day" do
      week_day = described_class.parse('-1503-W50-6')

      week_day.week.should  eql Aef::Weekling::Week.new(-1503, 50)
      week_day.index.should eql 6
    end

    it "should recognize a normal week day" do
      week_day = described_class.parse('2011-W30-1')

      week_day.week.should  eql Aef::Weekling::Week.new(2011, 30)
      week_day.index.should eql 1
    end

    it "should recognize a post apocalyptic week day" do
      week_day = described_class.parse('50023-W03-7')

      week_day.week.should  eql Aef::Weekling::Week.new(50023, 3)
      week_day.index.should eql 7
    end

    it "should report being unable to parse the given String" do
      lambda{
        described_class.parse('no week day!')
      }.should raise_error(ArgumentError, 'No week day found for parsing')
    end
  end

  context ".new" do
    it "should complain about a param of invalid type" do
      lambda {
        described_class.new(123)
      }.should raise_error(ArgumentError, 'A single argument must either respond to #week and #index or to #to_date')
    end

    it "should complain about less than one argument" do
      lambda {
        described_class.new
      }.should raise_error(ArgumentError, 'wrong number of arguments (0 for 1..3)')
    end

    it "should complain about more than three arguments" do
      lambda {
        described_class.new(123, 456, 789, 123)
      }.should raise_error(ArgumentError, 'wrong number of arguments (4 for 1..3)')
    end

    it "should allow to create a weekday by a given year, week index and day index" do
      week_day = described_class.new(2011, 1, 6)
      week_day.week.should  eql Aef::Weekling::Week.new(2011, 1)
      week_day.index.should eql 6
    end

    it "should allow to create a weekday by a given year, week index and day symbol" do
      week_day = described_class.new(2011, 1, :saturday)
      week_day.week.should  eql Aef::Weekling::Week.new(2011, 1)
      week_day.index.should eql 6
    end

    it "should allow to create a weekday by a given WeekDay object" do
      old_week_day = described_class.new(2011, 1, 6)

      week_day = described_class.new(old_week_day)
      week_day.week.should  eql Aef::Weekling::Week.new(2011, 1)
      week_day.index.should eql 6
    end

    it "should allow to create a weekday by a given Week object and day index" do
      week_day = described_class.new(Aef::Weekling::Week.new(2011, 1), 3)
      week_day.week.should  eql Aef::Weekling::Week.new(2011, 1)
      week_day.index.should eql 3
    end

    it "should allow to create a weekday by a given Week object and day symbol" do
      week_day = described_class.new(Aef::Weekling::Week.new(2011, 1), :wednesday)
      week_day.week.should  eql Aef::Weekling::Week.new(2011, 1)
      week_day.index.should eql 3
    end

    it "should allow to create a weekday by a given Date object" do
      date = Date.new(2011, 04, 06)

      week_day = described_class.new(date)
      week_day.week.should  eql Aef::Weekling::Week.new(2011, 14)
      week_day.index.should eql 3
    end

    it "should allow to create a weekday by a given DateTime object" do
      datetime = DateTime.new(2011, 04, 06, 16, 45, 30)

      week_day = described_class.new(datetime)
      week_day.week.should  eql Aef::Weekling::Week.new(2011, 14)
      week_day.index.should eql 3
    end

    it "should allow to create a weekday by a given Time object" do
      datetime = Time.new(2011, 04, 06, 16, 45, 30)

      week_day = described_class.new(datetime)
      week_day.week.should  eql Aef::Weekling::Week.new(2011, 14)
      week_day.index.should eql 3
    end

    it "should complain about a day index below 1" do
      lambda {
        described_class.new(Aef::Weekling::Week.today, 0)
      }.should raise_error(ArgumentError)
    end

    it "should complain about a day index above 7" do
      lambda {
        described_class.new(Aef::Weekling::Week.today, 8)
      }.should raise_error(ArgumentError)
    end

    it "should complain about an invalid day symbol" do
      lambda {
        described_class.new(Aef::Weekling::Week.today, :poopsday)
      }.should raise_error(ArgumentError)
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
      other.week = Aef::Weekling::Week.new(2012, 1)
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
      other.week = Aef::Weekling::Week.new(2012, 1)
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
      other.week = Aef::Weekling::Week.new(2011, 17)
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
      other.week = Aef::Weekling::Week.new(2005, 14)
      other.index = 5

      week.should_not == other
    end
  end

  context "#eql? (type dependent equality)" do
    it "should be true if week and index match" do
      week =  described_class.new(2012, 1, 3)
      other = described_class.new(2012, 1, 3)

      week.should eql other
    end

    it "should be false if week matches but not index" do
      week  = described_class.new(2012, 1, 2)
      other = described_class.new(2012, 1, 4)

      week.should_not eql other
    end

    it "should be false if index matches but not week" do
      week = described_class.new(2011, 15, 1)
      other = described_class.new(2011, 17, 1)

      week.should_not eql other
    end

    it "should be false if both index and week do not match" do
      week = described_class.new(2012, 23, 1)
      other = described_class.new(2005, 14, 4)

      week.should_not eql other
    end
  end

  context "#hash" do
    it "should return Integers" do
      a_week_day = described_class.new(2012, 5, 4)
      another_week_day = described_class.new(2012, 5, 5)

      a_week_day.hash.should be_a(Integer)
      another_week_day.hash.should be_a(Integer)
    end

    it "should discriminate a week-day from another one" do
      a_week_day = described_class.new(2012, 5, 4)
      another_week_day = described_class.new(2012, 5, 5)

      a_week_day.hash.should_not == another_week_day.hash
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
      higher_week_day.week = Aef::Weekling::Week.new(2012, 50)
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
      higher_week_day.week = Aef::Weekling::Week.new(2011, 15)
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
      higher_week_day.week = Aef::Weekling::Week.new(2012, 14)
      higher_week_day.index = 3

      lower_week_day.should < higher_week_day
    end
  end

  context "#to_s" do
    it "should be able to display an ancient week day" do
      week_day = described_class.new(-1503, 50, 3)

      week_day.to_s.should eql '-1503-W50-3'
    end

    it "should be able to display a normal week" do
      week_day = described_class.new(2011, 30, 7)

      week_day.to_s.should eql '2011-W30-7'
    end

    it "should be able to display a post apocalyptic week" do
      week_day = described_class.new(50023, 3, 1)

      week_day.to_s.should eql '50023-W03-1'
    end
  end

  context "#inspect" do
    it "should be able to display an ancient week day" do
      week_day = described_class.new(-1503, 50, 3)

      week_day.inspect.should eql '#<Aef::Weekling::WeekDay: -1503-W50-3>'
    end

    it "should be able to display a normal week" do
      week_day = described_class.new(2011, 30, 7)

      week_day.inspect.should eql '#<Aef::Weekling::WeekDay: 2011-W30-7>'
    end

    it "should be able to display a post apocalyptic week" do
      week_day = described_class.new(50023, 3, 1)

      week_day.inspect.should eql '#<Aef::Weekling::WeekDay: 50023-W03-1>'
    end
  end

  context "#to_date" do
    it "should translate to the Date of the day" do
      week_day = described_class.new(2011, 30, 3)

      week_day.to_date.should eql Date.new(2011, 7, 27)
    end

    it "should translate to the Date of the day in edge cases early in the year" do
      week_day = described_class.new(2010, 52, 6)

      week_day.to_date.should eql Date.new(2011, 1, 1)
    end

    it "should translate to the Date of the day in edge cases late in the year" do
      week_day = described_class.new(2011, 52, 7)

      week_day.to_date.should eql Date.new(2012, 1, 1)
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
        described_class.new(2011, 19, 3).method(method).call.should eql described_class.new(2011, 19, 4)
      end

      it "should return the next week day at the end of a week" do
        described_class.new(2011, 30, 7).method(method).call.should eql described_class.new(2011, 31, 1)
      end

      it "should return the next week day at the end of a year with 52 weeks" do
        described_class.new(2000, 52, 7).method(method).call.should eql described_class.new(2001, 1, 1)
      end

      it "should return the next week day at the end of a year with 53 weeks" do
        described_class.new(1998, 53, 7).method(method).call.should eql described_class.new(1999, 1, 1)
      end
    end
  end

  [:previous, :pred].each do |method|
    context "##{method}" do
      it "should return the previous week day" do
        described_class.new(2011, 20, 3).method(method).call.should eql described_class.new(2011, 20, 2)
      end

      it "should return the previous week day at the beginning of a week" do
        described_class.new(2011, 9, 1).method(method).call.should eql described_class.new(2011, 8, 7)
      end

      it "should return the previous week day at the beginning of a year following a year with 52 weeks" do
        described_class.new(2001, 1, 1).method(method).call.should eql described_class.new(2000, 52, 7)
      end

      it "should return the previous week day at the beginning of a year following a year with 53 weeks" do
        described_class.new(1999, 1, 1).method(method).call.should eql described_class.new(1998, 53, 7)
      end
    end
  end

  context "#+" do
    it "should be able to add a positive amount of days" do
      (described_class.new(1996, 51, 4) + 2).should eql described_class.new(1996, 51, 6)
    end

    it "should be able to add a positive amount of days so that the result isn't in the week anymore'" do
      (described_class.new(1996, 51, 4) + 4).should eql described_class.new(1996, 52, 1)
    end

    it "should be able to add a positive amount of days so that the result isn't in the year anymore'" do
      (described_class.new(1996, 51, 4) + 12).should eql described_class.new(1997, 1, 2)
    end

    it "should be able to add a positive amount of days so that the result isn't in the year with 53 weeks anymore'" do
      (described_class.new(1998, 51, 4) + 20).should eql described_class.new(1999, 1, 3)
    end

    it "should be able to add a negative amount of days" do
      (described_class.new(1996, 2, 4) + -2).should eql described_class.new(1996, 2, 2)
    end

    it "should be able to add a negative amount of days so that the result isn't in the week anymore'" do
      (described_class.new(1996, 2, 4) + -5).should eql described_class.new(1996, 1, 6)
    end

    it "should be able to add a negative amount of days so that the result isn't in the year anymore'" do
      (described_class.new(1996, 2, 4) + -15).should eql described_class.new(1995, 52, 3)
    end

    it "should be able to add a negative amount of days so that the result is in the previous year with 53 weeks'" do
      (described_class.new(1999, 2, 1) + -10).should eql described_class.new(1998, 53, 5)
    end

    it "should be able to add zero days" do
      (described_class.new(1996, 51, 4) + 0).should eql described_class.new(1996, 51, 4)
    end
  end

  context "#-" do
    it "should be able to subtract a positive amount of days" do
      (described_class.new(1996, 2, 4) - 2).should eql described_class.new(1996, 2, 2)
    end

    it "should be able to subtract a positive amount of days so that the result isn't in the week anymore'" do
      (described_class.new(1996, 2, 4) - 5).should eql described_class.new(1996, 1, 6)
    end

    it "should be able to subtract a positive amount of days so that the result isn't in the year anymore'" do
      (described_class.new(1996, 2, 4) - 15).should eql described_class.new(1995, 52, 3)
    end

    it "should be able to subtract a positive amount of days so that the result is in the previous year with 53 weeks'" do
      (described_class.new(1999, 2, 1) - 10).should eql described_class.new(1998, 53, 5)
    end

    it "should be able to subtract a negative amount of days" do
      (described_class.new(1996, 51, 4) - -2).should eql described_class.new(1996, 51, 6)
    end

    it "should be able to subtract a negative amount of days so that the result isn't in the week anymore'" do
      (described_class.new(1996, 51, 4) - -4).should eql described_class.new(1996, 52, 1)
    end

    it "should be able to subtract a negative amount of days so that the result isn't in the year anymore'" do
      (described_class.new(1996, 51, 4) - -12).should eql described_class.new(1997, 1, 2)
    end

    it "should be able to subtract a negative amount of days so that the result isn't in the year with 53 weeks anymore'" do
      (described_class.new(1998, 51, 4) - -20).should eql described_class.new(1999, 1, 3)
    end

    it "should be able to subtract zero days" do
      (described_class.new(1996, 51, 4) - 0).should eql described_class.new(1996, 51, 4)
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
      week_day.to_sym.should eql :monday
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
      week_day.to_sym.should eql :tuesday
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
      week_day.to_sym.should eql :wednesday
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
      week_day.to_sym.should eql :thursday
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
      week_day.to_sym.should eql :friday
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
      week_day.to_sym.should eql :saturday
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
      week_day.to_sym.should eql :sunday
    end
  end
end
