#!/usr/bin/env ruby

require 'fileutils'

unless ARGV[0]
  warn "Usage: #{File.basename($PROGRAM_NAME)} 'GLOB_PATTERN' [MERGED_DIRECTORY]"
  exit(1)
end

files = Dir.glob(ARGV[0]).sort

if files.empty?
  warn 'No files to process. Aborting...'
  exit(1)
end

MERGED_DIR = ARGV[1] || 'merged'
FileUtils.mkdir_p(MERGED_DIR)

print 'Copying cover... '
cover = files.shift
FileUtils.cp(cover, File.join(MERGED_DIR, "0#{File.extname(cover)}"))
puts 'done.'

files_count = files.count / 2

files.each_slice(2).with_index(1) do |(file1, file2), i|
  print "Converting #{i}/#{files_count}... "

  merged_file = File.join(MERGED_DIR, "#{i}#{File.extname(file1)}")
  if File.exist?(merged_file)
    puts 'already exists.'
  elsif file2.nil?
    FileUtils.cp(file1, merged_file)
    puts 'copy without merge.'
  else
    `montage -mode concatenate -tile 2x1 -geometry +0+0 '#{file2}' '#{file1}' '#{merged_file}'`
    puts 'done.'
  end
end
