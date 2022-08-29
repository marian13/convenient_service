require "byebug"

dir = ARGV.first

Dir.glob("#{dir}/**/*.rb").each do |path|
  old_lines = File.readlines(path)

  new_lines = []

  remove_tab = false

  old_lines.each do |old_line|
    # byebug

    case old_line
    when /module V2$/
      remove_tab = true
    when old_line.empty?
      new_lines << old_line
    else
      new_lines << (remove_tab ? old_line.delete_prefix("  ") : old_line)
    end
  end

  new_lines.pop if remove_tab

  result = new_lines.join

  puts result

  File.write(path, result) if ENV['DRY'] != true
end
