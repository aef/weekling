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
require 'weekling'

describe "weekling gem" do
  it "should include the Aef namespace into Object" do
    Object.should include Aef::Weekling
    Year.should equal Aef::Weekling::Year
    Week.should equal Aef::Weekling::Week
    WeekDay.should equal Aef::Weekling::WeekDay
  end

  shared_examples_for "convertible to year" do
    it "should be convertible to year" do
      subject.should respond_to(:to_year)
      subject.to_year.should be_a(Aef::Weekling::Year)
    end
  end

  shared_examples_for "convertible to week" do
    it "should be convertible to week" do
      subject.should respond_to(:to_week)
      subject.to_week.should be_a(Aef::Weekling::Week)
    end
  end

  shared_examples_for "convertible to week day" do
    it "should be convertible to week day" do
      subject.should respond_to(:to_week_day)
      subject.to_week_day.should be_a(Aef::Weekling::WeekDay)
    end
  end

  describe Integer do
    subject { 123 }

    it_should_behave_like "convertible to year"
  end

  describe Date do
    subject { described_class.today }

    it_should_behave_like "convertible to year"
    it_should_behave_like "convertible to week"
    it_should_behave_like "convertible to week day"
  end

  describe DateTime do
    subject { described_class.now }

    it_should_behave_like "convertible to year"
    it_should_behave_like "convertible to week"
    it_should_behave_like "convertible to week day"
  end

  describe Time do
    subject { described_class.now }

    it_should_behave_like "convertible to year"
    it_should_behave_like "convertible to week"
    it_should_behave_like "convertible to week day"
  end
end
