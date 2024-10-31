# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Core::Entities::Config::Entities::MethodMiddlewares::Entities::Caller::Commands::GenerateWithoutMiddlewaresName, type: :standard do
  example_group "class methods" do
    describe ".call" do
      let(:command_result) { described_class.call(name: name) }

      context "when `name` is `nil`" do
        let(:name) { nil }

        it "returns empty string" do
          expect(command_result).to eq("")
        end
      end

      context "when `name` is `Symbol`" do
        let(:name) { :foo }

        it "returns name without middlewares" do
          expect(command_result).to eq("foo_without_middlewares")
        end

        context "when `name` ends with `!`" do
          let(:name) { :foo! }

          it "returns name without middlewares" do
            expect(command_result).to eq("foo_without_middlewares!")
          end
        end

        context "when `name` ends with `?`" do
          let(:name) { :foo? }

          it "returns name without middlewares" do
            expect(command_result).to eq("foo_without_middlewares?")
          end
        end

        context "when `name` is empty" do
          let(:name) { :"" }

          it "returns empty string" do
            expect(command_result).to eq("")
          end
        end
      end

      context "when `name` is `String`" do
        let(:name) { "foo" }

        it "returns name without middlewares" do
          expect(command_result).to eq("foo_without_middlewares")
        end

        context "when `name` ends with `!`" do
          let(:name) { "foo!" }

          it "returns name without middlewares" do
            expect(command_result).to eq("foo_without_middlewares!")
          end
        end

        context "when `name` ends with `?`" do
          let(:name) { "foo?" }

          it "returns name without middlewares" do
            expect(command_result).to eq("foo_without_middlewares?")
          end
        end

        context "when `name` is empty" do
          let(:name) { "" }

          it "returns empty string" do
            expect(command_result).to eq("")
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
