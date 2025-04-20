# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

RSpec.describe ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method::Concern::ClassMethods, type: :standard do
  example_group "class methods" do
    let(:method_class) do
      Class.new.tap do |klass|
        klass.class_exec(described_class) do |mod|
          extend mod
        end
      end
    end

    describe ".call" do
      include ConvenientService::RSpec::Matchers::DelegateTo

      let(:other) { :foo }
      let(:options) { {direction: :input} }

      ##
      # NOTE: `it { is_expected...` does NOT support blocks.
      # https://github.com/rspec/rspec-expectations/issues/805
      #
      specify {
        expect { method_class.cast(other, **options) }
          .to delegate_to(ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method::Commands::CastMethod, :call)
          .with_arguments(other: other, options: options)
          .and_return_its_value
      }
    end
  end
end
