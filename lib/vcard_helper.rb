module VcardHelper
  module InstanceMethods
    def address(vcard, line_separator = '<br/>')
      vcard.address_lines.map{|line| h(line)}.join(line_separator).html_safe
    end

    def full_address(vcard, line_separator = '<br/>')
      vcard.full_address_lines.map{|line| h(line)}.join(line_separator).html_safe
    end

    def contact(vcard, line_separator = '<br/>', label_separator = ' ')
      vcard.contact_lines(label_separator).map{|line| h(line)}.join(line_separator).html_safe
    end
  end
end
