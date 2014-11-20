require 'snmpjr'
require 'snmpjr/response'
require 'snmpjr/target_timeout_error'

describe "snmpjr" do

  describe 'GET' do
    context 'when the host is reachable' do
      subject do
        Snmpjr.new(Snmpjr::Version::V2C).configure do |config|
          config.host = 'demo.snmplabs.com'
          config.port = 161
          config.community = 'public'
        end
      end

      it 'can perform a simple synchronous get request on an snmp agent' do
        expect(subject.get '1.3.6.1.2.1.1.1.0').to eq Snmpjr::Response.new(oid: '1.3.6.1.2.1.1.1.0', value: 'SunOS zeus.snmplabs.com 4.1.3_U1 1 sun4m')
      end

      let(:expected) { [Snmpjr::Response.new(oid: '1.3.6.1.2.1.1.1.0', value: 'SunOS zeus.snmplabs.com 4.1.3_U1 1 sun4m'),
                        Snmpjr::Response.new(oid: '1.3.6.1.2.1.1.5.0', value: 'zeus.snmplabs.com')] }
      it 'can perform a series of gets if passed an array of oids' do
        expect(subject.get ['1.3.6.1.2.1.1.1.0', '1.3.6.1.2.1.1.5.0']).to eq expected
      end

      context "when an invalid oid is requested" do

        let(:expected) { [Snmpjr::Response.new(oid: '1.3.6.1.2.1.1.5', error: 'noSuchInstance'),
                          Snmpjr::Response.new(oid: '1.3.6.1.2.1.1.5.0', value: 'zeus.snmplabs.com')] }

        it 'returns an error' do
          expect(subject.get ['1.3.6.1.2.1.1.5', '1.3.6.1.2.1.1.5.0']).to eq expected
        end
      end
    end

    context 'when the host is unreachable' do
      subject do
        Snmpjr.new(Snmpjr::Version::V2C).configure do |config|
          config.host = 'demo.snmplabs.com'
          config.port = 161
          config.community = 'public'
          config.timeout = 50
        end
      end

      it 'the request times out after 5 seconds' do
        expect{
          subject.get '1.3.6.1.2.1.1.1.0'
        }.to raise_error(Snmpjr::TargetTimeoutError)
      end
    end
  end
end
