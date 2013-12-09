class Card < ActiveRecord::Base

  # Select count cards at random
  def self.sample(count)
    return false if count > Card.count
    Card.select(:id).map{|m| m.id}.sample(count, random: Random.new)
  end

end
