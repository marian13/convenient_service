# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Support::SafeMethod do
  let(:safe_method) { described_class.new(object, method) }

  let(:args) { [:foo] }
  let(:kwargs) { {foo: :bar} }
  let(:block) { proc { :foo } }

  let(:method) { :foo }

  let(:default) { ConvenientService::Support::UNDEFINED }

  example_group "instance methods" do
    describe "#call" do
      context "when `object` is instance" do
        let(:object) { klass.new }

        context "when `method` is NOT defined" do
          let(:klass) { Class.new }

          context "when `default` is NOT passed" do
            let(:safe_method) { described_class.new(object, method) }

            it "returns `nil`" do
              expect(safe_method.call(*args, **kwargs, &block)).to be_nil
            end
          end

          context "when `default` is passed" do
            let(:safe_method) { described_class.new(object, method, default: default) }

            it "returns `default`" do
              expect(safe_method.call(*args, **kwargs, &block)).to eq(default)
            end
          end
        end

        context "when `method` is defined" do
          context "when `method` is public" do
            let(:klass) do
              Class.new do
                public

                def foo(*args, **kwargs, &block)
                  [__method__, args, kwargs, block]
                end
              end
            end

            it "returns `object.__send__(method, *args, **kwargs, &block)`" do
              expect(safe_method.call(*args, **kwargs, &block)).to eq([method, args, kwargs, block])
            end
          end

          context "when `method` is protected" do
            let(:klass) do
              Class.new do
                protected

                def foo(*args, **kwargs, &block)
                  [__method__, args, kwargs, block]
                end
              end
            end

            it "returns `object.__send__(method, *args, **kwargs, &block)`" do
              expect(safe_method.call(*args, **kwargs, &block)).to eq([method, args, kwargs, block])
            end
          end

          context "when `method` is private" do
            let(:klass) do
              Class.new do
                private

                def foo(*args, **kwargs, &block)
                  [__method__, args, kwargs, block]
                end
              end
            end

            it "returns `object.__send__(method, *args, **kwargs, &block)`" do
              expect(safe_method.call(*args, **kwargs, &block)).to eq([method, args, kwargs, block])
            end
          end
        end
      end

      context "when object is class" do
        let(:object) { klass }

        context "when `method` is NOT defined" do
          let(:klass) { Class.new }

          context "when `default` is NOT passed" do
            let(:safe_method) { described_class.new(object, method) }

            it "returns `nil`" do
              expect(safe_method.call(*args, **kwargs, &block)).to be_nil
            end
          end

          context "when `default` is passed" do
            let(:safe_method) { described_class.new(object, method, default: default) }

            it "returns `default`" do
              expect(safe_method.call(*args, **kwargs, &block)).to eq(default)
            end
          end
        end

        context "when `method` is defined" do
          context "when `method` is public" do
            let(:klass) do
              Class.new do
                class << self
                  public

                  def foo(*args, **kwargs, &block)
                    [__method__, args, kwargs, block]
                  end
                end
              end
            end

            it "returns `object.__send__(method, *args, **kwargs, &block)`" do
              expect(safe_method.call(*args, **kwargs, &block)).to eq([method, args, kwargs, block])
            end
          end

          context "when `method` is protected" do
            let(:klass) do
              Class.new do
                class << self
                  protected

                  def foo(*args, **kwargs, &block)
                    [__method__, args, kwargs, block]
                  end
                end
              end
            end

            it "returns `object.__send__(method, *args, **kwargs, &block)`" do
              expect(safe_method.call(*args, **kwargs, &block)).to eq([method, args, kwargs, block])
            end
          end

          context "when `method` is private" do
            let(:klass) do
              Class.new do
                class << self
                  private

                  def foo(*args, **kwargs, &block)
                    [__method__, args, kwargs, block]
                  end
                end
              end
            end

            it "returns `object.__send__(method, *args, **kwargs, &block)`" do
              expect(safe_method.call(*args, **kwargs, &block)).to eq([method, args, kwargs, block])
            end
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
