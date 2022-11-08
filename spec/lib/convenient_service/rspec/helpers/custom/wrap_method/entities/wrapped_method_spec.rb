# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# frozen_string_literal: true

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::RSpec::Helpers::Custom::WrapMethod::Entities::WrappedMethod do
  subject(:method) { described_class.new(entity: entity, method: method_name, middlewares: middlewares) }

  let(:service_class) do
    Class.new do
      def result
        :original_result_value
      end
    end
  end

  let(:service_instance) { service_class.new }

  let(:entity) { service_instance }
  let(:method_name) { :result }
  let(:middlewares) { [] }

  example_group "instance methods" do
    describe "#chain_called?" do
      context "when chain is NOT called" do
        it "returns `false`" do
          expect(method.chain_called?).to eq(false)
        end
      end

      context "when chain is called" do
        before do
          method.call
        end

        it "returns `true`" do
          expect(method.chain_called?).to eq(true)
        end
      end
    end

    ##
    # TODO: Specs.
    #
  end
end
# rubocop:enable RSpec/NestedGroups
