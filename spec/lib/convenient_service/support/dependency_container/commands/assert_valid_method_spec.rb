# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Support::DependencyContainer::Commands::AssertValidMethod, type: :standard do
  include ConvenientService::RSpec::Matchers::DelegateTo

  example_group "class methods" do
    describe ".call" do
      subject(:command_result) { described_class.call(slug: slug, scope: scope, container: container) }

      let(:slug) { :foo }
      let(:scope) { :class }

      context "when `method` is NOT exported" do
        let(:container) do
          Module.new do
            include ConvenientService::DependencyContainer::Export
          end
        end

        let(:exception_message) do
          <<~TEXT
            Module `#{container}` does NOT export method `#{slug}` with `#{scope}` scope.

            Did you forget to export it from `#{container}`? For example:

            module #{container}
              export #{slug}, scope: :#{scope} do |*args, **kwargs, &block|
                # ...
              end
            end
          TEXT
        end

        it "raises `ConvenientService::Support::DependencyContainer::Exceptions::NotExportedMethod`" do
          expect { command_result }
            .to raise_error(ConvenientService::Support::DependencyContainer::Exceptions::NotExportedMethod)
            .with_message(exception_message)
        end

        ##
        # NOTE: Do NOT use custom RSpec helpers and matchers inside Utils and Support to avoid cyclic module dependencies.
        #
        # rubocop:disable RSpec/MultipleExpectations, RSpec/MessageSpies, RSpec/ExampleLength
        specify do
          expect(ConvenientService).to receive(:raise).and_call_original

          expect { command_result }.to raise_error(ConvenientService::Support::DependencyContainer::Exceptions::NotExportedMethod)
        end
        # rubocop:enable RSpec/MultipleExpectations, RSpec/MessageSpies, RSpec/ExampleLength
      end

      context "when `method` is exported" do
        let(:container) do
          Module.new do
            include ConvenientService::DependencyContainer::Export

            export :foo, scope: :class do
              ":foo with scope: :class"
            end
          end
        end

        it "does NOT raise" do
          expect { command_result }.not_to raise_error
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
