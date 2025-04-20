# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

RSpec.describe ConvenientService::Utils::Module, type: :standard do
  include ConvenientService::RSpec::Matchers::DelegateTo

  describe ".fetch_own_const" do
    let(:mod) { Class.new }
    let(:const_name) { :NotExistingConst }
    let(:fallback_block) { proc { 42 } }

    specify do
      expect { described_class.fetch_own_const(mod, const_name, &fallback_block) }
        .to delegate_to(described_class::FetchOwnConst, :call)
        .with_arguments(mod, const_name, &fallback_block)
        .and_return_its_value
    end
  end

  describe ".get_namespace" do
    let(:mod) { Enumerator::Lazy }

    specify do
      expect { described_class.get_namespace(mod) }
        .to delegate_to(described_class::GetNamespace, :call)
        .with_arguments(mod)
        .and_return_its_value
    end
  end

  describe ".get_own_const" do
    let(:mod) { Class.new }
    let(:const_name) { :NotExistingConst }

    specify do
      expect { described_class.get_own_const(mod, const_name) }
        .to delegate_to(described_class::GetOwnConst, :call)
        .with_arguments(mod, const_name)
        .and_return_its_value
    end
  end

  describe ".get_own_instance_method" do
    let(:mod) { Class.new }
    let(:method_name) { :result }

    specify do
      expect { described_class.get_own_instance_method(mod, method_name) }
        .to delegate_to(described_class::GetOwnInstanceMethod, :call)
        .with_arguments(mod, method_name)
        .and_return_its_value
    end
  end

  describe ".include_module?" do
    let(:mod) { Class.new }
    let(:other_mod) { Module.new }

    specify do
      expect { described_class.include_module?(mod, other_mod) }
        .to delegate_to(described_class::IncludeModule, :call)
        .with_arguments(mod, other_mod)
        .and_return_its_value
    end
  end

  describe ".has_own_instance_method?" do
    let(:mod) { Class.new }
    let(:method_name) { :foo }

    specify do
      expect { described_class.has_own_instance_method?(mod, method_name) }
        .to delegate_to(described_class::HasOwnInstanceMethod, :call)
        .with_arguments(mod, method_name)
        .and_return_its_value
    end
  end
end
