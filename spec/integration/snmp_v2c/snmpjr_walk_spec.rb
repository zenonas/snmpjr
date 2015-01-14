require 'snmpjr'
require 'snmpjr/response'
require 'snmpjr/session_v2c'

describe "snmpjr for snmp v2c" do

  describe 'WALK' do
    subject { Snmpjr.new(Snmpjr::Version::V2C) }

    context 'when the host is reachable' do
      before do
        subject.configure do |config|
          config.host = 'demo.snmplabs.com'
          config.port = 161
          config.community = 'public'
        end
      end

      it 'can perform a simple synchronous walk request on an snmp agent' do
        response = subject.walk '1.3.6.1.2.1.1'
        expect(response.count).to eq 11
        expect(response.first.to_h).to eq(
          { oid: '1.3.6.1.2.1.1.1.0', value: 'SunOS zeus.snmplabs.com 4.1.3_U1 1 sun4m', type: 'OCTET STRING' }
        )
      end

      context "when a non existent subtree is walked" do
        it 'returns an empty array' do
          expect(subject.walk '1.3.6.1.5').to eq []
        end
      end
    end

    context 'when the host is unreachable' do
      before do
        subject.configure do |config|
          config.host = 'demo.snmplabs.com'
          config.port = 161
          config.community = 'public'
          config.timeout = 50
        end
      end

      it 'the request times out after 5 seconds' do
        expect{
          subject.walk '1.3.6.1.2.1.1'
        }.to raise_error(Snmpjr::TargetTimeoutError)
      end
    end
  end
end
