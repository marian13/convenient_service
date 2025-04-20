# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Config::Commands::NormalizeOptions, type: :standard do
  example_group "class methods" do
    describe ".call" do
      subject(:command_result) { described_class.call(options: options) }

      context "when `options` is `nil`" do
        let(:options) { nil }

        it "returns empty set" do
          expect(command_result).to eq(Set.new)
        end
      end

      context "when `options` is array" do
        context "when `options` is empty array" do
          let(:options) { [] }

          it "returns empty set" do
            expect(command_result).to eq(Set.new)
          end
        end

        context "when `options` contains symbols" do
          let(:options) { [:callbacks, :fallbacks, :rollbacks] }

          it "returns set with those symbols" do
            expect(command_result).to eq(Set[:callbacks, :fallbacks, :rollbacks])
          end
        end

        context "when `options` contains arrays" do
          let(:options) { [:callbacks, [:fallbacks], [:rollbacks]] }

          it "returns set with those arrays flattened" do
            expect(command_result).to eq(Set[:callbacks, :fallbacks, :rollbacks])
          end

          context "when `options` contains nested arrays" do
            let(:options) { [:callbacks, [:fallbacks, [:rollbacks]]] }

            it "returns set with those arrays flattened only one level flattened" do
              expect(command_result).to eq(Set[:callbacks, :fallbacks, [:rollbacks]])
            end
          end
        end

        context "when `options` contains sets" do
          let(:options) { [:callbacks, Set[:fallbacks], Set[:rollbacks]] }

          it "returns set with those sets flattened" do
            expect(command_result).to eq(Set[:callbacks, :fallbacks, :rollbacks])
          end

          context "when `options` contains nested arrays" do
            let(:options) { [:callbacks, Set[:fallbacks, Set[:rollbacks]]] }

            it "returns set with those arrays only one level flattened" do
              expect(command_result).to eq(Set[:callbacks, :fallbacks, Set[:rollbacks]])
            end
          end
        end

        context "when `options` contains hashes" do
          context "when `options` contains hashes with falsy values" do
            let(:options) { [:callbacks, {fallbacks: false}, {rollbacks: nil}] }

            it "returns set without hashes" do
              expect(command_result).to eq(Set[:callbacks])
            end
          end

          context "when `options` contains hashes with truthy values" do
            let(:options) { [:callbacks, {fallbacks: true}, {rollbacks: 42}] }

            it "returns set with those hashes keys" do
              expect(command_result).to eq(Set[:callbacks, :fallbacks, :rollbacks])
            end
          end
        end
      end

      context "when `options` is set" do
        context "when `options` is empty" do
          let(:options) { Set.new }

          it "returns empty set" do
            expect(command_result).to eq(Set.new)
          end
        end

        context "when `options` contains symbols" do
          let(:options) { Set[:callbacks, :fallbacks, :rollbacks] }

          it "returns set with those symbols" do
            expect(command_result).to eq(Set[:callbacks, :fallbacks, :rollbacks])
          end
        end

        context "when `options` contains arrays" do
          let(:options) { Set[:callbacks, [:fallbacks], [:rollbacks]] }

          it "returns set with those arrays flattened" do
            expect(command_result).to eq(Set[:callbacks, :fallbacks, :rollbacks])
          end

          context "when `options` contains nested arrays" do
            let(:options) { Set[:callbacks, [:fallbacks, [:rollbacks]]] }

            it "returns set with those arrays flattened only one level flattened" do
              expect(command_result).to eq(Set[:callbacks, :fallbacks, [:rollbacks]])
            end
          end
        end

        context "when `options` contains sets" do
          let(:options) { Set[:callbacks, Set[:fallbacks], Set[:rollbacks]] }

          it "returns set with those sets flattened" do
            expect(command_result).to eq(Set[:callbacks, :fallbacks, :rollbacks])
          end

          context "when `options` contains nested sets" do
            let(:options) { Set[:callbacks, Set[:fallbacks, Set[:rollbacks]]] }

            it "returns set with those sets only one level flattened" do
              expect(command_result).to eq(Set[:callbacks, :fallbacks, Set[:rollbacks]])
            end
          end
        end

        context "when `options` contains hashes" do
          context "when `options` contains hashes with falsy values" do
            let(:options) { Set[:callbacks, {fallbacks: false}, {rollbacks: nil}] }

            it "returns set without hashes" do
              expect(command_result).to eq(Set[:callbacks])
            end
          end

          context "when `options` contains hashes with truthy values" do
            let(:options) { Set[:callbacks, {fallbacks: true}, {rollbacks: 42}] }

            it "returns set with those hashes keys" do
              expect(command_result).to eq(Set[:callbacks, :fallbacks, :rollbacks])
            end
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
