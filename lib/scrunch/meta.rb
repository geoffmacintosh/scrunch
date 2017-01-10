# The part that deals with metadata collection and generation.
# Currently, all metadata is collected and written by the
# command-line-tool atomicparsley.
module Meta
  # Uses atomicparsley to collect metadata from the audiobook and
  # return it as a fancy hash. Returns the following values:
  # - nam (Title)
  # - alb (Series)
  # - ART (Author)
  def self.get_metadata(file)
    atoms = `AtomicParsley \"#{file}\" -t`
    atoms.each_line.each_with_object({}) do |line, hash|
      prefix, contents = line.split(": ")
      atom_name = /([\w]{3,4})(?=\" contains)/.match(prefix).to_s
      hash[atom_name] = contents.strip unless atom_name.empty?
      hash
    end
  end

  # Uses atomicparsley to write the embedded cover image to disk in
  # the same directory as the audiobook.
  def self.get_cover(input_file)
    unprocessed = `AtomicParsley \"#{input_file}\" -E`
    /(?<=\: ).*/.match(unprocessed).to_s
  end

  ## Returns the final filename that is written finally.
  def self.make_filename(input_file)
    input_file[0...-4] + "-new.m4b"
  end

  # Writes the metadata to the file.
  def self.apply_metadata(file, metadata, cover)
    %(AtomicParsley \"#{file}\" \
--title \"#{metadata["nam"]}\" \
--album \"#{metadata["alb"]}\" \
--artist \"#{metadata["ART"]}\" \
--genre \"Audiobooks\" \
--stik \"Audiobook\" \
--artwork \"#{cover}\" \
--overWrite \
2>&1 1>/dev/null)
  end
end
