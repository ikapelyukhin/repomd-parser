#!/usr/bin/env ruby

require 'pp'
require 'typhoeus'
require 'uri'
require_relative './lib/repomd_parser'

repo_url = 'https://download.opensuse.org/update/leap/42.3/oss/'

response = Typhoeus.get(URI.join(repo_url, 'repodata/repomd.xml'), followlocation: true)
File.open 'repomd.xml', 'wb' do |file|
  file.write(response.body)
end

stats = Hash.new { |hash, key| hash[key] = { count: 0, total_size: 0 } }
metadata_files = Hash.new { |hash, key| hash[key] = [] }

RepomdParser::RepomdXmlParser.new('repomd.xml').parse.each do |xml_file|
  metadata_files[xml_file.type] << xml_file if %i[primary deltainfo].include?(xml_file.type)
end

metadata_files[:primary].each do |xml_file|
  filename = File.basename(xml_file.location)

  response = Typhoeus.get(URI.join(repo_url, xml_file.location), followlocation: true)
  File.open(filename, 'wb') do |file|
    file.write(response.body)
  end

  rpms = RepomdParser::PrimaryXmlParser.new(filename, true).parse
  rpms.each do |package|
    stats[package[:arch]][:count] += 1
    stats[package[:arch]][:total_size] += package[:package_size].to_f
  end
end

stats.each { |arch, data| printf "%08s: %06s packages, %6.02f gigabytes\n", arch, data[:count], data[:total_size] / 1024 / 1024 / 1024 }
