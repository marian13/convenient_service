# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Support::Command do
  include ConvenientService::RSpec::Helpers::IgnoringException

  include ConvenientService::RSpec::Matchers::DelegateTo

  let(:command_class) { Class.new(described_class) }
  let(:command_instance) { command_class.new(*arguments.args, **arguments.kwargs, &arguments.block) }
  let(:arguments) { ConvenientService::Support::Arguments.new(:foo, foo: :bar) { :foo } }

  example_group "instance methods" do
    describe "#call" do
      let(:exception_message) do
        <<~TEXT
          Call method (#call) of `#{command_class}` is NOT overridden.
        TEXT
      end

      it "raises `ConvenientService::Support::Command::Exceptions::CallIsNotOverridden`" do
        expect { command_instance.call }
          .to raise_error(described_class::Exceptions::CallIsNotOverridden)
          .with_message(exception_message)
      end

      specify do
        expect { ignoring_exception(described_class::Exceptions::CallIsNotOverridden) { command_instance.call } }
          .to delegate_to(ConvenientService, :raise)
      end
    end
  end

  example_group "class methods" do
    describe ".new" do
      it "accepts *args, **kwargs and &block" do
        expect { command_class.new(*arguments.args, **arguments.kwargs, &arguments.block) }.not_to raise_error
      end
    end

    describe ".call" do
      let(:command_class) do
        Class.new(described_class) do
          def call
            42
          end
        end
      end

      let(:command_instance) { command_class.allocate }

      specify do
        expect { command_class.call(*arguments.args, **arguments.kwargs, &arguments.block) }
          .to delegate_to(command_class, :new)
          .with_arguments(*arguments.args, **arguments.kwargs, &arguments.block)
      end

      specify do
        allow(command_class).to receive(:new).and_return(command_instance)

        expect { command_class.call(*arguments.args, **arguments.kwargs, &arguments.block) }
          .to delegate_to(command_instance, :call)
          .without_arguments
          .and_return_its_value
      end
    end

    describe ".[]" do
      let(:command_class) do
        Class.new(described_class) do
          def call
            42
          end
        end
      end

      specify do
        expect { command_class[*arguments.args, **arguments.kwargs, &arguments.block] }
          .to delegate_to(command_class, :call)
          .with_arguments(*arguments.args, **arguments.kwargs, &arguments.block)
          .and_return_its_value
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
