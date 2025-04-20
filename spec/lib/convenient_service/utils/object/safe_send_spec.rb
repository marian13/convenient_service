# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Utils::Object::SafeSend, type: :standard do
  describe ".call" do
    let(:util_result) { described_class.call(object, method, *args, **kwargs, &block) }

    let(:object) { klass.new }

    let(:method) { :foo }
    let(:args) { [:foo] }
    let(:kwargs) { {foo: :bar} }
    let(:block) { proc { :foo } }

    context "when `object` does NOT respond to `method`" do
      let(:klass) { Class.new }

      it "returns `nil`" do
        expect(util_result).to be_nil
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
          expect(util_result).to eq([method, args, kwargs, block])
        end

        context "when `method` raises exception" do
          let(:klass) do
            Class.new do
              def foo(*args, **kwargs, &block)
                raise ArgumentError
              end
            end
          end

          it "returns `nil`" do
            expect(util_result).to be_nil
          end
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

        it "returns original method value" do
          expect(util_result).to eq([method, args, kwargs, block])
        end

        context "when `method` raises exception" do
          let(:klass) do
            Class.new do
              protected

              def foo(*args, **kwargs, &block)
                raise ArgumentError
              end
            end
          end

          it "returns `nil`" do
            expect(util_result).to be_nil
          end
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

        it "returns original method value" do
          expect(util_result).to eq([method, args, kwargs, block])
        end

        context "when `method` raises exception" do
          let(:klass) do
            Class.new do
              private

              def foo(*args, **kwargs, &block)
                raise ArgumentError
              end
            end
          end

          it "returns `nil`" do
            expect(util_result).to be_nil
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
