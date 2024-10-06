# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

return unless defined? ConvenientService::AmazingPrintInspect::Config

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasAmazingPrintInspect::Concern, type: :amazing_print do
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
          include ConvenientService::Standard::Config
          include ConvenientService::Service::Configs::AmazingPrintInspect

          def self.name
            "ImportantService"
          end

          def result
            success
          end
        end
      end

      let(:result) { service.result }

      let(:keywords) { ["ConvenientService", ":entity", "Result", ":service", "ImportantService", ":status", ":success"] }

      it "returns `inspect` representation of result" do
        expect(result.inspect).to include(*keywords)
      end

      context "when result has data" do
        let(:service) do
          Class.new do
            include ConvenientService::Standard::Config
            include ConvenientService::Service::Configs::AmazingPrintInspect

            def self.name
              "ImportantService"
            end

            def result
              success(data: {foo: :bar})
            end
          end
        end

        let(:keywords) { ["ConvenientService", ":entity", "Result", ":service", "ImportantService", ":status", ":success", ":data_keys", "foo"] }

        it "includes data keys into `inspect` representation of result" do
          expect(result.inspect).to include(*keywords)
        end

        context "when data has multiple keys" do
          let(:service) do
            Class.new do
              include ConvenientService::Standard::Config
              include ConvenientService::Service::Configs::AmazingPrintInspect

              def self.name
                "ImportantService"
              end

              def result
                success(data: {foo: :bar, baz: :qux, quux: :quuz})
              end
            end
          end

          let(:keywords) { ["ConvenientService", ":entity", "Result", ":service", "ImportantService", ":status", ":success", ":data_keys", "foo", "baz", "quux"] }

          it "delegates to `data.keys.inspect`" do
            expect(result.inspect).to include(*keywords)
          end
        end
      end

      context "when result has message" do
        let(:service) do
          Class.new do
            include ConvenientService::Standard::Config
            include ConvenientService::Service::Configs::AmazingPrintInspect

            def self.name
              "ImportantService"
            end

            def result
              error(message: "foo")
            end
          end
        end

        let(:keywords) { ["ConvenientService", ":entity", "Result", ":service", "ImportantService", ":status", ":error", ":message", "foo"] }

        it "includes message into `inspect` representation of result" do
          expect(result.inspect).to include(*keywords)
        end
      end

      context "when service class is anonymous" do
        let(:service) do
          Class.new do
            include ConvenientService::Standard::Config
            include ConvenientService::Service::Configs::AmazingPrintInspect

            def result
              success
            end
          end
        end

        let(:keywords) { ["ConvenientService", ":entity", "Result", ":service", "AnonymousClass(##{service.object_id})", ":status", ":success"] }

        it "uses custom class name" do
          expect(result.inspect).to include(*keywords)
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
