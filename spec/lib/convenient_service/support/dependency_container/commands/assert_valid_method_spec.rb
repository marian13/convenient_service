# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Support::DependencyContainer::Commands::AssertValidMethod do
  example_group "class methods" do
    describe ".call" do
      subject(:command_result) { described_class.call(full_name: :foo, scope: :class, from: container, method: method) }

      let(:full_name) { :foo }
      let(:scope) { :class }
      let(:container) { Module.new }

      context "when `method` is NOT valid" do
        let(:method) { nil }

        let(:error_message) do
          <<~TEXT
            Module `#{container}` does NOT export method `#{full_name}` with `#{scope}` scope.

            Did you forget to export it from `#{container}`? For example:

            module #{container}
              export #{full_name}, scope: :#{scope} do |*args, **kwargs, &block|
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

      context "when `method` is valid" do
        let(:method) { ConvenientService::Support::DependencyContainer::Entities::Method.new(full_name: full_name, scope: scope, body: body) }
        let(:body) { proc { :bar } }

        it "does NOT raise" do
          expect { command_result }.not_to raise_error
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
