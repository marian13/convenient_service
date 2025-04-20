# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

return if ConvenientService::Dependencies.ruby.version < 3.2

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Utils::Class::GetAttachedObject, type: :standard do
  example_group "class methods" do
    describe ".call" do
      subject(:utils_result) { described_class.call(klass) }

      context "when `class` is `nil`" do
        let(:klass) { nil }

        it "returns `nil`" do
          expect(utils_result).to be_nil
        end
      end

      context "when `class` is instance of `Class`" do
        context "when that `class` is NOT singleton class" do
          let(:klass) { String }

          it "returns `nil`" do
            expect(utils_result).to be_nil
          end
        end

        context "when that `class` is class singleton class" do
          let(:klass) { String.singleton_class }

          it "returns singleton class attached object" do
            expect(utils_result).to eq(String)
          end
        end

        context "when that `class` is module singleton class" do
          let(:klass) { Kernel.singleton_class }

          it "returns singleton class attached object" do
            expect(utils_result).to eq(Kernel)
          end
        end

        context "when that `class` is object singleton class" do
          let(:klass) { (+"abc").singleton_class }

          it "returns singleton class attached object" do
            expect(utils_result).to eq("abc")
          end
        end
      end

      context "when `class` is instance of `Module`" do
        let(:klass) { Kernel }

        it "returns `nil`" do
          expect(utils_result).to be_nil
        end
      end

      context "when `class` is object" do
        let(:klass) { "abc" }

        it "returns `nil`" do
          expect(utils_result).to be_nil
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
