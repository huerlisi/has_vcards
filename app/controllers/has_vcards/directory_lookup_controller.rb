module HasVcards
  class DirectoryLookupController < ApplicationController
    def search
      @selector = params[:selector]
      vcard_params = extract_vcard_params(params, @selector)

      @vcard = Vcard.new(vcard_params)
      render 'vcards/directory_lookup'
    end

    private
    def extract_vcard_params(params, selector)
      keys = selector.delete(']').split('[');
      vcard_params = params
      keys.each {|key| vcard_params = vcard_params[key]}
      return vcard_params
    end
  end
end
