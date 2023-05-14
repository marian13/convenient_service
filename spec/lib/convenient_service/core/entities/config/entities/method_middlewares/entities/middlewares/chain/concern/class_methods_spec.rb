# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Core::Entities::Config::Entities::MethodMiddlewares::Entities::Middlewares::Chain::Concern::ClassMethods do
  include ConvenientService::RSpec::Matchers::DelegateTo

  example_group "class methods" do
    let(:middleware_class) { ConvenientService::Core::Entities::Config::Entities::MethodMiddlewares::Entities::Middlewares::Chain }

    describe "#chain_class" do
      it "returns `ConvenientService::Core::Entities::Config::Entities::MethodMiddlewares::Entities::Middlewares::Chain::Entities::MethodChain`" do
        expect(middleware_class.chain_class).to eq(ConvenientService::Core::Entities::Config::Entities::MethodMiddlewares::Entities::Middlewares::Chain::Entities::MethodChain)
      end
    end

    describe "to_observable_middleware" do
      specify do
        expect { middleware_class.to_observable_middleware }
          .to delegate_to(ConvenientService::Core::Entities::Config::Entities::MethodMiddlewares::Entities::Middlewares::Chain::Commands::CreateObservableMiddleware, :call)
          .with_arguments(middleware: ConvenientService::Core::Entities::Config::Entities::MethodMiddlewares::Entities::Middlewares::Base::Commands::CreateObservableMiddleware.call(middleware: middleware_class))
          .and_return_its_value
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
