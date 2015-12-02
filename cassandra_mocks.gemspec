Gem::Specification.new do |s|
  s.name = 'cassandra_mocks'
  s.version = '0.0.8'
  s.license = 'Apache License 2.0'
  s.summary = 'Cassandra mocking framework'
  s.description = %q{Cassandra mocking framework intended to replace having
a full blown Cassandra running for a unit testing environment. Aims to be a fast
and accurate representation of running CQL 3 against the Ruby Cassandra driver}
  s.authors = ['Thomas RM Rogers']
  s.email = 'thomasrogers03@gmail.com'
  s.files = Dir['{lib}/**/*.rb', 'bin/*', 'LICENSE.txt', '*.md']
  s.require_path = 'lib'
  s.homepage = ''
  s.add_runtime_dependency 'cassandra-driver', '~> 1.1'
  s.add_runtime_dependency 'activesupport', '~> 4.0'
end
