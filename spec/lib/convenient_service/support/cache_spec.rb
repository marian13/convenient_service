# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Support::Cache do
  example_group "instance methods" do
    let(:cache) { described_class }

    describe ".create" do
      context "when `backend` is NOT passed" do
        let(:cache) { described_class.create }

        it "defaults `backend` to `:hash`" do
          expect(cache).to be_instance_of(ConvenientService::Support::Cache::Hash)
        end
      end

      context "when `backend` is passed" do
        context "when `backend` is NOT supported" do
          let(:backend) { :not_supported_backend }

          let(:error_message) do
            message = <<~TEXT
              Backend `#{backend}` is NOT supported.

              Supported backends are `:array`, `:hash`.
            TEXT
          end

          it "raises `ConvenientService::Support::Cache::Errors::NotSupportedBackend`" do
            expect { described_class.create(backend: backend) }
              .to raise_error(ConvenientService::Support::Cache::Errors::NotSupportedBackend)
              .with_message(error_message)
          end
        end

        context "when `backend` is supported" do
          context "when `backend` is `:hash`" do
            let(:cache) { described_class.create(backend: :hash) }

            it "creates hash-based cache" do
              expect(cache).to be_instance_of(ConvenientService::Support::Cache::Hash)
            end
          end

          context "when `backend` is `:array`" do
            let(:cache) { described_class.create(backend: :array) }

            it "creates array-based cache" do
              expect(cache).to be_instance_of(ConvenientService::Support::Cache::Array)
            end
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
