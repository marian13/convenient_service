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

      let(:step_aware_enumerable) { ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::Enumerable.new(**arguments) }
      let(:arguments) { {object: object, organizer: organizer, propagated_result: propagated_result} }

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
          let(:object) { [:foo, :bar] }
          let(:step_aware_enumerable) { ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::Array.new(**arguments) }

          it "returns step aware enumerable" do
            expect(command_result).to eq(step_aware_enumerable)
          end
        end

        context "when `object` is hash" do
          let(:object) { {foo: :bar, baz: :qux} }
          let(:step_aware_enumerable) { ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::Hash.new(**arguments) }

          it "returns step aware enumerable" do
            expect(command_result).to eq(step_aware_enumerable)
          end
        end

        context "when `object` is set" do
          let(:object) { Set[:foo, :bar] }
          let(:step_aware_enumerable) { ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::Set.new(**arguments) }

          it "returns step aware enumerable" do
            expect(command_result).to eq(step_aware_enumerable)
          end
        end

        context "when `object` is implicit enumerator" do
          let(:object) { [:foo, :bar].each }
          let(:step_aware_enumerable) { ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::Enumerator.new(**arguments) }

          it "returns step aware enumerable" do
            expect(command_result).to eq(step_aware_enumerable)
          end
        end

        context "when `object` is explicit enumerator" do
          let(:object) { Enumerator.new { |collection| [:foo, :bar].each { |item| collection << item } } }
          let(:step_aware_enumerable) { ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::Enumerator.new(**arguments) }

          it "returns step aware enumerable" do
            expect(command_result).to eq(step_aware_enumerable)
          end
        end

        context "when `object` is implicit lazy enumerator" do
          let(:object) { [:foo, :bar].lazy }
          let(:step_aware_enumerable) { ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::LazyEnumerator.new(**arguments) }

          it "returns step aware enumerable" do
            expect(command_result).to eq(step_aware_enumerable)
          end
        end

        context "when `object` is explicit lazy enumerator" do
          let(:object) { Enumerator::Lazy.new([:foo, :bar]) { |collection, *items| items.each { |item| collection << item } } }
          let(:step_aware_enumerable) { ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::LazyEnumerator.new(**arguments) }

          it "returns step aware enumerable" do
            expect(command_result).to eq(step_aware_enumerable)
          end
        end

        context "when `object` is implicit chain enumerator" do
          let(:object) { [:foo, :bar].chain([:baz, :qux]) }
          let(:step_aware_enumerable) { ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::ChainEnumerator.new(**arguments) }

          it "returns step aware enumerable" do
            expect(command_result).to eq(step_aware_enumerable)
          end
        end

        context "when `object` is explicit chain enumerator" do
          let(:object) { Enumerator::Chain.new([:foo, :bar], [:baz, :qux]) }
          let(:step_aware_enumerable) { ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::ChainEnumerator.new(**arguments) }

          it "returns step aware enumerable" do
            expect(command_result).to eq(step_aware_enumerable)
          end
        end

        ##
        # NOTE: There is NO way to create arithmetic sequence explicitly via `.new`.
        #
        context "when `object` is implicit arithmetic sequence" do
          let(:object) { (0..5).step(1) }
          let(:step_aware_enumerable) { ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::ArithmeticSequenceEnumerator.new(**arguments) }

          it "returns step aware enumerable" do
            expect(command_result).to eq(step_aware_enumerable)
          end
        end

        context "when `object` is range" do
          let(:object) { (0..5) }
          let(:step_aware_enumerable) { ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::Enumerable.new(**arguments) }

          it "returns step aware enumerable" do
            expect(command_result).to eq(step_aware_enumerable)
          end
        end

        context "when `object` is io" do
          let(:object) { $stdin }
          let(:step_aware_enumerable) { ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::Enumerable.new(**arguments) }

          it "returns step aware enumerable" do
            expect(command_result).to eq(step_aware_enumerable)
          end
        end

        context "when `object` is file" do
          let(:object) { File.new(Tempfile.new.path) }
          let(:step_aware_enumerable) { ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::Enumerable.new(**arguments) }

          it "returns step aware enumerable" do
            expect(command_result).to eq(step_aware_enumerable)
          end
        end

        if ConvenientService::Dependencies.ruby.match?("jruby < 9.5")
          context "when `object` is tempfile" do
            let(:object) { Tempfile.new }
            let(:step_aware_enumerable) { ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::Enumerable.new(**arguments) }

            it "returns step aware enumerable" do
              expect(command_result).to eq(step_aware_enumerable)
            end
          end
        else
          ##
          # NOTE: Tempfile is delegator, that is why it is NOT converted into step aware enumerable.
          # NOTE: Tempfile still can be used as step aware enumerable if converted into enumerator.
          #
          context "when `object` is tempfile" do
            let(:object) { Tempfile.new }

            let(:exception_message) do
              <<~TEXT
                Object of class `Tempfile` is NOT enumerable.

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

        context "when `object` is string io" do
          let(:object) { StringIO.new }
          let(:step_aware_enumerable) { ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::Enumerable.new(**arguments) }

          it "returns step aware enumerable" do
            expect(command_result).to eq(step_aware_enumerable)
          end
        end

        context "when `object` is custom enumerable" do
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
          let(:step_aware_enumerable) { ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::Enumerable.new(**arguments) }

          it "returns step aware enumerable" do
            expect(command_result).to eq(step_aware_enumerable)
          end
        end

        context "when `object` is enumerator descendant" do
          let(:klass) { Class.new(Enumerator) }
          let(:object) { klass.new { |collection| [:foo, :bar].each { |item| collection << item } } }
          let(:step_aware_enumerable) { ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::Enumerator.new(**arguments) }

          it "returns step aware enumerable" do
            expect(command_result).to eq(step_aware_enumerable)
          end
        end

        context "when `object` is lazy enumerator descendant" do
          let(:klass) { Class.new(Enumerator::Lazy) }
          let(:object) { klass.new([:foo, :bar]) { |collection, *items| items.each { |item| collection << item } } }
          let(:step_aware_enumerable) { ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::LazyEnumerator.new(**arguments) }

          it "returns step aware enumerable" do
            expect(command_result).to eq(step_aware_enumerable)
          end
        end

        context "when `object` is chain enumerator descendant" do
          let(:klass) { Class.new(Enumerator::Chain) }
          let(:object) { klass.new([:foo, :bar], [:baz, :qux]) }
          let(:step_aware_enumerable) { ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::ChainEnumerator.new(**arguments) }

          it "returns step aware enumerable" do
            expect(command_result).to eq(step_aware_enumerable)
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
