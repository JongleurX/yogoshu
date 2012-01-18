Before do
  DatabaseCleaner.start
end

Before do |scenario|
  DatabaseCleaner.clean
end

After do
  DatabaseCleaner.clean
end
