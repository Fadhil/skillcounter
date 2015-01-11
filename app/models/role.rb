class Role < ActiveRecord::Base
	# include CanCan::Ability
    has_and_belongs_to_many :users
end
