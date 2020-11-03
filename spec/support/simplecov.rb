# frozen_string_literal: true

require 'simplecov'
SimpleCov.start 'rails' do
  add_filter '/lib/'
  add_filter 'app/jobs/'
  add_group 'Services', 'app/services'
  add_group 'Operations', 'app/concepts'
end
