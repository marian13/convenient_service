# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Support::DependencyContainer::Import, type: :standard do
  let(:user) do
    Class.new.tap do |klass|
      klass.class_exec(described_class) do |mod|
        include mod
      end
    end
  end

  let(:container) do
    Module.new do
      include ConvenientService::Support::DependencyContainer::Export

      export :foo do
        "foo"
      end
    end
  end

  let(:slug) { :foo }
  let(:scope) { :instance }
  let(:prepend) { false }

  let(:method) { container.exported_methods.find_by(slug: slug, scope: scope) }

  let(:import) { user.import(slug, **kwargs) }
  let(:kwargs) { default_kwargs }
  let(:default_kwargs) { {from: container, scope: scope, prepend: prepend} }

  example_group "modules" do
    include ConvenientService::RSpec::Matchers::IncludeModule

    subject { described_class }

    it { is_expected.to include_module(ConvenientService::Support::Concern) }
  end

  example_group "class methods" do
    describe "#import" do
      ##
      # NOTE: Do NOT use custom RSpec helpers and matchers inside Utils and Support to avoid cyclic module dependencies.
      #
      # rubocop:disable RSpec/MultipleExpectations, RSpec/MessageSpies, RSpec/ExampleLength
      it "delegates to `ConvenientService::Support::DependencyContainer::Commands::AssertValidScope.call`" do
        container

        expect(ConvenientService::Support::DependencyContainer::Commands::AssertValidScope)
          .to receive(:call)
            .and_wrap_original { |original, *actual_args, **actual_kwargs, &actual_block|
                expect([actual_args, actual_kwargs, actual_block]).to eq([[], {scope: scope}, nil])

                original.call(*actual_args, **actual_kwargs, &actual_block)
              }

        import
      end
      # rubocop:enable RSpec/MultipleExpectations, RSpec/MessageSpies, RSpec/ExampleLength

      ##
      # NOTE: Do NOT use custom RSpec helpers and matchers inside Utils and Support to avoid cyclic module dependencies.
      #
      # rubocop:disable RSpec/MultipleExpectations, RSpec/MessageSpies, RSpec/ExampleLength
      it "delegates to `ConvenientService::Support::DependencyContainer::Commands::AssertValidContainer.call`" do
        expect(ConvenientService::Support::DependencyContainer::Commands::AssertValidContainer)
          .to receive(:call)
            .and_wrap_original { |original, *actual_args, **actual_kwargs, &actual_block|
                expect([actual_args, actual_kwargs, actual_block]).to eq([[], {container: container}, nil])

                original.call(*actual_args, **actual_kwargs, &actual_block)
              }

        import
      end
      # rubocop:enable RSpec/MultipleExpectations, RSpec/MessageSpies, RSpec/ExampleLength

      ##
      # NOTE: Do NOT use custom RSpec helpers and matchers inside Utils and Support to avoid cyclic module dependencies.
      #
      # rubocop:disable RSpec/MultipleExpectations, RSpec/MessageSpies, RSpec/ExampleLength
      it "delegates to `ConvenientService::Support::DependencyContainer::Commands::AssertValidMethod.call`" do
        expect(ConvenientService::Support::DependencyContainer::Commands::AssertValidMethod)
          .to receive(:call)
            .and_wrap_original { |original, *actual_args, **actual_kwargs, &actual_block|
                expect([actual_args, actual_kwargs, actual_block]).to eq([[], {slug: slug, scope: scope, container: container}, nil])

                original.call(*actual_args, **actual_kwargs, &actual_block)
              }

        import
      end
      # rubocop:enable RSpec/MultipleExpectations, RSpec/MessageSpies, RSpec/ExampleLength

      ##
      # NOTE: Do NOT use custom RSpec helpers and matchers inside Utils and Support to avoid cyclic module dependencies.
      #
      # rubocop:disable RSpec/MultipleExpectations, RSpec/MessageSpies, RSpec/ExampleLength
      it "delegates to `ConvenientService::Support::DependencyContainer::Commands::ImportMethod.call`" do
        expect(ConvenientService::Support::DependencyContainer::Commands::ImportMethod)
          .to receive(:call)
            .and_wrap_original { |original, *actual_args, **actual_kwargs, &actual_block|
                expect([actual_args, actual_kwargs, actual_block]).to eq([[], {importing_module: user, exported_method: method, prepend: prepend}, nil])

                original.call(*actual_args, **actual_kwargs, &actual_block)
              }

        import
      end
      # rubocop:enable RSpec/MultipleExpectations, RSpec/MessageSpies, RSpec/ExampleLength

      it "returns `ConvenientService::Support::DependencyContainer::Commands::ImportMethod.call` value" do
        expect(import).to eq(ConvenientService::Support::DependencyContainer::Commands::ImportMethod.call(importing_module: user, exported_method: method, prepend: prepend))
      end

      ##
      # NOTE: `it "imports method copy" do`.
      #
      context "when `as` is passed" do
        let(:kwargs) { default_kwargs.merge({as: alias_slug}) }
        let(:alias_slug) { :bar }
        let(:method_copy) { method.copy(overrides: {kwargs: {alias_slug: alias_slug}}) }

        ##
        # NOTE: Do NOT use custom RSpec helpers and matchers inside Utils and Support to avoid cyclic module dependencies.
        #
        # rubocop:disable RSpec/MultipleExpectations, RSpec/MessageSpies, RSpec/ExampleLength
        it "delegates to `ConvenientService::Support::DependencyContainer::Commands::ImportMethod#call`" do
          expect(ConvenientService::Support::DependencyContainer::Commands::ImportMethod)
            .to receive(:call)
              .and_wrap_original { |original, *actual_args, **actual_kwargs, &actual_block|
                  expect([actual_args, actual_kwargs, actual_block]).to eq([[], {importing_module: user, exported_method: method_copy, prepend: prepend}, nil])

                  original.call(*actual_args, **actual_kwargs, &actual_block)
                }

          import
        end
        # rubocop:enable RSpec/MultipleExpectations, RSpec/MessageSpies, RSpec/ExampleLength

        it "returns `ConvenientService::Support::DependencyContainer::Commands::ImportMethod#call` value" do
          expect(import).to eq(ConvenientService::Support::DependencyContainer::Commands::ImportMethod.call(importing_module: user, exported_method: method_copy, prepend: prepend))
        end
      end

      ##
      # NOTE: `it "defaults to `ConvenientService::Support::DependencyContainer::Constants::DEFAULT_SCOPE`" do`.
      #
      context "when `scope` is NOT passed" do
        let(:kwargs) { ConvenientService::Utils::Hash.except(default_kwargs, [:scope]) }

        ##
        # NOTE: Do NOT use custom RSpec helpers and matchers inside Utils and Support to avoid cyclic module dependencies.
        #
        # rubocop:disable RSpec/MultipleExpectations, RSpec/MessageSpies, RSpec/ExampleLength
        it "delegates to `ConvenientService::Support::DependencyContainer::Commands::ImportMethod#call`" do
          expect(ConvenientService::Support::DependencyContainer::Commands::ImportMethod)
            .to receive(:call)
              .and_wrap_original { |original, *actual_args, **actual_kwargs, &actual_block|
                  expect([actual_args, actual_kwargs, actual_block]).to eq([[], {importing_module: user, exported_method: method, prepend: prepend}, nil])

                  original.call(*actual_args, **actual_kwargs, &actual_block)
                }

          import
        end
        # rubocop:enable RSpec/MultipleExpectations, RSpec/MessageSpies, RSpec/ExampleLength

        it "returns `ConvenientService::Support::DependencyContainer::Commands::ImportMethod#call` value" do
          expect(import).to eq(ConvenientService::Support::DependencyContainer::Commands::ImportMethod.call(importing_module: user, exported_method: method, prepend: prepend))
        end
      end

      ##
      # NOTE: `it "defaults to `ConvenientService::Support::DependencyContainer::Constants::DEFAULT_PREPEND`" do`.
      #
      context "when `prepend` is NOT passed" do
        let(:kwargs) { ConvenientService::Utils::Hash.except(default_kwargs, [:prepend]) }

        ##
        # NOTE: Do NOT use custom RSpec helpers and matchers inside Utils and Support to avoid cyclic module dependencies.
        #
        # rubocop:disable RSpec/MultipleExpectations, RSpec/MessageSpies, RSpec/ExampleLength
        it "delegates to `ConvenientService::Support::DependencyContainer::Commands::ImportMethod#call`" do
          expect(ConvenientService::Support::DependencyContainer::Commands::ImportMethod)
            .to receive(:call)
              .and_wrap_original { |original, *actual_args, **actual_kwargs, &actual_block|
                  expect([actual_args, actual_kwargs, actual_block]).to eq([[], {importing_module: user, exported_method: method, prepend: ConvenientService::Support::DependencyContainer::Constants::DEFAULT_PREPEND}, nil])

                  original.call(*actual_args, **actual_kwargs, &actual_block)
                }

          import
        end
        # rubocop:enable RSpec/MultipleExpectations, RSpec/MessageSpies, RSpec/ExampleLength

        it "returns `ConvenientService::Support::DependencyContainer::Commands::ImportMethod#call` value" do
          expect(import).to eq(ConvenientService::Support::DependencyContainer::Commands::ImportMethod.call(importing_module: user, exported_method: method, prepend: ConvenientService::Support::DependencyContainer::Constants::DEFAULT_PREPEND))
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
