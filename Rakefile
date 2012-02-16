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

require 'bundler'

Bundler.setup

require 'rake'
require 'pathname'
require 'yard'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new

YARD::Rake::YardocTask.new('doc') do |yard|
  yard.options << '--no-private'
end

YARD::Rake::YardocTask.new('doc:full') do |yard|
  yard.options << '--private'
end

desc "Removes temporary project files"
task :clean do
  doc = Pathname.new('doc')
  doc.rmtree if doc.exist?
  yardoc = Pathname.new('.yardoc')
  yardoc.rmtree if yardoc.exist?
  Pathname.glob('*.gem').each &:delete
  Pathname.glob('**/*.rbc').each &:delete
end

desc "Opens an interactive console with the library loaded"
task :console do
  require 'pry'
  require 'weekling'
  Pry.start
end

task :default => :spec
