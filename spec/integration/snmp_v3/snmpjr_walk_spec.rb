require 'snmpjr'
require 'snmpjr/response'
require 'snmpjr/session_v3'

describe "snmpjr for snmp v3" do

  describe 'WALK' do
    subject { Snmpjr.new(Snmpjr::Version::V3) }

    context 'when the host is reachable' do
      before do
        subject.configure do |config|
          config.host = 'demo.snmplabs.com'
          config.port = 161
          config.context = '80004fb805636c6f75644dab22cc'
          config.user = 'usr-sha-des'
          config.authentication 'SHA', 'authkey1'
          config.privacy 'DES', 'privkey1'
        end
      end

      it 'can perform a simple synchronous walk request on an snmp agent' do
        response = subject.walk '1.3.6.1.2.1.1'
        expect(response.count).to eq 11
        expect(response.first.to_s).to eq 'SunOS zeus.snmplabs.com 4.1.3_U1 1 sun4m'
        expect(response.last.to_s).to match(/^\d+\:\d+:\d+\.\d+$/)
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
          config.context = '80004fb805636c6f75644dab22cc'
          config.user = 'usr-sha-des'
          config.authentication 'SHA', 'authkey1'
          config.privacy 'DES', 'privkey1'
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
