# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

return unless defined? ConvenientService::Service::Plugins::HasJSendResultParamsValidations::UsingActiveModelValidations

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Service::Plugins::HasJSendResultParamsValidations::UsingActiveModelValidations::Middleware, type: :standard do
  let(:middleware) { described_class }

  example_group "inheritance" do
    include ConvenientService::RSpec::PrimitiveMatchers::BeDescendantOf

    subject { middleware }

    it { is_expected.to be_descendant_of(ConvenientService::MethodChainMiddleware) }
  end

  example_group "class methods" do
    describe ".intended_methods" do
      let(:spec) do
        Class.new(ConvenientService::MethodChainMiddleware) do
          intended_for :result, entity: :service
        end
      end

      it "returns intended methods" do
        expect(middleware.intended_methods).to eq(spec.intended_methods)
      end
    end
  end

  shared_examples "verify middleware behavior" do
    example_group "instance methods" do
      describe "#call" do
        include ConvenientService::RSpec::Helpers::WrapMethod
        include ConvenientService::RSpec::Matchers::CallChainNext
        include ConvenientService::RSpec::Matchers::Results

        subject(:method_value) { method.call }

        let(:method) { wrap_method(service_instance, :result, observe_middleware: middleware.with(status: status)) }

        let(:service_class) do
          Class.new.tap do |klass|
            klass.class_exec(status, middleware) do |status, middleware|
              include ConvenientService::Standard::Config

              concerns do
                use ConvenientService::Service::Plugins::HasJSendResultParamsValidations::UsingActiveModelValidations::Concern
              end

              middlewares :result do
                use_and_observe middleware.with(status: status)
              end

              attr_reader :foo

              ##
              # NOTE: Rails 6 and 7 differently handle nested hashes in `validates` call. See links below.
              # - https://github.com/rails/rails/blob/v6.0.0/activemodel/lib/active_model/translation.rb#L67
              # - https://github.com/rails/rails/blob/v7.0.0/activemodel/lib/active_model/translation.rb#L67
              # - https://github.com/rails/rails/commit/4645f2d34fc1d9f037096de988e5cc5ca41a3cf3
              #
              # For example, the following works in Ruby 2.7 + Rails 6, Ruby 2.7 + Rails 7, Ruby 3.* + Rails 7,
              # but fails in Ruby 3.* and Rails 6.
              #   validates :foo, length: {maximum: 2}
              #
              # To imitate a similar behaviour in Rails 6 a custom validation can be used.
              #   validate { errors.add(:foo, "Foo length is over 2") if foo.to_s.length > 2 }
              #   validate_with LengthValidatior, fields: :foo
              #
              # More info:
              # - https://guides.rubyonrails.org/active_record_validations.html#performing-custom-validations
              #
              # TODO: Add to troubleshoting.
              #
              # validates :foo, length: {maximum: 2}
              validate { errors.add(:foo, "Foo length is over 2") if foo.to_s.length > 2 }

              def initialize(foo:)
                @foo = foo
              end

              ##
              # IMPORTANT: Helps to avoid:
              # *** ArgumentError Exception: Class name cannot be blank. You need to supply a name argument when anonymous class given
              # https://stackoverflow.com/a/26168343/12201472
              # https://api.rubyonrails.org/classes/ActiveModel/Naming.html
              #
              def self.name
                "Service"
              end

              def result
                success
              end
            end
          end
        end

        context "when validation does NOT have any errors" do
          let(:service_instance) { service_class.new(foo: "x") }

          specify do
            expect { method_value }
              .to call_chain_next.on(method)
              .and_return_its_value
          end
        end

        context "when validation has any error" do
          let(:service_instance) { service_class.new(foo: "bar") }

          let(:errors) { service_instance.errors.messages.transform_values(&:first) }

          it "returns result with first error message for each invalid attribute as data" do
            expect(method_value).to be_result(status).with_data(errors)
          end

          it "returns result with first error key/value joined by space as message" do
            expect(method_value).to be_result(status).with_message(errors.first.to_a.map(&:to_s).join(" "))
          end

          it "returns result with `:unsatisfied_active_model_validations` as code" do
            expect(method_value).to be_result(status).with_code(:unsatisfied_active_model_validations)
          end
        end
      end
    end
  end

  context "when status is NOT passed" do
    subject(:method_value) { method.call }

    include ConvenientService::RSpec::Helpers::WrapMethod

    let(:method) { wrap_method(service_instance, :result, observe_middleware: middleware) }

    let(:service_class) do
      Class.new.tap do |klass|
        klass.class_exec(middleware) do |middleware|
          include ConvenientService::Standard::Config

          concerns do
            use ConvenientService::Service::Plugins::HasJSendResultParamsValidations::UsingActiveModelValidations::Concern
          end

          middlewares :result do
            use_and_observe middleware
          end

          attr_reader :foo

          ##
          # NOTE: Rails 6 and 7 differently handle nested hashes in `validates` call. See links below.
          # - https://github.com/rails/rails/blob/v6.0.0/activemodel/lib/active_model/translation.rb#L67
          # - https://github.com/rails/rails/blob/v7.0.0/activemodel/lib/active_model/translation.rb#L67
          # - https://github.com/rails/rails/commit/4645f2d34fc1d9f037096de988e5cc5ca41a3cf3
          #
          # For example, the following works in Ruby 2.7 + Rails 6, Ruby 2.7 + Rails 7, Ruby 3.* + Rails 7,
          # but fails in Ruby 3.* and Rails 6.
          #   validates :foo, length: {maximum: 2}
          #
          # To imitate a similar behaviour in Rails 6 a custom validation can be used.
          #   validate { errors.add(:foo, "Foo length is over 2") if foo.to_s.length > 2 }
          #   validate_with LengthValidatior, fields: :foo
          #
          # More info:
          # - https://guides.rubyonrails.org/active_record_validations.html#performing-custom-validations
          #
          # TODO: Add to troubleshoting.
          #
          # validates :foo, length: {maximum: 2}
          validate { errors.add(:foo, "Foo length is over 2") if foo.to_s.length > 2 }

          def initialize(foo:)
            @foo = foo
          end

          ##
          # IMPORTANT: Helps to avoid:
          # *** ArgumentError Exception: Class name cannot be blank. You need to supply a name argument when anonymous class given
          # https://stackoverflow.com/a/26168343/12201472
          # https://api.rubyonrails.org/classes/ActiveModel/Naming.html
          #
          def self.name
            "Service"
          end

          def result
            success
          end
        end
      end
    end

    let(:service_instance) { service_class.new(foo: "bar") }

    it "defaults to `:error`" do
      expect(method_value).to be_error
    end
  end

  context "when status is failure" do
    include_examples "verify middleware behavior" do
      let(:status) { :failure }
    end
  end

  context "when status is error" do
    include_examples "verify middleware behavior" do
      let(:status) { :error }
    end
  end
end
# rubocop:enable RSpec/NestedGroups
