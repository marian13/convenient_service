# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/DescribeClass
RSpec.describe "convenient_service/core/aliases" do
  specify { expect(ConvenientService::ConcernMiddleware).to eq(ConvenientService::Core::Entities::Config::Entities::Concerns::Entities::Middleware) }

  specify { expect(ConvenientService::MethodClassicMiddleware).to eq(ConvenientService::Core::Entities::Config::Entities::MethodMiddlewares::Entities::Middlewares::Classic) }
  specify { expect(ConvenientService::MethodChainMiddleware).to eq(ConvenientService::Core::Entities::Config::Entities::MethodMiddlewares::Entities::Middlewares::Chain) }
end
# rubocop:enable RSpec/DescribeClass
