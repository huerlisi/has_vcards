module HasVcards
  class VcardsController < ApplicationController
    # Use inherited resources logic
    inherit_resources
    respond_to :html, :js

    def directory_lookup
      @vcard = Vcard.find(params[:id])
    end

    def directory_update
      @vcard = Vcard.find(params[:id])
      new_params = params[:vcard].select { |key, _| ['family_name', 'given_name', 'street_address', 'postal_code', 'locality'].include?(key) }

      @vcard.update_attributes(new_params)

      @vcard.save

      redirect_to @vcard.reference
    end
  end
end
