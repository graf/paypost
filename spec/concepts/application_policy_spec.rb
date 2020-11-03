# frozen_string_literal: true

require 'rails_helper'

describe ApplicationPolicy do
  subject(:policy) { described_class.new(user, double) }

  describe 'admin?' do
    subject { policy.admin? }

    let(:user) { create :admin }

    it { is_expected.to be_truthy }
  end

  describe 'merchant?' do
    subject { policy.merchant? }

    let(:user) { create :merchant }

    it { is_expected.to be_truthy }
  end
end
