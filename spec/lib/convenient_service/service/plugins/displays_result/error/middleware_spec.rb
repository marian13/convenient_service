# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Service::Plugins::DisplaysResult::Error::Middleware do
  example_group "inheritance" do
    include ConvenientService::RSpec::Matchers::BeDescendantOf

    subject { described_class }

    it { is_expected.to be_descendant_of(ConvenientService::Core::MethodChainMiddleware) }
  end

  example_group "instance methods" do
    describe "#call" do
      include ConvenientService::RSpec::Helpers::WrapMethod
      include ConvenientService::RSpec::Matchers::CallChainNext

      subject(:method_value) { method.call(**kwargs) }
      let(:kwargs) { {message: "An error message"} }

      let(:method) { wrap_method(service_instance, :error, middlewares: described_class) }

      let(:service_class) do
        Class.new do
          include ConvenientService::Service::Plugins::HasResult::Concern

          def initialize(display:)
            @display = display
          end
        end
      end

      let(:service_instance) { service_class.new(display: true) }

      context "when entity has display instance variable" do
        context "when its value is true" do
          it "prints result" do
            expect { method_value }.to output("\e[31;1m#{kwargs[:message]}\e[0m\n").to_stdout
          end

          it "returns error result" do
            expect(method_value).to be_error
          end
        end

        context "when its value is false" do
          let(:service_instance) { service_class.new(display: false) }

          it "does NOT print result" do
            expect { method_value }.not_to output("\e[31;1m#{kwargs[:message]}\e[0m\n").to_stdout
          end

          it "returns error result" do
            expect(method_value).to be_error
          end
        end

        context "when there is NO display argument at all" do
          let(:service_class) do
            Class.new do
              include ConvenientService::Service::Plugins::HasResult::Concern
            end
          end

          let(:service_instance) { service_class.new }

          it "does NOT print result" do
            expect { method_value }.not_to output("\e[31;1m#{kwargs[:message]}\e[0m\n").to_stdout
          end

          it "returns error result" do
            expect(method_value).to be_error
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
