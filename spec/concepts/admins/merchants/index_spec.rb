# frozen_string_literal: true

require 'rails_helper'

describe Admins::Merchants::Index do
  subject(:operation) { described_class.call(user: admin, presenter: presenter) }

  let(:presenter) { double(new: true) }
  let!(:merchant1) { create :merchant }
  let!(:merchant2) { create :merchant }

  let(:admin) { create :admin }

  it_behaves_like 'an operation'
  it_behaves_like 'an operation allowed for admin'
  it do
    operation
    expect(presenter).to have_received(:new).with(match_array([merchant2, merchant1]))
  end
end
