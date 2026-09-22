# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers, RSpec/DescribeClass
RSpec.describe "Result Ducks", type: [:standard, :e2e] do
  include ConvenientService::RSpec::Matchers::Results

  example_group "Service" do
    example_group "instance methods" do
      let(:other_service_class) do
        Class.new do
          include ConvenientService::Standard::Config

          def result
            success(from: :service_class)
          end
        end
      end

      describe "#result" do
        let(:service_instance) { service_class.new }

        context "when result duck is dynamic step" do
          let(:service_class) do
            Class.new.tap do |klass|
              klass.class_exec(first_step) do |first_step|
                include ConvenientService::Standard::Config

                define_singleton_method(:first_step) { first_step }

                def result
                  step first_step
                end

                private

                def first_step
                  self.class.first_step
                end
              end
            end
          end

          let(:first_step) do
            Class.new do
              include ConvenientService::Standard::Config

              def result
                success(from: :first_step)
              end
            end
          end

          it "returns dynamic step result" do
            expect(service_instance.result).to be_success.with_data(from: :first_step)
          end
        end

        context "when result duck is service class" do
          let(:service_class) do
            Class.new.tap do |klass|
              klass.class_exec(other_service_class) do |other_service_class|
                include ConvenientService::Standard::Config

                define_singleton_method(:other_service_class) { other_service_class }

                def result
                  other_service_class
                end

                private

                def other_service_class
                  self.class.other_service_class
                end
              end
            end
          end

          it "returns service class result" do
            expect(service_instance.result).to be_success.with_data(from: :service_class)
          end
        end

        context "when result duck is inline service" do
          let(:service_class) do
            Class.new do
              include ConvenientService::Standard::Config

              def result
                ConvenientService.inline do
                  def result
                    success(from: :inline_service)
                  end
                end
              end
            end
          end

          it "returns inline service result" do
            expect(service_instance.result).to be_success.with_data(from: :inline_service)
          end
        end

        context "when result duck is result" do
          let(:service_class) do
            Class.new do
              include ConvenientService::Standard::Config

              def result
                success(from: :result).result
              end
            end
          end

          it "returns result" do
            expect(service_instance.result).to be_success.with_data(from: :result)
          end
        end
      end

      describe "#fallback_result" do
        let(:service_instance) { service_class.new }

        context "when result duck is dynamic step" do
          let(:service_class) do
            Class.new.tap do |klass|
              klass.class_exec(first_step) do |first_step|
                include ConvenientService::Standard::Config

                define_singleton_method(:first_step) { first_step }

                def fallback_result
                  step first_step
                end

                private

                def first_step
                  self.class.first_step
                end
              end
            end
          end

          let(:first_step) do
            Class.new do
              include ConvenientService::Standard::Config

              def result
                success(from: :first_step)
              end
            end
          end

          it "returns dynamic step result" do
            expect(service_instance.fallback_result).to be_success.with_data(from: :first_step)
          end
        end

        context "when result duck is service class" do
          let(:service_class) do
            Class.new.tap do |klass|
              klass.class_exec(other_service_class) do |other_service_class|
                include ConvenientService::Standard::Config

                define_singleton_method(:other_service_class) { other_service_class }

                def fallback_result
                  other_service_class
                end

                private

                def other_service_class
                  self.class.other_service_class
                end
              end
            end
          end

          it "returns service class result" do
            expect(service_instance.fallback_result).to be_success.with_data(from: :service_class)
          end
        end

        context "when result duck is inline service" do
          let(:service_class) do
            Class.new do
              include ConvenientService::Standard::Config

              def fallback_result
                ConvenientService.inline do
                  def result
                    success(from: :inline_service)
                  end
                end
              end
            end
          end

          it "returns inline service result" do
            expect(service_instance.fallback_result).to be_success.with_data(from: :inline_service)
          end
        end

        context "when result duck is result" do
          let(:service_class) do
            Class.new do
              include ConvenientService::Standard::Config

              def fallback_result
                success(from: :result).result
              end
            end
          end

          it "returns result" do
            expect(service_instance.fallback_result).to be_success.with_data(from: :result)
          end
        end
      end

      describe "#fallback_failure_result" do
        let(:service_instance) { service_class.new }

        context "when result duck is dynamic step" do
          let(:service_class) do
            Class.new.tap do |klass|
              klass.class_exec(first_step) do |first_step|
                include ConvenientService::Standard::Config

                define_singleton_method(:first_step) { first_step }

                def fallback_failure_result
                  step first_step
                end

                private

                def first_step
                  self.class.first_step
                end
              end
            end
          end

          let(:first_step) do
            Class.new do
              include ConvenientService::Standard::Config

              def result
                success(from: :first_step)
              end
            end
          end

          it "returns dynamic step result" do
            expect(service_instance.fallback_failure_result).to be_success.with_data(from: :first_step)
          end
        end

        context "when result duck is service class" do
          let(:service_class) do
            Class.new.tap do |klass|
              klass.class_exec(other_service_class) do |other_service_class|
                include ConvenientService::Standard::Config

                define_singleton_method(:other_service_class) { other_service_class }

                def fallback_failure_result
                  other_service_class
                end

                private

                def other_service_class
                  self.class.other_service_class
                end
              end
            end
          end

          it "returns service class result" do
            expect(service_instance.fallback_failure_result).to be_success.with_data(from: :service_class)
          end
        end

        context "when result duck is inline service" do
          let(:service_class) do
            Class.new do
              include ConvenientService::Standard::Config

              def fallback_failure_result
                ConvenientService.inline do
                  def result
                    success(from: :inline_service)
                  end
                end
              end
            end
          end

          it "returns inline service result" do
            expect(service_instance.fallback_failure_result).to be_success.with_data(from: :inline_service)
          end
        end

        context "when result duck is result" do
          let(:service_class) do
            Class.new do
              include ConvenientService::Standard::Config

              def fallback_failure_result
                success(from: :result).result
              end
            end
          end

          it "returns result" do
            expect(service_instance.fallback_failure_result).to be_success.with_data(from: :result)
          end
        end
      end

      describe "#fallback_error_result" do
        let(:service_instance) { service_class.new }

        context "when result duck is dynamic step" do
          let(:service_class) do
            Class.new.tap do |klass|
              klass.class_exec(first_step) do |first_step|
                include ConvenientService::Standard::Config

                define_singleton_method(:first_step) { first_step }

                def fallback_error_result
                  step first_step
                end

                private

                def first_step
                  self.class.first_step
                end
              end
            end
          end

          let(:first_step) do
            Class.new do
              include ConvenientService::Standard::Config

              def result
                success(from: :first_step)
              end
            end
          end

          it "returns dynamic step result" do
            expect(service_instance.fallback_error_result).to be_success.with_data(from: :first_step)
          end
        end

        context "when result duck is service class" do
          let(:service_class) do
            Class.new.tap do |klass|
              klass.class_exec(other_service_class) do |other_service_class|
                include ConvenientService::Standard::Config

                define_singleton_method(:other_service_class) { other_service_class }

                def fallback_error_result
                  other_service_class
                end

                private

                def other_service_class
                  self.class.other_service_class
                end
              end
            end
          end

          it "returns service class result" do
            expect(service_instance.fallback_error_result).to be_success.with_data(from: :service_class)
          end
        end

        context "when result duck is inline service" do
          let(:service_class) do
            Class.new do
              include ConvenientService::Standard::Config

              def fallback_error_result
                ConvenientService.inline do
                  def result
                    success(from: :inline_service)
                  end
                end
              end
            end
          end

          it "returns inline service result" do
            expect(service_instance.fallback_error_result).to be_success.with_data(from: :inline_service)
          end
        end

        context "when result duck is result" do
          let(:service_class) do
            Class.new do
              include ConvenientService::Standard::Config

              def fallback_error_result
                success(from: :result).result
              end
            end
          end

          it "returns result" do
            expect(service_instance.fallback_error_result).to be_success.with_data(from: :result)
          end
        end
      end

      describe "#negated_result" do
        let(:service_instance) { service_class.new }

        context "when result duck is dynamic step" do
          let(:service_class) do
            Class.new.tap do |klass|
              klass.class_exec(first_step) do |first_step|
                include ConvenientService::Standard::Config

                define_singleton_method(:first_step) { first_step }

                def negated_result
                  step first_step
                end

                private

                def first_step
                  self.class.first_step
                end
              end
            end
          end

          let(:first_step) do
            Class.new do
              include ConvenientService::Standard::Config

              def result
                success(from: :first_step)
              end
            end
          end

          it "returns dynamic step result" do
            expect(service_instance.negated_result).to be_success.with_data(from: :first_step)
          end
        end

        context "when result duck is service class" do
          let(:service_class) do
            Class.new.tap do |klass|
              klass.class_exec(other_service_class) do |other_service_class|
                include ConvenientService::Standard::Config

                define_singleton_method(:other_service_class) { other_service_class }

                def negated_result
                  other_service_class
                end

                private

                def other_service_class
                  self.class.other_service_class
                end
              end
            end
          end

          it "returns service class result" do
            expect(service_instance.negated_result).to be_success.with_data(from: :service_class)
          end
        end

        context "when result duck is inline service" do
          let(:service_class) do
            Class.new do
              include ConvenientService::Standard::Config

              def negated_result
                ConvenientService.inline do
                  def result
                    success(from: :inline_service)
                  end
                end
              end
            end
          end

          it "returns inline service result" do
            expect(service_instance.negated_result).to be_success.with_data(from: :inline_service)
          end
        end

        context "when result duck is result" do
          let(:service_class) do
            Class.new do
              include ConvenientService::Standard::Config

              def negated_result
                success(from: :result).result
              end
            end
          end

          it "returns result" do
            expect(service_instance.negated_result).to be_success.with_data(from: :result)
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers, RSpec/DescribeClass
