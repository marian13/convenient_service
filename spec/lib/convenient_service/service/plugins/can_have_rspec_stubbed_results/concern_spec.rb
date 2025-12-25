# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/SpecFilePathFormat, RSpec/NestedGroups
RSpec.describe ConvenientService::Service::Plugins::CanHaveRSpecStubbedResults::Concern, type: :standard do
  include ConvenientService::RSpec::Matchers::DelegateTo

  let(:service_class) do
    Class.new do
      include ConvenientService::Standard::Config

      def result
        success
      end
    end
  end

  example_group "modules" do
    include ConvenientService::RSpec::Matchers::IncludeModule
    include ConvenientService::RSpec::Matchers::ExtendModule

    subject { described_class }

    it { is_expected.to include_module(ConvenientService::Support::Concern) }

    context "when included" do
      subject { service_class }

      let(:service_class) do
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
    describe ".stubbed_results_store" do
      specify do
        expect { service_class.stubbed_results_store }
          .to delegate_to(ConvenientService::Dependencies.rspec, :current_example)
          .without_arguments
          .and_return_its_value
      end
    end
  end
end
# rubocop:enable RSpec/SpecFilePathFormat, RSpec/NestedGroups
