# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

RSpec.describe ConvenientService::Core::Entities::ClassicMiddleware do
  let(:middleware) { described_class.new(stack) }

  let(:stack) { ConvenientService::Support::Middleware::StackBuilder.new }
  let(:env) { {foo: :bar} }

  example_group "instance methods" do
    describe "#call" do
      include ConvenientService::RSpec::Matchers::DelegateTo

      specify do
        expect { middleware.call(env) }
          .to delegate_to(stack, :call)
          .with_arguments(env)
          .and_return_its_value
      end
    end
  end
end
