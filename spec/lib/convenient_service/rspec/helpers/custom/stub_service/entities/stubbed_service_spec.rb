# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# frozen_string_literal: true

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::RSpec::Helpers::Custom::StubService::Entities::StubbedService do
  include ConvenientService::RSpec::Helpers::StubService

  include ConvenientService::RSpec::Matchers::DelegateTo
  include ConvenientService::RSpec::Matchers::Results

  subject(:helper) { described_class.new(service_class: service_class) }

  let(:service_class) do
    Class.new do
      include ConvenientService::Service::Configs::Standard

      def result
        success
      end
    end
  end

  let(:args) { [:foo] }
  let(:kwargs) { {foo: :bar} }
  let(:block) { proc { :foo } }

  let(:result_spec) { ConvenientService::RSpec::Helpers::Custom::StubService::Entities::ResultSpec.new(status: :success) }
  let(:result_value) { result_spec.for(service_class).calculate_value }

  example_group "instance methods" do
    describe "#with_arguments" do
      it "returns self" do
        expect(helper.with_arguments(*args, **kwargs, &block)).to eq(helper)
      end

      context "when method is NOT called with arguments" do
        it "does NOT modify method to return stub" do
          stub_service(service_class).with_arguments(*args, **kwargs, &block).to return_error.with_code(:with_arguments)

          expect(service_class.result).to be_success
        end
      end

      context "when method is called with arguments" do
        it "modifies method to return stub" do
          stub_service(service_class).with_arguments(*args, **kwargs, &block).to return_error.with_code(:with_arguments)

          expect(service_class.result(*args, **kwargs, &block)).to be_error.with_code(:with_arguments)
        end
      end
    end

    describe "#without_arguments" do
      it "returns self" do
        expect(helper.without_arguments).to eq(helper)
      end

      context "when method is NOT called without arguments" do
        it "modifies method to return stub" do
          stub_service(service_class).without_arguments.to return_error.with_code(:with_arguments)

          expect(service_class.result(*args, **kwargs, &block)).to be_error.with_code(:with_arguments)
        end
      end

      context "when method is called without arguments" do
        it "modifies method to return stub" do
          stub_service(service_class).without_arguments.to return_error.with_code(:with_arguments)

          expect(service_class.result).to be_error.with_code(:with_arguments)
        end
      end
    end

    describe "#to" do
      let(:key) { service_class.stubbed_results.keygen }

      it "returns `self`" do
        expect(helper.to(result_spec)).to eq(helper)
      end

      specify do
        expect { helper.to(result_spec) }
          .to delegate_to(service_class, :commit_config!)
          .with_arguments(trigger: ConvenientService::RSpec::Helpers::Custom::StubService::Constants::Triggers::STUB_SERVICE)
      end

      specify do
        expect { helper.to(result_spec) }
          .to delegate_to(ConvenientService::Service::Plugins::CanHaveStubbedResults::Commands::SetServiceStubbedResult, :call)
          .with_arguments(service: service_class, arguments: ConvenientService::Support::Arguments.null_arguments, result: result_value)
      end

      context "when used with `with_arguments`" do
        let(:key) { service_class.stubbed_results.keygen(*args, **kwargs, &block) }

        specify do
          expect { helper.with_arguments(*args, **kwargs, &block).to(result_spec) }
            .to delegate_to(ConvenientService::Service::Plugins::CanHaveStubbedResults::Commands::SetServiceStubbedResult, :call)
            .with_arguments(service: service_class, arguments: ConvenientService::Support::Arguments.new(*args, **kwargs, &block), result: result_value)
        end
      end

      context "when used with `without_arguments`" do
        let(:key) { service_class.stubbed_results.keygen(*args, **kwargs, &block) }

        specify do
          expect { helper.without_arguments.to(result_spec) }
            .to delegate_to(ConvenientService::Service::Plugins::CanHaveStubbedResults::Commands::SetServiceStubbedResult, :call)
            .with_arguments(service: service_class, arguments: ConvenientService::Support::Arguments.null_arguments, result: result_value)
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
