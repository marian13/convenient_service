# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/DescribeClass
RSpec.describe ConvenientService::Core::Entities::Config::Entities::MethodMiddlewares::Entities::Middlewares::Base::Constants, type: :standard do
  example_group "constants" do
    describe "::ANY_METHOD" do
      it "returns `ConvenientService::Support::UniqueValue` instance" do
        expect(described_class::ANY_METHOD).to be_instance_of(ConvenientService::Support::UniqueValue)
      end

      ##
      # NOTE: This example group is for instance methods of constant, that is why it is nested.
      # TODO: Custom matcher.
      #
      example_group "instance methods" do
        describe "#inspect" do
          it "returns inspect representation" do
            expect(described_class::ANY_METHOD.inspect).to eq("any_method")
          end
        end
      end
    end

    describe "::ANY_SCOPE" do
      it "returns `ConvenientService::Support::UniqueValue` instance" do
        expect(described_class::ANY_SCOPE).to be_instance_of(ConvenientService::Support::UniqueValue)
      end

      ##
      # NOTE: This example group is for instance methods of constant, that is why it is nested.
      # TODO: Custom matcher.
      #
      example_group "instance methods" do
        describe "#inspect" do
          it "returns inspect representation" do
            expect(described_class::ANY_SCOPE.inspect).to eq("any_scope")
          end
        end
      end
    end

    describe "::ANY_ENTITY" do
      it "returns `ConvenientService::Support::UniqueValue` instance" do
        expect(described_class::ANY_ENTITY).to be_instance_of(ConvenientService::Support::UniqueValue)
      end

      ##
      # NOTE: This example group is for instance methods of constant, that is why it is nested.
      # TODO: Custom matcher.
      #
      example_group "instance methods" do
        describe "#inspect" do
          it "returns inspect representation" do
            expect(described_class::ANY_ENTITY.inspect).to eq("any_entity")
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/DescribeClass
