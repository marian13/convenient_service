# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Examples::Standard::V1::Cowsay::Services::Print, type: :standard do
  include ConvenientService::RSpec::Matchers::Results
  include ConvenientService::RSpec::Matchers::IncludeModule

  let(:text) { "foo" }
  let(:out) { Tempfile.new }

  example_group "modules" do
    subject { described_class }

    it { is_expected.to include_module(ConvenientService::Standard::V1::Config) }
  end

  example_group "attributes" do
    include ConvenientService::RSpec::PrimitiveMatchers::HaveAttrReader

    subject { service }

    let(:service) { described_class.new(text: text, out: out) }

    it { is_expected.to have_attr_reader(:text) }
    it { is_expected.to have_attr_reader(:out) }
  end

  example_group "class methods" do
    describe ".result" do
      context "when `text` is NOT passed" do
        subject(:result) { described_class.result(out: out) }

        let(:content) do
          <<~'HEREDOC'
             ______________
            < Hello World! >
             --------------
                      \   ^__^
                       \  (oo)\_______
                          (__)\       )\/\
                              ||----w |
                              ||     ||
          HEREDOC
        end

        it "returns success" do
          expect(result).to be_success.without_data
        end

        it "prints cloud and cow to out" do
          result

          expect(out.tap(&:rewind).read).to eq(content)
        end
      end

      context "when `text` is passed" do
        subject(:result) { described_class.result(text: text, out: out) }

        let(:content) do
          <<~'HEREDOC'
             _____
            < Hi! >
             -----
                      \   ^__^
                       \  (oo)\_______
                          (__)\       )\/\
                              ||----w |
                              ||     ||
          HEREDOC
        end

        let(:text) { "Hi!" }

        it "returns `success`" do
          expect(result).to be_success.without_data
        end

        it "prints cloud and cow to out" do
          result

          expect(out.tap(&:rewind).read).to eq(content)
        end

        context "when `out` is NOT passed" do
          subject(:result) { described_class.result(text: text) }

          it "defaults to `stdout`" do
            expect { result }.to output(content).to_stdout
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
