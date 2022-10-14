# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Utils::Proc::ExecConfig do
  describe ".exec_config" do
    let(:object) { OpenStruct.new(method_from_object_context: method_from_object_context_value) }
    let(:method_from_enclosing_context) { method_from_enclosing_context_value }

    let(:method_from_object_context_value) { :foo }
    let(:method_from_enclosing_context_value) { :bar }

    context "when `block` is proc" do
      context "when `block` does NOT have only one positional argument" do
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

      context "when `block` has only one positional argument" do
        context "when that one positional argument is required" do
          let(:block) { proc { |a| method_from_enclosing_context } }

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
          let(:block) { proc { |a = 0| method_from_enclosing_context } }

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
    end

    context "when `block` is lambda" do
      context "when `block` does NOT have only one positional argument" do
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

      context "when `block` has only one positional argument" do
        context "when that one positional argument is required" do
          let(:block) { ->(a) { method_from_enclosing_context } }

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
          let(:block) { ->(a = 0) { method_from_enclosing_context } }

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
    end
  end
end
# rubocop:enable RSpec/NestedGroups
