# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

# rubocop:disable all
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
# rubocop:enable all
