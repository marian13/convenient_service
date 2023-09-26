# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Core::Entities::Config::Entities::MethodMiddlewares::Entities::MiddlewareCreators::Observable do
  include ConvenientService::RSpec::PrimitiveMatchers::CacheItsValue
  include ConvenientService::RSpec::Matchers::DelegateTo

  let(:middleware_creator) { described_class.new(middleware: middleware) }
  let(:middleware) { Class.new(ConvenientService::Core::Entities::Config::Entities::MethodMiddlewares::Entities::Middlewares::Chain) }

  example_group "inheritance" do
    include ConvenientService::RSpec::PrimitiveMatchers::BeDescendantOf

    subject { described_class }

    it { is_expected.to be_descendant_of(ConvenientService::Core::Entities::Config::Entities::MethodMiddlewares::Entities::MiddlewareCreators::Base) }
  end

  example_group "instance methods" do
    describe "#middleware_events" do
      it "returns empty hash" do
        expect(middleware_creator.middleware_events).to eq({})
      end

      specify do
        expect { middleware_creator.middleware_events }.to cache_its_value
      end

      example_group "returned hash" do
        context "when NOT existing `type`(key) is accessed" do
          let(:type) { :before_call }

          it "returns event" do
            expect(middleware_creator.middleware_events[type]).to eq(ConvenientService::Core::Entities::Config::Entities::MethodMiddlewares::Entities::MiddlewareCreators::Observable::Entities::Event.new(type: type))
          end

          it "sets event" do
            expect { middleware_creator.middleware_events[type] }.to change { middleware_creator.middleware_events.has_key?(type) }.from(false).to(true)
          end

          specify do
            expect { middleware_creator.middleware_events[type] }.to cache_its_value
          end
        end
      end
    end

    describe "#decorated_middleware" do
      specify do
        expect { middleware_creator.to_observable_middleware }
          .to delegate_to(middleware, :to_observable_middleware)
          .without_arguments
          .and_return_its_value
      end
    end

    describe "#extra_kwargs" do
      it "returns extra kwargs" do
        expect(middleware_creator.extra_kwargs).to eq({middleware_events: middleware_creator.middleware_events})
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
