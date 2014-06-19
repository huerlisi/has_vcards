# encoding: utf-8

module HasVcards
  module HasAddress
    def self.included(base)
      base.alias_method_chain :address, :autobuild
    end

    def address_with_autobuild
      address_without_autobuild || build_address
    end
  end

  class Vcard < ActiveRecord::Base
    has_one :address, autosave: true, validate: true
    # Phone numbers
    has_many :contacts, class_name: 'PhoneNumber', inverse_of: :vcard do
      def build_defaults
        # TODO i18nify
        ['Tel. geschäft', 'Tel. privat', 'Handy', 'E-Mail'].map{ |phone_number_type|
          build(phone_number_type: phone_number_type) unless exists?(phone_number_type: phone_number_type)
        }
      end
    end
    has_many :addresses, autosave: true, validate: true
    belongs_to :reference, polymorphic: true

    accepts_nested_attributes_for :addresses
    accepts_nested_attributes_for :address

    delegate  :post_office_box, :extended_address, :street_address, :locality, :region, :postal_code, :country_name, :zip_locality, to: :address
    delegate  :post_office_box=, :extended_address=, :street_address=, :locality=, :region=, :postal_code=, :country_name=, :zip_locality=, to: :address

    accepts_nested_attributes_for :contacts,
      reject_if: proc {|attributes| attributes['number'].blank? },
      allow_destroy: true

    # Access restrictions
    if defined?(ActiveModel::MassAssignmentSecurity)
      attr_accessible :full_name, :address_attributes, :family_name, :given_name,
        :post_office_box, :extended_address, :street_address, :locality, :region,
        :postal_code, :country_name, :zip_locality, :contacts_attributes,
        :honorific_prefix
    end

    include HasAddress
    # SwissMatch
    include Vcard::DirectoryLookup

    scope :active, conditions: { active: true }
    scope :by_name, lambda { |name| { conditions: self.by_name_conditions(name) } }
    scope :with_address, joins(:address).includes(:address)

    # Validations
    include I18nHelpers

    def validate_name
      if full_name.blank?
        errors.add(:full_name, "#{t_attr(:full_name, Vcard)} #{I18n.translate('errors.messages.empty')}")
        errors.add(:family_name, "#{t_attr(:family_name, Vcard)} #{I18n.translate('errors.messages.empty')}")
        errors.add(:given_name, "#{t_attr(:given_name, Vcard)} #{I18n.translate('errors.messages.empty')}")
      end
    end

    # Convenience accessors
    def full_name
      result = read_attribute(:full_name)
      result ||= [ family_name, given_name ].compact.join(' ')

      return result
    end

    def abbreviated_name
      return read_attribute(:full_name) if read_attribute(:full_name)

      [given_name.try(:first).try(:upcase), family_name].compact.join(". ")
    end

    # Advanced finders
    def self.by_name_conditions(name)
      ['vcards.full_name LIKE :name OR vcards.family_name LIKE :name OR vcards.given_name LIKE :name OR vcards.nickname LIKE :name', { name: name }]
    end

    def self.find_by_name(name)
      self.find :first, conditions: self.by_name_conditions(name)
    end

    def self.find_all_by_name(name)
      self.find :all, conditions: self.by_name_conditions(name)
    end

    # Helper methods
    def address_lines
      lines = [extended_address, street_address, post_office_box, "#{postal_code} #{locality}"]

      # Only return non-empty lines
      lines.map {|line| line.strip unless (line.nil? or line.strip.empty?)}.compact
    end

    def full_address_lines
      lines = [honorific_prefix, full_name] + address_lines

      # Only return non-empty lines
      lines.map {|line| line.strip unless (line.nil? or line.strip.empty?)}.compact
    end

    def contact_lines
      lines = contacts.map{|p| p.to_s unless (p.number.nil? or p.number.strip.empty?)}

      # Only return non-empty lines
      lines.map {|line| line.strip unless (line.nil? or line.strip.empty?)}.compact
    end
  end
end
