# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Core::Entities::Config::Entities::MethodMiddlewares::Entities::Middlewares::Chain::Concern::ClassMethods do
  example_group "class methods" do
    let(:middleware_class) { ConvenientService::Core::Entities::Config::Entities::MethodMiddlewares::Entities::Middlewares::Chain }

    describe "#chain_class" do
      it "returns `ConvenientService::Core::Entities::Config::Entities::MethodMiddlewares::Entities::Middlewares::Chain::Entities::MethodChain`" do
        expect(middleware_class.chain_class).to eq(ConvenientService::Core::Entities::Config::Entities::MethodMiddlewares::Entities::Middlewares::Chain::Entities::MethodChain)
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
