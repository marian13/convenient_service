# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Service::Plugins::CanHaveTryResult::Middleware do
  example_group "inheritance" do
    include ConvenientService::RSpec::Matchers::BeDescendantOf

    subject { described_class }

    it { is_expected.to be_descendant_of(ConvenientService::Core::MethodChainMiddleware) }
  end

  example_group "instance methods" do
    describe "#call" do
      include ConvenientService::RSpec::Helpers::WrapMethod

      include ConvenientService::RSpec::Matchers::CallChainNext
      include ConvenientService::RSpec::Matchers::DelegateTo
      include ConvenientService::RSpec::Matchers::Results

      subject(:method_value) { method.call }

      let(:method) { wrap_method(service_instance, :try_result, middlewares: described_class) }

      let(:service_class) do
        Class.new do
          include ConvenientService::Configs::Standard

          ##
          # TODO: Remove once `CanHaveTryResult` becomes included into `Standard` config.
          #
          concerns do
            use ConvenientService::Service::Plugins::CanHaveTryResult::Concern
          end

          middlewares :try_result do
            use ConvenientService::Service::Plugins::CanHaveTryResult::Middleware
          end

          def try_result
            success
          end
        end
      end

      let(:service_instance) { service_class.new }

      specify do
        expect { method_value }.to call_chain_next.on(method)
      end

      ##
      # TODO: `method.spy_middleware`.
      #
      # specify do
      #   expect { method_value }.to delegate_to(method.spy_middleware.commands, :is_result?)
      # end

      context "when `result` is NOT result" do
        let(:service_class) do
          Class.new do
            include ConvenientService::Configs::Standard

            ##
            # TODO: Remove once `CanHaveTryResult` becomes included into `Standard` config.
            #
            concerns do
              use ConvenientService::Service::Plugins::CanHaveTryResult::Concern
            end

            middlewares :try_result do
              use ConvenientService::Service::Plugins::CanHaveTryResult::Middleware
            end

            def try_result
              "string value"
            end
          end
        end

        let(:error_message) do
          <<~TEXT
            Return value of service `#{service_class}` try is NOT a `Result`.
            It is `String`.

            Did you forget to call `success` from the `try_result` method?
          TEXT
        end

        it "raises `ConvenientService::Service::Plugins::CanHaveTryResult::Errors::ServiceTryReturnValueNotKindOfResult`" do
          expect { method_value }
            .to raise_error(ConvenientService::Service::Plugins::CanHaveTryResult::Errors::ServiceTryReturnValueNotKindOfResult)
            .with_message(error_message)
        end
      end

      context "when `result` is result" do
        context "when `result` is NOT success" do
          let(:service_class) do
            Class.new do
              include ConvenientService::Configs::Standard

              ##
              # TODO: Remove once `CanHaveTryResult` becomes included into `Standard` config.
              #
              concerns do
                use ConvenientService::Service::Plugins::CanHaveTryResult::Concern
              end

              middlewares :try_result do
                use ConvenientService::Service::Plugins::CanHaveTryResult::Middleware
              end

              def try_result
                error
              end
            end
          end

          let(:error_message) do
            <<~TEXT
              Return value of service `#{service_class}` try is NOT a `success`.
              It is `error`.

              Did you accidentally call `failure` or `error` instead of `success` from the `try_result` method?
            TEXT
          end

          it "raises `ConvenientService::Service::Plugins::CanHaveTryResult::Errors::ServiceTryReturnValueNotSuccess`" do
            expect { method_value }
              .to raise_error(ConvenientService::Service::Plugins::CanHaveTryResult::Errors::ServiceTryReturnValueNotSuccess)
              .with_message(error_message)
          end
        end

        context "when `result` is success" do
          let(:service_class) do
            Class.new do
              include ConvenientService::Configs::Standard

              ##
              # TODO: Remove once `CanHaveTryResult` becomes included into `Standard` config.
              #
              concerns do
                use ConvenientService::Service::Plugins::CanHaveTryResult::Concern
              end

              middlewares :try_result do
                use ConvenientService::Service::Plugins::CanHaveTryResult::Middleware
              end

              def try_result
                success
              end
            end
          end

          it "returns original method value" do
            expect(method_value).to be_success.without_data
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
