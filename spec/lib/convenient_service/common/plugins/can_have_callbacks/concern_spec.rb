# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Common::Plugins::CanHaveCallbacks::Concern, type: :standard do
  include ConvenientService::RSpec::PrimitiveMatchers::CacheItsValue
  include ConvenientService::RSpec::Matchers::DelegateTo

  example_group "modules" do
    include ConvenientService::RSpec::Matchers::IncludeModule
    include ConvenientService::RSpec::PrimitiveMatchers::ExtendModule

    subject { described_class }

    it { is_expected.to include_module(ConvenientService::Support::Concern) }

    context "when included" do
      subject { service_class }

      let(:service_class) do
        Class.new.tap do |klass|
          klass.class_exec(described_class) do |mod|
            include mod
          end
        end
      end

      it { is_expected.to extend_module(described_class::ClassMethods) }
    end
  end

  example_group "class methods" do
    let(:service_class) do
      Class.new do
        include ConvenientService::Standard::Config
      end
    end

    let(:method) { :result }
    let(:block) { proc {} }

    example_group "class methods" do
      describe ".callbacks" do
        it "returns `ConvenientService::Common::Plugins::CanHaveCallbacks::Entities::CallbackCollection` instance" do
          expect(service_class.callbacks).to eq(ConvenientService::Common::Plugins::CanHaveCallbacks::Entities::CallbackCollection.new)
        end

        specify do
          expect { service_class.callbacks }.to cache_its_value
        end

        ##
        # TODO: Implement `delegate_to` that skips block comparion?
        #
        specify do
          expect { service_class.callbacks }.to delegate_to(service_class.internals_class.cache, :fetch)
        end
      end

      describe ".before" do
        specify do
          service_class.commit_config!

          expect { service_class.before(method, &block) }
            .to delegate_to(service_class, :callback)
            .with_arguments(:before, method, &block)
            .and_return_its_value
        end
      end

      describe ".after" do
        specify do
          service_class.commit_config!

          expect { service_class.after(method, &block) }
            .to delegate_to(service_class, :callback)
            .with_arguments(:after, method, &block)
            .and_return_its_value
        end
      end

      describe ".around" do
        specify do
          service_class.commit_config!

          expect { service_class.around(method, &block) }
            .to delegate_to(service_class, :callback)
            .with_arguments(:around, method, &block)
            .and_return_its_value
        end
      end

      describe ".callback" do
        let(:type) { :before }

        specify do
          expect { service_class.callback(type, method, &block) }
            .to delegate_to(service_class.callbacks, :create)
            .with_arguments(types: [type, method], block: block)
            .and_return_its_value
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
