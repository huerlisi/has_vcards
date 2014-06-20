require 'rails_helper'

RSpec.describe HasVcards::Address do
  before { @address = FactoryGirl.create :address }

  it 'has a valid factory' do
    expect(@address).to be_valid
  end

  describe 'address validation' do

    it 'accepts a valid address' do
      @address.validate_address

      expect(@address.errors).to be_empty
    end

    it 'accepts with an extended address instead of a street address' do
      @address.street_address = nil
      @address.extended_address = 'Alternative Address'
      @address.validate_address

      expect(@address.errors).to be_empty
    end

    it 'accepts with a postal office box instead of a street address' do
      @address.street_address = nil
      @address.post_office_box = '982312'
      @address.validate_address

      expect(@address.errors).to be_empty
    end

    it 'rejects without a postal code' do
      @address.postal_code = nil
      @address.validate_address

      expect(@address.errors.size).to eq 1
      expect(@address.errors.first.first).to eq :postal_code
    end

    it 'rejects without a locality' do
      @address.locality = nil
      @address.validate_address

      expect(@address.errors.size).to eq 1
      expect(@address.errors.first.first).to eq :locality
    end

    it 'rejects without at least an address, an extended address or a post office box' do
      @address.street_address = nil
      @address.validate_address

      expect(@address.errors.size).to eq 3
      expect(@address.errors.first.first).to eq :street_address
    end
  end
end
