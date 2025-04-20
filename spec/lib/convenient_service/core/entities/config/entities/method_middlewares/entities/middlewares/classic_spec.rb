# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

RSpec.describe ConvenientService::Core::Entities::Config::Entities::MethodMiddlewares::Entities::Middlewares::Classic, type: :standard do
  let(:middleware_instance) { described_class.new(stack) }

  let(:stack) { ConvenientService::Support::Middleware::StackBuilder.new }
  let(:env) { {foo: :bar} }

  example_group "inheritance" do
    include ConvenientService::RSpec::PrimitiveMatchers::BeDescendantOf

    subject { described_class }

    it { is_expected.to be_descendant_of(ConvenientService::Core::Entities::Config::Entities::MethodMiddlewares::Entities::Middlewares::Base) }
  end

  example_group "instance methods" do
    describe "#call" do
      include ConvenientService::RSpec::Matchers::DelegateTo

      specify do
        expect { middleware_instance.call(env) }
          .to delegate_to(stack, :call)
          .with_arguments(env)
          .and_return_its_value
      end
    end

    describe "#stack" do
      it "returns stack" do
        expect(middleware_instance.stack).to eq(stack)
      end
    end
  end
end
