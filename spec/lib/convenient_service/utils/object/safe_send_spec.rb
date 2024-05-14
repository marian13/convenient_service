# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

RSpec.describe ConvenientService::Utils::Object::SafeSend, type: :standard do
  describe ".call" do
    let(:result) { described_class.call(object, method, *args, **kwargs, &block) }

    let(:object) { klass.new }

    let(:method) { :foo }
    let(:args) { [:foo] }
    let(:kwargs) { {foo: :bar} }
    let(:block) { proc { :foo } }

    context "when `object` does NOT respond to `method`" do
      let(:klass) { Class.new }

      it "returns `nil`" do
        expect(result).to be_nil
      end
    end

    context "when `object` responds to `method`" do
      context "when `method` is public" do
        let(:klass) do
          Class.new do
            def foo(*args, **kwargs, &block)
              [__method__, args, kwargs, block]
            end
          end
        end

        it "returns original method value" do
          expect(result).to eq([method, args, kwargs, block])
        end
      end

      context "when `method` is public" do
        let(:klass) do
          Class.new do
            protected

            def foo(*args, **kwargs, &block)
              [__method__, args, kwargs, block]
            end
          end
        end

        it "returns original method value" do
          expect(result).to eq([method, args, kwargs, block])
        end
      end

      context "when `method` is public" do
        let(:klass) do
          Class.new do
            private

            def foo(*args, **kwargs, &block)
              [__method__, args, kwargs, block]
            end
          end
        end

        it "returns original method value" do
          expect(result).to eq([method, args, kwargs, block])
        end
      end
    end
  end
end
