# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Service::Plugins::CanHaveSteps::Entities::Service do
  include ConvenientService::RSpec::Matchers::DelegateTo

  let(:klass) do
    Class.new do
      include ConvenientService::Configs::Standard
    end
  end

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
  # NOTE: Waits for `should-matchers` full support.
  #
  # example_group "delegators" do
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
        let(:klass) do
          Class.new do
            include ConvenientService::Configs::Standard
          end
        end

        let(:service) { described_class.new(klass) }

        context "when `other` is NOT castable" do
          let(:other) { 42 }

          before do
            allow(described_class).to receive(:cast).and_return(nil)
          end

          it "returns `nil`" do
            expect(service == other).to be_nil
          end
        end

        context "when `other` is castable" do
          context "when `other` has different klass" do
            let(:other) { described_class.new(Class.new.tap { |klass| }) }

            before do
              allow(described_class).to receive(:cast).and_call_original
            end

            it "returns `false`" do
              expect(service == other).to eq(false)
            end
          end

          context "when `other` has same attributes" do
            let(:other) { described_class.new(klass) }

            before do
              allow(described_class).to receive(:cast).and_call_original
            end

            it "returns `true`" do
              expect(service == other).to eq(true)
            end
          end
        end
      end
    end

    describe "#has_defined_method?" do
      let(:klass) do
        Class.new do
          include ConvenientService::Configs::Standard
        end
      end

      let(:method_name) { :foo }
      let(:service) { described_class.new(klass) }
      let(:method) { ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method.cast(method_name, direction: :input) }

      specify do
        expect { service.has_defined_method?(method) }
          .to delegate_to(ConvenientService::Utils::Method, :defined?)
          .with_arguments(method, klass, private: true)
          .and_return_its_value
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
