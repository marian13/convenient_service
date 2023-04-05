# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Support::Cache do
  example_group "instance methods" do
    let(:cache) { described_class }

    describe ".create" do
      context "when type is NOT supported" do
        let(:bad_type) { :bad_type }
        let(:error_message) { "Invalid cache type: #{bad_type}." }

        it "raises ConvenientService::Support::Cache::Errors::NotSupportedType" do
          expect { described_class.create(type: bad_type) }
            .to raise_error(ConvenientService::Support::Cache::Errors::NotSupportedType)
            .with_message(error_message)
        end
      end

      context "when type is supported" do
        context "when cache hash-based" do
          it "creates a hash-based cache by default" do
            cache = described_class.create
            expect(cache).to be_a ConvenientService::Support::Cache::Hash
          end

          it "creates a hash-based cache when type is a `:hash`" do
            cache = described_class.create(type: :hash)
            expect(cache).to be_a ConvenientService::Support::Cache::Hash
          end
        end

        context "when cache array-based" do
          it "creates an array-based cache when type is a `:array`" do
            cache = described_class.create(type: :array)
            expect(cache).to be_a ConvenientService::Support::Cache::Array
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
