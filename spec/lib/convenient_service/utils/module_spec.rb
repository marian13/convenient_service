require "spec_helper"

require "convenient_service"

RSpec.describe ConvenientService::Utils::Module do
  include ConvenientService::RSpec::Matchers::DelegateTo

  describe ".get_own_const" do
    let(:mod) { Class.new }
    let(:const_name) { :NotExistingConst }

    specify do
      expect { described_class.get_own_const(mod, const_name) }
        .to delegate_to(ConvenientService::Utils::Module::GetOwnConst, :call)
        .with_arguments(mod, const_name)
        .and_return_its_value
    end
  end

  describe ".get_own_instance_method" do
    let(:mod) { Class.new }
    let(:method_name) { :result }

    specify do
      expect { described_class.get_own_instance_method(mod, method_name) }
        .to delegate_to(ConvenientService::Utils::Module::GetOwnInstanceMethod, :call)
        .with_arguments(mod, method_name)
        .and_return_its_value
    end
  end

  describe ".has_own_instance_method?" do
    let(:mod) { Class.new }
    let(:method_name) { :foo }

    specify do
      expect { described_class.has_own_instance_method?(mod, method_name) }
        .to delegate_to(ConvenientService::Utils::Module::HasOwnInstanceMethod, :call)
        .with_arguments(mod, method_name)
        .and_return_its_value
    end
  end
end
