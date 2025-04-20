# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

RSpec.describe ConvenientService::Utils::Object, type: :standard do
  include ConvenientService::RSpec::Matchers::DelegateTo

  describe ".clamp_class" do
    let(:object) { :foo }

    specify do
      expect { described_class.clamp_class(object) }
        .to delegate_to(described_class::ClampClass, :call)
        .with_arguments(object)
        .and_return_its_value
    end
  end

  describe ".duck_class" do
    let(:object) { :foo }

    specify do
      expect { described_class.duck_class(object) }
        .to delegate_to(described_class::DuckClass, :call)
        .with_arguments(object)
        .and_return_its_value
    end
  end

  describe ".instance_variable_delete" do
    let(:object) { Object.new }
    let(:ivar_name) { :@foo }

    specify do
      expect { described_class.instance_variable_delete(object, ivar_name) }
        .to delegate_to(described_class::InstanceVariableDelete, :call)
        .with_arguments(object, ivar_name)
        .and_return_its_value
    end
  end

  describe ".instance_variable_fetch" do
    let(:object) { Object.new }
    let(:ivar_name) { :@foo }
    let(:fallback_block) { proc { :bar } }

    specify do
      expect { described_class.instance_variable_fetch(object, ivar_name, &fallback_block) }
        .to delegate_to(described_class::InstanceVariableFetch, :call)
        .with_arguments(object, ivar_name, &fallback_block)
        .and_return_its_value
    end
  end

  describe ".memoize_including_falsy_values" do
    let(:object) { Object.new }
    let(:ivar_name) { :@foo }
    let(:value_block) { proc { false } }

    specify do
      expect { described_class.memoize_including_falsy_values(object, ivar_name, &value_block) }
        .to delegate_to(described_class::MemoizeIncludingFalsyValues, :call)
        .with_arguments(object, ivar_name, &value_block)
        .and_return_its_value
    end
  end

  describe ".resolve_type" do
    let(:object) { Kernel }

    specify do
      expect { described_class.resolve_type(object) }
        .to delegate_to(described_class::ResolveType, :call)
        .with_arguments(object)
        .and_return_its_value
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

    specify do
      expect { described_class.safe_send(object, method, *args, **kwargs, &block) }
        .to delegate_to(described_class::SafeSend, :call)
        .with_arguments(object, method, *args, **kwargs, &block)
        .and_return_its_value
    end
  end

  describe ".with_one_time_object" do
    let(:block) { proc { |one_time_object| :foo } }

    specify do
      expect { described_class.with_one_time_object(&block) }
        .to delegate_to(described_class::WithOneTimeObject, :call)
        .with_arguments(&block)
        .and_return_its_value
    end
  end
end
