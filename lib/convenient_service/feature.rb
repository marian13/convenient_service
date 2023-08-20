# frozen_string_literal: true

module ConvenientService
  module Feature
    include Support::Concern

    included do
      include Support::DependencyContainer::Entry
    end
  end
end
