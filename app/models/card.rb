class Card < ActiveRecord::Base

  def self.random(count)
    return false if count > Card.count
    Card.select(:id).map{|m| m.id}.sample(count, random: Random.new)
  end

end
