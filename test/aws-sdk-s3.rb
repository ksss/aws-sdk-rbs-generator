require 'aws-sdk-s3'

# Client

client = Aws::S3::Client.new(
  region: 'ap-test-1',
  stub_responses: true
)

p client.get_object(bucket: 'a', key: 'b').etag.upcase

# Resource

## Low level api

object = Aws::S3::Object.new(bucket_name: 'a', key: 'b', client: client)
batches = [[object]]
collection = Aws::S3::Object::Collection.new(batches)
p collection.first.bucket_name
p collection.first(1).sort
collection.each do |obj|
  p obj.bucket_name.upcase
  p obj.key.upcase
end

## High level api

resource = Aws::S3::Resource.new(client: client)
p resource.bucket('a').object('b').delete.version_id.upcase

resource.buckets.each do |bucket|
  bucket.objects.find do |object|
    object.bucket_name.upcase
  end
end
