target :lib do
  check "lib"
  signature "sig"
  repo_path "gems"
  Dir["gems/*"].each do |lib|
    library File.basename(lib)
  end
end

target :test do
  check "test"
  repo_path "gems"
  Dir["gems/*"].each do |lib|
    library File.basename(lib)
  end

  configure_code_diagnostics(Steep::Diagnostic::Ruby.all_error)
end
