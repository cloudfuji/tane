require "bundler/gem_tasks"

# Import the Tane rake tasks
import 'tasks/tane.rake'

Dir['tasks/**/*.rake'].each { |rake| load rake }

if ENV["RAILS_ENV"] != "production"
  require 'ci/reporter/rake/rspec'
end
