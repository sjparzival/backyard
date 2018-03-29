class Block < ApplicationRecord
  has_many :taggings
  has_many :tags, through: :taggings, dependent: :destroy
  belongs_to :user
end
