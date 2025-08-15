# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Support::Command, type: :standard do
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

      ##
      # NOTE: Do NOT use custom RSpec helpers and matchers inside Utils and Support to avoid cyclic module dependencies.
      #
      # rubocop:disable RSpec/MultipleExpectations, RSpec/MessageSpies, RSpec/ExampleLength
      specify do
        expect(ConvenientService).to receive(:raise).and_call_original

        expect { command_instance.call }.to raise_error(described_class::Exceptions::CallIsNotOverridden)
      end
      # rubocop:enable RSpec/MultipleExpectations, RSpec/MessageSpies, RSpec/ExampleLength
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

      ##
      # NOTE: Do NOT use custom RSpec helpers and matchers inside Utils and Support to avoid cyclic module dependencies.
      #
      # rubocop:disable RSpec/MultipleExpectations, RSpec/MessageSpies, RSpec/ExampleLength
      it "delegates to `ConvenientService::Support::Command.new`" do
        expect(command_class)
          .to receive(:new)
            .and_wrap_original { |original, *actual_args, **actual_kwargs, &actual_block|
                expect([actual_args, actual_kwargs, actual_block]).to eq([arguments.args, arguments.kwargs, arguments.block])

                original.call(*actual_args, **actual_kwargs, &actual_block)
              }

        command_class.call(*arguments.args, **arguments.kwargs, &arguments.block)
      end
      # rubocop:enable RSpec/MultipleExpectations, RSpec/MessageSpies, RSpec/ExampleLength

      ##
      # NOTE: Do NOT use custom RSpec helpers and matchers inside Utils and Support to avoid cyclic module dependencies.
      #
      # rubocop:disable RSpec/MultipleExpectations, RSpec/MessageSpies, RSpec/ExampleLength
      it "delegates to `ConvenientService::Support::Command#call`" do
        allow(command_class).to receive(:new).and_return(command_instance)

        expect(command_instance)
          .to receive(:call)
            .and_wrap_original { |original, *actual_args, **actual_kwargs, &actual_block|
                expect([actual_args, actual_kwargs, actual_block]).to eq([[], {}, nil])

                original.call(*actual_args, **actual_kwargs, &actual_block)
              }

        command_class.call(*arguments.args, **arguments.kwargs, &arguments.block)
      end
      # rubocop:enable RSpec/MultipleExpectations, RSpec/MessageSpies, RSpec/ExampleLength

      it "returns `ConvenientService::Support::Command#call` value" do
        expect(command_class.call(*arguments.args, **arguments.kwargs, &arguments.block)).to eq(command_instance.call)
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

      ##
      # NOTE: Do NOT use custom RSpec helpers and matchers inside Utils and Support to avoid cyclic module dependencies.
      #
      # rubocop:disable RSpec/MultipleExpectations, RSpec/MessageSpies, RSpec/ExampleLength
      it "delegates to `ConvenientService::Support::Command.call`" do
        expect(command_class)
          .to receive(:call)
            .and_wrap_original { |original, *actual_args, **actual_kwargs, &actual_block|
                expect([actual_args, actual_kwargs, actual_block]).to eq([arguments.args, arguments.kwargs, arguments.block])

                original.call(*actual_args, **actual_kwargs, &actual_block)
              }

        command_class[*arguments.args, **arguments.kwargs, &arguments.block]
      end
      # rubocop:enable RSpec/MultipleExpectations, RSpec/MessageSpies, RSpec/ExampleLength

      it "returns `ConvenientService::Support::Command#call` value" do
        expect(command_class[*arguments.args, **arguments.kwargs, &arguments.block]).to eq(command_class.call(*arguments.args, **arguments.kwargs, &arguments.block))
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
