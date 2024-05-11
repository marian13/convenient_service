# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::RSpec::Matchers::Classes::Results::Base::Entities::Chain, type: :standard do
  example_group "instance methods" do
    describe "#used_data?" do
      context "when data is NOT set" do
        let(:chain) { described_class.new }

        it "returns `false`" do
          expect(chain.used_data?).to eq(false)
        end
      end

      context "when data is set" do
        let(:chain) { described_class.new.tap { |chain| chain.data = data } }
        let(:data) { {foo: :bar} }

        it "returns `true`" do
          expect(chain.used_data?).to eq(true)
        end
      end
    end

    describe "#used_message?" do
      context "when message is NOT set" do
        let(:chain) { described_class.new }

        it "returns `false`" do
          expect(chain.used_message?).to eq(false)
        end
      end

      context "when message is set" do
        let(:chain) { described_class.new.tap { |chain| chain.message = message } }
        let(:message) { "foo" }

        it "returns `true`" do
          expect(chain.used_message?).to eq(true)
        end
      end
    end

    describe "#used_code?" do
      context "when code is NOT set" do
        let(:chain) { described_class.new }

        it "returns `false`" do
          expect(chain.used_code?).to eq(false)
        end
      end

      context "when code is set" do
        let(:chain) { described_class.new.tap { |chain| chain.code = code } }
        let(:code) { :foo }

        it "returns `true`" do
          expect(chain.used_code?).to eq(true)
        end
      end
    end

    describe "#used_service?" do
      context "when service is NOT set" do
        let(:chain) { described_class.new }

        it "returns `false`" do
          expect(chain.used_service?).to eq(false)
        end
      end

      context "when service is set" do
        let(:chain) { described_class.new.tap { |chain| chain.service = service } }

        let(:service) do
          Class.new do
            include ConvenientService::Service::Configs::Standard
          end
        end

        it "returns `true`" do
          expect(chain.used_service?).to eq(true)
        end
      end
    end

    describe "#used_step?" do
      context "when step is NOT set" do
        let(:chain) { described_class.new }

        it "returns `false`" do
          expect(chain.used_step?).to eq(false)
        end
      end

      context "when step is set" do
        let(:chain) { described_class.new.tap { |chain| chain.step = step } }
        let(:step) { :foo }

        it "returns `true`" do
          expect(chain.used_step?).to eq(true)
        end
      end
    end

    describe "#statuses" do
      context "when statuses is NOT set" do
        let(:chain) { described_class.new }

        it "returns empty array" do
          expect(chain.statuses).to eq([])
        end
      end

      context "when statuses is set" do
        let(:chain) { described_class.new.tap { |chain| chain.statuses = statuses } }
        let(:statuses) { [:success] }

        it "returns statuses" do
          expect(chain.statuses).to eq(statuses)
        end
      end
    end

    describe "#data" do
      context "when data is NOT set" do
        let(:chain) { described_class.new }

        it "returns empty hash" do
          expect(chain.data).to eq({})
        end
      end

      context "when data is set" do
        let(:chain) { described_class.new.tap { |chain| chain.data = data } }
        let(:data) { {foo: :bar} }

        it "returns data" do
          expect(chain.data).to eq(data)
        end
      end
    end

    describe "#message" do
      context "when message is NOT set" do
        let(:chain) { described_class.new }

        it "returns empty string" do
          expect(chain.message).to eq("")
        end
      end

      context "when message is set" do
        let(:chain) { described_class.new.tap { |chain| chain.message = message } }
        let(:message) { "foo" }

        it "returns message" do
          expect(chain.message).to eq(message)
        end
      end
    end

    describe "#code" do
      context "when code is NOT set" do
        let(:chain) { described_class.new }

        it "returns `nil`" do
          expect(chain.code).to be_nil
        end
      end

      context "when code is set" do
        let(:chain) { described_class.new.tap { |chain| chain.code = code } }
        let(:code) { :foo }

        it "returns code" do
          expect(chain.code).to eq(code)
        end
      end
    end

    describe "#comparison_method" do
      context "when comparison_method is NOT set" do
        let(:chain) { described_class.new }

        it "returns `ConvenientService::RSpec::Matchers::Classes::Results::Base::Constants::DEFAULT_COMPARISON_METHOD`" do
          expect(chain.comparison_method).to eq(ConvenientService::RSpec::Matchers::Classes::Results::Base::Constants::DEFAULT_COMPARISON_METHOD)
        end
      end

      context "when comparison_method is set" do
        let(:chain) { described_class.new.tap { |chain| chain.comparison_method = comparison_method } }
        let(:comparison_method) { :=== }

        it "returns comparison method" do
          expect(chain.comparison_method).to eq(comparison_method)
        end
      end
    end

    describe "#service" do
      context "when service is NOT set" do
        let(:chain) { described_class.new }

        it "returns `nil`" do
          expect(chain.service).to be_nil
        end
      end

      context "when service is set" do
        let(:chain) { described_class.new.tap { |chain| chain.service = service } }

        let(:service) do
          Class.new do
            include ConvenientService::Service::Configs::Standard

            def result
              success
            end
          end
        end

        it "returns service" do
          expect(chain.service).to eq(service)
        end
      end
    end

    describe "#step" do
      context "when step is NOT set" do
        let(:chain) { described_class.new }

        it "returns `nil`" do
          expect(chain.step).to be_nil
        end
      end

      context "when step is set" do
        let(:chain) { described_class.new.tap { |chain| chain.step = step } }
        let(:step) { :foo }

        it "returns step" do
          expect(chain.step).to eq(step)
        end
      end
    end

    describe "#statuses=" do
      let(:chain) { described_class.new }
      let(:statuses) { [:success] }

      it "sets statuses" do
        chain.statuses = statuses

        expect(chain.statuses).to eq(statuses)
      end

      it "returns set statuses" do
        expect(chain.statuses = statuses).to eq(statuses)
      end
    end

    describe "#comparison_method=" do
      let(:chain) { described_class.new }
      let(:comparison_method) { :=== }

      it "sets comparison_method" do
        chain.comparison_method = comparison_method

        expect(chain.comparison_method).to eq(comparison_method)
      end

      it "returns set comparison_method" do
        expect(chain.comparison_method = comparison_method).to eq(comparison_method)
      end
    end

    describe "#data=" do
      let(:chain) { described_class.new }
      let(:data) { {foo: :bar} }

      it "sets data" do
        chain.data = data

        expect(chain.data).to eq(data)
      end

      it "returns set data" do
        expect(chain.data = data).to eq(data)
      end
    end

    describe "#message=" do
      let(:chain) { described_class.new }
      let(:message) { "foo" }

      it "sets message" do
        chain.message = message

        expect(chain.message).to eq(message)
      end

      it "returns set message" do
        expect(chain.message = message).to eq(message)
      end
    end

    describe "#code=" do
      let(:chain) { described_class.new }
      let(:code) { :foo }

      it "sets code" do
        chain.code = code

        expect(chain.code).to eq(code)
      end

      it "returns set code" do
        expect(chain.code = code).to eq(code)
      end
    end

    describe "#service=" do
      let(:chain) { described_class.new }

      let(:service) do
        Class.new do
          include ConvenientService::Service::Configs::Standard
        end
      end

      it "sets service" do
        chain.service = service

        expect(chain.service).to eq(service)
      end

      it "returns set service" do
        expect(chain.service = service).to eq(service)
      end
    end

    describe "#step=" do
      let(:chain) { described_class.new }
      let(:step) { :foo }

      it "sets step" do
        chain.step = step

        expect(chain.step).to eq(step)
      end

      it "returns set step" do
        expect(chain.step = step).to eq(step)
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
