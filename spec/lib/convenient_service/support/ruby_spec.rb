# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Support::Ruby do
  example_group "class methods" do
    describe ".version" do
      it "returns version" do
        expect(described_class.version).to eq(ConvenientService::Support::Version.new(RUBY_VERSION))
      end
    end

    describe ".jruby?" do
      context "when `::RUBY_PLATFORM` is NOT valid" do
        context "when `::RUBY_PLATFORM` is `nil`" do
          before do
            stub_const("RUBY_PLATFORM", nil)
          end

          it "returns `false`" do
            expect(described_class.jruby?).to eq(false)
          end
        end

        context "when `::RUBY_PLATFORM` is empty string" do
          before do
            stub_const("RUBY_PLATFORM", "")
          end

          it "returns `false`" do
            expect(described_class.jruby?).to eq(false)
          end
        end
      end

      context "when `::RUBY_PLATFORM` is valid" do
        context "when `::RUBY_PLATFORM` does NOT match `/java/`" do
          before do
            stub_const("RUBY_PLATFORM", "x86_64-darwin18")
          end

          it "returns `false`" do
            expect(described_class.jruby?).to eq(false)
          end
        end

        context "when `::RUBY_PLATFORM` matches `/java/`" do
          before do
            stub_const("RUBY_PLATFORM", "java")
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
  end
end
# rubocop:enable RSpec/NestedGroups
