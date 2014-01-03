class RippleBridge < ActiveRecord::Base
  DESTINATION_TAG_LIMIT = 1000000000 
  attr_accessible :bitcoin_address, :destination_tag
  after_create :set_destination_tag

  validates_uniqueness_of :destination_tag
  validates_uniqueness_of :bitcoin_address
 
  def generate_destination_tag
    Random.rand(DESTINATION_TAG_LIMIT)
  end

  def set_destination_tag
    @good_tag = false
    while !@good_tag 
      tag = generate_destination_tag
      bridges = RippleBridge.where(destination_tag: tag)
      if bridges.length == 0
        @good_tag = true 
      end
    end
    self.destination_tag = tag
    self.save
  end
end
