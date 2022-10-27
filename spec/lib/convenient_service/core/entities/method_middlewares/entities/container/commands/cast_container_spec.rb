# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Core::Entities::MethodMiddlewares::Entities::Container::Commands::CastContainer do
  example_group "class methhods" do
    describe ".call" do
      let(:casted) { described_class.call(other: other) }
      let(:scope) { :instance }
      let(:klass) { Class.new }

      context "when `other` is NOT castable" do
        let(:other) { 42 }

        it "returns `nil`" do
          expect(casted).to be_nil
        end
      end

      context "when `other` is hash" do
        context "when that hash has no `:scope` key" do
          let(:other) { {} }

          it "returns `nil`" do
            expect(casted).to be_nil
          end
        end

        context "when that hash has `:scope` key" do
          context "when value by `:scope` key is NOT castable" do
            let(:other) { {scope: 42} }

            it "returns `nil`" do
              expect(casted).to be_nil
            end
          end

          context "when value by `:scope` key is `:instance`" do
            context "when that hash has no `:klass` key" do
              let(:other) { {scope: :instance} }

              it "returns `nil`" do
                expect(casted).to be_nil
              end
            end

            context "when value by `:klass` key is NOT castable" do
              let(:other) { {scope: :instance, klass: 42} }

              it "returns `nil`" do
                expect(casted).to be_nil
              end
            end

            context "when value by `:klass` key is any class" do
              let(:scope) { :instance }
              let(:klass) { Class.new }

              let(:other) { {scope: scope, klass: klass} }

              it "returns other casted to container" do
                expect(casted).to eq(ConvenientService::Core::Entities::MethodMiddlewares::Entities::Container.new(klass: klass))
              end
            end
          end

          context "when value by `:scope` key is `:class`" do
            context "when that hash has no `:class` key" do
              let(:other) { {scope: :class} }

              it "returns `nil`" do
                expect(casted).to be_nil
              end
            end

            context "when value by `:class` key is NOT castable" do
              let(:other) { {scope: :class, klass: 42} }

              it "returns `nil`" do
                expect(casted).to be_nil
              end
            end

            context "when value by `:class` key is any class" do
              let(:scope) { :class }
              let(:klass) { Class.new }

              let(:other) { {scope: scope, klass: klass} }

              it "returns other casted to container" do
                expect(casted).to eq(ConvenientService::Core::Entities::MethodMiddlewares::Entities::Container.new(klass: klass.singleton_class))
              end
            end
          end
        end
      end

      context "when `other` is container" do
        let(:other) { ConvenientService::Core::Entities::MethodMiddlewares::Entities::Container.cast({scope: scope, klass: klass}) }

        it "returns container copy" do
          expect(casted).to eq(other.copy)
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
