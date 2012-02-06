# Helper file to allow loading by gem name. Includes namespace Aef into Object
# and extends Date, DateTime and Time to support to_week and to_week_day.

require 'aef/week'
require 'aef/week/core_extensions'

Object.method(:include).call(Aef)

[Date, Time, DateTime].each do |klass|
  klass.method(:include).call(Week::CoreExtensions)
end
