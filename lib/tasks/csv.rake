require 'csv'

namespace :csv do

  task :import, [:filename, :username] => [:environment] do |t, args|
    user = User.find_by_name(args.username)
    csv_text = File.read(args.filename)
    csv = CSV.parse(csv_text, :headers => true)
    csv.each do |row|
      row = row.to_hash.with_indifferent_access
      Entry.create!(row.to_hash.symbolize_keys.merge(:user => user))
    end
  end

end
