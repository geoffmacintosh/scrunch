# Generic. Basically everything.
module Main
  # Checks to see if a program is on $PATH.
  def self.on_path?(prog_name)
    !`which "#{prog_name}"`.empty?
  end

  # Complains if the requested program is not on $PATH
  def self.assert_required(prog_name)
    raise "Could not find \"#{prog_name}\".\n" unless on_path?(prog_name)
  end

  # Checks to ensure the correct  number of arguments have been passed
  # to scrunch.
  def self.check_args
    return if ARGV.length == 1
    abort "Usage: scrunch <audiobook>"
  end

  # AtomicParsley and afconvert are required for scrunch to scrunch,
  # so they needs checking for.
  def self.check_reqs
    assert_required "AtomicParsley"
    assert_required "afconvert"
  end

  # Well, scrunch doesn't fly, but it does scrunch, so some checks are
  # made to ensure that it is ready to scrunch. This runs the other
  # methods that check for problems before scrunchery.
  def self.preflight
    check_args
    check_reqs
    abort "No such file or directory" unless File.file?(ARGV[0])
  end

  # Scrunches.
  def self.run
    preflight
    input_filename = File.absolute_path(ARGV[0])
    metadata = Meta.get_metadata(input_filename)
    output_filename = Meta.make_filename(input_filename)

    puts "Scrunching..."
    system Transcode.crush_file(input_filename, output_filename)
    cover = Meta.get_cover(input_filename)
    system Meta.apply_metadata(output_filename, metadata, cover)
    File.unlink cover if File.file? cover
  end
end
