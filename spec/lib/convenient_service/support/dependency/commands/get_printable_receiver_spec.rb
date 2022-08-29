# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Support::Dependency::Commands::GetPrintableReceiver do
  example_group "class methods" do
    describe ".call" do
      let(:command_result) { described_class.call(receiver: receiver, object: object) }
      let(:receiver) { :foo }

      let(:klass) { Class.new }
      let(:instance) { klass.new }

      let(:mod) { Module.new }
      let(:concern) { Module.new.tap { |mod| mod.include ConvenientService::Support::Concern } }

      context "when `object' type is `instance'" do
        let(:object) { instance }

        context "when `receiver' type is `module'" do
          context "when `receiver' type is NOT `concern'" do
            let(:receiver) { mod }

            it "returns printable version of `receiver'" do
              expect(command_result).to eq("to include(prepend) `#{receiver}'")
            end
          end

          context "when `receiver' type is `concern'" do
            let(:receiver) { concern }

            it "returns printable version of `receiver'" do
              expect(command_result).to eq("to include(prepend) `#{receiver}'")
            end
          end
        end

        context "when `receiver' type is class" do
          let(:receiver) { klass }

          it "returns printable version of `receiver'" do
            expect(command_result).to eq("to inherit `#{receiver}'")
          end
        end
      end

      context "when `object' type is class" do
        let(:object) { klass }

        context "when `receiver' type is `module'" do
          context "when `receiver' type is NOT `concern'" do
            let(:receiver) { mod }

            it "returns printable version of `receiver'" do
              expect(command_result).to eq("to extend(singleton_class.prepend) `#{receiver}'")
            end
          end

          context "when `receiver' type is `concern'" do
            let(:receiver) { concern }

            it "returns printable version of `receiver'" do
              expect(command_result).to eq("to include(prepend) `#{receiver}'")
            end
          end
        end

        context "when `receiver' type is class" do
          let(:receiver) { klass }

          it "returns printable version of `receiver'" do
            expect(command_result).to eq("to inherit `#{receiver}'")
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
