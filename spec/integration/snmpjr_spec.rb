require 'snmpjr'
require 'snmpjr/response'

describe "snmpjr" do

  describe 'GET' do
    context 'when the host is reachable' do
      subject { Snmpjr.new(:host => 'demo.snmplabs.com', :port => 161, :community => 'public') }

      it "can perform a simple synchronous get request on an snmp agent" do
        expect(subject.get '1.3.6.1.2.1.1.1.0').to eq Snmpjr::Response.new(:value => 'SunOS zeus.snmplabs.com 4.1.3_U1 1 sun4m')
      end

      let(:expected) { [Snmpjr::Response.new(:value => 'SunOS zeus.snmplabs.com 4.1.3_U1 1 sun4m'),
                        Snmpjr::Response.new(:value => 'zeus.snmplabs.com')] }
      it "can perform a series of gets if passed an array of oids" do
        expect(subject.get ['1.3.6.1.2.1.1.1.0', '1.3.6.1.2.1.1.5.0']).to eq expected
      end

      context "when an invalid oid is requested" do

        let(:expected) { [Snmpjr::Response.new(:error => 'Invalid first sub-identifier (must be 0, 1, or 2)'),
                          Snmpjr::Response.new(:value => 'zeus.snmplabs.com')] }

        it "returns an error" do
          expect(subject.get ['6.5.4.3.2.1', '1.3.6.1.2.1.1.5.0']).to eq expected
        end
      end
    end

    context 'when the host is unreachable' do
      subject { Snmpjr.new(:host => 'example.com', :port => 161, :community => 'public') }

      it "the request times out after 5 seconds" do
        expect(subject.get '1.3.6.1.2.1.1.1.0').to eq Snmpjr::Response.new(:error => 'Request timed out')
      end
    end
  end
end
