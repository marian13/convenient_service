# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Support::MethodParameters, type: :standard do
  example_group "constants" do
    describe "::Constants::Types::REQUIRED_KEYWORD" do
      it "is equal to `:keyreq`" do
        expect(described_class::Constants::Types::REQUIRED_KEYWORD).to eq(:keyreq)
      end
    end

    describe "::Constants::Types::OPTIONAL_KEYWORD" do
      it "is equal to `:key`" do
        expect(described_class::Constants::Types::OPTIONAL_KEYWORD).to eq(:key)
      end
    end

    describe "::Constants::Types::REST_KEYWORDS" do
      it "is equal to `:keyrest`" do
        expect(described_class::Constants::Types::REST_KEYWORDS).to eq(:keyrest)
      end
    end
  end

  example_group "instance methods" do
    let(:method_parameters) { described_class.new(method.parameters) }
    let(:method) { klass.instance_method(:some_method) }

    describe "#has_rest_kwargs?" do
      context "when method does NOT have rest kwargs" do
        let(:klass) do
          Class.new do
            def some_method
            end
          end
        end

        it "returns `false`" do
          expect(method_parameters.has_rest_kwargs?).to eq(false)
        end
      end

      context "when method has rest kwargs" do
        let(:klass) do
          Class.new do
            def some_method(**kwargs)
            end
          end
        end

        it "returns `true`" do
          expect(method_parameters.has_rest_kwargs?).to eq(true)
        end
      end
    end

    describe "#named_kwargs_keys" do
      context "when method does NOT have both required kwargs and optional keys" do
        let(:klass) do
          Class.new do
            def some_method
            end
          end
        end

        it "returns empty array" do
          expect(method_parameters.named_kwargs_keys).to eq([])
        end
      end

      context "when method has required kwargs" do
        let(:klass) do
          Class.new do
            def some_method(foo:, bar:)
            end
          end
        end

        it "returns array with keys of those required kwargs" do
          expect(method_parameters.named_kwargs_keys).to eq([:foo, :bar])
        end
      end

      context "when method has one optional kwargs" do
        let(:klass) do
          Class.new do
            def some_method(foo: :foo, bar: :bar)
            end
          end
        end

        it "returns array with keys of those " do
          expect(method_parameters.named_kwargs_keys).to eq([:foo, :bar])
        end
      end

      context "when method has both required and optional kwargs" do
        let(:klass) do
          Class.new do
            def some_method(foo:, bar:, baz: :baz, qux: :qux)
            end
          end
        end

        it "returns array with keys of those required and optional kwargs" do
          expect(method_parameters.named_kwargs_keys).to eq([:foo, :bar, :baz, :qux])
        end
      end
    end

    describe "#required_kwargs_keys" do
      context "when method does NOT have required kwargs" do
        let(:klass) do
          Class.new do
            def some_method
            end
          end
        end

        it "returns empty array" do
          expect(method_parameters.required_kwargs_keys).to eq([])
        end
      end

      context "when method has required kwargs" do
        context "when method has one required kwarg" do
          let(:klass) do
            Class.new do
              def some_method(foo:)
              end
            end
          end

          it "returns array with key of that one required kwarg" do
            expect(method_parameters.required_kwargs_keys).to eq([:foo])
          end
        end

        context "when method has multiple required kwargs" do
          let(:klass) do
            Class.new do
              def some_method(foo:, bar:)
              end
            end
          end

          it "returns array with keys of those multiple required kwargs" do
            expect(method_parameters.required_kwargs_keys).to eq([:foo, :bar])
          end
        end
      end
    end

    describe "#optional_kwargs_keys" do
      context "when method does NOT have optional kwargs" do
        let(:klass) do
          Class.new do
            def some_method
            end
          end
        end

        it "returns empty array" do
          expect(method_parameters.optional_kwargs_keys).to eq([])
        end
      end

      context "when method has optional kwargs" do
        context "when method has one optional kwarg" do
          let(:klass) do
            Class.new do
              def some_method(foo: :foo)
              end
            end
          end

          it "returns array with key of that one optional kwarg" do
            expect(method_parameters.optional_kwargs_keys).to eq([:foo])
          end
        end

        context "when method has multiple optional kwargs" do
          let(:klass) do
            Class.new do
              def some_method(foo: :foo, bar: :bar)
              end
            end
          end

          it "returns array with keys of those multiple optional kwargs" do
            expect(method_parameters.optional_kwargs_keys).to eq([:foo, :bar])
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
