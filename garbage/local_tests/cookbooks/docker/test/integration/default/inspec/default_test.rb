# check when 2+2=4

#describe 'math' do
#  context 'when adding 1 + 1' do
#    it 'equals 2' do
#      expect(sum).to eq(2)
#    end
#  end
#
#  context 'when adding 2 + 2' do
#    it 'equals 4' do
#      expect(sum).to eq(4)
#    end
#  end
#end

# check that port 80 not open
describe port(80) do
  it { should_not be_listening }
end

# check that docker installed
describe package('docker-ce') do
  it { should be_installed }
end

