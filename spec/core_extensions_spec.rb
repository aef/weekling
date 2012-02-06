require 'spec_helper'
require 'weekling'

describe "weekling gem" do
  it "should include the Aef namespace into Object" do
    Object.should include Aef
    Week.should equal Aef::Week
  end

  shared_examples_for "convertible to week" do
    it "should be convertible to week" do
      subject.should respond_to(:to_week)
      subject.to_week.should be_a(Aef::Week)
    end
  end

  shared_examples_for "convertible to week day" do
    it "should be convertible to week day" do
      subject.should respond_to(:to_week_day)
      subject.to_week_day.should be_a(Aef::Week::Day)
    end
  end

  describe Date do
    subject { described_class.today }

    it_should_behave_like "convertible to week"
    it_should_behave_like "convertible to week day"
  end

  describe DateTime do
    subject { described_class.now }

    it_should_behave_like "convertible to week"
    it_should_behave_like "convertible to week day"
  end

  describe Time do
    subject { described_class.now }

    it_should_behave_like "convertible to week"
    it_should_behave_like "convertible to week day"
  end
end
