# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Support::AbstractMethod, type: :standard do
  include ConvenientService::RSpec::Helpers::IgnoringException

  include ConvenientService::RSpec::Matchers::DelegateTo

  example_group "modules" do
    it "extends `ConvenientService::Support::Concern`" do
      expect(described_class.included_modules).to include(ConvenientService::Support::Concern)
    end
  end

  example_group "when included" do
    let(:klass) { Class.new }

    it "extends `ConvenientService::Support::AbstractMethod::ClassMethods` to class" do
      klass.include described_class

      expect(klass.singleton_class.included_modules).to include(described_class::ClassMethods)
    end
  end

  example_group "class methods" do
    describe ".abstract_method" do
      let(:instance) { klass.new }

      context "when NO names are passed" do
        let(:klass) do
          Class.new do
            include ConvenientService::Support::AbstractMethod

            abstract_method
          end
        end

        it "does nothing" do
          expect { klass }.not_to raise_error
        end
      end

      context "when one name is passed" do
        let(:klass) do
          Class.new do
            include ConvenientService::Support::AbstractMethod

            abstract_method :foo
          end
        end

        it "defines method with that name" do
          expect(klass.instance_methods).to include(:foo)
        end
      end

      context "when multiple names are passed" do
        let(:klass) do
          Class.new do
            include ConvenientService::Support::AbstractMethod

            abstract_method :foo, :bar
          end
        end

        it "defines method for all those names" do
          expect(klass.instance_methods).to include(:foo, :bar)
        end
      end

      context "when defined method is called" do
        context "when instance is NOT descandant of class" do
          let(:klass) do
            Class.new do
              include ConvenientService::Support::AbstractMethod

              abstract_method :foo
            end
          end

          let(:exception_message) do
            <<~TEXT
              `#{klass}` should implement abstract instance method `foo`.
            TEXT
          end

          it "raises `ConvenientService::Support::AbstractMethod::Exceptions::AbstractMethodNotOverridden`" do
            expect { instance.foo }
              .to raise_error(described_class::Exceptions::AbstractMethodNotOverridden)
              .with_message(exception_message)
          end

          specify do
            expect { ignoring_exception(described_class::Exceptions::AbstractMethodNotOverridden) { instance.foo } }
              .to delegate_to(ConvenientService, :raise)
          end
        end

        context "when instance is descandant of class" do
          let(:klass) do
            Class.new do
              class << self
                include ConvenientService::Support::AbstractMethod

                abstract_method :foo
              end
            end
          end

          let(:exception_message) do
            <<~TEXT
              `#{klass}` should implement abstract class method `foo`.
            TEXT
          end

          it "raises `ConvenientService::Support::AbstractMethod::Exceptions::AbstractMethodNotOverridden`" do
            expect { klass.foo }
              .to raise_error(described_class::Exceptions::AbstractMethodNotOverridden)
              .with_message(exception_message)
          end

          specify do
            expect { ignoring_exception(described_class::Exceptions::AbstractMethodNotOverridden) { klass.foo } }
              .to delegate_to(ConvenientService, :raise)
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
