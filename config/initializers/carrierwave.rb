CarrierWave.configure do |config|
  if Rails.env.staging? or Rails.env.production?
    #--->
    #config.fog_provider = 'fog-aws'                        # required
    #config.fog_credentials = {
    #  provider:              'AWS',                        # required
    #  aws_access_key_id:     'xxx',                        # required
    #  aws_secret_access_key: 'yyy',                        # required
    #  #region:                'eu-west-1',                  # optional, defaults to 'us-east-1'
    #  #host:                  's3.example.com',             # optional, defaults to nil
    #  #endpoint:              'https://s3.example.com:8080' # optional, defaults to nil
    #}
    #config.fog_directory  = 'name_of_directory'                          # required
    ##config.fog_public     = false                                        # optional, defaults to true
    ##config.fog_attributes = { 'Cache-Control' => "max-age=#{365.day.to_i}" } # optional, defaults to {}
    #--->
    config.storage    = :aws
    config.aws_bucket = ENV['S3_BUCKET_NAME']
    config.aws_acl    = :public_read
    #config.asset_host = 'http://example.com'
    #config.aws_authenticated_url_expiration = 60 * 60 * 24 * 365
    config.aws_credentials = {
      access_key_id:     ENV['AWS_ACCESS_KEY_ID'],
      secret_access_key: ENV['AWS_SECRET_ACCESS_KEY']
    }
    #--->
  else
    config.storage = :file
    if Rails.env.development?
      config.enable_processing = true
    else
      config.enable_processing = false
    end
  end
end