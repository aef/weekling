# encoding: UTF-8

Gem::Specification.new do |s|
  s.name = 'weekling'
  s.version = '0.1.0'
  s.required_rubygems_version = Gem::Requirement.new('>= 1.8.0')
  s.authors = ['Alexander E. Fischer']
  s.date = '2012-01-27'
  s.description = <<-DESCRIPTION
Weekling is a Ruby library which provides class representations to make date
calculations using weeks and week days much easier. Weeks and week days are
interpreted as in ISO 8601.
  DESCRIPTION
  s.email = 'aef@raxys.net'
  s.extra_rdoc_files = ['README.rdoc']
  s.files = ['README.rdoc', 'History.txt']
  s.homepage = 'http://github.com/aef/weekling'
  s.rdoc_options = ['--charset=UTF-8']
  s.require_paths = ['lib']
  s.rubygems_version = '1.8.10'
  s.summary = 'Easy ISO 8601 week and week day helper classes'
  s.specification_version = 3

  s.add_development_dependency('bundler', '~> 1.0.21')
  s.add_development_dependency('rspec', '~> 2.6.0')
  s.add_development_dependency('yard', '~> 0.7.5')
  s.add_development_dependency('rake', '~> 0.9.2')

  s.cert_chain = ['/home/dimedo/Desktop/gemkey/aef-new.pem']
  s.signing_key = '/home/dimedo/Desktop/gemkey/aef.key.pem'
end
