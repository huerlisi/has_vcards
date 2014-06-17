# encoding: utf-8

module HasVcards
  class HonorificPrefix < ActiveRecord::Base
    # Access restrictions
    attr_accessible :sex, :position, :name if defined?(ActiveModel::MassAssignmentSecurity)
  end
end
