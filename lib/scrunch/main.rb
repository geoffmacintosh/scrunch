# Generic. Basically everything.
module Main
  def self.on_path?(prog_name)
    !`which "#{prog_name}"`.empty?
  end

  def self.assert_required(prog_name)
    raise "Could not find \"#{prog_name}\".\n" unless on_path?(prog_name)
  end

  def self.check_args
    return if ARGV.length == 1
    abort "usage: scrunch <audiobook>"
  end

  def self.check_reqs
    assert_required "AtomicParsley"
    assert_required "afconvert"
  end

  def self.preflight
    check_args
    check_reqs
    abort "no such file or directory" unless File.file?(ARGV[0])
  end

  def self.run
    preflight
    input_filename = File.absolute_path(ARGV[0])
    metadata = Meta.get_metadata(input_filename)
    output_filename = Meta.make_filename(input_filename)

    puts "Scrunching..."
    system Transcode.crush_file(input_filename, output_filename)
    cover = Meta.get_cover(input_filename)
    system Meta.apply_metadata(output_filename, metadata, cover)
    system "rm \"#{cover}\""
  end
end
