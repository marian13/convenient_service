# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# frozen_string_literal: true

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::RSpec::Helpers::Custom::StubService::Entities::ResultSpec do
  let(:status) { :success }
  let(:chain) { {} }

  ##
  # TODO: Service class factory!
  #
  # rubocop:disable RSpec/LeakyConstantDeclaration, Lint/ConstantDefinitionInBlock
  let(:service_class) do
    Class.new do
      include ConvenientService::Core

      concerns do
        use ConvenientService::Service::Plugins::CanHaveStubbedResult::Concern
        use ConvenientService::Common::Plugins::HasConstructor::Concern
        use ConvenientService::Common::Plugins::HasConstructorWithoutInitialize::Concern
        use ConvenientService::Service::Plugins::HasResult::Concern
      end

      middlewares :result, scope: :class do
        use ConvenientService::Common::Plugins::NormalizesEnv::Middleware

        use ConvenientService::Service::Plugins::CanHaveStubbedResult::Middleware
      end

      class self::Result
        include ConvenientService::Core

        concerns do
          use ConvenientService::Common::Plugins::HasInternals::Concern
          use ConvenientService::Common::Plugins::HasConstructor::Concern
          use ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::HasJsendStatusAndAttributes::Concern
        end

        middlewares :initialize do
          use ConvenientService::Common::Plugins::NormalizesEnv::Middleware

          use ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::HasJsendStatusAndAttributes::Middleware
        end

        class self::Internals
          include ConvenientService::Core

          concerns do
            use ConvenientService::Common::Plugins::HasInternals::Entities::Internals::Plugins::HasCache::Concern
          end
        end
      end

      class self::Internals
        include ConvenientService::Core

        concerns do
          use ConvenientService::Common::Plugins::HasInternals::Entities::Internals::Plugins::HasCache::Concern
        end
      end

      def result
        success
      end
    end
  end
  # rubocop:enable RSpec/LeakyConstantDeclaration, Lint/ConstantDefinitionInBlock

  example_group "comparison" do
    describe "#==" do
      let(:result_spec) { described_class.new(status: status, service_class: service_class, chain: chain) }

      context "when `other` has different class" do
        let(:other) { 42 }

        it "returns `nil`" do
          expect(result_spec == other).to be_nil
        end
      end

      context "when `other` has different `status`" do
        let(:other) { described_class.new(status: :error, service_class: service_class, chain: chain) }

        it "returns `false`" do
          expect(result_spec == other).to eq(false)
        end
      end

      context "when `other` has different `service_class`" do
        let(:other) { described_class.new(status: status, service_class: Class.new, chain: chain) }

        it "returns `false`" do
          expect(result_spec == other).to eq(false)
        end
      end

      context "when `other` has different `chain`" do
        let(:other) { described_class.new(status: status, service_class: service_class, chain: {args: [:bar], kwargs: {bar: :foo}, block: -> { :bar }}) }

        it "returns `false`" do
          expect(result_spec == other).to eq(false)
        end
      end

      context "when `other` has same attributes" do
        let(:other) { described_class.new(status: status, service_class: service_class, chain: chain) }

        it "returns `true`" do
          expect(result_spec == other).to eq(true)
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
