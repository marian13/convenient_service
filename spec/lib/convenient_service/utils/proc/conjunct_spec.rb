# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Utils::Proc::Conjunct, type: :standard do
  describe ".call" do
    subject(:conjuction) { described_class.call(procs) }

    let(:item) { double }

    context "when procs array is empty" do
      let(:procs) { [] }

      it "returns proc that always evaluates to nil" do
        expect(conjuction[item]).to eq(nil)
      end

      example_group "returned proc" do
        context "when used with Enumerable#all?" do
          context "when enumerable is empty" do
            let(:enumerable) { [] }

            it "is evaluated as truthy" do
              expect(enumerable.all?(&conjuction)).to eq(true)
            end
          end
        end

        context "when used with Enumerable#find" do
          context "when enumerable is empty" do
            let(:enumerable) { [] }

            it "is evaluated as falsey" do
              expect(enumerable.find(&conjuction)).to be_nil
            end
          end
        end
      end
    end

    context "when procs array contains one proc" do
      let(:procs) { [first_proc] }
      let(:first_proc) { ->(item) { item[:valid] } }

      it "returns that one proc" do
        expect(conjuction).to eq(first_proc)
      end

      it "returns original proc (not copy)" do
        expect(conjuction).to equal(first_proc)
      end
    end

    context "when procs array contains two procs" do
      let(:procs) { [first_proc, second_proc] }

      let(:first_proc) { ->(item) { true } }
      let(:second_proc) { ->(item) { true } }

      context "when first proc returns false" do
        let(:first_proc) { ->(item) { false } }

        it "returns conjuction of those two procs that return false" do
          expect(conjuction[item]).to eq(false)
        end
      end

      context "when first proc returns true" do
        let(:first_proc) { ->(item) { true } }

        context "when second proc returns false" do
          let(:second_proc) { ->(item) { false } }

          it "returns conjuction of those two procs that return false" do
            expect(conjuction[item]).to eq(false)
          end
        end

        context "when second proc returns true" do
          let(:second_proc) { ->(item) { true } }

          it "returns conjuction of those two procs that return true" do
            expect(conjuction[item]).to eq(true)
          end
        end
      end
    end

    # rubocop:disable RSpec/MultipleMemoizedHelpers
    context "when procs array contains more than two procs" do
      let(:procs) { [first_proc, second_proc, third_proc, forth_proc, fifth_proc] }

      let(:first_proc) { ->(item) { true } }
      let(:second_proc) { ->(item) { true } }
      let(:third_proc) { ->(item) { false } }
      let(:forth_proc) { ->(item) { true } }
      let(:fifth_proc) { ->(item) { true } }

      ##
      # Proof of concept spec for big amount of procs.
      # Since third_proc return false, forth_proc and fifth_proc should not be called at all.
      # Also this spec proves proc that all procs are called at most once.
      #
      # rubocop:disable RSpec/MultipleExpectations, RSpec/ExampleLength
      it "returns conjuction combined from those more than two procs" do
        allow(first_proc).to receive(:[]).with(item).and_call_original.once
        allow(second_proc).to receive(:[]).with(item).and_call_original.once
        allow(third_proc).to receive(:[]).with(item).and_call_original.once
        allow(forth_proc).to receive(:[]).with(item).and_call_original.once
        allow(fifth_proc).to receive(:[]).with(item).and_call_original.once

        conjuction[item]

        expect(first_proc).to have_received(:[])
        expect(second_proc).to have_received(:[])
        expect(third_proc).to have_received(:[])
        expect(forth_proc).not_to have_received(:[])
        expect(fifth_proc).not_to have_received(:[])
      end
      # rubocop:enable RSpec/MultipleExpectations, RSpec/ExampleLength
    end
    # rubocop:enable RSpec/MultipleMemoizedHelpers
  end
end
# rubocop:enable RSpec/NestedGroups
