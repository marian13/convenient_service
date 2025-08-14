# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Support::Cache, type: :standard do
  include ConvenientService::RSpec::Matchers::DelegateTo

  example_group "class methods" do
    describe ".new" do
      specify do
        expect { described_class.new }
          .to delegate_to(described_class, :backed_by)
          .with_arguments(ConvenientService::Support::Cache::Constants::Backends::DEFAULT)
      end

      it "returns `ConvenientService::Support::Cache.backed_by(ConvenientService::Support::Cache::Constants::Backends::DEFAULT)` instance" do
        expect(described_class.new).to eq(described_class.backed_by(ConvenientService::Support::Cache::Constants::Backends::DEFAULT).new)
      end

      context "when `kwargs` are passed" do
        let(:kwargs) { {store: {bar: :baz}, parent: described_class.new, key: :foo} }

        it "passes those `kwargs` to `new`" do
          expect(described_class.new(**kwargs)).to eq(described_class.backed_by(ConvenientService::Support::Cache::Constants::Backends::DEFAULT).new(**kwargs))
        end
      end
    end

    describe ".backed_by" do
      context "when `backend` is NOT valid" do
        let(:backend) { :foo }

        let(:exception_message) do
          <<~TEXT
            Backend `#{backend.inspect}` is NOT supported.

            Supported backends are #{ConvenientService::Support::Cache::Constants::Backends::ALL.map { |backend| "`#{backend.inspect}`" }.join(", ")}.
          TEXT
        end

        it "raises `ConvenientService::Support::Cache::Exceptions::NotSupportedBackend`" do
          expect { described_class.backed_by(backend) }
            .to raise_error(ConvenientService::Support::Cache::Exceptions::NotSupportedBackend)
            .with_message(exception_message)
        end

        ##
        # NOTE: Do NOT use custom RSpec helpers and matchers inside Utils and Support to avoid cyclic module dependencies.
        #
        # rubocop:disable RSpec/MultipleExpectations, RSpec/MessageSpies
        specify do
          expect(ConvenientService).to receive(:raise).and_call_original

          expect { described_class.backed_by(backend) }.to raise_error(ConvenientService::Support::Cache::Exceptions::NotSupportedBackend)
        end
        # rubocop:enable RSpec/MultipleExpectations, RSpec/MessageSpies
      end

      context "when `backend` is valid" do
        context "when `backend` is `ConvenientService::Support::Cache::Constants::Backends::ARRAY`" do
          it "returns `ConvenientService::Support::Cache::Entities::Caches::Array`" do
            expect(described_class.backed_by(ConvenientService::Support::Cache::Constants::Backends::ARRAY)).to eq(ConvenientService::Support::Cache::Entities::Caches::Array)
          end
        end

        context "when `backend` is `ConvenientService::Support::Cache::Constants::Backends::HASH`" do
          it "returns `ConvenientService::Support::Cache::Entities::Caches::Hash`" do
            expect(described_class.backed_by(ConvenientService::Support::Cache::Constants::Backends::HASH)).to eq(ConvenientService::Support::Cache::Entities::Caches::Hash)
          end
        end

        context "when `backend` is `ConvenientService::Support::Cache::Constants::Backends::THREAD_SAFE_ARRAY`" do
          it "returns `ConvenientService::Support::Cache::Entities::Caches::ThreadSafeArray`" do
            expect(described_class.backed_by(ConvenientService::Support::Cache::Constants::Backends::THREAD_SAFE_ARRAY)).to eq(ConvenientService::Support::Cache::Entities::Caches::ThreadSafeArray)
          end
        end

        context "when `backend` is `ConvenientService::Support::Cache::Constants::Backends::THREAD_SAFE_HASH`" do
          it "returns `ConvenientService::Support::Cache::Entities::Caches::ThreadSafeHash`" do
            expect(described_class.backed_by(ConvenientService::Support::Cache::Constants::Backends::THREAD_SAFE_HASH)).to eq(ConvenientService::Support::Cache::Entities::Caches::ThreadSafeHash)
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
