class Case < ActiveRecord::Base

  enum conclusion: [:"plaintiff won the case" , :"defendant won the case", :"not decided yet"]
  after_initialize :set_default_conclusion, :if => :new_record?

  def set_default_conclusion
    self.conclusion ||= :"not decided yet"
  end



  enum kind: [:normal, :landmark]
  after_initialize :set_default_kind, :if => :new_record?

  def set_default_kind
    self.kind ||= :normal
  end



  def to_s
    return self.title
  end


  def hasDims
    @hasDims = []
    Dim.all.each do |dim|
      @s = dim.pres.to_set
      if self.pres.all.to_set & @s == @s
        @hasDims<<dim
      end
    end
    return @hasDims
  end

  belongs_to :user
  has_and_belongs_to_many :pres
end
