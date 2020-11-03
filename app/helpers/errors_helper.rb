# frozen_string_literal: true

module ErrorsHelper
  def with_each_field_error(model, field, &block)
    model.errors.full_messages_for(field).each(&block)
  end
end
