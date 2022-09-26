# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Utils::Method do
  describe ".defined?" do
    let(:method) { :foo }

    context "when `class` does NOT have `method`" do
      let(:klass) { Class.new }

      it "returns `false`" do
        expect(described_class.defined?(method, in: klass)).to eq(false)
      end
    end

    context "when `class` has `method`" do
      context "when that `method` is `public`" do
        let(:klass) do
          Class.new do
            def foo
            end
          end
        end

        it "returns `true`" do
          expect(described_class.defined?(method, in: klass)).to eq(true)
        end
      end

      context "when that `method` is `protected`" do
        let(:klass) do
          Class.new do
            protected

            def foo
            end
          end
        end

        it "returns `true`" do
          expect(described_class.defined?(method, in: klass)).to eq(true)
        end
      end

      context "when that `method` is `private`" do
        let(:klass) do
          Class.new do
            private

            def foo
            end
          end
        end

        it "returns `true`" do
          expect(described_class.defined?(method, in: klass)).to eq(true)
        end
      end
    end
  end

  describe ".find_own" do
    let(:method_name) { :result }
    let(:object) { klass.new }

    def create_module_with_result_method
      Module.new do
        def result
          super
        end
      end
    end

    context "when object class does NOT have prepended modules" do
      context "when object class does NOT have own method" do
        let(:klass) { Class.new }

        it "returns nil" do
          expect(described_class.find_own(method_name, object)).to be_nil
        end
      end

      context "when object class has own method" do
        let(:klass) do
          Class.new do
            def result
            end
          end
        end

        let(:own_method) { object.method(method_name) }

        it "returns method from object class" do
          expect(described_class.find_own(method_name, object)).to eq(own_method)
        end
      end
    end

    context "when object class has prepended modules" do
      context "when object class does NOT have more than ConvenientService::Support::FiniteLoop::MAX_ITERATION_COUNT prepended modules" do
        context "when object class does NOT have own method" do
          let(:klass) do
            mod_1 = create_module_with_result_method
            mod_2 = create_module_with_result_method

            Class.new do
              prepend mod_1
              prepend mod_2
            end
          end

          it "returns nil" do
            expect(described_class.find_own(method_name, object)).to be_nil
          end
        end

        context "when object class has own method" do
          let(:klass) do
            mod_1 = create_module_with_result_method
            mod_2 = create_module_with_result_method

            Class.new do
              prepend mod_1
              prepend mod_2

              def result
              end
            end
          end

          let(:own_method) { object.method(method_name).super_method.super_method }

          it "returns method from object class" do
            expect(described_class.find_own(method_name, object)).to eq(own_method)
          end
        end
      end

      # rubocop:disable RSpec/MultipleMemoizedHelpers
      context "when object class has more than ConvenientService::Support::FiniteLoop::MAX_ITERATION_COUNT prepended modules" do
        let(:klass) do
          mod_1 = create_module_with_result_method
          mod_2 = create_module_with_result_method
          mod_3 = create_module_with_result_method

          Class.new do
            prepend mod_1
            prepend mod_2
            prepend mod_3

            def result
            end
          end
        end

        let(:own_method) { object.method(method_name).super_method.super_method.super_method }

        let(:max_iteration_count) { 2 }

        let(:error_message) do
          <<~TEXT
            Max iteration count is exceeded. Current limit is #{max_iteration_count}.

            Consider using `max_iteration_count` or `raise_on_exceedance` options if that is not the expected behavior.
          TEXT
        end

        before do
          stub_const("ConvenientService::Support::FiniteLoop::MAX_ITERATION_COUNT", max_iteration_count)
        end

        it "raises ConvenientService::Support::FiniteLoop::Errors::MaxIterationCountExceeded" do
          expect { described_class.find_own(method_name, object) }
            .to raise_error(ConvenientService::Support::FiniteLoop::Errors::MaxIterationCountExceeded)
            .with_message(error_message)
        end

        it "supports max_iteration_count option" do
          expect(described_class.find_own(method_name, object, max_iteration_count: 10)).to eq(own_method)
        end
      end
      # rubocop:enable RSpec/MultipleMemoizedHelpers
    end
  end
end
# rubocop:enable RSpec/NestedGroups
