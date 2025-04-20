# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

return unless defined? ConvenientService::Examples::Standard

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Examples::Standard::Gemfile::Services::AssertFileNotEmpty, type: :standard do
  include ConvenientService::RSpec::Matchers::Results
  include ConvenientService::RSpec::Matchers::IncludeModule

  example_group "modules" do
    subject { described_class }

    it { is_expected.to include_module(ConvenientService::Standard::Config) }
  end

  example_group "class methods" do
    describe ".result" do
      subject(:result) { described_class.result(path: path) }

      context "when `AssertFileNotEmpty` is NOT successful" do
        context "when `path` is NOT valid" do
          context "when `path` is `nil`" do
            let(:path) { nil }

            it "returns `error` with `message`" do
              expect(result).to be_error.with_message("Path is `nil`").of_service(described_class).without_step
            end
          end

          context "when `path` is empty" do
            let(:path) { "" }

            it "returns `error` with `message`" do
              expect(result).to be_error.with_message("Path is empty").of_service(described_class).without_step
            end
          end
        end

        context "when file is empty" do
          ##
          # NOTE: Tempfile uses its own `let` in order to prevent its premature garbage collection.
          #
          let(:tempfile) { Tempfile.new }
          let(:path) { tempfile.path }

          it "returns `failure` with `message`" do
            expect(result).to be_failure.with_message("File with path `#{path}` is empty").of_service(described_class).without_step
          end
        end
      end

      context "when `AssertFileNotEmpty` is successful" do
        ##
        # NOTE: Tempfile uses its own `let` in order to prevent its premature garbage collection.
        #
        let(:tempfile) { Tempfile.new.tap { |file| file.write("content") }.tap(&:close) }
        let(:path) { tempfile.path }

        it "returns `success`" do
          expect(result).to be_success.of_service(described_class).without_step
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
