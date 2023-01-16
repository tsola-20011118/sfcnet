class Talk < ApplicationRecord
    validates :message, {presence: true}
end
