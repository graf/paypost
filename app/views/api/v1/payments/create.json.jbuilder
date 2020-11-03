# frozen_string_literal: true

json.call(@payment, :uuid, :status, :processed_at)
json.partial! @payment, as: :payment
