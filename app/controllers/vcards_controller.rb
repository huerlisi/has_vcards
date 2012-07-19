class VcardsController < ApplicationController
  # User inherited resources logic
  inherit_resources
  respond_to :html, :js

  def directory_lookup
    @vcard = Vcard.find(params[:id])
  end
end
