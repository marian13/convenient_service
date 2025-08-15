# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Support::Middleware::StackBuilder::Entities::Builders::RubyMiddleware, type: :standard do
  let(:stack_builder) { described_class.new(name: name, stack: stack) }

  let(:stack) { [] }
  let(:name) { "Stack" }

  let(:args) { [:foo] }
  let(:block) { proc { :foo } }

  example_group "inheritance" do
    ##
    # NOTE: Do NOT use custom RSpec helpers and matchers inside Utils and Support to avoid cyclic module dependencies.
    #
    specify { expect(described_class < ConvenientService::Dependencies::Extractions::RubyMiddleware::Middleware::Builder).to eq(true) }
  end

  example_group "class methods" do
    describe ".new" do
      context "when `name` is NOT passed" do
        it "defaults `\"Stack\"`" do
          expect(stack_builder.name).to eq("Stack")
        end
      end

      context "when `stack` is NOT passed" do
        ##
        # NOTE: Indirect test since `stack` is protected.
        #
        it "defaults to empty array" do
          expect(stack_builder.empty?).to eq(true)
        end
      end
    end
  end

  example_group "instance methods" do
    let(:middleware) { proc { :foo } }
    let(:other_middleware) { proc { :bar } }

    describe "#has?" do
      context "when stack does NOT have middleware" do
        before do
          stack_builder.clear
        end

        it "returns `false`" do
          expect(stack_builder.has?(middleware)).to eq(false)
        end
      end

      context "when stack has middleware" do
        before do
          stack_builder.use(middleware)
        end

        it "returns `true`" do
          expect(stack_builder.has?(middleware)).to eq(true)
        end
      end
    end

    describe "#empty?" do
      ##
      # NOTE: Do NOT use custom RSpec helpers and matchers inside Utils and Support to avoid cyclic module dependencies.
      #
      # rubocop:disable RSpec/MultipleExpectations, RSpec/MessageSpies, RSpec/ExampleLength
      it "delegates to `stack#empty?`" do
        expect(stack)
          .to receive(:empty?)
            .and_wrap_original { |original, *actual_args, **actual_kwargs, &actual_block|
                expect([actual_args, actual_kwargs, actual_block]).to eq([[], {}, nil])

                original.call(*actual_args, **actual_kwargs, &actual_block)
              }

        stack_builder.empty?
      end
      # rubocop:enable RSpec/MultipleExpectations, RSpec/MessageSpies, RSpec/ExampleLength

      it "returns `stack#empty?` value" do
        expect(stack_builder.empty?).to eq(stack.empty?)
      end
    end

    describe "#clear" do
      ##
      # NOTE: Do NOT use custom RSpec helpers and matchers inside Utils and Support to avoid cyclic module dependencies.
      #
      # rubocop:disable RSpec/MultipleExpectations, RSpec/MessageSpies, RSpec/ExampleLength
      it "delegates to `stack#clear`" do
        expect(stack)
          .to receive(:clear)
            .and_wrap_original { |original, *actual_args, **actual_kwargs, &actual_block|
                expect([actual_args, actual_kwargs, actual_block]).to eq([[], {}, nil])

                original.call(*actual_args, **actual_kwargs, &actual_block)
              }

        stack_builder.clear
      end
      # rubocop:enable RSpec/MultipleExpectations, RSpec/MessageSpies, RSpec/ExampleLength

      it "returns `stack_builder` value" do
        expect(stack_builder.clear).to eq(stack_builder)
      end
    end

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
          stub_const("ConvenientService::Support::Middleware::StackBuilder::Constants::Backends::DEFAULT", ConvenientService::Support::Middleware::StackBuilder::Constants::Backends::RUBY_MIDDLEWARE)
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

    describe "#unshift" do
      ##
      # NOTE: Do NOT use custom RSpec helpers and matchers inside Utils and Support to avoid cyclic module dependencies.
      #
      # rubocop:disable RSpec/MultipleExpectations, RSpec/MessageSpies, RSpec/ExampleLength
      it "delegates to `stack#unshift`" do
        expect(stack)
          .to receive(:unshift)
            .and_wrap_original { |original, *actual_args, **actual_kwargs, &actual_block|
                expect([actual_args, actual_kwargs, actual_block]).to eq([[[middleware, args, block]], {}, nil])

                original.call(*actual_args, **actual_kwargs, &actual_block)
              }

        stack_builder.unshift(middleware, *args, &block)
      end
      # rubocop:enable RSpec/MultipleExpectations, RSpec/MessageSpies, RSpec/ExampleLength

      it "returns `stack_builder` value" do
        expect(stack_builder.unshift(middleware, *args, &block)).to eq(stack_builder)
      end
    end

    describe "#prepend" do
      ##
      # NOTE: Do NOT use custom RSpec helpers and matchers inside Utils and Support to avoid cyclic module dependencies.
      #
      # rubocop:disable RSpec/MultipleExpectations, RSpec/MessageSpies, RSpec/ExampleLength
      it "delegates to `stack#unshift`" do
        expect(stack)
          .to receive(:unshift)
            .and_wrap_original { |original, *actual_args, **actual_kwargs, &actual_block|
                expect([actual_args, actual_kwargs, actual_block]).to eq([[[middleware, args, block]], {}, nil])

                original.call(*actual_args, **actual_kwargs, &actual_block)
              }

        stack_builder.prepend(middleware, *args, &block)
      end
      # rubocop:enable RSpec/MultipleExpectations, RSpec/MessageSpies, RSpec/ExampleLength

      it "returns `stack_builder` value" do
        expect(stack_builder.prepend(middleware, *args, &block)).to eq(stack_builder)
      end
    end

    describe "#use" do
      ##
      # NOTE: Do NOT use custom RSpec helpers and matchers inside Utils and Support to avoid cyclic module dependencies.
      #
      # rubocop:disable RSpec/MultipleExpectations, RSpec/MessageSpies, RSpec/ExampleLength
      it "delegates to `stack#<<`" do
        expect(stack)
          .to receive(:<<)
            .and_wrap_original { |original, *actual_args, **actual_kwargs, &actual_block|
                expect([actual_args, actual_kwargs, actual_block]).to eq([[[middleware, args, block]], {}, nil])

                original.call(*actual_args, **actual_kwargs, &actual_block)
              }

        stack_builder.use(middleware, *args, &block)
      end
      # rubocop:enable RSpec/MultipleExpectations, RSpec/MessageSpies, RSpec/ExampleLength

      it "returns `stack_builder` value" do
        expect(stack_builder.use(middleware, *args, &block)).to eq(stack_builder)
      end
    end

    describe "#append" do
      ##
      # NOTE: Do NOT use custom RSpec helpers and matchers inside Utils and Support to avoid cyclic module dependencies.
      #
      # rubocop:disable RSpec/MultipleExpectations, RSpec/MessageSpies, RSpec/ExampleLength
      it "delegates to `stack#<<`" do
        expect(stack)
          .to receive(:<<)
            .and_wrap_original { |original, *actual_args, **actual_kwargs, &actual_block|
                expect([actual_args, actual_kwargs, actual_block]).to eq([[[middleware, args, block]], {}, nil])

                original.call(*actual_args, **actual_kwargs, &actual_block)
              }

        stack_builder.append(middleware, *args, &block)
      end
      # rubocop:enable RSpec/MultipleExpectations, RSpec/MessageSpies, RSpec/ExampleLength

      it "returns `stack_builder` value" do
        expect(stack_builder.append(middleware, *args, &block)).to eq(stack_builder)
      end
    end

    describe "#delete" do
      context "when stack does NOT have middleware" do
        let(:exception_message) { "no implicit conversion from nil to integer" }

        before do
          stack_builder.clear
        end

        it "raises `TypeError`" do
          expect { stack_builder.delete(middleware) }
            .to raise_error(TypeError)
            .with_message(exception_message)
        end

        ##
        # NOTE: `TypeError` exception is raised by `Array#index` from `ruby_middleware` gem. That is why is NOT processed by `ConvenientService.raise`.
        # NOTE: Do NOT use custom RSpec helpers and matchers inside Utils and Support to avoid cyclic module dependencies.
        #
        #   # rubocop:disable RSpec/MultipleExpectations, RSpec/MessageSpies, RSpec/ExampleLength
        #   specify do
        #     expect(ConvenientService).to receive(:raise).and_call_original
        #
        #     expect { stack_builder.delete(middleware) }.to raise_error(TypeError)
        #   end
        #   # rubocop:enable RSpec/MultipleExpectations, RSpec/MessageSpies, RSpec/ExampleLength
        ##
      end

      context "when stack has middleware" do
        before do
          stack_builder.use(middleware)
        end

        it "removes that middleware from stack" do
          stack_builder.delete(middleware)

          expect(stack_builder.empty?).to eq(true)
        end

        ##
        # NOTE: Currently `ruby_middleware` is not fully compatible with `rack`.
        # TODO: Make `ruby_middleware` and `rack` fully compatible?
        #
        it "returns deleted middleware" do
          expect(stack_builder.delete(middleware)).to eq([middleware, [], nil])
        end
      end
    end

    describe "#remove" do
      context "when stack does NOT have middleware" do
        before do
          stack_builder.clear
        end

        let(:exception_message) { "no implicit conversion from nil to integer" }

        it "raises `TypeError`" do
          expect { stack_builder.delete(middleware) }
            .to raise_error(TypeError)
            .with_message(exception_message)
        end

        ##
        # NOTE: `TypeError` exception is raised by `Array#index` from `ruby_middleware` gem. That is why is NOT processed by `ConvenientService.raise`.
        # NOTE: Do NOT use custom RSpec helpers and matchers inside Utils and Support to avoid cyclic module dependencies.
        #
        #   # rubocop:disable RSpec/MultipleExpectations, RSpec/MessageSpies, RSpec/ExampleLength
        #   specify do
        #     expect(ConvenientService).to receive(:raise).and_call_original
        #
        #     expect { stack_builder.delete(middleware) }.to raise_error(TypeError)
        #   end
        #   # rubocop:enable RSpec/MultipleExpectations, RSpec/MessageSpies, RSpec/ExampleLength
        ##
      end

      context "when stack does has middleware" do
        before do
          stack_builder.use(middleware)
        end

        it "removes that middleware from stack" do
          stack_builder.remove(middleware)

          expect(stack_builder.empty?).to eq(true)
        end

        ##
        # NOTE: Currently `ruby_middleware` is not fully compatible with `rack`.
        # TODO: Make `ruby_middleware` and `rack` fully compatible?
        #
        it "returns removed middleware" do
          expect(stack_builder.remove(middleware)).to eq([middleware, [], nil])
        end
      end
    end

    describe "#to_a" do
      before do
        stack_builder.use(middleware)
        stack_builder.use(other_middleware)
      end

      it "returns middlewares without args and block" do
        expect(stack_builder.to_a).to eq([middleware, other_middleware])
      end
    end

    describe "#dup" do
      ##
      # NOTE: Unfreezes string since it is NOT possible to set spy on frozen objects.
      #
      let(:name) { +"Stack" }

      before do
        ##
        # NOTE: Create stack, before setting spies on `stack_class.new`, `name.dup`.
        #
        stack_builder
      end

      ##
      # NOTE: Do NOT use custom RSpec helpers and matchers inside Utils and Support to avoid cyclic module dependencies.
      #
      # rubocop:disable RSpec/MultipleExpectations, RSpec/MessageSpies, RSpec/ExampleLength
      it "delegates to `ConvenientService::Support::Middleware::StackBuilder::Entities::Builders::RubyMiddleware.new`" do
        expect(described_class)
          .to receive(:new)
            .and_wrap_original { |original, *actual_args, **actual_kwargs, &actual_block|
                expect([actual_args, actual_kwargs, actual_block]).to eq([[], {name: name, stack: stack, runner_class: ConvenientService::Dependencies::Extractions::RubyMiddleware::Middleware::Runner}, nil])

                original.call(*actual_args, **actual_kwargs, &actual_block)
              }

        stack_builder.dup
      end
      # rubocop:enable RSpec/MultipleExpectations, RSpec/MessageSpies, RSpec/ExampleLength

      it "returns `ConvenientService::Support::Middleware::StackBuilder::Entities::Builders::RubyMiddleware.new` value" do
        expect(stack_builder.dup).to eq(described_class.new(name: name, stack: stack, runner_class: ConvenientService::Dependencies::Extractions::RubyMiddleware::Middleware::Runner))
      end

      ##
      # NOTE: Do NOT use custom RSpec helpers and matchers inside Utils and Support to avoid cyclic module dependencies.
      #
      # rubocop:disable RSpec/MultipleExpectations, RSpec/MessageSpies, RSpec/ExampleLength
      it "delegates to `name#dup`" do
        expect(name)
          .to receive(:dup)
            .and_wrap_original { |original, *actual_args, **actual_kwargs, &actual_block|
                expect([actual_args, actual_kwargs, actual_block]).to eq([[], {}, nil])

                original.call(*actual_args, **actual_kwargs, &actual_block)
              }

        stack_builder.dup
      end
      # rubocop:enable RSpec/MultipleExpectations, RSpec/MessageSpies, RSpec/ExampleLength

      ##
      # NOTE: Do NOT use custom RSpec helpers and matchers inside Utils and Support to avoid cyclic module dependencies.
      #
      # rubocop:disable RSpec/MultipleExpectations, RSpec/MessageSpies, RSpec/ExampleLength
      it "delegates to `stack#dup`" do
        expect(stack)
          .to receive(:dup)
            .and_wrap_original { |original, *actual_args, **actual_kwargs, &actual_block|
                expect([actual_args, actual_kwargs, actual_block]).to eq([[], {}, nil])

                original.call(*actual_args, **actual_kwargs, &actual_block)
              }

        stack_builder.dup
      end
      # rubocop:enable RSpec/MultipleExpectations, RSpec/MessageSpies, RSpec/ExampleLength
    end

    example_group "comparison" do
      describe "#==" do
        context "when `other` has different class" do
          let(:other) { 42 }

          it "returns `false`" do
            expect(stack_builder == other).to be_nil
          end
        end

        context "when `other` has different `name`" do
          let(:other) { described_class.new(name: "OtherStack", stack: stack) }

          it "returns `false`" do
            expect(stack_builder == other).to eq(false)
          end
        end

        context "when `other` has different `plain_stack`" do
          let(:other) { described_class.new(name: name, stack: [[middleware, [], nil]]) }

          it "returns `false`" do
            expect(stack_builder == other).to eq(false)
          end
        end

        context "when `other` has same attributes" do
          let(:other) { described_class.new(name: name, stack: stack) }

          it "returns `true`" do
            expect(stack_builder == other).to eq(true)
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
