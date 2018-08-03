#!/usr/bin/env ruby

require 'bundler/setup'
require 'typhoeus' # FIXME: replace with Net::HTTP
require 'uri'
require 'repomd_parser'
require 'tmpdir'
require 'fileutils'

#repo_url =


def print_repo_stats(repo_url)
  tmpdir = Dir.mktmpdir
  repomd_file = File.join(tmpdir, 'repomd.xml')

  response = Typhoeus.get(URI.join(repo_url, 'repodata/repomd.xml'), followlocation: true)

  File.open(repomd_file, 'wb') do |file|
    file.write(response.body)
  end

  stats = Hash.new { |hash, key| hash[key] = { count: 0, total_size: 0 } }
  metadata_files = Hash.new { |hash, key| hash[key] = [] }

  RepomdParser::RepomdXmlParser.new(repomd_file).parse.each do |xml_file|
    metadata_files[xml_file.type] << xml_file if %i[primary deltainfo].include?(xml_file.type)
  end

  metadata_files[:primary].each do |xml_file|
    filename = File.join(tmpdir, File.basename(xml_file.location))

    response = Typhoeus.get(URI.join(repo_url, xml_file.location), followlocation: true)
    File.open(filename, 'wb') do |file|
      file.write(response.body)
    end

    rpms = RepomdParser::PrimaryXmlParser.new(filename, true).parse
    rpms.each do |package|
      stats[package[:arch]][:count] += 1
      stats[package[:arch]][:total_size] += package[:package_size]
    end
  end

  puts
  puts "Statistics for #{repo_url}"
  puts
  stats.each { |arch, data| printf "%08s: %06s packages, %6.02f gigabytes\n", arch, data[:count], data[:total_size].to_f / 1024 ** 3 }
ensure
  FileUtils.rm_r(tmpdir)
end


print_repo_stats('https://download.opensuse.org/update/leap/42.3/oss/')
print_repo_stats('http://download.fedoraproject.org/pub/fedora/linux/releases/28/Everything/x86_64/os/')
