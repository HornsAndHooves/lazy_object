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

    def method_with_kwargs_and_block(**kwargs, &block)
      block.call **kwargs
    end

    def method_with_kwargs_and_yield(**kwargs)
      yield **kwargs
    end
  end

  let(:lazy_object) {
    LazyObject.new do
      targ       = TargetObject.new
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
      expect(target_method).to eq({ foo: "bar" })
    end
  end

  context "when target object uses kwargs and a block" do
    let(:lazy_object) { LazyObject.new { TargetObject.new } }

    it "will delegate the call to the block" do
      result = lazy_object.method_with_kwargs_and_block(foo: "bar") { |foo:| { bar: foo.reverse } }

      expect(result).to eq({ bar: "rab" })
    end
  end

  context "when target object uses kwargs and an implicit block" do
    let(:lazy_object) { LazyObject.new { TargetObject.new } }

    it "will delegate the call to the block" do
      result = lazy_object.method_with_kwargs_and_yield(foo: "bar") { |foo:| { bar: foo.reverse } }

      expect(result).to eq({ bar: "rab" })
    end
  end

  context "when target object evaluates to a falsy value" do
    let(:lazy_object) { LazyObject.new { TargetObject.new } }

    it "evaluates the block exactly once for false" do
      TargetObject.should_receive(:new).once.and_return(false)
      3.times do
        expect(lazy_object).to eq(false)
      end
    end

    it "evaluates the block exactly once for nil" do
      TargetObject.should_receive(:new).once.and_return(nil)
      3.times do
        expect(lazy_object).to eq(nil)
      end
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
