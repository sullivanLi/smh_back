class Event < ActiveRecord::Base
  has_many :times, class_name: "EventTime"
  before_create :generate_random_id

  private

  def generate_random_id
    begin
      self.id = SecureRandom.random_number(1_000_000)
    end while Event.where(id: self.id).exists?
  end
end
