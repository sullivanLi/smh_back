class Event < ActiveRecord::Base
  belongs_to :person
  has_many :times, class_name: "EventTime", dependent: :destroy

  before_create :generate_random_id
  alias_attribute :owner, :person

  private

  def generate_random_id
    begin
      self.id = SecureRandom.random_number(1_000_000)
    end while Event.where(id: self.id).exists?
  end
end
