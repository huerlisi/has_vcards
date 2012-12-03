# encoding: utf-8

class HonorificPrefix < ActiveRecord::Base
  # Access restrictions
  attr_accessible :sex, :position, :name
end
