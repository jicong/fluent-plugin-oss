# OSS plugin for [Fluentd](http://github.com/fluent/fluentd)

## Output: Configuration

```
<match **>
  @type oss
  oss_key_id xxx
  oss_key_secret xxx
  oss_bucket xxx
  oss_endpoint xxx
  oss_object_key_format "%{time_slice}/%{host}-%{uuid}.%{file_ext}"

  buffer_path /var/log/fluent/myapp
  time_slice_format %Y%m%d
  time_slice_wait 10m
  time_format %Y%m%dT%H%M%S%z
</match>
```
