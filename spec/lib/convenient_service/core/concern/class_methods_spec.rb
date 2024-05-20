# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Core::Concern::ClassMethods, type: :standard do
  include ConvenientService::RSpec::Helpers::IgnoringException

  include ConvenientService::RSpec::Matchers::DelegateTo
  include ConvenientService::RSpec::PrimitiveMatchers::CacheItsValue

  let(:service_class) do
    Class.new do
      include ConvenientService::Core
    end
  end

  let(:config) { ConvenientService::Core::Entities::Config.new(klass: service_class) }

  let(:args) { [:foo] }
  let(:kwargs) { {foo: :bar} }
  let(:block) { proc { :foo } }

  example_group "class methods" do
    describe ".concerns" do
      let(:configuration_block) { proc {} }

      specify do
        allow(ConvenientService::Core::Entities::Config).to receive(:new).with(klass: service_class).and_return(config)

        ##
        # NOTE: `delegate_to` is NOT used since `concerns` is called twice under the hood.
        #
        expect(service_class.concerns(&configuration_block)).to eq(config.concerns)
      end

      ##
      # NOTE: Indirect test for `||=` in `@config ||= Entities::Config.new(klass: self)`.
      #
      specify do
        expect { service_class.concerns(&configuration_block) }.to cache_its_value
      end
    end

    describe ".middlewares" do
      let(:method) { :result }
      let(:scope) { :instance }
      let(:configuration_block) { proc {} }

      specify do
        allow(ConvenientService::Core::Entities::Config).to receive(:new).with(klass: service_class).and_return(config)

        expect { service_class.middlewares(method, scope: scope, &configuration_block) }
          .to delegate_to(config, :middlewares)
          .with_arguments(method, scope: scope, &configuration_block)
          .and_return_its_value
      end

      ##
      # NOTE: Indirect test for `||=` in `@config ||= Entities::Config.new(klass: self)`.
      #
      specify do
        expect { service_class.middlewares(method, scope: scope, &configuration_block) }.to cache_its_value
      end
    end

    describe ".has_committed_config?" do
      before do
        allow(ConvenientService::Core::Entities::Config).to receive(:new).with(klass: service_class).and_return(config)
      end

      specify do
        expect { service_class.has_committed_config? }
          .to delegate_to(config, :committed?)
          .without_arguments
          .and_return_its_value
      end

      context "when config is NOT committed" do
        it "returns `false`" do
          expect(service_class.has_committed_config?).to eq(false)
        end
      end

      context "when config is committed" do
        before do
          service_class.commit_config!
        end

        it "returns `true`" do
          expect(service_class.has_committed_config?).to eq(true)
        end
      end
    end

    describe ".commit_config!" do
      specify do
        allow(ConvenientService::Core::Entities::Config).to receive(:new).with(klass: service_class).and_return(config)

        expect { service_class.commit_config! }.to delegate_to(config, :commit!)
      end

      ##
      # NOTE: Indirect test for `||=` in `@config ||= Entities::Config.new(klass: self)`.
      #
      specify do
        ##
        # NOTE: Returns `true` for the first time, `false` - for the subsequent calls.
        #
        service_class.commit_config!

        ##
        # NOTE: If returns `true`, then `config` was NOT cached.
        #
        expect(service_class.commit_config!).to eq(false)
      end

      example_group "`trigger` option" do
        before do
          allow(ConvenientService::Core::Entities::Config).to receive(:new).with(klass: service_class).and_return(config)
        end

        context "when `trigger` is NOT passed" do
          it "defaults `ConvenientService::Core::Constants::Triggers::USER`" do
            expect { service_class.commit_config! }
              .to delegate_to(config, :commit!)
              .with_arguments(trigger: ConvenientService::Core::Constants::Triggers::USER)
          end
        end

        context "when `trigger` is passed" do
          specify do
            expect { service_class.commit_config!(trigger: ConvenientService::Core::Constants::Triggers::CLASS_METHOD_MISSING) }
              .to delegate_to(config, :commit!)
              .with_arguments(trigger: ConvenientService::Core::Constants::Triggers::CLASS_METHOD_MISSING)
          end
        end
      end
    end

    describe ".new" do
      context "when config is NOT committed" do
        specify do
          expect { service_class.new(*args, **kwargs, &block) }
            .to delegate_to(service_class, :method_missing)
            .with_arguments(:new, *args, **kwargs, &block)
        end

        it "returns new instance" do
          expect(service_class.new(*args, **kwargs, &block)).to be_instance_of(service_class)
        end
      end

      context "when config is committed" do
        before do
          service_class.commit_config!
        end

        specify do
          expect { service_class.new(*args, **kwargs, &block) }
            .not_to delegate_to(service_class, :method_missing)
            .with_arguments(:new, *args, **kwargs, &block)
        end

        it "returns new instance" do
          expect(service_class.new(*args, **kwargs, &block)).to be_instance_of(service_class)
        end
      end
    end
  end

  example_group "private class methods" do
    describe ".method_missing" do
      let(:service_class) do
        Class.new do
          include ConvenientService::Core

          concerns do
            ##
            # NOTE: Defines `foo` that is later extended by service class by `concerns.include!`.
            #
            concern =
              Module.new do
                include ConvenientService::Support::Concern

                class_methods do
                  def foo(*args, **kwargs, &block)
                    [:foo, args, kwargs, block&.source_location]
                  end
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
        expect { service_class.foo }
          .to delegate_to(service_class, :commit_config!)
          .with_arguments(trigger: ConvenientService::Core::Constants::Triggers::CLASS_METHOD_MISSING)
      end

      ##
      # TODO: `it "logs debug message"`.
      #

      it "calls `send`" do
        ##
        # NOTE: If `[:foo, args, kwargs, block&.source_location]` is returned, then `send` was called. See concern above.
        #
        expect(service_class.foo(*args, **kwargs, &block)).to eq([:foo, args, kwargs, block&.source_location])
      end

      specify do
        expect { service_class.foo }
          .to delegate_to(ConvenientService::Utils::Module, :class_method_defined?)
          .with_arguments(service_class, :foo, public: true, protected: false, private: false)
      end

      context "when concerns are included more than once (since they do not contain required class method)" do
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
            expect { service_class.foo }.to raise_error(NoMethodError).with_message(/undefined method 'foo' for class #{service_class}/)
          end
        elsif ConvenientService::Dependencies.ruby.version >= 3.3
          it "raises `NoMethodError`" do
            ##
            # NOTE: Intentionally calling missed method that won't be included (no concerns with it).
            #
            expect { service_class.foo }.to raise_error(NoMethodError).with_message(/undefined method `foo' for class #{service_class}/)
          end
        else
          it "raises `NoMethodError`" do
            ##
            # NOTE: Intentionally calling missed method that won't be included (no concerns with it).
            #
            expect { service_class.foo }.to raise_error(NoMethodError).with_message(/undefined method `foo' for #{service_class}/)
          end
        end

        specify do
          expect { ignoring_exception(NoMethodError) { service_class.foo } }.to delegate_to(ConvenientService, :reraise)
        end
      end

      context "when middleware caller defined without super method" do
        let(:service_class) do
          Class.new do
            include ConvenientService::Core

            middlewares(:foo, scope: :class) {}
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
            expect { service_class.foo }.to raise_error(NoMethodError).with_message(/super: no superclass method 'foo' for class #{service_class}/)
          end
        elsif ConvenientService::Dependencies.ruby.version >= 3.3
          it "raises `NoMethodError`" do
            ##
            # NOTE: Intentionally calling missed method that won't be included (no concerns with it), but has middlewares.
            #
            expect { service_class.foo }.to raise_error(NoMethodError).with_message(/super: no superclass method `foo' for class #{service_class}/)
          end
        else
          it "raises `NoMethodError`" do
            ##
            # NOTE: Intentionally calling missed method that won't be included (no concerns with it), but has middlewares.
            #
            expect { service_class.foo }.to raise_error(NoMethodError).with_message(/super: no superclass method `foo' for #{service_class}/)
          end
        end
        # rubocop:enable RSpec/RepeatedDescription

        if ConvenientService::Dependencies.ruby.version >= 3.0
          ##
          # NOTE: Check the following files/links in order to get an idea why this spec is NOT working for Ruby 2.7.
          # - `lib/convenient_service/core/entities/config/entities/method_middlewares/entities/caller/commands/define_method_middlewares_caller.rb`
          # - https://gist.github.com/marian13/9c25041f835564e945d978839097d419
          #
          specify do
            expect { ignoring_exception(NoMethodError) { service_class.foo } }.to delegate_to(ConvenientService, :reraise)
          end
        end
      end
    end

    describe ".respond_to_missing?" do
      let(:method_name) { :foo }
      let(:include_private) { false }

      let(:result) { service_class.respond_to_missing_public?(method_name, include_private) }

      let(:service_class) do
        Class.new do
          include ConvenientService::Core

          class << self
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
          expect { service_class.respond_to_missing?(method_name, include_private) }
            .to raise_error(NoMethodError)
            .with_message(/private method 'respond_to_missing\?' called for class #{service_class}/)
        end
      elsif ConvenientService::Dependencies.ruby.version >= 3.3
        it "is private" do
          expect { service_class.respond_to_missing?(method_name, include_private) }
            .to raise_error(NoMethodError)
            .with_message(/private method `respond_to_missing\?' called for class #{service_class}/)
        end
      else
        it "is private" do
          expect { service_class.respond_to_missing?(method_name, include_private) }
            .to raise_error(NoMethodError)
            .with_message(/private method `respond_to_missing\?' called for #{service_class}/)
        end
      end
      # rubocop:enable RSpec/RepeatedDescription

      context "when `include_private` is `false`" do
        let(:include_private) { false }

        context "when service class does NOT have public class method" do
          context "when concerns do NOT have public class method" do
            let(:service_class) do
              Class.new do
                include ConvenientService::Core

                class << self
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
            end

            it "returns `false`" do
              expect(result).to eq(false)
            end

            context "when service class has private class method" do
              let(:service_class) do
                Class.new do
                  include ConvenientService::Core

                  class << self
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
              end

              it "returns `false`" do
                expect(result).to eq(false)
              end
            end

            context "when concerns have private class method" do
              let(:service_class) do
                Class.new do
                  include ConvenientService::Core

                  concerns do
                    concern = Module.new do
                      include ConvenientService::Support::Concern

                      class_methods do
                        private

                        def foo
                        end
                      end
                    end

                    use concern
                  end

                  class << self
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
              end

              it "returns `false`" do
                expect(result).to eq(false)
              end
            end
          end

          context "when concerns have public class method" do
            let(:service_class) do
              Class.new do
                include ConvenientService::Core

                concerns do
                  concern = Module.new do
                    include ConvenientService::Support::Concern

                    class_methods do
                      def foo
                      end
                    end
                  end

                  use concern
                end

                class << self
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

              class << self
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
          end

          it "returns `true`" do
            expect(result).to eq(true)
          end
        end
      end

      context "when `include_private` is `true`" do
        let(:include_private) { true }

        context "when service class does NOT have public class method" do
          context "when concerns do NOT have public class method" do
            let(:service_class) do
              Class.new do
                include ConvenientService::Core

                class << self
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
            end

            it "returns `false`" do
              expect(result).to eq(false)
            end

            context "when service class has private class method" do
              let(:service_class) do
                Class.new do
                  include ConvenientService::Core

                  class << self
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
              end

              it "returns `true`" do
                expect(result).to eq(true)
              end
            end

            context "when concerns have private class method" do
              let(:service_class) do
                Class.new do
                  include ConvenientService::Core

                  concerns do
                    concern = Module.new do
                      include ConvenientService::Support::Concern

                      class_methods do
                        private

                        def foo
                        end
                      end
                    end

                    use concern
                  end

                  class << self
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
              end

              it "returns `true`" do
                expect(result).to eq(true)
              end
            end
          end

          context "when concerns have public class method" do
            let(:service_class) do
              Class.new do
                include ConvenientService::Core

                concerns do
                  concern = Module.new do
                    include ConvenientService::Support::Concern

                    class_methods do
                      def foo
                      end
                    end
                  end

                  use concern
                end

                class << self
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

              class << self
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
          end

          it "returns `true`" do
            expect(result).to eq(true)
          end
        end
      end

      context "when `include_private` is NOT passed" do
        let(:result) { service_class.respond_to_missing_public?(method_name) }

        let(:service_class) do
          Class.new do
            include ConvenientService::Core

            class << self
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
