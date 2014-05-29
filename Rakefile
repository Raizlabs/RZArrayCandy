# Adapted from AFNetworking rakefile
include FileUtils::Verbose

namespace :test do
  
  task :install do
    sh("brew update && brew upgrade xctool") rescue nil
  end
  
  task :iOS do
    run_tests('iOS Tests', 'iphonesimulator')
    tests_failed('iOS') unless $?.success?
  end
  
  task :OSX do
    run_tests('OSX Tests', 'macosx')
    tests_failed('OSX') unless $?.success?
  end
  
end

task :test do
  Rake::Task['test:iOS'].invoke
  Rake::Task['test:OSX'].invoke
end

task :default => 'test'

private

def run_tests(scheme, sdk)
  sh("xctool -workspace RZArrayCandy.xcworkspace -scheme '#{scheme}' -sdk '#{sdk}' clean test; exit $?") rescue nil
end

def tests_failed(platform)
  puts red("#{platform} unit tests failed")
  exit $?.exitstatus
end

def red(string)
 "\033[0;31m! #{string}"
end