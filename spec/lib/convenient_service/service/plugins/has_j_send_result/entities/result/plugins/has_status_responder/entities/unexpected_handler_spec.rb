# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasStatusResponder::Entities::UnexpectedHandler, type: :standard do
  include ConvenientService::RSpec::Matchers::DelegateTo
  include ConvenientService::RSpec::PrimitiveMatchers::CacheItsValue

  let(:handler) { described_class.new(block: block) }

  let(:block) { proc { block_value } }
  let(:block_value) { "block value" }

  example_group "instance methods" do
    example_group "attributes" do
      include ConvenientService::RSpec::PrimitiveMatchers::HaveAttrReader

      subject { handler }

      it { is_expected.to have_attr_reader(:block) }
    end

    describe "#handle" do
      specify do
        expect { handler.handle }
          .to delegate_to(block, :call)
          .with_arguments(ConvenientService::Support::Arguments.null_arguments)
          .and_return_its_value
      end
    end

    example_group "comparison" do
      describe "#==" do
        let(:handler) { described_class.new(block: block) }

        context "when `other` has different class" do
          let(:other) { 42 }

          it "returns `nil`" do
            expect(handler == other).to be_nil
          end
        end

        context "when `other` has different `block`" do
          let(:other) { described_class.new(block: proc {}) }

          it "returns `false`" do
            expect(handler == other).to eq(false)
          end
        end

        context "when `other` has same attributes" do
          let(:other) { described_class.new(block: block) }

          it "returns `true`" do
            expect(handler == other).to eq(true)
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
