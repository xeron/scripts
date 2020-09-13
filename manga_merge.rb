#!/usr/bin/env ruby

require 'fileutils'

MERGED_DIR = ARGV[1] || 'merged'
FileUtils.mkdir_p(MERGED_DIR)

files = Dir.glob(ARGV[0]).sort
files_count = files.count / 2

print 'Copying cover... '
cover = files.shift
FileUtils.cp(cover, File.join(MERGED_DIR, "0#{File.extname(cover)}"))
puts 'done.'

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
