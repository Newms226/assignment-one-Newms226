class Car < ApplicationRecord
  belongs_to :make
  has_and_belongs_to_many :parts

  validates :make, presence: true
  validates :model, presence: true
  validates :part_id, presence: true
  validates :vin, presence: true, numericality: true, uniqueness: true
end
