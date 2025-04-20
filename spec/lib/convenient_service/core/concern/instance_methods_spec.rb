# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Core::Concern::InstanceMethods, type: :standard do
  include ConvenientService::RSpec::Helpers::IgnoringException

  include ConvenientService::RSpec::Matchers::DelegateTo

  let(:service_class) do
    Class.new do
      include ConvenientService::Core
    end
  end

  ##
  # NOTE: `allocate` since `new` triggers config commitment.
  #
  let(:service_instance) { service_class.allocate }

  let(:args) { [:foo] }
  let(:kwargs) { {foo: :bar} }
  let(:block) { proc { :foo } }

  let(:middleware) do
    Class.new(ConvenientService::MethodChainMiddleware) do
      def next(...)
        chain.next(...)
      end
    end
  end

  example_group "private instance methods" do
    describe "#initialize" do
      it "accepts (*args, **kwargs, &block)" do
        expect { service_instance.__send__(:initialize, *args, **kwargs, &block) }.not_to raise_error
      end
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

      it "commits config" do
        ##
        # NOTE: Intentionally calling missed method. But later it is added by `concerns.include!`.
        #
        expect { service_instance.foo }
          .to delegate_to(service_class, :commit_config!)
          .with_arguments(trigger: ConvenientService::Core::Constants::Triggers::INSTANCE_METHOD_MISSING)
      end

      ##
      # TODO: `it "logs debug message"`.
      #

      it "calls `send`" do
        ##
        # NOTE: If `[:foo, args, kwargs, block&.source_location]` is returned, then `send` was called. See concern above.
        #
        expect(service_instance.foo(*args, **kwargs, &block)).to eq([:foo, args, kwargs, block&.source_location])
      end

      specify do
        expect { service_instance.foo }
          .to delegate_to(ConvenientService::Utils::Module, :instance_method_defined?)
          .with_arguments(service_class, :foo, public: true, protected: false, private: false)
      end

      context "when concerns are included more than once (since they do not contain required instance method)" do
        let(:service_class) do
          Class.new do
            include ConvenientService::Core
          end
        end

        ##
        # NOTE: Ruby 3.4 changes exception messages and backtrace displays.
        # - https://www.ruby-lang.org/en/news/2024/05/16/ruby-3-4-0-preview1-released
        #
        # NOTE: Depending on the `did_you_mean` version, an additional line may be added to the exception message, which is why the `with_message` string is replaced by regex.
        #
        # rubocop:disable RSpec/RepeatedDescription
        if ConvenientService::Dependencies.ruby.version >= 3.4
          it "raises `NoMethodError`" do
            ##
            # NOTE: Intentionally calling missed method that won't be included (no concerns with it).
            #
            expect { service_instance.foo }.to raise_error(NoMethodError).with_message(/undefined method 'foo' for an instance of #{service_instance.class}/)
          end
        elsif ConvenientService::Dependencies.ruby.version >= 3.3
          it "raises `NoMethodError`" do
            ##
            # NOTE: Intentionally calling missed method that won't be included (no concerns with it).
            #
            expect { service_instance.foo }.to raise_error(NoMethodError).with_message(/undefined method `foo' for an instance of #{service_instance.class}/)
          end
        else
          it "raises `NoMethodError`" do
            ##
            # NOTE: Intentionally calling missed method that won't be included (no concerns with it).
            #
            expect { service_instance.foo }.to raise_error(NoMethodError).with_message(/undefined method `foo' for #{service_instance}/)
          end
        end
        # rubocop:enable RSpec/RepeatedDescription

        specify do
          expect { ignoring_exception(NoMethodError) { service_instance.foo } }.to delegate_to(ConvenientService, :reraise)
        end
      end

      context "when middleware caller defined without super method" do
        let(:service_class) do
          Class.new.tap do |klass|
            klass.class_exec(middleware) do |middleware|
              include ConvenientService::Core

              middlewares(:foo, scope: :instance) do |stack|
                stack.use middleware
              end
            end
          end
        end

        ##
        # NOTE: Ruby 3.4 changes exception messages and backtrace displays.
        # - https://www.ruby-lang.org/en/news/2024/05/16/ruby-3-4-0-preview1-released
        #
        # NOTE: Depending on the `did_you_mean` version, an additional line may be added to the exception message, which is why the `with_message` string is replaced by regex.
        #
        # rubocop:disable RSpec/RepeatedDescription
        if ConvenientService::Dependencies.ruby.version >= 3.4
          it "raises `NoMethodError`" do
            ##
            # NOTE: Intentionally calling missed method that won't be included (no concerns with it), but has middlewares.
            #
            expect { service_instance.foo }.to raise_error(NoMethodError).with_message(/super: no superclass method 'foo' for an instance of #{service_instance.class}/)
          end
        elsif ConvenientService::Dependencies.ruby.version >= 3.3
          it "raises `NoMethodError`" do
            ##
            # NOTE: Intentionally calling missed method that won't be included (no concerns with it), but has middlewares.
            #
            expect { service_instance.foo }.to raise_error(NoMethodError).with_message(/super: no superclass method `foo' for an instance of #{service_instance.class}/)
          end
        else
          it "raises `NoMethodError`" do
            ##
            # NOTE: Intentionally calling missed method that won't be included (no concerns with it), but has middlewares.
            #
            expect { service_instance.foo }.to raise_error(NoMethodError).with_message(/super: no superclass method `foo' for #{service_instance}/)
          end
        end

        if ConvenientService::Dependencies.ruby.version >= 3.0
          ##
          # NOTE: Check the following files/links in order to get an idea why this spec is NOT working for Ruby 2.7.
          # - `lib/convenient_service/core/entities/config/entities/method_middlewares/entities/caller/commands/define_method_callers.rb`
          # - https://gist.github.com/marian13/9c25041f835564e945d978839097d419
          #
          specify do
            expect { ignoring_exception(NoMethodError) { service_instance.foo } }.to delegate_to(ConvenientService, :reraise)
          end
        end
      end
    end

    describe "#respond_to_missing?" do
      let(:method_name) { :foo }
      let(:include_private) { false }

      let(:result) { service_instance.respond_to_missing_public?(method_name, include_private) }

      let(:service_class) do
        Class.new do
          include ConvenientService::Core

          ##
          # IMPORTANT: `respond_to_missing?` is always private, which is enforced by Ruby. That is why this wrapper is used.
          # - https://ruby-doc.org/core-2.7.0/Object.html#method-i-respond_to_missing-3F
          # - https://github.com/ruby/spec/blob/master/language/def_spec.rb#L65
          #
          def respond_to_missing_public?(...)
            respond_to_missing?(...)
          end
        end
      end

      ##
      # NOTE: Ruby 3.4 changes exception messages and backtrace displays.
      # - https://www.ruby-lang.org/en/news/2024/05/16/ruby-3-4-0-preview1-released
      #
      # NOTE: Depending on the `did_you_mean` version, an additional line may be added to the exception message, which is why the `with_message` string is replaced by regex.
      #
      # rubocop:disable RSpec/RepeatedDescription
      if ConvenientService::Dependencies.ruby.version >= 3.4
        it "is private" do
          expect { service_instance.respond_to_missing?(method_name, include_private) }
            .to raise_error(NoMethodError)
            .with_message(/private method 'respond_to_missing\?' called for an instance of #{service_instance.class}/)
        end
      elsif ConvenientService::Dependencies.ruby.version >= 3.3
        it "is private" do
          expect { service_instance.respond_to_missing?(method_name, include_private) }
            .to raise_error(NoMethodError)
            .with_message(/private method `respond_to_missing\?' called for an instance of #{service_instance.class}/)
        end
      else
        it "is private" do
          expect { service_instance.respond_to_missing?(method_name, include_private) }
            .to raise_error(NoMethodError)
            .with_message(/private method `respond_to_missing\?' called for #{service_instance}/)
        end
      end
      # rubocop:enable RSpec/RepeatedDescription

      context "when `include_private` is `false`" do
        let(:include_private) { false }

        context "when service class does NOT have public instance method" do
          context "when concerns do NOT have public instance method" do
            let(:service_class) do
              Class.new do
                include ConvenientService::Core

                ##
                # IMPORTANT: `respond_to_missing?` is always private, which is enforced by Ruby. That is why this wrapper is used.
                # - https://ruby-doc.org/core-2.7.0/Object.html#method-i-respond_to_missing-3F
                # - https://github.com/ruby/spec/blob/master/language/def_spec.rb#L65
                #
                def respond_to_missing_public?(...)
                  respond_to_missing?(...)
                end
              end
            end

            it "returns `false`" do
              expect(result).to eq(false)
            end

            context "when service class has private instance method" do
              let(:service_class) do
                Class.new do
                  include ConvenientService::Core

                  ##
                  # IMPORTANT: `respond_to_missing?` is always private, which is enforced by Ruby. That is why this wrapper is used.
                  # - https://ruby-doc.org/core-2.7.0/Object.html#method-i-respond_to_missing-3F
                  # - https://github.com/ruby/spec/blob/master/language/def_spec.rb#L65
                  #
                  def respond_to_missing_public?(...)
                    respond_to_missing?(...)
                  end

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

                  ##
                  # IMPORTANT: `respond_to_missing?` is always private, which is enforced by Ruby. That is why this wrapper is used.
                  # - https://ruby-doc.org/core-2.7.0/Object.html#method-i-respond_to_missing-3F
                  # - https://github.com/ruby/spec/blob/master/language/def_spec.rb#L65
                  #
                  def respond_to_missing_public?(...)
                    respond_to_missing?(...)
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

                ##
                # IMPORTANT: `respond_to_missing?` is always private, which is enforced by Ruby. That is why this wrapper is used.
                # - https://ruby-doc.org/core-2.7.0/Object.html#method-i-respond_to_missing-3F
                # - https://github.com/ruby/spec/blob/master/language/def_spec.rb#L65
                #
                def respond_to_missing_public?(...)
                  respond_to_missing?(...)
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

              ##
              # IMPORTANT: `respond_to_missing?` is always private, which is enforced by Ruby. That is why this wrapper is used.
              # - https://ruby-doc.org/core-2.7.0/Object.html#method-i-respond_to_missing-3F
              # - https://github.com/ruby/spec/blob/master/language/def_spec.rb#L65
              #
              def respond_to_missing_public?(...)
                respond_to_missing?(...)
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

                ##
                # IMPORTANT: `respond_to_missing?` is always private, which is enforced by Ruby. That is why this wrapper is used.
                # - https://ruby-doc.org/core-2.7.0/Object.html#method-i-respond_to_missing-3F
                # - https://github.com/ruby/spec/blob/master/language/def_spec.rb#L65
                #
                def respond_to_missing_public?(...)
                  respond_to_missing?(...)
                end
              end
            end

            it "returns `false`" do
              expect(result).to eq(false)
            end

            context "when service class has private instance method" do
              let(:service_class) do
                Class.new do
                  include ConvenientService::Core

                  ##
                  # IMPORTANT: `respond_to_missing?` is always private, which is enforced by Ruby. That is why this wrapper is used.
                  # - https://ruby-doc.org/core-2.7.0/Object.html#method-i-respond_to_missing-3F
                  # - https://github.com/ruby/spec/blob/master/language/def_spec.rb#L65
                  #
                  def respond_to_missing_public?(...)
                    respond_to_missing?(...)
                  end

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

                  ##
                  # IMPORTANT: `respond_to_missing?` is always private, which is enforced by Ruby. That is why this wrapper is used.
                  # - https://ruby-doc.org/core-2.7.0/Object.html#method-i-respond_to_missing-3F
                  # - https://github.com/ruby/spec/blob/master/language/def_spec.rb#L65
                  #
                  def respond_to_missing_public?(...)
                    respond_to_missing?(...)
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

                ##
                # IMPORTANT: `respond_to_missing?` is always private, which is enforced by Ruby. That is why this wrapper is used.
                # - https://ruby-doc.org/core-2.7.0/Object.html#method-i-respond_to_missing-3F
                # - https://github.com/ruby/spec/blob/master/language/def_spec.rb#L65
                #
                def respond_to_missing_public?(...)
                  respond_to_missing?(...)
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

              ##
              # IMPORTANT: `respond_to_missing?` is always private, which is enforced by Ruby. That is why this wrapper is used.
              # - https://ruby-doc.org/core-2.7.0/Object.html#method-i-respond_to_missing-3F
              # - https://github.com/ruby/spec/blob/master/language/def_spec.rb#L65
              #
              def respond_to_missing_public?(...)
                respond_to_missing?(...)
              end
            end
          end

          it "returns `true`" do
            expect(result).to eq(true)
          end
        end
      end

      context "when `include_private` is NOT passed" do
        let(:result) { service_instance.respond_to_missing_public?(method_name) }

        let(:service_class) do
          Class.new do
            include ConvenientService::Core

            ##
            # IMPORTANT: `respond_to_missing?` is always private, which is enforced by Ruby. That is why this wrapper is used.
            # - https://ruby-doc.org/core-2.7.0/Object.html#method-i-respond_to_missing-3F
            # - https://github.com/ruby/spec/blob/master/language/def_spec.rb#L65
            #
            def respond_to_missing_public?(...)
              respond_to_missing?(...)
            end

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
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
