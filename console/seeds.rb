# frozen_string_literal: true

# ConvenientService.backtrace_cleaner.remove_silencers!

class CalculateSquare
  include ConvenientService::Standard::Config

  attr_reader :number

  def initialize(number:)
    @number = number
  end

  def result
    success(square: number**2)
  end
end

class GreaterThanNine
  include ConvenientService::Standard::Config

  attr_reader :number

  def initialize(number:)
    @number = number
  end

  def result
    (number > 9) ? success : failure
  end
end

class LessThanExactlyService
  include ConvenientService::Standard::Config

  def result
    step_aware_enumerable([1, 4, 2, 5, 3, 6])
      .collect { |number|
        step CalculateSquare,
          in: [number: -> { number }],
          out: :square
      }
      .select_exactly(2)
      .with_index { |square|
        step GreaterThanNine,
          in: [number: -> { square }]
      }
      .result
  end
end

class ExactlyService
  include ConvenientService::Standard::Config

  def result
    step_aware_enumerable([1, 4, 2, 5, 3, 6])
      .collect { |number|
        step CalculateSquare,
          in: [number: -> { number }],
          out: :square
      }
      .select_exactly(3)
      .with_index { |square|
        step GreaterThanNine,
          in: [number: -> { square }]
      }
      .result
  end
end

class MoreThanExactlyService
  include ConvenientService::Standard::Config

  def result
    step_aware_enumerable([1, 4, 2, 5, 3, 6])
      .collect { |number|
        step CalculateSquare,
          in: [number: -> { number }],
          out: :square
      }
      .select_exactly(4)
      .with_index { |square|
        step GreaterThanNine,
          in: [number: -> { square }]
      }
      .result
  end
end

p [LessThanExactlyService, ExactlyService, MoreThanExactlyService].map(&:result).map(&:status).map(&:to_sym)
