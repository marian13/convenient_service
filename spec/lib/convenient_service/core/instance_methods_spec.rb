# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Core::InstanceMethods do
  include ConvenientService::RSpec::Matchers::DelegateTo

  let(:service_instance) { service_class.new }

  describe "#concerns" do
    let(:service_class) do
      Class.new.tap do |klass|
        klass.class_exec(described_class, concerns_result) do |mod, concerns_result|
          include mod

          define_singleton_method(:concerns) { |&block| concerns_result }
        end
      end
    end

    let(:service_instance) { service_class.new }
    let(:concerns_result) { double }
    let(:configuration_block) { proc {} }

    specify {
      expect { service_instance.concerns(&configuration_block) }
        .to delegate_to(service_class, :concerns)
        .with_arguments(&configuration_block)
        .and_return_its_value
    }
  end

  describe "#middlewares" do
    let(:service_class) do
      Class.new.tap do |klass|
        klass.class_exec(described_class, middlewares_result) do |mod, middlewares_result|
          include mod

          define_singleton_method(:middlewares) { |**kwargs, &block| middlewares_result }
        end
      end
    end

    let(:middlewares_result) { double }
    let(:kwargs) { {foo: :bar} }
    let(:configuration_block) { proc {} }

    specify {
      expect { service_instance.middlewares(**kwargs, &configuration_block) }
        .to delegate_to(service_class, :middlewares)
        .with_arguments(**kwargs, &configuration_block)
        .and_return_its_value
    }
  end

  describe "#method_missing" do
    let(:service_class) do
      Class.new do
        include ConvenientService::Core

        concerns do
          ##
          # NOTE: Simplest concern is just a module.
          # NOTE: Defines `foo` that is later included by service class by `concerns.include!`.
          #
          concern =
            Module.new do
              def foo(*args, **kwargs, &block)
                [:foo, args, kwargs, block&.source_location]
              end
            end

          use concern
        end
      end
    end

    let(:args) { [:foo] }
    let(:kwargs) { {foo: :bar} }
    let(:block) { proc { :foo } }

    it "commits config" do
      ##
      # NOTE: Intentionally calling missed method. But later it is added by `concerns.include!`.
      #
      expect { service_instance.foo }.to delegate_to(service_class, :commit_config!)
    end

    ##
    # TODO: `it "logs debug message"`.
    #

    it "calls super" do
      ##
      # NOTE: If `[:foo, args, kwargs, block&.source_location]` is returned, then `super` was called. See concern above.
      #
      expect(service_instance.foo(*args, **kwargs, &block)).to eq([:foo, args, kwargs, block&.source_location])
    end

    context "when concerns are included more than once (since they do not contain required instance method)" do
      let(:service_class) do
        Class.new do
          include ConvenientService::Core
        end
      end

      it "raises `NoMethodError`" do
        ##
        # NOTE: Intentionally calling missed method that won't be included (no concerns with it).
        #
        expect { service_instance.foo }.to raise_error(NoMethodError).with_message("undefined method `foo' for #{service_instance}")
      end
    end

    context "when middleware caller defined without super method" do
      let(:service_class) do
        Class.new do
          include ConvenientService::Core

          middlewares(:foo, scope: :instance) {}
        end
      end

      it "raises `NoMethodError`" do
        ##
        # NOTE: Intentionally calling missed method that won't be included (no concerns with it), but has middlewares.
        #
        expect { service_instance.foo }.to raise_error(NoMethodError).with_message("super: no superclass method `foo' for #{service_instance}")
      end
    end
  end

  describe "#respond_to_missing?" do
    let(:method_name) { :foo }
    let(:result) { service_instance.respond_to_missing?(method_name, include_private) }

    context "when `include_private` is `false`" do
      let(:include_private) { false }

      context "when service class does NOT have public instance method" do
        context "when concerns do NOT have public instance method" do
          let(:service_class) do
            Class.new do
              include ConvenientService::Core
            end
          end

          it "returns `false`" do
            expect(result).to eq(false)
          end

          context "when service class has private instance method" do
            let(:service_class) do
              Class.new do
                include ConvenientService::Core

                private

                def foo
                end
              end
            end

            it "returns `false`" do
              expect(result).to eq(false)
            end
          end

          context "when concerns have private instance method" do
            let(:service_class) do
              Class.new do
                include ConvenientService::Core

                concerns do
                  concern = Module.new do
                    private

                    def foo
                    end
                  end

                  use concern
                end
              end
            end

            it "returns `false`" do
              expect(result).to eq(false)
            end
          end
        end

        context "when concerns have public instance method" do
          let(:service_class) do
            Class.new do
              include ConvenientService::Core

              concerns do
                concern = Module.new do
                  def foo
                  end
                end

                use concern
              end
            end
          end

          it "returns `true`" do
            expect(result).to eq(true)
          end
        end
      end

      context "when service class has public instance method" do
        let(:service_class) do
          Class.new do
            include ConvenientService::Core

            def foo
            end
          end
        end

        it "returns `true`" do
          expect(result).to eq(true)
        end
      end
    end

    context "when `include_private` is `true`" do
      let(:include_private) { true }

      context "when service class does NOT have public instance method" do
        context "when concerns do NOT have public instance method" do
          let(:service_class) do
            Class.new do
              include ConvenientService::Core
            end
          end

          it "returns `false`" do
            expect(result).to eq(false)
          end

          context "when service class has private instance method" do
            let(:service_class) do
              Class.new do
                include ConvenientService::Core

                private

                def foo
                end
              end
            end

            it "returns `true`" do
              expect(result).to eq(true)
            end
          end

          context "when concerns have private instance method" do
            let(:service_class) do
              Class.new do
                include ConvenientService::Core

                concerns do
                  concern = Module.new do
                    private

                    def foo
                    end
                  end

                  use concern
                end
              end
            end

            it "returns `true`" do
              expect(result).to eq(true)
            end
          end
        end

        context "when concerns have public instance method" do
          let(:service_class) do
            Class.new do
              include ConvenientService::Core

              concerns do
                concern = Module.new do
                  def foo
                  end
                end

                use concern
              end
            end
          end

          it "returns `true`" do
            expect(result).to eq(true)
          end
        end
      end

      context "when service class has public instance method" do
        let(:service_class) do
          Class.new do
            include ConvenientService::Core

            def foo
            end
          end
        end

        it "returns `true`" do
          expect(result).to eq(true)
        end
      end
    end

    context "when `include_private` is NOT passed" do
      let(:result) { service_instance.respond_to_missing?(method_name) }

      let(:service_class) do
        Class.new do
          include ConvenientService::Core

          private

          def foo
          end
        end
      end

      it "defaults to `false`" do
        ##
        # NOTE: private methods are ignored when `include_private` is `false`.
        #
        expect(result).to eq(false)
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
