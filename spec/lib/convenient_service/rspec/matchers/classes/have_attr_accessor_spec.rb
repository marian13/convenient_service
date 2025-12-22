# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::RSpec::Matchers::Classes::HaveAttrAccessor, type: :standard do
  subject(:matcher_result) { matcher.matches?(object) }

  let(:matcher) { described_class.new(attr_name) }

  let(:attr_name) { :foo }
  let(:object) { klass.new }
  let(:klass) { Class.new }

  describe "#matches?" do
    context "when `object` does NOT have accessor `method`" do
      context "when `object` does NOT have reader `method`" do
        let(:klass) { Class.new }

        it "returns `false`" do
          expect(matcher_result).to be(false)
        end
      end

      context "when `object` has reader `method`" do
        context "when that reader `method` does NOT return corresponding instance variable value" do
          let(:klass) do
            Class.new do
              def foo
                :foo
              end
            end
          end

          it "returns `false`" do
            expect(matcher_result).to be(false)
          end
        end

        context "when that reader `method` returns corresponding instance variable value" do
          context "when that reader `method` defined explicitly" do
            context "when `object` does NOT have writer `method`" do
              let(:klass) do
                Class.new do
                  # rubocop:disable Style/TrivialAccessors
                  def foo
                    @foo
                  end
                  # rubocop:enable Style/TrivialAccessors
                end
              end

              it "returns `false`" do
                expect(matcher_result).to be(false)
              end
            end

            context "when `object` has writer `method`" do
              context "when that writer `method` does NOT set and return corresponding instance variable value" do
                let(:klass) do
                  Class.new do
                    # rubocop:disable Style/TrivialAccessors
                    def foo
                      @foo
                    end
                    # rubocop:enable Style/TrivialAccessors

                    def foo=(value)
                      :foo
                    end
                  end
                end

                it "returns `false`" do
                  expect(matcher_result).to be(false)
                end
              end

              context "when that writer `method` does NOT set but return corresponding instance variable value" do
                let(:klass) do
                  Class.new do
                    # rubocop:disable Style/TrivialAccessors
                    def foo
                      @foo
                    end
                    # rubocop:enable Style/TrivialAccessors

                    def foo=(value)
                      value
                    end
                  end
                end

                it "returns `false`" do
                  expect(matcher_result).to be(false)
                end
              end

              context "when that writer `method` sets and returns corresponding instance variable value" do
                context "when that `method` defined explicitly" do
                  let(:klass) do
                    Class.new do
                      # rubocop:disable Style/TrivialAccessors
                      def foo
                        @foo
                      end
                      # rubocop:enable Style/TrivialAccessors

                      # rubocop:disable Style/TrivialAccessors
                      def foo=(value)
                        @foo = value
                      end
                      # rubocop:enable Style/TrivialAccessors
                    end
                  end

                  it "returns `true`" do
                    expect(matcher_result).to be(true)
                  end
                end

                context "when that `method` defined `attr_writer`" do
                  let(:klass) do
                    Class.new do
                      # rubocop:disable Style/TrivialAccessors
                      def foo
                        @foo
                      end
                      # rubocop:enable Style/TrivialAccessors

                      attr_writer :foo
                    end
                  end

                  it "returns `true`" do
                    expect(matcher_result).to be(true)
                  end
                end

                context "when that `method` defined `attr` with `true`" do
                  let(:klass) do
                    Class.new do
                      # rubocop:disable Style/TrivialAccessors
                      def foo
                        @foo
                      end
                      # rubocop:enable Style/TrivialAccessors

                      # rubocop:disable Lint/DeprecatedClassMethods
                      attr :foo, true
                      # rubocop:enable Lint/DeprecatedClassMethods
                    end
                  end

                  it "returns `true`" do
                    expect(matcher_result).to be(true)
                  end
                end
              end
            end
          end

          context "when that `method` defined `attr_reader`" do
            context "when `object` does NOT have writer `method`" do
              let(:klass) do
                Class.new do
                  attr_reader :foo
                end
              end

              it "returns `false`" do
                expect(matcher_result).to be(false)
              end
            end

            context "when `object` has writer `method`" do
              context "when that writer `method` does NOT set and return corresponding instance variable value" do
                let(:klass) do
                  Class.new do
                    attr_reader :foo

                    def foo=(value)
                      :foo
                    end
                  end
                end

                it "returns `false`" do
                  expect(matcher_result).to be(false)
                end
              end

              context "when that writer `method` does NOT set but return corresponding instance variable value" do
                let(:klass) do
                  Class.new do
                    attr_reader :foo

                    def foo=(value)
                      value
                    end
                  end
                end

                it "returns `false`" do
                  expect(matcher_result).to be(false)
                end
              end

              context "when that writer `method` sets and returns corresponding instance variable value" do
                context "when that `method` defined explicitly" do
                  let(:klass) do
                    Class.new do
                      attr_reader :foo

                      # rubocop:disable Style/TrivialAccessors
                      def foo=(value)
                        @foo = value
                      end
                      # rubocop:enable Style/TrivialAccessors
                    end
                  end

                  it "returns `true`" do
                    expect(matcher_result).to be(true)
                  end
                end

                context "when that `method` defined `attr_writer`" do
                  let(:klass) do
                    Class.new do
                      attr_reader :foo

                      attr_writer :foo
                    end
                  end

                  it "returns `true`" do
                    expect(matcher_result).to be(true)
                  end
                end

                context "when that `method` defined `attr` with `true`" do
                  let(:klass) do
                    Class.new do
                      attr_reader :foo

                      # rubocop:disable Lint/DeprecatedClassMethods
                      attr :foo, true
                      # rubocop:enable Lint/DeprecatedClassMethods
                    end
                  end

                  it "returns `true`" do
                    expect(matcher_result).to be(true)
                  end
                end
              end
            end
          end

          context "when that `method` defined `attr`" do
            context "when `object` does NOT have writer `method`" do
              let(:klass) do
                Class.new do
                  attr :foo
                end
              end

              it "returns `false`" do
                expect(matcher_result).to be(false)
              end
            end

            context "when `object` has writer `method`" do
              context "when that writer `method` does NOT set and return corresponding instance variable value" do
                let(:klass) do
                  Class.new do
                    attr :foo

                    def foo=(value)
                      :foo
                    end
                  end
                end

                it "returns `false`" do
                  expect(matcher_result).to be(false)
                end
              end

              context "when that writer `method` does NOT set but return corresponding instance variable value" do
                let(:klass) do
                  Class.new do
                    attr :foo

                    def foo=(value)
                      value
                    end
                  end
                end

                it "returns `false`" do
                  expect(matcher_result).to be(false)
                end
              end

              context "when that writer `method` sets and returns corresponding instance variable value" do
                context "when that `method` defined explicitly" do
                  let(:klass) do
                    Class.new do
                      attr :foo

                      # rubocop:disable Style/TrivialAccessors
                      def foo=(value)
                        @foo = value
                      end
                      # rubocop:enable Style/TrivialAccessors
                    end
                  end

                  it "returns `true`" do
                    expect(matcher_result).to be(true)
                  end
                end

                context "when that `method` defined `attr_writer`" do
                  let(:klass) do
                    Class.new do
                      attr :foo

                      attr_writer :foo
                    end
                  end

                  it "returns `true`" do
                    expect(matcher_result).to be(true)
                  end
                end

                context "when that `method` defined `attr` with `true`" do
                  let(:klass) do
                    Class.new do
                      attr :foo

                      # rubocop:disable Lint/DeprecatedClassMethods
                      attr :foo, true
                      # rubocop:enable Lint/DeprecatedClassMethods
                    end
                  end

                  it "returns `true`" do
                    expect(matcher_result).to be(true)
                  end
                end
              end
            end
          end

          context "when that `method` defined `attr` with `false`" do
            context "when `object` does NOT have writer `method`" do
              let(:klass) do
                Class.new do
                  # rubocop:disable Lint/DeprecatedClassMethods
                  attr :foo, false
                  # rubocop:enable Lint/DeprecatedClassMethods
                end
              end

              it "returns `false`" do
                expect(matcher_result).to be(false)
              end
            end

            context "when `object` has writer `method`" do
              context "when that writer `method` does NOT set and return corresponding instance variable value" do
                let(:klass) do
                  Class.new do
                    # rubocop:disable Lint/DeprecatedClassMethods
                    attr :foo, false
                    # rubocop:enable Lint/DeprecatedClassMethods

                    def foo=(value)
                      :foo
                    end
                  end
                end

                it "returns `false`" do
                  expect(matcher_result).to be(false)
                end
              end

              context "when that writer `method` does NOT set but return corresponding instance variable value" do
                let(:klass) do
                  Class.new do
                    # rubocop:disable Lint/DeprecatedClassMethods
                    attr :foo, false
                    # rubocop:enable Lint/DeprecatedClassMethods

                    def foo=(value)
                      value
                    end
                  end
                end

                it "returns `false`" do
                  expect(matcher_result).to be(false)
                end
              end

              context "when that writer `method` sets and returns corresponding instance variable value" do
                context "when that `method` defined explicitly" do
                  let(:klass) do
                    Class.new do
                      # rubocop:disable Lint/DeprecatedClassMethods
                      attr :foo, false
                      # rubocop:enable Lint/DeprecatedClassMethods

                      # rubocop:disable Style/TrivialAccessors
                      def foo=(value)
                        @foo = value
                      end
                      # rubocop:enable Style/TrivialAccessors
                    end
                  end

                  it "returns `true`" do
                    expect(matcher_result).to be(true)
                  end
                end

                context "when that `method` defined `attr_writer`" do
                  let(:klass) do
                    Class.new do
                      # rubocop:disable Lint/DeprecatedClassMethods
                      attr :foo, false
                      # rubocop:enable Lint/DeprecatedClassMethods

                      attr_writer :foo
                    end
                  end

                  it "returns `true`" do
                    expect(matcher_result).to be(true)
                  end
                end

                context "when that `method` defined `attr` with `true`" do
                  let(:klass) do
                    Class.new do
                      # rubocop:disable Lint/DeprecatedClassMethods
                      attr :foo, false
                      # rubocop:enable Lint/DeprecatedClassMethods

                      # rubocop:disable Lint/DeprecatedClassMethods
                      attr :foo, true
                      # rubocop:enable Lint/DeprecatedClassMethods
                    end
                  end

                  it "returns `true`" do
                    expect(matcher_result).to be(true)
                  end
                end
              end
            end
          end
        end
      end
    end

    context "when `object` has accessor `method`" do
      let(:klass) do
        Class.new do
          attr_accessor :foo
        end
      end

      it "returns `true`" do
        expect(matcher_result).to be(true)
      end
    end
  end

  describe "#description" do
    it "returns message" do
      matcher_result

      expect(matcher.description).to eq("have attr accessor `#{attr_name}`")
    end
  end

  describe "#failure_message" do
    it "returns message" do
      matcher_result

      expect(matcher.failure_message).to eq("expected `#{object.class}` to have attr accessor `#{attr_name}`")
    end
  end

  describe "#failure_message_when_negated" do
    it "returns message" do
      matcher_result

      expect(matcher.failure_message_when_negated).to eq("expected `#{object.class}` NOT to have attr accessor `#{attr_name}`")
    end
  end
end
# rubocop:enable RSpec/NestedGroups
