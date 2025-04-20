# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/DescribeClass
RSpec.describe ConvenientService::Core::Constants, type: :standard do
  example_group "constants" do
    describe "::Commits::METHOD_MISSING_MAX_TRIES" do
      it "returns `10`" do
        expect(described_class::Commits::METHOD_MISSING_MAX_TRIES).to eq(10)
      end
    end

    describe "::Triggers::INSTANCE_METHOD_MISSING" do
      it "returns `ConvenientService::Support::UniqueValue` instance" do
        expect(described_class::Triggers::INSTANCE_METHOD_MISSING).to be_instance_of(ConvenientService::Support::UniqueValue)
      end

      ##
      # NOTE: This example group is for instance methods of constant, that is why it is nested.
      # TODO: Custom matcher.
      #
      example_group "instance methods" do
        describe "#inspect" do
          it "returns inspect representation" do
            expect(described_class::Triggers::INSTANCE_METHOD_MISSING.inspect).to eq("INSTANCE_METHOD_MISSING")
          end
        end
      end
    end

    describe "::Triggers::CLASS_METHOD_MISSING" do
      it "returns `ConvenientService::Support::UniqueValue` instance" do
        expect(described_class::Triggers::CLASS_METHOD_MISSING).to be_instance_of(ConvenientService::Support::UniqueValue)
      end

      ##
      # NOTE: This example group is for instance methods of constant, that is why it is nested.
      # TODO: Custom matcher.
      #
      example_group "instance methods" do
        describe "#inspect" do
          it "returns inspect representation" do
            expect(described_class::Triggers::CLASS_METHOD_MISSING.inspect).to eq("CLASS_METHOD_MISSING")
          end
        end
      end
    end

    describe "::Triggers::USER" do
      it "returns `ConvenientService::Support::UniqueValue` instance" do
        expect(described_class::Triggers::USER).to be_instance_of(ConvenientService::Support::UniqueValue)
      end

      ##
      # NOTE: This example group is for instance methods of constant, that is why it is nested.
      # TODO: Custom matcher.
      #
      example_group "instance methods" do
        describe "#inspect" do
          it "returns inspect representation" do
            expect(described_class::Triggers::RESOLVE_METHOD_MIDDLEWARES_SUPER_METHOD.inspect).to eq("RESOLVE_METHOD_MIDDLEWARES_SUPER_METHOD")
          end
        end
      end
    end

    describe "::Triggers::RESOLVE_METHOD_MIDDLEWARES_SUPER_METHOD" do
      it "returns `ConvenientService::Support::UniqueValue` instance" do
        expect(described_class::Triggers::RESOLVE_METHOD_MIDDLEWARES_SUPER_METHOD).to be_instance_of(ConvenientService::Support::UniqueValue)
      end

      ##
      # NOTE: This example group is for instance methods of constant, that is why it is nested.
      # TODO: Custom matcher.
      #
      example_group "instance methods" do
        describe "#inspect" do
          it "returns inspect representation" do
            expect(described_class::Triggers::USER.inspect).to eq("USER")
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/DescribeClass
