# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module HasMermaidFlowchart
        module Entities
          class Flowchart
            module Entities
              class Template
                ##
                # @api private
                #
                # @return [String]
                #
                def relative_path
                  @relative_path ||= ::File.join("..", "templates", "flowchart.html.erb")
                end

                ##
                # @api private
                #
                # @return [String]
                #
                # @internal
                #   NOTE: `expand_path` docs.
                #   - https://ruby-doc.org/core-2.7.0/File.html#method-c-expand_path
                #
                def absolute_path
                  @absolute_path ||= ::File.expand_path(relative_path, __dir__)
                end

                ##
                # @api private
                #
                # @return [ERB]
                #
                def erb
                  @erb ||= ::ERB.new(content)
                end

                ##
                # @api private
                #
                # @return [String]
                #
                def content
                  @content ||= ::File.read(absolute_path)
                end

                ##
                # @api private
                #
                # @param replacements [Hash{Symbol => Object}]
                # @return [String]
                #
                # @see ConvenientService::Service::Plugins::HasMermaidFlowchart::Entities::Flowchart#replacements
                #
                # @internal
                #   NOTE: Prefer `result_with_hash`.
                #   - https://ruby-doc.org/stdlib-2.7.0/libdoc/erb/rdoc/ERB.html#method-i-result_with_hash
                #
                def render(**replacements)
                  erb.result_with_hash(replacements)
                end

                ##
                # @api private
                #
                # @param other [Object]
                # @return [Boolean, nil]
                #
                def ==(other)
                  return unless other.instance_of?(self.class)

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
