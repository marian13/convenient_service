# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Utils::Module do
  describe ".get_own_const" do
    let(:result) { described_class.get_own_const(mod, const_name) }

    let(:mod) { Class.new }

    context "when const is NOT defined directly inside module namespace" do
      context "when const is NOT defined at all" do
        let(:const_name) { :NotExistingConst }

        it "returns `nil`" do
          expect(result).to be_nil
        end
      end

      context "when const is defined outside module namespace" do
        ##
        # NOTE: `File` is defined in `Object` class from Ruby Core.
        #
        let(:const_name) { :File }

        it "returns `nil`" do
          expect(result).to be_nil
        end
      end
    end

    context "when const is defined directly inside module namespace" do
      let(:mod) do
        Class.new.tap do |klass|
          klass.const_set(:File, Class.new)
        end
      end

      let(:const_name) { :File }

      it "returns that const" do
        expect(result).to eq(mod::File)
      end
    end
  end

  describe ".has_own_instance_method?" do
    include ConvenientService::RSpec::Matchers::DelegateTo

    let(:mod) do
      Class.new do
        def foo
        end
      end
    end

    ##
    # NOTE: `+` unfreezes string.
    # https://ruby-doc.org/core-3.1.2/String.html#method-i-2B-40
    #
    let(:method_name) { +"foo" }
    let(:private) { false }
    let(:default_kwargs) { {private: private} }
    let(:kwargs) { default_kwargs }

    let(:result) { described_class.has_own_instance_method?(mod, method_name, **kwargs) }

    context "when `mod` does NOT have own instance method" do
      let(:mod) do
        Class.new do
        end
      end

      context "when `private` is NOT passed" do
        let(:kwargs) { ConvenientService::Utils::Hash.except(default_kwargs, [:private]) }

        it "defaults to `false`" do
          ##
          # NOTE: Same result as in "when `private` is `false`".
          #
          expect(result).to eq(false)
        end
      end

      context "when `private` is passed" do
        let(:kwargs) { default_kwargs.merge(private: private) }

        context "when `private` is `false`" do
          let(:private) { false }

          it "returns `false`" do
            expect(result).to eq(false)
          end
        end

        context "when `private` is `true`" do
          let(:private) { true }

          context "when `mod` does NOT have private own instance method" do
            let(:mod) do
              Class.new do
              end
            end

            it "returns `false`" do
              expect(result).to eq(false)
            end
          end

          context "when `mod` has private own instance method" do
            let(:mod) do
              Class.new do
                private

                def foo
                end
              end
            end

            it "returns `true`" do
              expect(result).to eq(true)
            end
          end
        end
      end
    end

    context "when `mod` has own instance method" do
      let(:mod) do
        Class.new do
          def foo
          end
        end
      end

      it "returns `true`" do
        expect(result).to eq(true)
      end
    end

    it "converts `method` to symbol" do
      expect { result }.to delegate_to(method_name, :to_sym)
    end

    it "delegates to `instance_methods(false)` to find public and protected own methods" do
      expect { result }.to delegate_to(mod, :instance_methods).with_arguments(false)
    end

    context "when `private` is `true`" do
      let(:mod) do
        Class.new do
          private

          def foo
          end
        end
      end

      let(:private) { true }

      it "delegates to `private_instance_methods(false)` to find private own methods" do
        expect { result }.to delegate_to(mod, :private_instance_methods).with_arguments(false)
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
