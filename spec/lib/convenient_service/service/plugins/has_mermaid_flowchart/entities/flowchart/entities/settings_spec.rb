# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Service::Plugins::HasMermaidFlowchart::Entities::Flowchart::Entities::Settings do
  include ConvenientService::RSpec::Matchers::DelegateTo

  let(:settings) { described_class.new(flowchart: service.mermaid_flowchart, hash: hash) }

  let(:service) do
    Class.new do
      include ConvenientService::Service::Configs::Standard

      def result
        success
      end
    end
  end

  let(:hash) { {} }

  let(:absolute_path) { "diagram.html" }
  let(:direction) { "TB" }
  let(:title) { "Diagram" }

  example_group "instance methods" do
    example_group "attributes" do
      include ConvenientService::RSpec::Matchers::HaveAttrReader

      subject { settings }

      it { is_expected.to have_attr_reader(:flowchart) }
      it { is_expected.to have_attr_reader(:hash) }
    end

    describe "#absolute_path" do
      context "when `absolute_path` is NOT set" do
        it "returns `default_absolute_path`" do
          expect(settings.absolute_path).to eq(settings.default_absolute_path)
        end
      end

      context "when `absolute_path` is set" do
        before do
          settings.absolute_path = absolute_path
        end

        it "returns that set `absolute_path`" do
          expect(settings.absolute_path).to eq(absolute_path)
        end
      end
    end

    describe "#absolute_path=" do
      it "sets `absolute_path`" do
        settings.absolute_path = absolute_path

        expect(settings.absolute_path).to eq(absolute_path)
      end

      it "returns `absolute_path`" do
        expect(settings.absolute_path = absolute_path).to eq(absolute_path)
      end
    end

    describe "#default_absolute_path" do
      it "returns path from current working directory" do
        expect(settings.default_absolute_path).to eq(File.join(Dir.pwd, "flowchart.html"))
      end

      specify do
        expect { settings.default_absolute_path }
          .to delegate_to(File, :join)
          .with_arguments(Dir.pwd, "flowchart.html")
          .and_return_its_value
      end

      specify do
        expect { settings.default_absolute_path }
          .to delegate_to(Dir, :pwd)
          .without_arguments
      end
    end

    describe "#direction" do
      context "when `direction` is NOT set" do
        it "returns `default_direction`" do
          expect(settings.direction).to eq(settings.default_direction)
        end
      end

      context "when `direction` is set" do
        before do
          settings.direction = direction
        end

        it "returns that set `direction`" do
          expect(settings.direction).to eq(direction)
        end
      end
    end

    describe "#direction=" do
      it "sets `direction`" do
        settings.direction = direction

        expect(settings.direction).to eq(direction)
      end

      it "returns `direction`" do
        expect(settings.direction = direction).to eq(direction)
      end
    end

    describe "#default_direction" do
      specify do
        expect(settings.default_direction).to eq("LR")
      end
    end

    describe "#title" do
      context "when `title` is NOT set" do
        it "returns `default_title`" do
          expect(settings.title).to eq(settings.default_title)
        end
      end

      context "when `title` is set" do
        before do
          settings.title = title
        end

        it "returns that set `title`" do
          expect(settings.title).to eq(title)
        end
      end
    end

    describe "#title=" do
      it "sets `title`" do
        settings.title = title

        expect(settings.title).to eq(title)
      end

      it "returns `title`" do
        expect(settings.title = title).to eq(title)
      end
    end

    describe "#default_title" do
      specify do
        expect { settings.default_title }
          .to delegate_to(ConvenientService::Utils::Class, :display_name)
          .with_arguments(service)
          .and_return_its_value
      end
    end

    example_group "comparison" do
      describe "#==" do
        context "when `other` have different class" do
          let(:other) { 42 }

          it "returns `nil`" do
            expect(settings == other).to be_nil
          end
        end

        context "when `other` have different flowchart" do
          let(:other) { described_class.new(flowchart: other_service.mermaid_flowchart, hash: hash) }

          let(:other_service) do
            Class.new do
              include ConvenientService::Service::Configs::Standard

              def result
                success
              end
            end
          end

          it "returns `false`" do
            expect(settings == other).to eq(false)
          end
        end

        context "when `other` have different hash" do
          let(:other) { described_class.new(flowchart: service.mermaid_flowchart, hash: {absolute_path: "digram.html"}) }

          it "returns `false`" do
            expect(settings == other).to eq(false)
          end
        end

        context "when `other` has same attributes" do
          let(:other) { described_class.new(flowchart: service.mermaid_flowchart, hash: hash) }

          it "returns `true`" do
            expect(settings == other).to eq(true)
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
