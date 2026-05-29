class Game < ApplicationRecord
  belongs_to :map
  
  # Gameはplayersを複数持ちますよ、という意味.(多分)
  # dependent: :destroyは、Gameを消したときに付随して消えますよ、という意味.
  has_many :players, dependent: :destroy
end
