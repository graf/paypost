# frozen_string_literal: true

require 'rails_helper'

describe Admins::Merchants::New do
  subject(:operation) { described_class.call(user: admin) }

  let(:admin) { create :admin }

  it_behaves_like 'an operation'
  it_behaves_like 'an operation allowed for admin'
end
