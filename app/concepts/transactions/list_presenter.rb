# frozen_string_literal: true

module Transactions
  class ListPresenter
    def initialize(transactions)
      @transactions = transactions
    end

    def transactions
      @_transactions ||= @transactions.map do |t|
        transaction(t)
      end
    end

    private

    def transaction(transaction)
      {
        type: transaction_type(transaction),
        amount: transaction.amount,
        uuid: transaction.uuid,
        status: transaction.status,
        created_at: transaction.created_at,
        row_style: row_style(transaction)
      }
    end

    def transaction_type(transaction)
      transaction.type.demodulize.downcase
    end

    def row_style(transaction)
      case transaction.status
      when 'approved', :approved
        'table-success'
      when 'error', :error
        'table-danger'
      when 'reversed', :reversed, 'refunded', :refunded
        'table-secondary'
      else
        ''
      end
    end
  end
end
