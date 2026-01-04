# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers, RSpec/ExampleLength, RSpec/DescribeClass
RSpec.describe "Positional, keyword and block step inputs", type: [:standard, :e2e] do
  let(:first_step) do
    Class.new.tap do |klass|
      klass.class_exec(out) do |out|
        include ConvenientService::Standard::Config

        define_method(:out) { out }

        attr_reader :args, :kwargs, :block

        def initialize(*args, **kwargs, &block)
          @args = args
          @kwargs = kwargs
          @block = block
        end

        def result
          out.puts "=== Service step ==="
          out.puts "Args              : #{args.join(", ")}."
          out.puts "Kwargs            : #{kwargs.values.join(", ")}."
          out.puts "Block             : #{block.source_location.take(2).join(":")}."
          out.puts "Block value       : #{block.call(*other_args, **other_kwargs, &other_block)}."

          success
        end

        private

        def other_args
          ["Inside service block `args[0]`", "Inside service block `args[1]`"]
        end

        def other_kwargs
          {foo: "Inside service block `kwargs[:foo]`", bar: "Inside service block `kwargs[:bar]`"}
        end

        def other_block
          proc { "Inside service block value" }
        end
      end
    end
  end

  let(:service) do
    Class.new.tap do |klass|
      klass.class_exec(out, first_step) do |out, first_step|
        include ConvenientService::Standard::Config

        define_method(:out) { out }

        step first_step,
          in: [
            0 => -> { "Service `args[0]`" },
            1 => -> { "Service `args[1]`" },
            :foo => -> { "Service `kwargs[:foo]`" },
            :baz => -> { "Service `kwargs[:bar]`" },
            block => -> do
              proc do |*args, **kwargs, &block|
                out.puts "Step block args   : #{args.join(", ")}."
                out.puts "Step block kwargs : #{kwargs.values.join(", ")}."
                out.puts "Step block block  : #{block.source_location.take(2).join(":")}."
                out.puts "Step block value  : #{block.call}."
                out.puts "Organizer value   : #{organizer_method_value}."

                "Service block value"
              end
            end
          ]

        step :method_step_without_arguments

        step :method_step_with_arguments,
          in: [
            0 => -> { "Method `args[0]`" },
            1 => -> { "Method `args[1]`" },
            :foo => -> { "Method `kwargs[:foo]`" },
            :baz => -> { "Method `kwargs[:bar]`" },
            block => -> do
              proc do |*args, **kwargs, &block|
                out.puts "Step block args   : #{args.join(", ")}."
                out.puts "Step block kwargs : #{kwargs.values.join(", ")}."
                out.puts "Step block block  : #{block.source_location.take(2).join(":")}."
                out.puts "Step block value  : #{block.call}."
                out.puts "Organizer value   : #{organizer_method_value}."

                "Method step with arguments block value"
              end
            end
          ]

        def method_step_without_arguments
          out.puts
          out.puts "=== Method step without arguments ==="
          out.puts "Args              : #{args.join(", ")}."
          out.puts "Kwargs            : #{kwargs.values.join(", ")}."
          out.puts "Block             : #{block.source_location.take(2).join(":")}."
          out.puts "Block value       : #{block.call(*other_args, **other_kwargs, &other_block)}."

          success
        end

        def method_step_with_arguments(*args, **kwargs, &block)
          out.puts
          out.puts "=== Method step with arguments ==="
          out.puts "Args              : #{args.join(", ")}."
          out.puts "Kwargs            : #{kwargs.values.join(", ")}."
          out.puts "Block             : #{block.source_location.take(2).join(":")}."
          out.puts "Block value       : #{block.call(*other_args, **other_kwargs, &other_block)}."

          success
        end

        private

        def args
          [
            "Method step without arguments `args[0]`",
            "Method step without arguments `args[1]`"
          ]
        end

        def kwargs
          {
            foo: "Method step without arguments `kwargs[:foo]`",
            bar: "Method step without arguments `kwargs[:bar]`"
          }
        end

        def block
          proc { "Method step without arguments block value" }
        end

        def other_args
          ["Inside method block `args[0]`", "Inside method block `args[1]`"]
        end

        def other_kwargs
          {foo: "Inside method block `kwargs[:foo]`", bar: "Inside method block `kwargs[:bar]`"}
        end

        def other_block
          proc { "Inside method block value" }
        end

        def organizer_method_value
          "Organizer method value"
        end
      end
    end
  end

  let(:out) { Tempfile.new }
  let(:output) { out.tap(&:rewind).read }

  specify do
    service.result

    expect(output).to eq(
      <<~TEXT
        === Service step ===
        Args              : Service `args[0]`, Service `args[1]`.
        Kwargs            : Service `kwargs[:foo]`, Service `kwargs[:bar]`.
        Block             : #{__FILE__}:70.
        Step block args   : Inside service block `args[0]`, Inside service block `args[1]`.
        Step block kwargs : Inside service block `kwargs[:foo]`, Inside service block `kwargs[:bar]`.
        Step block block  : #{__FILE__}:50.
        Step block value  : Inside service block value.
        Organizer value   : Organizer method value.
        Block value       : Service block value.

        === Method step without arguments ===
        Args              : Method step without arguments `args[0]`, Method step without arguments `args[1]`.
        Kwargs            : Method step without arguments `kwargs[:foo]`, Method step without arguments `kwargs[:bar]`.
        Block             : #{__FILE__}:142.
        Block value       : Method step without arguments block value.

        === Method step with arguments ===
        Args              : Method `args[0]`, Method `args[1]`.
        Kwargs            : Method `kwargs[:foo]`, Method `kwargs[:bar]`.
        Block             : #{__FILE__}:91.
        Step block args   : Inside method block `args[0]`, Inside method block `args[1]`.
        Step block kwargs : Inside method block `kwargs[:foo]`, Inside method block `kwargs[:bar]`.
        Step block block  : #{__FILE__}:154.
        Step block value  : Inside method block value.
        Organizer value   : Organizer method value.
        Block value       : Method step with arguments block value.
      TEXT
    )
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers, RSpec/ExampleLength, RSpec/DescribeClass
