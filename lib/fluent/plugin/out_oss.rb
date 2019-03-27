require 'fluent/output'
require 'fluent/log'
require 'aliyun/oss'
require 'zlib'
require 'time'
require 'tempfile'
require 'securerandom'
require 'socket'

module Fluent
  class OSSOutput < TimeSlicedOutput
    Fluent::Plugin.register_output('oss', self)

    desc "OSS access key id"
    config_param :oss_key_id, :string
    desc "OSS access key secret"
    config_param :oss_key_secret, :string, secret: true
    desc "OSS bucket name"
    config_param :oss_bucket, :string
    desc "OSS endpoint"
    config_param :oss_endpoint, :string
    desc "The format of OSS object keys"
    config_param :oss_object_key_format, :string, default: "%{time_slice}/%{host}-%{uuid}.%{file_ext}"

    def configure(conf)
      super
    end

    def compress(chunk, tmp)
      res = system "gzip -c #{chunk.path} > #{tmp.path}"
      unless res
        log.warn "failed to execute gzip command. Fallback to GzipWriter. status = #{$?}"
        begin
          tmp.truncate(0)
          gw = Zlib::GzipWriter.new(tmp)
          chunk.write_to(gw)
          gw.close
        ensure
          gw.close rescue nil
        end
      end
    end

    def process_object_key_format(chunk, key_format)
      key_map = {
        host: Socket.gethostname,
        time_slice: chunk.key,
        uuid: SecureRandom.hex(4),
        file_ext: 'gz'
      }
      result = key_format
      key_map.each do |k, v|
        result = result.gsub("%{#{k.to_s}}", v)
      end
      result
    end

    def start
      super
      Aliyun::Common::Logging.set_log_file('/dev/null')
      @client = Aliyun::OSS::Client.new(
        :endpoint => @oss_endpoint,
        :access_key_id => @oss_key_id,
        :access_key_secret => @oss_key_secret)

      raise "Specific bucket not exists: #{@oss_bucket}" unless @client.bucket_exists? @oss_bucket

      @bucket = @client.get_bucket(@oss_bucket)
    end

    def format(tag, time, record)
      {tag: tag, timestamp: time, log: record}.to_json + "\n"
    end

    def write(chunk)
      begin
        f = Tempfile.new('oss-')
        compress(chunk, f)
        path = process_object_key_format(chunk, @oss_object_key_format)
        raise "Upload #{f.path} failed" unless @bucket.resumable_upload(path, f.path)
      ensure
        f.close(true)
      end
    end
  end
end
