# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module Service
    module Plugins
      module HasMermaidFlowchart
        module Entities
          class Flowchart
            module Entities
              class Settings
                ##
                # @api private
                #
                # @!attribute flowchart [r]
                #   @return [ConvenientService::Service::Plugins::HasMermaidFlowchart::Entities::Flowchart]
                #
                attr_reader :flowchart

                ##
                # @api private
                #
                # @!attribute hash [r]
                #   @return [Hash]
                #
                attr_reader :hash

                ##
                # @api private
                #
                # @return [void]
                #
                def initialize(flowchart:, hash: {})
                  @flowchart = flowchart
                  @hash = hash
                end

                ##
                # @api public
                #
                # @return [String]
                #
                def absolute_path
                  hash.fetch(:absolute_path) { default_absolute_path }
                end

                ##
                # @api public
                #
                # @return [String]
                #
                def absolute_path=(other_absolute_path)
                  hash[:absolute_path] = other_absolute_path
                end

                ##
                # @api public
                #
                # @return [String]
                #
                def default_absolute_path
                  ::File.join(::Dir.pwd, "flowchart.html")
                end

                ##
                # @api public
                #
                # @return [String]
                #
                def direction
                  hash.fetch(:direction) { default_direction }
                end

                ##
                # @api public
                #
                # @return [String]
                #
                def direction=(other_direction)
                  hash[:direction] = other_direction
                end

                ##
                # @api public
                #
                # Possible FlowChart directions are:
                #   TB - Top to bottom
                #   TD - Top-down/ same as top to bottom
                #   BT - Bottom to top
                #   RL - Right to left
                #   LR - Left to right
                #
                # @see https://mermaid.js.org/syntax/flowchart.html#direction
                #
                def default_direction
                  "LR"
                end

                ##
                # @api public
                #
                # @return [String]
                #
                def title
                  hash.fetch(:title) { default_title }
                end

                ##
                # @api public
                #
                # @return [String]
                #
                def title=(other_title)
                  hash[:title] = other_title
                end

                ##
                # @api public
                #
                def default_title
                  Utils::Class.display_name(flowchart.service)
                end

                ##
                # @api private
                #
                # @param other [Object]
                # @return [Boolean, nil]
                #
                def ==(other)
                  return unless other.instance_of?(self.class)

                  return false if flowchart != other.flowchart
                  return false if hash != other.hash

                  true
                end
              end
            end
          end
        end
      end
    end
  end
end
