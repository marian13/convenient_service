# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

return unless defined? ConvenientService::Service::Plugins::HasJSendResultParamsValidations::UsingDryValidation

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Service::Plugins::HasJSendResultParamsValidations::UsingDryValidation::NoOpConcern, type: :rails do
  include ConvenientService::RSpec::Matchers::IncludeModule
  include ConvenientService::RSpec::Matchers::ExtendModule

  example_group "modules" do
    subject { described_class }

    it { is_expected.to include_module(ConvenientService::Concern) }

    context "when included" do
      subject do
        Class.new.tap do |klass|
          klass.class_exec(described_class) do |mod|
            include mod
          end
        end
      end

      it { is_expected.to extend_module(described_class::ClassMethods) }
    end
  end

  example_group "class methods" do
    describe ".with" do
      context "when `skip_validations` is NOT passed" do
        it "defaults to `false` (returns original concern)" do
          expect(described_class.with).to eq(ConvenientService::Service::Plugins::HasJSendResultParamsValidations::UsingDryValidation::Concern)
        end
      end

      context "when `skip_validations` is passed" do
        context "when `skip_validations` is `false`" do
          it "returns original concern" do
            expect(described_class.with(skip_validations: false)).to eq(ConvenientService::Service::Plugins::HasJSendResultParamsValidations::UsingDryValidation::Concern)
          end
        end

        context "when `skip_validations` is `true`" do
          it "returns no-op concern" do
            expect(described_class.with(skip_validations: true)).to eq(described_class)
          end
        end
      end
    end
  end

  example_group "method signatures sync" do
    def method_for(method_name, mod)
      mod.instance_method(method_name).parameters
    end

    specify { expect(method_for(:contract, described_class::ClassMethods)).to eq(method_for(:contract, described_class)) }
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
