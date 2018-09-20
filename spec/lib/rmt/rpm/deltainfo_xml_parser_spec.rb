require 'repomd_parser'

RSpec.describe RepomdParser::DeltainfoXmlParser do
  let(:parsed_files) do
    described_class.new(
      file_fixture('dummy_repo/repodata/a546b430098b8a3fb7d65493a9ce608fafcb32f451d0ce8bf85410191f347cc3-deltainfo.xml.gz')
    ).parse
  end

  it 'references drpm files' do
    expect(parsed_files).to eq [
      RepomdParser::Reference.new(
        location: 'apples-0.1-0.x86_64.drpm',
        checksum_type: 'sha256',
        checksum: 'd5da95c8606a3de101d543e7d90c96f59b9f7cf50a8c944cbee889505401565e',
        type: :drpm,
        size: 2087,
        arch: 'x86_64',
      ),
      RepomdParser::Reference.new(
        location: 'oranges-0.1-0.x86_64.drpm',
        checksum_type: 'sha256',
        checksum: 'b0ec989937ef76c88cedb50848cc111bf2f3bcbb490fa8c8c1180aa4a9a63d73',
        type: :drpm,
        size: 2083,
        arch: 'x86_64',
      )
    ]
  end
end
