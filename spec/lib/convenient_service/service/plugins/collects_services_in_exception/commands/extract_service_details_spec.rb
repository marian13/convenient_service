# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Service::Plugins::CollectsServicesInException::Commands::ExtractServiceDetails, type: :standard do
  example_group "class methods" do
    describe ".call" do
      include ConvenientService::RSpec::Helpers::IgnoringException

      let(:command_result) { described_class.call(service: service_instance, method: method) }

      let(:service_instance) { service_class.new_without_initialize }
      let(:exception) { exception_class.new(exception_message) }
      let(:exception_class) { Class.new(StandardError) }
      let(:exception_message) { "exception message" }

      before do
        ##
        # NOTE: Makes sure that exception is properly processed.
        # This a library code. That is why using `send` is okish here.
        # Do not use `send` without strong arguments in a business appication code.
        #
        ignoring_exception(exception_class) { service_instance.send(method) }
      end

      context "when `method` is NOT `:result`" do
        let(:service_class) do
          Class.new.tap do |klass|
            klass.class_exec(exception) do |exception|
              include ConvenientService::Standard::Config

              def initialize
                raise exception
              end

              define_method(:exception) { exception }
            end
          end
        end

        let(:method) { :initialize }

        it "returns details with `method`" do
          expect(command_result).to eq({instance: service_instance, trigger: {method: ":#{method}"}})
        end
      end

      context "when `method` is `:result`" do
        let(:method) { :result }

        context "when `service` has NO steps" do
          let(:service_class) do
            Class.new.tap do |klass|
              klass.class_exec(exception) do |exception|
                include ConvenientService::Standard::Config

                def result
                  raise exception
                end

                define_method(:exception) { exception }
              end
            end
          end

          it "returns details with `method`" do
            expect(command_result).to eq({instance: service_instance, trigger: {method: ":result"}})
          end
        end

        context "when `service` has steps" do
          context "when first not completed step is NOT found" do
            let(:service_class) do
              Class.new.tap do |klass|
                klass.class_exec(exception) do |exception|
                  include ConvenientService::Standard::Config

                  step :foo

                  def foo
                    raise exception
                  end

                  define_method(:exception) { exception }
                end
              end
            end

            before do
              ##
              # PARANOID: This is NOT possible in production.
              #
              service_instance.steps.each { |step| step.mark_as_completed! }
            end

            it "returns details with unknown step (probably `ConvenientService` bug)" do
              expect(command_result).to eq({instance: service_instance, trigger: {step: "Unknown Step", index: -1}})
            end
          end

          context "when first not completed step is found" do
            let(:service_class) do
              Class.new.tap do |klass|
                klass.class_exec(exception) do |exception|
                  include ConvenientService::Standard::Config

                  step :foo

                  def foo
                    raise exception
                  end

                  define_method(:exception) { exception }
                end
              end
            end

            it "returns detals with that step and its index" do
              expect(command_result).to eq({instance: service_instance, trigger: {step: ":foo", index: 0}})
            end
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
