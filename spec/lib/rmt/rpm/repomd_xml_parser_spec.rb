require 'repomd_parser'

RSpec.describe RepomdParser::RepomdXmlParser do
  let(:parsed_files) { described_class.new(file_fixture('dummy_repo/repodata/repomd.xml')).parse }

  it 'references repodata files' do
    expect(parsed_files).to eq [
      RepomdParser::Reference.new(
        location: 'repodata/837fb50abc9680b1e11e050901a56721855a5e854e85e46ceaad2c6816297e69-filelists.xml.gz',
        checksum_type: 'sha256',
        checksum: '837fb50abc9680b1e11e050901a56721855a5e854e85e46ceaad2c6816297e69',
        type: :filelists,
        size: 402,
      ),
      RepomdParser::Reference.new(
        location: 'repodata/a546b430098b8a3fb7d65493a9ce608fafcb32f451d0ce8bf85410191f347cc3-deltainfo.xml.gz',
        checksum_type: 'sha256',
        checksum: 'a546b430098b8a3fb7d65493a9ce608fafcb32f451d0ce8bf85410191f347cc3',
        type: :deltainfo,
        size: 451,
      ),
      RepomdParser::Reference.new(
        location: 'repodata/2d12587a74d924bad597fd8e25b8955270dfbe7591e020f9093edbb4a0d04444-other.xml.gz',
        checksum_type: 'sha256',
        checksum: '2d12587a74d924bad597fd8e25b8955270dfbe7591e020f9093edbb4a0d04444',
        type: :other,
        size: 379,
      ),
      RepomdParser::Reference.new(
        location: 'repodata/abf421e45af5cd686f050bab3d2a98e0a60d1b5ca3b07c86cb948fc1abfa675e-primary.xml.gz',
        checksum_type: 'sha256',
        checksum: 'abf421e45af5cd686f050bab3d2a98e0a60d1b5ca3b07c86cb948fc1abfa675e',
        type: :primary,
        size: 920,
      )
    ]
  end

  let(:old_style_parsed_files) { described_class.new(file_fixture('old_style_repo/repodata/repomd.xml')).parse }

  it 'handles repomd.xml without size field' do
    expect(old_style_parsed_files).to eq [
      RepomdParser::Reference.new(
        location: 'repodata/filelists.xml.gz',
        checksum_type: 'sha',
        checksum: '504bd30dbb050055dc81f3f359b23a0e21f58f35',
        type: :filelists,
        size: nil,
      ),
      RepomdParser::Reference.new(
        location: 'repodata/patches.xml',
        checksum_type: 'sha',
        checksum: '7903e7dc15859c0fc705f04192ad1a70efb95363',
        type: :patches,
        size: nil,
      ),
      RepomdParser::Reference.new(
        location: 'repodata/other.xml.gz',
        checksum_type: 'sha',
        checksum: '28cde758a4bbeff4b9d0e32fe4914644147afb1b',
        type: :other,
        size: nil,
      ),
      RepomdParser::Reference.new(
        location: 'repodata/primary.xml.gz',
        checksum_type: 'sha',
        checksum: 'f4122deb33b18b137646dd86c8fbd6f96ca6cd57',
        type: :primary,
        size: nil,
      ),
      RepomdParser::Reference.new(
        location: 'repodata/pattern.xml',
        checksum_type: 'sha',
        checksum: '20f45621426fcd74364d6fabe6929d1164797801',
        type: :pattern,
        size: nil,
      ),
      RepomdParser::Reference.new(
        location: 'repodata/product.xml',
        checksum_type: 'sha',
        checksum: '20f45621426fcd74364d6fabe6929d1164797801',
        type: :product,
        size: nil,
      )
    ]
  end
end
