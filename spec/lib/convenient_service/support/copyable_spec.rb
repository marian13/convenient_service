# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Support::Copyable, type: :standard do
  example_group "instance methods" do
    describe "#copy" do
      let(:base_class) do
        Class.new do
          include ConvenientService::Support::Copyable

          attr_reader :args, :kwargs, :block

          def initialize(*args, **kwargs, &block)
            @args = args
            @kwargs = kwargs
            @block = block
          end

          def ==(other)
            return unless other.instance_of?(self.class)

            return false if args != other.args
            return false if kwargs != other.kwargs
            return false if block != other.block

            true
          end

          def to_arguments
            ConvenientService::Support::Arguments.new(*args, **kwargs, &block)
          end
        end
      end

      let(:klass) { Class.new(base_class) }
      let(:instance) { klass.new(*arguments.args, **arguments.kwargs, &arguments.block) }
      let(:arguments) { ConvenientService::Support::Arguments.new(:foo, :bar, :baz, foo: 0, bar: 1, baz: 2) { :foo } }

      it "returns copy" do
        expect(instance.copy).to eq(instance)
      end

      it "returns new instance" do
        expect(instance.copy).not_to equal(instance)
      end

      context "when `overrides[:args]` is passed" do
        context "when `overrides[:args]` is array" do
          let(:overrides) { {args: [:qux, :quux]} }

          it "replaces `to_arguments.args` with `overrides[:args]`" do
            expect(instance.copy(overrides: overrides).args).to eq([:qux, :quux])
          end
        end

        context "when `overrides[:args]` is hash" do
          let(:overrides) { {args: {0 => :qux, 1 => :quux}} }

          it "merges `to_arguments.args` with `overrides[:args]`" do
            expect(instance.copy(overrides: overrides).args).to eq([:qux, :quux, :baz])
          end

          it "delegates to `ConvenientService::Utils::Array.merge`" do
            allow(ConvenientService::Utils::Array).to receive(:merge).with(instance.to_arguments.args, overrides[:args]).and_call_original

            instance.copy(overrides: overrides)

            expect(ConvenientService::Utils::Array).to have_received(:merge)
          end
        end
      end

      context "when `overrides[:kwargs]` is passed" do
        context "when `overrides[:kwargs]` is array" do
          let(:overrides) { {kwargs: [foo: 3, bar: 4]} }

          it "replaces `to_arguments.kwargs` with `overrides[:kwargs]`" do
            expect(instance.copy(overrides: overrides).kwargs).to eq({foo: 3, bar: 4})
          end
        end

        context "when `overrides[:kwargs]` is hash" do
          let(:overrides) { {kwargs: {foo: 3, bar: 4}} }

          it "merges `to_arguments.kwargs` with `overrides[:kwargs]`" do
            expect(instance.copy(overrides: overrides).kwargs).to eq({foo: 3, bar: 4, baz: 2})
          end
        end
      end

      context "when `overrides[:block]` is passed" do
        let(:overrides) { {block: proc { :bar }} }

        it "merges `to_arguments.block` with `overrides[:block]`" do
          expect(instance.copy(overrides: overrides).block).to eq(overrides[:block])
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
