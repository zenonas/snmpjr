describe "snmpjr" do

  describe 'GET' do
    it "can perform a simple synchronous get request on an snmp agent" do
      snmp = Snmpjr.new(:host => 'demo.snmplabs.com', :port => 161, :community => 'public')
      expect(snmp.get '1.3.6.1.2.1.1.1.0').to eq 'SunOS zeus.snmplabs.com 4.1.3_U1 1 sun4m'
    end
  end
end
