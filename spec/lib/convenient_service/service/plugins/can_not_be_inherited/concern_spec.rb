# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Service::Plugins::CanNotBeInherited::Concern, type: :standard do
  include ConvenientService::RSpec::Helpers::IgnoringException

  include ConvenientService::RSpec::Matchers::DelegateTo

  example_group "modules" do
    include ConvenientService::RSpec::Matchers::IncludeModule
    include ConvenientService::RSpec::Matchers::ExtendModule

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
    describe ".inherited" do
      let(:service_class) do
        Class.new do
          include ConvenientService::Standard::Config

          concerns do
            use ConvenientService::Service::Plugins::CanNotBeInherited::Concern
          end

          commit_config!

          ##
          # NOTE: `.inherited` is private by Ruby. That's why this wrapper is used.
          #
          def self.public_inherited(sub_service_class)
            inherited(sub_service_class)
          end
        end
      end

      let(:sub_service_class) do
        Class.new do
          include ConvenientService::Standard::Config
        end
      end

      let(:exception_message) do
        <<~TEXT
          Service `#{ConvenientService::Utils::Class.display_name(sub_service_class)}` is inherited from `#{ConvenientService::Utils::Class.display_name(service_class)}`.

          It is an antipattern. It neglects the idea of steps.

          Please, try to reorganize `#{ConvenientService::Utils::Class.display_name(sub_service_class)}` service.
        TEXT
      end

      it "raises `ConvenientService::Service::Plugins::CanNotBeInherited::Exceptions::ServiceIsInherited`" do
        expect { service_class.public_inherited(sub_service_class) }
          .to raise_error(ConvenientService::Service::Plugins::CanNotBeInherited::Exceptions::ServiceIsInherited)
          .with_message(exception_message)
      end

      specify do
        expect { ignoring_exception(ConvenientService::Service::Plugins::CanNotBeInherited::Exceptions::ServiceIsInherited) { service_class.public_inherited(sub_service_class) } }
          .to delegate_to(ConvenientService, :raise)
      end

      example_group "comprehensive suite" do
        example_group "inheritance" do
          let(:namespace) { Module.new }

          let(:service_class) do
            namespace.module_exec do
              # rubocop:disable Lint/ConstantDefinitionInBlock, RSpec/LeakyConstantDeclaration
              class self::Service
                include ConvenientService::Standard::Config

                concerns do
                  use ConvenientService::Service::Plugins::CanNotBeInherited::Concern
                end

                commit_config!

                self
              end
              # rubocop:enable Lint/ConstantDefinitionInBlock, RSpec/LeakyConstantDeclaration
            end
          end

          let(:sub_service_class) do
            ##
            # NOTE: `service_class` is called intentionally to define `Service` class.
            # NOTE: `Class.new(service_class)` does not allow to override `self.name` since `self.inherited` is invoked faster.
            #
            service_class

            namespace.module_exec do
              # rubocop:disable Lint/ConstantDefinitionInBlock, RSpec/LeakyConstantDeclaration
              class self::SubService < self::Service
                self
              end
              # rubocop:enable Lint/ConstantDefinitionInBlock, RSpec/LeakyConstantDeclaration
            end
          end

          let(:exception_message) do
            <<~TEXT
              Service `#{namespace}::SubService` is inherited from `#{namespace}::Service`.

              It is an antipattern. It neglects the idea of steps.

              Please, try to reorganize `#{namespace}::SubService` service.
            TEXT
          end

          it "raises `ConvenientService::Service::Plugins::CanNotBeInherited::Exceptions::ServiceIsInherited`" do
            expect { sub_service_class }
              .to raise_error(ConvenientService::Service::Plugins::CanNotBeInherited::Exceptions::ServiceIsInherited)
              .with_message(exception_message)
          end

          specify do
            expect { ignoring_exception(ConvenientService::Service::Plugins::CanNotBeInherited::Exceptions::ServiceIsInherited) { sub_service_class } }
              .to delegate_to(ConvenientService, :raise)
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
