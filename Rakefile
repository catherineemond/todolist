require 'rake/testtask'
require 'bundler/gem_tasks'
require 'find'

desc 'Run tests'
task :default => :test

Rake::TestTask.new(:test) do |t|
  t.libs << 'test'
  t.libs << 'lib'
  t.test_files = FileList['test/**/*_test.rb']
 end

desc 'Display inventory of all files'
task :inventory do
  Find.find('.') do |name|
    next if name.include?('/.') # Excludes all files and directories with . names
    puts name if File.file?(name)
  end
end
