# frozen_string_literal: true

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
            return false if block&.source_location != other.block&.source_location

            true
          end

          def to_arguments
            ConvenientService::Support::Arguments.new(*args, **kwargs, &block)
          end
        end
      end

      let(:klass) { Class.new(base_class) }
      let(:instance) { klass.new(*arguments.args, **arguments.kwargs, &arguments.block) }
      let(:arguments) { ConvenientService::Support::Arguments.new(:foo, :bar, foo: 0, bar: 1) { :foo } }

      it "returns copy" do
        expect(instance.copy).to eq(instance)
      end

      it "returns new instance" do
        expect(instance.copy.object_id).not_to eq(instance.object_id)
      end

      context "when `overrides[:args]` is NOT passed" do
        let(:overrides) { {} }

        it "defaults to empty hash`" do
          expect(instance.copy(overrides: overrides).args).to eq(arguments.args)
        end
      end

      context "when `overrides[:args]` is passed" do
        context "when `overrides[:args]` is array" do
          let(:overrides) { {args: [:baz, :qux]} }

          it "replaces `to_arguments.args` with `overrides[:args]`" do
            expect(instance.copy(overrides: overrides).args).to eq(overrides[:args])
          end
        end

        context "when `overrides[:args]` is hash" do
          let(:overrides) { {args: {0 => :baz, 1 => :qux}} }

          it "merges `to_arguments.args` with `overrides[:args]`" do
            expect(instance.copy(overrides: overrides).args).to eq(overrides[:args].values)
          end

          it "delegates to `ConvenientService::Utils::Array.merge`" do
            allow(ConvenientService::Utils::Array).to receive(:merge).with(instance.to_arguments.args, overrides[:args]).and_call_original

            instance.copy(overrides: overrides)

            expect(ConvenientService::Utils::Array).to have_received(:merge)
          end
        end
      end

      context "when `overrides[:kwargs]` is NOT passed" do
        let(:overrides) { {} }

        it "defaults to empty hash`" do
          expect(instance.copy(overrides: overrides).kwargs).to eq(arguments.kwargs)
        end
      end

      context "when `overrides[:kwargs]` is passed" do
        let(:overrides) { {kwargs: {foo: 3, bar: 4}} }

        it "merges `to_arguments.kwargs` with `overrides[:kwargs]`" do
          expect(instance.copy(overrides: overrides).kwargs).to eq(overrides[:kwargs])
        end
      end

      context "when `overrides[:block]` is passed" do
        let(:overrides) { {block: proc { :bar }} }

        it "merges `to_arguments.block` with `overrides[:block]`" do
          expect(instance.copy(overrides: overrides).block).to eq(overrides[:block])
        end
      end

      context "when `overrides` is passed" do
        let(:overrides) { {block: proc { :bar }} }

        it "does NOT mutate `overrides`" do
          overrides.freeze

          ##
          # NOTE: Using specific error in `not_to raise_error` may lead to false positives.
          # - https://stackoverflow.com/questions/44515447/best-practices-for-rspec-expect-raise-error
          # - https://github.com/rspec/rspec-expectations/issues/231
          #
          expect { instance.copy(overrides: overrides) }.not_to raise_error
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
