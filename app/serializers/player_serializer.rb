class PlayerSerializer < ActiveModel::Serializer
  attributes :id, :username, :email, :activity
end
