require 'spec_helper'

describe Coercer::Object, '.to_integer' do
  subject { object.to_integer(value) }

  let(:object) { described_class.new }
  let(:value)  { stub('value')   }

  context 'when the value responds to #to_int' do
    let(:coerced) { stub('coerced') }

    before do
      value.should_receive(:to_int).with().and_return(coerced)
    end

    it { should be(coerced) }
  end

  context 'when the value does not respond to #to_int' do
    specify { expect { subject }.to raise_error(UnsupportedCoercion) }
  end
end
