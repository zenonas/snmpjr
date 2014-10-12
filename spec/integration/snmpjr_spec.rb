require 'snmpjr'

describe "snmpjr" do

  subject { Snmpjr.new(:host => 'demo.snmplabs.com', :port => 161, :community => 'public') }
  describe 'GET' do
    it "can perform a simple synchronous get request on an snmp agent" do
      expect(subject.get '1.3.6.1.2.1.1.1.0').to eq 'SunOS zeus.snmplabs.com 4.1.3_U1 1 sun4m'
    end

    let(:expected) { ['SunOS zeus.snmplabs.com 4.1.3_U1 1 sun4m', 'zeus.snmplabs.com'] }
    it "can perform a series of gets if passed an array of oids" do
      expect(subject.get ['1.3.6.1.2.1.1.1.0', '1.3.6.1.2.1.1.5.0']).to eq expected
    end
  end
end
