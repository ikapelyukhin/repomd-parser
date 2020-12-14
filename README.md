# RepomdParser [![Build Status](https://travis-ci.org/ikapelyukhin/repomd-parser.svg?branch=master)](https://travis-ci.org/ikapelyukhin/repomd-parser)

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

`parse` method returns an array of `RepomdParser::Reference`. 

```ruby
metadata_files = RepomdParser::RepomdXmlParser.new('repomd.xml').parse
metadata_files.each do |metadata_file|
  printf "type: %10s, location: %s\n", metadata_file.type, metadata_file.location 
end
```

#### RepomdParser::PrimaryXmlParser

Parses `primary.xml`, which contains information about RPM packages in the repository.

`parse` method returns an array of `RepomdParser::Reference`.

```ruby
rpm_packages = RepomdParser::PrimaryXmlParser.new('primary.xml').parse
rpm_packages.each do |rpm|
  printf "arch: %8s, location: %s\n", rpm.arch, rpm.location
end
```

#### RepomdParser::DeltainfoXmlParser

Parses `deltainfo.xml`, which contains information about delta-RPM packages in the repository.

`parse` method returns an array of `RepomdParser::Reference`.

```ruby
rpm_packages = RepomdParser::DeltainfoXmlParser.new('deltainfo.xml').parse
rpm_packages.each do |rpm|
  printf "arch: %8s, location: %s\n", rpm.arch, rpm.location
end
```

#### RepomdParser::UpdateinfoXmlParser

Parses `updateinfo.xml`, which contains information about updates (patches) in the repository.

`parse` method returns an array of `RepomdParser::Update` objects, each having a `packages` method returning an array of `RepomdParser::Reference` objects, representing the updated RPM packages.

```ruby
patches = RepomdParser::UpdateinfoXmlParser.new('updateinfo.xml').parse

patches.each do |patch|
  printf "title: %8s, description: %s\n", patch.title, patch.description

  patch.packages.each do |rpm|
    printf "arch: %8s, location: %s\n", rpm.arch, rpm.location
  end
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

#### RepomdParser::Update

Represents an update, including the RPM packages that got updated:

* `id`, a unique identifier for this update
* `title`, a string summarizing the update
* `description`, a more detailed description of this update
* `severity`, e.g. Moderate, Critical
* `type`, e.g. enhancement, security
* `issued`, date and time this update was issued
* `packages`, list of updated packages, represented as `RepomdParser::Reference` instances

## Caveats

* Relies on the file name to determine if the file is compressed (automatically decompresses `.gz` files)

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/ikapelyukhin/repomd-parser.
