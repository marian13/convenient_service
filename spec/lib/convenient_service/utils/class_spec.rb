# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

RSpec.describe ConvenientService::Utils::Class, type: :standard do
  include ConvenientService::RSpec::Matchers::DelegateTo

  describe ".display_name" do
    let(:klass) { Class.new }

    specify do
      expect { described_class.display_name(klass) }
        .to delegate_to(described_class::DisplayName, :call)
        .with_arguments(klass)
        .and_return_its_value
    end
  end

  if ConvenientService::Dependencies.ruby.version >= 3.2
    describe ".display_name" do
      let(:klass) { String.singleton_class }

      specify do
        expect { described_class.attached_object(klass) }
          .to delegate_to(described_class::GetAttachedObject, :call)
          .with_arguments(klass)
          .and_return_its_value
      end
    end
  end
end
