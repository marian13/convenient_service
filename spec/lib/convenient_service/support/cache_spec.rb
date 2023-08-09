# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Support::Cache do
  example_group "class methods" do
    describe ".create" do
      let(:cache) { described_class.create(backend: backend) }

      let(:backend) { ConvenientService::Support::Cache::Constants::Backends::HASH }

      context "when `backend` is NOT passed" do
        let(:cache) { described_class.create }

        it "defaults `backend` to `:hash`" do
          expect(cache).to be_instance_of(ConvenientService::Support::Cache::Entities::Caches::Hash)
        end
      end

      context "when `backend` is passed" do
        context "when `backend` is NOT supported" do
          let(:backend) { :not_supported_backend }

          let(:exception_message) do
            <<~TEXT
              Backend `#{backend}` is NOT supported.

              Supported backends are `:array`, `:hash`, `:thread_safe_array`.
            TEXT
          end

          it "raises `ConvenientService::Support::Cache::Exceptions::NotSupportedBackend`" do
            expect { cache }
              .to raise_error(ConvenientService::Support::Cache::Exceptions::NotSupportedBackend)
              .with_message(exception_message)
          end
        end

        context "when `backend` is supported" do
          context "when `backend` is `:hash`" do
            let(:backend) { ConvenientService::Support::Cache::Constants::Backends::HASH }

            it "creates hash-based cache" do
              expect(cache).to be_instance_of(ConvenientService::Support::Cache::Entities::Caches::Hash)
            end
          end

          context "when `backend` is `:array`" do
            let(:backend) { ConvenientService::Support::Cache::Constants::Backends::ARRAY }

            it "creates array-based cache" do
              expect(cache).to be_instance_of(ConvenientService::Support::Cache::Entities::Caches::Array)
            end
          end

          context "when `backend` is `:thread_safe_array`" do
            let(:backend) { ConvenientService::Support::Cache::Constants::Backends::THREAD_SAFE_ARRAY }

            it "creates thread safe array-based cache" do
              expect(cache).to be_instance_of(ConvenientService::Support::Cache::Entities::Caches::ThreadSafeArray)
            end
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
