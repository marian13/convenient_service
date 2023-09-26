# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::RSpec::Matchers::Classes::Results::Base::Entities::Printers do
  include ConvenientService::RSpec::Matchers::DelegateTo
  include ConvenientService::RSpec::Matchers::Results

  let(:result) { service.result }

  example_group "class methods" do
    describe "#create" do
      context "when matcher does NOT have result" do
        let(:matcher) { be_success }

        specify do
          expect { described_class.create(matcher: matcher) }
            .to delegate_to(ConvenientService::RSpec::Matchers::Classes::Results::Base::Entities::Printers::Null, :new)
            .with_arguments(matcher: matcher)
            .and_return_its_value
        end
      end

      context "when matcher has result" do
        context "when matcher has result with success status" do
          let(:matcher) { be_success.tap { |matcher| matcher.matches?(result) } }

          let(:service) do
            Class.new do
              include ConvenientService::Service::Configs::Standard

              def result
                success
              end
            end
          end

          specify do
            expect { described_class.create(matcher: matcher) }
              .to delegate_to(ConvenientService::RSpec::Matchers::Classes::Results::Base::Entities::Printers::Success, :new)
              .with_arguments(matcher: matcher)
              .and_return_its_value
          end
        end

        context "when matcher has result with failure status" do
          let(:matcher) { be_failure.tap { |matcher| matcher.matches?(result) } }

          let(:service) do
            Class.new do
              include ConvenientService::Service::Configs::Standard

              def result
                failure
              end
            end
          end

          specify do
            expect { described_class.create(matcher: matcher) }
              .to delegate_to(ConvenientService::RSpec::Matchers::Classes::Results::Base::Entities::Printers::Failure, :new)
              .with_arguments(matcher: matcher)
              .and_return_its_value
          end
        end

        context "when matcher has result with error status" do
          let(:matcher) { be_error.tap { |matcher| matcher.matches?(result) } }

          let(:service) do
            Class.new do
              include ConvenientService::Service::Configs::Standard

              def result
                error
              end
            end
          end

          specify do
            expect { described_class.create(matcher: matcher) }
              .to delegate_to(ConvenientService::RSpec::Matchers::Classes::Results::Base::Entities::Printers::Error, :new)
              .with_arguments(matcher: matcher)
              .and_return_its_value
          end
        end

        context "when matcher has result with unknown status" do
          let(:matcher) { be_error.tap { |matcher| matcher.matches?(result) } }

          let(:service) do
            Class.new do
              include ConvenientService::Service::Configs::Standard

              def result
                success.copy(overrides: {kwargs: {status: :unknown}})
              end
            end
          end

          specify do
            expect { described_class.create(matcher: matcher) }
              .to delegate_to(ConvenientService::RSpec::Matchers::Classes::Results::Base::Entities::Printers::Null, :new)
              .with_arguments(matcher: matcher)
              .and_return_its_value
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
