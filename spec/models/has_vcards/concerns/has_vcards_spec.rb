require 'rails_helper'

# Dummy class to test class methods
class Something < ActiveRecord::Base
  include HasVcards::Concerns::HasVcards
end

describe HasVcards::Concerns::HasVcards do
  context 'a new instance of Something' do
    let(:something) { Something.new }

    it 'has a vcards association' do
      expect(something.vcards.build).to be_a HasVcards::Vcard
    end

    it 'has a vcard association' do
      expect(something.build_vcard).to be_a HasVcards::Vcard
    end

    it 'has a vcard autobuilt' do
      expect(something.vcard).to be_a HasVcards::Vcard
    end

    it 'delegates attribute accessors to the main vcard' do
      attributes = %i[ full_name nickname family_name given_name additional_name honorific_prefix honorific_suffix ]

      attributes.each do |attr|
        expect(something.vcard).to receive(attr)
        something.vcard.send(attr)

        expect(something.vcard).to receive("#{attr}=")
        something.vcard.send("#{attr}=", 'foo')
      end
    end
  end

  it 'accepts nested attributes for vcard' do
    vcard_attributes = { full_name: 'Full' }

    something = Something.create(vcard_attributes: vcard_attributes)
    expect(something.vcard.full_name).to eq 'Full'
  end

  it 'accepts nested attributes for vcards' do
    vcards_attributes = { '' => { full_name: 'Full' } }

    something = Something.create(vcards_attributes: vcards_attributes)
    expect(something.vcards[0].full_name).to eq 'Full'
  end
end
