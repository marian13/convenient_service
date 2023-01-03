# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

RSpec.describe ConvenientService::Utils::Proc do
  include ConvenientService::RSpec::Matchers::DelegateTo

  describe ".conjunct" do
    let(:procs) { [->(item) { item[:valid] }] }

    specify do
      expect { described_class.conjunct(procs) }
        .to delegate_to(ConvenientService::Utils::Proc::Conjunct, :call)
        .with_arguments(procs)
        .and_return_its_value
    end
  end

  describe ".display" do
    let(:proc) { -> { :foo } }

    specify do
      expect { described_class.display(proc) }
        .to delegate_to(ConvenientService::Utils::Proc::Display, :call)
        .with_arguments(proc)
        .and_return_its_value
    end
  end

  describe ".exec_config" do
    let(:proc) { ->(object) { object.reverse } }
    let(:object) { "abc" }

    specify do
      expect { described_class.exec_config(proc, object) }
        .to delegate_to(ConvenientService::Utils::Proc::ExecConfig, :call)
        .with_arguments(proc, object)
        .and_return_its_value
    end
  end
end
