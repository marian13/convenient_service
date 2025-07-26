# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::RSpec::PrimitiveMatchers::Classes::HaveAliasMethod, type: :standard do
  subject(:matcher_result) { matcher.matches?(object) }

  let(:matcher) { described_class.new(alias_name, original_name) }

  let(:alias_name) { :bar }
  let(:original_name) { :foo }

  let(:klass) do
    Class.new do
      def foo
      end

      alias_method :bar, :foo
    end
  end

  let(:object) { klass.new }

  describe "#matches?" do
    context "when `object` does NOT have method with original method name" do
      let(:klass) { Class.new }

      it "returns `false`" do
        expect(matcher_result).to eq(false)
      end

      it "delegates to `ConvenientService::Utils::Method.defined?`" do
        allow(ConvenientService::Utils::Method).to receive(:defined?).with(original_name, object.class, private: true).and_call_original

        matcher_result

        expect(ConvenientService::Utils::Method).to have_received(:defined?)
      end
    end

    context "when `object` has method with original method name" do
      let(:klass) do
        Class.new do
          def foo
          end
        end
      end

      context "when `object` does NOT have method with alias method" do
        let(:klass) do
          Class.new do
            def foo
            end
          end
        end

        it "returns `false`" do
          expect(matcher_result).to eq(false)
        end

        it "delegates to `ConvenientService::Utils::Method.defined?`" do
          allow(ConvenientService::Utils::Method).to receive(:defined?).with(original_name, object.class, private: true).and_call_original
          allow(ConvenientService::Utils::Method).to receive(:defined?).with(alias_name, object.class, private: true).and_call_original

          matcher_result

          expect(ConvenientService::Utils::Method).to have_received(:defined?).twice
        end
      end

      context "when `object` has method with alias method name" do
        context "when that method is NOT actually alias" do
          let(:klass) do
            Class.new do
              def foo
              end

              def bar
              end
            end
          end

          it "returns `false`" do
            expect(matcher_result).to eq(false)
          end
        end

        context "when that method is actually alias" do
          context "when that method is defined by `alias_method`" do
            let(:klass) do
              Class.new do
                def foo
                end

                alias_method :bar, :foo
              end
            end

            it "returns `true`" do
              expect(matcher_result).to eq(true)
            end

            context "when `object` has method with original method name defined by `attr_reader`" do
              let(:klass) do
                Class.new do
                  attr_reader :foo

                  alias_method :bar, :foo
                end
              end

              it "returns `true`" do
                expect(matcher_result).to eq(true)
              end
            end

            context "when `object` has method with original method name defined by `attr_writer`" do
              let(:original_name) { :foo= }

              let(:klass) do
                Class.new do
                  attr_writer :foo

                  alias_method :bar, :foo=
                end
              end

              it "returns `true`" do
                expect(matcher_result).to eq(true)
              end
            end

            context "when `object` has method with original method name defined by `attr_accessor` reader" do
              let(:klass) do
                Class.new do
                  attr_accessor :foo

                  alias_method :bar, :foo
                end
              end

              it "returns `true`" do
                expect(matcher_result).to eq(true)
              end
            end

            context "when `object` has method with original method name defined by `attr_accessor` writer" do
              let(:original_name) { :foo= }

              let(:klass) do
                Class.new do
                  attr_accessor :foo

                  alias_method :bar, :foo=
                end
              end

              it "returns `true`" do
                expect(matcher_result).to eq(true)
              end
            end

            context "when `object` has method with original method name defined by `attr` reader" do
              let(:klass) do
                Class.new do
                  attr :foo

                  alias_method :bar, :foo
                end
              end

              it "returns `true`" do
                expect(matcher_result).to eq(true)
              end
            end

            context "when `object` has method with original method name defined by `attr` writer" do
              let(:original_name) { :foo= }

              let(:klass) do
                Class.new do
                  # rubocop:disable Lint/DeprecatedClassMethods
                  attr :foo, true
                  # rubocop:enable Lint/DeprecatedClassMethods

                  alias_method :bar, :foo=
                end
              end

              it "returns `true`" do
                expect(matcher_result).to eq(true)
              end
            end
          end

          # rubocop:disable Style/Alias
          context "when that method is defined by `alias`" do
            let(:klass) do
              Class.new do
                def foo
                end

                alias bar foo
              end
            end

            it "returns `true`" do
              expect(matcher_result).to eq(true)
            end

            context "when `object` has method with original method name defined by `attr_reader`" do
              let(:klass) do
                Class.new do
                  attr_reader :foo

                  alias bar foo
                end
              end

              it "returns `true`" do
                expect(matcher_result).to eq(true)
              end
            end

            context "when `object` has method with original method name defined by `attr_writer`" do
              let(:original_name) { :foo= }

              let(:klass) do
                Class.new do
                  attr_writer :foo

                  alias bar foo=
                end
              end

              it "returns `true`" do
                expect(matcher_result).to eq(true)
              end
            end

            context "when `object` has method with original method name defined by `attr_accessor` reader" do
              let(:klass) do
                Class.new do
                  attr_accessor :foo

                  alias bar foo
                end
              end

              it "returns `true`" do
                expect(matcher_result).to eq(true)
              end
            end

            context "when `object` has method with original method name defined by `attr_accessor` writer" do
              let(:original_name) { :foo= }

              let(:klass) do
                Class.new do
                  attr_accessor :foo

                  alias bar foo=
                end
              end

              it "returns `true`" do
                expect(matcher_result).to eq(true)
              end
            end

            context "when `object` has method with original method name defined by `attr` reader" do
              let(:klass) do
                Class.new do
                  attr :foo

                  alias bar foo
                end
              end

              it "returns `true`" do
                expect(matcher_result).to eq(true)
              end
            end

            context "when `object` has method with original method name defined by `attr` writer" do
              let(:original_name) { :foo= }

              let(:klass) do
                Class.new do
                  # rubocop:disable Lint/DeprecatedClassMethods
                  attr :foo, true
                  # rubocop:enable Lint/DeprecatedClassMethods

                  alias bar foo=
                end
              end

              it "returns `true`" do
                expect(matcher_result).to eq(true)
              end
            end
          end
          # rubocop:enable Style/Alias
        end
      end
    end
  end

  describe "#description" do
    it "returns message" do
      matcher_result

      expect(matcher.description).to eq("have alias method `#{alias_name}` for `#{original_name}`")
    end
  end

  describe "#failure_message" do
    it "returns message" do
      matcher_result

      expect(matcher.failure_message).to eq("expected `#{object.class}` to have alias method `#{alias_name}` for `#{original_name}`")
    end
  end

  describe "#failure_message_when_negated" do
    it "returns message" do
      matcher_result

      expect(matcher.failure_message_when_negated).to eq("expected `#{object.class}` NOT to have alias method `#{alias_name}` for `#{original_name}`")
    end
  end
end
# rubocop:enable RSpec/NestedGroups
