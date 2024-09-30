# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Common::Plugins::HasInstanceProxy::Entities::InstanceProxy, type: :standard do
  include ConvenientService::RSpec::Matchers::DelegateTo
  include ConvenientService::RSpec::PrimitiveMatchers::CacheItsValue

  let(:instance_proxy) { described_class.new(target: target) }
  let(:target) { target_klass.new }

  let(:target_klass) do
    Class.new do
      def foo(*args, **kwargs, &block)
        [__method__, args, kwargs, block]
      end
    end
  end

  example_group "instance methods" do
    describe "#instance_proxy_target" do
      it "returns `target` passed to constructor" do
        expect(instance_proxy.instance_proxy_target).to eq(target)
      end

      it "uses `@__convenient_service_instance_proxy_target__` as instance variable" do
        expect(instance_proxy.instance_proxy_target).to eq(instance_proxy.instance_variable_get(:@__convenient_service_instance_proxy_target__))
      end
    end

    describe "#instance_proxy_class" do
      it "returns instance proxy class" do
        expect(instance_proxy.instance_proxy_class).to eq(described_class)
      end
    end

    describe "#class" do
      it "returns target class" do
        expect(instance_proxy.class).to eq(target_klass)
      end
    end

    example_group "comparison" do
      describe "#==" do
        let(:instance_proxy) { described_class.new(target: target) }

        context "when `other` has different class" do
          let(:other) { 42 }

          it "returns `nil`" do
            expect(instance_proxy == other).to be_nil
          end
        end

        context "when `other` has different `target`" do
          let(:other) { described_class.new(target: 42) }

          it "returns `false`" do
            expect(instance_proxy == other).to eq(false)
          end
        end

        context "when `other` has same attributes" do
          let(:other) { described_class.new(target: target) }

          it "returns `true`" do
            expect(instance_proxy == other).to eq(true)
          end
        end
      end
    end
  end

  example_group "private instance methods" do
    describe "#respond_to_missing?" do
      let(:method_name) { :foo }
      let(:include_private) { false }
      let(:instance_proxy) { instance_proxy_klass.new(target: target) }

      let(:instance_proxy_klass) do
        Class.new(described_class) do
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
          expect { instance_proxy.respond_to_missing?(method_name, include_private) }
            .to raise_error(NoMethodError)
            .with_message(/private method 'respond_to_missing\?' called for an instance of #{target.class}/)
        end
      elsif ConvenientService::Dependencies.ruby.version >= 3.3
        it "is private" do
          expect { instance_proxy.respond_to_missing?(method_name, include_private) }
            .to raise_error(NoMethodError)
            .with_message(/private method `respond_to_missing\?' called for an instance of #{target.class}/)
        end
      else
        it "is private" do
          expect { instance_proxy.respond_to_missing?(method_name, include_private) }
            .to raise_error(NoMethodError)
            .with_message(/private method `respond_to_missing\?' called for #{target}/)
        end
      end
      # rubocop:enable RSpec/RepeatedDescription

      specify do
        expect { instance_proxy.respond_to_missing_public?(method_name, include_private) }
          .to delegate_to(instance_proxy.instance_proxy_target, :respond_to?)
          .with_arguments(method_name, include_private)
          .and_return_its_value
      end
    end

    describe "#method_missing" do
      let(:args) { [:foo] }
      let(:kwargs) { {foo: :bar} }
      let(:block) { proc { :foo } }

      specify do
        expect { instance_proxy.foo(*args, **kwargs, &block) }
          .to delegate_to(instance_proxy.instance_proxy_target, :public_send)
          .with_arguments(:foo, *args, **kwargs, &block)
          .and_return_its_value
      end

      specify do
        expect { instance_proxy.foo(*args, **kwargs, &block) }.to delegate_to(ConvenientService, :reraise)
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
