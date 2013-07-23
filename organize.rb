#!/usr/bin/env ruby
require 'fileutils'

localFolder = File.dirname(File.expand_path(__FILE__))

# Check for command line arguments
# 0 => folder to organize, if nil, assume local folder 
# 1 => folder to put stuff into, if not, assume local folder executed from
if ARGV[0].nil?
  sourceFolder = localFolder
else
  sourceArg = File.expand_path ARGV[0]
  if File.directory? sourceArg
    sourceFolder = sourceArg
  else
    sourceFolder = File.dirname sourceArg 
  end
end

if ARGV[1].nil?
  $destFolder = localFolder
else
  destArg = File.expand_path ARGV[1]
  if File.directory? destArg
    $destFolder =  destArg
  else
    $destFolder = File.dirname destArg
  end
end

def process_files(startDir)
  entries = Dir.entries(startDir).map{ |e| File.join startDir, e }[2..-1]
  puts entries
  entries.each do |entry|
    # Recurse if it's a directory
    if File.directory? entry
      process_files File.expand_path(entry)
    else
      extension = File.extname(entry)[1..-1] 
      # Does the source folder have a folder named with the extension?
      unless Dir.entries($destFolder).include? extension
        FileUtils.mkdir(File.join($destFolder, extension))
      end
      FileUtils.cp(entry, File.join($destFolder, extension))
    end
  end
end

process_files sourceFolder
