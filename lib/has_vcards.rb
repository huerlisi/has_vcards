require 'has_vcards/railtie' if defined?(::Rails::Railtie)

module HasVcardsClassMethods
  def has_vcards(options = {})
    class_eval <<-end_eval
      scope :by_name, lambda {|name| {:include => :vcard, :order => 'vcards.full_name', :conditions => Vcard.by_name_conditions(name)}}

      has_one :vcard, :as => 'object', :autosave => true, :validate => true
      delegate :full_name, :nickname, :family_name, :given_name, :additional_name, :honorific_prefix, :honorific_suffix, :to => :vcard
      delegate :full_name=, :nickname=, :family_name=, :given_name=, :additional_name=, :honorific_prefix=, :honorific_suffix=, :to => :vcard
      
      has_many :vcards, :as => 'object', :autosave => true, :validate => true

      def vcard_with_autobuild
        vcard_without_autobuild || build_vcard
      end
      alias_method_chain :vcard, :autobuild
    end_eval
  end
end
