# coding: utf-8
# -*-Ruby-*-

def get_metadata(file)
  atoms = `AtomicParsley \"#{file}\" -t`
  atoms.each_line.reduce({}) { |hash, line|
    prefix, contents = line.split(": ")
    atom_name = /([\w]{3,4})(?=\" contains)/.match(prefix).to_s
    if !atom_name.empty? then
      hash[atom_name] = contents.strip
    end
    hash
  }
end

def get_cover(input_file)
  unprocessed = `AtomicParsley \"#{input_file}\" -E`
  /(?<=\: ).*/.match(unprocessed).to_s
end

def crush_file(input_file, output_file)
  "afconvert \"#{input_file}\" -f m4bf -d aacp 32000 -o \"#{output_file}\""
end

def make_filename(input_file)
  input_file[0...-4] + "-new.m4b"
end

def apply_metadata(file, metadata, cover)
  %{AtomicParsley \"#{file}\"                     \
                  --title \"#{metadata["nam"]}\"  \
                  --album \"#{metadata["alb"]}\"  \
                  --artist \"#{metadata["ART"]}\" \
                  --genre \"Audiobooks\"          \
                  --stik \"Audiobook\"            \
                  --artwork \"#{cover}\"          \
                  --overWrite                     \
                  2>&1 1>/dev/null
  }
end

def on_path?(prog_name)
  !`which "#{prog_name}"`.empty?
end

def assert_required(prog_name)
  if !on_path? prog_name then
    puts "Could not find required program \"#{prog_name}\".\n"
    exit
  end
end

if ARGV.length != 1 then
  usage = "usage: scrunch <audiobook>"
  puts usage
  exit
end

assert_required "AtomicParsley"
assert_required "afconvert"

input_filename = ARGV[0]

if File.file?(input_filename) then
  input_filename = File.absolute_path(input_filename)

  metadata = get_metadata(input_filename)
  output_filename = make_filename(input_filename)
  cover = get_cover(input_filename)

  puts "scrunching..."
  system crush_file(input_filename, output_filename)
  system apply_metadata(output_filename, metadata, cover)
  system "rm \"#{cover}\""
else
  puts "No such file or directory"
end
