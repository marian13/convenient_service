# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Support::Middleware::StackBuilder, type: :standard do
  include ConvenientService::RSpec::Matchers::DelegateTo

  example_group "class methods" do
    describe ".new" do
      specify do
        expect { described_class.new }
          .to delegate_to(described_class, :backed_by)
          .with_arguments(ConvenientService::Support::Middleware::StackBuilder::Constants::Backends::DEFAULT)
      end

      it "returns `ConvenientService::Support::Middleware::StackBuilder.backed_by(ConvenientService::Support::Middleware::StackBuilder::Constants::Backends::DEFAULT)` instance" do
        expect(described_class.new).to eq(described_class.backed_by(ConvenientService::Support::Middleware::StackBuilder::Constants::Backends::DEFAULT).new)
      end

      context "when `kwargs` are passed" do
        let(:kwargs) { {name: "Stack", stack: []} }

        it "passes those `kwargs` to `new`" do
          expect(described_class.new(**kwargs)).to eq(described_class.backed_by(ConvenientService::Support::Middleware::StackBuilder::Constants::Backends::DEFAULT).new(**kwargs))
        end
      end
    end

    describe ".backed_by" do
      context "when `backend` is NOT valid" do
        let(:backend) { :foo }

        let(:exception_message) do
          <<~TEXT
            Middleware backend `#{backend.inspect}` is NOT supported.

            Supported backends are #{ConvenientService::Support::Middleware::StackBuilder::Constants::Backends::ALL.map { |backend| "`#{backend.inspect}`" }.join(", ")}.
          TEXT
        end

        it "raises `ConvenientService::Support::Middleware::StackBuilder::Exceptions::NotSupportedBackend`" do
          expect { described_class.backed_by(backend) }
            .to raise_error(ConvenientService::Support::Middleware::StackBuilder::Exceptions::NotSupportedBackend)
            .with_message(exception_message)
        end

        ##
        # NOTE: Do NOT use custom RSpec helpers and matchers inside Utils and Support to avoid cyclic module dependencies.
        #
        # rubocop:disable RSpec/MultipleExpectations, RSpec/MessageSpies
        specify do
          expect(ConvenientService).to receive(:raise).and_call_original

          expect { described_class.backed_by(backend) }.to raise_error(ConvenientService::Support::Middleware::StackBuilder::Exceptions::NotSupportedBackend)
        end
        # rubocop:enable RSpec/MultipleExpectations, RSpec/MessageSpies
      end

      context "when `backend` is valid" do
        context "when `backend` is `ConvenientService::Support::Middleware::StackBuilder::Constants::Backends::RUBY_MIDDLEWARE`" do
          it "returns `ConvenientService::Support::Middleware::StackBuilder::Entities::Builders::RubyMiddleware`" do
            expect(described_class.backed_by(ConvenientService::Support::Middleware::StackBuilder::Constants::Backends::RUBY_MIDDLEWARE)).to eq(ConvenientService::Support::Middleware::StackBuilder::Entities::Builders::RubyMiddleware)
          end
        end

        context "when `backend` is `ConvenientService::Support::Middleware::StackBuilder::Constants::Backends::RACK`" do
          it "returns `ConvenientService::Support::Middleware::StackBuilder::Entities::Builders::Rack`" do
            expect(described_class.backed_by(ConvenientService::Support::Middleware::StackBuilder::Constants::Backends::RACK)).to eq(ConvenientService::Support::Middleware::StackBuilder::Entities::Builders::Rack)
          end
        end

        context "when `backend` is `ConvenientService::Support::Middleware::StackBuilder::Constants::Backends::STATEFUL`" do
          it "returns `ConvenientService::Support::Middleware::StackBuilder::Entities::Builders::Stateful`" do
            expect(described_class.backed_by(ConvenientService::Support::Middleware::StackBuilder::Constants::Backends::STATEFUL)).to eq(ConvenientService::Support::Middleware::StackBuilder::Entities::Builders::Stateful)
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
