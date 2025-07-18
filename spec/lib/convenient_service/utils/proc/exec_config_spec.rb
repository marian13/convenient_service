# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Utils::Proc::ExecConfig, type: :standard do
  describe ".call" do
    let(:klass) do
      Class.new do
        attr_reader :method_from_object_context

        def initialize(method_from_object_context:)
          @method_from_object_context = method_from_object_context
        end
      end
    end

    let(:object) { klass.new(method_from_object_context: method_from_object_context_value) }

    let(:method_from_enclosing_context) { method_from_enclosing_context_value }

    let(:method_from_object_context_value) { :foo }
    let(:method_from_enclosing_context_value) { :bar }

    context "when `block` is proc" do
      context "when `block` does NOT have only one argument" do
        let(:block) { proc { method_from_object_context } }

        it "evaluates `block` in `object` context" do
          ##
          # If no error is raised, then `method_from_object_context` was called from object (it is NOT defined in the enclosing context).
          #
          expect { described_class.call(block, object) }.not_to raise_error
        end

        it "returns block value" do
          expect(described_class.call(block, object)).to eq(method_from_object_context_value)
        end
      end

      context "when `block` has only one argument" do
        context "when `block` has only one positional argument" do
          context "when that one positional argument is required" do
            let(:block) { proc { |foo| method_from_enclosing_context } }

            it "evaluates `block` in enclosing context" do
              ##
              # If no error is raised, then `method_from_enclosing_context` was called from enclosing context (it is NOT defined in the `object` context).
              #
              expect { described_class.call(block, object) }.not_to raise_error
            end

            it "returns block value" do
              expect(described_class.call(block, object)).to eq(method_from_enclosing_context_value)
            end
          end

          context "when that one positional argument is optional" do
            let(:block) { proc { |foo = nil| method_from_enclosing_context } }

            it "evaluates `block` in enclosing context" do
              ##
              # If no error is raised, then `method_from_enclosing_context` was called from enclosing context (it is NOT defined in the `object` context).
              #
              expect { described_class.call(block, object) }.not_to raise_error
            end

            it "returns block value" do
              expect(described_class.call(block, object)).to eq(method_from_enclosing_context_value)
            end
          end
        end

        context "when `block` has only one keyword argument" do
          context "when that one keyword argument is required" do
            let(:block) { proc { |foo:| method_from_enclosing_context } }

            it "raises `ArgumentError`" do
              expect { described_class.call(block, object) }.to raise_error(ArgumentError).with_message(/missing keyword: :?foo/)
            end
          end

          context "when that one keyword argument is optional" do
            let(:block) { proc { |foo: nil| method_from_object_context } }

            it "evaluates `block` in enclosing context" do
              ##
              # If no error is raised, then `method_from_object_context` was called from enclosing context (it is NOT defined in the `object` context).
              #
              expect { described_class.call(block, object) }.not_to raise_error
            end

            it "returns block value" do
              expect(described_class.call(block, object)).to eq(method_from_object_context_value)
            end
          end
        end
      end
    end

    context "when `block` is lambda" do
      context "when `block` does NOT have only one argument" do
        let(:block) { -> { method_from_object_context } }

        it "evaluates `block` in `object` context" do
          ##
          # If no error is raised, then `method_from_object_context` was called from object (it is NOT defined in the enclosing context).
          #
          expect { described_class.call(block, object) }.not_to raise_error
        end

        it "returns block value" do
          expect(described_class.call(block, object)).to eq(method_from_object_context_value)
        end
      end

      context "when `block` has only one argument" do
        context "when `block` has only one positional argument" do
          context "when that one positional argument is required" do
            let(:block) { ->(foo) { method_from_enclosing_context } }

            it "evaluates `block` in enclosing context" do
              ##
              # If no error is raised, then `method_from_enclosing_context` was called from enclosing context (it is NOT defined in the `object` context).
              #
              expect { described_class.call(block, object) }.not_to raise_error
            end

            it "returns block value" do
              expect(described_class.call(block, object)).to eq(method_from_enclosing_context_value)
            end
          end

          context "when that one positional argument is optional" do
            let(:block) { ->(foo = nil) { method_from_enclosing_context } }

            it "evaluates `block` in enclosing context" do
              ##
              # If no error is raised, then `method_from_enclosing_context` was called from enclosing context (it is NOT defined in the `object` context).
              #
              expect { described_class.call(block, object) }.not_to raise_error
            end

            it "returns block value" do
              expect(described_class.call(block, object)).to eq(method_from_enclosing_context_value)
            end
          end
        end

        context "when `block` has only one keyword argument" do
          context "when that one keyword is required" do
            let(:block) { ->(foo:) { method_from_enclosing_context } }

            it "raises `ArgumentError`" do
              expect { described_class.call(block, object) }.to raise_error(ArgumentError).with_message(/missing keyword: :?foo/)
            end
          end

          context "when that one keyword argument is optional" do
            let(:block) { ->(foo: nil) { method_from_object_context } }

            it "evaluates `block` in enclosing context" do
              ##
              # If no error is raised, then `method_from_object_context` was called from enclosing context (it is NOT defined in the `object` context).
              #
              expect { described_class.call(block, object) }.not_to raise_error
            end

            it "returns block value" do
              expect(described_class.call(block, object)).to eq(method_from_object_context_value)
            end
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
