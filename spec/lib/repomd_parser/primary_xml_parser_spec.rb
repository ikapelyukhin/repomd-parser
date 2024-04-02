require 'repomd_parser'

RSpec.describe RepomdParser::PrimaryXmlParser do
  describe '#parse' do
    let(:expected_result) do
      [
        RepomdParser::Reference.new(
          location: 'apples-0.1-0.x86_64.rpm',
          checksum_type: 'sha256',
          checksum: '5c4e3fa1624bd23251eecdda9c7fcefad045995a9eaed527d06dd8510cfe2851',
          type: :rpm,
          size: 1934,
          arch: 'x86_64',
          name: 'apples',
          summary: 'Apples dummy RPM',
          description: 'Dummy apples RPM',
          license: 'Public',
          version: '0.1',
          release: '0',
          build_time: Time.parse('2017-07-19 08:34:13 UTC')
        ),
        RepomdParser::Reference.new(
          location: 'apples-0.2-0.x86_64.rpm',
          checksum_type: 'sha256',
          checksum: 'a9fdc5517f48d2b12c780deb080c8a619f3d440b0b50c2c30b5c9350352db463',
          type: :rpm,
          size: 1950,
          arch: 'x86_64',
          name: 'apples',
          summary: 'Apples dummy RPM',
          description: 'Dummy apples RPM',
          license: 'Public',
          version: '0.2',
          release: '0',
          build_time: Time.parse('2017-07-19 08:35:44 UTC')
        ),
        RepomdParser::Reference.new(
          location: 'oranges-0.1-0.x86_64.rpm',
          checksum_type: 'sha256',
          checksum: 'a38de0c943388127b9c746e7772d694055ec255706ececd563fb55d13b01b4f3',
          type: :rpm,
          size: 1933,
          arch: 'x86_64',
          name: 'oranges',
          summary: 'Oranges dummy RPM',
          description: 'Dummy oranges RPM',
          license: 'Public',
          version: '0.1',
          release: '0',
          build_time: Time.parse('2017-07-19 08:38:03 UTC')
        ),
        RepomdParser::Reference.new(
          location: 'oranges-0.2-0.x86_64.rpm',
          checksum_type: 'sha256',
          checksum: 'd38a6b65326e471540ce5105677411035d437a177634a77088dfb73e34461f37',
          type: :rpm,
          size: 1949,
          arch: 'x86_64',
          name: 'oranges',
          summary: 'Oranges dummy RPM',
          description: 'Dummy oranges RPM',
          license: 'Public',
          version: '0.2',
          release: '0',
          build_time: Time.parse('2017-07-19 08:39:19 UTC')
        )
      ]
    end

    context 'XML compressed with Zstandard' do
      let(:parsed_files) do
        described_class.new.parse_file(
          file_fixture(
            'dummy_repo/repodata/0d499f39e90442b3f052681964debe48ac6e438252cee5fc2dd33002795026f1-primary.xml.zst'
          )
        )
      end

      it 'references rpm files' do
        expect(parsed_files).to eq(expected_result)
      end
    end

    context 'XML compressed with gzip' do
      let(:parsed_files) do
        described_class.new.parse_file(
          file_fixture(
            'dummy_repo/repodata/abf421e45af5cd686f050bab3d2a98e0a60d1b5ca3b07c86cb948fc1abfa675e-primary.xml.gz'
          )
        )
      end

      it 'references rpm files' do
        expect(parsed_files).to eq(expected_result)
      end
    end

    context 'plain XML' do
      let(:parsed_files) do
        described_class.new.parse_file(
          file_fixture(
            'dummy_repo/repodata/abf421e45af5cd686f050bab3d2a98e0a60d1b5ca3b07c86cb948fc1abfa675e-primary.xml'
          )
        )
      end

      it 'references rpm files' do
        expect(parsed_files).to eq(expected_result)
      end
    end
  end
end
