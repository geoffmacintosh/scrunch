module Main
  def self.on_path?(prog_name)
    !`which "#{prog_name}"`.empty?
  end

  def self.assert_required(prog_name)
    if !on_path? prog_name then
      puts "Could not find required program \"#{prog_name}\".\n"
      exit
    end
  end

  if ARGV.length != 1
    usage = "usage: scrunch <audiobook>"
    puts usage
    exit
  end

  assert_required "AtomicParsley"
  assert_required "afconvert"

  input_filename = ARGV[0]

  if File.file?(input_filename)
    input_filename = File.absolute_path(input_filename)

    metadata = Meta.get_metadata(input_filename)
    output_filename = Meta.make_filename(input_filename)

    puts "Scrunching..."
    system Transcode.crush_file(input_filename, output_filename)
    cover = Meta.get_cover(input_filename)
    system Meta.apply_metadata(output_filename, metadata, cover)
    system "rm \"#{cover}\""
  else
    puts "No such file or directory"
  end
end
