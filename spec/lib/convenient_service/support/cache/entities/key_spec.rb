# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Support::Cache::Entities::Key, type: :standard do
  include ConvenientService::RSpec::Matchers::DelegateTo

  let(:args) { [:foo] }
  let(:kwargs) { {foo: :bar} }
  let(:block) { proc { :foo } }
  let(:key) { described_class.new(*args, **kwargs, &block) }

  example_group "instance methods" do
    describe "#==" do
      context "when `other` has different class" do
        let(:other) { 42 }

        it "returns `false`" do
          expect(key == other).to be_nil
        end
      end

      context "when `other` has different `args`" do
        let(:other) { described_class.new(:baz, **kwargs, &block) }

        it "returns `false`" do
          expect(key == other).to eq(false)
        end
      end

      context "when `other` has different `kwargs`" do
        let(:other) { described_class.new(*args, baz: :qux, &block) }

        it "returns `false`" do
          expect(key == other).to eq(false)
        end
      end

      context "when `other` has different `block`" do
        let(:other) { described_class.new(*args, **kwargs, &other_block) }
        let(:other_block) { proc { :baz } }

        it "returns `false`" do
          expect(key == other).to eq(false)
        end

        ##
        # TODO: Refactor.
        #
        # rubocop:disable Lint/Void, RSpec/ExampleLength
        it "uses `source_location` to compare blocks" do
          constructor_arguments_source_location = double
          other_block_source_location = double

          allow(block).to receive(:source_location).and_return(constructor_arguments_source_location)
          allow(other_block).to receive(:source_location).and_return(other_block_source_location)
          allow(constructor_arguments_source_location).to receive(:==).with(other_block_source_location)

          key == other

          expect(constructor_arguments_source_location).to have_received(:==)
        end
        # rubocop:enable Lint/Void, RSpec/ExampleLength
      end

      context "when `other` has same attributes" do
        let(:other) { described_class.new(*args, **kwargs, &block) }

        it "returns `true`" do
          expect(key == other).to eq(true)
        end
      end
    end

    describe "#eql?" do
      context "when `other` has different class" do
        let(:other) { 42 }

        it "returns `false`" do
          expect(key.eql?(other)).to be_nil
        end
      end

      context "when `other` has different `args`" do
        let(:other) { described_class.new(:baz, **kwargs, &block) }

        it "returns `false`" do
          expect(key.eql?(other)).to eq(false)
        end
      end

      context "when `other` has different `kwargs`" do
        let(:other) { described_class.new(*args, baz: :qux, &block) }

        it "returns `false`" do
          expect(key.eql?(other)).to eq(false)
        end
      end

      context "when `other` has different `block`" do
        let(:other) { described_class.new(*args, **kwargs, &other_block) }
        let(:other_block) { proc { :baz } }

        it "returns `false`" do
          expect(key.eql?(other)).to eq(false)
        end

        ##
        # TODO: Refactor.
        #
        # rubocop:disable Lint/Void, RSpec/ExampleLength
        it "uses `source_location` to compare blocks" do
          constructor_arguments_source_location = double
          other_block_source_location = double

          allow(block).to receive(:source_location).and_return(constructor_arguments_source_location)
          allow(other_block).to receive(:source_location).and_return(other_block_source_location)
          allow(constructor_arguments_source_location).to receive(:==).with(other_block_source_location)

          key.eql?(other)

          expect(constructor_arguments_source_location).to have_received(:==)
        end
        # rubocop:enable Lint/Void, RSpec/ExampleLength
      end

      context "when `other` has same attributes" do
        let(:other) { described_class.new(*args, **kwargs, &block) }

        it "returns `true`" do
          expect(key.eql?(other)).to eq(true)
        end
      end
    end

    describe "#hash" do
      it "returns hash based on class, `args`, `kwargs`, and `block` source location" do
        expect(key.hash).to eq([described_class, args, kwargs, block.source_location].hash)
      end

      context "when `block` in `nil`" do
        let(:block) { nil }

        it "uses `nil` hash for `block`" do
          expect(key.hash).to eq([described_class, args, kwargs, nil].hash)
        end
      end
    end
  end

  example_group "usage" do
    context "when used as hash keys" do
      let(:map) { {} }

      let(:value) { :foo }

      let(:command) do
        map[key] = value
        map[other_key] = value
      end

      context "when those keys do NOT cause collision (calling `#hash` returns different numbers)" do
        let(:key) { described_class.new(:foo) }
        let(:other_key) { described_class.new(:bar) }

        ##
        # NOTE: Do NOT use custom RSpec helpers and matchers inside Utils and Support to avoid cyclic module dependencies.
        #
        # rubocop:disable RSpec/MultipleExpectations, RSpec/MessageSpies, RSpec/ExampleLength
        it "delegates to `key#hash`" do
          expect(key)
            .to receive(:hash)
              .and_wrap_original { |original, *actual_args, **actual_kwargs, &actual_block|
                expect([actual_args, actual_kwargs, actual_block]).to eq([[], {}, nil])

                original.call(*actual_args, **actual_kwargs, &actual_block)
              }

          command
        end
        # rubocop:enable RSpec/MultipleExpectations, RSpec/MessageSpies, RSpec/ExampleLength

        ##
        # NOTE: Do NOT use custom RSpec helpers and matchers inside Utils and Support to avoid cyclic module dependencies.
        #
        # rubocop:disable RSpec/MultipleExpectations, RSpec/MessageSpies, RSpec/ExampleLength
        it "delegates to `other_key#hash`" do
          expect(other_key)
            .to receive(:hash)
              .and_wrap_original { |original, *actual_args, **actual_kwargs, &actual_block|
                expect([actual_args, actual_kwargs, actual_block]).to eq([[], {}, nil])

                original.call(*actual_args, **actual_kwargs, &actual_block)
              }

          command
        end
        # rubocop:enable RSpec/MultipleExpectations, RSpec/MessageSpies, RSpec/ExampleLength

        ##
        # NOTE: Do NOT use custom RSpec helpers and matchers inside Utils and Support to avoid cyclic module dependencies.
        #
        # rubocop:disable RSpec/MultipleExpectations, RSpec/MessageSpies, RSpec/ExampleLength
        it "does NOT delegate to `key#eql?`" do
          expect(key)
            .not_to receive(:eql?)
              .and_wrap_original { |original, *actual_args, **actual_kwargs, &actual_block|
                expect([actual_args, actual_kwargs, actual_block]).to eq([[key], {}, nil])

                original.call(*actual_args, **actual_kwargs, &actual_block)
              }

          command
        end
        # rubocop:enable RSpec/MultipleExpectations, RSpec/MessageSpies, RSpec/ExampleLength

        ##
        # NOTE: Do NOT use custom RSpec helpers and matchers inside Utils and Support to avoid cyclic module dependencies.
        #
        # rubocop:disable RSpec/MultipleExpectations, RSpec/MessageSpies, RSpec/ExampleLength
        it "delegates to `other_key#eql?`" do
          expect(other_key)
            .not_to receive(:eql?)
              .and_wrap_original { |original, *actual_args, **actual_kwargs, &actual_block|
                expect([actual_args, actual_kwargs, actual_block]).to eq([[key], {}, nil])

                original.call(*actual_args, **actual_kwargs, &actual_block)
              }, "Flaky collision found: key.object_id - `#{key.object_id}`, other_key.object_id - `#{other_key.object_id}`, key.hash - `#{key.hash}`, other_key.hash - `#{other_key.hash}`."

          command
        end
        # rubocop:enable RSpec/MultipleExpectations, RSpec/MessageSpies, RSpec/ExampleLength
      end

      context "when those keys cause collision (calling `#hash` returns same numbers)" do
        let(:key) { described_class.new(:foo) }
        let(:other_key) { described_class.new(:foo) }

        ##
        # NOTE: Do NOT use custom RSpec helpers and matchers inside Utils and Support to avoid cyclic module dependencies.
        #
        # rubocop:disable RSpec/MultipleExpectations, RSpec/MessageSpies, RSpec/ExampleLength
        it "delegates to `key#hash`" do
          expect(key)
            .to receive(:hash)
              .and_wrap_original { |original, *actual_args, **actual_kwargs, &actual_block|
                expect([actual_args, actual_kwargs, actual_block]).to eq([[], {}, nil])

                original.call(*actual_args, **actual_kwargs, &actual_block)
              }

          command
        end
        # rubocop:enable RSpec/MultipleExpectations, RSpec/MessageSpies, RSpec/ExampleLength

        ##
        # NOTE: Do NOT use custom RSpec helpers and matchers inside Utils and Support to avoid cyclic module dependencies.
        #
        # rubocop:disable RSpec/MultipleExpectations, RSpec/MessageSpies, RSpec/ExampleLength
        it "delegates to `other_key#hash`" do
          expect(other_key)
            .to receive(:hash)
              .and_wrap_original { |original, *actual_args, **actual_kwargs, &actual_block|
                expect([actual_args, actual_kwargs, actual_block]).to eq([[], {}, nil])

                original.call(*actual_args, **actual_kwargs, &actual_block)
              }

          command
        end
        # rubocop:enable RSpec/MultipleExpectations, RSpec/MessageSpies, RSpec/ExampleLength

        ##
        # NOTE: Do NOT use custom RSpec helpers and matchers inside Utils and Support to avoid cyclic module dependencies.
        #
        # rubocop:disable RSpec/MultipleExpectations, RSpec/MessageSpies, RSpec/ExampleLength
        it "does NOT delegate to `key#eql?`" do
          expect(key)
            .not_to receive(:eql?)
              .and_wrap_original { |original, *actual_args, **actual_kwargs, &actual_block|
                expect([actual_args, actual_kwargs, actual_block]).to eq([[key], {}, nil])

                original.call(*actual_args, **actual_kwargs, &actual_block)
              }

          command
        end
        # rubocop:enable RSpec/MultipleExpectations, RSpec/MessageSpies, RSpec/ExampleLength

        ##
        # NOTE: Do NOT use custom RSpec helpers and matchers inside Utils and Support to avoid cyclic module dependencies.
        #
        # rubocop:disable RSpec/MultipleExpectations, RSpec/MessageSpies, RSpec/ExampleLength
        it "delegates to `other_key#eql?`" do
          expect(other_key)
            .to receive(:eql?)
              .and_wrap_original { |_original, *actual_args, **actual_kwargs, &actual_block| expect([actual_args, actual_kwargs, actual_block]).to eq([[key], {}, nil]) }

          command
        end
        # rubocop:enable RSpec/MultipleExpectations, RSpec/MessageSpies, RSpec/ExampleLength

        context "when those keys are NOT equal in `#eql?` terms" do
          let(:collision_hash) { 42 }

          before do
            allow(key).to receive(:hash).and_return(collision_hash)
            allow(other_key).to receive(:hash).and_return(collision_hash)
          end

          context "when `#eql?` returns `nil`" do
            let(:key) { described_class.new(:foo) }
            let(:other_key) { Object.new }

            it "considers other key that caused collision as separate key" do
              command

              expect(map.keys.size).to eq(2)
            end
          end

          context "when `#eql?` returns `false`" do
            let(:key) { described_class.new(:foo) }
            let(:other_key) { described_class.new(:bar) }

            it "considers other key that caused collision as separate key" do
              command

              expect(map.keys.size).to eq(2)
            end
          end
        end

        context "when those keys are equal in `#eql?` terms" do
          context "when `#eql?` returns `true`" do
            let(:key) { described_class.new(:foo) }
            let(:other_key) { described_class.new(:foo) }

            it "considers other key that caused collision as same key" do
              command

              expect(map.keys.size).to eq(1)
            end
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
