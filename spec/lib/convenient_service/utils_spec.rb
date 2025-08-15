# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Utils, type: :standard do
  example_group "class methods" do
    describe ".to_bool" do
      let(:object) { :foo }

      it "delegates to `ConvenientService::Utils::Bool::ToBool.call`" do
        allow(described_class::Bool::ToBool).to receive(:call).with(object).and_call_original

        described_class.to_bool(object)

        expect(described_class::Bool::ToBool).to have_received(:call).with(object)
      end

      it "returns `ConvenientService::Utils::Bool::ToBool.call` value" do
        expect(described_class.to_bool(object)).to eq(described_class::Bool::ToBool.call(object))
      end
    end

    describe ".safe_send" do
      let(:klass) do
        Class.new do
          def foo(*args, **kwargs, &block)
            [__method__, args, kwargs, block]
          end
        end
      end

      let(:object) { klass.new }

      let(:method) { :foo }
      let(:args) { [:foo] }
      let(:kwargs) { {foo: :bar} }
      let(:block) { proc { :foo } }

      ##
      # NOTE: Do NOT use custom RSpec helpers and matchers inside Utils and Support to avoid cyclic module dependencies.
      #
      # rubocop:disable RSpec/MultipleExpectations, RSpec/MessageSpies, RSpec/ExampleLength
      it "delegates to `ConvenientService::Utils::Object::SafeSend.call`" do
        expect(described_class::Object::SafeSend)
          .to receive(:call)
            .and_wrap_original { |original, *actual_args, **actual_kwargs, &actual_block|
              expect([actual_args, actual_kwargs, actual_block]).to eq([[object, method, *args], kwargs, block])

              original.call(*actual_args, **actual_kwargs, &actual_block)
            }

        described_class.safe_send(object, method, *args, **kwargs, &block)
      end
      # rubocop:enable RSpec/MultipleExpectations, RSpec/MessageSpies, RSpec/ExampleLength

      it "returns `ConvenientService::Utils::Object::SafeSend.call` value" do
        expect(described_class.safe_send(object, method, *args, **kwargs, &block)).to eq(described_class::Object::SafeSend.call(object, method, *args, **kwargs, &block))
      end
    end

    describe ".memoize_including_falsy_values" do
      let(:object) { Object.new }
      let(:ivar_name) { :@foo }
      let(:value_block) { proc { false } }

      ##
      # NOTE: Do NOT use custom RSpec helpers and matchers inside Utils and Support to avoid cyclic module dependencies.
      #
      # rubocop:disable RSpec/MultipleExpectations, RSpec/MessageSpies, RSpec/ExampleLength
      it "delegates to `ConvenientService::Utils::Object::MemoizeIncludingFalsyValues.call`" do
        expect(described_class::Object::MemoizeIncludingFalsyValues)
          .to receive(:call)
            .and_wrap_original { |original, *actual_args, **actual_kwargs, &actual_block|
              expect([actual_args, actual_kwargs, actual_block]).to eq([[object, ivar_name], {}, value_block])

              original.call(*actual_args, **actual_kwargs, &actual_block)
            }

        described_class.memoize_including_falsy_values(object, ivar_name, &value_block)
      end
      # rubocop:enable RSpec/MultipleExpectations, RSpec/MessageSpies, RSpec/ExampleLength

      it "returns `ConvenientService::Utils::Object::MemoizeIncludingFalsyValues.call` value" do
        expect(described_class.memoize_including_falsy_values(object, ivar_name, &value_block)).to eq(described_class::Object::MemoizeIncludingFalsyValues.call(object, ivar_name, &value_block))
      end
    end

    describe ".with_one_time_object" do
      let(:block) { proc { |one_time_object| :foo } }

      ##
      # NOTE: Do NOT use custom RSpec helpers and matchers inside Utils and Support to avoid cyclic module dependencies.
      #
      # rubocop:disable RSpec/MultipleExpectations, RSpec/MessageSpies, RSpec/ExampleLength
      it "delegates to `ConvenientService::Utils::Object::WithOneTimeObject.call`" do
        expect(described_class::Object::WithOneTimeObject)
          .to receive(:call)
            .and_wrap_original { |original, *actual_args, **actual_kwargs, &actual_block|
              expect([actual_args, actual_kwargs, actual_block]).to eq([[], {}, block])

              original.call(*actual_args, **actual_kwargs, &actual_block)
            }

        described_class.with_one_time_object(&block)
      end
      # rubocop:enable RSpec/MultipleExpectations, RSpec/MessageSpies, RSpec/ExampleLength

      it "returns `ConvenientService::Utils::Object::WithOneTimeObject.call` value" do
        expect(described_class.with_one_time_object(&block)).to eq(described_class::Object::WithOneTimeObject.call(&block))
      end
    end
  end
end
# rubocop:enable RSpec/MultipleMemoizedHelpers
