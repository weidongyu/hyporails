class Pre < ActiveRecord::Base
  has_and_belongs_to_many :cases
  has_and_belongs_to_many :dims
end
