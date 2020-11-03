# frozen_string_literal: true

class CleanupTransactionsJob < ApplicationJob
  queue_as :default

  def perform(*_args)
    Transactions::Cleanup.call
  end
end
