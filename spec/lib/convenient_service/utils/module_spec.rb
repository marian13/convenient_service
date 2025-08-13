# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

RSpec.describe ConvenientService::Utils::Module, type: :standard do
  describe ".fetch_own_const" do
    let(:mod) { Class.new }
    let(:const_name) { :NotExistingConst }
    let(:fallback_block) { proc { 42 } }

    # rubocop:disable RSpec/MultipleExpectations, RSpec/MessageSpies
    it "delegates to `ConvenientService::Utils::Module::FetchOwnConst.call`" do
      expect(described_class::FetchOwnConst)
        .to receive(:call)
          .and_wrap_original { |_original, *actual_args, **actual_kwargs, &actual_block| expect([actual_args, actual_kwargs, actual_block]).to eq([[mod, const_name], {}, fallback_block]) }

      described_class.fetch_own_const(mod, const_name, &fallback_block)
    end
    # rubocop:enable RSpec/MultipleExpectations, RSpec/MessageSpies

    it "returns `ConvenientService::Utils::Module::FetchOwnConst.call` value" do
      expect(described_class.fetch_own_const(mod, const_name, &fallback_block)).to eq(described_class::FetchOwnConst.call(mod, const_name, &fallback_block))
    end
  end

  describe ".get_namespace" do
    let(:mod) { Enumerator::Lazy }

    # rubocop:disable RSpec/MultipleExpectations, RSpec/MessageSpies
    it "delegates to `ConvenientService::Utils::Module::GetNamespace.call`" do
      expect(described_class::GetNamespace)
        .to receive(:call)
          .and_wrap_original { |_original, *actual_args, **actual_kwargs, &actual_block| expect([actual_args, actual_kwargs, actual_block]).to eq([[mod], {}, nil]) }

      described_class.get_namespace(mod)
    end
    # rubocop:enable RSpec/MultipleExpectations, RSpec/MessageSpies

    it "returns `ConvenientService::Utils::Module::GetNamespace.call` value" do
      expect(described_class.get_namespace(mod)).to eq(described_class::GetNamespace.call(mod))
    end
  end

  describe ".get_own_const" do
    let(:mod) { Class.new }
    let(:const_name) { :NotExistingConst }

    # rubocop:disable RSpec/MultipleExpectations, RSpec/MessageSpies
    it "delegates to `ConvenientService::Utils::Module::GetOwnConst.call`" do
      expect(described_class::GetOwnConst)
        .to receive(:call)
          .and_wrap_original { |_original, *actual_args, **actual_kwargs, &actual_block| expect([actual_args, actual_kwargs, actual_block]).to eq([[mod, const_name], {}, nil]) }

      described_class.get_own_const(mod, const_name)
    end
    # rubocop:enable RSpec/MultipleExpectations, RSpec/MessageSpies

    it "returns `ConvenientService::Utils::Module::GetOwnConst.call` value" do
      expect(described_class.get_own_const(mod, const_name)).to eq(described_class::GetOwnConst.call(mod, const_name))
    end
  end

  describe ".get_own_instance_method" do
    let(:mod) { Class.new }
    let(:method_name) { :result }

    # rubocop:disable RSpec/MultipleExpectations, RSpec/MessageSpies
    it "delegates to `ConvenientService::Utils::Module::GetOwnInstanceMethod.call`" do
      expect(described_class::GetOwnInstanceMethod)
        .to receive(:call)
          .and_wrap_original { |_original, *actual_args, **actual_kwargs, &actual_block| expect([actual_args, actual_kwargs, actual_block]).to eq([[mod, method_name], {}, nil]) }

      described_class.get_own_instance_method(mod, method_name)
    end
    # rubocop:enable RSpec/MultipleExpectations, RSpec/MessageSpies

    it "returns `ConvenientService::Utils::Module::GetOwnInstanceMethod.call` value" do
      expect(described_class.get_own_instance_method(mod, method_name)).to eq(described_class::GetOwnInstanceMethod.call(mod, method_name))
    end
  end

  describe ".include_module?" do
    let(:mod) { Class.new }
    let(:other_mod) { Module.new }

    # rubocop:disable RSpec/MultipleExpectations, RSpec/MessageSpies
    it "delegates to `ConvenientService::Utils::Module::IncludeModule.call`" do
      expect(described_class::IncludeModule)
        .to receive(:call)
          .and_wrap_original { |_original, *actual_args, **actual_kwargs, &actual_block| expect([actual_args, actual_kwargs, actual_block]).to eq([[mod, other_mod], {}, nil]) }

      described_class.include_module?(mod, other_mod)
    end
    # rubocop:enable RSpec/MultipleExpectations, RSpec/MessageSpies

    it "returns `ConvenientService::Utils::Module::IncludeModule.call` value" do
      expect(described_class.include_module?(mod, other_mod)).to eq(described_class::IncludeModule.call(mod, other_mod))
    end
  end

  describe ".has_own_instance_method?" do
    let(:mod) { Class.new }
    let(:method_name) { :foo }

    # rubocop:disable RSpec/MultipleExpectations, RSpec/MessageSpies
    it "delegates to `ConvenientService::Utils::Module::HasOwnInstanceMethod.call`" do
      expect(described_class::HasOwnInstanceMethod)
        .to receive(:call)
          .and_wrap_original { |_original, *actual_args, **actual_kwargs, &actual_block| expect([actual_args, actual_kwargs, actual_block]).to eq([[mod, method_name], {}, nil]) }

      described_class.has_own_instance_method?(mod, method_name)
    end
    # rubocop:enable RSpec/MultipleExpectations, RSpec/MessageSpies

    it "returns `ConvenientService::Utils::Module::HasOwnInstanceMethod.call` value" do
      expect(described_class.has_own_instance_method?(mod, method_name)).to eq(described_class::HasOwnInstanceMethod.call(mod, method_name))
    end
  end
end
