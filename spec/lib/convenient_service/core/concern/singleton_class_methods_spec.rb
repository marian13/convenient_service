# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Core::Concern::SingletonClassMethods, type: :standard do
  include ConvenientService::RSpec::Helpers::IgnoringException

  include ConvenientService::RSpec::Matchers::DelegateTo
  include ConvenientService::RSpec::PrimitiveMatchers::CacheItsValue

  let(:service_class) do
    Class.new do
      include ConvenientService::Core
    end
  end

  example_group "class methods" do
    if ConvenientService::Dependencies.ruby.version >= 3.2
      describe ".singleton_class.__convenient_service_config__" do
        specify do
          expect { service_class.singleton_class.__convenient_service_config__ }
            .to delegate_to(service_class.singleton_class, :attached_object)
            .without_arguments
        end

        specify do
          expect { service_class.singleton_class.__convenient_service_config__ }
            .to delegate_to(service_class.singleton_class.attached_object, :__convenient_service_config__)
            .without_arguments
            .and_return_its_value
        end

        specify do
          expect { service_class.singleton_class.__convenient_service_config__ }.to cache_its_value
        end
      end
    else
      describe ".singleton_class.__convenient_service_config__" do
        context "when `klass` is NOT passed" do
          specify do
            ##
            # NOTE: Imitates non-memoized config instance variable. For Ruby 3.2+ is is stored in `class`. For previous versions its stored in `class.singleton_class`.
            #
            service_class.singleton_class.remove_instance_variable(:@__convenient_service_config__)

            expect { service_class.singleton_class.__convenient_service_config__ }
              .to delegate_to(ConvenientService::Core::Entities::Config, :new)
              .with_arguments(klass: nil)
          end

          it "returns config" do
            expect(service_class.__convenient_service_config__).to be_instance_of(ConvenientService::Core::Entities::Config)
          end

          specify do
            expect { service_class.singleton_class.__convenient_service_config__ }.to cache_its_value
          end
        end

        context "when `klass` is passed" do
          let(:klass) { Class.new }

          specify do
            ##
            # NOTE: Imitates non-memoized config instance variable. For Ruby 3.2+ is is stored in `class`. For previous versions its stored in `class.singleton_class`.
            #
            service_class.singleton_class.remove_instance_variable(:@__convenient_service_config__)

            expect { service_class.singleton_class.__convenient_service_config__(klass: klass) }
              .to delegate_to(ConvenientService::Core::Entities::Config, :new)
              .with_arguments(klass: klass)
          end

          it "returns config" do
            expect(service_class.__convenient_service_config__).to be_instance_of(ConvenientService::Core::Entities::Config)
          end

          specify do
            expect { service_class.singleton_class.__convenient_service_config__ }.to cache_its_value
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
