require 'yaml'

ruby_versions = ['2.1']

minor_4_0 = 4..8
minor_4_1 = 0..4

minor_4_0.each do |i|
  appraisal_version = "4.0.#{i}"
  appraise "4.0.#{i}" do
    gem "rails", appraisal_version
  end
end

minor_4_1.each do |i|
  appraisal_version = "4.1.#{i}"
  appraise "4.1.#{i}" do
    gem "rails", appraisal_version
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