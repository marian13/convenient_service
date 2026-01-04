# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers, RSpec/ExampleLength, RSpec/DescribeClass
RSpec.describe "Loose method step arguments", type: [:standard, :e2e] do
  include ConvenientService::RSpec::Matchers::Results

  let(:service) do
    Class.new.tap do |klass|
      klass.class_exec(inside_block, outside_block) do |inside_block, outside_block|
        include ConvenientService::Standard::Config

        private

        def args_from_arguments(*args)
          case args.size
          when 2
            args
          when 1
            args + ["Inside `arg2`"]
          when 0
            ["Inside `arg1`", "Inside `arg2`"]
          end
        end

        def kwargs_from_arguments(**kwargs)
          case kwargs.size
          when 2
            kwargs
          when 1
            kwargs.merge(bar: "Inside `kwarg2`")
          when 0
            {foo: "Inside `kwarg1`", bar: "Inside `kwarg2`"}
          end
        end

        def block_from_arguments(&block)
          block&.source_location || inside_block.source_location
        end

        define_method(:inside_block) { inside_block }
        define_method(:outside_block) { outside_block }
      end
    end
  end

  let(:inside_block) do
    proc { "Inside `block` value" }.tap do |object|
      object.define_singleton_method(:inspect) do
        "Inside `block`".inspect
      end
    end
  end

  let(:outside_block) do
    proc { "Outside `block` value" }.tap do |object|
      object.define_singleton_method(:inspect) do
        "Outside `block`".inspect
      end
    end
  end

  example_group "no arguments" do
    context "when method definition - ()" do
      before do
        service.class_exec do
          def method_step
            success(args: args_from_arguments, kwargs: kwargs_from_arguments, block: block_from_arguments)
          end
        end
      end

      context "when step definition - ()" do
        before do
          service.step :method_step
        end

        it "uses proper loose arguments" do
          expect(service.result).to be_success.with_data(
            args: ["Inside `arg1`", "Inside `arg2`"],
            kwargs: {foo: "Inside `kwarg1`", bar: "Inside `kwarg2`"},
            block: inside_block.source_location
          )
        end
      end

      context "when step definition (first)" do
        before do
          service.step :method_step,
            in: [
              0 => -> { "Outside `arg1`" }
            ]
        end

        it "uses proper loose arguments" do
          expect(service.result).to be_success.with_data(
            args: ["Inside `arg1`", "Inside `arg2`"],
            kwargs: {foo: "Inside `kwarg1`", bar: "Inside `kwarg2`"},
            block: inside_block.source_location
          )
        end
      end

      context "when step definition (foo:)" do
        before do
          service.step :method_step,
            in: [
              foo: -> { "Outside `kwarg1`" }
            ]
        end

        it "uses proper loose arguments" do
          expect(service.result).to be_success.with_data(
            args: ["Inside `arg1`", "Inside `arg2`"],
            kwargs: {foo: "Inside `kwarg1`", bar: "Inside `kwarg2`"},
            block: inside_block.source_location
          )
        end
      end

      context "when step definition (&block)" do
        before do
          service.step :method_step,
            in: [
              service.block => -> { outside_block }
            ]
        end

        it "uses proper loose arguments" do
          expect(service.result).to be_success.with_data(
            args: ["Inside `arg1`", "Inside `arg2`"],
            kwargs: {foo: "Inside `kwarg1`", bar: "Inside `kwarg2`"},
            block: inside_block.source_location
          )
        end
      end
    end
  end

  example_group "args" do
    context "when method definition - (first)" do
      before do
        service.class_exec do
          def method_step(first)
            success(args: args_from_arguments(first))
          end
        end
      end

      context "when step definition - ()" do
        before do
          service.step :method_step
        end

        if ConvenientService::Dependencies.ruby.version > 3.0
          it "raise `ArgumentError`" do
            expect { service.result }.to raise_error(ArgumentError).with_message("wrong number of arguments (given 0, expected 1)")
          end
        else
          ##
          # HACK: Ruby 2.7 `(*args, **kwargs)` unexpected behaviour.
          #
          it "uses unpredicatble loose args" do
            expect(service.result).to be_success.with_data(args: [{}, "Inside `arg2`"])
          end
        end
      end

      context "when step definition - (first)" do
        before do
          service.step :method_step,
            in: [
              0 => -> { "Outside `arg1`" }
            ]
        end

        it "uses proper loose args" do
          expect(service.result).to be_success.with_data(args: ["Outside `arg1`", "Inside `arg2`"])
        end
      end

      context "when step definition - (first, second)" do
        before do
          service.step :method_step,
            in: [
              0 => -> { "Outside `arg1`" },
              1 => -> { "Outside `arg2`" }
            ]
        end

        it "uses proper loose args" do
          expect(service.result).to be_success.with_data(args: ["Outside `arg1`", "Inside `arg2`"])
        end
      end
    end

    context "when method definition - (first = 'Default `arg1`')" do
      before do
        service.class_exec do
          def method_step(first = "Default `arg1`")
            success(args: args_from_arguments(first))
          end
        end
      end

      context "when step definition - ()" do
        before do
          service.step :method_step
        end

        it "uses proper loose args" do
          expect(service.result).to be_success.with_data(args: ["Default `arg1`", "Inside `arg2`"])
        end
      end

      context "when step definition - (first)" do
        before do
          service.step :method_step,
            in: [
              0 => -> { "Outside `arg1`" }
            ]
        end

        it "uses proper loose args" do
          expect(service.result).to be_success.with_data(args: ["Outside `arg1`", "Inside `arg2`"])
        end
      end

      context "when step definition - (first, second)" do
        before do
          service.step :method_step,
            in: [
              0 => -> { "Outside `arg1`" },
              1 => -> { "Outside `arg2`" }
            ]
        end

        it "uses proper loose args" do
          expect(service.result).to be_success.with_data(args: ["Outside `arg1`", "Inside `arg2`"])
        end
      end
    end

    context "when method definition - (first, second)" do
      before do
        service.class_exec do
          def method_step(first, second)
            success(args: args_from_arguments(first, second))
          end
        end
      end

      context "when step definition - ()" do
        before do
          service.step :method_step
        end

        it "raise `ArgumentError`" do
          expect { service.result }.to raise_error(ArgumentError).with_message("wrong number of arguments (given 0, expected 2)")
        end
      end

      context "when step definition - (first)" do
        before do
          service.step :method_step,
            in: [
              0 => -> { "Outside `arg1`" }
            ]
        end

        if ConvenientService::Dependencies.ruby.version > 3.0
          it "raise `ArgumentError`" do
            expect { service.result }.to raise_error(ArgumentError).with_message("wrong number of arguments (given 1, expected 2)")
          end
        else
          ##
          # HACK: Ruby 2.7 `(*args, **kwargs)` unexpected behaviour.
          #
          it "uses unpredicatble loose args" do
            expect(service.result).to be_success.with_data(args: ["Outside `arg1`", {}])
          end
        end
      end

      context "when step definition - (first, second)" do
        before do
          service.step :method_step,
            in: [
              0 => -> { "Outside `arg1`" },
              1 => -> { "Outside `arg2`" }
            ]
        end

        it "uses proper loose args" do
          expect(service.result).to be_success.with_data(args: ["Outside `arg1`", "Outside `arg2`"])
        end
      end
    end

    context "when method definition - (first, second = 'Default `arg2`')" do
      before do
        service.class_exec do
          def method_step(first, second = "Default `arg2`")
            success(args: args_from_arguments(first, second))
          end
        end
      end

      context "when step definition - ()" do
        before do
          service.step :method_step
        end

        if ConvenientService::Dependencies.ruby.version > 3.0
          it "raise `ArgumentError`" do
            expect { service.result }.to raise_error(ArgumentError).with_message("wrong number of arguments (given 0, expected 1..2)")
          end
        else
          ##
          # HACK: Ruby 2.7 `(*args, **kwargs)` unexpected behaviour.
          #
          it "uses unpredicatble loose args" do
            expect(service.result).to be_success.with_data(args: [{}, "Default `arg2`"])
          end
        end
      end

      context "when step definition - (first)" do
        before do
          service.step :method_step,
            in: [
              0 => -> { "Outside `arg1`" }
            ]
        end

        it "uses proper loose args" do
          expect(service.result).to be_success.with_data(args: ["Outside `arg1`", "Default `arg2`"])
        end
      end

      context "when step definition - (first, second)" do
        before do
          service.step :method_step,
            in: [
              0 => -> { "Outside `arg1`" },
              1 => -> { "Outside `arg2`" }
            ]
        end

        it "uses proper loose args" do
          expect(service.result).to be_success.with_data(args: ["Outside `arg1`", "Outside `arg2`"])
        end
      end
    end

    context "when method definition - (first = 'Default `arg1`', second = 'Default `arg2`')" do
      before do
        service.class_exec do
          def method_step(first = "Default `arg1`", second = "Default `arg2`")
            success(args: args_from_arguments(first, second))
          end
        end
      end

      context "when step definition - ()" do
        before do
          service.step :method_step
        end

        it "uses proper loose args" do
          expect(service.result).to be_success.with_data(args: ["Default `arg1`", "Default `arg2`"])
        end
      end

      context "when step definition - (first)" do
        before do
          service.step :method_step,
            in: [
              0 => -> { "Outside `arg1`" }
            ]
        end

        it "uses proper loose args" do
          expect(service.result).to be_success.with_data(args: ["Outside `arg1`", "Default `arg2`"])
        end
      end

      context "when step definition - (first, second)" do
        before do
          service.step :method_step,
            in: [
              0 => -> { "Outside `arg1`" },
              1 => -> { "Outside `arg2`" }
            ]
        end

        it "uses proper loose args" do
          expect(service.result).to be_success.with_data(args: ["Outside `arg1`", "Outside `arg2`"])
        end
      end
    end

    context "when method definition - (*args)" do
      before do
        service.class_exec do
          def method_step(*args)
            success(args: args_from_arguments(*args))
          end
        end
      end

      context "when step definition - ()" do
        before do
          service.step :method_step
        end

        it "uses proper loose args" do
          expect(service.result).to be_success.with_data(args: ["Inside `arg1`", "Inside `arg2`"])
        end
      end

      context "when step definition - (first)" do
        before do
          service.step :method_step,
            in: [
              0 => -> { "Outside `arg1`" }
            ]
        end

        it "uses proper loose args" do
          expect(service.result).to be_success.with_data(args: ["Outside `arg1`", "Inside `arg2`"])
        end
      end

      context "when step definition - (first, second)" do
        before do
          service.step :method_step,
            in: [
              0 => -> { "Outside `arg1`" },
              1 => -> { "Outside `arg2`" }
            ]
        end

        it "uses proper loose args" do
          expect(service.result).to be_success.with_data(args: ["Outside `arg1`", "Outside `arg2`"])
        end
      end
    end
  end

  example_group "kwargs" do
    context "when method definition - (foo:)" do
      before do
        service.class_exec do
          def method_step(foo:)
            success(kwargs: kwargs_from_arguments(foo: foo))
          end
        end
      end

      context "when step definition - ()" do
        before do
          service.step :method_step
        end

        it "raise `ArgumentError`" do
          expect { service.result }.to raise_error(ArgumentError).with_message("missing keyword: :foo")
        end
      end

      context "when step definition - (foo:)" do
        before do
          service.step :method_step,
            in: [
              foo: -> { "Outside `kwarg1`" }
            ]
        end

        it "uses proper loose arguments" do
          expect(service.result).to be_success.with_data(kwargs: {foo: "Outside `kwarg1`", bar: "Inside `kwarg2`"})
        end
      end

      context "when step definition - (foo:, bar:)" do
        before do
          service.step :method_step,
            in: [
              foo: -> { "Outside `kwarg1`" },
              bar: -> { "Outside `kwarg2`" }
            ]
        end

        it "uses proper loose arguments" do
          expect(service.result).to be_success.with_data(kwargs: {foo: "Outside `kwarg1`", bar: "Inside `kwarg2`"})
        end
      end
    end

    context "when method definition - (foo: 'default `kwarg1`')" do
      before do
        service.class_exec do
          def method_step(foo: "Default `kwarg1`")
            success(kwargs: kwargs_from_arguments(foo: foo))
          end
        end
      end

      context "when step definition - ()" do
        before do
          service.step :method_step
        end

        it "uses proper loose arguments" do
          expect(service.result).to be_success.with_data(kwargs: {foo: "Default `kwarg1`", bar: "Inside `kwarg2`"})
        end
      end

      context "when step definition - (foo:)" do
        before do
          service.step :method_step,
            in: [
              foo: -> { "Outside `kwarg1`" }
            ]
        end

        it "uses proper loose arguments" do
          expect(service.result).to be_success.with_data(kwargs: {foo: "Outside `kwarg1`", bar: "Inside `kwarg2`"})
        end
      end

      context "when step definition - (foo:, bar:)" do
        before do
          service.step :method_step,
            in: [
              foo: -> { "Outside `kwarg1`" },
              bar: -> { "Outside `kwarg2`" }
            ]
        end

        it "uses proper loose arguments" do
          expect(service.result).to be_success.with_data(kwargs: {foo: "Outside `kwarg1`", bar: "Inside `kwarg2`"})
        end
      end
    end

    context "when method definition - (foo:, bar:)" do
      before do
        service.class_exec do
          def method_step(foo:, bar:)
            success(kwargs: kwargs_from_arguments(foo: foo, bar: bar))
          end
        end
      end

      context "when step definition - ()" do
        before do
          service.step :method_step
        end

        it "raise `ArgumentError`" do
          expect { service.result }.to raise_error(ArgumentError).with_message("missing keywords: :foo, :bar")
        end
      end

      context "when step definition - (foo:)" do
        before do
          service.step :method_step,
            in: [
              foo: -> { "Outside `kwarg1`" }
            ]
        end

        it "raise `ArgumentError`" do
          expect { service.result }.to raise_error(ArgumentError).with_message("missing keyword: :bar")
        end
      end

      context "when step definition - (foo:, bar:)" do
        before do
          service.step :method_step,
            in: [
              foo: -> { "Outside `kwarg1`" },
              bar: -> { "Outside `kwarg2`" }
            ]
        end

        it "uses proper loose arguments" do
          expect(service.result).to be_success.with_data(kwargs: {foo: "Outside `kwarg1`", bar: "Outside `kwarg2`"})
        end
      end
    end

    context "when method definition - (foo:, bar: 'default `kwarg2`')" do
      before do
        service.class_exec do
          def method_step(foo:, bar: "Default `kwarg2`")
            success(kwargs: kwargs_from_arguments(foo: foo, bar: bar))
          end
        end
      end

      context "when step definition - ()" do
        before do
          service.step :method_step
        end

        it "raise `ArgumentError`" do
          expect { service.result }.to raise_error(ArgumentError).with_message("missing keyword: :foo")
        end
      end

      context "when step definition - (foo:)" do
        before do
          service.step :method_step,
            in: [
              foo: -> { "Outside `kwarg1`" }
            ]
        end

        it "uses proper loose arguments" do
          expect(service.result).to be_success.with_data(kwargs: {foo: "Outside `kwarg1`", bar: "Default `kwarg2`"})
        end
      end

      context "when step definition - (foo:, bar:)" do
        before do
          service.step :method_step,
            in: [
              foo: -> { "Outside `kwarg1`" },
              bar: -> { "Outside `kwarg2`" }
            ]
        end

        it "uses proper loose arguments" do
          expect(service.result).to be_success.with_data(kwargs: {foo: "Outside `kwarg1`", bar: "Outside `kwarg2`"})
        end
      end
    end

    context "when method definition - (foo: 'default `kwarg1`', bar: 'default `kwarg2`')" do
      before do
        service.class_exec do
          def method_step(foo: "Default `kwarg1`", bar: "Default `kwarg2`")
            success(kwargs: kwargs_from_arguments(foo: foo, bar: bar))
          end
        end
      end

      context "when step definition - ()" do
        before do
          service.step :method_step
        end

        it "uses proper loose arguments" do
          expect(service.result).to be_success.with_data(kwargs: {foo: "Default `kwarg1`", bar: "Default `kwarg2`"})
        end
      end

      context "when step definition - (foo:)" do
        before do
          service.step :method_step,
            in: [
              foo: -> { "Outside `kwarg1`" }
            ]
        end

        it "uses proper loose arguments" do
          expect(service.result).to be_success.with_data(kwargs: {foo: "Outside `kwarg1`", bar: "Default `kwarg2`"})
        end
      end

      context "when step definition - (foo:, bar:)" do
        before do
          service.step :method_step,
            in: [
              foo: -> { "Outside `kwarg1`" },
              bar: -> { "Outside `kwarg2`" }
            ]
        end

        it "uses proper loose arguments" do
          expect(service.result).to be_success.with_data(kwargs: {foo: "Outside `kwarg1`", bar: "Outside `kwarg2`"})
        end
      end
    end

    context "when method definition - (**kwargs)" do
      before do
        service.class_exec do
          def method_step(**kwargs)
            success(kwargs: kwargs_from_arguments(**kwargs))
          end
        end
      end

      context "when step definition - ()" do
        before do
          service.step :method_step
        end

        it "uses proper loose arguments" do
          expect(service.result).to be_success.with_data(kwargs: {foo: "Inside `kwarg1`", bar: "Inside `kwarg2`"})
        end
      end

      context "when step definition - (foo:)" do
        before do
          service.step :method_step,
            in: [
              foo: -> { "Outside `kwarg1`" }
            ]
        end

        it "uses proper loose arguments" do
          expect(service.result).to be_success.with_data(kwargs: {foo: "Outside `kwarg1`", bar: "Inside `kwarg2`"})
        end
      end

      context "when step definition - (foo:, bar:)" do
        before do
          service.step :method_step,
            in: [
              foo: -> { "Outside `kwarg1`" },
              bar: -> { "Outside `kwarg2`" }
            ]
        end

        it "uses proper loose arguments" do
          expect(service.result).to be_success.with_data(kwargs: {foo: "Outside `kwarg1`", bar: "Outside `kwarg2`"})
        end
      end
    end
  end

  example_group "block" do
    context "when method definition - (&block)" do
      before do
        service.class_exec do
          def method_step(&block)
            success(block: block_from_arguments(&block))
          end
        end
      end

      context "when step definition - ()" do
        before do
          service.step :method_step
        end

        it "uses proper loose arguments" do
          expect(service.result).to be_success.with_data(block: inside_block.source_location)
        end
      end

      context "when step definition - (&block)" do
        before do
          service.step :method_step,
            in: [
              service.block => -> { outside_block }
            ]
        end

        it "uses proper loose arguments" do
          expect(service.result).to be_success.with_data(block: outside_block.source_location)
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers, RSpec/ExampleLength, RSpec/DescribeClass
