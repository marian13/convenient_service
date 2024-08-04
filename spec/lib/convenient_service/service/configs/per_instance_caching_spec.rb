# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Service::Configs::PerInstanceCaching, type: :standard do
  example_group "modules" do
    include ConvenientService::RSpec::Matchers::IncludeModule

    subject { described_class }

    it { is_expected.to include_module(ConvenientService::Config) }

    context "when included" do
      let(:service_class) do
        Class.new.tap do |klass|
          klass.class_exec(described_class) do |mod|
            include mod
          end
        end
      end

      specify { expect(service_class).to include_module(ConvenientService::Core) }

      example_group "service" do
        example_group "#result middlewares" do
          it "prepends `ConvenientService::Common::Plugins::CachesReturnValue::Middleware` to service middlewares for `#result`" do
            expect(service_class.middlewares(:result).to_a.first).to eq(ConvenientService::Common::Plugins::CachesReturnValue::Middleware)
          end
        end

        example_group "#regular_result middlewares" do
          it "prepends `ConvenientService::Common::Plugins::CachesReturnValue::Middleware` to service middlewares for `#regular_result`" do
            expect(service_class.middlewares(:regular_result).to_a.first).to eq(ConvenientService::Common::Plugins::CachesReturnValue::Middleware)
          end
        end

        example_group "#steps_result middlewares" do
          it "prepends `ConvenientService::Common::Plugins::CachesReturnValue::Middleware` to service middlewares for `#steps_result`" do
            expect(service_class.middlewares(:steps_result).to_a.first).to eq(ConvenientService::Common::Plugins::CachesReturnValue::Middleware)
          end
        end

        example_group "#negated_result middlewares" do
          it "prepends `ConvenientService::Common::Plugins::CachesReturnValue::Middleware` to service middlewares for `#negated_result`" do
            expect(service_class.middlewares(:negated_result).to_a.first).to eq(ConvenientService::Common::Plugins::CachesReturnValue::Middleware)
          end
        end

        example_group "#fallback_failure_result middlewares" do
          it "prepends `ConvenientService::Common::Plugins::CachesReturnValue::Middleware` to service middlewares for `#fallback_failure_result`" do
            expect(service_class.middlewares(:fallback_failure_result).to_a.first).to eq(ConvenientService::Common::Plugins::CachesReturnValue::Middleware)
          end
        end

        example_group "#fallback_error_result middlewares" do
          it "prepends `ConvenientService::Common::Plugins::CachesReturnValue::Middleware` to service middlewares for `#fallback_error_result`" do
            expect(service_class.middlewares(:fallback_error_result).to_a.first).to eq(ConvenientService::Common::Plugins::CachesReturnValue::Middleware)
          end
        end

        example_group "#fallback_result middlewares" do
          it "prepends `ConvenientService::Common::Plugins::CachesReturnValue::Middleware` to service middlewares for `#fallback_result`" do
            expect(service_class.middlewares(:fallback_result).to_a.first).to eq(ConvenientService::Common::Plugins::CachesReturnValue::Middleware)
          end
        end

        example_group "service internals" do
          example_group "concerns" do
            it "adds `ConvenientService::Common::Plugins::HasInternals::Entities::Internals::Plugins::HasCache::Concern` to service internals concerns" do
              expect(service_class::Internals.concerns.to_a.last).to eq(ConvenientService::Common::Plugins::HasInternals::Entities::Internals::Plugins::HasCache::Concern)
            end
          end
        end

        example_group "service result" do
          example_group "service result status" do
            example_group "service result status internals" do
              example_group "concerns" do
                it "adds `ConvenientService::Common::Plugins::HasInternals::Entities::Internals::Plugins::HasCache::Concern` to service result status internals concerns" do
                  expect(service_class::Result::Status::Internals.concerns.to_a.last).to eq(ConvenientService::Common::Plugins::HasInternals::Entities::Internals::Plugins::HasCache::Concern)
                end
              end
            end
          end

          example_group "service result internals" do
            example_group "concerns" do
              it "adds `ConvenientService::Common::Plugins::HasInternals::Entities::Internals::Plugins::HasCache::Concern` to service result internals concerns" do
                expect(service_class::Result::Internals.concerns.to_a.last).to eq(ConvenientService::Common::Plugins::HasInternals::Entities::Internals::Plugins::HasCache::Concern)
              end
            end
          end
        end

        example_group "service step" do
          example_group "#result middlewares" do
            it "prepends `ConvenientService::Common::Plugins::CachesReturnValue::Middleware` to service middlewares for `#result`" do
              expect(service_class::Step.middlewares(:result).to_a.first).to eq(ConvenientService::Common::Plugins::CachesReturnValue::Middleware)
            end
          end

          example_group "#service_result middlewares" do
            it "prepends `ConvenientService::Common::Plugins::CachesReturnValue::Middleware` to service middlewares for `#service_result`" do
              expect(service_class::Step.middlewares(:service_result).to_a.first).to eq(ConvenientService::Common::Plugins::CachesReturnValue::Middleware)
            end
          end

          example_group "#method_result middlewares" do
            it "prepends `ConvenientService::Common::Plugins::CachesReturnValue::Middleware` to service middlewares for `#method_result`" do
              expect(service_class::Step.middlewares(:method_result).to_a.first).to eq(ConvenientService::Common::Plugins::CachesReturnValue::Middleware)
            end
          end

          example_group "service step internals" do
            example_group "concerns" do
              it "adds `ConvenientService::Common::Plugins::HasInternals::Entities::Internals::Plugins::HasCache::Concern` to service result internals concerns" do
                expect(service_class::Step::Internals.concerns.to_a.last).to eq(ConvenientService::Common::Plugins::HasInternals::Entities::Internals::Plugins::HasCache::Concern)
              end
            end
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
