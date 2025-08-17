# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method::Entities::Factories::Method, type: :standard do
  include ConvenientService::RSpec::Matchers::DelegateTo

  let(:factory) { described_class.new(other: method) }
  let(:method) { ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method.cast(:foo, direction: "input") }

  example_group "inheritance" do
    include ConvenientService::RSpec::Matchers::BeDescendantOf

    subject { described_class }

    it { is_expected.to be_descendant_of(ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method::Entities::Factories::Base) }
  end

  example_group "instance methods" do
    describe "#create_key" do
      specify do
        expect { factory.create_key }
          .to delegate_to(method.key, :copy)
          .without_arguments
          .and_return_its_value
      end
    end

    describe "#create_name" do
      specify do
        expect { factory.create_name }
          .to delegate_to(method.name, :copy)
          .without_arguments
          .and_return_its_value
      end
    end

    describe "#create_caller" do
      specify do
        expect { factory.create_caller }
          .to delegate_to(method.caller, :copy)
          .without_arguments
          .and_return_its_value
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
