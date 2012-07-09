require 'csv'

namespace :csv do

  # Import glossary entries from a csv file
  #
  # Create a user to add the entries and specify the user in the username variable, as in:
  #
  # rake csv:import[csv-file,importer]
  #
  # for a user named "importer".
  #
  # To use a non-comma delimiter, include the delimiter as a last argument in the list.
  #
  # The first line of the CSV file is a header and should include term_in_<lang> for each
  # language in the glossary plus optionally "note" for translator notes.
  # Entries with duplicate terms in the glossary language are entered with an index
  task :import, [:filename, :username, :col_sep] => [:environment] do |t, args|
    raise ArgumentError, "ERROR: User '#{args.username}' not found." unless user = User.find_by_name(args.username)
    raise IOError, "ERROR: Unable to open CSV file." unless csv_text = File.read(args.filename)

    col_sep = args.col_sep ? args.col_sep : ','
    raise IOError, "ERROR: Unable to parse CSV file." unless csv = CSV.parse(csv_text, :headers => true, :col_sep => col_sep)

    entries_hashes = []

    csv.each do |row|
      row = row.to_hash.with_indifferent_access
      entry = Entry.new(row.to_hash.symbolize_keys)
      entry.user_id = user.id
      term = entry.term_in_glossary_language

      # check for duplicates and mark first entry found as having duplicates
      if (found = entries_hashes.find { |h| h[:term_in_glossary_language] == term })
        found[:duplicates] = true
      end

      # add row to hash
      entries_hashes << row

      # save entry and set status and term_in_glossary_language accordingly
      entries_hashes.last[:status] = entry.save
      entries_hashes.last[:term_in_glossary_language] = term
    end

    # output all entries with duplicates (and anything else that could not be added)
    if (duplicates = entries_hashes.find_all { |h| h[:duplicates] || !h[:status] })
      puts duplicates.map { |d|
        csv.headers.map { |h| d[h] }.join(col_sep) 
      }.sort.join("\n")
    end

  end
end
