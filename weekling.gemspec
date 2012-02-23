# encoding: UTF-8
=begin
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

$LOAD_PATH << 'lib'

require 'weekling/bare'

Gem::Specification.new do |s|
  s.name        = 'weekling'
  s.version     = Aef::Weekling::VERSION.dup
  s.authors     = ['Alexander E. Fischer']
  s.email       = ['aef@raxys.net']
  s.homepage    = 'http://github.com/aef/weekling'
  s.license     = 'ISC'
  s.summary     = 'Easy ISO 8601 year, week and week-day helper classes'
  s.description = <<-DESCRIPTION
Weekling is a Ruby library which provides class representations to make date
calculations using years, weeks and week-days much easier. Years, weeks and
week-days are interpreted as in ISO 8601.
  DESCRIPTION

  s.rubyforge_project = nil
  s.has_rdoc          = 'yard'
  s.extra_rdoc_files  = ['HISTORY.md', 'LICENSE.md'] 

  s.files         = `git ls-files`.lines.map(&:chomp)
  s.test_files    = `git ls-files -- {test,spec,features}/*`.lines.map(&:chomp)
  s.executables   = `git ls-files -- bin/*`.lines.map{|f| File.basename(f.chomp) }
  s.require_paths = ["lib"]

  s.add_development_dependency('bundler', '~> 1.0.21')
  s.add_development_dependency('rake', '~> 0.9.2')
  s.add_development_dependency('rspec', '~> 2.6.0')
  s.add_development_dependency('simplecov', '~> 0.5.4')
  s.add_development_dependency('pry', '~> 0.9.8')
  s.add_development_dependency('yard', '~> 0.7.5')
  s.add_development_dependency('maruku', '~> 0.6.0')

  s.cert_chain = "#{ENV['GEM_CERT_CHAIN']}".split(':')
  s.signing_key = ENV['GEM_SIGNING_KEY']
end
