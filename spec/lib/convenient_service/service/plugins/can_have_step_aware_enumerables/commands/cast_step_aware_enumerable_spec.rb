# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Commands::CastStepAwareEnumerable, type: :standard do
  include ConvenientService::RSpec::Helpers::IgnoringException

  include ConvenientService::RSpec::Matchers::DelegateTo

  example_group "class methods" do
    describe ".call" do
      subject(:command_result) { described_class.call(object: object, organizer: organizer, propagated_result: propagated_result) }

      let(:service) do
        Class.new do
          include ConvenientService::Standard::Config
        end
      end

      let(:organizer) { service.new }
      let(:propagated_result) { service.error(code: "from propagated result") }

      let(:step_aware_enumerable) { ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::Enumerable.new(object: object, organizer: organizer, propagated_result: propagated_result) }

      context "when `object` is NOT enumerable" do
        let(:object) { 42 }

        let(:exception_message) do
          <<~TEXT
            Object of class `Integer` is NOT enumerable.

            Valid enumerable examples are classes that mix in `Enumerable` module like `Array`, `Hash`, `Set`, `Range`, `IO`, `Enumerator`, etc.
          TEXT
        end

        it "raises `ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Exceptions::ObjectIsNotEnumerable`" do
          expect { command_result }
            .to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Exceptions::ObjectIsNotEnumerable)
            .with_message(exception_message)
        end

        specify do
          expect { ignoring_exception(ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Exceptions::ObjectIsNotEnumerable) { command_result } }
            .to delegate_to(ConvenientService, :raise)
        end

        context "when `object` is instance of anonymous class" do
          let(:anonymous_class) { Class.new }
          let(:object) { anonymous_class.new }

          let(:exception_message) do
            <<~TEXT
              Object of class `#{ConvenientService::Utils::Class.display_name(object.class)}` is NOT enumerable.

              Valid enumerable examples are classes that mix in `Enumerable` module like `Array`, `Hash`, `Set`, `Range`, `IO`, `Enumerator`, etc.
            TEXT
          end

          it "raises `ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Exceptions::ObjectIsNotEnumerable`" do
            expect { command_result }
              .to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Exceptions::ObjectIsNotEnumerable)
              .with_message(exception_message)
          end
        end
      end

      context "when `object` is enumerable" do
        context "when `object` is array" do
          let(:object) { [:foo, :bar, :baz] }

          it "returns step aware enumerable" do
            expect(command_result).to eq(step_aware_enumerable)
          end
        end

        context "when `object` is set" do
          let(:object) { Set[:foo, :bar, :baz] }

          it "returns step aware enumerable" do
            expect(command_result).to eq(step_aware_enumerable)
          end
        end

        ##
        # TODO: Other enumerables including custom enumerables.
        ##
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
