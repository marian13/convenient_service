# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Utils::Module::GetNamespace, type: :standard do
  example_group "class methhods" do
    describe ".call" do
      let(:mod) { Class.new }

      let(:util_result) { described_class.call(mod) }

      context "when `mod` does NOT have namespace" do
        let(:mod) { String }

        it "returns `nil`" do
          expect(util_result).to be_nil
        end
      end

      context "when `mod` has namespace" do
        let(:mod) { Enumerator::Lazy }

        it "returns namespace" do
          expect(util_result).to eq(Enumerator)
        end

        context "when `mod` has nested namespace" do
          let(:mod) { Thread::Backtrace::Location }

          it "returns nested namespace" do
            expect(util_result).to eq(Thread::Backtrace)
          end
        end
      end

      context "when `mod` is anonymous" do
        let(:mod) { Module.new }

        it "returns `nil`" do
          expect(util_result).to be_nil
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
