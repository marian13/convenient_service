# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

return unless defined? ConvenientService::Service::Plugins::HasJSendResultParamsValidations::UsingDryValidation

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Service::Plugins::HasJSendResultParamsValidations::UsingDryValidation::Concern::ClassMethods do
  example_group "class methods" do
    describe ".contract" do
      include ConvenientService::RSpec::Matchers::BeDirectDescendantOf

      let(:service_class) do
        Class.new.tap do |klass|
          klass.class_exec(described_class) do |mod|
            extend mod
          end
        end
      end

      context "when `block` is NOT passed" do
        it "returns `Dry::Validation::Contract` direct descendant" do
          expect(service_class.contract).to be_direct_descendant_of(Dry::Validation::Contract)
        end
      end

      context "when `block` is passed" do
        it "returns `Dry::Validation::Contract` direct descendant" do
          expect(service_class.contract).to be_direct_descendant_of(Dry::Validation::Contract)
        end

        ##
        # RSpec/MessageSpies does NOT supports expectations for blocks.
        #
        # rubocop:disable RSpec/MessageSpies, RSpec/MultipleExpectations, RSpec/ExampleLength, RSpec/StubbedMock
        it "executes `block` in the context of `contract`" do
          block_with_rules = proc do
            ##
            # https://dry-rb.org/gems/dry-validation/1.8/#quick-start
            #
            params do
              required(:email).filled(:string)
              required(:age).value(:integer)
            end
          end

          ##
          # https://github.com/rspec/rspec-mocks/issues/1182#issuecomment-332087650
          #
          expect(service_class.contract).to receive(:class_exec) { |&block| expect(block).to eq(block_with_rules) }

          service_class.contract(&block_with_rules)
        end
        # rubocop:enable RSpec/MessageSpies, RSpec/MultipleExpectations, RSpec/ExampleLength, RSpec/StubbedMock
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
