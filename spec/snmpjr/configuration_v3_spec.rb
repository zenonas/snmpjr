require production_code

describe Snmpjr::ConfigurationV3 do
  describe '#authentication' do
    it 'sets the authentication protocol' do
      subject.authentication 'MD5', 'test1234'
      expect(subject.authentication_protocol).to eq 'MD5'
    end

    it 'sets the authentication key' do
      subject.authentication 'MD5', 'test1234'
      expect(subject.authentication_key).to eq 'test1234'
    end
  end

  describe '#privacy' do
    it 'sets the privacy protocol' do
      subject.privacy 'AES256', 'test1234'
      expect(subject.privacy_protocol).to eq 'AES256'
    end

    it 'sets the privacy key' do
      subject.privacy 'AES256', 'test1234'
      expect(subject.privacy_key).to eq 'test1234'
    end
  end

  describe '#create_pdu' do
    it 'creates a new PduV3 instance' do
      expect(subject.create_pdu).to be_a Snmpjr::PduV3
    end

    it 'assigns a context to it' do
      subject.context = 'some_context'
      expect(Snmpjr::PduV3).to receive(:new).with('some_context')
      subject.create_pdu
    end
  end

  describe '#security_level' do
    context 'noAuthNoPriv' do
      it 'sets the security level to NoAuthNoPriv if no authentication or privacy are set' do
        expect(subject.security_level).to eq Snmpjr::ConfigurationV3::SecurityLevels::NoAuthNoPriv
      end
    end

    context 'authNoPriv' do
      it 'sets the security level to no authNoPriv if authentication but no privacy is set' do
        subject.authentication 'MD5', 'test1234'
        expect(subject.security_level).to eq Snmpjr::ConfigurationV3::SecurityLevels::AuthNoPriv
      end
    end

    context 'authPriv' do
      it 'sets the security level to authPriv if both authentication and privacy are set' do
        subject.authentication 'MD5', 'test1234'
        subject.privacy 'AES256', 'test1234'
        expect(subject.security_level).to eq Snmpjr::ConfigurationV3::SecurityLevels::AuthPriv
      end
    end
  end

  describe '#create_target' do
    let(:target) { double :target }
    let(:created_target) { double :created_target }

    before do
      allow(Snmpjr::TargetV3).to receive(:new).and_return target
      allow(target).to receive(:create).with(subject).and_return created_target
    end

    it 'creates a target for snmp v3' do
      subject.create_target
      expect(subject.create_target).to eq created_target
    end
  end

  describe '#create_session' do
    let(:created_session) { double :created_session }

    before do
      allow(Snmpjr::SessionV3).to receive(:new).with(subject).and_return created_session
    end

    it 'creates a session for snmp v3' do
      subject.create_session
      expect(subject.create_session).to eq created_session
    end
  end
end
