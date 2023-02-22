# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/DescribeClass
RSpec.describe "convenient_service/aliases" do
  specify { expect(ConvenientService::Command).to eq(ConvenientService::Support::Command) }
  specify { expect(ConvenientService::Concern).to eq(ConvenientService::Support::Concern) }
  specify { expect(ConvenientService::DependencyContainer).to eq(ConvenientService::Support::DependencyContainer) }

  specify { expect(ConvenientService::ClassicMiddleware).to eq(ConvenientService::Core::Entities::ClassicMiddleware) }
  specify { expect(ConvenientService::ConcernMiddleware).to eq(ConvenientService::Core::Entities::Config::Entities::Concerns::Entities::Middleware) }
  specify { expect(ConvenientService::MethodChainMiddleware).to eq(ConvenientService::Core::Entities::Config::Entities::MethodMiddlewares::Entities::Middleware) }
end
# rubocop:enable RSpec/DescribeClass
