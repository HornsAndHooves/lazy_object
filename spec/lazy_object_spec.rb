require 'spec_helper'

RSpec.describe LazyObject do

  class TargetObject
    attr_accessor :value

    def method_with_yield(foo)
      yield foo
    end

    def method_with_kwargs(**kwargs)
      kwargs
    end
  end

  let(:lazy_object) {
    LazyObject.new do
      targ = TargetObject.new
      targ.value = :foo
      targ
    end
  }

  it "should call the init block and forward methods to the target object" do
    expect(lazy_object.value).to eq(:foo)
    lazy_object.value = :bar
    expect(lazy_object.value).to eq(:bar)

    expect(
      lazy_object.method_with_yield(:baz) { |foo| "--#{foo}--" }
    ).to eq("--baz--")
  end

  context "when target object methods use keyword arguments" do
    subject(:target_method) { lazy_object.method_with_kwargs(foo: "bar") }
    let(:lazy_object) { LazyObject.new { TargetObject.new } }

    it "should not raise an exception and properly delegate to the target object" do
      expect { target_method }.not_to raise_exception
      expect(target_method).to eq({foo: "bar"})
    end
  end

  context "equality operators" do
    it "should return correct value when comparing" do
      one = LazyObject.new { 1 }
      expect(one).to eq(1)
    end

    specify "==" do
      foo = LazyObject.new { :foo }
      expect(foo == :foo).to eq(true)
    end

    specify "!=" do
      foo = LazyObject.new { :foo }
      expect(foo != :foo).to eq(false)
    end

    specify "!" do
      foo = LazyObject.new { :foo }
      expect(!foo).to eq(false)
    end
  end
end
