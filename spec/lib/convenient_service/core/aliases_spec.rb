# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/DescribeClass
RSpec.describe "convenient_service/core/aliases", type: :standard do
  specify { expect(ConvenientService::ConcernMiddleware).to eq(ConvenientService::Core::Entities::Config::Entities::Concerns::Entities::Middleware) }

  specify { expect(ConvenientService::MethodClassicMiddleware).to eq(ConvenientService::Core::Entities::Config::Entities::MethodMiddlewares::Entities::Middlewares::Classic) }
  specify { expect(ConvenientService::MethodChainMiddleware).to eq(ConvenientService::Core::Entities::Config::Entities::MethodMiddlewares::Entities::Middlewares::Chain) }
end
# rubocop:enable RSpec/DescribeClass
