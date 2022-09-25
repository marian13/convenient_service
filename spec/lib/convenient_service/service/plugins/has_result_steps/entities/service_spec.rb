# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Service::Plugins::HasResultSteps::Entities::Service do
  let(:klass) { Class.new }

  let(:service) { described_class.new(klass) }

  example_group "modules" do
    include ConvenientService::RSpec::Matchers::IncludeModule
    include ConvenientService::RSpec::Matchers::ExtendModule

    subject { described_class }

    it { is_expected.to include_module(ConvenientService::Support::Castable) }
    it { is_expected.to include_module(ConvenientService::Support::Delegate) }
    it { is_expected.to extend_module(described_class::ClassMethods) }
  end

  ##
  # NOTE: Waits for `should-matchers' full support.
  #
  # example_group "delegations" do
  #   include Shoulda::Matchers::Independent
  #
  #   subject { service }
  #
  #   it { is_expected.to delegate_method(:result).to(:klass) }
  #   it { is_expected.to delegate_method(:step_class).to(:klass) }
  # end

  example_group "instance methods" do
    example_group "comparison" do
      describe "#==" do
        let(:klass) { Class.new }
        let(:service) { described_class.new(klass) }

        context "when `other' is NOT castable" do
          let(:other) { 42 }

          before do
            allow(described_class).to receive(:cast).and_return(nil)
          end

          it "returns `nil'" do
            expect(service == other).to be_nil
          end
        end

        context "when `other' is castable" do
          context "when `other' has different klass" do
            let(:other) { described_class.new(Class.new.tap { |klass| }) }

            before do
              allow(described_class).to receive(:cast).and_call_original
            end

            it "returns `false'" do
              expect(service == other).to eq(false)
            end
          end

          context "when `other' has same attributes" do
            let(:other) { described_class.new(klass) }

            before do
              allow(described_class).to receive(:cast).and_call_original
            end

            it "returns `true'" do
              expect(service == other).to eq(true)
            end
          end
        end
      end
    end

    describe "#has_defined_method?" do
      let(:method_name) { :foo }
      let(:klass) { Class.new }
      let(:service) { described_class.new(klass) }
      let(:method) { ConvenientService::Service::Plugins::HasResultSteps::Entities::Method.cast(method_name, direction: :input) }

      it "converts `method' to string" do
        allow(method).to receive(:to_s).and_call_original

        service.has_defined_method?(method)

        expect(method).to have_received(:to_s)
      end

      it "delegates to `Module#method_defined?'" do
        allow(klass).to receive(:method_defined?).with(method_name.to_s).and_call_original

        service.has_defined_method?(method)

        expect(klass).to have_received(:method_defined?)
      end

      context "when `method' is NOT defined" do
        let(:klass) { Class.new }

        it "returns `false'" do
          expect(service.has_defined_method?(method)).to eq(false)
        end
      end

      context "when public `method' is defined" do
        let(:klass) do
          Class.new do
            def foo
            end
          end
        end

        it "returns `true'" do
          expect(service.has_defined_method?(method)).to eq(true)
        end
      end

      context "when private `method' is defined" do
        let(:klass) do
          Class.new do
            private

            def foo
            end
          end
        end

        it "returns `true'" do
          expect(service.has_defined_method?(method)).to eq(true)
        end
      end
    end

    describe "#inspect" do
      let(:klass) { Class.new }
      let(:service) { described_class.new(klass) }

      it "returns inspect string" do
        expect(service.inspect).to eq("HasResultSteps::Service(#{klass})")
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
