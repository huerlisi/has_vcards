module HasVcards
  module ClassMethods
    def has_vcards
      class_eval <<-end_eval
        scope :by_name, lambda {|name| {:include => :vcard, :order => 'vcards.full_name', :conditions => Vcard.by_name_conditions(name)}}

        has_one :vcard, :class_name => 'HasVcards::Vcard', :as => 'reference', :autosave => true, :validate => true
        delegate :full_name, :nickname, :family_name, :given_name, :additional_name, :honorific_prefix, :honorific_suffix, :to => :vcard
        delegate :full_name=, :nickname=, :family_name=, :given_name=, :additional_name=, :honorific_prefix=, :honorific_suffix=, :to => :vcard

        has_many :vcards, :class_name => 'HasVcards::Vcard', :as => 'reference', :autosave => true, :validate => true

        def vcard_with_autobuild
          vcard_without_autobuild || build_vcard
        end
        alias_method_chain :vcard, :autobuild
      end_eval
    end
  end
end
