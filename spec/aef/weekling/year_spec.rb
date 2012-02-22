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

require 'spec_helper'
require 'aef/weekling/year'
require 'ostruct'

describe Aef::Weekling::Year do
  [:today, :now].each do |method|
    context ".#{method}" do
      it "should find the current year" do
        year = described_class.method(method).call
        today = Date.today

        year.index.should eql today.year
      end
    end
  end

  context ".parse" do
    it "should recognize an ancient year" do
      year = described_class.parse('-1503')

      year.index.should eql -1503
    end

    it "should recognize a normal year" do
      year = described_class.parse('2011')

      year.index.should eql 2011
    end

    it "should recognize a post apocalyptic year" do
      year = described_class.parse('50023')

      year.index.should eql 50023
    end

    it "should report being unable to parse the given String" do
      lambda{
        described_class.parse('no year!')
      }.should raise_error(ArgumentError, 'No year found for parsing')
    end
  end

  context ".new" do
    it "should complain about a param of invalid type" do
      lambda {
        described_class.new(/abc/)
      }.should raise_error(ArgumentError, 'A single argument must either respond to #to_date or to #to_i')
    end

    it "should be able to initialize an ancient year by index" do
      year = described_class.new(-1691)

      year.index.should eql -1691
    end

    it "should be able to initialize a normal year by index" do
      year = described_class.new(2012)

      year.index.should eql 2012
    end

    it "should be able to initialize a post apocalyptic year by index" do
      year = described_class.new(23017)

      year.index.should eql 23017
    end

    it "should be able to initialize a year by a given Year object" do
      old_year = described_class.new(2011)
      year = described_class.new(old_year)

      year.index.should eql old_year.index
    end

    it "should be able to initialize a year by a given Date object" do
      date = Date.today
      year = described_class.new(date)

      year.index.should eql date.year
    end

    it "should be able to initialize a year by a given DateTime object" do
      date = DateTime.now
      year = described_class.new(date)

      year.index.should eql date.year
    end

    it "should be able to initialize a year by a given Time object" do
      time = Time.now
      year = described_class.new(time)

      date = time.to_date

      year.index.should eql date.year
    end
  end

  context "#== (type independent equality)" do
    it "should be true if index matches" do
      year = described_class.new(2012)
      other = described_class.new(2012)

      year.should == other
    end

    it "should be true if index matches, independent of the other object's type" do
      year = described_class.new(2012)

      other = OpenStruct.new(to_i: 2012)

      year.should == other
    end

    it "should be false if index doesn't match" do
      year = described_class.new(2012)
      other = described_class.new(2013)

      year.should_not == other
    end

    it "should be false if index doesn't match, independent of the other object's type" do
      year = described_class.new(2012)

      other = OpenStruct.new(to_i: 2013)

      year.should_not == other
    end
  end

  context "#eql? (type dependant equality)" do
    it "should be true if index matches and other is of same class" do
      year = described_class.new(2012)
      other = described_class.new(2012)

      year.should eql other
    end

    it "should be true if index matches and other is of descendent class" do
      year = described_class.new(2012)

      inheriting_class = Class.new(described_class)

      other = inheriting_class.new(2012)

      year.should eql other
    end

    it "should be false if index matches but type differs" do
      year = described_class.new(2012)

      other = OpenStruct.new(to_i: 2012)

      year.should_not eql other
    end

    it "should be false if index doesn't match" do
      year = described_class.new(2012)
      other = described_class.new(2005)

      year.should_not eql other
    end
  end

  context "#hash" do
    it "should return Integers" do
      a_year = described_class.new(2012)
      another_year = described_class.new(2013)

      a_year.hash.should be_a(Integer)
      another_year.hash.should be_a(Integer)
    end

    it "should discriminate a year from another one" do
      a_year = described_class.new(2012)
      another_year = described_class.new(2013)

      a_year.hash.should_not == another_year.hash
    end
  end

  context "#<=>" do
    it "should correctly determine the order of years" do
      lower_year = described_class.new(2011)
      higher_year = described_class.new(2012)

      lower_year.should < higher_year
    end

    it "should correctly determine the order of years, independent of type" do
      lower_year = described_class.new(2011)

      higher_year = OpenStruct.new(to_year: OpenStruct.new(index: 2012))

      lower_year.should < higher_year
    end
  end

  context "#to_s" do
    it "should be able to display an ancient year" do
      year = described_class.new(-1503)

      year.to_s.should eql '-1503'
    end

    it "should be able to display a normal year" do
      year = described_class.new(2011)

      year.to_s.should eql '2011'
    end

    it "should be able to display a post apocalyptic year" do
      year = described_class.new(50023)

      year.to_s.should eql '50023'
    end   
  end

  context "#inspect" do
    it "should be able to display an ancient year" do
      year = described_class.new(-1503)

      year.inspect.should eql '#<Aef::Weekling::Year: -1503>'
    end

    it "should be able to display a normal year" do
      year = described_class.new(2011)

      year.inspect.should eql '#<Aef::Weekling::Year: 2011>'
    end

    it "should be able to display a post apocalyptic year" do
      year = described_class.new(50023)

      year.inspect.should eql '#<Aef::Weekling::Year: 50023>'
    end
  end

  context "#to_year" do
    it "should return itself" do
      year = described_class.new(2011)
      year.to_year.should equal(year)
    end
  end

  [:next, :succ].each do |method|
    context "##{method}" do
      it "should return the next year" do
        described_class.new(2011).method(method).call.should eql described_class.new(2012)
      end
    end
  end

  [:previous, :pred].each do |method|
    context "##{method}" do
      it "should return the previous year" do
        described_class.new(2011).method(method).call.should eql described_class.new(2010)
      end
    end
  end

  context "#+" do
    it "should be able to add a positive amount of years" do
      (described_class.new(1998) + 15).should eql described_class.new(2013)
    end

    it "should be able to add a negative amount of years" do
      (described_class.new(1998) + -12).should eql described_class.new(1986)
    end

    it "should be able to add zero years" do
      (described_class.new(1998) + 0).should eql described_class.new(1998)
    end
  end

  context "#-" do
    it "should be able to subtract a positive amount of years" do
      (described_class.new(1998) - 15).should eql described_class.new(1983)
    end

    it "should be able to subtract a negative amount of years" do
      (described_class.new(1998) - -12).should eql described_class.new(2010)
    end

    it "should be able to add zero years" do
      (described_class.new(1998) - 0).should eql described_class.new(1998)
    end
  end

  context "#even?" do
    it "should be true if the index is even" do
      described_class.new(420).should be_even
      described_class.new(2012).should be_even
      described_class.new(25046).should be_even
    end

    it "should be false if the index is odd" do
      described_class.new(419).should_not be_even
      described_class.new(2011).should_not be_even
      described_class.new(25043).should_not be_even
    end
  end

  context "#leap?" do
    it "should be true if year is a leap year" do
      Aef::Weekling::Year.new(2004).should be_leap
      Aef::Weekling::Year.new(1804).should be_leap
      Aef::Weekling::Year.new(2016).should be_leap
    end

    it "should be false if year is not a leap year" do
      Aef::Weekling::Year.new(1998).should_not be_leap
      Aef::Weekling::Year.new(2100).should_not be_leap
      Aef::Weekling::Year.new(2003).should_not be_leap
    end
  end

  context "#odd?" do
    it "should be true if the index is odd" do
      described_class.new(419).should be_odd
      described_class.new(2011).should be_odd
      described_class.new(25043).should be_odd
    end

    it "should be false if the index is even" do
      described_class.new(420).should_not be_odd
      described_class.new(2012).should_not be_odd
      described_class.new(25046).should_not be_odd
    end
  end

  context "#week_count" do
    it "should return the correct amount of weeks for years with 52 weeks" do
      described_class.new(1985).week_count.should eql 52
      described_class.new(2002).week_count.should eql 52
      described_class.new(2024).week_count.should eql 52
    end

    it "should return the correct amount of weeks for years with 53 weeks" do
      described_class.new(1981).week_count.should eql 53
      described_class.new(2020).week_count.should eql 53
      described_class.new(2026).week_count.should eql 53
    end
  end

  context "#weeks" do
    it "should return a range of weeks" do
      described_class.new(2011).weeks.should eql(
        (Aef::Weekling::Week.new(2011, 1)..Aef::Weekling::Week.new(2011, 52)))
    end
  end

  context "#week" do
    it "should return a week by index" do
      described_class.new(2011).week(17).should eql Aef::Weekling::Week.new(2011, 17)
    end
  end

end
