# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Service::Plugins::HasResultSteps::Entities::Method::Entities::Callers::Reassignment do
  include ConvenientService::RSpec::Matchers::DelegateTo

  let(:caller) { described_class.new(object) }
  let(:object) { +"foo" }
  let(:name) { +"foo" }

  example_group "instance methods" do
    describe "#reassignment?" do
      specify { expect { caller.reassignment?(name) }.to delegate_to(object, :to_sym) }
      specify { expect { caller.reassignment?(name) }.to delegate_to(name, :to_sym) }

      context "when object casted to symbol is NOT the same as name casted to symbol" do
        let(:name) { "bar" }

        it "returns `false`" do
          expect(caller.reassignment?(name)).to eq(false)
        end
      end

      context "when object casted to symbol is the same as name casted to symbol" do
        let(:name) { "foo" }

        it "returns `true`" do
          expect(caller.reassignment?(name)).to eq(true)
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
