# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Common::Plugins::CanHaveUserProvidedEntity::Commands::FindOrCreateEntity do
  example_group "class methods" do
    describe ".call" do
      include ConvenientService::RSpec::PrimitiveMatchers::BeDescendantOf
      include ConvenientService::RSpec::Matchers::IncludeModule

      subject(:command_result) { described_class.call(namespace: namespace, proto_entity: proto_entity) }

      let(:namespace) { Class.new }

      let(:proto_entity) do
        Class.new do
          # rubocop:disable Lint/ConstantDefinitionInBlock, RSpec/LeakyConstantDeclaration
          module self::Concern
          end
          # rubocop:enable Lint/ConstantDefinitionInBlock, RSpec/LeakyConstantDeclaration

          def self.name
            "ProtoEntity"
          end
        end
      end

      context "when `proto_entity` does NOT have name" do
        let(:proto_entity) do
          Class.new do
            # rubocop:disable Lint/ConstantDefinitionInBlock, RSpec/LeakyConstantDeclaration
            module self::Concern
            end
            # rubocop:enable Lint/ConstantDefinitionInBlock, RSpec/LeakyConstantDeclaration

            def self.name
              nil
            end
          end
        end

        let(:exception_message) do
          <<~TEXT
            Proto entity `#{proto_entity}` has no name.

            In other words:

              proto_entity.name
              # => nil

            NOTE: Anonymous classes do NOT have names. Are you passing an anonymous class?
          TEXT
        end

        it "raises `ConvenientService::Common::Plugins::CanHaveUserProvidedEntity::Exceptions::ProtoEntityHasNoName`" do
          expect { command_result }
            .to raise_error(ConvenientService::Common::Plugins::CanHaveUserProvidedEntity::Exceptions::ProtoEntityHasNoName)
            .with_message(exception_message)
        end
      end

      context "when `proto_entity` does NOT have concern" do
        let(:proto_entity) do
          Class.new do
            def self.name
              "ProtoEntity"
            end
          end
        end

        let(:exception_message) do
          <<~TEXT
            Proto entity `#{proto_entity}` has no concern.

            Have a look at `ConvenientService::Service::Plugins::HasJSendResult::Entities::Result`.

            It is an example of a valid proto entity.
          TEXT
        end

        it "raises `ConvenientService::Common::Plugins::CanHaveUserProvidedEntity::Exceptions::ProtoEntityHasNoConcern`" do
          expect { command_result }
            .to raise_error(ConvenientService::Common::Plugins::CanHaveUserProvidedEntity::Exceptions::ProtoEntityHasNoConcern)
            .with_message(exception_message)
        end
      end

      context "when `namespace` does NOT have it own `entity`" do
        let(:namespace) { Class.new }

        it "returns `Class` instance" do
          expect(command_result).to be_instance_of(Class)
        end

        it "returns `proto_entity` descendant" do
          expect(command_result).to be_descendant_of(proto_entity)
        end

        it "includes `ConvenientService::Core`" do
          expect(command_result).to include_module(ConvenientService::Core)
        end

        it "includes `proto_entity::Concern`" do
          expect(command_result).to include_module(proto_entity::Concern)
        end
      end

      context "when `namespace` has its own `entity`" do
        let(:namespace) do
          Class.new.tap do |namespace|
            namespace.const_set(:Result, described_class.call(namespace: namespace, proto_entity: proto_entity))
          end
        end

        it "returns `Class` instance" do
          expect(command_result).to be_instance_of(Class)
        end

        it "returns that own `entity`" do
          expect(command_result).to eq(namespace::Result)
        end

        it "includes `ConvenientService::Core`" do
          expect(command_result).to include_module(ConvenientService::Core)
        end

        it "includes `proto_entity::Concern`" do
          expect(command_result).to include_module(proto_entity::Concern)
        end
      end

      example_group "entity" do
        let(:entity) { described_class.call(namespace: namespace, proto_entity: proto_entity) }

        example_group "class methods" do
          describe ".proto_entity" do
            it "returns `proto_entity` passed to `ConvenientService::Common::Plugins::CanHaveUserProvidedEntity::Commands::FindOrCreateEntity`" do
              expect(entity.proto_entity).to eq(proto_entity)
            end
          end

          describe ".==" do
            context "when `other` does NOT respond to `proto_entity`" do
              let(:other) { 42 }

              it "returns `nil`" do
                expect(entity == other).to be_nil
              end
            end

            context "when `other` has different `proto_entity`" do
              let(:other_proto_entity) do
                Class.new do
                  # rubocop:disable Lint/ConstantDefinitionInBlock, RSpec/LeakyConstantDeclaration
                  module self::Concern
                  end
                  # rubocop:enable Lint/ConstantDefinitionInBlock, RSpec/LeakyConstantDeclaration

                  def self.name
                    "OtherProtoEntity"
                  end
                end
              end

              let(:other) { described_class.call(namespace: namespace, proto_entity: other_proto_entity) }

              it "returns `false`" do
                expect(entity == other).to eq(false)
              end
            end

            context "when `other` has same attributes" do
              let(:other) { described_class.call(namespace: namespace, proto_entity: proto_entity) }

              it "returns true" do
                expect(entity == other).to eq(true)
              end
            end
          end
        end

        ##
        # TODO: Specs for autogenerated `#inspect`.
        #
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
