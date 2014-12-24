Dir.glob('750words_import/*.txt') do |file|
  File.open(file, 'r') do |f|
    newfile = false
    suppress = 0
    cur_file = nil
    blank = false
    f.each_line do |line|
      if line == "------ ENTRY ------\n"
        newfile = true
      elsif newfile
        filename = line.gsub(/Date:    /, '').gsub(/-/, '_').chomp + '.md'
        cur_file.close unless cur_file.nil?
        cur_file = File.open('import/' + filename, 'w')
        newfile = false
        blank = false
        suppress = 3
      elsif suppress == 2
        seconds = line.match(/Minutes:\s(\d+)/)[1].to_i * 60
        cur_file.write("---\nseconds: #{seconds}\n---\n")
        suppress -= 1
      elsif suppress > 0
        suppress -= 1
      elsif line == "\n"
        blank = true
      else
        cur_file.write("\n") if blank
        cur_file.write(line)
      end
    end
    cur_file.close unless cur_file.nil?
  end
end
