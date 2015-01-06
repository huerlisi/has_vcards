# encoding: utf-8

require 'rails_helper'

describe HasVcards::Vcard do
  before { @vcard = FactoryGirl.build :vcard }

  it 'has a valid factory' do
    expect(@vcard).to be_valid
  end

  context 'database schema' do
    let(:vcard) { HasVcards::Vcard.new }

    it 'allows long names' do
      vcard.full_name = 'a' * 100
      vcard.save
      vcard.reload
      expect(vcard.full_name).to eq ('a' * 100)
    end
  end

  context 'a new instance' do
    let(:vcard) { HasVcards::Vcard.new }

    it 'has an address autobuilt' do
      expect(vcard.address).to be_a HasVcards::Address
    end
  end

  describe 'name validation' do

    it 'accepts vcards with a full name' do
      @vcard.validate_name

      expect(@vcard.errors).to be_empty
    end

    it 'accepts vcards with a given name' do
      @vcard.full_name = nil
      @vcard.given_name = 'Ben'
      @vcard.validate_name

      expect(@vcard.errors).to be_empty
    end

    it 'accepts vcards with a family name' do
      @vcard.full_name = nil
      @vcard.family_name = 'Hur'
      @vcard.validate_name

      expect(@vcard.errors).to be_empty
    end

    it 'rejects vcards without a full name' do
      @vcard.full_name = nil
      @vcard.validate_name

      expect(@vcard.errors.size).to be 3
    end
  end

  describe '#full_name' do

    context 'with an existing full name' do

      it 'returns the same name' do
        expect(@vcard.full_name).to eq 'Ben Hur'
      end
    end

    context 'without an existing full name' do
      before { @vcard.full_name = nil }

      it 'constructs a full name from family- and given name' do
        @vcard.family_name = 'Clark'
        @vcard.given_name  = 'Louis'

        expect(@vcard.full_name).to eq 'Clark Louis'
      end
    end
  end

  describe '#abbreviated_name' do

    context 'with an existing full name' do

      it 'returns the same name' do
        expect(@vcard.abbreviated_name).to eq 'Ben Hur'
      end
    end

    context 'without an existing full name' do
      before { @vcard.full_name = nil }

      it 'constructs a full name from family- and given name' do
        @vcard.family_name = 'Clark'
        @vcard.given_name  = 'Louis Anderson'

        expect(@vcard.abbreviated_name).to eq 'L. Clark'
      end
    end
  end

  it 'delegates attribute accessors to the main address' do
    attributes = [ :post_office_box, :extended_address, :street_address, :locality, :region, :postal_code, :country_name, :zip_locality]
    attributes.each do |attr|
      expect(@vcard.address).to receive(attr)
      @vcard.address.send(attr)

      expect(@vcard.address).to receive("#{attr}=")
      @vcard.address.send("#{attr}=", 'foo')
    end
  end

  describe '#address_lines' do

    it 'only returns non empty lines' do
      @vcard.street_address   = '1234 Foobar Street'
      @vcard.post_office_box  = '09823'
      @vcard.extended_address = '   '

      expect(@vcard.address_lines.size).to be 2
    end

    it 'strips lines' do
      @vcard.street_address = '  1234 Foobar Street   '
      expect(@vcard.address_lines).to include('1234 Foobar Street')
    end
  end

  describe '#full_address_lines' do

    it 'also returns the full address and name' do
      @vcard.full_name        = 'Fullname'
      @vcard.honorific_prefix = 'Prefix'
      @vcard.street_address   = '1234 Foobar Street'
      @vcard.post_office_box  = '09823'

      expect(@vcard.full_address_lines.size).to be 4
    end

    it 'strips lines' do
      @vcard.street_address = '  1234 Foobar Street   '
      expect(@vcard.address_lines).to include('1234 Foobar Street')
    end
  end

  describe '#contact_lines' do
    it 'returns contact lines' do
      3.times { FactoryGirl.create :phone_number, vcard: @vcard }
      expect(@vcard.contacts.size).to eq 3
      expect(@vcard.contact_lines.size).to eq 3
    end

    it 'strips lines' do
      @vcard.contacts.build(number: '  123 44 55  ')
      expect(@vcard.contact_lines).to include('123 44 55')
    end
  end

  describe 'contacts relation' do
    describe '#build_defaults' do
      it 'builds default contacts' do
        @vcard.contacts = []
        @vcard.contacts.build_defaults
        expect(@vcard.contacts.map(&:phone_number_type)).to eql ['Tel. geschäft', 'Tel. privat', 'Handy', 'E-Mail']
      end

      it 'can be run twice without duplicating default contacts' do
        @vcard.contacts = []
        @vcard.contacts.build_defaults
        expect { @vcard.contacts.build_defaults }.to_not change { @vcard.contacts.size }
      end

      it 'does not add contacts for existing type' do
        email = @vcard.contacts.build phone_number_type: 'E-Mail'
        @vcard.contacts.build_defaults
        expect(@vcard.contacts.select { |contact| contact.phone_number_type == 'E-Mail' }).to contain_exactly(email)
      end
    end
  end

  context 'scopes' do
    describe '.by_name' do
      it 'finds vcards with name' do
        vcard_1 = FactoryGirl.create :vcard, full_name: 'quack'
        vcard_2 = FactoryGirl.create :vcard, full_name: 'Andi Peter'

        expect(HasVcards::Vcard.by_name('quack')).to eq [vcard_1]
      end
    end
  end
end
