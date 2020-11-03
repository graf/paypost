# frozen_string_literal: true

require 'clockwork'
include Clockwork
require_relative 'boot'
require_relative 'environment'

every(1.hour, 'transactions.cleanup') do
  CleanupTransactionsJob.perform_later
end
