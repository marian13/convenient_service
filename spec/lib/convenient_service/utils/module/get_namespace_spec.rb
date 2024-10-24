# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Utils::Module::GetNamespace, type: :standard do
  include ConvenientService::RSpec::Helpers::IgnoringException

  include ConvenientService::RSpec::Matchers::DelegateTo

  example_group "class methhods" do
    describe ".call" do
      let(:mod) { Class.new }

      let(:util_result) { described_class.call(mod) }

      context "when `mod` does NOT have namespace" do
        let(:mod) { String }

        it "returns `nil`" do
          expect(util_result).to be_nil
        end

        context "when `mod` is anonymous" do
          let(:mod) { Module.new }

          it "returns `nil`" do
            expect(util_result).to be_nil
          end
        end
      end

      context "when `mod` has namespace" do
        let(:mod) { Enumerator::Lazy }

        it "returns namespace" do
          expect(util_result).to eq(Enumerator)
        end

        ##
        # NOTE: `Namespace::AnonymousModule` is NOT possible. That is why such context is not tested.
        #
        # context "when `mod` is anonymous" do
        # end
        ##

        context "when namespace is anonymous" do
          let(:namespace) { Module.new }

          let(:mod) do
            # rubocop:disable Lint/ConstantDefinitionInBlock, RSpec/LeakyConstantDeclaration
            class namespace::Foo
              self
            end
            # rubocop:enable Lint/ConstantDefinitionInBlock, RSpec/LeakyConstantDeclaration
          end

          let(:exception_message) do
            <<~TEXT
              `#{mod.inspect}` is nested under anonymous namespace `#{namespace.inspect}`.

              Unfortunately, Ruby does NOT have a reliable way to get corresponding `Module` or `Class` object by anonymous namespace name.
              - https://bugs.ruby-lang.org/issues/15408
              - https://stackoverflow.com/questions/2818602/in-ruby-why-does-inspect-print-out-some-kind-of-object-id-which-is-different
            TEXT
          end

          it "raises `ConvenientService::Utils::Module::Exceptions::NestingUnderAnonymousNamespace`" do
            expect { util_result }
              .to raise_error(ConvenientService::Utils::Module::Exceptions::NestingUnderAnonymousNamespace)
              .with_message(exception_message)
          end

          specify do
            expect { ignoring_exception(ConvenientService::Utils::Module::Exceptions::NestingUnderAnonymousNamespace) { util_result } }
              .to delegate_to(ConvenientService, :raise)
          end
        end

        context "when `mod` has nested namespace" do
          let(:mod) { Thread::Backtrace::Location }

          it "returns nested namespace" do
            expect(util_result).to eq(Thread::Backtrace)
          end

          context "when parent nested namespace is anonymous" do
            let(:parent_namespace) { Module.new }

            let(:nested_namespace) do
              # rubocop:disable Lint/ConstantDefinitionInBlock, RSpec/LeakyConstantDeclaration, Naming/ClassAndModuleCamelCase
              class parent_namespace::Foo
                self
              end
              # rubocop:enable Lint/ConstantDefinitionInBlock, RSpec/LeakyConstantDeclaration, Naming/ClassAndModuleCamelCase
            end

            let(:mod) do
              # rubocop:disable Lint/ConstantDefinitionInBlock, RSpec/LeakyConstantDeclaration, Naming/ClassAndModuleCamelCase
              class nested_namespace::Bar
                self
              end
              # rubocop:enable Lint/ConstantDefinitionInBlock, RSpec/LeakyConstantDeclaration, Naming/ClassAndModuleCamelCase
            end

            let(:exception_message) do
              <<~TEXT
                `#{mod.inspect}` is nested under anonymous namespace `#{nested_namespace.inspect}`.

                Unfortunately, Ruby does NOT have a reliable way to get corresponding `Module` or `Class` object by anonymous namespace name.
                - https://bugs.ruby-lang.org/issues/15408
                - https://stackoverflow.com/questions/2818602/in-ruby-why-does-inspect-print-out-some-kind-of-object-id-which-is-different
              TEXT
            end

            it "raises `ConvenientService::Utils::Module::Exceptions::NestingUnderAnonymousNamespace`" do
              expect { util_result }
                .to raise_error(ConvenientService::Utils::Module::Exceptions::NestingUnderAnonymousNamespace)
                .with_message(exception_message)
            end

            specify do
              expect { ignoring_exception(ConvenientService::Utils::Module::Exceptions::NestingUnderAnonymousNamespace) { util_result } }
                .to delegate_to(ConvenientService, :raise)
            end
          end

          ##
          # NOTE: `ParentNamespace::AnonymousNestedNamespace::SomeModule` is NOT possible. That is why such context is not tested.
          #
          # context "when nested namespace is anonymous" do
          # end
          ##

          ##
          # NOTE: `ParentNamespace::NestedNamespace::AnonymousModule` is NOT possible. That is why such context is not tested.
          #
          # context "when `mod` is anonymous" do
          # end
          ##
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
