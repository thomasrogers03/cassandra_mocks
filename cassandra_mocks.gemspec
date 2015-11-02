Gem::Specification.new do |s|
  s.name = 'cassandra_mocks'
  s.version = '0.0.2'
  s.license = 'Apache License 2.0'
  s.summary = ''
  s.description = ''
  s.authors = ['Thomas RM Rogers']
  s.email = 'thomasrogers03@gmail.com'
  s.files = Dir['{lib}/**/*.rb', 'bin/*', 'LICENSE.txt', '*.md']
  s.require_path = 'lib'
  s.homepage = ''
  s.add_runtime_dependency 'cassandra-driver', '~> 1.1'
  s.add_runtime_dependency 'activesupport', '>= 4.0'
end
