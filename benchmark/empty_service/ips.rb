# frozen_string_literal: true

require "bundler/setup"
require "service_actor"
require "interactor"
require "trailblazer/operation"
require "active_interaction"
require "light-service"
require "mutations"
require "convenient_service"
require "benchmark/ips"

##
# Imaginary no gem service. Used as unattainable standard.
#
class NoGemService
  Result = Struct.new(:success?, :data)

  def self.result(**kwargs)
    new(**kwargs).result
  end

  def result
    Result.new
  end

  private

  def success(**kwargs)
    Result.new(success?: true, data: kwargs)
  end
end

##
# ServiceActor - Composable Ruby service objects.
# - https://github.com/sunny/actor
#
class ActorService < Actor
  def call
  end
end

##
# Interactor - Interactor provides a common interface for performing complex user interactions.
# - https://github.com/collectiveidea/interactor
#
class InteractorService
  include Interactor

  def call
  end
end

##
# Trailblazer-operation - Trailblazer's Operation implementation.
# - https://trailblazer.to/2.1/docs/operation.html#operation-overview
# - https://github.com/trailblazer/trailblazer-operation
#
class TrailblazerService < Trailblazer::Operation
  step :result

  def result(options, *)
  end
end

##
# ActiveInteraction - Manage application specific business logic.
# - https://github.com/AaronLasseigne/active_interaction
#
class ActiveInteractionService < ActiveInteraction::Base
  def execute
  end
end

##
# LightService - Series of Actions with an emphasis on simplicity.
# - https://github.com/adomokos/light-service
#
class LightServiceService
  extend ::LightService::Action

  executed do |context|
  end
end

##
# Mutations - Compose your business logic into commands that sanitize and validate input.
# - https://github.com/cypriss/mutations
#
class MutationsService < Mutations::Command
  def execute
  end
end

##
# Convenient Service - Service object pattern implementation in Ruby.
# - https://github.com/marian13/convenient_service
#
class ConvenientServiceService
  include ConvenientService::Standard::Config

  def result
    success
  end
end

ConvenientServiceService.commit_config! # Warmup.

Benchmark.ips do |x|
  x.time = 10 # Seconds.
  x.warmup = 0 # No additional warmup required. It is already performed outside.

  x.report("Empty service - Without any gem") { NoGemService.result }
  x.report("Empty service - With Actor") { ActorService.call }
  x.report("Empty service - With Interactor") { InteractorService.call }
  x.report("Empty service - With Trailblazer Operation") { TrailblazerService.call }
  x.report("Empty service - With ActiveInteraction") { ActiveInteractionService.run! }
  x.report("Empty service - With LightService") { LightServiceService.execute }
  x.report("Empty service - With Mutations") { MutationsService.run }
  x.report("Empty service - With Convenient Service") { ConvenientServiceService.result }

  x.compare!(order: :baseline)
end
