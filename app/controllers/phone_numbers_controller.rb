class PhoneNumbersController < ApplicationController
  # Use inherited resources logic
  inherit_resources
  respond_to :html, :js

  # Relations
  optional_belongs_to :vcard

  # Optionally support in place editing
  if respond_to? :in_place_edit_for
    in_place_edit_for :phone_number, :phone_number_type
    in_place_edit_for :phone_number, :number
  end
end
