module Vcards::VcardHelper
  module InstanceMethods
    def address(vcard, separator = '<br/>')
      vcard.address_lines.map{|line| h(line)}.join(separator)
    end

    def full_address(vcard, separator = '<br/>')
      vcard.full_address_lines.map{|line| h(line)}.join(separator)
    end

    def contact(vcard, separator = '<br/>')
      vcard.contact_lines.map{|line| h(line)}.join(separator)
    end
  end
end
