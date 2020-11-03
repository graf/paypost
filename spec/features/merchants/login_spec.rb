# frozen_string_literal: true

require 'rails_helper'

describe 'Merchant sign in process', type: :feature do
  before do
    create :admin, email: 'admin@test.com', password: 'password'
  end

  it 'signs me in' do
    visit '/admins/sign_in'
    within('#new_admin') do
      fill_in 'Email', with: 'admin@test.com'
      fill_in 'Password', with: 'password'
    end
    click_button 'Sign In as Admin'
    expect(page).to have_content 'Signed in successfully.'
  end
end
