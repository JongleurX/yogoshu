task :travis_ci do
  FileUtils.cp "config/database_example.yml", 'config/database.yml'
end
