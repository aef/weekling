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
