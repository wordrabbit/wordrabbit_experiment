class Page < ApplicationRecord
  belongs_to :site
  has_many :issues
end
