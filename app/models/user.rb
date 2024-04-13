class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

        attribute :approved, :boolean, default: false
        attribute :role, :boolean, default: false

  def admin?
    isAdmin
  end
end
