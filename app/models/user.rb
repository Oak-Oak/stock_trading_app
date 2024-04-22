class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable

        attribute :approved, :boolean, default: false
        attribute :isAdmin, :boolean, default: false

  has_many :transactions
end
