Before do
  DatabaseCleaner.start
  DatabaseCleaner.clean
end

After do |scenario|
  DatabaseCleaner.clean
end
