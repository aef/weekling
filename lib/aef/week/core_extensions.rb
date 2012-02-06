module Aef

  class Week

    # This module allows Objects to be extended to be support to_week and
    # to_week_day. Date, DateTime and Time is automatically included if you
    # require like the following:
    #
    #   require 'weekling'
    module CoreExtensions
      # Constructs an Aef::Week from the object
      def to_week
        Week.new(self)
      end
  
      # Constructs an Aef::Week::Day from the object
      def to_week_day
        Week::Day.new(self)
      end
    end

  end
end
