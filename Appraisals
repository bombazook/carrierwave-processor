require 'yaml'
require 'gems'

ruby_versions = ['2.1', '2.2', '2.3']

first_rails_version = Gem::Version.new("4.0.4")

rails_versions = Gems.versions('rails').map do |i| 
  i["number"]
end.select do |i|
  Gem::Version.new(i) >= first_rails_version
end

rails_versions.each do |version|
  appraise version do
    gem "rails", version
  end
end

::File.open('.travis.yml', 'w+') do |f|
  travis_hash = { 
    'language' => 'ruby', 
    'rvm' => ruby_versions, 
    'script'  => 'bundle exec rspec spec', 
    'gemfile' => Dir.glob('gemfiles/*.gemfile')
  }
  travis = ::YAML.dump(travis_hash)
  f.write travis
end
