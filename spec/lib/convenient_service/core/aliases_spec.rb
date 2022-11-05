# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/DescribeClass
RSpec.describe "convenient_service/core/aliases" do
  specify { expect(ConvenientService::Core::ClassicMiddleware).to eq(ConvenientService::Core::Entities::ClassicMiddleware) }
  specify { expect(ConvenientService::Core::ConcernMiddleware).to eq(ConvenientService::Core::Entities::Config::Entities::Concerns::Entities::Middleware) }
  specify { expect(ConvenientService::Core::MethodChainMiddleware).to eq(ConvenientService::Core::Entities::Config::Entities::MethodMiddlewares::Entities::Middleware) }
end
# rubocop:enable RSpec/DescribeClass
