target :lib do
  check "lib"
  signature "sig"
  repo_path "gems"
  library "aws-sdk-core"
  library "aws-sdk-s3"
  library "aws-sdk-sqs"
  library "aws-sdk-ec2"
end

target :test do
  check "test"
  repo_path "gems"
  library "aws-sdk-core"
  library "aws-sdk-s3"
  library "aws-sdk-sqs"
  library "aws-sdk-ec2"

  configure_code_diagnostics(Steep::Diagnostic::Ruby.all_error)
end
