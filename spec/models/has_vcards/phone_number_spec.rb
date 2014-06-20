require 'rails_helper'

RSpec.describe HasVcards::PhoneNumber do
  before { @phone_number = FactoryGirl.create :phone_number }

  it 'has a valid factory' do
    expect(@phone_number).to be_valid
    expect(@phone_number.vcard).to be_valid
  end
end
