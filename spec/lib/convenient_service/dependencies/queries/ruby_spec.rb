# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Dependencies::Queries::Ruby, type: :standard do
  example_group "class methods" do
    describe ".version" do
      it "returns version" do
        expect(described_class.version).to eq(ConvenientService::Dependencies::Queries::Version.new(RUBY_VERSION))
      end
    end

    describe ".mri?" do
      context "when `::RUBY_ENGINE` is NOT valid" do
        context "when `::RUBY_ENGINE` is `nil`" do
          before do
            stub_const("RUBY_ENGINE", nil)
          end

          it "returns `false`" do
            expect(described_class.mri?).to eq(false)
          end
        end

        context "when `::RUBY_ENGINE` is empty string" do
          before do
            stub_const("RUBY_ENGINE", "")
          end

          it "returns `false`" do
            expect(described_class.mri?).to eq(false)
          end
        end
      end

      context "when `::RUBY_ENGINE` is valid" do
        context "when `::RUBY_ENGINE` does NOT equal to `\"ruby\"`" do
          before do
            stub_const("RUBY_ENGINE", "jruby")
          end

          it "returns `false`" do
            expect(described_class.mri?).to eq(false)
          end
        end

        context "when `::RUBY_ENGINE` equals to `\"ruby\"`" do
          before do
            stub_const("RUBY_ENGINE", "ruby")
          end

          it "returns `true`" do
            expect(described_class.mri?).to eq(true)
          end
        end
      end
    end

    describe ".ruby?" do
      context "when `::RUBY_ENGINE` is NOT valid" do
        context "when `::RUBY_ENGINE` is `nil`" do
          before do
            stub_const("RUBY_ENGINE", nil)
          end

          it "returns `false`" do
            expect(described_class.ruby?).to eq(false)
          end
        end

        context "when `::RUBY_ENGINE` is empty string" do
          before do
            stub_const("RUBY_ENGINE", "")
          end

          it "returns `false`" do
            expect(described_class.ruby?).to eq(false)
          end
        end
      end

      context "when `::RUBY_ENGINE` is valid" do
        context "when `::RUBY_ENGINE` does NOT equal to `\"ruby\"`" do
          before do
            stub_const("RUBY_ENGINE", "jruby")
          end

          it "returns `false`" do
            expect(described_class.ruby?).to eq(false)
          end
        end

        context "when `::RUBY_ENGINE` equals to `\"ruby\"`" do
          before do
            stub_const("RUBY_ENGINE", "ruby")
          end

          it "returns `true`" do
            expect(described_class.ruby?).to eq(true)
          end
        end
      end
    end

    describe ".jruby?" do
      context "when `::RUBY_ENGINE` is NOT valid" do
        context "when `::RUBY_ENGINE` is `nil`" do
          before do
            stub_const("RUBY_ENGINE", nil)
          end

          it "returns `false`" do
            expect(described_class.jruby?).to eq(false)
          end
        end

        context "when `::RUBY_ENGINE` is empty string" do
          before do
            stub_const("RUBY_ENGINE", "")
          end

          it "returns `false`" do
            expect(described_class.jruby?).to eq(false)
          end
        end
      end

      context "when `::RUBY_ENGINE` is valid" do
        context "when `::RUBY_ENGINE` does NOT match `/jruby/`" do
          before do
            stub_const("RUBY_ENGINE", "truffleruby")
          end

          it "returns `false`" do
            expect(described_class.jruby?).to eq(false)
          end
        end

        context "when `::RUBY_ENGINE` matches `/jruby/`" do
          before do
            stub_const("RUBY_ENGINE", "jruby")
          end

          it "returns `true`" do
            expect(described_class.jruby?).to eq(true)
          end
        end
      end
    end

    describe ".truffleruby?" do
      context "when `::RUBY_ENGINE` is NOT valid" do
        context "when `::RUBY_ENGINE` is `nil`" do
          before do
            stub_const("RUBY_ENGINE", nil)
          end

          it "returns `false`" do
            expect(described_class.truffleruby?).to eq(false)
          end
        end

        context "when `::RUBY_ENGINE` is empty string" do
          before do
            stub_const("RUBY_ENGINE", "")
          end

          it "returns `false`" do
            expect(described_class.truffleruby?).to eq(false)
          end
        end
      end

      context "when `::RUBY_ENGINE` is valid" do
        context "when `::RUBY_ENGINE` does NOT match `/truffleruby/`" do
          before do
            stub_const("RUBY_ENGINE", "jruby")
          end

          it "returns `false`" do
            expect(described_class.truffleruby?).to eq(false)
          end
        end

        context "when `::RUBY_ENGINE` matches `/truffleruby/`" do
          before do
            stub_const("RUBY_ENGINE", "truffleruby")
          end

          it "returns `true`" do
            expect(described_class.truffleruby?).to eq(true)
          end
        end
      end
    end

    ##
    # NOTE: Specs only to verify syntax. The entire suite altogether verifies the actual behavior.
    #
    describe ".match?" do
      context "when `engine_name` is NOT valid" do
        let(:pattern) { "not_existing_ruby < 10.0" }

        it "raises `NoMethodError`" do
          expect { described_class.match?(pattern) }
            .to raise_error(NoMethodError)
            .with_message(/undefined method [`']not_existing_ruby\?'/)
        end
      end

      context "when `engine_name` is valid" do
        context "when `operator` is NOT valid" do
          let(:pattern) { "ruby << 10.0" }

          it "raises `NoMethodError`" do
            expect { described_class.match?(pattern) }
              .to raise_error(NoMethodError)
              .with_message(/undefined method [`']<<'/)
          end
        end

        context "when `operator` is valid" do
          context "when `engine_version` is NOT valid" do
            let(:pattern) { "ruby > foo" }

            it "raises `ArgumentError`" do
              expect { described_class.match?(pattern) }
                .to raise_error(ArgumentError)
                .with_message(/comparison.+failed/)
            end
          end

          context "when `engine_version` is valid" do
            let(:pattern) { "ruby > 3.5" }

            it "does NOT raise" do
              expect { described_class.match?(pattern) }.not_to raise_error
            end
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
