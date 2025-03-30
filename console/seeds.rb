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

class SmallerThanNine
  include ConvenientService::Standard::Config

  attr_reader :number

  def initialize(number:)
    @number = number
  end

  def result
    number < 9 ? success : failure
  end
end

class Service
  include ConvenientService::Standard::Config

  def result
    step_aware_enumerable([1, 2, 3, 4, 5])
      .collect { |number|
        step CalculateSquare,
          in: [number: -> { number }],
          out: :square
      }
      .drop_while { |square|
        step SmallerThanNine,
          in: [number: -> { square }]
      }
      .select_exactly(3)
      .with_index { |square, index| p [square, index] }
      .result
  end
end

result = Service.result

puts result.inspect
puts result.unsafe_data.inspect
