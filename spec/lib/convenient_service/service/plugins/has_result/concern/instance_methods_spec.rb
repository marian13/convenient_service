# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Service::Plugins::HasResult::Concern::InstanceMethods do
  let(:base_service_class) do
    Class.new.tap do |klass|
      klass.class_exec(described_class) do |mod|
        include mod

        class << self
          def success(**kwargs)
            "success"
          end

          def failure(**kwargs)
            "failure"
          end

          def error(**kwargs)
            "error"
          end
        end
      end
    end
  end

  let(:service_instance) { service_class.new }
  let(:result) { service_instance.result }

  example_group "instance methods" do
    let(:service_class) { base_service_class }

    describe "#result" do
      let(:error_message) do
        <<~TEXT
          Result method (#result) of `#{service_class}' is NOT overridden.
        TEXT
      end

      it "raises `ConvenientService::Service::Plugins::HasResult::Errors::ResultIsNotOverridden'" do
        expect { result }
          .to raise_error(ConvenientService::Service::Plugins::HasResult::Errors::ResultIsNotOverridden)
          .with_message(error_message)
      end
    end
  end

  example_group "private instance methods" do
    include ConvenientService::RSpec::Matchers::BeDescendantOf

    describe "#success" do
      let(:service_class) do
        Class.new(base_service_class) do
          def result
            success
          end
        end
      end

      it "delegates to `self.class.success'" do
        allow(service_class).to receive(:success).and_call_original

        result

        expect(service_class).to have_received(:success)
      end

      it "returns `self.class.success'" do
        expect(result).to eq(service_class.success)
      end

      it "passes `self' as service to `self.class.success'" do
        allow(service_class).to receive(:success).with(hash_including(service: service_instance))

        result

        expect(service_class).to have_received(:success)
      end

      context "when `data' is passed" do
        let(:service_class) do
          Class.new(base_service_class).tap do |klass|
            klass.class_exec(data) do |data|
              define_method(:result) { success(data: data) }
            end
          end
        end

        let(:data) { {foo: :bar} }

        it "passes `data' to `self.class.success'" do
          allow(service_class).to receive(:success).with(hash_including(data: data)).and_call_original

          result

          expect(service_class).to have_received(:success)
        end
      end
    end

    describe "#failure" do
      let(:service_class) do
        Class.new(base_service_class) do
          def result
            failure
          end
        end
      end

      it "delegates to `self.class.failure'" do
        allow(service_class).to receive(:failure).and_call_original

        result

        expect(service_class).to have_received(:failure)
      end

      it "returns `self.class.failure'" do
        expect(result).to eq(service_class.failure)
      end

      it "passes `self' as service to `self.class.failure'" do
        allow(service_class).to receive(:failure).with(hash_including(service: service_instance))

        result

        expect(service_class).to have_received(:failure)
      end

      context "when `data' is passed" do
        let(:service_class) do
          Class.new(base_service_class).tap do |klass|
            klass.class_exec(data) do |data|
              define_method(:result) { failure(data: data) }
            end
          end
        end

        let(:data) { {foo: "bar"} }

        it "passes `data' to `self.class.failure'" do
          allow(service_class).to receive(:failure).with(hash_including(data: data)).and_call_original

          result

          expect(service_class).to have_received(:failure)
        end
      end
    end

    describe "#error" do
      let(:service_class) do
        Class.new(base_service_class) do
          def result
            error
          end
        end
      end

      it "delegates to `self.class.error'" do
        allow(service_class).to receive(:error).and_call_original

        result

        expect(service_class).to have_received(:error)
      end

      it "returns `self.class.error'" do
        expect(result).to eq(service_class.error)
      end

      it "passes `self' as service to `self.class.error'" do
        allow(service_class).to receive(:error).with(hash_including(service: service_instance))

        result

        expect(service_class).to have_received(:error)
      end

      context "when `message' is passed" do
        let(:service_class) do
          Class.new(base_service_class).tap do |klass|
            klass.class_exec(message) do |message|
              define_method(:result) { error(message: message) }
            end
          end
        end

        let(:message) { "foo" }

        it "passes `message' to `self.class.error'" do
          allow(service_class).to receive(:error).with(hash_including(message: message)).and_call_original

          result

          expect(service_class).to have_received(:error)
        end
      end

      context "when `code' is passed" do
        let(:service_class) do
          Class.new(base_service_class).tap do |klass|
            klass.class_exec(code) do |code|
              define_method(:result) { error(code: code) }
            end
          end
        end

        let(:code) { :foo }

        it "passes `code' to `self.class.error'" do
          allow(service_class).to receive(:error).with(hash_including(code: code)).and_call_original

          result

          expect(service_class).to have_received(:error)
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
