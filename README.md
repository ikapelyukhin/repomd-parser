# RepomdParser

RPM repository metadata parser.

For tools that use `RepomdParser`, see [repo-tools](https://github.com/ikapelyukhin/repo-tools) repository.

This gem can parse `repomd.xml`, `primary.xml` and `deltainfo.xml` metadata files of the RPM repository,
providing a way to get access to the list of packages in the repo and the details of each individual package (name, size, checksum, etc.)

## Installation

1. Add `gem 'repomd_parser'` line to your application's Gemfile;
2. Execute `bundle`.

Alternatively, install as `gem install repomd_parser`.

## Usage

#### RepomdParser::RepomdXmlParser

Parses `repomd.xml` -- the main repository metadata file, which references other metadata files.

`parse` and `parse_file` methods return an array of `RepomdParser::Reference`.

##### Using the `parse` method

```ruby
File.open('repomd.xml') do |fh|
  metadata_files = RepomdParser::RepomdXmlParser.new.parse(fh)
  metadata_files.each do |metadata_file|
    printf "type: %10s, location: %s\n", metadata_file.type, metadata_file.location
  end
end
```

##### Using the `parse_file` method

```ruby
metadata_files = RepomdParser::RepomdXmlParser.new.parse_file('repomd.xml')
metadata_files.each do |metadata_file|
  printf "type: %10s, location: %s\n", metadata_file.type, metadata_file.location 
end
```

#### RepomdParser::PrimaryXmlParser

Parses `primary.xml`, which contains information about RPM packages in the repository.

`parse` and `parse_file` methods return an array of `RepomdParser::Reference`.

##### Using the `parse` method

```ruby
File.open('primary.xml') do |fh|
  rpm_packages = RepomdParser::PrimaryXmlParser.new.parse(fh)
  rpm_packages.each do |rpm|
    printf "arch: %8s, location: %s\n", rpm.arch, rpm.location
  end
end
```

##### Using the `parse_file` method

```ruby
rpm_packages = RepomdParser::PrimaryXmlParser.new.parse_file('primary.xml')
rpm_packages.each do |rpm|
  printf "arch: %8s, location: %s\n", rpm.arch, rpm.location
end
```

#### RepomdParser::DeltainfoXmlParser

Parses `deltainfo.xml`, which contains information about delta-RPM packages in the repository.

`parse` and `parse_file` methods return an array of `RepomdParser::Reference`.

##### Using the `parse` method

```ruby
File.open('deltainfo.xml') do |fh|
  rpm_packages = RepomdParser::DeltainfoXmlParser.new.parse(fh)
  rpm_packages.each do |rpm|
    printf "arch: %8s, location: %s\n", rpm.arch, rpm.location
  end
end
```

##### Using the `parse_file` method

```ruby
rpm_packages = RepomdParser::DeltainfoXmlParser.new.parse_file('deltainfo.xml')
rpm_packages.each do |rpm|
  printf "arch: %8s, location: %s\n", rpm.arch, rpm.location
end
```

#### Compressed file support

The gzip and Zstandard compression formats are supported. The `parse_file`
method automatically decompresses files based on the filename, e.g.:

```ruby
rpm_packages = RepomdParser::PrimaryXmlParser.new.parse_file('primary.xml.gz')
rpm_packages.each do |rpm|
  printf "arch: %8s, location: %s\n", rpm.arch, rpm.location
end
```

The `RepomdParser.decompress_io` helper is provided to handle
decompression of IO objects for use with the `parse` method:

```ruby
filename = 'primary.xml.gz'
io = RepomdParser.decompress_io(File.open(filename), filename)

rpm_packages = RepomdParser::PrimaryXmlParser.new.parse(io)
rpm_packages.each do |rpm|
  printf "arch: %8s, location: %s\n", rpm.arch, rpm.location
end
```


#### RepomdParser::Reference

Represents a file referenced in the metadata file. Has the following accessors:

* `location`, relative to the root of the repository.
* `checksum_type`, e.g. SHA1, SHA256, MD5.
* `checksum`.
* `type`, type of the file, e.g. `:primary`, `:deltainfo`, `:rpm`, `:drpm`.
* `size` in bytes.
* `arch`.

RPM and DRPM files additionally have the following attributes:

* `name`.
* `version`.
* `release`.
* `build_time`.

## Caveats

* File extension is used to determine file compression type (expected
  extensions are `.gz` and `.zst` for gzip and Zstandard respectively)

## Development

After checking out the repo, run `bundle install` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/ikapelyukhin/repomd-parser.
