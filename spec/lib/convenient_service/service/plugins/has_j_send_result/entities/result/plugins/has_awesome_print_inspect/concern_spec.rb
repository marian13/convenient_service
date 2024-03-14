# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasAwesomePrintInspect::Concern do
  example_group "modules" do
    include ConvenientService::RSpec::Matchers::IncludeModule

    subject { described_class }

    it { is_expected.to include_module(ConvenientService::Support::Concern) }

    context "when included" do
      subject { result_class }

      let(:result_class) do
        Class.new.tap do |klass|
          klass.class_exec(described_class) do |mod|
            include mod
          end
        end
      end

      it { is_expected.to include_module(described_class::InstanceMethods) }
    end
  end

  example_group "instance methods" do
    include ConvenientService::RSpec::Matchers::DelegateTo

    describe "#inspect" do
      let(:service) do
        Class.new do
          include ConvenientService::Service::Configs::Essential

          include ConvenientService::Service::Configs::AwesomePrintInspect

          def self.name
            "ImportantService"
          end

          def result
            success
          end
        end
      end

      let(:result) { service.result }

      let(:keywords) { ["ConvenientService", "entity", "Result", "service", "ImportantService", "status", ":success"] }

      it "returns `inspect` representation of result" do
        expect(result.inspect).to include(*keywords)
      end

      specify do
        allow(result.service).to receive(:inspect_values).and_return({})

        expect { result.inspect }
          .to delegate_to(result.service.inspect_values, :[])
          .with_arguments(:name)
      end

      context "when result has data" do
        let(:service) do
          Class.new do
            include ConvenientService::Service::Configs::Essential

            include ConvenientService::Service::Configs::AwesomePrintInspect

            def self.name
              "ImportantService"
            end

            def result
              success(data: {foo: :bar})
            end
          end
        end

        let(:keywords) { ["ConvenientService", "entity", "Result", "service", "ImportantService", "status", ":success", "data_keys", "foo"] }

        it "includes data keys into `inspect` representation of result" do
          expect(result.inspect).to include(*keywords)
        end

        context "when data has multiple keys" do
          let(:service) do
            Class.new do
              include ConvenientService::Service::Configs::Essential

              include ConvenientService::Service::Configs::AwesomePrintInspect

              def self.name
                "ImportantService"
              end

              def result
                success(data: {foo: :bar, baz: :qux, quux: :quuz})
              end
            end
          end

          let(:keywords) { ["ConvenientService", "entity", "Result", "service", "ImportantService", "status", ":success", "data_keys", "foo", "baz", "quux"] }

          it "delegates to `data.keys.inspect`" do
            expect(result.inspect).to include(*keywords)
          end
        end
      end

      context "when result has message" do
        let(:service) do
          Class.new do
            include ConvenientService::Service::Configs::Essential

            include ConvenientService::Service::Configs::AwesomePrintInspect

            def self.name
              "ImportantService"
            end

            def result
              error(message: "foo")
            end
          end
        end

        let(:keywords) { ["ConvenientService", "entity", "Result", "service", "ImportantService", "status", ":error", "message", "foo"] }

        it "includes message into `inspect` representation of result" do
          expect(result.inspect).to include(*keywords)
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
