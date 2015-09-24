require "bundler/gem_tasks"
require "rake/testtask"

Rake::TestTask.new(:test) do |t|
  t.libs << "test"
  t.libs << "lib"
  t.test_files = FileList['test/**/*_test.rb']
end

%i[unit integration].each do |kind|
  namespace :test do
    Rake::TestTask.new(kind) do |t|
      t.libs << "test"
      t.test_files = FileList["test/#{kind}/**/*_test.rb"]
    end
  end
end

task :default => :test
