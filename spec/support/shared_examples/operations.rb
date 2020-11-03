# frozen_string_literal: true

RSpec.shared_examples 'an operation' do |_parameter|
  it { is_expected.to be_success }
  it { is_expected.to be_kind_of(described_class) }
  it { is_expected.to respond_to(:errors) }
end

RSpec.shared_examples 'an operation allowed for admin' do
  let(:admin) { create :admin }
  it { is_expected.to be_success }

  context 'when not an admin' do
    let(:admin) { double }

    it { expect { subject }.to raise_error(Operation::NotAuthorizedError) }
  end
end
