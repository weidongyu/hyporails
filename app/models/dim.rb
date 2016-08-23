class Dim < ActiveRecord::Base
  has_and_belongs_to_many :pres
  has_and_belongs_to_many :focals

  def to_s
    return self.name
  end
end
