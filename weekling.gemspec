# encoding: UTF-8
=begin
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

require 'pathname'

$LOAD_PATH.unshift('lib')

require 'weekling/bare'

Gem::Specification.new do |s|
  s.name = 'weekling'
  s.version = Aef::Weekling::VERSION.dup
  s.required_rubygems_version = Gem::Requirement.new('>= 1.8.0')
  s.authors = ['Alexander E. Fischer']
  s.date = '2012-02-09'
  s.license = 'BSD-2-Clause'
  s.description = <<-DESCRIPTION
Weekling is a Ruby library which provides class representations to make date
calculations using years, weeks and week-days much easier. Years, weeks and
week-days are interpreted as in ISO 8601.
  DESCRIPTION
  s.email = 'aef@raxys.net'
  s.has_rdoc = 'yard'
  s.extra_rdoc_files = ['HISTORY.md', 'LICENSE.md'] 
  s.files = Pathname.new('Manifest.txt').read.lines.map(&:chomp).to_a
  s.homepage = 'http://github.com/aef/weekling'
  s.require_paths = ['lib']
  s.rubygems_version = '1.8.10'
  s.summary = 'Easy ISO 8601 year, week and week-day helper classes'
  s.specification_version = 3

  s.add_development_dependency('bundler', '~> 1.0.21')
  s.add_development_dependency('rspec', '~> 2.6.0')
  s.add_development_dependency('yard', '~> 0.7.5')
  s.add_development_dependency('rake', '~> 0.9.2')
  s.add_development_dependency('pry', '~> 0.9.8')
  s.add_development_dependency('simplecov', '~> 0.5.4')
  s.add_development_dependency('redcarpet', '~> 2.1.0')

  s.cert_chain = "#{ENV['GEM_CERT_CHAIN']}".split(':')
  s.signing_key = ENV['GEM_SIGNING_KEY']
end
