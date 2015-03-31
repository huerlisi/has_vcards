require 'rails_helper'

RSpec.describe HasVcards::PhoneNumber do
  before { @phone_number = FactoryGirl.create :phone_number }

  it 'has a valid factory' do
    expect(@phone_number).to be_valid
    expect(@phone_number.vcard).to be_valid
  end

  describe '#label' do
    let(:phone) { FactoryGirl.build :phone_number }

    it 'uses locales when known' do
      phone.phone_number_type = 'email'
      expect(phone.label).to eq 'Mail'
    end

    it 'titelizes the type when no locale available' do
      phone.phone_number_type = 'new_phone'
      expect(phone.label).to eq 'New Phone'
    end

    it 'returns empty string if phone_number_type is empty' do
      phone.phone_number_type = nil
      expect(phone.label).to eq ''

      phone.phone_number_type = ' '
      expect(phone.label).to eq ''
    end
  end

  describe '#to_s' do
    let(:phone) { FactoryGirl.build :phone_number, number: '077/777 88 99' }

    it 'returns the sole number by default' do
      expect(phone.to_s).to eq '077/777 88 99'
    end

    it 'returns the sole number for :default format' do
      expect(phone.to_s(:default)).to eq '077/777 88 99'
    end

    it 'returns the label and number for the :label format' do
      expect(phone).to receive(:label).and_return('Ph')
      string = phone.to_s(:label)
      expect(string).to match(/077\/777 88 99/)
      expect(string).to match(/Ph/)
    end

    it 'uses the passed in separator for the :label format' do
      expect(phone).to receive(:label).and_return('Ph')
      expect(phone.to_s(:label, '|')).to eq 'Ph|077/777 88 99'
    end

    it 'uses locales to the passed in separator for the :label format' do
      expect(phone).to receive(:label).and_return('Ph')
      expect(phone.to_s(:label, '|')).to eq 'Ph|077/777 88 99'
    end
  end

  describe '#to_url' do
    let(:phone) { FactoryGirl.build :phone_number, number: '123' }

    it 'returns a tel: URL for phone numbers' do
      phone.phone_number_type = 'phone'
      expect(phone.to_url).to eq 'tel:123'
    end

    it 'returns a tel: URL for mobile numbers' do
      phone.phone_number_type = 'mobile'
      expect(phone.to_url).to eq 'tel:123'
    end

    it 'returns a fax: URL for fax numbers' do
      phone.phone_number_type = 'fax'
      expect(phone.to_url).to eq 'fax:123'
    end

    it 'returns a mailto: URL for email addresses' do
      phone.phone_number_type = 'email'
      expect(phone.to_url).to eq 'mailto:123'
    end

    it 'returns nil for unknown types' do
      phone.phone_number_type = 'unicorn'
      expect(phone.to_url).to be_nil
    end
  end
end
