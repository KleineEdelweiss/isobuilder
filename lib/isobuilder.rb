#! /usr/bin/ruby
# lib/isobuilder

# Format the name
def name_fmt(name) "#{name.split("/").last.gsub(/([[:punct:]]|\s)+/, "_")}.iso" end

# Is name good?
def name_good?(name)
  out = name_fmt(name)
  puts "Is the name, '#{out}' acceptable? [Y/n]"
  puts "[Default: Y]"
  choice = STDIN.gets.strip.downcase
  (choice.length.zero? || choice[0] == 'y') ? out : false
end # End name good checker

# Create the output file name
def name_output(name)
  choice = name_good?(name)
  until choice
    puts "Please name your ISO output filename"
    choice = name_good? STDIN.gets.strip
  end
  "#{Dir.pwd}/#{choice}"
end # End name output

# Create the ISO
def iso_build(path)
  puts "Building ISO from '#{path}'"

  # Fix the path
  path_fix = "'#{path}'"
  # Get the desired output file name
  oname = name_output(path)

  # File stat
  fst = File.stat(path)
  # device, filesystem type, blocks, used, available, percent, mount point
  dev, fstype, blocks, used, avail, pcent, *mnt_pt= `df -T '#{path}'`.split("\n").last.strip.split

  # Informational output
  puts "::INFO:: ISO source path: '#{path}'"
  puts "::INFO:: ISO is located at device: #{dev}"
  puts "::INFO:: ISO source filesystem type (should be a disk of some sort) is: #{fstype}"
  puts "::INFO:: ISO output filename: #{oname}"
  puts "::INFO:: ISO will be of size: #{used.to_f / 1024} MB (#{pcent})"

  # Prompt to finalize
  puts "Does this seem correct? [Y/n]"
  choice = STDIN.gets.strip.downcase
  if (choice.length.zero? || choice[0] == 'y') then
    # Based on the file type, build the ISO
    if (fst.blockdev? || (mnt_pt.join("-").sub(/\/$/, "") == path.gsub(/\s/, "-").sub(/\/$/, ""))) then
      #puts "Will 'dd' this block device"
      #puts "dd if='#{dev}' of=#{oname} status=progress"
      `dd if='#{dev}' of=#{oname} status=progress`
    elsif File.directory?(path) then
      puts "Will 'mkisofs' this directory"
      #`mkisofs -o #{oname} #{path_fix}`
      #puts "Please make sure you have the command, 'mkisofs', often a part of 'cdrtools' or similar packages on most distributions"
    else
      puts "I don't know how this happened..."
    end
  else
    puts "Cancelling..."
  end
end # End build of ISO

# ERROR: no directory selected
def e_arg_count
  puts "::ERROR:: Need to select a directory or drive to make ISO from -- if drive, please mount it"
end # End e_arg_count

# ERROR: argument not exist
def e_arg_noexist(arg)
  puts "::ERROR:: Path, '#{arg}' does not exist"
end # End e_arg_noexist

# ERROR: arg wrong type
def e_arg_wrong_type(arg)
  puts "::ERROR:: '#{arg}' is not a directory or drive"
end # End e_wrong_type

# Check arg type
def check_args(path)
  case
  when !File.exist?(path) then
    e_arg_noexist path
  when (!File.directory?(path) && !File.stat(path).blockdev?) then
    e_arg_wrong_type path
  else
    iso_build path
  end
end # End arg check

# Get user input
def confirm(path)
  # Prompt
  puts "Make ISO from #{path}? [Y/n]"
  puts "[Default: Y]"
  choice = STDIN.gets.strip.downcase

  # Check validity
  case
  # Input is either empty or yes
  when (choice.length == 0 || choice[0] == "y") then
    check_args path
  # Input is no
  when choice[0] == "n"
    puts "Cancelling"
  # Input is invalid
  else
    puts "::ERROR:: Invalid response"
    confirm path
  end
end # End get user input

# Main
def main
  # Check for correct args count
  case ARGV.count
  when 1 then
    confirm ARGV[0]
  else
    e_arg_count
  end
end # End main

# Run the program
main
