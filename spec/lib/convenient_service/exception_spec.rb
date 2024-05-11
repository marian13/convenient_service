# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Exception, type: :standard do
  example_group "inheritance" do
    include ConvenientService::RSpec::PrimitiveMatchers::BeDescendantOf

    subject { described_class }

    it { is_expected.to be_descendant_of(StandardError) }
  end

  example_group "class methods" do
    describe ".new" do
      context "when NO arguments are passed" do
        let(:exception_class) do
          Class.new(described_class) do
            def initialize_without_arguments
              initialize("initialize_without_arguments message")
            end
          end
        end

        let(:message) { "initialize_without_arguments message" }

        it "delegates to `#initialize_without_arguments`" do
          expect(exception_class.new.message).to eq(message)
        end
      end

      context "when `message` is passed" do
        let(:exception_class) { Class.new(described_class) }
        let(:message) { "foo" }

        it "delegates to `StandartError#initialize`" do
          expect(exception_class.new(message).message).to eq(message)
        end
      end

      context "when `kwargs` are passed" do
        let(:exception_class) do
          Class.new(described_class) do
            def initialize_with_kwargs(**kwargs)
              initialize("initialize_with_kwargs #{kwargs}")
            end
          end
        end

        let(:kwargs) { {foo: :bar} }
        let(:message) { "initialize_with_kwargs #{kwargs}" }

        it "delegates to `#initialize_with_kwargs`" do
          expect(exception_class.new(**kwargs).message).to eq(message)
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
