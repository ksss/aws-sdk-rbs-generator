target :lib do
  check "lib"
  signature "sig"
  repo_path "gems"
  Dir["gems/*"].each do |lib|
    library File.basename(lib)
  end
end
