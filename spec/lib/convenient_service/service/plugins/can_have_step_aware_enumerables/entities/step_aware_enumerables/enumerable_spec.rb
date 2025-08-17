# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::Enumerable, type: :standard do
  include ConvenientService::RSpec::Matchers::DelegateTo

  let(:step_aware_enumerable) { described_class.new(object: object, organizer: organizer, propagated_result: propagated_result) }

  let(:service) do
    Class.new do
      include ConvenientService::Standard::Config
    end
  end

  let(:klass) do
    Class.new do
      include Enumerable

      attr_reader :collection

      def initialize(collection)
        @collection = collection
      end

      def each(&block)
        collection.each(&block)
      end
    end
  end

  let(:object) { klass.new([:foo, :bar]) }
  let(:organizer) { service.new }
  let(:propagated_result) { service.error(code: "from propagated result") }

  example_group "inheritance" do
    include ConvenientService::RSpec::Matchers::BeDescendantOf

    subject { described_class }

    it { is_expected.to be_descendant_of(ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::Base) }
  end

  example_group "instance methods" do
    example_group "alias methods" do
      include ConvenientService::RSpec::Matchers::HaveAliasMethod

      subject { step_aware_enumerable }

      it { is_expected.to have_alias_method(:enumerable, :object) }
    end

    describe "#default_data_key" do
      it "returns `:values`" do
        expect(step_aware_enumerable.default_data_key).to eq(:values)
      end
    end

    describe "#default_evaluate_by" do
      it "returns `nil`" do
        expect(step_aware_enumerable.default_evaluate_by).to be_nil
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
