module Vcards
  class Address < ActiveRecord::Base
    belongs_to :vcard
  end
end
