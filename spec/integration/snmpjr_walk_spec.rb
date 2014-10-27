require 'snmpjr'
require 'snmpjr/response'
require 'snmpjr/target_timeout_error'

describe "snmpjr" do

  describe 'WALK' do
    context 'when the host is reachable' do
      subject { Snmpjr.new(host: 'demo.snmplabs.com', port: 161, community: 'public') }

      it 'can perform a simple synchronous walk request on an snmp agent' do
        response = subject.walk '1.3.6.1.2.1.1'
        expect(response.count).to eq 11
        expect(response.first.to_s).to eq 'SunOS zeus.snmplabs.com 4.1.3_U1 1 sun4m'
        expect(response.last.to_s).to match /^\d+\:\d+:\d+\.\d+$/
      end

      context "when a non existent subtree is walked" do
        it 'returns an empty array' do
          expect(subject.walk '1.3.6.1.5').to eq []
        end
      end
    end

    context 'when the host is unreachable' do
      subject { Snmpjr.new(host: 'example.com', port: 161, community: 'public', timeout: 50) }

      it 'the request times out after 5 seconds' do
        expect{
          subject.walk '1.3.6.1.2.1.1'
        }.to raise_error(Snmpjr::TargetTimeoutError)
      end
    end
  end
end
