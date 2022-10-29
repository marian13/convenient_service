# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Core::Entities::Concerns::Entities::Middleware::Commands::CastMiddleware do
  example_group "class methhods" do
    describe ".call" do
      let(:casted) { described_class.call(other: other) }

      context "when `other` is NOT castable" do
        let(:other) { 42 }

        it "returns `nil`" do
          expect(casted).to be_nil
        end
      end

      context "when `other` is Class" do
        context "when Class is NOT `ConvenientService::Core::Entities::Concerns::Entities::Middleware` descendant" do
          let(:other) { Class.new }

          it "returns `nil`" do
            expect(casted).to be_nil
          end
        end

        context "when Class is `ConvenientService::Core::Entities::Concerns::Entities::Middleware` descendant" do
          let(:other) do
            ::Class.new(ConvenientService::Core::Entities::Concerns::Entities::Middleware).tap do |klass|
              klass.class_exec(Module.new) do |mod|
                define_singleton_method(:concern) { mod }
              end
            end
          end

          it "returns middleware copy" do
            expect(casted).to eq(other.dup)
          end
        end
      end

      context "when `other` is Module" do
        let(:other) { Module.new }

        let(:middleware) do
          ::Class.new(ConvenientService::Core::Entities::Concerns::Entities::Middleware).tap do |klass|
            klass.class_exec(other) do |mod|
              define_singleton_method(:concern) { mod }
            end
          end
        end

        it "returns other casted to middleware" do
          expect(casted).to eq(middleware)
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
