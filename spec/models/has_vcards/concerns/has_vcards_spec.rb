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
  end

  it 'delegates name attributes writes to the vcard' do
    something = Something.new(
      full_name: 'Full',
      nickname: 'Nick',
      family_name: 'Family',
      given_name: 'Given',
      additional_name: 'Additional',
      honorific_prefix: 'Prefix',
      honorific_suffix: 'Suffix'
    )

    expect(something.vcard.full_name).to eq 'Full'
    expect(something.vcard.nickname).to eq 'Nick'
    expect(something.vcard.family_name).to eq 'Family'
    expect(something.vcard.given_name).to eq 'Given'
    expect(something.vcard.additional_name).to eq 'Additional'
    expect(something.vcard.honorific_prefix).to eq 'Prefix'
    expect(something.vcard.honorific_suffix).to eq 'Suffix'
  end

  it 'delegates name attributes reads to the vcard' do
    vcard = HasVcards::Vcard.new(
      full_name: 'Full',
      nickname: 'Nick',
      family_name: 'Family',
      given_name: 'Given',
      additional_name: 'Additional',
      honorific_prefix: 'Prefix',
      honorific_suffix: 'Suffix'
    )

    something = Something.new(vcard: vcard)

    expect(something.full_name).to eq 'Full'
    expect(something.nickname).to eq 'Nick'
    expect(something.family_name).to eq 'Family'
    expect(something.given_name).to eq 'Given'
    expect(something.additional_name).to eq 'Additional'
    expect(something.honorific_prefix).to eq 'Prefix'
    expect(something.honorific_suffix).to eq 'Suffix'
  end

  it 'should accept nested attributes for vcard' do
    vcard_attributes = { full_name: 'Full' }

    something = Something.create(vcard_attributes: vcard_attributes)
    expect(something.vcard.full_name).to eq 'Full'
  end

  it 'should accept nested attributes for vcards' do
    vcards_attributes = { '' => { full_name: 'Full' } }

    something = Something.create(vcards_attributes: vcards_attributes)
    expect(something.vcards[0].full_name).to eq 'Full'
  end
end
