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
        expect(response.first.value).to eq 'SunOS zeus.snmplabs.com 4.1.3_U1 1 sun4m'
        expect(response.last.value).to eq 'Timeticks: (1) 0:00:00.01'
      end

      context "when an invalid oid is requested" do

        it 'returns an error' do
          expect(subject.walk '1.3.6.1.5').to eq Snmpjr::Response.new(error: 'noSuchInstance') 
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
