# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Service::Plugins::HasMermaidFlowchart::Entities::Flowchart::Entities::Template, type: :standard do
  example_group "instance methods" do
    include ConvenientService::RSpec::Matchers::DelegateTo
    include ConvenientService::RSpec::PrimitiveMatchers::CacheItsValue

    let(:template) { described_class.new }

    describe "#relative_path" do
      specify do
        expect { template.relative_path }
          .to delegate_to(File, :join)
          .with_arguments("..", "templates", "flowchart.html.erb")
          .and_return_its_value
      end

      specify do
        expect { template.relative_path }.to cache_its_value
      end
    end

    describe "#absolute_path" do
      specify do
        expect { template.absolute_path }
          .to delegate_to(File, :expand_path)
          .with_arguments(template.relative_path, File.join(Dir.pwd, "lib", "convenient_service", "service", "plugins", "has_mermaid_flowchart", "entities", "flowchart", "entities"))
          .and_return_its_value
      end

      specify do
        expect { template.absolute_path }.to cache_its_value
      end
    end

    describe "#erb" do
      specify do
        ##
        # NOTE: `.and_return_its_value` is skipped since `ERB.new` does NOT implement meaningful `#==`.
        # - https://ruby-doc.org/stdlib-2.7.0/libdoc/erb/rdoc/ERB.html
        # - https://github.com/ruby/erb/blob/master/lib/erb.rb
        #
        expect { template.erb }
          .to delegate_to(ERB, :new)
          .with_arguments(template.content)
      end

      it "returns `ERB` instance" do
        expect(template.erb).to be_instance_of(ERB)
      end

      specify do
        expect { template.erb }.to cache_its_value
      end
    end

    describe "#content" do
      specify do
        expect { template.content }
          .to delegate_to(File, :read)
          .with_arguments(template.absolute_path)
          .and_return_its_value
      end

      specify do
        expect { template.content }.to cache_its_value
      end
    end

    describe "#render" do
      let(:replacements) do
        {
          title: "Title",
          code: "flowchart LR\nitem"
        }
      end

      specify do
        expect { template.render(**replacements) }
          .to delegate_to(template.erb, :result_with_hash)
          .with_arguments(replacements)
          .and_return_its_value
      end

      specify do
        expect { template.render(**replacements) }.not_to cache_its_value
      end
    end

    example_group "comparison" do
      describe "#==" do
        context "when `other` have different class" do
          let(:other) { 42 }

          it "returns `nil`" do
            expect(template == other).to be_nil
          end
        end

        context "when `other` has same class" do
          let(:other) { described_class.new }

          it "returns `true`" do
            expect(template == other).to eq(true)
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
