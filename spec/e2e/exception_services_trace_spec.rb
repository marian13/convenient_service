# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers, RSpec/DescribeClass
RSpec.describe "Exception services trace", type: [:standard, :e2e] do
  include ConvenientService::RSpec::Matchers::Results

  example_group "Service" do
    example_group "instance methods" do
      describe "#initialize" do
        let(:service_instance) { service_class.allocate }

        context "when `#initialize` raises exception" do
          let(:service_class) do
            Class.new do
              include ConvenientService::Standard::Config

              def initialize
                raise StandardError, "exception from `#initialize`"
              end
            end
          end

          let(:services) { [{instance: service_instance, trigger: {method: ":initialize"}}] }

          # rubocop:disable RSpec/MultipleExpectations
          it "adds service details to exception" do
            expect { service_instance.send(:initialize) }.to raise_error(StandardError) do |exception|
              expect(exception.message).to eq("exception from `#initialize`")
              expect(exception.services).to eq(services)
            end
          end
          # rubocop:enable RSpec/MultipleExpectations
        end

        context "when `#initialize` reraises exception" do
          let(:service_class) do
            Class.new do
              include ConvenientService::Standard::Config

              def initialize
                raise StandardError, "exception from `#initialize`"
              rescue
                raise StandardError, "reraised exception from `#initialize`"
              end
            end
          end

          # rubocop:disable RSpec/MultipleExpectations
          it "does NOT add service details to exception cause" do
            expect { service_instance.send(:initialize) }.to raise_error(StandardError) do |exception|
              expect(exception.cause.message).to eq("exception from `#initialize`")
              expect(exception.cause).not_to respond_to(:services)
            end
          end
          # rubocop:enable RSpec/MultipleExpectations
        end
      end

      describe "#result" do
        let(:service_instance) { service_class.new }

        context "when `#result` raises exception" do
          let(:service_class) do
            Class.new do
              include ConvenientService::Standard::Config

              def result
                raise StandardError, "exception from `#result`"
              end
            end
          end

          let(:services) { [{instance: service_instance, trigger: {method: ":result"}}] }

          # rubocop:disable RSpec/MultipleExpectations
          it "adds service details to exception" do
            expect { service_instance.result }.to raise_error(StandardError) do |exception|
              expect(exception.message).to eq("exception from `#result`")
              expect(exception.services).to eq(services)
            end
          end
          # rubocop:enable RSpec/MultipleExpectations
        end

        context "when `#result` reraises exception" do
          let(:service_class) do
            Class.new do
              include ConvenientService::Standard::Config

              def result
                raise StandardError, "exception from `#result`"
              rescue
                raise StandardError, "reraised exception from `#result`"
              end
            end
          end

          # rubocop:disable RSpec/MultipleExpectations
          it "does NOT add service details to exception cause" do
            expect { service_instance.result }.to raise_error(StandardError) do |exception|
              expect(exception.cause.message).to eq("exception from `#result`")
              expect(exception.cause).not_to respond_to(:services)
            end
          end
          # rubocop:enable RSpec/MultipleExpectations
        end
      end

      describe "#negated_result" do
        let(:service_instance) { service_class.new }

        context "when `#negated_result` raises exception" do
          let(:service_class) do
            Class.new do
              include ConvenientService::Standard::Config

              def negated_result
                raise StandardError, "exception from `#negated_result`"
              end
            end
          end

          let(:services) { [{instance: service_instance, trigger: {method: ":negated_result"}}] }

          # rubocop:disable RSpec/MultipleExpectations
          it "adds service details to exception" do
            expect { service_instance.negated_result }.to raise_error(StandardError) do |exception|
              expect(exception.message).to eq("exception from `#negated_result`")
              expect(exception.services).to eq(services)
            end
          end
          # rubocop:enable RSpec/MultipleExpectations
        end

        context "when `#negated_result` reraises exception" do
          let(:service_class) do
            Class.new do
              include ConvenientService::Standard::Config

              def negated_result
                raise StandardError, "exception from `#negated_result`"
              rescue
                raise StandardError, "reraised exception from `#negated_result`"
              end
            end
          end

          # rubocop:disable RSpec/MultipleExpectations
          it "does NOT add service details to exception cause" do
            expect { service_instance.negated_result }.to raise_error(StandardError) do |exception|
              expect(exception.cause.message).to eq("exception from `#negated_result`")
              expect(exception.cause).not_to respond_to(:services)
            end
          end
          # rubocop:enable RSpec/MultipleExpectations
        end
      end

      describe "#fallback_failure_result" do
        let(:service_instance) { service_class.new }

        context "when `#fallback_failure_result` raises exception" do
          let(:service_class) do
            Class.new do
              include ConvenientService::Standard::Config

              def fallback_failure_result
                raise StandardError, "exception from `#fallback_failure_result`"
              end
            end
          end

          let(:services) { [{instance: service_instance, trigger: {method: ":fallback_failure_result"}}] }

          # rubocop:disable RSpec/MultipleExpectations
          it "adds service details to exception" do
            expect { service_instance.fallback_failure_result }.to raise_error(StandardError) do |exception|
              expect(exception.message).to eq("exception from `#fallback_failure_result`")
              expect(exception.services).to eq(services)
            end
          end
          # rubocop:enable RSpec/MultipleExpectations
        end

        context "when `#fallback_failure_result` reraises exception" do
          let(:service_class) do
            Class.new do
              include ConvenientService::Standard::Config

              def fallback_failure_result
                raise StandardError, "exception from `#fallback_failure_result`"
              rescue
                raise StandardError, "reraised exception from `#fallback_failure_result`"
              end
            end
          end

          # rubocop:disable RSpec/MultipleExpectations
          it "does NOT add service details to exception cause" do
            expect { service_instance.fallback_failure_result }.to raise_error(StandardError) do |exception|
              expect(exception.cause.message).to eq("exception from `#fallback_failure_result`")
              expect(exception.cause).not_to respond_to(:services)
            end
          end
          # rubocop:enable RSpec/MultipleExpectations
        end
      end

      describe "#fallback_error_result" do
        let(:service_instance) { service_class.new }

        context "when `#fallback_error_result` raises exception" do
          let(:service_class) do
            Class.new do
              include ConvenientService::Standard::Config

              def fallback_error_result
                raise StandardError, "exception from `#fallback_error_result`"
              end
            end
          end

          let(:services) { [{instance: service_instance, trigger: {method: ":fallback_error_result"}}] }

          # rubocop:disable RSpec/MultipleExpectations
          it "adds service details to exception" do
            expect { service_instance.fallback_error_result }.to raise_error(StandardError) do |exception|
              expect(exception.message).to eq("exception from `#fallback_error_result`")
              expect(exception.services).to eq(services)
            end
          end
          # rubocop:enable RSpec/MultipleExpectations
        end

        context "when `#fallback_error_result` reraises exception" do
          let(:service_class) do
            Class.new do
              include ConvenientService::Standard::Config

              def fallback_error_result
                raise StandardError, "exception from `#fallback_error_result`"
              rescue
                raise StandardError, "reraised exception from `#fallback_error_result`"
              end
            end
          end

          # rubocop:disable RSpec/MultipleExpectations
          it "does NOT add service details to exception cause" do
            expect { service_instance.fallback_error_result }.to raise_error(StandardError) do |exception|
              expect(exception.cause.message).to eq("exception from `#fallback_error_result`")
              expect(exception.cause).not_to respond_to(:services)
            end
          end
          # rubocop:enable RSpec/MultipleExpectations
        end
      end

      describe "#fallback_result" do
        let(:service_instance) { service_class.new }

        context "when `#fallback_result` raises exception" do
          let(:service_class) do
            Class.new do
              include ConvenientService::Standard::Config

              def fallback_result
                raise StandardError, "exception from `#fallback_result`"
              end
            end
          end

          let(:services) { [{instance: service_instance, trigger: {method: ":fallback_result"}}] }

          # rubocop:disable RSpec/MultipleExpectations
          it "adds service details to exception" do
            expect { service_instance.fallback_result }.to raise_error(StandardError) do |exception|
              expect(exception.message).to eq("exception from `#fallback_result`")
              expect(exception.services).to eq(services)
            end
          end
          # rubocop:enable RSpec/MultipleExpectations
        end

        context "when `#fallback_result` reraises exception" do
          let(:service_class) do
            Class.new do
              include ConvenientService::Standard::Config

              def fallback_result
                raise StandardError, "exception from `#fallback_result`"
              rescue
                raise StandardError, "reraised exception from `#fallback_result`"
              end
            end
          end

          # rubocop:disable RSpec/MultipleExpectations
          it "does NOT add service details to exception cause" do
            expect { service_instance.fallback_result }.to raise_error(StandardError) do |exception|
              expect(exception.cause.message).to eq("exception from `#fallback_result`")
              expect(exception.cause).not_to respond_to(:services)
            end
          end
          # rubocop:enable RSpec/MultipleExpectations
        end
      end

      describe "#rollback_result" do
        let(:service_instance) { service_class.new }

        context "when `#rollback_result` raises exception" do
          let(:service_class) do
            Class.new do
              include ConvenientService::Standard::Config

              def rollback_result
                raise StandardError, "exception from `#rollback_result`"
              end
            end
          end

          # rubocop:disable RSpec/MultipleExpectations
          it "does NOT adds service details to exception" do
            expect { service_instance.rollback_result }.to raise_error(StandardError) do |exception|
              expect(exception.message).to eq("exception from `#rollback_result`")
              expect(exception).not_to respond_to(:services)
            end
          end
          # rubocop:enable RSpec/MultipleExpectations
        end

        context "when `#rollback_result` reraises exception" do
          let(:service_class) do
            Class.new do
              include ConvenientService::Standard::Config

              def rollback_result
                raise StandardError, "exception from `#rollback_result`"
              rescue
                raise StandardError, "reraised exception from `#rollback_result`"
              end
            end
          end

          # rubocop:disable RSpec/MultipleExpectations
          it "does NOT add service details to exception cause" do
            expect { service_instance.rollback_result }.to raise_error(StandardError) do |exception|
              expect(exception.cause.message).to eq("exception from `#rollback_result`")
              expect(exception.cause).not_to respond_to(:services)
            end
          end
          # rubocop:enable RSpec/MultipleExpectations
        end
      end
    end

    example_group "service step" do
      let(:service_instance) { service_class.new }

      context "when service step raises exception" do
        let(:service_class) do
          Class.new.tap do |klass|
            klass.class_exec(service_step) do |service_step|
              include ConvenientService::Standard::Config

              step service_step
            end
          end
        end

        let(:service_step) do
          Class.new do
            include ConvenientService::Standard::Config

            def result
              raise StandardError, "exception from service step"
            end

            def self.name
              "ServiceStep"
            end
          end
        end

        # rubocop:disable RSpec/MultipleExpectations, RSpec/ExampleLength
        it "adds service details to exception" do
          expect { service_instance.result }.to raise_error(StandardError) do |exception|
            expect(exception.message).to eq("exception from service step")

            expect(exception.services[0][:instance]).to be_instance_of(service_step)
            expect(exception.services[0][:trigger]).to eq({method: ":result"})

            expect(exception.services[1][:instance]).to eq(service_instance)
            expect(exception.services[1][:trigger]).to eq({index: 0, step: service_step.name})
          end
        end
        # rubocop:enable RSpec/MultipleExpectations, RSpec/ExampleLength
      end

      context "when service step reraises exception" do
        let(:service_class) do
          Class.new.tap do |klass|
            klass.class_exec(service_step) do |service_step|
              include ConvenientService::Standard::Config

              step service_step
            end
          end
        end

        let(:service_step) do
          Class.new do
            include ConvenientService::Standard::Config

            def result
              raise StandardError, "exception from service step"
            rescue
              raise StandardError, "reraised exception from service step"
            end
          end
        end

        # rubocop:disable RSpec/MultipleExpectations
        it "does NOT add service details to exception cause" do
          expect { service_instance.result }.to raise_error(StandardError) do |exception|
            expect(exception.cause.message).to eq("exception from service step")
            expect(exception.cause).not_to respond_to(:services)
          end
        end
        # rubocop:enable RSpec/MultipleExpectations
      end
    end

    example_group "method step" do
      let(:service_instance) { service_class.new }

      context "when method step raises exception" do
        let(:service_class) do
          Class.new do
            include ConvenientService::Standard::Config

            step :method_step

            def method_step
              raise StandardError, "exception from method step"
            end
          end
        end

        let(:services) { [{instance: service_instance, trigger: {step: ":method_step", index: 0}}] }

        # rubocop:disable RSpec/MultipleExpectations
        it "adds service details to exception" do
          expect { service_instance.result }.to raise_error(StandardError) do |exception|
            expect(exception.message).to eq("exception from method step")
            expect(exception.services).to eq(services)
          end
        end
        # rubocop:enable RSpec/MultipleExpectations
      end

      context "when method step reraises exception" do
        let(:service_class) do
          Class.new do
            include ConvenientService::Standard::Config

            step :method_step

            def method_step
              raise StandardError, "exception from method step"
            rescue
              raise StandardError, "reraised exception from service step"
            end
          end
        end

        # rubocop:disable RSpec/MultipleExpectations
        it "does NOT add service details to exception" do
          expect { service_instance.result }.to raise_error(StandardError) do |exception|
            expect(exception.cause.message).to eq("exception from method step")
            expect(exception.cause).not_to respond_to(:services)
          end
        end
        # rubocop:enable RSpec/MultipleExpectations
      end
    end

    example_group "foreign service from regular result" do
      let(:service_instance) { service_class.new }

      context "when foreign service raises exception" do
        let(:service_class) do
          Class.new.tap do |klass|
            klass.class_exec(foreign_service) do |foreign_service|
              include ConvenientService::Standard::Config

              define_method(:result) { foreign_service.result }
            end
          end
        end

        let(:foreign_service) do
          Class.new do
            include ConvenientService::Standard::Config

            def result
              raise StandardError, "exception from foreign service"
            end
          end
        end

        # rubocop:disable RSpec/MultipleExpectations, RSpec/ExampleLength
        it "adds service details to exception" do
          expect { service_instance.result }.to raise_error(StandardError) do |exception|
            expect(exception.message).to eq("exception from foreign service")

            expect(exception.services[0][:instance]).to be_instance_of(foreign_service)
            expect(exception.services[0][:trigger]).to eq({method: ":result"})

            expect(exception.services[1][:instance]).to eq(service_instance)
            expect(exception.services[1][:trigger]).to eq({method: ":result"})
          end
        end
        # rubocop:enable RSpec/MultipleExpectations, RSpec/ExampleLength
      end

      context "when foreign service reraises exception" do
        let(:service_class) do
          Class.new.tap do |klass|
            klass.class_exec(foreign_service) do |foreign_service|
              include ConvenientService::Standard::Config

              define_method(:result) { foreign_service.result }
            end
          end
        end

        let(:foreign_service) do
          Class.new do
            include ConvenientService::Standard::Config

            def result
              raise StandardError, "exception from foreign service"
            rescue
              raise StandardError, "reraised exception from foreign service"
            end
          end
        end

        # rubocop:disable RSpec/MultipleExpectations
        it "does NOT add service details to exception" do
          expect { service_instance.result }.to raise_error(StandardError) do |exception|
            expect(exception.cause.message).to eq("exception from foreign service")
            expect(exception.cause).not_to respond_to(:services)
          end
        end
        # rubocop:enable RSpec/MultipleExpectations
      end
    end

    example_group "foreign service from method step" do
      let(:service_instance) { service_class.new }

      context "when foreign service raises exception" do
        let(:service_class) do
          Class.new.tap do |klass|
            klass.class_exec(foreign_service) do |foreign_service|
              include ConvenientService::Standard::Config

              step :method_step

              define_method(:method_step) { foreign_service.result }
            end
          end
        end

        let(:foreign_service) do
          Class.new do
            include ConvenientService::Standard::Config

            def result
              raise StandardError, "exception from foreign service"
            end
          end
        end

        # rubocop:disable RSpec/MultipleExpectations, RSpec/ExampleLength
        it "adds service details to exception" do
          expect { service_instance.result }.to raise_error(StandardError) do |exception|
            expect(exception.message).to eq("exception from foreign service")

            expect(exception.services[0][:instance]).to be_instance_of(foreign_service)
            expect(exception.services[0][:trigger]).to eq({method: ":result"})

            expect(exception.services[1][:instance]).to eq(service_instance)
            expect(exception.services[1][:trigger]).to eq({step: ":method_step", index: 0})
          end
        end
        # rubocop:enable RSpec/MultipleExpectations, RSpec/ExampleLength
      end

      context "when foreign service reraises exception" do
        let(:service_class) do
          Class.new.tap do |klass|
            klass.class_exec(foreign_service) do |foreign_service|
              include ConvenientService::Standard::Config

              step :method_step

              define_method(:method_step) { foreign_service.result }
            end
          end
        end

        let(:foreign_service) do
          Class.new do
            include ConvenientService::Standard::Config

            def result
              raise StandardError, "exception from foreign service"
            rescue
              raise StandardError, "reraised exception from foreign service"
            end
          end
        end

        # rubocop:disable RSpec/MultipleExpectations
        it "does NOT add service details to exception" do
          expect { service_instance.result }.to raise_error(StandardError) do |exception|
            expect(exception.cause.message).to eq("exception from foreign service")
            expect(exception.cause).not_to respond_to(:services)
          end
        end
        # rubocop:enable RSpec/MultipleExpectations
      end
    end

    ##
    # FIX: Allow to use middlewares for `fallback_result` when called via `fallback: true`.
    #
    example_group "fallback failure result from service step" do
      let(:service_instance) { service_class.new }

      context "when fallback failure result raises exception" do
        let(:service_class) do
          Class.new.tap do |klass|
            klass.class_exec(service_step) do |service_step|
              include ConvenientService::Standard::Config

              step service_step, fallback: true
            end
          end
        end

        let(:service_step) do
          Class.new do
            include ConvenientService::Standard::Config

            def result
              failure
            end

            def fallback_failure_result
              raise StandardError, "exception from fallback failure result from service step"
            end

            def self.name
              "ServiceStep"
            end
          end
        end

        # rubocop:disable RSpec/MultipleExpectations, RSpec/ExampleLength
        it "adds service details to exception" do
          expect { service_instance.result }.to raise_error(StandardError) do |exception|
            expect(exception.message).to eq("exception from fallback failure result from service step")

            expect(exception.services[0][:instance]).to be_instance_of(service_step)
            expect(exception.services[0][:trigger]).to eq({method: ":fallback_failure_result"})

            expect(exception.services[1][:instance]).to eq(service_instance)
            expect(exception.services[1][:trigger]).to eq({index: 0, step: service_step.name})
          end
        end
        # rubocop:enable RSpec/MultipleExpectations, RSpec/ExampleLength
      end

      context "when fallback failure result reraises exception" do
        let(:service_class) do
          Class.new.tap do |klass|
            klass.class_exec(service_step) do |service_step|
              include ConvenientService::Standard::Config

              step service_step, fallback: true
            end
          end
        end

        let(:service_step) do
          Class.new do
            include ConvenientService::Standard::Config

            def result
              failure
            end

            def fallback_failure_result
              raise StandardError, "exception from fallback failure result from service step"
            rescue
              raise StandardError, "reraised exception from fallback failure result from service step"
            end
          end
        end

        # rubocop:disable RSpec/MultipleExpectations
        it "does NOT add service details to exception cause" do
          expect { service_instance.result }.to raise_error(StandardError) do |exception|
            expect(exception.cause.message).to eq("exception from fallback failure result from service step")
            expect(exception.cause).not_to respond_to(:services)
          end
        end
        # rubocop:enable RSpec/MultipleExpectations
      end
    end

    example_group "fallback error result from service step" do
      let(:service_instance) { service_class.new }

      context "when fallback error result raises exception" do
        let(:service_class) do
          Class.new.tap do |klass|
            klass.class_exec(service_step) do |service_step|
              include ConvenientService::Standard::Config

              step service_step, fallback: :error
            end
          end
        end

        let(:service_step) do
          Class.new do
            include ConvenientService::Standard::Config

            def result
              error
            end

            def fallback_error_result
              raise StandardError, "exception from fallback error result from service step"
            end

            def self.name
              "ServiceStep"
            end
          end
        end

        # rubocop:disable RSpec/MultipleExpectations, RSpec/ExampleLength
        it "adds service details to exception" do
          expect { service_instance.result }.to raise_error(StandardError) do |exception|
            expect(exception.message).to eq("exception from fallback error result from service step")

            expect(exception.services[0][:instance]).to be_instance_of(service_step)
            expect(exception.services[0][:trigger]).to eq({method: ":fallback_error_result"})

            expect(exception.services[1][:instance]).to eq(service_instance)
            expect(exception.services[1][:trigger]).to eq({index: 0, step: service_step.name})
          end
        end
        # rubocop:enable RSpec/MultipleExpectations, RSpec/ExampleLength
      end

      context "when fallback error result reraises exception" do
        let(:service_class) do
          Class.new.tap do |klass|
            klass.class_exec(service_step) do |service_step|
              include ConvenientService::Standard::Config

              step service_step, fallback: :error
            end
          end
        end

        let(:service_step) do
          Class.new do
            include ConvenientService::Standard::Config

            def result
              error
            end

            def fallback_error_result
              raise StandardError, "exception from fallback error result from service step"
            rescue
              raise StandardError, "reraised exception from fallback error result from service step"
            end
          end
        end

        # rubocop:disable RSpec/MultipleExpectations
        it "does NOT add service details to exception cause" do
          expect { service_instance.result }.to raise_error(StandardError) do |exception|
            expect(exception.cause.message).to eq("exception from fallback error result from service step")
            expect(exception.cause).not_to respond_to(:services)
          end
        end
        # rubocop:enable RSpec/MultipleExpectations
      end
    end

    example_group "fallback result from service step" do
      let(:service_instance) { service_class.new }

      context "when fallback result raises exception" do
        let(:service_class) do
          Class.new.tap do |klass|
            klass.class_exec(service_step) do |service_step|
              include ConvenientService::Standard::Config

              step service_step, fallback: true
            end
          end
        end

        let(:service_step) do
          Class.new do
            include ConvenientService::Standard::Config

            def result
              failure
            end

            def fallback_result
              raise StandardError, "exception from fallback result from service step"
            end

            def self.name
              "ServiceStep"
            end
          end
        end

        # rubocop:disable RSpec/MultipleExpectations, RSpec/ExampleLength
        it "adds service details to exception" do
          expect { service_instance.result }.to raise_error(StandardError) do |exception|
            expect(exception.message).to eq("exception from fallback result from service step")

            expect(exception.services[0][:instance]).to be_instance_of(service_step)
            expect(exception.services[0][:trigger]).to eq({method: ":fallback_result"})

            expect(exception.services[1][:instance]).to eq(service_instance)
            expect(exception.services[1][:trigger]).to eq({index: 0, step: service_step.name})
          end
        end
        # rubocop:enable RSpec/MultipleExpectations, RSpec/ExampleLength
      end

      context "when fallback result reraises exception" do
        let(:service_class) do
          Class.new.tap do |klass|
            klass.class_exec(service_step) do |service_step|
              include ConvenientService::Standard::Config

              step service_step, fallback: true
            end
          end
        end

        let(:service_step) do
          Class.new do
            include ConvenientService::Standard::Config

            def result
              failure
            end

            def fallback_result
              raise StandardError, "exception from fallback result from service step"
            rescue
              raise StandardError, "reraised exception from fallback result from service step"
            end
          end
        end

        # rubocop:disable RSpec/MultipleExpectations
        it "does NOT add service details to exception cause" do
          expect { service_instance.result }.to raise_error(StandardError) do |exception|
            expect(exception.cause.message).to eq("exception from fallback result from service step")
            expect(exception.cause).not_to respond_to(:services)
          end
        end
        # rubocop:enable RSpec/MultipleExpectations
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers, RSpec/DescribeClass
