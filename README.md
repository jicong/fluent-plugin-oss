# OSS plugin for [Fluentd](http://github.com/fluent/fluentd)

## Install
```
gem install fluent-plugin-oss
```

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
  buffer_chunk_limit 256m
  time_slice_format %Y%m%d
  time_slice_wait 10m
  num_threads 8
</match>
```

You can also use it with forest plugin

```
<match **>
  @type forest
  subtype oss
  <template>
    oss_key_id xxx
    oss_key_secret xxx
    oss_bucket xxx
    oss_endpoint xxx
    oss_object_key_format "${tag}/%{time_slice}/%{host}-%{uuid}.%{file_ext}"

    buffer_path /var/log/fluent/myapp
    buffer_chunk_limit 256m
    time_slice_format %Y%m%d
    time_slice_wait 10m
    num_threads 8
  </template>
</match>
```
