module HasVcards
  module Concerns
    # ActiveRecord extensions
    #
    # Including this module in your ActiveRecord classes sets up associations and helpers to integrate Vcards with that model.
    #
    # Use something like this to use it:
    #
    # class Something < ActiveRecord::Base
    #   include HasVcards::Concerns::HasVcards
    # end
    module HasVcards
      extend ActiveSupport::Concern

      included do
        # Vcards
        has_many :vcards, class_name: 'HasVcards::Vcard', as: 'reference', autosave: true, validate: true
        accepts_nested_attributes_for :vcards

        # Single/Main vcard
        has_one :vcard, class_name: 'HasVcards::Vcard', as: 'reference', autosave: true, validate: true
        accepts_nested_attributes_for :vcard

        delegate :full_name, :nickname, :family_name, :given_name, :additional_name, :honorific_prefix, :honorific_suffix, to: :vcard
        delegate :full_name=, :nickname=, :family_name=, :given_name=, :additional_name=, :honorific_prefix=, :honorific_suffix=, to: :vcard

        def vcard_with_autobuild
          vcard_without_autobuild || build_vcard
        end
        alias_method :vcard_without_autobuild, :vcard
        alias_method :vcard, :vcard_with_autobuild

        # Access restrictions
        if defined?(ActiveModel::MassAssignmentSecurity)
          attr_accessible :full_name, :nickname, :family_name, :given_name, :honorific_prefix, :honorific_suffix,
                          :vcard_attributes, :vcards_attributes
        end
      end
    end
  end
end
