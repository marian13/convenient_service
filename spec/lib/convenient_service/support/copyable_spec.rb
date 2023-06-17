# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Support::Copyable do
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

          def to_args
            args
          end

          def to_kwargs
            kwargs
          end

          def to_block
            block
          end
        end
      end

      let(:klass) { Class.new(base_class) }
      let(:instance) { klass.new(*constructor_arguments[:args], **constructor_arguments[:kwargs], &constructor_arguments[:block]) }

      let(:constructor_arguments) do
        {
          args: [:foo, :bar],
          kwargs: {foo: 0, bar: 1},
          block: proc { :foo }
        }
      end

      it "returns copy" do
        expect(instance.copy).to eq(instance)
      end

      it "delegates to `to_args`" do
        allow(instance).to receive(:to_args).and_call_original

        instance.copy

        expect(instance).to have_received(:to_args)
      end

      it "delegates to `to_kwargs`" do
        allow(instance).to receive(:to_kwargs).and_call_original

        instance.copy

        expect(instance).to have_received(:to_kwargs)
      end

      it "delegates to `to_block`" do
        allow(instance).to receive(:to_block).and_call_original

        instance.copy

        expect(instance).to have_received(:to_block)
      end

      context "when `overrides[:args]` is NOT passed" do
        let(:overrides) { {} }

        it "defaults to empty hash`" do
          expect(instance.copy(overrides: overrides).args).to eq(constructor_arguments[:args])
        end
      end

      context "when `overrides[:args]` is passed" do
        context "when `overrides[:args]` is array" do
          let(:overrides) { {args: [:baz, :qux]} }

          it "replaces `to_args` with `overrides[:args]`" do
            expect(instance.copy(overrides: overrides).args).to eq(overrides[:args])
          end
        end

        context "when `overrides[:args]` is hash" do
          let(:overrides) { {args: {0 => :baz, 1 => :qux}} }

          it "merges `to_args` with `overrides[:args]`" do
            expect(instance.copy(overrides: overrides).args).to eq(overrides[:args].values)
          end

          it "delegates to `ConvenientService::Utils::Array.merge`" do
            allow(ConvenientService::Utils::Array).to receive(:merge).with(instance.to_args, overrides[:args]).and_call_original

            instance.copy(overrides: overrides)

            expect(ConvenientService::Utils::Array).to have_received(:merge)
          end
        end
      end

      context "when `overrides[:kwargs]` is NOT passed" do
        let(:overrides) { {} }

        it "defaults to empty hash`" do
          expect(instance.copy(overrides: overrides).kwargs).to eq(constructor_arguments[:kwargs])
        end
      end

      context "when `overrides[:kwargs]` is passed" do
        let(:overrides) { {kwargs: {foo: 3, bar: 4}} }

        it "merges `to_kwargs` with `overrides[:kwargs]`" do
          expect(instance.copy(overrides: overrides).kwargs).to eq(overrides[:kwargs])
        end
      end

      context "when `overrides[:block]` is passed" do
        let(:overrides) { {block: proc { :bar }} }

        it "merges `to_block` with `overrides[:block]`" do
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

      context "when `to_args` is NOT implemented" do
        let(:klass) do
          Class.new(base_class) do
            undef to_args
          end
        end

        it "uses empty array as `args`" do
          expect(instance.copy.args).to eq([])
        end
      end

      context "when `to_kwargs` is NOT implemented" do
        let(:klass) do
          Class.new(base_class) do
            undef to_kwargs
          end
        end

        it "uses empty hash as `kwargs`" do
          expect(instance.copy.kwargs).to eq({})
        end
      end

      context "when `to_block` is NOT implemented" do
        let(:klass) do
          Class.new(base_class) do
            undef to_block
          end
        end

        it "uses `nil` as `block`" do
          expect(instance.copy.block).to be_nil
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
