# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

RSpec.describe ConvenientService::Utils::Object, type: :standard do
  describe ".clamp_class" do
    let(:object) { :foo }

    # rubocop:disable RSpec/MultipleExpectations, RSpec/MessageSpies
    it "delegates to `ConvenientService::Utils::Module::ClampClass.call`" do
      expect(described_class::ClampClass)
        .to receive(:call)
          .and_wrap_original { |_original, *actual_args, **actual_kwargs, &actual_block| expect([actual_args, actual_kwargs, actual_block]).to eq([[object], {}, nil]) }

      described_class.clamp_class(object)
    end
    # rubocop:enable RSpec/MultipleExpectations, RSpec/MessageSpies

    it "returns `ConvenientService::Utils::Module::ClampClass.call` value" do
      expect(described_class.clamp_class(object)).to eq(described_class::ClampClass.call(object))
    end
  end

  describe ".duck_class" do
    let(:object) { :foo }

    # rubocop:disable RSpec/MultipleExpectations, RSpec/MessageSpies
    it "delegates to `ConvenientService::Utils::Object::DuckClass.call`" do
      expect(described_class::DuckClass)
        .to receive(:call)
          .and_wrap_original { |_original, *actual_args, **actual_kwargs, &actual_block| expect([actual_args, actual_kwargs, actual_block]).to eq([[object], {}, nil]) }

      described_class.duck_class(object)
    end
    # rubocop:enable RSpec/MultipleExpectations, RSpec/MessageSpies

    it "returns `ConvenientService::Utils::Object::DuckClass.call` value" do
      expect(described_class.duck_class(object)).to eq(described_class::DuckClass.call(object))
    end
  end

  describe ".instance_variable_delete" do
    let(:object) { Object.new }
    let(:ivar_name) { :@foo }

    # rubocop:disable RSpec/MultipleExpectations, RSpec/MessageSpies
    it "delegates to `ConvenientService::Utils::Object::InstanceVariableDelete.call`" do
      expect(described_class::InstanceVariableDelete)
        .to receive(:call)
          .and_wrap_original { |_original, *actual_args, **actual_kwargs, &actual_block| expect([actual_args, actual_kwargs, actual_block]).to eq([[object, ivar_name], {}, nil]) }

      described_class.instance_variable_delete(object, ivar_name)
    end
    # rubocop:enable RSpec/MultipleExpectations, RSpec/MessageSpies

    it "returns `ConvenientService::Utils::Object::InstanceVariableDelete.call` value" do
      expect(described_class.instance_variable_delete(object, ivar_name)).to eq(described_class::InstanceVariableDelete.call(object, ivar_name))
    end
  end

  describe ".instance_variable_fetch" do
    let(:object) { Object.new }
    let(:ivar_name) { :@foo }
    let(:fallback_block) { proc { :bar } }

    # rubocop:disable RSpec/MultipleExpectations, RSpec/MessageSpies
    it "delegates to `ConvenientService::Utils::Object::InstanceVariableFetch.call`" do
      expect(described_class::InstanceVariableFetch)
        .to receive(:call)
          .and_wrap_original { |_original, *actual_args, **actual_kwargs, &actual_block| expect([actual_args, actual_kwargs, actual_block]).to eq([[object, ivar_name], {}, fallback_block]) }

      described_class.instance_variable_fetch(object, ivar_name, &fallback_block)
    end
    # rubocop:enable RSpec/MultipleExpectations, RSpec/MessageSpies

    it "returns `ConvenientService::Utils::Object::InstanceVariableFetch.call` value" do
      expect(described_class.instance_variable_fetch(object, ivar_name, &fallback_block)).to eq(described_class::InstanceVariableFetch.call(object, ivar_name, &fallback_block))
    end
  end

  describe ".memoize_including_falsy_values" do
    let(:object) { Object.new }
    let(:ivar_name) { :@foo }
    let(:value_block) { proc { false } }

    # rubocop:disable RSpec/MultipleExpectations, RSpec/MessageSpies
    it "delegates to `ConvenientService::Utils::Object::MemoizeIncludingFalsyValues.call`" do
      expect(described_class::MemoizeIncludingFalsyValues)
        .to receive(:call)
          .and_wrap_original { |_original, *actual_args, **actual_kwargs, &actual_block| expect([actual_args, actual_kwargs, actual_block]).to eq([[object, ivar_name], {}, value_block]) }

      described_class.memoize_including_falsy_values(object, ivar_name, &value_block)
    end
    # rubocop:enable RSpec/MultipleExpectations, RSpec/MessageSpies

    it "returns `ConvenientService::Utils::Object::MemoizeIncludingFalsyValues.call` value" do
      expect(described_class.memoize_including_falsy_values(object, ivar_name, &value_block)).to eq(described_class::MemoizeIncludingFalsyValues.call(object, ivar_name, &value_block))
    end
  end

  describe ".resolve_type" do
    let(:object) { Kernel }

    # rubocop:disable RSpec/MultipleExpectations, RSpec/MessageSpies
    it "delegates to `ConvenientService::Utils::Object::ResolveType.call`" do
      expect(described_class::ResolveType)
        .to receive(:call)
          .and_wrap_original { |_original, *actual_args, **actual_kwargs, &actual_block| expect([actual_args, actual_kwargs, actual_block]).to eq([[object], {}, nil]) }

      described_class.resolve_type(object)
    end
    # rubocop:enable RSpec/MultipleExpectations, RSpec/MessageSpies

    it "returns `ConvenientService::Utils::Object::ResolveType.call` value" do
      expect(described_class.resolve_type(object)).to eq(described_class::ResolveType.call(object))
    end
  end

  describe ".safe_send" do
    let(:object) do
      Object.new.tap do |object|
        object.define_singleton_method(:foo) do |*args, **kwargs, &block|
          [__method__, args, kwargs, block]
        end
      end
    end

    let(:method) { :foo }
    let(:args) { [:foo] }
    let(:kwargs) { {foo: :bar} }
    let(:block) { proc { :foo } }

    # rubocop:disable RSpec/MultipleExpectations, RSpec/MessageSpies
    it "delegates to `ConvenientService::Utils::Object::SafeSend.call`" do
      expect(described_class::SafeSend)
        .to receive(:call)
          .and_wrap_original { |_original, *actual_args, **actual_kwargs, &actual_block| expect([actual_args, actual_kwargs, actual_block]).to eq([[object, method, *args], kwargs, block]) }

      described_class.safe_send(object, method, *args, **kwargs, &block)
    end
    # rubocop:enable RSpec/MultipleExpectations, RSpec/MessageSpies

    it "returns `ConvenientService::Utils::Object::SafeSend.call` value" do
      expect(described_class.safe_send(object, method, *args, **kwargs, &block)).to eq(described_class::SafeSend.call(object, method, *args, **kwargs, &block))
    end
  end

  describe ".with_one_time_object" do
    let(:block) { proc { |one_time_object| :foo } }

    # rubocop:disable RSpec/MultipleExpectations, RSpec/MessageSpies
    it "delegates to `ConvenientService::Utils::Object::WithOneTimeObject.call`" do
      expect(described_class::WithOneTimeObject)
        .to receive(:call)
          .and_wrap_original { |_original, *actual_args, **actual_kwargs, &actual_block| expect([actual_args, actual_kwargs, actual_block]).to eq([[], {}, block]) }

      described_class.with_one_time_object(&block)
    end
    # rubocop:enable RSpec/MultipleExpectations, RSpec/MessageSpies

    it "returns `ConvenientService::Utils::Object::WithOneTimeObject.call` value" do
      expect(described_class.with_one_time_object(&block)).to eq(described_class::WithOneTimeObject.call(&block))
    end
  end
end
