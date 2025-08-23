# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Support::Middleware::StackBuilder::Entities::Builders::Stateful, type: :standard do
  let(:stack_builder) { described_class.new(name: name, stack: stack) }

  let(:stack) { [] }
  let(:name) { "Stack" }

  example_group "inheritance" do
    ##
    # NOTE: Do NOT use custom RSpec helpers and matchers inside Utils and Support to avoid cyclic module dependencies.
    #
    specify { expect(described_class < ConvenientService::Support::Middleware::StackBuilder::Entities::Builders::Custom).to eq(true) }
  end

  example_group "instance methods" do
    ##
    # TODO: Comprehensive specs.
    #
    describe "#call" do
      example_group "e2e" do
        let(:service) do
          Class.new do
            include ConvenientService::Standard::Config

            step :foo
            step :bar
            step :baz

            def foo
              success
            end

            def bar
              success
            end

            def baz
              success
            end
          end
        end

        before do
          stub_const("ConvenientService::Support::Middleware::StackBuilder::Constants::Backends::DEFAULT", ConvenientService::Support::Middleware::StackBuilder::Constants::Backends::STATEFUL)
        end

        it "runs middleware stack" do
          expect(service.result.success?).to eq(true)
        end
      end

      context "when stack is empty" do
        let(:stack) { [] }
        let(:env) { {} }

        it "returns `env`" do
          expect(stack_builder.call(env).object_id).to eq(env.object_id)
        end
      end

      ##
      # TODO: More direct specs.
      ##
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
