# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Core::Entities::Config::Entities::MethodMiddlewares::Entities::Stack, type: :standard do
  include ConvenientService::RSpec::Matchers::DelegateTo

  let(:stack) { described_class.new(klass: klass, name: name, plain_stack: plain_stack) }

  let(:klass) do
    Class.new do
      include ConvenientService::Config
    end
  end

  let(:name) { "stack name" }
  let(:plain_stack) { ConvenientService::Support::Middleware::StackBuilder.new(name: name) }
  let(:env) { {foo: :bar} }

  let(:index) { 0 }

  let(:middleware) do
    Class.new(ConvenientService::Core::Entities::Config::Entities::MethodMiddlewares::Entities::Middlewares::Chain) do
      def next(...)
        chain.next(...)
      end
    end
  end

  let(:original) { proc { :foo } }

  let(:other_middleware) do
    Class.new(ConvenientService::Core::Entities::Config::Entities::MethodMiddlewares::Entities::Middlewares::Chain) do
      def next(...)
        chain.next(...)
      end
    end
  end

  example_group "class methods" do
    describe ".new" do
      context "when `plain_stack` is NOT `nil`" do
        let(:stack) { described_class.new(klass: klass, name: name, plain_stack: custom_plain_stack) }
        let(:custom_plain_stack) { ConvenientService::Support::Middleware::StackBuilder.new(name: "custom plain stack") }

        ##
        # NOTE: Since `plain_stack` reader is protected, indirect expectation is used.
        #
        it "uses passed `plain_stack` as `plain_stack`" do
          expect { stack.call_with_original(env, original) }
            .to delegate_to(custom_plain_stack, :call_with_original)
            .with_arguments(env, original)
        end
      end

      context "when `plain_stack` is `nil`" do
        let(:stack) { described_class.new(klass: klass, name: name, plain_stack: nil) }
        let(:default_plain_stack) { ConvenientService::Support::Middleware::StackBuilder.new(name: name) }

        ##
        # NOTE: Since `plain_stack` reader is protected, indirect expectation is used.
        #
        it "defaults to `ConvenientService::Support::Middleware::StackBuilder.new(name: name)`" do
          expect { stack }
            .to delegate_to(ConvenientService::Support::Middleware::StackBuilder, :new)
            .with_arguments(name: name)
        end
      end
    end
  end

  example_group "instance methods" do
    example_group "alias methods" do
      include ConvenientService::RSpec::Matchers::HaveAliasMethod

      subject { stack }

      it { is_expected.to have_alias_method(:insert_before, :insert) }
    end

    example_group "attributes" do
      include ConvenientService::RSpec::Matchers::HaveAttrReader

      subject { stack }

      it { is_expected.to have_attr_reader(:klass) }
    end

    describe "#options" do
      specify do
        expect { stack.options }
          .to delegate_to(klass, :options)
          .and_return_its_value
      end
    end

    describe "#name" do
      specify do
        expect { stack.name }
          .to delegate_to(plain_stack, :name)
          .and_return_its_value
      end
    end

    describe "#dup" do
      ##
      # NOTE: Unfreezes string since it is NOT possible to set spy on frozen objects.
      #
      let(:name) { +"stack name" }

      before do
        ##
        # NOTE: Create stack, before setting spies on `stack_class.new`, `name.dup`.
        #
        stack
      end

      specify do
        expect { stack.dup }
          .to delegate_to(described_class, :new)
          .with_arguments(klass: klass, plain_stack: plain_stack)
          .and_return_its_value
      end

      specify { expect { stack.dup }.not_to delegate_to(klass, :dup) }

      specify { expect { stack.dup }.to delegate_to(name, :dup) }

      specify { expect { stack.dup }.to delegate_to(plain_stack, :dup) }
    end

    describe "#call_with_original" do
      specify do
        expect { stack.call_with_original(env, original) }
          .to delegate_to(plain_stack, :call_with_original)
          .with_arguments(env, original)
          .and_return_its_value
      end
    end

    describe "#unshift" do
      specify do
        expect { stack.unshift(middleware) }
          .to delegate_to(plain_stack, :unshift)
          .with_arguments(middleware)
      end

      it "returns stack" do
        expect(stack.unshift(middleware)).to eq(stack)
      end
    end

    describe "#prepend" do
      specify do
        expect { stack.prepend(middleware) }
          .to delegate_to(plain_stack, :unshift)
          .with_arguments(middleware)
      end

      it "returns stack" do
        expect(stack.prepend(middleware)).to eq(stack)
      end
    end

    describe "#insert" do
      before do
        stack.use other_middleware
      end

      context "when index passed" do
        specify do
          expect { stack.insert(index, middleware) }
            .to delegate_to(plain_stack, :insert)
            .with_arguments(index, middleware)
        end

        it "returns stack" do
          expect(stack.insert(index, middleware)).to eq(stack)
        end
      end

      context "when middleware passed" do
        specify do
          expect { stack.insert(other_middleware, middleware) }
            .to delegate_to(plain_stack, :insert)
            .with_arguments(other_middleware, middleware)
        end

        it "returns stack" do
          expect(stack.insert(other_middleware, middleware)).to eq(stack)
        end
      end
    end

    describe "#insert_before" do
      before do
        stack.use other_middleware
      end

      context "when index passed" do
        specify do
          expect { stack.insert_before(index, middleware) }
            .to delegate_to(plain_stack, :insert)
            .with_arguments(index, middleware)
        end

        it "returns stack" do
          expect(stack.insert_before(index, middleware)).to eq(stack)
        end
      end

      context "when middleware passed" do
        specify do
          expect { stack.insert_before(other_middleware, middleware) }
            .to delegate_to(plain_stack, :insert)
            .with_arguments(other_middleware, middleware)
        end

        it "returns stack" do
          expect(stack.insert_before(other_middleware, middleware)).to eq(stack)
        end
      end
    end

    describe "#insert_after" do
      before do
        stack.use other_middleware
      end

      context "when index passed" do
        specify do
          expect { stack.insert_after(index, middleware) }
            .to delegate_to(plain_stack, :insert_after)
            .with_arguments(index, middleware)
        end

        it "returns stack" do
          expect(stack.insert_after(index, middleware)).to eq(stack)
        end
      end

      context "when middleware passed" do
        specify do
          expect { stack.insert_after(other_middleware, middleware) }
            .to delegate_to(plain_stack, :insert_after)
            .with_arguments(other_middleware, middleware)
        end

        it "returns stack" do
          expect(stack.insert_after(other_middleware, middleware)).to eq(stack)
        end
      end
    end

    describe "#insert_before_each" do
      before do
        stack.use other_middleware
      end

      specify do
        expect { stack.insert_before_each(middleware) }
          .to delegate_to(plain_stack, :insert_before_each)
          .with_arguments(middleware)
      end

      it "returns stack" do
        expect(stack.insert_before_each(middleware)).to eq(stack)
      end
    end

    describe "#insert_after_each" do
      before do
        stack.use other_middleware
      end

      specify do
        expect { stack.insert_after_each(middleware) }
          .to delegate_to(plain_stack, :insert_after_each)
          .with_arguments(middleware)
      end

      it "returns stack" do
        expect(stack.insert_after_each(middleware)).to eq(stack)
      end
    end

    describe "#replace" do
      before do
        stack.use other_middleware
      end

      context "when index passed" do
        specify do
          expect { stack.replace(index, middleware) }
            .to delegate_to(plain_stack, :replace)
            .with_arguments(index, middleware)
        end

        it "returns stack" do
          expect(stack.replace(index, middleware)).to eq(stack)
        end
      end

      context "when middleware passed" do
        specify do
          expect { stack.replace(other_middleware, middleware) }
            .to delegate_to(plain_stack, :replace)
            .with_arguments(other_middleware, middleware)
        end

        it "returns stack" do
          expect(stack.replace(other_middleware, middleware)).to eq(stack)
        end
      end
    end

    describe "#delete" do
      before do
        stack.use other_middleware
      end

      context "when index passed" do
        specify do
          expect { stack.delete(index) }
            .to delegate_to(plain_stack, :delete)
            .with_arguments(index)
        end

        it "returns stack" do
          expect(stack.delete(index)).to eq(stack)
        end
      end

      context "when middleware passed" do
        specify do
          expect { stack.delete(other_middleware) }
            .to delegate_to(plain_stack, :delete)
            .with_arguments(other_middleware)
        end

        it "returns stack" do
          expect(stack.delete(other_middleware)).to eq(stack)
        end
      end
    end

    describe "#remove" do
      before do
        stack.use other_middleware
      end

      context "when index passed" do
        specify do
          expect { stack.remove(index) }
            .to delegate_to(plain_stack, :delete)
            .with_arguments(index)
        end

        it "returns stack" do
          expect(stack.remove(index)).to eq(stack)
        end
      end

      context "when middleware passed" do
        specify do
          expect { stack.remove(other_middleware) }
            .to delegate_to(plain_stack, :delete)
            .with_arguments(other_middleware)
        end

        it "returns stack" do
          expect(stack.remove(other_middleware)).to eq(stack)
        end
      end
    end

    describe "#use" do
      specify do
        expect { stack.use(middleware) }
          .to delegate_to(plain_stack, :use)
          .with_arguments(middleware)
      end

      it "returns stack" do
        expect(stack.use(middleware)).to eq(stack)
      end
    end

    describe "#append" do
      specify do
        expect { stack.append(middleware) }
          .to delegate_to(plain_stack, :use)
          .with_arguments(middleware)
      end

      it "returns stack" do
        expect(stack.append(middleware)).to eq(stack)
      end
    end

    describe "#observe" do
      before do
        stack.use(middleware)
      end

      specify do
        expect { stack.observe(middleware) }
          .to delegate_to(plain_stack, :replace)
          .with_arguments(middleware, middleware.observable)
      end

      it "returns stack" do
        expect(stack.observe(middleware)).to eq(stack)
      end
    end

    describe "#use_and_observe" do
      specify do
        expect { stack.use_and_observe(middleware) }
          .to delegate_to(plain_stack, :use)
          .with_arguments(middleware.observable)
      end

      it "returns stack" do
        expect(stack.use_and_observe(middleware)).to eq(stack)
      end
    end

    describe "#empty?" do
      specify do
        expect { stack.empty? }
          .to delegate_to(plain_stack, :empty?)
          .and_return_its_value
      end
    end

    describe "#has?" do
      specify do
        expect { stack.has?(middleware) }
          .to delegate_to(plain_stack, :has?)
          .with_arguments(middleware)
          .and_return_its_value
      end
    end

    describe "#to_a" do
      specify do
        expect { stack.to_a }
          .to delegate_to(plain_stack, :to_a)
          .and_return_its_value
      end
    end

    example_group "comparison" do
      describe "#==" do
        context "when `other` has different class" do
          let(:other) { 42 }

          it "returns `false`" do
            expect(stack == other).to be_nil
          end
        end

        context "when `other` has different `klass`" do
          let(:other) { described_class.new(klass: other_klass, plain_stack: plain_stack) }

          let(:other_klass) do
            Class.new do
              include ConvenientService::Core
            end
          end

          it "returns `false`" do
            expect(stack == other).to eq(false)
          end
        end

        context "when `other` has different `plain_stack`" do
          let(:other) { described_class.new(klass: klass, plain_stack: ConvenientService::Support::Middleware::StackBuilder.new(name: name).tap { |stack| stack.use middleware }) }

          it "returns `false`" do
            expect(stack == other).to eq(false)
          end
        end

        context "when `other` has same attributes" do
          let(:other) { described_class.new(klass: klass, plain_stack: plain_stack) }

          it "returns `true`" do
            expect(stack == other).to eq(true)
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
