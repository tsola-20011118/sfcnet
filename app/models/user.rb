class User < ApplicationRecord
    validates :name, {presence: true}
    validates :age, {presence: true}
    validates :mail, {presence: true}
    validates :passward, {presence: true}
    validates :sex, {presence: true}
end
