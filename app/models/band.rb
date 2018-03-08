class Band < ActiveRecord
  validates :name, :user_id, presence: true
  belongs_to :user
end
