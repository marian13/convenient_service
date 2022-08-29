# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Common::Plugins::HasCallbacks::Middleware do
  example_group "inheritance" do
    include ConvenientService::RSpec::Matchers::BeDescendantOf

    subject { described_class }

    it { is_expected.to be_descendant_of(ConvenientService::Core::MethodChainMiddleware) }
  end

  example_group "instance methods" do
    describe "#call" do
      include ConvenientService::RSpec::Helpers::WrapMethod
      include ConvenientService::RSpec::Matchers::CallChainNext

      subject(:method_value) { method.call }

      let(:method) { wrap_method(service_instance, :result, middlewares: described_class) }

      let(:out) { Tempfile.new }
      let(:output) { out.tap(&:rewind).read }
      let(:result_original_value) { "result original value" }

      let(:service_class) do
        Class.new.tap do |klass|
          klass.class_exec(result_original_value, out) do |result_original_value, out|
            include ConvenientService::Common::Plugins::HasCallbacks::Concern

            define_method(:out) { out }

            define_method(:result) { result_original_value.tap { out.puts "original result" } }
          end
        end
      end

      let(:service_instance) { service_class.new }

      specify {
        expect { method_value }
          .to call_chain_next.on(method)
          .and_return_its_value
      }

      context "when service class has no callbacks" do
        let(:text) do
          <<~TEXT
            original result
          TEXT
        end

        it "runs only `chain.next'" do
          method_value

          expect(output).to eq(text)
        end
      end

      context "when service class has one before callback" do
        let(:text) do
          <<~TEXT
            first before result
            original result
          TEXT
        end

        before do
          service_class.before(:result) { out.puts "first before result" }
        end

        it "runs that before callback in addition to `chain.next'" do
          method_value

          expect(output).to eq(text)
        end
      end

      context "when service class has one after callback" do
        let(:text) do
          <<~TEXT
            original result
            first after result
          TEXT
        end

        before do
          service_class.after(:result) { out.puts "first after result" }
        end

        it "runs that after callback in addition to `chain.next'" do
          method_value

          expect(output).to eq(text)
        end
      end

      context "when service class has multiple before callbacks" do
        let(:text) do
          <<~TEXT
            first before result
            second before result
            original result
          TEXT
        end

        before do
          service_class.before(:result) { out.puts "first before result" }
          service_class.before(:result) { out.puts "second before result" }
        end

        it "runs those before callbacks in addition to `chain.next'" do
          method_value

          expect(output).to eq(text)
        end
      end

      context "when service class has multiple after callbacks" do
        let(:text) do
          <<~TEXT
            original result
            second after result
            first after result
          TEXT
        end

        before do
          service_class.after(:result) { out.puts "first after result" }
          service_class.after(:result) { out.puts "second after result" }
        end

        it "runs those after callbacks in addition to `chain.next'" do
          method_value

          expect(output).to eq(text)
        end
      end

      context "when service class has before and after callbacks" do
        let(:text) do
          <<~TEXT
            first before result
            second before result
            original result
            second after result
            first after result
          TEXT
        end

        before do
          service_class.before(:result) { out.puts "first before result" }
          service_class.before(:result) { out.puts "second before result" }

          service_class.after(:result) { out.puts "first after result" }
          service_class.after(:result) { out.puts "second after result" }
        end

        it "runs those before and after callbacks in addition to `chain.next'" do
          method_value

          expect(output).to eq(text)
        end
      end

      example_group "after callbacks first argument" do
        before do
          ##
          # NOTE: `result_original_value' is NOT available inside service instance context.
          # That is why "chain next value" literal is used.
          #
          service_class.after(:result) { |result| raise if result != "result original value" }
        end

        it "passes `chain.next' to all after callbacks as first argument" do
          expect { method_value }.not_to raise_error
        end
      end

      example_group "context" do
        let(:service_class) do
          Class.new.tap do |klass|
            klass.class_exec do
              include ConvenientService::Common::Plugins::HasCallbacks::Concern

              def some_instance_method
              end

              def result
              end
            end
          end
        end

        example_group "before callbacks context" do
          before do
            service_class.before(:result) { some_instance_method }
          end

          it "executes before callbacks in instance context" do
            expect { method_value }.not_to raise_error
          end
        end

        example_group "after callbacks context" do
          before do
            service_class.after(:result) { some_instance_method }
          end

          it "executes after callbacks in instance context" do
            expect { method_value }.not_to raise_error
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
