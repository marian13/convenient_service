# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

RSpec.describe ConvenientService::Utils::String do
  include ConvenientService::RSpec::Matchers::DelegateTo

  describe ".camelize" do
    let(:string) { "foo" }

    specify do
      expect { described_class.camelize(string) }
        .to delegate_to(ConvenientService::Utils::String::Camelize, :call)
        .with_arguments(string)
        .and_return_its_value
    end
  end

  describe ".demodulize" do
    let(:string) { "Inflections" }

    specify do
      expect { described_class.demodulize(string) }
        .to delegate_to(ConvenientService::Utils::String::Demodulize, :call)
        .with_arguments(string)
        .and_return_its_value
    end
  end

  describe ".split" do
    let(:string) { "foo.bar" }
    let(:delimiters) { "." }

    specify do
      expect { described_class.split(string, *delimiters) }
        .to delegate_to(ConvenientService::Utils::String::Split, :call)
        .with_arguments(string, *delimiters)
        .and_return_its_value
    end
  end
end
