# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::RSpec::PrimitiveMatchers::Classes::DelegateTo::Entities::SubMatchers::Arguments::Commands::GeneratePrintableArguments, type: :standard do
  example_group "class methods" do
    describe ".call" do
      let(:command_result) { described_class.call(arguments: arguments) }

      let(:arguments) { ConvenientService::Support::Arguments.new(*args, **kwargs, &block) }

      let(:args) { [] }
      let(:kwargs) { {} }
      let(:block) { nil }

      context "when args, kwargs and block are NOT passed" do
        let(:args) { [] }
        let(:kwargs) { {} }
        let(:block) { nil }

        it "returns printable arguments without args, kwargs and block" do
          expect(command_result).to eq("()")
        end
      end

      context "when args are passed, kwargs and block are NOT passed" do
        let(:args) { [:foo] }
        let(:kwargs) { {} }
        let(:block) { nil }

        it "returns printable arguments with args, without kwargs and block" do
          expect(command_result).to eq("(:foo)")
        end
      end

      context "when kwargs are passed, args and block are NOT passed" do
        let(:args) { [] }
        let(:kwargs) { {foo: :bar} }
        let(:block) { nil }

        it "returns printable arguments with kwargs, without args and block" do
          expect(command_result).to eq("(foo: :bar)")
        end
      end

      context "when block is passed, args and kwargs are NOT passed" do
        let(:args) { [] }
        let(:kwargs) { {} }
        let(:block) { proc { :foo } }

        it "returns printable arguments with block, without args and kwargs" do
          expect(command_result).to eq("() { ... }")
        end
      end

      context "when args and kwargs are passed, block is NOT passed" do
        let(:args) { [:foo] }
        let(:kwargs) { {foo: :bar} }
        let(:block) { nil }

        it "returns printable arguments with args and kwargs, without block" do
          expect(command_result).to eq("(:foo, foo: :bar)")
        end
      end

      context "when args and block are passed, kwargs are NOT passed" do
        let(:args) { [:foo] }
        let(:kwargs) { {} }
        let(:block) { proc { :foo } }

        it "returns printable arguments with args and block, without kwargs" do
          expect(command_result).to eq("(:foo) { ... }")
        end
      end

      context "when kwargs and block are passed, args are NOT passed" do
        let(:args) { [] }
        let(:kwargs) { {foo: :bar} }
        let(:block) { proc { :foo } }

        it "returns printable arguments with kwargs and block, without args" do
          expect(command_result).to eq("(foo: :bar) { ... }")
        end
      end

      context "when args, kwargs and block are passed" do
        let(:args) { [:foo] }
        let(:kwargs) { {foo: :bar} }
        let(:block) { proc { :foo } }

        it "returns printable arguments with args, kwargs and block" do
          expect(command_result).to eq("(:foo, foo: :bar) { ... }")
        end
      end

      context "when multiple args are passed" do
        let(:args) { [:foo, :bar] }

        it "concats them by comma" do
          expect(command_result).to eq("(:foo, :bar)")
        end
      end

      context "when multiple kwargs are passed" do
        let(:kwargs) { {foo: :bar, baz: :qux} }

        it "concats them by comma" do
          expect(command_result).to eq("(foo: :bar, baz: :qux)")
        end
      end

      context "when args are complex objects" do
        let(:args) { [object] }
        let(:object) { /abc/ }

        it "uses `inspect` to print them" do
          expect(command_result).to eq("(#{object.inspect})")
        end
      end

      context "when kwargs are complex objects" do
        let(:kwargs) { {foo: object} }
        let(:object) { /abc/ }

        it "uses `inspect` to print them" do
          expect(command_result).to eq("(foo: #{object.inspect})")
        end
      end

      context "when arguments are null arguments" do
        let(:arguments) { ConvenientService::Support::Arguments.null_arguments }

        it "returns empty string" do
          expect(command_result).to eq("")
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
