require 'rake/testtask'

# Tasks
namespace :foreman_parameters_summary do
  namespace :example do
    desc 'Example Task'
    task task: :environment do
      # Task goes here
    end
  end
end

# Tests
namespace :test do
  desc 'Test ForemanParametersSummary'
  Rake::TestTask.new(:foreman_parameters_summary) do |t|
    test_dir = File.join(File.dirname(__FILE__), '../..', 'test')
    t.libs << ['test', test_dir]
    t.pattern = "#{test_dir}/**/*_test.rb"
    t.verbose = true
    t.warning = false
  end
end

namespace :foreman_parameters_summary do
  task :rubocop do
    begin
      require 'rubocop/rake_task'
      RuboCop::RakeTask.new(:rubocop_foreman_parameters_summary) do |task|
        task.patterns = ["#{ForemanParametersSummary::Engine.root}/app/**/*.rb",
                         "#{ForemanParametersSummary::Engine.root}/lib/**/*.rb",
                         "#{ForemanParametersSummary::Engine.root}/test/**/*.rb"]
      end
    rescue
      puts 'Rubocop not loaded.'
    end

    Rake::Task['rubocop_foreman_parameters_summary'].invoke
  end
end

Rake::Task[:test].enhance ['test:foreman_parameters_summary']

load 'tasks/jenkins.rake'
if Rake::Task.task_defined?(:'jenkins:unit')
  Rake::Task['jenkins:unit'].enhance ['test:foreman_parameters_summary', 'foreman_parameters_summary:rubocop']
end
