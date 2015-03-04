require 'spec_helper'

RSpec.describe LazyObject do

  class TargetObject
    attr_accessor :value

    def method_with_yield(foo)
      yield foo
    end
  end

  let(:lazy_object) {
    LazyObject.new do
      targ = TargetObject.new
      targ.value = :foo
      targ
    end
  }

  it 'should call the init block and forward methods to the target object' do
    expect( lazy_object.value ).to eq(:foo)
    lazy_object.value = :bar
    expect( lazy_object.value ).to eq(:bar)

    expect( lazy_object.method_with_yield(:baz) { |foo| "--#{foo}--" } ).to eq('--baz--')
  end

end
