RSpec.configure do |config|
  def file_fixture(path)
    File.join(__dir__, 'fixtures', 'files', path).to_s
  end
end