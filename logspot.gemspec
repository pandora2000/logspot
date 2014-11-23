Gem::Specification.new do |s|
  s.name = 'logspot'
  s.version = '0.2.0'
  s.authors = ['Tetsuri Moriya']
  s.email = ['tetsuri.moriya@gmail.com']
  s.summary = 'Logger'
  s.description = 'Logger with various output forms'
  s.homepage = 'https://github.com/pandora2000/logspot'
  s.license = 'MIT'
  s.files = `git ls-files`.split("\n")
  s.add_development_dependency 'rspec', '>= 0'
  s.add_runtime_dependency 'activesupport', '>= 4'
end
