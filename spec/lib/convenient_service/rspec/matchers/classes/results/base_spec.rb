# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::RSpec::Matchers::Classes::Results::Base, type: :standard do
  include ConvenientService::RSpec::Matchers::DelegateTo
  include ConvenientService::RSpec::Matchers::CacheItsValue

  let(:matcher) { described_class.new(statuses: statuses, result: result) }
  let(:statuses) { [:success] }

  let(:service) do
    Class.new do
      include ConvenientService::Standard::Config

      def result
        success
      end
    end
  end

  let(:result) { service.result }
  let(:chain) { described_class::Entities::Chain.new.tap { |chain| chain.statuses = statuses } }

  example_group "class methods" do
    describe ".new" do
      context "when statuses are NOT passed" do
        let(:matcher) { matcher_class.new(result: result) }

        let(:matcher_class) do
          Class.new(described_class) do
            def statuses
              [:success, :failure, :error]
            end
          end
        end

        it "defaults statuses to `self.statuses`" do
          expect(matcher.chain.statuses).to eq([:success, :failure, :error])
        end
      end

      context "when result is NOT passed" do
        let(:matcher) { described_class.new(statuses: statuses) }

        it "defaults result to `nil`" do
          expect(matcher.result).to be_nil
        end
      end
    end
  end

  example_group "instance methods" do
    example_group "attributes" do
      include ConvenientService::RSpec::Matchers::HaveAttrReader

      subject { matcher }

      it { is_expected.to have_attr_reader(:result) }
    end

    example_group "abstract methods" do
      include ConvenientService::RSpec::Matchers::HaveAbstractMethod

      subject { matcher }

      it { is_expected.to have_abstract_method(:statuses) }
    end

    describe "#matches?" do
      it "sets result" do
        matcher.matches?(service.failure)

        expect(matcher.result).to eq(service.failure)
      end

      specify do
        expect { matcher.matches?(result) }
          .to delegate_to(matcher.validator, :valid_result?)
          .without_arguments
          .and_return_its_value
      end

      ##
      # TODO: Resolve a bug in `delegate_to`. It does NOT work as expected with `respond_to?`. See source for details.
      #
      # context "when result does NOT respond to `commit_config!`" do
      #   let(:result) { "foo" }
      #
      #   specify do
      #     expect { matcher.matches?(result) }
      #       .not_to delegate_to(result.class, :commit_config!)
      #       .with_any_arguments
      #       .without_calling_original
      #   end
      # end

      context "when result responds to `commit_config!`" do
        let(:result) { service.result }

        specify do
          expect { matcher.matches?(result) }
            .to delegate_to(result.class, :commit_config!)
            .with_arguments(trigger: described_class::Constants::Triggers::BE_RESULT)
        end
      end
    end

    describe "#description" do
      specify do
        expect { matcher.description }
          .to delegate_to(matcher.printer, :description)
          .without_arguments
          .and_return_its_value
      end
    end

    describe "#failure_message" do
      specify do
        expect { matcher.failure_message }
          .to delegate_to(matcher.printer, :failure_message)
          .without_arguments
          .and_return_its_value
      end
    end

    describe "#failure_message_when_negated" do
      specify do
        expect { matcher.failure_message_when_negated }
          .to delegate_to(matcher.printer, :failure_message_when_negated)
          .without_arguments
          .and_return_its_value
      end
    end

    describe "#with_data" do
      let(:data) { {foo: :bar} }

      it "sets chain data" do
        matcher.with_data(data)

        expect(matcher.chain.data).to eq(data)
      end

      it "returns matcher" do
        expect(matcher.with_data(data)).to eq(matcher)
      end
    end

    describe "#and_data" do
      let(:data) { {foo: :bar} }

      it "sets chain data" do
        matcher.and_data(data)

        expect(matcher.chain.data).to eq(data)
      end

      it "returns matcher" do
        expect(matcher.and_data(data)).to eq(matcher)
      end
    end

    describe "#without_data" do
      it "sets chain data to empty hash" do
        matcher.without_data

        expect(matcher.chain.data).to eq({})
      end

      it "returns matcher" do
        expect(matcher.without_data).to eq(matcher)
      end
    end

    describe "#with_message" do
      let(:message) { "foo" }

      it "sets chain message" do
        matcher.with_message(message)

        expect(matcher.chain.message).to eq(message)
      end

      it "returns matcher" do
        expect(matcher.with_message(message)).to eq(matcher)
      end
    end

    describe "#and_message" do
      let(:message) { "foo" }

      it "sets chain message" do
        matcher.and_message(message)

        expect(matcher.chain.message).to eq(message)
      end

      it "returns matcher" do
        expect(matcher.and_message(message)).to eq(matcher)
      end
    end

    describe "#with_code" do
      let(:code) { :foo }

      it "sets chain code" do
        matcher.with_code(code)

        expect(matcher.chain.code).to eq(code)
      end

      it "returns matcher" do
        expect(matcher.with_code(code)).to eq(matcher)
      end
    end

    describe "#and_code" do
      let(:code) { :foo }

      it "sets chain code" do
        matcher.and_code(code)

        expect(matcher.chain.code).to eq(code)
      end

      it "returns matcher" do
        expect(matcher.and_code(code)).to eq(matcher)
      end
    end

    describe "#of_service" do
      let(:service) do
        Class.new do
          include ConvenientService::Standard::Config

          def result
            success
          end
        end
      end

      it "sets chain service" do
        matcher.of_service(service)

        expect(matcher.chain.service).to eq(service)
      end

      it "returns matcher" do
        expect(matcher.of_service(service)).to eq(matcher)
      end
    end

    describe "#of_original_service" do
      let(:service) do
        Class.new do
          include ConvenientService::Standard::Config

          def result
            success
          end
        end
      end

      it "sets chain original service" do
        matcher.of_original_service(service)

        expect(matcher.chain.original_service).to eq(service)
      end

      it "returns matcher" do
        expect(matcher.of_original_service(service)).to eq(matcher)
      end
    end

    describe "#of_step" do
      let(:service) do
        Class.new do
          include ConvenientService::Standard::Config

          step :foo

          def foo
            success
          end
        end
      end

      let(:step) { :foo }

      context "when `index` is NOT passed" do
        it "sets chain step" do
          matcher.of_step(step)

          expect(matcher.chain.step).to eq(step)
        end

        it "does NOT set chain step index" do
          matcher.of_step(step)

          expect(matcher.chain.step_index).to be_nil
        end

        it "returns matcher" do
          expect(matcher.of_step(step)).to eq(matcher)
        end
      end

      context "when `index` is passed" do
        let(:index) { 0 }

        it "sets chain step" do
          matcher.of_step(step, index: index)

          expect(matcher.chain.step).to eq(step)
        end

        it "sets chain step index" do
          matcher.of_step(step, index: index)

          expect(matcher.chain.step_index).to eq(index)
        end

        it "returns matcher" do
          expect(matcher.of_step(step, index: index)).to eq(matcher)
        end
      end
    end

    describe "#without_step" do
      it "sets chain step to nil" do
        matcher.without_step

        expect(matcher.chain.step).to be_nil
      end

      it "returns matcher" do
        expect(matcher.without_step).to eq(matcher)
      end
    end

    describe "#comparing_by" do
      let(:comparison_method) { :== }

      it "sets chain comparison_method" do
        matcher.comparing_by(comparison_method)

        expect(matcher.chain.comparison_method).to eq(comparison_method)
      end

      it "returns matcher" do
        expect(matcher.comparing_by(comparison_method)).to eq(matcher)
      end
    end

    describe "#chain" do
      it "returns chain" do
        expect(matcher.chain).to eq(chain)
      end

      specify do
        expect { matcher.chain }.to cache_its_value
      end
    end

    describe "#printer" do
      specify do
        expect { matcher.printer }
          .to delegate_to(described_class::Entities::Printers, :create)
          .with_arguments(matcher: matcher)
          .and_return_its_value
      end

      specify do
        expect { matcher.printer }.to cache_its_value
      end
    end

    describe "#validator" do
      specify do
        expect { matcher.validator }
          .to delegate_to(described_class::Entities::Validator, :new)
          .with_arguments(matcher: matcher)
          .and_return_its_value
      end

      specify do
        expect { matcher.validator }.to cache_its_value
      end
    end

    example_group "comparison" do
      describe "#==" do
        context "when `other` has different class" do
          let(:other) { 42 }

          it "returns `nil`" do
            expect(matcher == other).to be_nil
          end
        end

        context "when `other` has different `statuses`" do
          let(:other) { described_class.new(statuses: [:failure], result: result).without_step }

          it "returns `false`" do
            expect(matcher == other).to be(false)
          end
        end

        context "when `other` has different `chain`" do
          let(:other) { described_class.new(statuses: statuses, result: result).without_step }

          it "returns `false`" do
            expect(matcher == other).to be(false)
          end
        end

        context "when `other` has different `result`" do
          let(:other) { described_class.new(statuses: statuses, result: nil) }

          it "returns `false`" do
            expect(matcher == other).to be(false)
          end
        end

        context "when `other` has same attributes" do
          let(:other) { described_class.new(statuses: statuses, result: result) }

          it "returns `true`" do
            expect(matcher == other).to be(true)
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
