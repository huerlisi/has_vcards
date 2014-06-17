require 'rails_helper'

RSpec.describe HasVcards::Vcard do
  it 'has a valid factory' do
    vcard = FactoryGirl.create(:vcard)
    expect(vcard).to be_valid
  end
end
