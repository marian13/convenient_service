# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Service::Plugins::HasMermaidFlowchart::Entities::Flowchart, type: :standard do
  include ConvenientService::RSpec::Matchers::DelegateTo
  include ConvenientService::RSpec::PrimitiveMatchers::CacheItsValue

  example_group "instance methods" do
    let(:flowchart) { described_class.new(service: service) }

    let(:service) do
      Class.new do
        include ConvenientService::Standard::Config

        def result
          success
        end
      end
    end

    example_group "attributes" do
      include ConvenientService::RSpec::PrimitiveMatchers::HaveAttrReader

      subject { flowchart }

      it { is_expected.to have_attr_reader(:service) }
    end

    describe "#content" do
      specify do
        expect { flowchart.content }
          .to delegate_to(flowchart.template, :render)
          .with_arguments(**flowchart.replacements)
          .and_return_its_value
      end

      specify do
        expect { flowchart.content }.not_to cache_its_value
      end
    end

    describe "#replacements" do
      let(:replacements) do
        {
          title: flowchart.settings.title,
          code: flowchart.code.generate
        }
      end

      it "returns replacements" do
        expect(flowchart.replacements).to eq(replacements)
      end

      specify do
        expect { flowchart.replacements }.not_to cache_its_value
      end
    end

    describe "#code" do
      specify do
        expect { flowchart.code }
          .to delegate_to(described_class::Entities::Code, :new)
          .with_arguments(flowchart: flowchart)
          .and_return_its_value
      end

      specify do
        expect { flowchart.template }.to cache_its_value
      end
    end

    describe "#settings" do
      specify do
        expect { flowchart.settings }
          .to delegate_to(described_class::Entities::Settings, :new)
          .with_arguments(flowchart: flowchart)
          .and_return_its_value
      end

      specify do
        expect { flowchart.settings }.to cache_its_value
      end
    end

    describe "#template" do
      specify do
        expect { flowchart.template }
          .to delegate_to(described_class::Entities::Template, :new)
          .without_arguments
          .and_return_its_value
      end

      specify do
        expect { flowchart.template }.to cache_its_value
      end
    end

    describe "#save" do
      let(:absolute_path) { tempfile.path }
      let(:tempfile) { Tempfile.new }

      before do
        flowchart.settings.absolute_path = absolute_path
      end

      specify do
        expect { flowchart.save }
          .to delegate_to(File, :write)
          .with_arguments(flowchart.settings.absolute_path, flowchart.content)
          .and_return_its_value
      end

      specify do
        expect { flowchart.save }.to cache_its_value
      end
    end

    example_group "comparison" do
      describe "#==" do
        context "when `other` have different class" do
          let(:other) { 42 }

          it "returns `nil`" do
            expect(flowchart == other).to be_nil
          end
        end

        context "when `other` have different service" do
          let(:other) { described_class.new(service: other_service) }

          let(:other_service) do
            Class.new do
              include ConvenientService::Standard::Config

              def result
                success
              end
            end
          end

          it "returns `nil`" do
            expect(flowchart == other).to eq(false)
          end
        end

        context "when `other` has same attributes" do
          let(:other) { described_class.new(service: service) }

          it "returns `true`" do
            expect(flowchart == other).to eq(true)
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
