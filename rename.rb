#!/usr/bin/env ruby
require 'find'
require 'fileutils'

def camel_case(value)
  return value if !value.include?('_') && value.match?(/[A-Z]+.*/)
  value.split('_').map(&:capitalize).join
end

def usage
  puts 'This script renames the template plugin to a name of your choice'
  puts 'Please supply the desired plugin name in snake_case, e.g.'
  puts ''
  puts '    rename.rb smart_proxy_my_awesome_plugin'
  puts ''
  exit 0
end

usage if ARGV.size != 1

snake = ARGV[0]
snake = snake.sub /\Asmart_proxy_/, ''
camel = camel_case(snake)

if snake == camel
  puts "Could not camelize '#{snake}' - exiting"
  exit 1
end

old_dirs = []
Find.find(__dir__) do |path|
  next unless File.file?(path)
  next if path =~ /\.git/
  next if path == './rename.rb'

  # Change content on all files
  buffer = File.read(path)
  buffer.gsub!(/plugin_template/, snake)
  buffer.gsub!(/PluginTemplate/, camel)
  File.write(path, buffer)
end

Find.find(__dir__) do |path|
  # Change all the paths to the new snake_case name
  if path.match?(/plugin_template/i)
    new = path.gsub('plugin_template', snake)
    # Recursively copy the directory and store the original for deletion
    # Check for $ because we don't need to copy template/hosts for example
    if File.directory?(path) && path.match?(/plugin_template$/i)
      FileUtils.mkdir_p(new)
      old_dirs << path
    else
      # gsub replaces all instances, so it will work on the new directories
      FileUtils.mv(path, new)
    end
  end
end

# Clean up
FileUtils.rm_rf(old_dirs)

FileUtils.mv('README.plugin.md', 'README.md')

File.unlink(__FILE__)

puts 'All done!'
puts "Add this to the Smart Proxy's bundler.d/Gemfile.local.rb configuration:"
puts ''
puts "  gem 'smart_proxy_#{snake}', path: '#{Dir.pwd}'"
puts ''
puts 'Happy hacking!'
