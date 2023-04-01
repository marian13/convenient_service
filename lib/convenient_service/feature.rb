# frozen_string_literal: true

module ConvenientService
  module Feature
    include Support::Concern

    included do
      include Support::DependencyContainer::Entry
      include Support::DependencyContainer::Export
    end
  end
end
