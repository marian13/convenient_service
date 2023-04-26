# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Support::DependencyContainer::Commands::AssertValidMethod do
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

        let(:error_message) do
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

        it "raises `ConvenientService::Support::DependencyContainer::Errors::NotExportedMethod`" do
          expect { command_result }
            .to raise_error(ConvenientService::Support::DependencyContainer::Errors::NotExportedMethod)
            .with_message(error_message)
        end
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
