target :lib do
  check "lib"
  signature "sig"
  repo_path "gems"
  library "aws-sdk-core"
  library "aws-sdk-s3"
end

target :test do
  check "test"
  repo_path "gems"
  library "aws-sdk-core"
  library "aws-sdk-s3"

  configure_code_diagnostics(Steep::Diagnostic::Ruby.all_error)
end
