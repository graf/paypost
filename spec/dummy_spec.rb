# frozen_string_literal: true

require 'rails_helper'

describe 'RSpec' do
  let(:text) { 'Hello World!' }

  it('works') { expect(text).to eq('Hello World!') }
end
