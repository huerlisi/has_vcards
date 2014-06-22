module HasVcards
  class ZipLocalityInput < SimpleForm::Inputs::StringInput
    def zip_codes
      SwissMatch.zip_codes.map { |zip| zip.to_s }.inspect
    end

    def input
      input_html_options[:type] = 'text'
      input_html_options[:autocomplete] = 'off'
      input_html_options['data-provide'] = 'typeahead'
      input_html_options['data-source'] = zip_codes

      super
    end
  end
end
