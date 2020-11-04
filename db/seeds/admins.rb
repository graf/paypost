# frozen_string_literal: true

def create_admin(email:, password:)
  Admin.find_or_create_by!(email: email) do |user|
    user.password = password
  end
end

create_admin(email: 'admin@paypost.com', password: '123456')
