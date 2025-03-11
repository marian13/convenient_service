# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Entities::StepAwareEnumerable, type: :standard do
  include ConvenientService::RSpec::Matchers::DelegateTo
  include ConvenientService::RSpec::Matchers::Results

  example_group "instance methods" do
    let(:service) do
      Class.new do
        include ConvenientService::Standard::Config
      end
    end

    let(:organizer) { service.new }

    let(:step_aware_enumerable) { described_class.new(enumerable: items, organizer: organizer) }

    ##
    # NOTE: Delegation avoidance is tested by not executing `raise`.
    #
    describe "#all?" do
      example_group "pattern form" do
        let(:pattern) do
          proc do |item|
            if item.instance_of?(Symbol) then true
            elsif item.instance_of?(Integer) then raise
            end
          end
        end

        context "when items are empty" do
          let(:items) { [] }

          it "returns step aware enumerable" do
            expect(step_aware_enumerable.all?(pattern)).to be_instance_of(described_class)
          end

          context "when converted into result" do
            it "returns success" do
              expect(step_aware_enumerable.all?(pattern).result).to be_success
            end
          end
        end

        context "when block value is NOT truthy for all items" do
          let(:items) { ["foo", 1] }

          it "returns step aware enumerable" do
            expect(step_aware_enumerable.all?(pattern)).to be_instance_of(described_class)
          end

          context "when converted into result" do
            it "returns failure" do
              expect(step_aware_enumerable.all?(pattern).result).to be_failure
            end
          end
        end

        context "when block value is truthy for all items" do
          let(:items) { [:foo, :bar] }

          it "returns step aware enumerable" do
            expect(step_aware_enumerable.all?(pattern)).to be_instance_of(described_class)
          end

          context "when converted into result" do
            it "returns success" do
              expect(step_aware_enumerable.all?(pattern).result).to be_success
            end
          end
        end
      end

      example_group "block form" do
        context "when condition block does NOT return step" do
          let(:condition_block) { proc { |item| item.call.instance_of?(Symbol) } }

          context "when items are empty" do
            let(:items) { [] }

            it "returns step aware enumerable" do
              expect(step_aware_enumerable.all?(&condition_block)).to be_instance_of(described_class)
            end

            context "when converted into result" do
              it "returns success" do
                expect(step_aware_enumerable.all?(&condition_block).result).to be_success
              end
            end
          end

          context "when block value is NOT truthy for all items" do
            let(:items) { [-> { "foo" }, -> { raise }] }

            it "returns step aware enumerable" do
              expect(step_aware_enumerable.all?(&condition_block)).to be_instance_of(described_class)
            end

            context "when converted into result" do
              it "returns failure" do
                expect(step_aware_enumerable.all?(&condition_block).result).to be_failure
              end
            end
          end

          context "when block value is truthy for all items" do
            let(:items) { [-> { :foo }, -> { :bar }] }

            it "returns step aware enumerable" do
              expect(step_aware_enumerable.all?(&condition_block)).to be_instance_of(described_class)
            end

            context "when converted into result" do
              it "returns success" do
                expect(step_aware_enumerable.all?(&condition_block).result).to be_success
              end
            end
          end
        end

        context "when condition block return step" do
          let(:condition_block) do
            proc do |item|
              organizer.step nested_service,
                in: [item: -> { item }]
            end
          end

          let(:nested_service) do
            Class.new do
              include ConvenientService::Standard::Config

              attr_reader :item

              def initialize(item:)
                @item = item
              end

              def result
                value = item.call

                return error if value.instance_of?(Integer)

                value.instance_of?(Symbol) ? success : failure
              end
            end
          end

          context "when items are empty" do
            let(:items) { [] }

            it "returns step aware enumerable" do
              expect(step_aware_enumerable.all?(&condition_block)).to be_instance_of(described_class)
            end

            context "when converted into result" do
              it "returns success" do
                expect(step_aware_enumerable.all?(&condition_block).result).to be_success
              end
            end
          end

          context "when step result is NOT success for all items" do
            let(:items) { [-> { "foo" }, -> { raise }] }

            it "returns step aware enumerable" do
              expect(step_aware_enumerable.all?(&condition_block)).to be_instance_of(described_class)
            end

            context "when converted into result" do
              it "returns failure" do
                expect(step_aware_enumerable.all?(&condition_block).result).to be_failure
              end
            end
          end

          context "when step result is success for all items" do
            let(:items) { [-> { :foo }, -> { :bar }] }

            it "returns step aware enumerable" do
              expect(step_aware_enumerable.all?(&condition_block)).to be_instance_of(described_class)
            end

            context "when converted into result" do
              it "returns success" do
                expect(step_aware_enumerable.all?(&condition_block).result).to be_success
              end
            end
          end

          context "when step result is error for any item" do
            let(:items) { [-> { 1 }, -> { raise }] }

            it "returns step aware enumerable" do
              expect(step_aware_enumerable.all?(&condition_block)).to be_instance_of(described_class)
            end

            context "when converted into result" do
              it "returns error" do
                expect(step_aware_enumerable.all?(&condition_block).result).to be_error
              end
            end
          end
        end
      end
    end

    ##
    # NOTE: Delegation avoidance is tested by not executing `raise`.
    #
    describe "#any?" do
      example_group "pattern form" do
        let(:pattern) do
          proc do |item|
            if item.instance_of?(Symbol) then true
            elsif item.instance_of?(Integer) then raise
            end
          end
        end

        context "when items are empty" do
          let(:items) { [] }

          it "returns step aware enumerable" do
            expect(step_aware_enumerable.any?(pattern)).to be_instance_of(described_class)
          end

          context "when converted into result" do
            it "returns failure" do
              expect(step_aware_enumerable.any?(pattern).result).to be_failure
            end
          end
        end

        context "when block value is NOT truthy for any item" do
          let(:items) { ["foo", "bar"] }

          it "returns step aware enumerable" do
            expect(step_aware_enumerable.any?(pattern)).to be_instance_of(described_class)
          end

          context "when converted into result" do
            it "returns failure" do
              expect(step_aware_enumerable.any?(pattern).result).to be_failure
            end
          end
        end

        context "when block value is truthy for any item" do
          let(:items) { [:foo, 1] }

          it "returns step aware enumerable" do
            expect(step_aware_enumerable.any?(pattern)).to be_instance_of(described_class)
          end

          context "when converted into result" do
            it "returns success" do
              expect(step_aware_enumerable.any?(pattern).result).to be_success
            end
          end
        end
      end

      example_group "block form" do
        context "when condition block does NOT return step" do
          let(:condition_block) { proc { |item| item.call.instance_of?(Symbol) } }

          context "when items are empty" do
            let(:items) { [] }

            it "returns step aware enumerable" do
              expect(step_aware_enumerable.any?(&condition_block)).to be_instance_of(described_class)
            end

            context "when converted into result" do
              it "returns failure" do
                expect(step_aware_enumerable.any?(&condition_block).result).to be_failure
              end
            end
          end

          context "when block value is NOT truthy for any item" do
            let(:items) { [-> { "foo" }, -> { "bar" }] }

            it "returns step aware enumerable" do
              expect(step_aware_enumerable.any?(&condition_block)).to be_instance_of(described_class)
            end

            context "when converted into result" do
              it "returns failure" do
                expect(step_aware_enumerable.any?(&condition_block).result).to be_failure
              end
            end
          end

          context "when block value is truthy for any item" do
            let(:items) { [-> { :foo }, -> { raise }] }

            it "returns step aware enumerable" do
              expect(step_aware_enumerable.any?(&condition_block)).to be_instance_of(described_class)
            end

            context "when converted into result" do
              it "returns success" do
                expect(step_aware_enumerable.any?(&condition_block).result).to be_success
              end
            end
          end
        end

        context "when condition block return step" do
          let(:condition_block) do
            proc do |item|
              organizer.step nested_service,
                in: [item: -> { item }]
            end
          end

          let(:nested_service) do
            Class.new do
              include ConvenientService::Standard::Config

              attr_reader :item

              def initialize(item:)
                @item = item
              end

              def result
                value = item.call

                return error if value.instance_of?(Integer)

                value.instance_of?(Symbol) ? success : failure
              end
            end
          end

          context "when items are empty" do
            let(:items) { [] }

            it "returns step aware enumerable" do
              expect(step_aware_enumerable.any?(&condition_block)).to be_instance_of(described_class)
            end

            context "when converted into result" do
              it "returns failure" do
                expect(step_aware_enumerable.any?(&condition_block).result).to be_failure
              end
            end
          end

          context "when step result is NOT success for any item" do
            let(:items) { [-> { "foo" }, -> { "bar" }] }

            it "returns step aware enumerable" do
              expect(step_aware_enumerable.any?(&condition_block)).to be_instance_of(described_class)
            end

            context "when converted into result" do
              it "returns failure" do
                expect(step_aware_enumerable.any?(&condition_block).result).to be_failure
              end
            end
          end

          context "when step result is success for any items" do
            let(:items) { [-> { :foo }, -> { raise }] }

            it "returns step aware enumerable" do
              expect(step_aware_enumerable.any?(&condition_block)).to be_instance_of(described_class)
            end

            context "when converted into result" do
              it "returns success" do
                expect(step_aware_enumerable.any?(&condition_block).result).to be_success
              end
            end
          end

          context "when step result is error for any item" do
            let(:items) { [-> { 1 }, -> { raise }] }

            it "returns step aware enumerable" do
              expect(step_aware_enumerable.any?(&condition_block)).to be_instance_of(described_class)
            end

            context "when converted into result" do
              it "returns error" do
                expect(step_aware_enumerable.any?(&condition_block).result).to be_error
              end
            end
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
