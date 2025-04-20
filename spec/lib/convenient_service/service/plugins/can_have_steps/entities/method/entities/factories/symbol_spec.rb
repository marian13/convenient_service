# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method::Entities::Factories::Symbol, type: :standard do
  include ConvenientService::RSpec::Matchers::DelegateTo

  let(:factory) { described_class.new(other: symbol) }
  let(:symbol) { :foo }

  example_group "inheritance" do
    include ConvenientService::RSpec::PrimitiveMatchers::BeDescendantOf

    subject { described_class }

    it { is_expected.to be_descendant_of(ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method::Entities::Factories::Base) }
  end

  example_group "instance methods" do
    describe "#create_key" do
      specify do
        expect { factory.create_key }
          .to delegate_to(ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method::Entities::Key, :new)
          .with_arguments(factory.other)
          .and_return_its_value
      end
    end

    describe "#create_name" do
      specify do
        expect { factory.create_name }
          .to delegate_to(ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method::Entities::Name, :new)
          .with_arguments(factory.other)
          .and_return_its_value
      end
    end

    describe "#create_caller" do
      specify do
        expect { factory.create_caller }
          .to delegate_to(ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method::Entities::Callers::Usual, :new)
          .with_arguments(factory.other)
          .and_return_its_value
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
