module HasAddress
  def self.included(base)
    base.alias_method_chain :address, :autobuild
  end

  def address_with_autobuild
    address_without_autobuild || build_address
  end
end

class Vcard < ActiveRecord::Base
  has_one :address, :autosave => true, :validate => true
  accepts_nested_attributes_for :address
  delegate  :post_office_box, :extended_address, :street_address, :locality, :region, :postal_code, :country_name, :to => :address
  delegate  :post_office_box=, :extended_address=, :street_address=, :locality=, :region=, :postal_code=, :country_name=, :to => :address
  include HasAddress
  
  has_many :addresses, :autosave => true, :validate => true
  accepts_nested_attributes_for :addresses

  named_scope :active, :conditions => {:active => true}
  named_scope :by_name, lambda {|name| {:conditions => self.by_name_conditions(name)}}
  named_scope :with_address, :join => :address

  belongs_to :object, :polymorphic => true

  # Convenience accessors
  def full_name
    result = read_attribute(:full_name)
    result ||= [ family_name, given_name ].compact.join(' ')

    return result
  end

  def abbreviated_name
    "#{given_name[0..0]}. #{family_name}"
  end

  # Advanced finders
  def self.by_name_conditions(name)
    ['vcards.full_name LIKE :name OR vcards.family_name LIKE :name OR vcards.given_name LIKE :name OR vcards.nickname LIKE :name', {:name => name}]
  end

  def self.find_by_name(name)
    self.find(:first, :conditions => self.by_name_conditions(name))
  end

  def self.find_all_by_name(name)
    self.find(:all, :conditions => self.by_name_conditions(name))
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

  def contact_lines(separator = " ")
    lines = contacts.map{|p| p.to_s unless (p.number.nil? or p.number.strip.empty?)}
    
    # Only return non-empty lines
    lines.map {|line| line.strip unless (line.nil? or line.strip.empty?)}.compact
  end

  # Phone numbers
  has_many :contacts, :class_name => 'PhoneNumber', :as => :object do
    def build_defaults
      ['Tel. geschäft', 'Tel. privat', 'Handy', 'E-Mail'].map{ |phone_number_type|
        build(:phone_number_type => phone_number_type) unless exists?(:phone_number_type => phone_number_type)
      }
    end
  end
  accepts_nested_attributes_for :contacts, :reject_if => proc {|attributes| attributes['number'].blank? }, :allow_destroy => true
  
  # Salutation
  def salutation
    case honorific_prefix
    when 'Herr Dr. med.'
      result = "Sehr geehrter Herr Dr. " + family_name
    when 'Frau Dr. med.'
      result = "Sehr geehrte Frau Dr. " + family_name
    when 'Herr Dr.'
      result = "Sehr geehrter Herr Dr. " + family_name
    when 'Frau Dr.'
      result = "Sehr geehrte Frau Dr. " + family_name
    when 'Herr'
      result = "Sehr geehrter Herr " + family_name
    when 'Frau'
      result = "Sehr geehrte Frau " + family_name
    when 'Br.'
      result = "Sehr geehrter Bruder " + family_name
    when 'Sr.'
      result = "Sehr geehrte Schwester " + family_name
    else
      result = "Sehr geehrte Damen und Herren"
    end
    return result
  end
end

module VcardClassMethods
  def has_vcards(options = {})
    class_eval <<-end_eval
      named_scope :by_name, lambda {|name| {:include => :vcard, :order => 'vcards.full_name', :conditions => Vcard.by_name_conditions(name)}}

      has_one :vcard, :as => 'object', :autosave => true, :validate => true
      delegate :full_name, :nickname, :family_name, :given_name, :additional_name, :honorific_prefix, :honorific_suffix, :to => :vcard
      delegate :full_name=, :nickname=, :family_name=, :given_name=, :additional_name=, :honorific_prefix=, :honorific_suffix=, :to => :vcard
      
      has_many :vcards, :as => 'object', :autosave => true, :validate => true
    end_eval
  end
end
