# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Service::Plugins::HasResultSteps::Middleware do
  example_group "inheritance" do
    include ConvenientService::RSpec::Matchers::BeDescendantOf

    subject { described_class }

    it { is_expected.to be_descendant_of(ConvenientService::Core::MethodChainMiddleware) }
  end

  example_group "instance methods" do
    describe "#call" do
      include ConvenientService::RSpec::Helpers::WrapMethod

      subject(:method_value) { method.call }

      let(:method) { wrap_method(service_instance, :result, middlewares: described_class) }
      let(:service_instance) { service_class.new }

      context "when service has no steps" do
        let(:service_class) do
          Class.new do
            include ConvenientService::Service::Plugins::HasResult::Concern
            include ConvenientService::Service::Plugins::HasResultSteps::Concern

            # rubocop:disable RSpec/LeakyConstantDeclaration, Lint/ConstantDefinitionInBlock
            class self::Result
              include ConvenientService::Core

              concerns do
                use ConvenientService::Common::Plugins::HasInternals::Concern
                use ConvenientService::Common::Plugins::HasConstructor::Concern
                use ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::HasJsendStatusAndAttributes::Concern
              end

              middlewares :initialize do
                use ConvenientService::Common::Plugins::NormalizesEnv::Middleware

                use ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::HasJsendStatusAndAttributes::Middleware
              end

              class self::Internals
                include ConvenientService::Core

                concerns do
                  use ConvenientService::Common::Plugins::HasInternals::Entities::Internals::Plugins::HasCache::Concern
                end
              end
            end
            # rubocop:enable RSpec/LeakyConstantDeclaration, Lint/ConstantDefinitionInBlock

            def result
              success
            end
          end
        end

        it "calls super" do
          ##
          # NOTE: Should return success, see how result is defined above.
          #
          expect(method_value).to be_success
        end
      end

      context "when intermediate step is NOT successful" do
        let(:first_step) do
          Class.new do
            include ConvenientService::Service::Plugins::HasResult::Concern

            # rubocop:disable RSpec/LeakyConstantDeclaration, Lint/ConstantDefinitionInBlock
            class self::Result
              include ConvenientService::Core

              concerns do
                use ConvenientService::Common::Plugins::HasInternals::Concern
                use ConvenientService::Common::Plugins::HasConstructor::Concern
                use ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::HasJsendStatusAndAttributes::Concern
              end

              middlewares :initialize do
                use ConvenientService::Common::Plugins::NormalizesEnv::Middleware

                use ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::HasJsendStatusAndAttributes::Middleware
              end

              class self::Internals
                include ConvenientService::Core

                concerns do
                  use ConvenientService::Common::Plugins::HasInternals::Entities::Internals::Plugins::HasCache::Concern
                end
              end
            end
            # rubocop:enable RSpec/LeakyConstantDeclaration, Lint/ConstantDefinitionInBlock

            def result
              error(message: "some error message")
            end
          end
        end

        let(:second_step) do
          Class.new do
            include ConvenientService::Service::Plugins::HasResult::Concern

            # rubocop:disable RSpec/LeakyConstantDeclaration, Lint/ConstantDefinitionInBlock
            class self::Result
              include ConvenientService::Core

              concerns do
                use ConvenientService::Common::Plugins::HasInternals::Concern
                use ConvenientService::Common::Plugins::HasConstructor::Concern
                use ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::HasJsendStatusAndAttributes::Concern
              end

              middlewares :initialize do
                use ConvenientService::Common::Plugins::NormalizesEnv::Middleware

                use ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::HasJsendStatusAndAttributes::Middleware
              end

              class self::Internals
                include ConvenientService::Core

                concerns do
                  use ConvenientService::Common::Plugins::HasInternals::Entities::Internals::Plugins::HasCache::Concern
                end
              end
            end
            # rubocop:enable RSpec/LeakyConstantDeclaration, Lint/ConstantDefinitionInBlock

            def result
              success(data: {baz: :qux})
            end
          end
        end

        let(:service_class) do
          Class.new.tap do |klass|
            klass.class_exec(first_step, second_step) do |first_step, second_step|
              include ConvenientService::Service::Plugins::HasResult::Concern
              include ConvenientService::Service::Plugins::HasResultSteps::Concern

              # rubocop:disable RSpec/LeakyConstantDeclaration, Lint/ConstantDefinitionInBlock
              class self::Result
                include ConvenientService::Core

                concerns do
                  use ConvenientService::Common::Plugins::HasInternals::Concern
                  use ConvenientService::Common::Plugins::HasConstructor::Concern
                  use ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::HasJsendStatusAndAttributes::Concern
                end

                middlewares :initialize do
                  use ConvenientService::Common::Plugins::NormalizesEnv::Middleware

                  use ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::HasJsendStatusAndAttributes::Middleware
                end

                class self::Internals
                  include ConvenientService::Core

                  concerns do
                    use ConvenientService::Common::Plugins::HasInternals::Entities::Internals::Plugins::HasCache::Concern
                  end
                end
              end
              # rubocop:enable RSpec/LeakyConstantDeclaration, Lint/ConstantDefinitionInBlock

              step first_step
              step second_step
            end
          end
        end

        it "returns result of intermediate step" do
          expect(method_value.message).to eq("some error message")
        end

        it "does NOT evaluate results of following steps" do
          allow(second_step).to receive(:new).and_call_original

          method_value

          expect(second_step).not_to have_received(:new)
        end
      end

      context "when all steps are successful" do
        let(:first_step) do
          Class.new do
            include ConvenientService::Service::Plugins::HasResult::Concern

            # rubocop:disable RSpec/LeakyConstantDeclaration, Lint/ConstantDefinitionInBlock
            class self::Result
              include ConvenientService::Core

              concerns do
                use ConvenientService::Common::Plugins::HasInternals::Concern
                use ConvenientService::Common::Plugins::HasConstructor::Concern
                use ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::HasJsendStatusAndAttributes::Concern
              end

              middlewares :initialize do
                use ConvenientService::Common::Plugins::NormalizesEnv::Middleware

                use ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::HasJsendStatusAndAttributes::Middleware
              end

              class self::Internals
                include ConvenientService::Core

                concerns do
                  use ConvenientService::Common::Plugins::HasInternals::Entities::Internals::Plugins::HasCache::Concern
                end
              end
            end
            # rubocop:enable RSpec/LeakyConstantDeclaration, Lint/ConstantDefinitionInBlock

            def result
              success(data: {foo: :bar})
            end
          end
        end

        let(:second_step) do
          Class.new do
            include ConvenientService::Service::Plugins::HasResult::Concern

            # rubocop:disable RSpec/LeakyConstantDeclaration, Lint/ConstantDefinitionInBlock
            class self::Result
              include ConvenientService::Core

              concerns do
                use ConvenientService::Common::Plugins::HasInternals::Concern
                use ConvenientService::Common::Plugins::HasConstructor::Concern
                use ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::HasJsendStatusAndAttributes::Concern
              end

              middlewares :initialize do
                use ConvenientService::Common::Plugins::NormalizesEnv::Middleware

                use ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::HasJsendStatusAndAttributes::Middleware
              end

              class self::Internals
                include ConvenientService::Core

                concerns do
                  use ConvenientService::Common::Plugins::HasInternals::Entities::Internals::Plugins::HasCache::Concern
                end
              end
            end
            # rubocop:enable RSpec/LeakyConstantDeclaration, Lint/ConstantDefinitionInBlock

            def result
              success(data: {baz: :qux})
            end
          end
        end

        let(:service_class) do
          Class.new.tap do |klass|
            klass.class_exec(first_step, second_step) do |first_step, second_step|
              include ConvenientService::Service::Plugins::HasResult::Concern
              include ConvenientService::Service::Plugins::HasResultSteps::Concern

              # rubocop:disable RSpec/LeakyConstantDeclaration, Lint/ConstantDefinitionInBlock
              class self::Result
                include ConvenientService::Core

                concerns do
                  use ConvenientService::Common::Plugins::HasInternals::Concern
                  use ConvenientService::Common::Plugins::HasConstructor::Concern
                  use ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::HasJsendStatusAndAttributes::Concern
                end

                middlewares :initialize do
                  use ConvenientService::Common::Plugins::NormalizesEnv::Middleware

                  use ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::HasJsendStatusAndAttributes::Middleware
                end

                class self::Internals
                  include ConvenientService::Core

                  concerns do
                    use ConvenientService::Common::Plugins::HasInternals::Entities::Internals::Plugins::HasCache::Concern
                  end
                end
              end
              # rubocop:enable RSpec/LeakyConstantDeclaration, Lint/ConstantDefinitionInBlock

              step first_step
              step second_step
            end
          end
        end

        it "returns result of last step" do
          expect(method_value.data).to eq({baz: :qux})
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
