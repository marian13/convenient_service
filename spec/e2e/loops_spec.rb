# frozen_string_literal: true

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers, RSpec/DescribeClass, RSpec/ExampleLength, RSpec/MissingExampleGroupArgument, RSpec/MultipleExpectations
RSpec.describe "Loops", type: [:standard, :e2e] do
  include ConvenientService::RSpec::Matchers::Results

  example_group "enumerable" do
    let(:enumerable_class) do
      Class.new do
        include Enumerable

        attr_reader :collection

        def initialize(collection)
          @collection = collection
        end

        def each(&block)
          collection.each(&block)
        end

        def ==(other)
          return unless other.instance_of?(self.class)

          collection == other.collection
        end

        def self.name
          "Enumerable"
        end
      end
    end

    example_group "instance methods" do
      let(:service_class) do
        Class.new do
          include ConvenientService::Standard::Config
        end
      end

      let(:service) { service_class.new }

      let(:status_service) do
        Class.new do
          include ConvenientService::Standard::Config

          attr_reader :status

          def initialize(status:)
            @status = status
          end

          def result
            case status
            when :success then success(status_string: "ok", status_code: 200)
            when :failure then failure
            when :error then error
            when :exception then raise
            else
              raise
            end
          end

          def self.name
            "StatusService"
          end
        end
      end

      let(:statuses_service) do
        Class.new do
          include ConvenientService::Standard::Config

          attr_reader :statuses

          def initialize(statuses:)
            @statuses = statuses
          end

          def result
            if statuses.include?(:exception)
              raise
            elsif statuses.include?(:error)
              error
            elsif statuses.include?(:failure)
              failure
            elsif statuses.uniq.include?(:success)
              success(status_string: "ok", status_code: 200)
            else
              raise
            end
          end

          def self.name
            "StatusesService"
          end
        end
      end

      let(:number_service) do
        Class.new do
          include ConvenientService::Standard::Config

          attr_reader :number

          def initialize(number:)
            @number = number
          end

          ##
          # NOTE: `number_code` is ASCII Code.
          #
          def result
            case number
            when 0 then success(number_string: "zero", number_code: 48)
            when 1 then success(number_string: "one", number_code: 49)
            when 2 then success(number_string: "two", number_code: 50)
            when 3 then success(number_string: "three", number_code: 51)
            when 4 then success(number_string: "four", number_code: 52)
            when 5 then success(number_string: "five", number_code: 53)
            when -Float::INFINITY..-1 then error
            else
              raise
            end
          end

          def self.name
            "NumberService"
          end
        end
      end

      let(:numbers_service) do
        Class.new do
          include ConvenientService::Standard::Config

          attr_reader :numbers

          def initialize(numbers:)
            @numbers = numbers
          end

          ##
          # NOTE: `number_code` is ASCII Code.
          #
          def result
            return error if numbers.any? { |number| (-Float::INFINITY..-1).cover?(number) }

            formatted_numbers =
              numbers.map do |number|
                case number
                when 0 then {string: "zero", code: 48}
                when 1 then {string: "one", code: 49}
                when 2 then {string: "two", code: 50}
                when 3 then {string: "three", code: 51}
                when 4 then {string: "four", code: 52}
                when 5 then {string: "five", code: 53}
                else
                  raise
                end
              end

            success(number_strings: formatted_numbers.map { |number| number[:string] }, number_codes: formatted_numbers.map { |number| number[:code] })
          end

          def self.name
            "NumbersService"
          end
        end
      end

      let(:compare_numbers_service) do
        Class.new do
          include ConvenientService::Standard::Config

          attr_reader :number, :other_number

          def initialize(number:, other_number:)
            @number = number
            @other_number = other_number
          end

          ##
          # NOTE: `number_code` is ASCII Code.
          #
          def result
            return error if [number, other_number].any? { |value| (-Float::INFINITY..-1).cover?(value) }

            case number <=> other_number
            when -1
              success(integer: -1, operator: "<")
            when 1
              success(integer: 1, operator: ">")
            when 0
              success(integer: 0, operator: "=")
            else
              raise
            end
          end

          def self.name
            "CompareNumbersService"
          end
        end
      end

      let(:add_numbers_service) do
        Class.new do
          include ConvenientService::Standard::Config

          attr_reader :number, :other_number

          def initialize(number:, other_number:)
            @number = number
            @other_number = other_number
          end

          def result
            return error if [number, other_number].any? { |value| (-Float::INFINITY..-1).cover?(value) }

            success(sum: number + other_number, operator: "+")
          end

          def self.name
            "AddNumbersService"
          end
        end
      end

      let(:concat_strings_service) do
        Class.new do
          include ConvenientService::Standard::Config

          attr_reader :string, :other_string

          def initialize(string:, other_string:)
            @string = string
            @other_string = other_string
          end

          def result
            return error if [string, other_string].any? { |value| (-Float::INFINITY..-1).cover?(value.to_i) }

            success(concatenation: string.concat(other_string), operator: "concat")
          end

          def self.name
            "ConcatStringsService"
          end
        end
      end

      let(:condition) do
        proc do |status|
          case status
          when :success then true
          when :failure then false
          when :error then raise
          when :exception then raise
          else
            raise
          end
        end
      end

      def enumerable(collection)
        enumerable_class.new(collection)
      end

      def enumerator(collection)
        collection.each
      end

      def lazy_enumerator(collection)
        collection.lazy
      end

      def chain_enumerator(collection)
        collection.chain
      end

      def set(collection)
        Set.new(collection)
      end

      def step(...)
        service.step(...)
      end

      # def sorted_set(collection)
      #   SortedSet.new(collection)
      # end

      describe "#each" do
        specify do
          # NOTE: Empty collection.
          expect([].each { |status| condition[status] }).to eq([])
          expect(service.collection(enumerable([])).each { |status| condition[status] }.result).to be_success.with_data(values: [])
          expect(service.collection(enumerator([])).each { |status| condition[status] }.result).to be_success.with_data(values: [])
          expect(service.collection(lazy_enumerator([])).each { |status| condition[status] }.result).to be_success.with_data(values: [])
          expect(service.collection(chain_enumerator([])).each { |status| condition[status] }.result).to be_success.with_data(values: [])
          expect(service.collection([]).each { |status| condition[status] }.result).to be_success.with_data(values: [])
          expect(service.collection(set([])).each { |status| condition[status] }.result).to be_success.with_data(values: set([]))
          expect(service.collection({}).each { |status| condition[status] }.result).to be_success.with_data(values: {})
          expect(service.collection((:success...:success)).each { |status| condition[status] }.result).to be_success.with_data(values: (:success...:success))

          # NOTE: No block.
          expect([0, 1, 2, 3, 4, 5].each.to_a).to eq([0, 1, 2, 3, 4, 5])
          expect(service.collection(enumerable([0, 1, 2, 3, 4, 5])).each.result).to be_success.with_data(values: [0, 1, 2, 3, 4, 5])
          expect(service.collection(enumerator([0, 1, 2, 3, 4, 5])).each.result).to be_success.with_data(values: [0, 1, 2, 3, 4, 5])
          expect(lazy_enumerator([0, 1, 2, 3, 4, 5]).each.to_a).to eq([0, 1, 2, 3, 4, 5])
          expect(service.collection(lazy_enumerator([0, 1, 2, 3, 4, 5])).each.result).to be_success.with_data(values: [0, 1, 2, 3, 4, 5])
          expect(service.collection(chain_enumerator([0, 1, 2, 3, 4, 5])).each.result).to be_success.with_data(values: [0, 1, 2, 3, 4, 5])
          expect(service.collection([0, 1, 2, 3, 4, 5]).each.result).to be_success.with_data(values: [0, 1, 2, 3, 4, 5])

          # NOTE: Block.
          expect([0, 1, 2, 3, 4, 5].each { |number| number.to_s.ord }).to eq([0, 1, 2, 3, 4, 5])
          expect(service.collection(enumerable([0, 1, 2, 3, 4, 5])).each { |number| number.to_s.ord }.result).to be_success.with_data(values: [0, 1, 2, 3, 4, 5])
          expect(service.collection(enumerator([0, 1, 2, 3, 4, 5])).each { |number| number.to_s.ord }.result).to be_success.with_data(values: [0, 1, 2, 3, 4, 5])
          expect(service.collection(lazy_enumerator([0, 1, 2, 3, 4, 5])).each { |number| number.to_s.ord }.result).to be_success.with_data(values: [0, 1, 2, 3, 4, 5])
          expect(service.collection(chain_enumerator([0, 1, 2, 3, 4, 5])).each { |number| number.to_s.ord }.result).to be_success.with_data(values: [0, 1, 2, 3, 4, 5])
          expect(service.collection([0, 1, 2, 3, 4, 5]).each { |number| number.to_s.ord }.result).to be_success.with_data(values: [0, 1, 2, 3, 4, 5])

          expect(service.collection(set([0, 1, 2, 3, 4, 5])).each { |number| number.to_s.ord }.result).to be_success.with_data(values: set([0, 1, 2, 3, 4, 5]))
          expect({0 => 0, 1 => 1, 2 => 2, 3 => 3, 4 => 4, 5 => 5}.each { |key, value| value.to_s.ord }.to_h).to eq({0 => 0, 1 => 1, 2 => 2, 3 => 3, 4 => 4, 5 => 5})
          expect(service.collection({0 => 0, 1 => 1, 2 => 2, 3 => 3, 4 => 4, 5 => 5}).each { |key, value| value.to_s.ord }.result).to be_success.with_data(values: {0 => 0, 1 => 1, 2 => 2, 3 => 3, 4 => 4, 5 => 5})
          expect(service.collection((0..5)).each { |number| number.to_s.ord }.result).to be_success.with_data(values: (0..5))

          # NOTE: Step with no outputs.
          expect(service.collection(enumerable([:success, :success, :success])).each { |status| step status_service, in: [status: -> { status }] }.result).to be_success.with_data(values: [:success, :success, :success])
          expect(service.collection(enumerator([:success, :success, :success])).each { |status| step status_service, in: [status: -> { status }] }.result).to be_success.with_data(values: [:success, :success, :success])
          expect(service.collection(lazy_enumerator([:success, :success, :success])).each { |status| step status_service, in: [status: -> { status }] }.result).to be_success.with_data(values: [:success, :success, :success])
          expect(service.collection(chain_enumerator([:success, :success, :success])).each { |status| step status_service, in: [status: -> { status }] }.result).to be_success.with_data(values: [:success, :success, :success])
          expect(service.collection([:success, :success, :success]).each { |status| step status_service, in: [status: -> { status }] }.result).to be_success.with_data(values: [:success, :success, :success])

          expect(service.collection(set([:success])).each { |status| step status_service, in: [status: -> { status }] }.result).to be_success.with_data(values: set([:success]))
          expect(service.collection({success: :success}).each { |key, value| step status_service, in: [status: -> { value }] }.result).to be_success.with_data(values: {success: :success})
          expect(service.collection((:success..:success)).each { |status| step status_service, in: [status: -> { status }] }.result).to be_success.with_data(values: (:success..:success))

          # NOTE: Step with one output.
          expect(service.collection(enumerable([:success, :success, :success])).each { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(values: [:success, :success, :success])
          expect(service.collection(enumerator([:success, :success, :success])).each { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(values: [:success, :success, :success])
          expect(service.collection(lazy_enumerator([:success, :success, :success])).each { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(values: [:success, :success, :success])
          expect(service.collection(chain_enumerator([:success, :success, :success])).each { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(values: [:success, :success, :success])
          expect(service.collection([:success, :success, :success]).each { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(values: [:success, :success, :success])

          expect(service.collection(set([:success])).each { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(values: set([:success]))
          expect(service.collection({success: :success}).each { |key, value| step status_service, in: [status: -> { value }], out: :status_string }.result).to be_success.with_data(values: {success: :success})
          expect(service.collection((:success..:success)).each { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(values: (:success..:success))

          # NOTE: Step with multiple outputs.
          expect(service.collection(enumerable([:success, :success, :success])).each { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [:success, :success, :success])
          expect(service.collection(enumerator([:success, :success, :success])).each { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [:success, :success, :success])
          expect(service.collection(lazy_enumerator([:success, :success, :success])).each { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [:success, :success, :success])
          expect(service.collection(chain_enumerator([:success, :success, :success])).each { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [:success, :success, :success])
          expect(service.collection([:success, :success, :success]).each { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [:success, :success, :success])

          expect(service.collection(set([:success])).each { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: set([:success]))
          expect(service.collection({success: :success}).each { |key, value| step status_service, in: [status: -> { value }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: {success: :success})
          expect(service.collection((:success..:success)).each { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: (:success..:success))

          # NOTE: Error result.
          expect(service.collection(enumerable([:success, :error, :exception])).each { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection(enumerator([:success, :error, :exception])).each { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection(lazy_enumerator([:success, :error, :exception])).each { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection(chain_enumerator([:success, :error, :exception])).each { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection([:success, :error, :exception]).each { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data

          expect(service.collection(set([:success, :error, :exception])).each { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection({success: :success, error: :error, exception: :exception}).each { |key, value| step status_service, in: [status: -> { value }] }.result).to be_error.without_data
          expect(service.collection((:error..:error)).each { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data

          # NOTE: Error propagation.
          expect(service.collection(enumerable([:success, :error, :exception])).filter { |status| step status_service, in: [status: -> { status }] }.each { |status| condition[status] }.result).to be_error.without_data
          expect(service.collection(enumerator([:success, :error, :exception])).filter { |status| step status_service, in: [status: -> { status }] }.each { |status| condition[status] }.result).to be_error.without_data
          expect(service.collection(lazy_enumerator([:success, :error, :exception])).filter { |status| step status_service, in: [status: -> { status }] }.each { |status| condition[status] }.result).to be_error.without_data
          expect(service.collection(chain_enumerator([:success, :error, :exception])).filter { |status| step status_service, in: [status: -> { status }] }.each { |status| condition[status] }.result).to be_error.without_data
          expect(service.collection([:success, :error, :exception]).filter { |status| step status_service, in: [status: -> { status }] }.each { |status| condition[status] }.result).to be_error.without_data

          expect(service.collection(set([:success, :error, :exception])).filter { |status| step status_service, in: [status: -> { status }] }.each { |status| condition[status] }.result).to be_error.without_data
          expect(service.collection({success: :success, error: :error, exception: :exception}).filter { |key, value| step status_service, in: [status: -> { value }] }.each { |key, value| condition[value] }.result).to be_error.without_data
          expect(service.collection((:error..:error)).filter { |status| step status_service, in: [status: -> { status }] }.each { |status| condition[status] }.result).to be_error.without_data

          # NOTE: Usage on terminal chaining.
          expect { service.collection(enumerable([:success, :exception, :exception])).first.each { |status| condition[status] }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection(enumerator([:success, :exception, :exception])).first.each { |status| condition[status] }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection(lazy_enumerator([:success, :exception, :exception])).first.each { |status| condition[status] }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection(chain_enumerator([:success, :exception, :exception])).first.each { |status| condition[status] }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection([:success, :exception, :exception]).first.each { |status| condition[status] }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)

          expect { service.collection(set([:success, :exception, :exception])).first.each { |status| condition[status] }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection({success: :success, exception: :exception}).first.each { |key, value| condition[value] }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection((:success..:success)).first.each { |status| condition[status] }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
        end
      end

      describe "#all?" do
        specify do
          # NOTE: Empty collection.
          expect([].all?).to eq(true)
          expect(service.collection(enumerable([])).all?.result).to be_success.without_data
          expect(service.collection(enumerator([])).all?.result).to be_success.without_data
          expect(service.collection(lazy_enumerator([])).all?.result).to be_success.without_data
          expect(service.collection(chain_enumerator([])).all?.result).to be_success.without_data
          expect(service.collection([]).all?.result).to be_success.without_data
          expect(service.collection({}).all?.result).to be_success.without_data
          expect(service.collection((:success...:success)).all?.result).to be_success.without_data
          expect(service.collection(set([])).all?.result).to be_success.without_data

          # NOTE: No block, no pattern.
          expect([:success].all?).to eq(true)
          expect(service.collection(enumerable([:success])).all?.result).to be_success.without_data
          expect(service.collection(enumerator([:success])).all?.result).to be_success.without_data
          expect(service.collection(lazy_enumerator([:success])).all?.result).to be_success.without_data
          expect(service.collection(chain_enumerator([:success])).all?.result).to be_success.without_data
          expect(service.collection([:success]).all?.result).to be_success.without_data
          expect(service.collection(set([:success])).all?.result).to be_success.without_data
          expect(service.collection({success: :success}).all?.result).to be_success.without_data
          expect(service.collection((:success..:success)).all?.result).to be_success.without_data

          # NOTE: Matched pattern.
          expect([:success, :success, :success].all?(/success/)).to eq(true)
          expect(service.collection(enumerable([:success, :success, :success])).all?(/success/).result).to be_success.without_data
          expect(service.collection(enumerator([:success, :success, :success])).all?(/success/).result).to be_success.without_data
          expect(service.collection(lazy_enumerator([:success, :success, :success])).all?(/success/).result).to be_success.without_data
          expect(service.collection(chain_enumerator([:success, :success, :success])).all?(/success/).result).to be_success.without_data
          expect(service.collection([:success, :success, :success]).all?(/success/).result).to be_success.without_data
          expect(service.collection(set([:success, :success, :success])).all?(/success/).result).to be_success.without_data

          expect(service.collection({success: :success}).all?([:success, :success]).result).to be_success.without_data
          expect(service.collection((:success..:success)).all?(/success/).result).to be_success.without_data

          # NOTE: Not matched pattern.
          expect([:success, :failure, :exception].all?(/success/)).to eq(false)
          expect(service.collection(enumerable([:success, :failure, :exception])).all?(/success/).result).to be_failure.without_data
          expect(service.collection(enumerator([:success, :failure, :exception])).all?(/success/).result).to be_failure.without_data
          expect(service.collection(lazy_enumerator([:success, :failure, :exception])).all?(/success/).result).to be_failure.without_data
          expect(service.collection(chain_enumerator([:success, :failure, :exception])).all?(/success/).result).to be_failure.without_data
          expect(service.collection([:success, :failure, :exception]).all?(/success/).result).to be_failure.without_data
          expect(service.collection(set([:success, :failure, :exception])).all?(/success/).result).to be_failure.without_data

          expect(service.collection({failure: :failure}).all?([:success, :success]).result).to be_failure.without_data
          expect(service.collection((:failure..:failure)).all?(/success/).result).to be_failure.without_data

          # NOTE: Matched block.
          expect([:success, :success, :success].all? { |status| condition[status] }).to eq(true)
          expect(service.collection(enumerable([:success, :success, :success])).all? { |status| condition[status] }.result).to be_success.without_data
          expect(service.collection(enumerator([:success, :success, :success])).all? { |status| condition[status] }.result).to be_success.without_data
          expect(service.collection(lazy_enumerator([:success, :success, :success])).all? { |status| condition[status] }.result).to be_success.without_data
          expect(service.collection(chain_enumerator([:success, :success, :success])).all? { |status| condition[status] }.result).to be_success.without_data
          expect(service.collection([:success, :success, :success]).all? { |status| condition[status] }.result).to be_success.without_data
          expect(service.collection(set([:success, :success, :success])).all? { |status| condition[status] }.result).to be_success.without_data

          expect(service.collection({success: :success}).all? { |key, value| condition[value] }.result).to be_success.without_data
          expect(service.collection((:success..:success)).all? { |status| condition[status] }.result).to be_success.without_data

          # NOTE: Not matched block.
          expect([:success, :failure, :exception].all? { |status| condition[status] }).to eq(false)
          expect(service.collection(enumerable([:success, :failure, :exception])).all? { |status| condition[status] }.result).to be_failure.without_data
          expect(service.collection(enumerator([:success, :failure, :exception])).all? { |status| condition[status] }.result).to be_failure.without_data
          expect(service.collection(lazy_enumerator([:success, :failure, :exception])).all? { |status| condition[status] }.result).to be_failure.without_data
          expect(service.collection(chain_enumerator([:success, :failure, :exception])).all? { |status| condition[status] }.result).to be_failure.without_data
          expect(service.collection([:success, :failure, :exception]).all? { |status| condition[status] }.result).to be_failure.without_data
          expect(service.collection(set([:success, :failure, :exception])).all? { |status| condition[status] }.result).to be_failure.without_data

          expect(service.collection({success: :success, failure: :failure, exception: :exception}).all? { |key, value| condition[value] }.result).to be_failure.without_data
          expect(service.collection((:failure..:failure)).all? { |status| condition[status] }.result).to be_failure.without_data

          # NOTE: Matched step with no outputs.
          expect(service.collection(enumerable([:success, :success, :success])).all? { |status| step status_service, in: [status: -> { status }] }.result).to be_success.without_data
          expect(service.collection(enumerator([:success, :success, :success])).all? { |status| step status_service, in: [status: -> { status }] }.result).to be_success.without_data
          expect(service.collection(lazy_enumerator([:success, :success, :success])).all? { |status| step status_service, in: [status: -> { status }] }.result).to be_success.without_data
          expect(service.collection(chain_enumerator([:success, :success, :success])).all? { |status| step status_service, in: [status: -> { status }] }.result).to be_success.without_data
          expect(service.collection([:success, :success, :success]).all? { |status| step status_service, in: [status: -> { status }] }.result).to be_success.without_data
          expect(service.collection(set([:success, :success, :success])).all? { |status| step status_service, in: [status: -> { status }] }.result).to be_success.without_data

          expect(service.collection({success: :success}).all? { |key, value| step status_service, in: [status: -> { value }] }.result).to be_success.without_data
          expect(service.collection((:success..:success)).all? { |status| step status_service, in: [status: -> { status }] }.result).to be_success.without_data

          # NOTE: Not matched step with no outputs.
          expect(service.collection(enumerable([:success, :failure, :exception])).all? { |status| step status_service, in: [status: -> { status }] }.result).to be_failure.without_data
          expect(service.collection(enumerator([:success, :failure, :exception])).all? { |status| step status_service, in: [status: -> { status }] }.result).to be_failure.without_data
          expect(service.collection(lazy_enumerator([:success, :failure, :exception])).all? { |status| step status_service, in: [status: -> { status }] }.result).to be_failure.without_data
          expect(service.collection(chain_enumerator([:success, :failure, :exception])).all? { |status| step status_service, in: [status: -> { status }] }.result).to be_failure.without_data
          expect(service.collection([:success, :failure, :exception]).all? { |status| step status_service, in: [status: -> { status }] }.result).to be_failure.without_data
          expect(service.collection(set([:success, :failure, :exception])).all? { |status| step status_service, in: [status: -> { status }] }.result).to be_failure.without_data

          expect(service.collection({success: :success, failure: :failure, exception: :exception}).all? { |key, value| step status_service, in: [status: -> { value }] }.result).to be_failure.without_data
          expect(service.collection((:failure..:failure)).all? { |status| step status_service, in: [status: -> { status }] }.result).to be_failure.without_data

          # NOTE: Matched step with one output.
          expect(service.collection(enumerable([:success, :success, :success])).all? { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.without_data
          expect(service.collection(enumerator([:success, :success, :success])).all? { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.without_data
          expect(service.collection(lazy_enumerator([:success, :success, :success])).all? { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.without_data
          expect(service.collection(chain_enumerator([:success, :success, :success])).all? { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.without_data
          expect(service.collection([:success, :success, :success]).all? { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.without_data
          expect(service.collection(set([:success, :success, :success])).all? { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.without_data

          expect(service.collection({success: :success}).all? { |key, value| step status_service, in: [status: -> { value }], out: :status_string }.result).to be_success.without_data
          expect(service.collection((:success..:success)).all? { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.without_data

          # NOTE: Not matched step with one output.
          expect(service.collection(enumerable([:success, :failure, :exception])).all? { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_failure.without_data
          expect(service.collection(enumerator([:success, :failure, :exception])).all? { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_failure.without_data
          expect(service.collection(lazy_enumerator([:success, :failure, :exception])).all? { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_failure.without_data
          expect(service.collection(chain_enumerator([:success, :failure, :exception])).all? { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_failure.without_data
          expect(service.collection([:success, :failure, :exception]).all? { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_failure.without_data
          expect(service.collection(set([:success, :failure, :exception])).all? { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_failure.without_data

          expect(service.collection({success: :success, failure: :failure, exception: :exception}).all? { |key, value| step status_service, in: [status: -> { value }], out: :status_string }.result).to be_failure.without_data
          expect(service.collection((:failure..:failure)).all? { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_failure.without_data

          # NOTE: Matched step with multiple outputs.
          expect(service.collection(enumerable([:success, :success, :success])).all? { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.without_data
          expect(service.collection(enumerator([:success, :success, :success])).all? { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.without_data
          expect(service.collection(lazy_enumerator([:success, :success, :success])).all? { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.without_data
          expect(service.collection(chain_enumerator([:success, :success, :success])).all? { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.without_data
          expect(service.collection([:success, :success, :success]).all? { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.without_data
          expect(service.collection(set([:success, :success, :success])).all? { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.without_data

          expect(service.collection({success: :success}).all? { |key, value| step status_service, in: [status: -> { value }], out: [:status_string, :status_code] }.result).to be_success.without_data
          expect(service.collection((:success..:success)).all? { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.without_data

          # NOTE: Not matched step with multiple outputs.
          expect(service.collection(enumerable([:success, :failure, :exception])).all? { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_failure.without_data
          expect(service.collection(enumerator([:success, :failure, :exception])).all? { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_failure.without_data
          expect(service.collection(lazy_enumerator([:success, :failure, :exception])).all? { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_failure.without_data
          expect(service.collection(chain_enumerator([:success, :failure, :exception])).all? { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_failure.without_data
          expect(service.collection([:success, :failure, :exception]).all? { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_failure.without_data
          expect(service.collection(set([:success, :failure, :exception])).all? { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_failure.without_data

          expect(service.collection({success: :success, failure: :failure, exception: :exception}).all? { |key, value| step status_service, in: [status: -> { value }], out: [:status_string, :status_code] }.result).to be_failure.without_data
          expect(service.collection((:failure..:failure)).all? { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_failure.without_data

          # NOTE: Error result.
          expect(service.collection(enumerable([:success, :error, :exception])).all? { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection(enumerator([:success, :error, :exception])).all? { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection(lazy_enumerator([:success, :error, :exception])).all? { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection(chain_enumerator([:success, :error, :exception])).all? { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection([:success, :error, :exception]).all? { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection(set([:success, :error, :exception])).all? { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data

          expect(service.collection({success: :success, error: :error, exception: :exception}).all? { |key, value| step status_service, in: [status: -> { value }] }.result).to be_error.without_data
          expect(service.collection((:error..:error)).all? { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data

          # NOTE: Error propagation.
          expect(service.collection(enumerable([:success, :error, :exception])).select { |status| step status_service, in: [status: -> { status }] }.all?.result).to be_error.without_data
          expect(service.collection(enumerator([:success, :error, :exception])).select { |status| step status_service, in: [status: -> { status }] }.all?.result).to be_error.without_data
          expect(service.collection(lazy_enumerator([:success, :error, :exception])).select { |status| step status_service, in: [status: -> { status }] }.all?.result).to be_error.without_data
          expect(service.collection(chain_enumerator([:success, :error, :exception])).select { |status| step status_service, in: [status: -> { status }] }.all?.result).to be_error.without_data
          expect(service.collection([:success, :error, :exception]).select { |status| step status_service, in: [status: -> { status }] }.all?.result).to be_error.without_data
          expect(service.collection(set([:success, :error, :exception])).select { |status| step status_service, in: [status: -> { status }] }.all?.result).to be_error.without_data

          expect(service.collection({success: :success, error: :error, exception: :exception}).select { |key, value| step status_service, in: [status: -> { value }] }.all?.result).to be_error.without_data
          expect(service.collection((:error..:error)).select { |status| step status_service, in: [status: -> { status }] }.all?.result).to be_error.without_data

          # NOTE: Usage on terminal chaining.
          expect { service.collection(enumerable([:success, :exception, :exception])).first.all?.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection(enumerator([:success, :exception, :exception])).first.all?.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection(lazy_enumerator([:success, :exception, :exception])).first.all?.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection(chain_enumerator([:success, :exception, :exception])).first.all?.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection([:success, :exception, :exception]).first.all?.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection(set([:success, :exception, :exception])).first.all?.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)

          expect { service.collection({success: :success, exception: :exception}).first.all?.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection((:success..:success)).first.all?.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
        end
      end

      describe "#any?" do
        specify do
          # NOTE: Empty collection.
          expect([].any?).to eq(false)
          expect(service.collection(enumerable([])).any?.result).to be_failure.without_data
          expect(service.collection(enumerator([])).any?.result).to be_failure.without_data
          expect(service.collection(lazy_enumerator([])).any?.result).to be_failure.without_data
          expect(service.collection(chain_enumerator([])).any?.result).to be_failure.without_data
          expect(service.collection([]).any?.result).to be_failure.without_data
          expect(service.collection({}).any?.result).to be_failure.without_data
          expect(service.collection((:success...:success)).any?.result).to be_failure.without_data
          expect(service.collection(set([])).any?.result).to be_failure.without_data

          # NOTE: No block, no pattern.
          expect([:success].any?).to eq(true)
          expect(service.collection(enumerable([:success])).any?.result).to be_success.without_data
          expect(service.collection(enumerator([:success])).any?.result).to be_success.without_data
          expect(service.collection(lazy_enumerator([:success])).any?.result).to be_success.without_data
          expect(service.collection(chain_enumerator([:success])).any?.result).to be_success.without_data
          expect(service.collection([:success]).any?.result).to be_success.without_data
          expect(service.collection(set([:success])).any?.result).to be_success.without_data
          expect(service.collection({success: :success}).any?.result).to be_success.without_data
          expect(service.collection((:success..:success)).any?.result).to be_success.without_data

          # NOTE: Matched pattern.
          expect([:success, :failure, :exception].any?(/success/)).to eq(true)
          expect(service.collection(enumerable([:success, :failure, :exception])).any?(/success/).result).to be_success.without_data
          expect(service.collection(enumerator([:success, :failure, :exception])).any?(/success/).result).to be_success.without_data
          expect(service.collection(lazy_enumerator([:success, :failure, :exception])).any?(/success/).result).to be_success.without_data
          expect(service.collection(chain_enumerator([:success, :failure, :exception])).any?(/success/).result).to be_success.without_data
          expect(service.collection([:success, :failure, :exception]).any?(/success/).result).to be_success.without_data
          expect(service.collection(set([:success, :failure, :exception])).any?(/success/).result).to be_success.without_data

          expect(service.collection({failure: :failure, success: :success, exception: :exception}).any?([:success, :success]).result).to be_success.without_data
          expect(service.collection((:success..:success)).any?(/success/).result).to be_success.without_data

          # NOTE: Not matched pattern.
          expect([:failure, :failure, :failure].any?(/success/)).to eq(false)
          expect(service.collection(enumerable([:failure, :failure, :failure])).any?(/success/).result).to be_failure.without_data
          expect(service.collection(enumerator([:failure, :failure, :failure])).any?(/success/).result).to be_failure.without_data
          expect(service.collection(lazy_enumerator([:failure, :failure, :failure])).any?(/success/).result).to be_failure.without_data
          expect(service.collection(chain_enumerator([:failure, :failure, :failure])).any?(/success/).result).to be_failure.without_data
          expect(service.collection([:failure, :failure, :failure]).any?(/success/).result).to be_failure.without_data
          expect(service.collection(set([:failure, :failure, :failure])).any?(/success/).result).to be_failure.without_data

          expect(service.collection({failure: :failure}).any?([:success, :success]).result).to be_failure.without_data
          expect(service.collection((:failure..:failure)).any?(/success/).result).to be_failure.without_data

          # NOTE: Matched block.
          expect([:failure, :success, :exception].any? { |status| condition[status] }).to eq(true)
          expect(service.collection(enumerable([:failure, :success, :exception])).any? { |status| condition[status] }.result).to be_success.without_data
          expect(service.collection(enumerator([:failure, :success, :exception])).any? { |status| condition[status] }.result).to be_success.without_data
          expect(service.collection(lazy_enumerator([:failure, :success, :exception])).any? { |status| condition[status] }.result).to be_success.without_data
          expect(service.collection(chain_enumerator([:failure, :success, :exception])).any? { |status| condition[status] }.result).to be_success.without_data
          expect(service.collection([:failure, :success, :exception]).any? { |status| condition[status] }.result).to be_success.without_data
          expect(service.collection(set([:failure, :success, :exception])).any? { |status| condition[status] }.result).to be_success.without_data

          expect(service.collection({failure: :failure, success: :success, exception: :exception}).any? { |key, value| condition[value] }.result).to be_success.without_data
          expect(service.collection((:success..:success)).any? { |status| condition[status] }.result).to be_success.without_data

          # NOTE: Not matched block.
          expect([:failure, :failure, :failure].any? { |status| condition[status] }).to eq(false)
          expect(service.collection(enumerable([:failure, :failure, :failure])).any? { |status| condition[status] }.result).to be_failure.without_data
          expect(service.collection(enumerator([:failure, :failure, :failure])).any? { |status| condition[status] }.result).to be_failure.without_data
          expect(service.collection(lazy_enumerator([:failure, :failure, :failure])).any? { |status| condition[status] }.result).to be_failure.without_data
          expect(service.collection(chain_enumerator([:failure, :failure, :failure])).any? { |status| condition[status] }.result).to be_failure.without_data
          expect(service.collection([:failure, :failure, :failure]).any? { |status| condition[status] }.result).to be_failure.without_data
          expect(service.collection(set([:failure, :failure, :failure])).any? { |status| condition[status] }.result).to be_failure.without_data

          expect(service.collection({failure: :failure}).any? { |key, value| condition[value] }.result).to be_failure.without_data
          expect(service.collection((:failure..:failure)).any? { |status| condition[status] }.result).to be_failure.without_data

          # NOTE: Matched step with no outputs.
          expect(service.collection(enumerable([:failure, :success, :exception])).any? { |status| step status_service, in: [status: -> { status }] }.result).to be_success.without_data
          expect(service.collection(enumerator([:failure, :success, :exception])).any? { |status| step status_service, in: [status: -> { status }] }.result).to be_success.without_data
          expect(service.collection(lazy_enumerator([:failure, :success, :exception])).any? { |status| step status_service, in: [status: -> { status }] }.result).to be_success.without_data
          expect(service.collection(chain_enumerator([:failure, :success, :exception])).any? { |status| step status_service, in: [status: -> { status }] }.result).to be_success.without_data
          expect(service.collection([:failure, :success, :exception]).any? { |status| step status_service, in: [status: -> { status }] }.result).to be_success.without_data
          expect(service.collection(set([:failure, :success, :exception])).any? { |status| step status_service, in: [status: -> { status }] }.result).to be_success.without_data

          expect(service.collection({failure: :failure, success: :success, exception: :exception}).any? { |key, value| step status_service, in: [status: -> { value }] }.result).to be_success.without_data
          expect(service.collection((:success..:success)).any? { |status| step status_service, in: [status: -> { status }] }.result).to be_success.without_data

          # NOTE: Not matched step with no outputs.
          expect(service.collection(enumerable([:failure, :failure, :failure])).any? { |status| step status_service, in: [status: -> { status }] }.result).to be_failure.without_data
          expect(service.collection(enumerator([:failure, :failure, :failure])).any? { |status| step status_service, in: [status: -> { status }] }.result).to be_failure.without_data
          expect(service.collection(lazy_enumerator([:failure, :failure, :failure])).any? { |status| step status_service, in: [status: -> { status }] }.result).to be_failure.without_data
          expect(service.collection(chain_enumerator([:failure, :failure, :failure])).any? { |status| step status_service, in: [status: -> { status }] }.result).to be_failure.without_data
          expect(service.collection([:failure, :failure, :failure]).any? { |status| step status_service, in: [status: -> { status }] }.result).to be_failure.without_data
          expect(service.collection(set([:failure, :failure, :failure])).any? { |status| step status_service, in: [status: -> { status }] }.result).to be_failure.without_data

          expect(service.collection({failure: :failure}).any? { |key, value| step status_service, in: [status: -> { value }] }.result).to be_failure.without_data
          expect(service.collection((:failure..:failure)).any? { |status| step status_service, in: [status: -> { status }] }.result).to be_failure.without_data

          # NOTE: Matched step with one output.
          expect(service.collection(enumerable([:failure, :success, :exception])).any? { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.without_data
          expect(service.collection(enumerator([:failure, :success, :exception])).any? { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.without_data
          expect(service.collection(lazy_enumerator([:failure, :success, :exception])).any? { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.without_data
          expect(service.collection(chain_enumerator([:failure, :success, :exception])).any? { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.without_data
          expect(service.collection([:failure, :success, :exception]).any? { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.without_data
          expect(service.collection(set([:failure, :success, :exception])).any? { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.without_data

          expect(service.collection({failure: :failure, success: :success, exception: :exception}).any? { |key, value| step status_service, in: [status: -> { value }], out: :status_string }.result).to be_success.without_data
          expect(service.collection((:success..:success)).any? { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.without_data

          # NOTE: Not matched step with one output.
          expect(service.collection(enumerable([:failure, :failure, :failure])).any? { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_failure.without_data
          expect(service.collection(enumerator([:failure, :failure, :failure])).any? { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_failure.without_data
          expect(service.collection(lazy_enumerator([:failure, :failure, :failure])).any? { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_failure.without_data
          expect(service.collection(chain_enumerator([:failure, :failure, :failure])).any? { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_failure.without_data
          expect(service.collection([:failure, :failure, :failure]).any? { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_failure.without_data
          expect(service.collection(set([:failure, :failure, :failure])).any? { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_failure.without_data

          expect(service.collection({failure: :failure}).any? { |key, value| step status_service, in: [status: -> { value }], out: :status_string }.result).to be_failure.without_data
          expect(service.collection((:failure..:failure)).any? { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_failure.without_data

          # NOTE: Matched step with multiple outputs.
          expect(service.collection(enumerable([:failure, :success, :exception])).any? { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.without_data
          expect(service.collection(enumerator([:failure, :success, :exception])).any? { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.without_data
          expect(service.collection(lazy_enumerator([:failure, :success, :exception])).any? { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.without_data
          expect(service.collection(chain_enumerator([:failure, :success, :exception])).any? { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.without_data
          expect(service.collection([:failure, :success, :exception]).any? { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.without_data
          expect(service.collection(set([:failure, :success, :exception])).any? { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.without_data

          expect(service.collection({failure: :failure, success: :success, exception: :exception}).any? { |key, value| step status_service, in: [status: -> { value }], out: [:status_string, :status_code] }.result).to be_success.without_data
          expect(service.collection((:success..:success)).any? { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.without_data

          # NOTE: Not matched step with multiple outputs.
          expect(service.collection(enumerable([:failure, :failure, :failure])).any? { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_failure.without_data
          expect(service.collection(enumerator([:failure, :failure, :failure])).any? { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_failure.without_data
          expect(service.collection(lazy_enumerator([:failure, :failure, :failure])).any? { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_failure.without_data
          expect(service.collection(chain_enumerator([:failure, :failure, :failure])).any? { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_failure.without_data
          expect(service.collection([:failure, :failure, :failure]).any? { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_failure.without_data
          expect(service.collection(set([:failure, :failure, :failure])).any? { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_failure.without_data

          expect(service.collection({failure: :failure}).any? { |key, value| step status_service, in: [status: -> { value }], out: [:status_string, :status_code] }.result).to be_failure.without_data
          expect(service.collection((:failure..:failure)).any? { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_failure.without_data

          # NOTE: Error result.
          expect(service.collection(enumerable([:failure, :error, :exception])).any? { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection(enumerator([:failure, :error, :exception])).any? { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection(lazy_enumerator([:failure, :error, :exception])).any? { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection(chain_enumerator([:failure, :error, :exception])).any? { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection([:failure, :error, :exception]).any? { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection(set([:failure, :error, :exception])).any? { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data

          expect(service.collection({failure: :failure, error: :error, exception: :exception}).any? { |key, value| step status_service, in: [status: -> { value }] }.result).to be_error.without_data
          expect(service.collection((:error..:error)).any? { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data

          # NOTE: Error propagation.
          expect(service.collection(enumerable([:failure, :error, :exception])).select { |status| step status_service, in: [status: -> { status }] }.any?.result).to be_error.without_data
          expect(service.collection(enumerator([:failure, :error, :exception])).select { |status| step status_service, in: [status: -> { status }] }.any?.result).to be_error.without_data
          expect(service.collection(lazy_enumerator([:failure, :error, :exception])).select { |status| step status_service, in: [status: -> { status }] }.any?.result).to be_error.without_data
          expect(service.collection(chain_enumerator([:failure, :error, :exception])).select { |status| step status_service, in: [status: -> { status }] }.any?.result).to be_error.without_data
          expect(service.collection([:failure, :error, :exception]).select { |status| step status_service, in: [status: -> { status }] }.any?.result).to be_error.without_data
          expect(service.collection(set([:failure, :error, :exception])).select { |status| step status_service, in: [status: -> { status }] }.any?.result).to be_error.without_data

          expect(service.collection({failure: :failure, error: :error, exception: :exception}).select { |key, value| step status_service, in: [status: -> { value }] }.any?.result).to be_error.without_data
          expect(service.collection((:error..:error)).select { |status| step status_service, in: [status: -> { status }] }.any?.result).to be_error.without_data

          # NOTE: Usage on terminal chaining.
          expect { service.collection(enumerable([:success, :exception, :exception])).first.any?.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection(enumerator([:success, :exception, :exception])).first.any?.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection(lazy_enumerator([:success, :exception, :exception])).first.any?.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection(chain_enumerator([:success, :exception, :exception])).first.any?.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection([:success, :exception, :exception]).first.any?.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection(set([:success, :exception, :exception])).first.any?.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)

          expect { service.collection({success: :success, exception: :exception}).first.any?.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection((:success..:success)).first.any?.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
        end
      end

      describe "#chain" do
        specify do
          # NOTE: Empty collection.
          expect([].chain([2]).to_a).to eq([2])
          expect(service.collection(enumerable([])).chain([2]).result).to be_success.with_data(values: [2])
          expect(service.collection(enumerator([])).chain([2]).result).to be_success.with_data(values: [2])
          expect(service.collection(lazy_enumerator([])).chain([2]).result).to be_success.with_data(values: [2])
          expect(service.collection(chain_enumerator([])).chain([2]).result).to be_success.with_data(values: [2])
          expect(service.collection([]).chain([2]).result).to be_success.with_data(values: [2])
          expect(service.collection(set([])).chain([2]).result).to be_success.with_data(values: [2])
          expect(service.collection({}).chain([2]).result).to be_success.with_data(values: [2])
          expect(service.collection((1...1)).chain([2]).result).to be_success.with_data(values: [2])

          # No argument.
          expect([1].chain.to_a).to eq([1])
          expect(service.collection(enumerable([1])).chain.result).to be_success.with_data(values: [1])
          expect(service.collection(enumerator([1])).chain.result).to be_success.with_data(values: [1])
          expect(service.collection(lazy_enumerator([1])).chain.result).to be_success.with_data(values: [1])
          expect(service.collection(chain_enumerator([1])).chain.result).to be_success.with_data(values: [1])
          expect(service.collection([1]).chain.result).to be_success.with_data(values: [1])
          expect(service.collection(set([1])).chain.result).to be_success.with_data(values: [1])
          expect({1 => 1}.chain.to_a).to eq([[1, 1]])
          expect(service.collection({1 => 1}).chain.result).to be_success.with_data(values: [[1, 1]])
          expect(service.collection((1..1)).chain.result).to be_success.with_data(values: [1])

          # One argument.
          expect([1].chain([2]).to_a).to eq([1, 2])
          expect(service.collection(enumerable([1])).chain([2]).result).to be_success.with_data(values: [1, 2])
          expect(service.collection(enumerator([1])).chain([2]).result).to be_success.with_data(values: [1, 2])
          expect(service.collection(lazy_enumerator([1])).chain([2]).result).to be_success.with_data(values: [1, 2])
          expect(service.collection(chain_enumerator([1])).chain([2]).result).to be_success.with_data(values: [1, 2])
          expect(service.collection([1]).chain([2]).result).to be_success.with_data(values: [1, 2])
          expect(service.collection(set([1])).chain([2]).result).to be_success.with_data(values: [1, 2])
          expect({1 => 1}.chain([2]).to_a).to eq([[1, 1], 2])
          expect({1 => 1}.chain({2 => 2}).to_a).to eq([[1, 1], [2, 2]])
          expect(service.collection({1 => 1}).chain([2]).result).to be_success.with_data(values: [[1, 1], 2])
          expect(service.collection({1 => 1}).chain({2 => 2}).result).to be_success.with_data(values: [[1, 1], [2, 2]])
          expect(service.collection((1..1)).chain([2]).result).to be_success.with_data(values: [1, 2])

          # Multiple arguments.
          expect([1].chain([2], [3]).to_a).to eq([1, 2, 3])
          expect(service.collection(enumerable([1])).chain([2], [3]).result).to be_success.with_data(values: [1, 2, 3])
          expect(service.collection(enumerator([1])).chain([2], [3]).result).to be_success.with_data(values: [1, 2, 3])
          expect(service.collection(lazy_enumerator([1])).chain([2], [3]).result).to be_success.with_data(values: [1, 2, 3])
          expect(service.collection(chain_enumerator([1])).chain([2], [3]).result).to be_success.with_data(values: [1, 2, 3])
          expect(service.collection([1]).chain([2], [3]).result).to be_success.with_data(values: [1, 2, 3])
          expect(service.collection(set([1])).chain([2], [3]).result).to be_success.with_data(values: [1, 2, 3])
          expect({1 => 1}.chain([2], [3]).to_a).to eq([[1, 1], 2, 3])
          expect({1 => 1}.chain({2 => 2}, {3 => 3}).to_a).to eq([[1, 1], [2, 2], [3, 3]])
          expect(service.collection({1 => 1}).chain([2], [3]).result).to be_success.with_data(values: [[1, 1], 2, 3])
          expect(service.collection({1 => 1}).chain({2 => 2}, {3 => 3}).result).to be_success.with_data(values: [[1, 1], [2, 2], [3, 3]])
          expect(service.collection((1..1)).chain([2], [3]).result).to be_success.with_data(values: [1, 2, 3])

          # NOTE: Error propagation.
          expect(service.collection(enumerable([:success, :error, :exception])).filter { |status| step status_service, in: [status: -> { status }] }.chain([2], [3]).result).to be_error.without_data
          expect(service.collection(enumerator([:success, :error, :exception])).filter { |status| step status_service, in: [status: -> { status }] }.chain([2], [3]).result).to be_error.without_data
          expect(service.collection(lazy_enumerator([:success, :error, :exception])).filter { |status| step status_service, in: [status: -> { status }] }.chain([2], [3]).result).to be_error.without_data
          expect(service.collection(chain_enumerator([:success, :error, :exception])).filter { |status| step status_service, in: [status: -> { status }] }.chain([2], [3]).result).to be_error.without_data
          expect(service.collection([:success, :error, :exception]).filter { |status| step status_service, in: [status: -> { status }] }.chain([2], [3]).result).to be_error.without_data

          expect(service.collection(set([:success, :error, :exception])).filter { |status| step status_service, in: [status: -> { status }] }.chain([2], [3]).result).to be_error.without_data
          expect(service.collection({success: :success, error: :error, exception: :exception}).filter { |key, value| step status_service, in: [status: -> { value }] }.chain([2], [3]).result).to be_error.without_data
          expect(service.collection((:error..:error)).filter { |status| step status_service, in: [status: -> { status }] }.chain([2], [3]).result).to be_error.without_data

          # NOTE: Usage on terminal chaining.
          expect { service.collection(enumerable([:success, :exception, :exception])).first.chain([2], [3]) }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection(enumerator([:success, :exception, :exception])).first.chain([2], [3]) }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection(lazy_enumerator([:success, :exception, :exception])).first.chain([2], [3]) }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection(chain_enumerator([:success, :exception, :exception])).first.chain([2], [3]) }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection([:success, :exception, :exception]).first.chain([2], [3]) }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)

          expect { service.collection(set([:success, :exception, :exception])).first.chain([2], [3]) }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection({success: :success, exception: :exception}).first.chain([2], [3]).result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection((:success..:success)).first.chain([2], [3]) }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
        end
      end

      describe "#chunk" do
        specify do
          # NOTE: Empty collection.
          expect([].chunk { |status| condition[status] }.to_a).to eq([])
          expect(service.collection(enumerable([])).chunk { |status| condition[status] }.result).to be_success.with_data(values: [])
          expect(service.collection(enumerator([])).chunk { |status| condition[status] }.result).to be_success.with_data(values: [])
          expect(service.collection(lazy_enumerator([])).chunk { |status| condition[status] }.result).to be_success.with_data(values: [])
          expect(service.collection(chain_enumerator([])).chunk { |status| condition[status] }.result).to be_success.with_data(values: [])
          expect(service.collection([]).chunk { |status| condition[status] }.result).to be_success.with_data(values: [])
          expect(service.collection(set([])).chunk { |status| condition[status] }.result).to be_success.with_data(values: [])
          expect(service.collection({}).chunk { |status| condition[status] }.result).to be_success.with_data(values: [])
          expect(service.collection((:success...:success)).chunk { |status| condition[status] }.result).to be_success.with_data(values: [])

          # NOTE: No block.
          expect([:success, :success, :success].chunk.to_a).to eq([])
          expect(service.collection(enumerable([:success, :success, :success])).chunk.result).to be_success.with_data(values: [])
          expect(service.collection(enumerator([:success, :success, :success])).chunk.result).to be_success.with_data(values: [])
          expect(service.collection(lazy_enumerator([:success, :success, :success])).chunk.result).to be_success.with_data(values: [])
          expect(service.collection(chain_enumerator([:success, :success, :success])).chunk.result).to be_success.with_data(values: [])
          expect(service.collection([:success, :success, :success]).chunk.result).to be_success.with_data(values: [])

          expect(service.collection(set([:success])).chunk.result).to be_success.with_data(values: [])
          expect(service.collection({success: :success}).chunk.result).to be_success.with_data(values: [])
          expect(service.collection((:success..:success)).chunk.result).to be_success.with_data(values: [])

          # NOTE: Block.
          expect([:success, :failure, :success, :failure].chunk { |status| condition[status] }.to_a).to eq([[true, [:success]], [false, [:failure]], [true, [:success]], [false, [:failure]]])
          expect(service.collection(enumerable([:success, :failure, :success, :failure])).chunk { |status| condition[status] }.result).to be_success.with_data(values: [[true, [:success]], [false, [:failure]], [true, [:success]], [false, [:failure]]])
          expect(service.collection(enumerator([:success, :failure, :success, :failure])).chunk { |status| condition[status] }.result).to be_success.with_data(values: [[true, [:success]], [false, [:failure]], [true, [:success]], [false, [:failure]]])
          expect(service.collection(lazy_enumerator([:success, :failure, :success, :failure])).chunk { |status| condition[status] }.result).to be_success.with_data(values: [[true, [:success]], [false, [:failure]], [true, [:success]], [false, [:failure]]])
          expect(service.collection(chain_enumerator([:success, :failure, :success, :failure])).chunk { |status| condition[status] }.result).to be_success.with_data(values: [[true, [:success]], [false, [:failure]], [true, [:success]], [false, [:failure]]])
          expect(service.collection([:success, :failure, :success, :failure]).chunk { |status| condition[status] }.result).to be_success.with_data(values: [[true, [:success]], [false, [:failure]], [true, [:success]], [false, [:failure]]])

          expect(service.collection(set([:success, :failure])).chunk { |status| condition[status] }.result).to be_success.with_data(values: [[true, [:success]], [false, [:failure]]])
          expect(service.collection({success: :success, failure: :failure}).chunk { |key, value| condition[value] }.result).to be_success.with_data(values: [[true, [[:success, :success]]], [false, [[:failure, :failure]]]])
          expect(service.collection((:success..:success)).chunk { |status| condition[status] }.result).to be_success.with_data(values: [[true, [:success]]])
          expect(service.collection((:failure..:failure)).chunk { |status| condition[status] }.result).to be_success.with_data(values: [[false, [:failure]]])

          # NOTE: nil, separator, alone.
          expect([nil, :success, :_separator, :failure, :_alone].chunk { |status| status }.to_a).to eq([[:success, [:success]], [:failure, [:failure]], [:_alone, [:_alone]]])
          expect(service.collection(enumerable([nil, :success, :_separator, :failure, :_alone])).chunk { |status| status }.result).to be_success.with_data(values: [[:success, [:success]], [:failure, [:failure]], [:_alone, [:_alone]]])
          expect(service.collection(enumerator([nil, :success, :_separator, :failure, :_alone])).chunk { |status| status }.result).to be_success.with_data(values: [[:success, [:success]], [:failure, [:failure]], [:_alone, [:_alone]]])
          expect(service.collection(lazy_enumerator([nil, :success, :_separator, :failure, :_alone])).chunk { |status| status }.result).to be_success.with_data(values: [[:success, [:success]], [:failure, [:failure]], [:_alone, [:_alone]]])
          expect(service.collection(chain_enumerator([nil, :success, :_separator, :failure, :_alone])).chunk { |status| status }.result).to be_success.with_data(values: [[:success, [:success]], [:failure, [:failure]], [:_alone, [:_alone]]])
          expect(service.collection([nil, :success, :_separator, :failure, :_alone]).chunk { |status| status }.result).to be_success.with_data(values: [[:success, [:success]], [:failure, [:failure]], [:_alone, [:_alone]]])

          expect(service.collection(set([nil, :success, :_separator, :failure, :_alone])).chunk { |status| status }.result).to be_success.with_data(values: [[:success, [:success]], [:failure, [:failure]], [:_alone, [:_alone]]])
          expect(service.collection({nil => nil, :success => :success, :_separator => :_separator, :failure => :failure, :_alone => :_alone}).chunk { |key, value| value }.result).to be_success.with_data(values: [[:success, [[:success, :success]]], [:failure, [[:failure, :failure]]], [:_alone, [[:_alone, :_alone]]]])

          expect(service.collection([nil]).chunk { |status| status }.result).to be_success.with_data(values: [])
          expect(service.collection((:success..:success)).chunk { |status| status }.result).to be_success.with_data(values: [[:success, [:success]]])
          expect(service.collection((:_separator..:_separator)).chunk { |status| status }.result).to be_success.with_data(values: [])
          expect(service.collection((:failure..:failure)).chunk { |status| status }.result).to be_success.with_data(values: [[:failure, [:failure]]])
          expect(service.collection((:_alone..:_alone)).chunk { |status| status }.result).to be_success.with_data(values: [[:_alone, [:_alone]]])

          # NOTE: Step with no outputs.
          expect(service.collection(enumerable([:success, :failure, :success, :failure])).chunk { |status| step status_service, in: [status: -> { status }] }.result).to be_success.with_data(values: [[true, [:success]], [false, [:failure]], [true, [:success]], [false, [:failure]]])
          expect(service.collection(enumerator([:success, :failure, :success, :failure])).chunk { |status| step status_service, in: [status: -> { status }] }.result).to be_success.with_data(values: [[true, [:success]], [false, [:failure]], [true, [:success]], [false, [:failure]]])
          expect(service.collection(lazy_enumerator([:success, :failure, :success, :failure])).chunk { |status| step status_service, in: [status: -> { status }] }.result).to be_success.with_data(values: [[true, [:success]], [false, [:failure]], [true, [:success]], [false, [:failure]]])
          expect(service.collection(chain_enumerator([:success, :failure, :success, :failure])).chunk { |status| step status_service, in: [status: -> { status }] }.result).to be_success.with_data(values: [[true, [:success]], [false, [:failure]], [true, [:success]], [false, [:failure]]])
          expect(service.collection([:success, :failure, :success, :failure]).chunk { |status| step status_service, in: [status: -> { status }] }.result).to be_success.with_data(values: [[true, [:success]], [false, [:failure]], [true, [:success]], [false, [:failure]]])

          expect(service.collection(set([:success, :failure])).chunk { |status| step status_service, in: [status: -> { status }] }.result).to be_success.with_data(values: [[true, [:success]], [false, [:failure]]])
          expect(service.collection({success: :success, failure: :failure}).chunk { |key, value| step status_service, in: [status: -> { value }] }.result).to be_success.with_data(values: [[true, [[:success, :success]]], [false, [[:failure, :failure]]]])
          expect(service.collection((:success..:success)).chunk { |status| step status_service, in: [status: -> { status }] }.result).to be_success.with_data(values: [[true, [:success]]])
          expect(service.collection((:failure..:failure)).chunk { |status| step status_service, in: [status: -> { status }] }.result).to be_success.with_data(values: [[false, [:failure]]])

          # NOTE: Step with one output.
          expect(service.collection(enumerable([:success, :failure, :success, :failure])).chunk { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(values: [["ok", [:success]], ["ok", [:success]]])
          expect(service.collection(enumerator([:success, :failure, :success, :failure])).chunk { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(values: [["ok", [:success]], ["ok", [:success]]])
          expect(service.collection(lazy_enumerator([:success, :failure, :success, :failure])).chunk { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(values: [["ok", [:success]], ["ok", [:success]]])
          expect(service.collection(chain_enumerator([:success, :failure, :success, :failure])).chunk { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(values: [["ok", [:success]], ["ok", [:success]]])
          expect(service.collection([:success, :failure, :success, :failure]).chunk { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(values: [["ok", [:success]], ["ok", [:success]]])

          expect(service.collection(set([:success, :failure])).chunk { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(values: [["ok", [:success]]])
          expect(service.collection({success: :success, failure: :failure}).chunk { |key, value| step status_service, in: [status: -> { value }], out: :status_string }.result).to be_success.with_data(values: [["ok", [[:success, :success]]]])
          expect(service.collection((:success..:success)).chunk { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(values: [["ok", [:success]]])
          expect(service.collection((:failure..:failure)).chunk { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(values: [])

          # NOTE: Step with multiple outputs.
          expect(service.collection(enumerable([:success, :failure, :success, :failure])).chunk { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [[{status_string: "ok", status_code: 200}, [:success]], [{status_string: "ok", status_code: 200}, [:success]]])
          expect(service.collection(enumerator([:success, :failure, :success, :failure])).chunk { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [[{status_string: "ok", status_code: 200}, [:success]], [{status_string: "ok", status_code: 200}, [:success]]])
          expect(service.collection(lazy_enumerator([:success, :failure, :success, :failure])).chunk { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [[{status_string: "ok", status_code: 200}, [:success]], [{status_string: "ok", status_code: 200}, [:success]]])
          expect(service.collection(chain_enumerator([:success, :failure, :success, :failure])).chunk { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [[{status_string: "ok", status_code: 200}, [:success]], [{status_string: "ok", status_code: 200}, [:success]]])
          expect(service.collection([:success, :failure, :success, :failure]).chunk { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [[{status_string: "ok", status_code: 200}, [:success]], [{status_string: "ok", status_code: 200}, [:success]]])

          expect(service.collection(set([:success, :failure])).chunk { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [[{status_string: "ok", status_code: 200}, [:success]]])
          expect(service.collection({success: :success, failure: :failure}).chunk { |key, value| step status_service, in: [status: -> { value }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [[{status_string: "ok", status_code: 200}, [[:success, :success]]]])
          expect(service.collection((:success..:success)).chunk { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [[{status_string: "ok", status_code: 200}, [:success]]])
          expect(service.collection((:failure..:failure)).chunk { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [])

          # NOTE: Error result.
          expect(service.collection(enumerable([:success, :error, :exception])).chunk { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection(enumerator([:success, :error, :exception])).chunk { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection(lazy_enumerator([:success, :error, :exception])).chunk { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection(chain_enumerator([:success, :error, :exception])).chunk { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection([:success, :error, :exception]).chunk { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data

          expect(service.collection(set([:success, :error, :exception])).chunk { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection({success: :success, error: :error, exception: :exception}).chunk { |key, value| step status_service, in: [status: -> { value }] }.result).to be_error.without_data
          expect(service.collection((:error..:error)).chunk { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data

          # NOTE: Error propagation.
          expect(service.collection(enumerable([:success, :error, :exception])).select { |status| step status_service, in: [status: -> { status }] }.chunk { |status| condition[status] }.result).to be_error.without_data
          expect(service.collection(enumerator([:success, :error, :exception])).select { |status| step status_service, in: [status: -> { status }] }.chunk { |status| condition[status] }.result).to be_error.without_data
          expect(service.collection(lazy_enumerator([:success, :error, :exception])).select { |status| step status_service, in: [status: -> { status }] }.chunk { |status| condition[status] }.result).to be_error.without_data
          expect(service.collection(chain_enumerator([:success, :error, :exception])).select { |status| step status_service, in: [status: -> { status }] }.chunk { |status| condition[status] }.result).to be_error.without_data
          expect(service.collection([:success, :error, :exception]).select { |status| step status_service, in: [status: -> { status }] }.chunk { |status| condition[status] }.result).to be_error.without_data

          expect(service.collection(set([:success, :error, :exception])).select { |status| step status_service, in: [status: -> { status }] }.chunk { |status| condition[status] }.result).to be_error.without_data
          expect(service.collection({success: :success, error: :error, exception: :exception}).select { |key, value| step status_service, in: [status: -> { value }] }.chunk { |key, value| condition[value] }.result).to be_error.without_data
          expect(service.collection((:error..:error)).select { |status| step status_service, in: [status: -> { status }] }.chunk { |status| condition[status] }.result).to be_error.without_data

          # NOTE: Usage on terminal chaining.
          expect { service.collection(enumerable([:success, :exception, :exception])).first.chunk { |status| condition[status] }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection(enumerator([:success, :exception, :exception])).first.chunk { |status| condition[status] }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection(lazy_enumerator([:success, :exception, :exception])).first.chunk { |status| condition[status] }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection(chain_enumerator([:success, :exception, :exception])).first.chunk { |status| condition[status] }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection([:success, :exception, :exception]).first.chunk { |status| condition[status] }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)

          expect { service.collection(set([:success, :exception, :exception])).first.chunk { |status| condition[status] }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection({success: :success, exception: :exception}).first.chunk { |key, value| condition[value] }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection((:success..:success)).first.chunk { |status| condition[status] }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
        end
      end

      describe "#chunk_while" do
        specify do
          # NOTE: Empty collection.
          expect([].chunk_while { raise }.to_a).to eq([])
          expect(service.collection(enumerable([])).chunk_while { raise }.result).to be_success.with_data(values: [])
          expect(service.collection(enumerator([])).chunk_while { raise }.result).to be_success.with_data(values: [])
          expect(service.collection(lazy_enumerator([])).chunk_while { raise }.result).to be_success.with_data(values: [])
          expect(service.collection(chain_enumerator([])).chunk_while { raise }.result).to be_success.with_data(values: [])
          expect(service.collection([]).chunk_while { raise }.result).to be_success.with_data(values: [])
          expect(service.collection(set([])).chunk_while { raise }.result).to be_success.with_data(values: [])
          expect(service.collection({}).chunk_while { raise }.result).to be_success.with_data(values: [])
          expect(service.collection((:success...:success)).chunk_while { raise }.result).to be_success.with_data(values: [])

          # NOTE: No block.
          expect { [:success, :success, :success].chunk_while.to_a }.to raise_error(ArgumentError).with_message("tried to create Proc object without a block")
          expect { service.collection(enumerable([:success, :success, :success])).chunk_while.result }.to raise_error(ArgumentError).with_message("tried to create Proc object without a block")
          expect { service.collection(enumerator([:success, :success, :success])).chunk_while.result }.to raise_error(ArgumentError).with_message("tried to create Proc object without a block")
          expect { service.collection(lazy_enumerator([:success, :success, :success])).chunk_while.result }.to raise_error(ArgumentError).with_message("tried to create Proc object without a block")
          expect { service.collection(chain_enumerator([:success, :success, :success])).chunk_while.result }.to raise_error(ArgumentError).with_message("tried to create Proc object without a block")
          expect { service.collection([:success, :success, :success]).chunk_while.result }.to raise_error(ArgumentError).with_message("tried to create Proc object without a block")

          expect { service.collection(set([:success])).chunk_while.result }.to raise_error(ArgumentError).with_message("tried to create Proc object without a block")
          expect { service.collection({success: :success}).chunk_while.result }.to raise_error(ArgumentError).with_message("tried to create Proc object without a block")
          expect { service.collection((:success..:success)).chunk_while.result }.to raise_error(ArgumentError).with_message("tried to create Proc object without a block")

          # NOTE: Block with one argument.
          expect([:success, :failure, :success, :failure].chunk_while { |status| condition[status] }.to_a).to eq([[:success, :failure], [:success, :failure]])
          expect(service.collection(enumerable([:success, :failure, :success, :failure])).chunk_while { |status| condition[status] }.result).to be_success.with_data(values: [[:success, :failure], [:success, :failure]])
          expect(service.collection(enumerator([:success, :failure, :success, :failure])).chunk_while { |status| condition[status] }.result).to be_success.with_data(values: [[:success, :failure], [:success, :failure]])
          expect(service.collection(lazy_enumerator([:success, :failure, :success, :failure])).chunk_while { |status| condition[status] }.result).to be_success.with_data(values: [[:success, :failure], [:success, :failure]])
          expect(service.collection(chain_enumerator([:success, :failure, :success, :failure])).chunk_while { |status| condition[status] }.result).to be_success.with_data(values: [[:success, :failure], [:success, :failure]])
          expect(service.collection([:success, :failure, :success, :failure]).chunk_while { |status| condition[status] }.result).to be_success.with_data(values: [[:success, :failure], [:success, :failure]])

          expect(service.collection(set([:success, :failure])).chunk_while { |status| condition[status] }.result).to be_success.with_data(values: [[:success, :failure]])
          expect(service.collection({success: :success, failure: :failure}).chunk_while { |(key, value)| condition[value] }.result).to be_success.with_data(values: [[[:success, :success], [:failure, :failure]]])
          expect(service.collection((:success..:success)).chunk_while { |status| condition[status] }.result).to be_success.with_data(values: [[:success]])
          expect(service.collection((:failure..:failure)).chunk_while { |status| condition[status] }.result).to be_success.with_data(values: [[:failure]])

          # NOTE: Block with multiple arguments.
          expect([:success, :failure, :success, :failure].chunk_while { |status, other_status| [status, other_status].map(&condition) }.to_a).to eq([[:success, :failure, :success, :failure]])
          expect(service.collection(enumerable([:success, :failure, :success, :failure])).chunk_while { |status, other_status| [status, other_status].map(&condition) }.result).to be_success.with_data(values: [[:success, :failure, :success, :failure]])
          expect(service.collection(enumerator([:success, :failure, :success, :failure])).chunk_while { |status, other_status| [status, other_status].map(&condition) }.result).to be_success.with_data(values: [[:success, :failure, :success, :failure]])
          expect(service.collection(lazy_enumerator([:success, :failure, :success, :failure])).chunk_while { |status, other_status| [status, other_status].map(&condition) }.result).to be_success.with_data(values: [[:success, :failure, :success, :failure]])
          expect(service.collection(chain_enumerator([:success, :failure, :success, :failure])).chunk_while { |status, other_status| [status, other_status].map(&condition) }.result).to be_success.with_data(values: [[:success, :failure, :success, :failure]])
          expect(service.collection([:success, :failure, :success, :failure]).chunk_while { |status, other_status| [status, other_status].map(&condition) }.result).to be_success.with_data(values: [[:success, :failure, :success, :failure]])

          expect(service.collection(set([:success, :failure])).chunk_while { |status, other_status| [status, other_status].map(&condition) }.result).to be_success.with_data(values: [[:success, :failure]])
          expect(service.collection({success: :success, failure: :failure}).chunk_while { |(key, value), (other_key, other_value)| [value, other_value].map(&condition) }.result).to be_success.with_data(values: [[[:success, :success], [:failure, :failure]]])
          expect(service.collection((:success..:success)).chunk_while { |status, other_status| [status, other_status].map(&condition) }.result).to be_success.with_data(values: [[:success]])
          expect(service.collection((:failure..:failure)).chunk_while { |status, other_status| [status, other_status].map(&condition) }.result).to be_success.with_data(values: [[:failure]])

          # NOTE: Step with no outputs.
          expect(service.collection(enumerable([:success, :failure, :success, :failure])).chunk_while { |status, other_status| step statuses_service, in: [statuses: -> { [status, other_status] }] }.result).to be_success.with_data(values: [[:success], [:failure], [:success], [:failure]])
          expect(service.collection(enumerator([:success, :failure, :success, :failure])).chunk_while { |status, other_status| step statuses_service, in: [statuses: -> { [status, other_status] }] }.result).to be_success.with_data(values: [[:success], [:failure], [:success], [:failure]])
          expect(service.collection(lazy_enumerator([:success, :failure, :success, :failure])).chunk_while { |status, other_status| step statuses_service, in: [statuses: -> { [status, other_status] }] }.result).to be_success.with_data(values: [[:success], [:failure], [:success], [:failure]])
          expect(service.collection(chain_enumerator([:success, :failure, :success, :failure])).chunk_while { |status, other_status| step statuses_service, in: [statuses: -> { [status, other_status] }] }.result).to be_success.with_data(values: [[:success], [:failure], [:success], [:failure]])
          expect(service.collection([:success, :failure, :success, :failure]).chunk_while { |status, other_status| step statuses_service, in: [statuses: -> { [status, other_status] }] }.result).to be_success.with_data(values: [[:success], [:failure], [:success], [:failure]])

          expect(service.collection(set([:success, :failure])).chunk_while { |status, other_status| step statuses_service, in: [statuses: -> { [status, other_status] }] }.result).to be_success.with_data(values: [[:success], [:failure]])
          expect(service.collection({success: :success, failure: :failure}).chunk_while { |(key, value), (other_key, other_value)| step statuses_service, in: [statuses: -> { [value, other_value] }] }.result).to be_success.with_data(values: [[[:success, :success]], [[:failure, :failure]]])
          expect(service.collection((:success..:success)).chunk_while { |status, other_status| step statuses_service, in: [statuses: -> { [status, other_status] }] }.result).to be_success.with_data(values: [[:success]])
          expect(service.collection((:failure..:failure)).chunk_while { |status, other_status| step statuses_service, in: [statuses: -> { [status, other_status] }] }.result).to be_success.with_data(values: [[:failure]])

          # NOTE: Step with one output.
          expect(service.collection(enumerable([:success, :failure, :success, :failure])).chunk_while { |status, other_status| step statuses_service, in: [statuses: -> { [status, other_status] }], out: :status_string }.result).to be_success.with_data(values: [[:success], [:failure], [:success], [:failure]])
          expect(service.collection(enumerator([:success, :failure, :success, :failure])).chunk_while { |status, other_status| step statuses_service, in: [statuses: -> { [status, other_status] }], out: :status_string }.result).to be_success.with_data(values: [[:success], [:failure], [:success], [:failure]])
          expect(service.collection(lazy_enumerator([:success, :failure, :success, :failure])).chunk_while { |status, other_status| step statuses_service, in: [statuses: -> { [status, other_status] }], out: :status_string }.result).to be_success.with_data(values: [[:success], [:failure], [:success], [:failure]])
          expect(service.collection(chain_enumerator([:success, :failure, :success, :failure])).chunk_while { |status, other_status| step statuses_service, in: [statuses: -> { [status, other_status] }], out: :status_string }.result).to be_success.with_data(values: [[:success], [:failure], [:success], [:failure]])
          expect(service.collection([:success, :failure, :success, :failure]).chunk_while { |status, other_status| step statuses_service, in: [statuses: -> { [status, other_status] }], out: :status_string }.result).to be_success.with_data(values: [[:success], [:failure], [:success], [:failure]])

          expect(service.collection(set([:success, :failure])).chunk_while { |status, other_status| step statuses_service, in: [statuses: -> { [status, other_status] }], out: :status_string }.result).to be_success.with_data(values: [[:success], [:failure]])
          expect(service.collection({success: :success, failure: :failure}).chunk_while { |(key, value), (other_key, other_value)| step statuses_service, in: [statuses: -> { [value, other_value] }], out: :status_string }.result).to be_success.with_data(values: [[[:success, :success]], [[:failure, :failure]]])
          expect(service.collection((:success..:success)).chunk_while { |status, other_status| step statuses_service, in: [statuses: -> { [status, other_status] }], out: :status_string }.result).to be_success.with_data(values: [[:success]])
          expect(service.collection((:failure..:failure)).chunk_while { |status, other_status| step statuses_service, in: [statuses: -> { [status, other_status] }], out: :status_string }.result).to be_success.with_data(values: [[:failure]])

          # NOTE: Step with multiple outputs.
          expect(service.collection(enumerable([:success, :failure, :success, :failure])).chunk_while { |status, other_status| step statuses_service, in: [statuses: -> { [status, other_status] }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [[:success], [:failure], [:success], [:failure]])
          expect(service.collection(enumerator([:success, :failure, :success, :failure])).chunk_while { |status, other_status| step statuses_service, in: [statuses: -> { [status, other_status] }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [[:success], [:failure], [:success], [:failure]])
          expect(service.collection(lazy_enumerator([:success, :failure, :success, :failure])).chunk_while { |status, other_status| step statuses_service, in: [statuses: -> { [status, other_status] }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [[:success], [:failure], [:success], [:failure]])
          expect(service.collection(chain_enumerator([:success, :failure, :success, :failure])).chunk_while { |status, other_status| step statuses_service, in: [statuses: -> { [status, other_status] }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [[:success], [:failure], [:success], [:failure]])
          expect(service.collection([:success, :failure, :success, :failure]).chunk_while { |status, other_status| step statuses_service, in: [statuses: -> { [status, other_status] }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [[:success], [:failure], [:success], [:failure]])

          expect(service.collection(set([:success, :failure])).chunk_while { |status, other_status| step statuses_service, in: [statuses: -> { [status, other_status] }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [[:success], [:failure]])
          expect(service.collection({success: :success, failure: :failure}).chunk_while { |(key, value), (other_key, other_value)| step statuses_service, in: [statuses: -> { [value, other_value] }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [[[:success, :success]], [[:failure, :failure]]])
          expect(service.collection((:success..:success)).chunk_while { |status, other_status| step statuses_service, in: [statuses: -> { [status, other_status] }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [[:success]])
          expect(service.collection((:failure..:failure)).chunk_while { |status, other_status| step statuses_service, in: [statuses: -> { [status, other_status] }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [[:failure]])

          # NOTE: Error result.
          expect(service.collection(enumerable([:success, :error, :exception])).chunk_while { |status, other_status| step statuses_service, in: [statuses: -> { [status, other_status] }] }.result).to be_error.without_data
          expect(service.collection(enumerator([:success, :error, :exception])).chunk_while { |status, other_status| step statuses_service, in: [statuses: -> { [status, other_status] }] }.result).to be_error.without_data
          expect(service.collection(lazy_enumerator([:success, :error, :exception])).chunk_while { |status, other_status| step statuses_service, in: [statuses: -> { [status, other_status] }] }.result).to be_error.without_data
          expect(service.collection(chain_enumerator([:success, :error, :exception])).chunk_while { |status, other_status| step statuses_service, in: [statuses: -> { [status, other_status] }] }.result).to be_error.without_data
          expect(service.collection([:success, :error, :exception]).chunk_while { |status, other_status| step statuses_service, in: [statuses: -> { [status, other_status] }] }.result).to be_error.without_data

          expect(service.collection(set([:success, :error, :exception])).chunk_while { |status, other_status| step statuses_service, in: [statuses: -> { [status, other_status] }] }.result).to be_error.without_data
          expect(service.collection({success: :success, error: :error, exception: :exception}).chunk_while { |(key, value), (other_key, other_value)| step statuses_service, in: [statuses: -> { [value, other_value] }] }.result).to be_error.without_data
          expect((:error..:error).chunk_while { |status, other_status| [status, other_status].map(&condition) }.to_a).to eq([[:error]])
          expect(service.collection((:error..:error)).chunk_while { |status, other_status| step statuses_service, in: [statuses: -> { [status, other_status] }] }.result).to be_success.with_data(values: [[:error]])

          # NOTE: Error propagation.
          expect(service.collection(enumerable([:success, :error, :exception])).select { |status| step status_service, in: [status: -> { status }] }.chunk_while { |status| condition[status] }.result).to be_error.without_data
          expect(service.collection(enumerator([:success, :error, :exception])).select { |status| step status_service, in: [status: -> { status }] }.chunk_while { |status| condition[status] }.result).to be_error.without_data
          expect(service.collection(lazy_enumerator([:success, :error, :exception])).select { |status| step status_service, in: [status: -> { status }] }.chunk_while { |status| condition[status] }.result).to be_error.without_data
          expect(service.collection(chain_enumerator([:success, :error, :exception])).select { |status| step status_service, in: [status: -> { status }] }.chunk_while { |status| condition[status] }.result).to be_error.without_data
          expect(service.collection([:success, :error, :exception]).select { |status| step status_service, in: [status: -> { status }] }.chunk_while { |status| condition[status] }.result).to be_error.without_data

          expect(service.collection(set([:success, :error, :exception])).select { |status| step status_service, in: [status: -> { status }] }.chunk_while { |status| condition[status] }.result).to be_error.without_data
          expect(service.collection({success: :success, error: :error, exception: :exception}).select { |key, value| step status_service, in: [status: -> { value }] }.chunk_while { |key, value| condition[value] }.result).to be_error.without_data
          expect(service.collection((:error..:error)).select { |status| step status_service, in: [status: -> { status }] }.chunk_while { |status| condition[status] }.result).to be_error.without_data

          # NOTE: Usage on terminal chaining.
          expect { service.collection(enumerable([:success, :exception, :exception])).first.chunk_while { |status| condition[status] }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection(enumerator([:success, :exception, :exception])).first.chunk_while { |status| condition[status] }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection(lazy_enumerator([:success, :exception, :exception])).first.chunk_while { |status| condition[status] }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection(chain_enumerator([:success, :exception, :exception])).first.chunk_while { |status| condition[status] }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection([:success, :exception, :exception]).first.chunk_while { |status| condition[status] }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)

          expect { service.collection(set([:success, :exception, :exception])).first.chunk_while { |status| condition[status] }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection({success: :success, exception: :exception}).first.chunk_while { |key, value| condition[value] }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection((:success..:success)).first.chunk_while { |status| condition[status] }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
        end
      end

      describe "#collect" do
        specify do
          # NOTE: Empty collection.
          expect([].collect { |status| condition[status] }).to eq([])
          expect(service.collection(enumerable([])).collect { |status| condition[status] }.result).to be_success.with_data(values: [])
          expect(service.collection(enumerator([])).collect { |status| condition[status] }.result).to be_success.with_data(values: [])
          expect(service.collection(lazy_enumerator([])).collect { |status| condition[status] }.result).to be_success.with_data(values: [])
          expect(service.collection(chain_enumerator([])).collect { |status| condition[status] }.result).to be_success.with_data(values: [])
          expect(service.collection([]).collect { |status| condition[status] }.result).to be_success.with_data(values: [])
          expect(service.collection(set([])).collect { |status| condition[status] }.result).to be_success.with_data(values: [])
          expect(service.collection({}).collect { |status| condition[status] }.result).to be_success.with_data(values: [])
          expect(service.collection((:success...:success)).collect { |status| condition[status] }.result).to be_success.with_data(values: [])

          # NOTE: No block.
          expect([:success, :success, :success].collect.to_a).to eq([:success, :success, :success])
          expect(service.collection(enumerable([:success, :success, :success])).collect.result).to be_success.with_data(values: [:success, :success, :success])
          expect(service.collection(enumerator([:success, :success, :success])).collect.result).to be_success.with_data(values: [:success, :success, :success])
          expect { service.collection(lazy_enumerator([:success, :success, :success])).collect.result }.to raise_error(ArgumentError).with_message("tried to call lazy map without a block")
          expect(service.collection(chain_enumerator([:success, :success, :success])).collect.result).to be_success.with_data(values: [:success, :success, :success])
          expect(service.collection([:success, :success, :success]).collect.result).to be_success.with_data(values: [:success, :success, :success])

          # NOTE: Block.
          expect([:success, :success, :success].collect { |status| condition[status] }).to eq([true, true, true])
          expect(service.collection(enumerable([:success, :success, :success])).collect { |status| condition[status] }.result).to be_success.with_data(values: [true, true, true])
          expect(service.collection(enumerator([:success, :success, :success])).collect { |status| condition[status] }.result).to be_success.with_data(values: [true, true, true])
          expect(service.collection(lazy_enumerator([:success, :success, :success])).collect { |status| condition[status] }.result).to be_success.with_data(values: [true, true, true])
          expect(service.collection(chain_enumerator([:success, :success, :success])).collect { |status| condition[status] }.result).to be_success.with_data(values: [true, true, true])
          expect(service.collection([:success, :success, :success]).collect { |status| condition[status] }.result).to be_success.with_data(values: [true, true, true])

          expect(service.collection(set([:success])).collect { |status| condition[status] }.result).to be_success.with_data(values: [true])
          expect(service.collection({success: :success}).collect { |key, value| condition[value] }.result).to be_success.with_data(values: [true])
          expect(service.collection((:success..:success)).collect { |status| condition[status] }.result).to be_success.with_data(values: [true])

          # NOTE: Step with no outputs.
          expect(service.collection(enumerable([:success, :success, :success])).collect { |status| step status_service, in: [status: -> { status }] }.result).to be_success.with_data(values: [true, true, true])
          expect(service.collection(enumerator([:success, :success, :success])).collect { |status| step status_service, in: [status: -> { status }] }.result).to be_success.with_data(values: [true, true, true])
          expect(service.collection(lazy_enumerator([:success, :success, :success])).collect { |status| step status_service, in: [status: -> { status }] }.result).to be_success.with_data(values: [true, true, true])
          expect(service.collection(chain_enumerator([:success, :success, :success])).collect { |status| step status_service, in: [status: -> { status }] }.result).to be_success.with_data(values: [true, true, true])
          expect(service.collection([:success, :success, :success]).collect { |status| step status_service, in: [status: -> { status }] }.result).to be_success.with_data(values: [true, true, true])

          expect(service.collection(set([:success])).collect { |status| step status_service, in: [status: -> { status }] }.result).to be_success.with_data(values: [true])
          expect(service.collection({success: :success}).collect { |key, value| step status_service, in: [status: -> { value }] }.result).to be_success.with_data(values: [true])
          expect(service.collection((:success..:success)).collect { |status| step status_service, in: [status: -> { status }] }.result).to be_success.with_data(values: [true])

          # NOTE: Step with one output.
          expect(service.collection(enumerable([:success, :success, :success])).collect { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(values: ["ok", "ok", "ok"])
          expect(service.collection(enumerator([:success, :success, :success])).collect { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(values: ["ok", "ok", "ok"])
          expect(service.collection(lazy_enumerator([:success, :success, :success])).collect { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(values: ["ok", "ok", "ok"])
          expect(service.collection(chain_enumerator([:success, :success, :success])).collect { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(values: ["ok", "ok", "ok"])
          expect(service.collection([:success, :success, :success]).collect { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(values: ["ok", "ok", "ok"])

          expect(service.collection(set([:success])).collect { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(values: ["ok"])
          expect(service.collection({success: :success}).collect { |key, value| step status_service, in: [status: -> { value }], out: :status_string }.result).to be_success.with_data(values: ["ok"])
          expect(service.collection((:success..:success)).collect { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(values: ["ok"])

          # NOTE: Step with multiple outputs.
          expect(service.collection(enumerable([:success, :success, :success])).collect { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [{status_string: "ok", status_code: 200}, {status_string: "ok", status_code: 200}, {status_string: "ok", status_code: 200}])
          expect(service.collection(enumerator([:success, :success, :success])).collect { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [{status_string: "ok", status_code: 200}, {status_string: "ok", status_code: 200}, {status_string: "ok", status_code: 200}])
          expect(service.collection(lazy_enumerator([:success, :success, :success])).collect { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [{status_string: "ok", status_code: 200}, {status_string: "ok", status_code: 200}, {status_string: "ok", status_code: 200}])
          expect(service.collection(chain_enumerator([:success, :success, :success])).collect { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [{status_string: "ok", status_code: 200}, {status_string: "ok", status_code: 200}, {status_string: "ok", status_code: 200}])
          expect(service.collection([:success, :success, :success]).collect { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [{status_string: "ok", status_code: 200}, {status_string: "ok", status_code: 200}, {status_string: "ok", status_code: 200}])

          expect(service.collection(set([:success])).collect { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [{status_string: "ok", status_code: 200}])
          expect(service.collection({success: :success}).collect { |key, value| step status_service, in: [status: -> { value }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [{status_string: "ok", status_code: 200}])
          expect(service.collection((:success..:success)).collect { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [{status_string: "ok", status_code: 200}])

          # NOTE: Error result.
          expect(service.collection(enumerable([:success, :error, :exception])).collect { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection(enumerator([:success, :error, :exception])).collect { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection(lazy_enumerator([:success, :error, :exception])).collect { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection(chain_enumerator([:success, :error, :exception])).collect { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection([:success, :error, :exception]).collect { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data

          expect(service.collection(set([:success, :error, :exception])).collect { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection({success: :success, error: :error, exception: :exception}).collect { |key, value| step status_service, in: [status: -> { value }] }.result).to be_error.without_data
          expect(service.collection((:error..:error)).collect { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data

          # NOTE: Error propagation.
          expect(service.collection(enumerable([:success, :error, :exception])).select { |status| step status_service, in: [status: -> { status }] }.collect { |status| condition[status] }.result).to be_error.without_data
          expect(service.collection(enumerator([:success, :error, :exception])).select { |status| step status_service, in: [status: -> { status }] }.collect { |status| condition[status] }.result).to be_error.without_data
          expect(service.collection(lazy_enumerator([:success, :error, :exception])).select { |status| step status_service, in: [status: -> { status }] }.collect { |status| condition[status] }.result).to be_error.without_data
          expect(service.collection(chain_enumerator([:success, :error, :exception])).select { |status| step status_service, in: [status: -> { status }] }.collect { |status| condition[status] }.result).to be_error.without_data
          expect(service.collection([:success, :error, :exception]).select { |status| step status_service, in: [status: -> { status }] }.collect { |status| condition[status] }.result).to be_error.without_data

          expect(service.collection(set([:success, :error, :exception])).select { |status| step status_service, in: [status: -> { status }] }.collect { |status| condition[status] }.result).to be_error.without_data
          expect(service.collection({success: :success, error: :error, exception: :exception}).select { |key, value| step status_service, in: [status: -> { value }] }.collect { |key, value| condition[value] }.result).to be_error.without_data
          expect(service.collection((:error..:error)).select { |status| step status_service, in: [status: -> { status }] }.collect { |status| condition[status] }.result).to be_error.without_data

          # NOTE: Usage on terminal chaining.
          expect { service.collection(enumerable([:success, :exception, :exception])).first.collect { |status| condition[status] }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection(enumerator([:success, :exception, :exception])).first.collect { |status| condition[status] }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection(lazy_enumerator([:success, :exception, :exception])).first.collect { |status| condition[status] }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection(chain_enumerator([:success, :exception, :exception])).first.collect { |status| condition[status] }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection([:success, :exception, :exception]).first.collect { |status| condition[status] }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)

          expect { service.collection(set([:success, :exception, :exception])).first.collect { |status| condition[status] }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection({success: :success, exception: :exception}).first.collect { |key, value| condition[value] }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection((:success..:success)).first.collect { |status| condition[status] }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
        end
      end

      describe "#collect_concat" do
        specify do
          # NOTE: Empty collection.
          expect([].collect_concat { |status| condition[status] }).to eq([])
          expect(service.collection(enumerable([])).collect_concat { |status| condition[status] }.result).to be_success.with_data(values: [])
          expect(service.collection(enumerator([])).collect_concat { |status| condition[status] }.result).to be_success.with_data(values: [])
          expect(service.collection(lazy_enumerator([])).collect_concat { |status| condition[status] }.result).to be_success.with_data(values: [])
          expect(service.collection(chain_enumerator([])).collect_concat { |status| condition[status] }.result).to be_success.with_data(values: [])
          expect(service.collection([]).collect_concat { |status| condition[status] }.result).to be_success.with_data(values: [])
          expect(service.collection(set([])).collect_concat { |status| condition[status] }.result).to be_success.with_data(values: [])
          expect(service.collection({}).collect_concat { |status| condition[status] }.result).to be_success.with_data(values: [])
          expect(service.collection((:success...:success)).collect_concat { |status| condition[status] }.result).to be_success.with_data(values: [])

          # NOTE: No block.
          expect([:success, :success, :success].collect_concat.to_a).to eq([:success, :success, :success])
          expect(service.collection(enumerable([:success, :success, :success])).collect_concat.result).to be_success.with_data(values: [:success, :success, :success])
          expect(service.collection(enumerator([:success, :success, :success])).collect_concat.result).to be_success.with_data(values: [:success, :success, :success])
          expect { service.collection(lazy_enumerator([:success, :success, :success])).collect_concat.result }.to raise_error(ArgumentError).with_message("tried to call lazy flat_map without a block")
          expect(service.collection(chain_enumerator([:success, :success, :success])).collect_concat.result).to be_success.with_data(values: [:success, :success, :success])
          expect(service.collection([:success, :success, :success]).collect_concat.result).to be_success.with_data(values: [:success, :success, :success])

          # NOTE: Block.
          expect([:success, :success, :success].collect_concat { |status| condition[status] }).to eq([true, true, true])
          expect(service.collection(enumerable([:success, :success, :success])).collect_concat { |status| condition[status] }.result).to be_success.with_data(values: [true, true, true])
          expect(service.collection(enumerator([:success, :success, :success])).collect_concat { |status| condition[status] }.result).to be_success.with_data(values: [true, true, true])
          expect(service.collection(lazy_enumerator([:success, :success, :success])).collect_concat { |status| condition[status] }.result).to be_success.with_data(values: [true, true, true])
          expect(service.collection(chain_enumerator([:success, :success, :success])).collect_concat { |status| condition[status] }.result).to be_success.with_data(values: [true, true, true])
          expect(service.collection([:success, :success, :success]).collect_concat { |status| condition[status] }.result).to be_success.with_data(values: [true, true, true])

          expect(service.collection(set([:success])).collect_concat { |status| condition[status] }.result).to be_success.with_data(values: [true])
          expect(service.collection({success: :success}).collect_concat { |key, value| condition[value] }.result).to be_success.with_data(values: [true])
          expect(service.collection((:success..:success)).collect_concat { |status| condition[status] }.result).to be_success.with_data(values: [true])

          # NOTE: Flatten.
          expect([:success, :success, :success].collect_concat { |status| [condition[status], condition[status]] }).to eq([true, true, true, true, true, true])
          expect(service.collection(enumerable([:success, :success, :success])).collect_concat { |status| [condition[status], condition[status]] }.result).to be_success.with_data(values: [true, true, true, true, true, true])
          expect(service.collection(enumerator([:success, :success, :success])).collect_concat { |status| [condition[status], condition[status]] }.result).to be_success.with_data(values: [true, true, true, true, true, true])
          expect(service.collection(lazy_enumerator([:success, :success, :success])).collect_concat { |status| [condition[status], condition[status]] }.result).to be_success.with_data(values: [true, true, true, true, true, true])
          expect(service.collection(chain_enumerator([:success, :success, :success])).collect_concat { |status| [condition[status], condition[status]] }.result).to be_success.with_data(values: [true, true, true, true, true, true])
          expect(service.collection([:success, :success, :success]).collect_concat { |status| [condition[status], condition[status]] }.result).to be_success.with_data(values: [true, true, true, true, true, true])

          expect(service.collection(set([:success])).collect_concat { |status| [condition[status], condition[status]] }.result).to be_success.with_data(values: [true, true])
          expect(service.collection({success: :success}).collect_concat { |key, value| [condition[value], condition[value]] }.result).to be_success.with_data(values: [true, true])
          expect(service.collection((:success..:success)).collect_concat { |status| [condition[status], condition[status]] }.result).to be_success.with_data(values: [true, true])

          # NOTE: Step with no outputs.
          expect(service.collection(enumerable([:success, :success, :success])).collect_concat { |status| step status_service, in: [status: -> { status }] }.result).to be_success.with_data(values: [true, true, true])
          expect(service.collection(enumerator([:success, :success, :success])).collect_concat { |status| step status_service, in: [status: -> { status }] }.result).to be_success.with_data(values: [true, true, true])
          expect(service.collection(lazy_enumerator([:success, :success, :success])).collect_concat { |status| step status_service, in: [status: -> { status }] }.result).to be_success.with_data(values: [true, true, true])
          expect(service.collection(chain_enumerator([:success, :success, :success])).collect_concat { |status| step status_service, in: [status: -> { status }] }.result).to be_success.with_data(values: [true, true, true])
          expect(service.collection([:success, :success, :success]).collect_concat { |status| step status_service, in: [status: -> { status }] }.result).to be_success.with_data(values: [true, true, true])

          expect(service.collection(set([:success])).collect_concat { |status| step status_service, in: [status: -> { status }] }.result).to be_success.with_data(values: [true])
          expect(service.collection({success: :success}).collect_concat { |key, value| step status_service, in: [status: -> { value }] }.result).to be_success.with_data(values: [true])
          expect(service.collection((:success..:success)).collect_concat { |status| step status_service, in: [status: -> { status }] }.result).to be_success.with_data(values: [true])

          # NOTE: Step with one output.
          expect(service.collection(enumerable([:success, :success, :success])).collect_concat { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(values: ["ok", "ok", "ok"])
          expect(service.collection(enumerator([:success, :success, :success])).collect_concat { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(values: ["ok", "ok", "ok"])
          expect(service.collection(lazy_enumerator([:success, :success, :success])).collect_concat { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(values: ["ok", "ok", "ok"])
          expect(service.collection(chain_enumerator([:success, :success, :success])).collect_concat { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(values: ["ok", "ok", "ok"])
          expect(service.collection([:success, :success, :success]).collect_concat { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(values: ["ok", "ok", "ok"])

          expect(service.collection(set([:success])).collect_concat { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(values: ["ok"])
          expect(service.collection({success: :success}).collect_concat { |key, value| step status_service, in: [status: -> { value }], out: :status_string }.result).to be_success.with_data(values: ["ok"])
          expect(service.collection((:success..:success)).collect_concat { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(values: ["ok"])

          # NOTE: Step with multiple outputs.
          expect(service.collection(enumerable([:success, :success, :success])).collect_concat { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [{status_string: "ok", status_code: 200}, {status_string: "ok", status_code: 200}, {status_string: "ok", status_code: 200}])
          expect(service.collection(enumerator([:success, :success, :success])).collect_concat { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [{status_string: "ok", status_code: 200}, {status_string: "ok", status_code: 200}, {status_string: "ok", status_code: 200}])
          expect(service.collection(lazy_enumerator([:success, :success, :success])).collect_concat { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [{status_string: "ok", status_code: 200}, {status_string: "ok", status_code: 200}, {status_string: "ok", status_code: 200}])
          expect(service.collection(chain_enumerator([:success, :success, :success])).collect_concat { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [{status_string: "ok", status_code: 200}, {status_string: "ok", status_code: 200}, {status_string: "ok", status_code: 200}])
          expect(service.collection([:success, :success, :success]).collect_concat { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [{status_string: "ok", status_code: 200}, {status_string: "ok", status_code: 200}, {status_string: "ok", status_code: 200}])

          expect(service.collection(set([:success])).collect_concat { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [{status_string: "ok", status_code: 200}])
          expect(service.collection({success: :success}).collect_concat { |key, value| step status_service, in: [status: -> { value }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [{status_string: "ok", status_code: 200}])
          expect(service.collection((:success..:success)).collect_concat { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [{status_string: "ok", status_code: 200}])

          # NOTE: Error result.
          expect(service.collection(enumerable([:success, :error, :exception])).collect_concat { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection(enumerator([:success, :error, :exception])).collect_concat { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection(lazy_enumerator([:success, :error, :exception])).collect_concat { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection(chain_enumerator([:success, :error, :exception])).collect_concat { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection([:success, :error, :exception]).collect_concat { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data

          expect(service.collection(set([:success, :error, :exception])).collect_concat { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection({success: :success, error: :error, exception: :exception}).collect_concat { |key, value| step status_service, in: [status: -> { value }] }.result).to be_error.without_data
          expect(service.collection((:error..:error)).collect_concat { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data

          # NOTE: Error propagation.
          expect(service.collection(enumerable([:success, :error, :exception])).select { |status| step status_service, in: [status: -> { status }] }.collect_concat { |status| condition[status] }.result).to be_error.without_data
          expect(service.collection(enumerator([:success, :error, :exception])).select { |status| step status_service, in: [status: -> { status }] }.collect_concat { |status| condition[status] }.result).to be_error.without_data
          expect(service.collection(lazy_enumerator([:success, :error, :exception])).select { |status| step status_service, in: [status: -> { status }] }.collect_concat { |status| condition[status] }.result).to be_error.without_data
          expect(service.collection(chain_enumerator([:success, :error, :exception])).select { |status| step status_service, in: [status: -> { status }] }.collect_concat { |status| condition[status] }.result).to be_error.without_data
          expect(service.collection([:success, :error, :exception]).select { |status| step status_service, in: [status: -> { status }] }.collect_concat { |status| condition[status] }.result).to be_error.without_data

          expect(service.collection(set([:success, :error, :exception])).select { |status| step status_service, in: [status: -> { status }] }.collect_concat { |status| condition[status] }.result).to be_error.without_data
          expect(service.collection({success: :success, error: :error, exception: :exception}).select { |key, value| step status_service, in: [status: -> { value }] }.collect_concat { |key, value| condition[value] }.result).to be_error.without_data
          expect(service.collection((:error..:error)).select { |status| step status_service, in: [status: -> { status }] }.collect_concat { |status| condition[status] }.result).to be_error.without_data

          # NOTE: Usage on terminal chaining.
          expect { service.collection(enumerable([:success, :exception, :exception])).first.collect_concat { |status| condition[status] }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection(enumerator([:success, :exception, :exception])).first.collect_concat { |status| condition[status] }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection(lazy_enumerator([:success, :exception, :exception])).first.collect_concat { |status| condition[status] }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection(chain_enumerator([:success, :exception, :exception])).first.collect_concat { |status| condition[status] }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection([:success, :exception, :exception]).first.collect_concat { |status| condition[status] }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)

          expect { service.collection(set([:success, :exception, :exception])).first.collect_concat { |status| condition[status] }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection({success: :success, exception: :exception}).first.collect_concat { |key, value| condition[value] }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection((:success..:success)).first.collect_concat { |status| condition[status] }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
        end
      end

      # compact

      # rubocop:disable Performance/Size
      describe "#count" do
        specify do
          # NOTE: Empty collection.
          expect([].count).to eq(0)
          expect(service.collection(enumerable([])).count.result).to be_success.with_data(value: 0)
          expect(service.collection(enumerator([])).count.result).to be_success.with_data(value: 0)
          expect(service.collection(lazy_enumerator([])).count.result).to be_success.with_data(value: 0)
          expect(service.collection(chain_enumerator([])).count.result).to be_success.with_data(value: 0)
          expect(service.collection([]).count.result).to be_success.with_data(value: 0)
          expect(service.collection(set([])).count.result).to be_success.with_data(value: 0)
          expect(service.collection({}).count.result).to be_success.with_data(value: 0)
          expect(service.collection((:success...:success)).count.result).to be_success.with_data(value: 0)

          # NOTE: No block, no pattern.
          expect([:success, :success].count).to eq(2)
          expect(service.collection(enumerable([:success, :success])).count.result).to be_success.with_data(value: 2)
          expect(service.collection(enumerator([:success, :success])).count.result).to be_success.with_data(value: 2)
          expect(service.collection(lazy_enumerator([:success, :success])).count.result).to be_success.with_data(value: 2)
          expect(service.collection(chain_enumerator([:success, :success])).count.result).to be_success.with_data(value: 2)
          expect(service.collection([:success, :success]).count.result).to be_success.with_data(value: 2)

          expect(service.collection(set([:success])).count.result).to be_success.with_data(value: 1)
          expect(service.collection({success: :success}).count.result).to be_success.with_data(value: 1)
          expect(service.collection((:success..:success)).count.result).to be_success.with_data(value: 1)

          # NOTE: Item.
          expect([:success, :failure, :success, :failure].count(:success)).to eq(2)
          expect(service.collection(enumerable([:success, :failure, :success, :failure])).count(:success).result).to be_success.with_data(value: 2)
          expect(service.collection(enumerator([:success, :failure, :success, :failure])).count(:success).result).to be_success.with_data(value: 2)
          expect(service.collection(lazy_enumerator([:success, :failure, :success, :failure])).count(:success).result).to be_success.with_data(value: 2)
          expect(service.collection(chain_enumerator([:success, :failure, :success, :failure])).count(:success).result).to be_success.with_data(value: 2)
          expect(service.collection([:success, :failure, :success, :failure]).count(:success).result).to be_success.with_data(value: 2)

          expect(service.collection(set([:success, :failure])).count(:success).result).to be_success.with_data(value: 1)
          expect(service.collection({success: :success, failure: :failure}).count([:success, :success]).result).to be_success.with_data(value: 1)
          expect(service.collection((:success..:success)).count(:success).result).to be_success.with_data(value: 1)
          expect(service.collection((:failure..:failure)).count(:success).result).to be_success.with_data(value: 0)

          # NOTE: Block.
          expect([:success, :failure, :success, :failure].count { |status| condition[status] }).to eq(2)
          expect(service.collection(enumerable([:success, :failure, :success, :failure])).count { |status| condition[status] }.result).to be_success.with_data(value: 2)
          expect(service.collection(enumerator([:success, :failure, :success, :failure])).count { |status| condition[status] }.result).to be_success.with_data(value: 2)
          expect(service.collection(lazy_enumerator([:success, :failure, :success, :failure])).count { |status| condition[status] }.result).to be_success.with_data(value: 2)
          expect(service.collection(chain_enumerator([:success, :failure, :success, :failure])).count { |status| condition[status] }.result).to be_success.with_data(value: 2)
          expect(service.collection([:success, :failure, :success, :failure]).count { |status| condition[status] }.result).to be_success.with_data(value: 2)

          expect(service.collection(set([:success, :failure])).count { |status| condition[status] }.result).to be_success.with_data(value: 1)
          expect(service.collection({success: :success, failure: :failure}).count { |key, value| condition[value] }.result).to be_success.with_data(value: 1)
          expect(service.collection((:success..:success)).count { |status| condition[status] }.result).to be_success.with_data(value: 1)
          expect(service.collection((:failure..:failure)).count { |status| condition[status] }.result).to be_success.with_data(value: 0)

          # NOTE: Step with no outputs.
          expect(service.collection(enumerable([:success, :failure, :success, :failure])).count { |status| step status_service, in: [status: -> { status }] }.result).to be_success.with_data(value: 2)
          expect(service.collection(enumerator([:success, :failure, :success, :failure])).count { |status| step status_service, in: [status: -> { status }] }.result).to be_success.with_data(value: 2)
          expect(service.collection(lazy_enumerator([:success, :failure, :success, :failure])).count { |status| step status_service, in: [status: -> { status }] }.result).to be_success.with_data(value: 2)
          expect(service.collection(chain_enumerator([:success, :failure, :success, :failure])).count { |status| step status_service, in: [status: -> { status }] }.result).to be_success.with_data(value: 2)
          expect(service.collection([:success, :failure, :success, :failure]).count { |status| step status_service, in: [status: -> { status }] }.result).to be_success.with_data(value: 2)

          expect(service.collection(set([:success, :failure])).count { |status| step status_service, in: [status: -> { status }] }.result).to be_success.with_data(value: 1)
          expect(service.collection({success: :success, failure: :failure}).count { |key, value| step status_service, in: [status: -> { value }] }.result).to be_success.with_data(value: 1)
          expect(service.collection((:success..:success)).count { |status| step status_service, in: [status: -> { status }] }.result).to be_success.with_data(value: 1)
          expect(service.collection((:failure..:failure)).count { |status| condition[status] }.result).to be_success.with_data(value: 0)

          # NOTE: Step with one output.
          expect(service.collection(enumerable([:success, :failure, :success, :failure])).count { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(value: 2)
          expect(service.collection(enumerator([:success, :failure, :success, :failure])).count { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(value: 2)
          expect(service.collection(lazy_enumerator([:success, :failure, :success, :failure])).count { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(value: 2)
          expect(service.collection(chain_enumerator([:success, :failure, :success, :failure])).count { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(value: 2)
          expect(service.collection([:success, :failure, :success, :failure]).count { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(value: 2)
          expect(service.collection(set([:success, :failure])).count { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(value: 1)

          expect(service.collection({success: :success, failure: :failure}).count { |key, value| step status_service, in: [status: -> { value }], out: :status_string }.result).to be_success.with_data(value: 1)
          expect(service.collection((:success..:success)).count { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(value: 1)
          expect(service.collection((:failure..:failure)).count { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(value: 0)

          # NOTE: Step with multiple outputs.
          expect(service.collection(enumerable([:success, :failure, :success, :failure])).count { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(value: 2)
          expect(service.collection(enumerator([:success, :failure, :success, :failure])).count { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(value: 2)
          expect(service.collection(lazy_enumerator([:success, :failure, :success, :failure])).count { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(value: 2)
          expect(service.collection(chain_enumerator([:success, :failure, :success, :failure])).count { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(value: 2)
          expect(service.collection([:success, :failure, :success, :failure]).count { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(value: 2)
          expect(service.collection(set([:success, :failure])).count { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(value: 1)

          expect(service.collection({success: :success, failure: :failure}).count { |key, value| step status_service, in: [status: -> { value }], out: [:status_string, :status_code] }.result).to be_success.with_data(value: 1)
          expect(service.collection((:success..:success)).count { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(value: 1)
          expect(service.collection((:failure..:failure)).count { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(value: 0)

          # NOTE: Error result.
          expect(service.collection(enumerable([:success, :error, :exception])).count { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection(enumerator([:success, :error, :exception])).count { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection(lazy_enumerator([:success, :error, :exception])).count { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection(chain_enumerator([:success, :error, :exception])).count { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection([:success, :error, :exception]).count { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection(set([:success, :error, :exception])).count { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data

          expect(service.collection({success: :success, error: :error, exception: :exception}).count { |key, value| step status_service, in: [status: -> { value }] }.result).to be_error.without_data
          expect(service.collection((:error..:error)).count { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data

          # NOTE: Error propagation.
          expect(service.collection(enumerable([:success, :error, :exception])).filter { |status| step status_service, in: [status: -> { status }] }.count { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection(enumerator([:success, :error, :exception])).filter { |status| step status_service, in: [status: -> { status }] }.count { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection(lazy_enumerator([:success, :error, :exception])).filter { |status| step status_service, in: [status: -> { status }] }.count { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection(chain_enumerator([:success, :error, :exception])).filter { |status| step status_service, in: [status: -> { status }] }.count { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection([:success, :error, :exception]).filter { |status| step status_service, in: [status: -> { status }] }.count { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection(set([:success, :error, :exception])).filter { |status| step status_service, in: [status: -> { status }] }.count { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data

          expect(service.collection({success: :success, error: :error, exception: :exception}).filter { |key, value| step status_service, in: [status: -> { value }] }.count { |key, value| step status_service, in: [status: -> { value }] }.result).to be_error.without_data
          expect(service.collection((:error..:error)).filter { |status| step status_service, in: [status: -> { status }] }.count { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data

          # NOTE: Usage on terminal chaining.
          expect { service.collection(enumerable([:success, :exception, :exception])).first.count.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection(enumerator([:success, :exception, :exception])).first.count.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection(lazy_enumerator([:success, :exception, :exception])).first.count.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection(chain_enumerator([:success, :exception, :exception])).first.count.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection([:success, :exception, :exception]).first.count.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection(set([:success, :exception, :exception])).first.count.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)

          expect { service.collection({success: :success, exception: :exception}).first.count.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection((:success..:success)).first.count.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
        end
      end
      # rubocop:enable Performance/Size

      describe "#cycle" do
        specify do
          # NOTE: Empty collection.
          expect([].cycle(2) { |status| condition[status] }).to eq(nil)
          expect(service.collection(enumerable([])).cycle(2) { |status| condition[status] }.result).to be_success.with_data(value: nil)
          expect(service.collection(enumerator([])).cycle(2) { |status| condition[status] }.result).to be_success.with_data(value: nil)
          expect(service.collection(lazy_enumerator([])).cycle(2) { |status| condition[status] }.result).to be_success.with_data(value: nil)
          expect(service.collection(chain_enumerator([])).cycle(2) { |status| condition[status] }.result).to be_success.with_data(value: nil)
          expect(service.collection([]).cycle(2) { |status| condition[status] }.result).to be_success.with_data(value: nil)
          expect(service.collection(set([])).cycle(2) { |status| condition[status] }.result).to be_success.with_data(value: nil)
          expect(service.collection({}).cycle(2) { |status| condition[status] }.result).to be_success.with_data(value: nil)
          expect(service.collection((:success...:success)).cycle(2) { |status| condition[status] }.result).to be_success.with_data(value: nil)

          # NOTE: No block.
          expect([:success, :success].cycle(2).to_a).to eq([:success, :success, :success, :success])
          expect(service.collection(enumerable([:success, :success])).cycle(2).result).to be_success.with_data(values: [:success, :success, :success, :success])
          expect(service.collection(enumerator([:success, :success])).cycle(2).result).to be_success.with_data(values: [:success, :success, :success, :success])
          expect(service.collection(lazy_enumerator([:success, :success])).cycle(2).result).to be_success.with_data(values: [:success, :success, :success, :success])
          expect(service.collection(chain_enumerator([:success, :success])).cycle(2).result).to be_success.with_data(values: [:success, :success, :success, :success])
          expect(service.collection([:success, :success]).cycle(2).result).to be_success.with_data(values: [:success, :success, :success, :success])

          expect(service.collection(set([:success])).cycle(2).result).to be_success.with_data(values: [:success, :success])
          expect(service.collection({success: :success}).cycle(2).result).to be_success.with_data(values: [[:success, :success], [:success, :success]])
          expect(service.collection((:success..:success)).cycle(2).result).to be_success.with_data(values: [:success, :success])

          # NOTE: Block.
          expect([:success, :success].cycle(2) { |status| condition[status] }).to eq(nil)
          expect(service.collection(enumerable([:success, :success])).cycle(2) { |status| condition[status] }.result).to be_success.with_data(value: nil)
          expect(service.collection(enumerator([:success, :success])).cycle(2) { |status| condition[status] }.result).to be_success.with_data(value: nil)
          expect(service.collection(lazy_enumerator([:success, :success])).cycle(2) { |status| condition[status] }.result).to be_success.with_data(value: nil)
          expect(service.collection(chain_enumerator([:success, :success])).cycle(2) { |status| condition[status] }.result).to be_success.with_data(value: nil)
          expect(service.collection([:success, :success]).cycle(2) { |status| condition[status] }.result).to be_success.with_data(value: nil)

          expect(service.collection(set([:success])).cycle(2) { |status| condition[status] }.result).to be_success.with_data(value: nil)
          expect(service.collection({success: :success}).cycle(2) { |key, value| condition[value] }.result).to be_success.with_data(value: nil)
          expect(service.collection((:success..:success)).cycle(2) { |status| condition[status] }.result).to be_success.with_data(value: nil)

          # NOTE: Step with no outputs.
          expect(service.collection(enumerable([:success, :success])).cycle(2) { |status| step status_service, in: [status: -> { status }] }.result).to be_success.with_data(value: nil)
          expect(service.collection(enumerator([:success, :success])).cycle(2) { |status| step status_service, in: [status: -> { status }] }.result).to be_success.with_data(value: nil)
          expect(service.collection(lazy_enumerator([:success, :success])).cycle(2) { |status| step status_service, in: [status: -> { status }] }.result).to be_success.with_data(value: nil)
          expect(service.collection(chain_enumerator([:success, :success])).cycle(2) { |status| step status_service, in: [status: -> { status }] }.result).to be_success.with_data(value: nil)
          expect(service.collection([:success, :success]).cycle(2) { |status| step status_service, in: [status: -> { status }] }.result).to be_success.with_data(value: nil)

          expect(service.collection(set([:success])).cycle(2) { |status| step status_service, in: [status: -> { status }] }.result).to be_success.with_data(value: nil)
          expect(service.collection({success: :success}).cycle(2) { |key, value| step status_service, in: [status: -> { value }] }.result).to be_success.with_data(value: nil)
          expect(service.collection((:success..:success)).cycle(2) { |status| step status_service, in: [status: -> { status }] }.result).to be_success.with_data(value: nil)

          # NOTE: Step with one output.
          expect(service.collection(enumerable([:success, :success])).cycle(2) { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(value: nil)
          expect(service.collection(enumerator([:success, :success])).cycle(2) { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(value: nil)
          expect(service.collection(lazy_enumerator([:success, :success])).cycle(2) { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(value: nil)
          expect(service.collection(chain_enumerator([:success, :success])).cycle(2) { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(value: nil)
          expect(service.collection([:success, :success]).cycle(2) { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(value: nil)

          expect(service.collection(set([:success])).cycle(2) { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(value: nil)
          expect(service.collection({success: :success}).cycle(2) { |key, value| step status_service, in: [status: -> { value }], out: :status_string }.result).to be_success.with_data(value: nil)
          expect(service.collection((:success..:success)).cycle(2) { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(value: nil)

          # NOTE: Step with multiple outputs.
          expect(service.collection(enumerable([:success, :success])).cycle(2) { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(value: nil)
          expect(service.collection(enumerator([:success, :success])).cycle(2) { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(value: nil)
          expect(service.collection(lazy_enumerator([:success, :success])).cycle(2) { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(value: nil)
          expect(service.collection(chain_enumerator([:success, :success])).cycle(2) { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(value: nil)
          expect(service.collection([:success, :success]).cycle(2) { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(value: nil)

          expect(service.collection(set([:success])).cycle(2) { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(value: nil)
          expect(service.collection({success: :success}).cycle(2) { |key, value| step status_service, in: [status: -> { value }], out: [:status_string, :status_code] }.result).to be_success.with_data(value: nil)
          expect(service.collection((:success..:success)).cycle(2) { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(value: nil)

          # NOTE: Error result.
          expect(service.collection(enumerable([:success, :error, :exception])).cycle(2) { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection(enumerator([:success, :error, :exception])).cycle(2) { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection(lazy_enumerator([:success, :error, :exception])).cycle(2) { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection(chain_enumerator([:success, :error, :exception])).cycle(2) { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection([:success, :error, :exception]).cycle(2) { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data

          expect(service.collection(set([:success, :error, :exception])).cycle(2) { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection({success: :success, error: :error, exception: :exception}).cycle(2) { |key, value| step status_service, in: [status: -> { value }] }.result).to be_error.without_data
          expect(service.collection((:error..:error)).cycle(2) { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data

          # NOTE: Error propagation.
          expect(service.collection(enumerable([:success, :error, :exception])).select { |status| step status_service, in: [status: -> { status }] }.cycle(2) { |status| condition[status] }.result).to be_error.without_data
          expect(service.collection(enumerator([:success, :error, :exception])).select { |status| step status_service, in: [status: -> { status }] }.cycle(2) { |status| condition[status] }.result).to be_error.without_data
          expect(service.collection(lazy_enumerator([:success, :error, :exception])).select { |status| step status_service, in: [status: -> { status }] }.cycle(2) { |status| condition[status] }.result).to be_error.without_data
          expect(service.collection(chain_enumerator([:success, :error, :exception])).select { |status| step status_service, in: [status: -> { status }] }.cycle(2) { |status| condition[status] }.result).to be_error.without_data
          expect(service.collection([:success, :error, :exception]).select { |status| step status_service, in: [status: -> { status }] }.cycle(2) { |status| condition[status] }.result).to be_error.without_data

          expect(service.collection(set([:success, :error, :exception])).select { |status| step status_service, in: [status: -> { status }] }.cycle(2) { |status| condition[status] }.result).to be_error.without_data
          expect(service.collection({success: :success, error: :error, exception: :exception}).select { |key, value| step status_service, in: [status: -> { value }] }.cycle(2) { |key, value| condition[value] }.result).to be_error.without_data
          expect(service.collection((:error..:error)).select { |status| step status_service, in: [status: -> { status }] }.cycle(2) { |status| condition[status] }.result).to be_error.without_data

          # NOTE: Usage on terminal chaining.
          expect { service.collection(enumerable([:success, :exception, :exception])).first.cycle(2) { |status| condition[status] }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection(enumerator([:success, :exception, :exception])).first.cycle(2) { |status| condition[status] }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection(lazy_enumerator([:success, :exception, :exception])).first.cycle(2) { |status| condition[status] }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection(chain_enumerator([:success, :exception, :exception])).first.cycle(2) { |status| condition[status] }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection([:success, :exception, :exception]).first.cycle(2) { |status| condition[status] }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)

          expect { service.collection(set([:success, :exception, :exception])).first.cycle(2) { |status| condition[status] }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection({success: :success, exception: :exception}).first.cycle(2) { |key, value| condition[value] }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection((:success..:success)).first.cycle(2) { |status| condition[status] }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
        end
      end

      describe "#detect" do
        specify do
          # NOTE: Empty collection.
          expect([].detect { |status| condition[status] }).to eq(nil)
          expect(service.collection(enumerable([])).detect { |status| condition[status] }.result).to be_failure.without_data
          expect(service.collection(enumerator([])).detect { |status| condition[status] }.result).to be_failure.without_data
          expect(service.collection(lazy_enumerator([])).detect { |status| condition[status] }.result).to be_failure.without_data
          expect(service.collection(chain_enumerator([])).detect { |status| condition[status] }.result).to be_failure.without_data
          expect(service.collection([]).detect { |status| condition[status] }.result).to be_failure.without_data
          expect(service.collection({}).detect { |status| condition[status] }.result).to be_failure.without_data
          expect(service.collection((:success...:success)).detect { |status| condition[status] }.result).to be_failure.without_data
          expect(service.collection(set([])).detect { |status| condition[status] }.result).to be_failure.without_data

          # NOTE: No block.
          expect([:success].detect.to_a).to eq([:success])
          expect(service.collection(enumerable([:success])).detect.result).to be_success.with_data(values: [:success])
          expect(service.collection(enumerator([:success])).detect.result).to be_success.with_data(values: [:success])
          expect(service.collection(lazy_enumerator([:success])).detect.result).to be_success.with_data(values: [:success])
          expect(service.collection(chain_enumerator([:success])).detect.result).to be_success.with_data(values: [:success])
          expect(service.collection([:success]).detect.result).to be_success.with_data(values: [:success])
          expect(service.collection(set([:success])).detect.result).to be_success.with_data(values: [:success])
          expect(service.collection({success: :success}).detect.result).to be_success.with_data(values: [[:success, :success]])
          expect(service.collection((:success..:success)).detect.result).to be_success.with_data(values: [:success])

          # NOTE: Matched block.
          expect([:failure, :success, :exception].detect { |status| condition[status] }).to eq(:success)
          expect(service.collection(enumerable([:failure, :success, :exception])).detect { |status| condition[status] }.result).to be_success.with_data(value: :success)
          expect(service.collection(enumerator([:failure, :success, :exception])).detect { |status| condition[status] }.result).to be_success.with_data(value: :success)
          expect(service.collection(lazy_enumerator([:failure, :success, :exception])).detect { |status| condition[status] }.result).to be_success.with_data(value: :success)
          expect(service.collection(chain_enumerator([:failure, :success, :exception])).detect { |status| condition[status] }.result).to be_success.with_data(value: :success)
          expect(service.collection([:failure, :success, :exception]).detect { |status| condition[status] }.result).to be_success.with_data(value: :success)
          expect(service.collection(set([:failure, :success, :exception])).detect { |status| condition[status] }.result).to be_success.with_data(value: :success)

          expect(service.collection({success: :success}).detect { |key, value| condition[value] }.result).to be_success.with_data(value: [:success, :success])
          expect(service.collection((:success..:success)).detect { |status| condition[status] }.result).to be_success.with_data(value: :success)

          # NOTE: Not matched block.
          expect([:failure, :failure, :failure].detect { |status| condition[status] }).to eq(nil)
          expect(service.collection(enumerable([:failure, :failure, :failure])).detect { |status| condition[status] }.result).to be_failure.without_data
          expect(service.collection(enumerator([:failure, :failure, :failure])).detect { |status| condition[status] }.result).to be_failure.without_data
          expect(service.collection(lazy_enumerator([:failure, :failure, :failure])).detect { |status| condition[status] }.result).to be_failure.without_data
          expect(service.collection(chain_enumerator([:failure, :failure, :failure])).detect { |status| condition[status] }.result).to be_failure.without_data
          expect(service.collection([:failure, :failure, :failure]).detect { |status| condition[status] }.result).to be_failure.without_data
          expect(service.collection(set([:failure, :failure, :failure])).detect { |status| condition[status] }.result).to be_failure.without_data

          expect(service.collection({failure: :failure}).detect { |key, value| condition[value] }.result).to be_failure.without_data
          expect(service.collection((:failure..:failure)).detect { |status| condition[status] }.result).to be_failure.without_data

          # NOTE: Not matched block with ifnode.
          expect([:failure, :failure, :failure].detect(-> { :default }) { |status| condition[status] }).to eq(:default)
          expect(service.collection(enumerable([:failure, :failure, :failure])).detect(-> { :default }) { |status| condition[status] }.result).to be_success.with_data(value: :default)
          expect(service.collection(enumerator([:failure, :failure, :failure])).detect(-> { :default }) { |status| condition[status] }.result).to be_success.with_data(value: :default)
          expect(service.collection(lazy_enumerator([:failure, :failure, :failure])).detect(-> { :default }) { |status| condition[status] }.result).to be_success.with_data(value: :default)
          expect(service.collection(chain_enumerator([:failure, :failure, :failure])).detect(-> { :default }) { |status| condition[status] }.result).to be_success.with_data(value: :default)
          expect(service.collection([:failure, :failure, :failure]).detect(-> { :default }) { |status| condition[status] }.result).to be_success.with_data(value: :default)
          expect(service.collection(set([:failure, :failure, :failure])).detect(-> { :default }) { |status| condition[status] }.result).to be_success.with_data(value: :default)

          expect(service.collection({failure: :failure}).detect(-> { :default }) { |key, value| condition[value] }.result).to be_success.with_data(value: :default)
          expect(service.collection((:failure..:failure)).detect(-> { :default }) { |status| condition[status] }.result).to be_success.with_data(value: :default)

          # NOTE: Matched step with no outputs.
          expect(service.collection(enumerable([:failure, :success, :exception])).detect { |status| step status_service, in: [status: -> { status }] }.result).to be_success.with_data(value: :success)
          expect(service.collection(enumerator([:failure, :success, :exception])).detect { |status| step status_service, in: [status: -> { status }] }.result).to be_success.with_data(value: :success)
          expect(service.collection(lazy_enumerator([:failure, :success, :exception])).detect { |status| step status_service, in: [status: -> { status }] }.result).to be_success.with_data(value: :success)
          expect(service.collection(chain_enumerator([:failure, :success, :exception])).detect { |status| step status_service, in: [status: -> { status }] }.result).to be_success.with_data(value: :success)
          expect(service.collection([:failure, :success, :exception]).detect { |status| step status_service, in: [status: -> { status }] }.result).to be_success.with_data(value: :success)
          expect(service.collection(set([:failure, :success, :exception])).detect { |status| step status_service, in: [status: -> { status }] }.result).to be_success.with_data(value: :success)

          expect(service.collection({success: :success}).detect { |key, value| step status_service, in: [status: -> { value }] }.result).to be_success.with_data(value: [:success, :success])
          expect(service.collection((:success..:success)).detect { |status| step status_service, in: [status: -> { status }] }.result).to be_success.with_data(value: :success)

          # NOTE: Not matched step with no outputs.
          expect(service.collection(enumerable([:failure, :failure, :failure])).detect { |status| step status_service, in: [status: -> { status }] }.result).to be_failure.without_data
          expect(service.collection(enumerator([:failure, :failure, :failure])).detect { |status| step status_service, in: [status: -> { status }] }.result).to be_failure.without_data
          expect(service.collection(lazy_enumerator([:failure, :failure, :failure])).detect { |status| step status_service, in: [status: -> { status }] }.result).to be_failure.without_data
          expect(service.collection(chain_enumerator([:failure, :failure, :failure])).detect { |status| step status_service, in: [status: -> { status }] }.result).to be_failure.without_data
          expect(service.collection([:failure, :failure, :failure]).detect { |status| step status_service, in: [status: -> { status }] }.result).to be_failure.without_data
          expect(service.collection(set([:failure, :failure, :failure])).detect { |status| step status_service, in: [status: -> { status }] }.result).to be_failure.without_data

          expect(service.collection({failure: :failure}).detect { |key, value| step status_service, in: [status: -> { value }] }.result).to be_failure.without_data
          expect(service.collection((:failure..:failure)).detect { |status| step status_service, in: [status: -> { status }] }.result).to be_failure.without_data

          # NOTE: Not matched step with no outputs with ifnode.
          expect(service.collection(enumerable([:failure, :failure, :failure])).detect(-> { :default }) { |status| step status_service, in: [status: -> { status }] }.result).to be_success.with_data(value: :default)
          expect(service.collection(enumerator([:failure, :failure, :failure])).detect(-> { :default }) { |status| step status_service, in: [status: -> { status }] }.result).to be_success.with_data(value: :default)
          expect(service.collection(lazy_enumerator([:failure, :failure, :failure])).detect(-> { :default }) { |status| step status_service, in: [status: -> { status }] }.result).to be_success.with_data(value: :default)
          expect(service.collection(chain_enumerator([:failure, :failure, :failure])).detect(-> { :default }) { |status| step status_service, in: [status: -> { status }] }.result).to be_success.with_data(value: :default)
          expect(service.collection([:failure, :failure, :failure]).detect(-> { :default }) { |status| step status_service, in: [status: -> { status }] }.result).to be_success.with_data(value: :default)
          expect(service.collection(set([:failure, :failure, :failure])).detect(-> { :default }) { |status| step status_service, in: [status: -> { status }] }.result).to be_success.with_data(value: :default)

          expect(service.collection({failure: :failure}).detect(-> { :default }) { |key, value| step status_service, in: [status: -> { value }] }.result).to be_success.with_data(value: :default)
          expect(service.collection((:failure..:failure)).detect(-> { :default }) { |status| step status_service, in: [status: -> { status }] }.result).to be_success.with_data(value: :default)

          # NOTE: Matched step with one output.
          expect(service.collection(enumerable([:failure, :success, :exception])).detect { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(value: :success)
          expect(service.collection(enumerator([:failure, :success, :exception])).detect { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(value: :success)
          expect(service.collection(lazy_enumerator([:failure, :success, :exception])).detect { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(value: :success)
          expect(service.collection(chain_enumerator([:failure, :success, :exception])).detect { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(value: :success)
          expect(service.collection([:failure, :success, :exception]).detect { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(value: :success)
          expect(service.collection(set([:failure, :success, :exception])).detect { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(value: :success)

          expect(service.collection({success: :success}).detect { |key, value| step status_service, in: [status: -> { value }], out: :status_string }.result).to be_success.with_data(value: [:success, :success])
          expect(service.collection((:success..:success)).detect { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(value: :success)

          # NOTE: Not matched step with one output.
          expect(service.collection(enumerable([:failure, :failure, :failure])).detect { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_failure.without_data
          expect(service.collection(enumerator([:failure, :failure, :failure])).detect { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_failure.without_data
          expect(service.collection(lazy_enumerator([:failure, :failure, :failure])).detect { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_failure.without_data
          expect(service.collection(chain_enumerator([:failure, :failure, :failure])).detect { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_failure.without_data
          expect(service.collection([:failure, :failure, :failure]).detect { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_failure.without_data
          expect(service.collection(set([:failure, :failure, :failure])).detect { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_failure.without_data

          expect(service.collection({failure: :failure}).detect { |key, value| step status_service, in: [status: -> { value }], out: :status_string }.result).to be_failure.without_data
          expect(service.collection((:failure..:failure)).detect { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_failure.without_data

          # NOTE: Not matched step with one output with ifnode.
          expect(service.collection(enumerable([:failure, :failure, :failure])).detect(-> { :default }) { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(value: :default)
          expect(service.collection(enumerator([:failure, :failure, :failure])).detect(-> { :default }) { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(value: :default)
          expect(service.collection(lazy_enumerator([:failure, :failure, :failure])).detect(-> { :default }) { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(value: :default)
          expect(service.collection(chain_enumerator([:failure, :failure, :failure])).detect(-> { :default }) { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(value: :default)
          expect(service.collection([:failure, :failure, :failure]).detect(-> { :default }) { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(value: :default)
          expect(service.collection(set([:failure, :failure, :failure])).detect(-> { :default }) { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(value: :default)

          expect(service.collection({failure: :failure}).detect(-> { :default }) { |key, value| step status_service, in: [status: -> { value }], out: :status_string }.result).to be_success.with_data(value: :default)
          expect(service.collection((:failure..:failure)).detect(-> { :default }) { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(value: :default)

          # NOTE: Matched step with multiple outputs.
          expect(service.collection(enumerable([:failure, :success, :exception])).detect { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(value: :success)
          expect(service.collection(enumerator([:failure, :success, :exception])).detect { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(value: :success)
          expect(service.collection(lazy_enumerator([:failure, :success, :exception])).detect { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(value: :success)
          expect(service.collection(chain_enumerator([:failure, :success, :exception])).detect { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(value: :success)
          expect(service.collection([:failure, :success, :exception]).detect { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(value: :success)
          expect(service.collection(set([:failure, :success, :exception])).detect { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(value: :success)

          expect(service.collection({success: :success}).detect { |key, value| step status_service, in: [status: -> { value }], out: [:status_string, :status_code] }.result).to be_success.with_data(value: [:success, :success])
          expect(service.collection((:success..:success)).detect { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(value: :success)

          # NOTE: Not matched step with multiple outputs.
          expect(service.collection(enumerable([:failure, :failure, :failure])).detect { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_failure.without_data
          expect(service.collection(enumerator([:failure, :failure, :failure])).detect { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_failure.without_data
          expect(service.collection(lazy_enumerator([:failure, :failure, :failure])).detect { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_failure.without_data
          expect(service.collection(chain_enumerator([:failure, :failure, :failure])).detect { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_failure.without_data
          expect(service.collection([:failure, :failure, :failure]).detect { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_failure.without_data
          expect(service.collection(set([:failure, :failure, :failure])).detect { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_failure.without_data

          expect(service.collection({failure: :failure}).detect { |key, value| step status_service, in: [status: -> { value }], out: [:status_string, :status_code] }.result).to be_failure.without_data
          expect(service.collection((:failure..:failure)).detect { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_failure.without_data

          # NOTE: Not matched step with multiple outputs with ifnode.
          expect(service.collection(enumerable([:failure, :failure, :failure])).detect(-> { :default }) { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(value: :default)
          expect(service.collection(enumerator([:failure, :failure, :failure])).detect(-> { :default }) { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(value: :default)
          expect(service.collection(lazy_enumerator([:failure, :failure, :failure])).detect(-> { :default }) { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(value: :default)
          expect(service.collection(chain_enumerator([:failure, :failure, :failure])).detect(-> { :default }) { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(value: :default)
          expect(service.collection([:failure, :failure, :failure]).detect(-> { :default }) { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(value: :default)
          expect(service.collection(set([:failure, :failure, :failure])).detect(-> { :default }) { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(value: :default)

          expect(service.collection({failure: :failure}).detect(-> { :default }) { |key, value| step status_service, in: [status: -> { value }], out: [:status_string, :status_code] }.result).to be_success.with_data(value: :default)
          expect(service.collection((:failure..:failure)).detect(-> { :default }) { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(value: :default)

          # NOTE: Error result.
          expect(service.collection(enumerable([:failure, :error, :exception])).detect { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection(enumerator([:failure, :error, :exception])).detect { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection(lazy_enumerator([:failure, :error, :exception])).detect { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection(chain_enumerator([:failure, :error, :exception])).detect { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection([:failure, :error, :exception]).detect { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection(set([:failure, :error, :exception])).detect { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data

          expect(service.collection({failure: :failure, error: :error, exception: :exception}).detect { |key, value| step status_service, in: [status: -> { value }] }.result).to be_error.without_data
          expect(service.collection((:error..:error)).detect { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data

          # NOTE: Error propagation.
          expect(service.collection(enumerable([:failure, :error, :exception])).select { |status| step status_service, in: [status: -> { status }] }.detect { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection(enumerator([:failure, :error, :exception])).select { |status| step status_service, in: [status: -> { status }] }.detect { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection(lazy_enumerator([:failure, :error, :exception])).select { |status| step status_service, in: [status: -> { status }] }.detect { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection(chain_enumerator([:failure, :error, :exception])).select { |status| step status_service, in: [status: -> { status }] }.detect { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection([:failure, :error, :exception]).select { |status| step status_service, in: [status: -> { status }] }.detect { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection(set([:failure, :error, :exception])).select { |status| step status_service, in: [status: -> { status }] }.detect { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data

          expect(service.collection({failure: :failure, error: :error, exception: :exception}).select { |key, value| step status_service, in: [status: -> { value }] }.detect { |key, value| step status_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection((:error..:error)).select { |status| step status_service, in: [status: -> { status }] }.detect { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data

          # NOTE: Usage on terminal chaining.
          expect { service.collection(enumerable([:success, :exception, :exception])).first.detect { |status| condition[status] }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection(enumerator([:success, :exception, :exception])).first.detect { |status| condition[status] }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection(lazy_enumerator([:success, :exception, :exception])).first.detect { |status| condition[status] }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection(chain_enumerator([:success, :exception, :exception])).first.detect { |status| condition[status] }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection([:success, :exception, :exception]).first.detect { |status| condition[status] }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection(set([:success, :exception, :exception])).first.detect { |status| condition[status] }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)

          expect { service.collection({success: :success, exception: :exception}).first.detect { |status| condition[status] }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection((:success..:success)).first.detect { |status| condition[status] }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
        end
      end

      describe "#drop" do
        specify do
          # NOTE: Empty collection.
          expect([].drop(2)).to eq([])
          expect(service.collection(enumerable([])).drop(2).result).to be_success.with_data(values: [])
          expect(service.collection(enumerator([])).drop(2).result).to be_success.with_data(values: [])
          expect(service.collection(lazy_enumerator([])).drop(2).result).to be_success.with_data(values: [])
          expect(service.collection(chain_enumerator([])).drop(2).result).to be_success.with_data(values: [])
          expect(service.collection([]).drop(2).result).to be_success.with_data(values: [])
          expect(service.collection({}).drop(2).result).to be_success.with_data(values: [])
          expect(service.collection((:success...:success)).drop(2).result).to be_success.with_data(values: [])
          expect(service.collection(set([])).drop(2).result).to be_success.with_data(values: [])

          # NOTE: 0.
          expect([:success, :success, :failure, :failure].drop(0)).to eq([:success, :success, :failure, :failure])
          expect(service.collection(enumerable([:success, :success, :failure, :failure])).drop(0).result).to be_success.with_data(values: [:success, :success, :failure, :failure])
          expect(service.collection(enumerator([:success, :success, :failure, :failure])).drop(0).result).to be_success.with_data(values: [:success, :success, :failure, :failure])
          expect(service.collection(lazy_enumerator([:success, :success, :failure, :failure])).drop(0).result).to be_success.with_data(values: [:success, :success, :failure, :failure])
          expect(service.collection(chain_enumerator([:success, :success, :failure, :failure])).drop(0).result).to be_success.with_data(values: [:success, :success, :failure, :failure])
          expect(service.collection([:success, :success, :failure, :failure]).drop(0).result).to be_success.with_data(values: [:success, :success, :failure, :failure])
          expect(service.collection(set([:success, :failure])).drop(0).result).to be_success.with_data(values: [:success, :failure])
          expect(service.collection({success: :success, failure: :failure}).drop(0).result).to be_success.with_data(values: [[:success, :success], [:failure, :failure]])
          expect(service.collection((:success..:success)).drop(0).result).to be_success.with_data(values: [:success])

          # NOTE: n.
          expect([:success, :success, :failure, :failure].drop(2)).to eq([:failure, :failure])
          expect(service.collection(enumerable([:success, :success, :failure, :failure])).drop(2).result).to be_success.with_data(values: [:failure, :failure])
          expect(service.collection(enumerator([:success, :success, :failure, :failure])).drop(2).result).to be_success.with_data(values: [:failure, :failure])
          expect(service.collection(lazy_enumerator([:success, :success, :failure, :failure])).drop(2).result).to be_success.with_data(values: [:failure, :failure])
          expect(service.collection(chain_enumerator([:success, :success, :failure, :failure])).drop(2).result).to be_success.with_data(values: [:failure, :failure])
          expect(service.collection([:success, :success, :failure, :failure]).drop(2).result).to be_success.with_data(values: [:failure, :failure])
          expect(service.collection(set([:success, :failure])).drop(1).result).to be_success.with_data(values: [:failure])
          expect(service.collection({success: :success, failure: :failure}).drop(1).result).to be_success.with_data(values: [[:failure, :failure]])
          expect(service.collection((:success..:success)).drop(1).result).to be_success.with_data(values: [])

          # NOTE: Error propagation.
          expect(service.collection(enumerable([:success, :error, :exception])).select { |status| step status_service, in: [status: -> { status }] }.drop(2).result).to be_error.without_data
          expect(service.collection(enumerator([:success, :error, :exception])).select { |status| step status_service, in: [status: -> { status }] }.drop(2).result).to be_error.without_data
          expect(service.collection(lazy_enumerator([:success, :error, :exception])).select { |status| step status_service, in: [status: -> { status }] }.drop(2).result).to be_error.without_data
          expect(service.collection(chain_enumerator([:success, :error, :exception])).select { |status| step status_service, in: [status: -> { status }] }.drop(2).result).to be_error.without_data
          expect(service.collection([:success, :error, :exception]).select { |status| step status_service, in: [status: -> { status }] }.drop(2).result).to be_error.without_data
          expect(service.collection(set([:success, :error, :exception])).select { |status| step status_service, in: [status: -> { status }] }.drop(2).result).to be_error.without_data

          expect(service.collection({success: :success, error: :error, exception: :exception}).select { |key, value| step status_service, in: [status: -> { value }] }.drop(2).result).to be_error.without_data
          expect(service.collection((:error..:error)).select { |status| step status_service, in: [status: -> { status }] }.drop(2).result).to be_error.without_data

          # NOTE: Usage on terminal chaining.
          expect { service.collection(enumerable([:success, :exception, :exception])).first.drop(2).result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection(enumerator([:success, :exception, :exception])).first.drop(2).result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection(lazy_enumerator([:success, :exception, :exception])).first.drop(2).result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection(chain_enumerator([:success, :exception, :exception])).first.drop(2).result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection([:success, :exception, :exception]).first.drop(2).result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection(set([:success, :exception, :exception])).first.drop(2).result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)

          expect { service.collection({success: :success, exception: :exception}).first.drop(2).result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection((:success..:success)).first.drop(2).result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
        end
      end

      describe "#drop_while" do
        specify do
          # NOTE: Empty collection.
          expect([].drop_while { |status| condition[status] }).to eq([])
          expect(service.collection(enumerable([])).drop_while { |status| condition[status] }.result).to be_success.with_data(values: [])
          expect(service.collection(enumerator([])).drop_while { |status| condition[status] }.result).to be_success.with_data(values: [])
          expect(service.collection(lazy_enumerator([])).drop_while { |status| condition[status] }.result).to be_success.with_data(values: [])
          expect(service.collection(chain_enumerator([])).drop_while { |status| condition[status] }.result).to be_success.with_data(values: [])
          expect(service.collection([]).drop_while { |status| condition[status] }.result).to be_success.with_data(values: [])
          expect(service.collection(set([])).drop_while { |status| condition[status] }.result).to be_success.with_data(values: [])
          expect(service.collection({}).drop_while { |status| condition[status] }.result).to be_success.with_data(values: [])
          expect(service.collection((:success...:success)).drop_while { |status| condition[status] }.result).to be_success.with_data(values: [])

          # NOTE: No block.
          expect([:success, :success, :success].drop_while.to_a).to eq([:success])
          expect(service.collection(enumerable([:success, :success, :success])).drop_while.result).to be_success.with_data(values: [:success])
          expect(service.collection(enumerator([:success, :success, :success])).drop_while.result).to be_success.with_data(values: [:success])
          expect { service.collection(lazy_enumerator([:success, :success, :success])).drop_while.result }.to raise_error(ArgumentError).with_message("tried to call lazy drop_while without a block")
          expect(service.collection(chain_enumerator([:success, :success, :success])).drop_while.result).to be_success.with_data(values: [:success])
          expect(service.collection([:success, :success, :success]).drop_while.result).to be_success.with_data(values: [:success])

          expect(service.collection(set([:success, :failure])).drop_while.result).to be_success.with_data(values: [:success])
          expect(service.collection({success: :success, failure: :failure}).drop_while.result).to be_success.with_data(values: [[:success, :success]])
          expect(service.collection((:success..:success)).drop_while.result).to be_success.with_data(values: [:success])

          # NOTE: Block.
          expect([:success, :success, :failure, :exception].drop_while { |status| condition[status] }).to eq([:failure, :exception])
          expect(service.collection(enumerable([:success, :success, :failure, :exception])).drop_while { |status| condition[status] }.result).to be_success.with_data(values: [:failure, :exception])
          expect(service.collection(enumerator([:success, :success, :failure, :exception])).drop_while { |status| condition[status] }.result).to be_success.with_data(values: [:failure, :exception])
          expect(service.collection(lazy_enumerator([:success, :success, :failure, :exception])).drop_while { |status| condition[status] }.result).to be_success.with_data(values: [:failure, :exception])
          expect(service.collection(chain_enumerator([:success, :success, :failure, :exception])).drop_while { |status| condition[status] }.result).to be_success.with_data(values: [:failure, :exception])
          expect(service.collection([:success, :success, :failure, :exception]).drop_while { |status| condition[status] }.result).to be_success.with_data(values: [:failure, :exception])

          expect(service.collection(set([:success, :failure])).drop_while { |status| condition[status] }.result).to be_success.with_data(values: [:failure])
          expect(service.collection({success: :success, failure: :failure, exception: :exception}).drop_while { |key, value| condition[value] }.result).to be_success.with_data(values: [[:failure, :failure], [:exception, :exception]])
          expect(service.collection((:success..:success)).drop_while { |status| condition[status] }.result).to be_success.with_data(values: [])
          expect(service.collection((:failure..:failure)).drop_while { |status| condition[status] }.result).to be_success.with_data(values: [:failure])

          # NOTE: Step with no outputs.
          expect(service.collection(enumerable([:success, :success, :failure, :exception])).drop_while { |status| step status_service, in: [status: -> { status }] }.result).to be_success.with_data(values: [:failure, :exception])
          expect(service.collection(enumerator([:success, :success, :failure, :exception])).drop_while { |status| step status_service, in: [status: -> { status }] }.result).to be_success.with_data(values: [:failure, :exception])
          expect(service.collection(lazy_enumerator([:success, :success, :failure, :exception])).drop_while { |status| step status_service, in: [status: -> { status }] }.result).to be_success.with_data(values: [:failure, :exception])
          expect(service.collection(chain_enumerator([:success, :success, :failure, :exception])).drop_while { |status| step status_service, in: [status: -> { status }] }.result).to be_success.with_data(values: [:failure, :exception])
          expect(service.collection([:success, :success, :failure, :exception]).drop_while { |status| step status_service, in: [status: -> { status }] }.result).to be_success.with_data(values: [:failure, :exception])

          expect(service.collection(set([:success, :failure])).drop_while { |status| step status_service, in: [status: -> { status }] }.result).to be_success.with_data(values: [:failure])
          expect(service.collection({success: :success, failure: :failure, exception: :exception}).drop_while { |key, value| step status_service, in: [status: -> { value }] }.result).to be_success.with_data(values: [[:failure, :failure], [:exception, :exception]])
          expect(service.collection((:success..:success)).drop_while { |status| step status_service, in: [status: -> { status }] }.result).to be_success.with_data(values: [])
          expect(service.collection((:failure..:failure)).drop_while { |status| step status_service, in: [status: -> { status }] }.result).to be_success.with_data(values: [:failure])

          # NOTE: Step with one output.
          expect(service.collection(enumerable([:success, :success, :failure, :exception])).drop_while { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(values: [:failure, :exception])
          expect(service.collection(enumerator([:success, :success, :failure, :exception])).drop_while { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(values: [:failure, :exception])
          expect(service.collection(lazy_enumerator([:success, :success, :failure, :exception])).drop_while { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(values: [:failure, :exception])
          expect(service.collection(chain_enumerator([:success, :success, :failure, :exception])).drop_while { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(values: [:failure, :exception])
          expect(service.collection([:success, :success, :failure, :exception]).drop_while { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(values: [:failure, :exception])

          expect(service.collection(set([:success, :failure])).drop_while { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(values: [:failure])
          expect(service.collection({success: :success, failure: :failure, exception: :exception}).drop_while { |key, value| step status_service, in: [status: -> { value }], out: :status_string }.result).to be_success.with_data(values: [[:failure, :failure], [:exception, :exception]])
          expect(service.collection((:success..:success)).drop_while { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(values: [])
          expect(service.collection((:failure..:failure)).drop_while { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(values: [:failure])

          # NOTE: Step with multiple outputs.
          expect(service.collection(enumerable([:success, :success, :failure, :exception])).drop_while { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [:failure, :exception])
          expect(service.collection(enumerator([:success, :success, :failure, :exception])).drop_while { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [:failure, :exception])
          expect(service.collection(lazy_enumerator([:success, :success, :failure, :exception])).drop_while { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [:failure, :exception])
          expect(service.collection(chain_enumerator([:success, :success, :failure, :exception])).drop_while { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [:failure, :exception])
          expect(service.collection([:success, :success, :failure, :exception]).drop_while { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [:failure, :exception])

          expect(service.collection(set([:success, :failure])).drop_while { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [:failure])
          expect(service.collection({success: :success, failure: :failure, exception: :exception}).drop_while { |key, value| step status_service, in: [status: -> { value }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [[:failure, :failure], [:exception, :exception]])
          expect(service.collection((:success..:success)).drop_while { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [])
          expect(service.collection((:failure..:failure)).drop_while { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [:failure])

          # NOTE: Error result.
          expect(service.collection(enumerable([:success, :error, :exception])).drop_while { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection(enumerator([:success, :error, :exception])).drop_while { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection(lazy_enumerator([:success, :error, :exception])).drop_while { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection(chain_enumerator([:success, :error, :exception])).drop_while { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection([:success, :error, :exception]).drop_while { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data

          expect(service.collection(set([:success, :error, :exception])).drop_while { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection({success: :success, error: :error, exception: :exception}).drop_while { |key, value| step status_service, in: [status: -> { value }] }.result).to be_error.without_data
          expect(service.collection((:error..:error)).drop_while { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data

          # NOTE: Error propagation.
          expect(service.collection(enumerable([:success, :error, :exception])).filter { |status| step status_service, in: [status: -> { status }] }.drop_while { |status| condition[status] }.result).to be_error.without_data
          expect(service.collection(enumerator([:success, :error, :exception])).filter { |status| step status_service, in: [status: -> { status }] }.drop_while { |status| condition[status] }.result).to be_error.without_data
          expect(service.collection(lazy_enumerator([:success, :error, :exception])).filter { |status| step status_service, in: [status: -> { status }] }.drop_while { |status| condition[status] }.result).to be_error.without_data
          expect(service.collection(chain_enumerator([:success, :error, :exception])).filter { |status| step status_service, in: [status: -> { status }] }.drop_while { |status| condition[status] }.result).to be_error.without_data
          expect(service.collection([:success, :error, :exception]).filter { |status| step status_service, in: [status: -> { status }] }.drop_while { |status| condition[status] }.result).to be_error.without_data

          expect(service.collection(set([:success, :error, :exception])).filter { |status| step status_service, in: [status: -> { status }] }.drop_while { |status| condition[status] }.result).to be_error.without_data
          expect(service.collection({success: :success, error: :error, exception: :exception}).filter { |key, value| step status_service, in: [status: -> { value }] }.drop_while { |key, value| condition[value] }.result).to be_error.without_data
          expect(service.collection((:error..:error)).filter { |status| step status_service, in: [status: -> { status }] }.drop_while { |status| condition[status] }.result).to be_error.without_data

          # NOTE: Usage on terminal chaining.
          expect { service.collection(enumerable([:success, :exception, :exception])).first.drop_while { |status| condition[status] }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection(enumerator([:success, :exception, :exception])).first.drop_while { |status| condition[status] }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection(lazy_enumerator([:success, :exception, :exception])).first.drop_while { |status| condition[status] }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection(chain_enumerator([:success, :exception, :exception])).first.drop_while { |status| condition[status] }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection([:success, :exception, :exception]).first.drop_while { |status| condition[status] }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)

          expect { service.collection(set([:success, :exception, :exception])).first.drop_while { |status| condition[status] }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection({success: :success, exception: :exception}).first.drop_while { |key, value| condition[value] }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection((:success..:success)).first.drop_while { |status| condition[status] }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
        end
      end

      describe "#each_cons" do
        specify do
          # NOTE: Empty collection.
          expect([].each_cons(2) { |status| condition[status] }).to eq([])
          expect(service.collection(enumerable([])).each_cons(2) { |status| condition[status] }.result).to be_success.with_data(values: [])
          expect(service.collection(enumerator([])).each_cons(2) { |status| condition[status] }.result).to be_success.with_data(values: [])
          expect(service.collection(lazy_enumerator([])).each_cons(2) { |status| condition[status] }.result).to be_success.with_data(values: [])
          expect(service.collection(chain_enumerator([])).each_cons(2) { |status| condition[status] }.result).to be_success.with_data(values: [])
          expect(service.collection([]).each_cons(2) { |status| condition[status] }.result).to be_success.with_data(values: [])
          expect(service.collection(set([])).each_cons(2) { |status| condition[status] }.result).to be_success.with_data(values: [])
          expect(service.collection({}).each_cons(2) { |status| condition[status] }.result).to be_success.with_data(values: [])
          expect(service.collection((:success...:success)).each_cons(2) { |status| condition[status] }.result).to be_success.with_data(values: [])

          # NOTE: No block.
          expect([0, 1, 2, 3, 4, 5].each_cons(2).to_a).to eq([[0, 1], [1, 2], [2, 3], [3, 4], [4, 5]])
          expect(service.collection(enumerable([0, 1, 2, 3, 4, 5])).each_cons(2).result).to be_success.with_data(values: [[0, 1], [1, 2], [2, 3], [3, 4], [4, 5]])
          expect(service.collection(enumerator([0, 1, 2, 3, 4, 5])).each_cons(2).result).to be_success.with_data(values: [[0, 1], [1, 2], [2, 3], [3, 4], [4, 5]])
          expect(lazy_enumerator([0, 1, 2, 3, 4, 5]).each_cons(2).to_a).to eq([[0, 1], [1, 2], [2, 3], [3, 4], [4, 5]])
          expect(service.collection(lazy_enumerator([0, 1, 2, 3, 4, 5])).each_cons(2).result).to be_success.with_data(values: [[0, 1], [1, 2], [2, 3], [3, 4], [4, 5]])
          expect(service.collection(chain_enumerator([0, 1, 2, 3, 4, 5])).each_cons(2).result).to be_success.with_data(values: [[0, 1], [1, 2], [2, 3], [3, 4], [4, 5]])
          expect(service.collection([0, 1, 2, 3, 4, 5]).each_cons(2).result).to be_success.with_data(values: [[0, 1], [1, 2], [2, 3], [3, 4], [4, 5]])

          # NOTE: Block.
          expect([0, 1, 2, 3, 4, 5].each_cons(2) { |numbers| numbers.map(&:to_s).map(&:ord) }).to eq([0, 1, 2, 3, 4, 5])
          expect(service.collection(enumerable([0, 1, 2, 3, 4, 5])).each_cons(2) { |numbers| numbers.map(&:to_s).map(&:ord) }.result).to be_success.with_data(values: [0, 1, 2, 3, 4, 5])
          expect(service.collection(enumerator([0, 1, 2, 3, 4, 5])).each_cons(2) { |numbers| numbers.map(&:to_s).map(&:ord) }.result).to be_success.with_data(values: [0, 1, 2, 3, 4, 5])
          expect(service.collection(lazy_enumerator([0, 1, 2, 3, 4, 5])).each_cons(2) { |numbers| numbers.map(&:to_s).map(&:ord) }.result).to be_success.with_data(values: [0, 1, 2, 3, 4, 5])
          expect(service.collection(chain_enumerator([0, 1, 2, 3, 4, 5])).each_cons(2) { |numbers| numbers.map(&:to_s).map(&:ord) }.result).to be_success.with_data(values: [0, 1, 2, 3, 4, 5])
          expect(service.collection([0, 1, 2, 3, 4, 5]).each_cons(2) { |numbers| numbers.map(&:to_s).map(&:ord) }.result).to be_success.with_data(values: [0, 1, 2, 3, 4, 5])

          expect(service.collection(set([0, 1, 2, 3, 4, 5])).each_cons(2) { |numbers| numbers.map(&:to_s).map(&:ord) }.result).to be_success.with_data(values: [0, 1, 2, 3, 4, 5])
          expect(service.collection({0 => 0, 1 => 1, 2 => 2, 3 => 3, 4 => 4, 5 => 5}).each_cons(2) { |numbers| numbers.map(&:last).map(&:to_s).map(&:ord) }.result).to be_success.with_data(values: [[0, 0], [1, 1], [2, 2], [3, 3], [4, 4], [5, 5]])
          expect(service.collection((0..5)).each_cons(2) { |numbers| numbers.map(&:to_s).map(&:ord) }.result).to be_success.with_data(values: [0, 1, 2, 3, 4, 5])
          expect(service.collection((0..0)).each_cons(2) { |numbers| numbers.map(&:to_s).map(&:ord) }.result).to be_success.with_data(values: [0])

          # NOTE: Step with no outputs.
          expect(service.collection(enumerable([:success, :success, :success])).each_cons(2) { |statuses| step statuses_service, in: [statuses: -> { statuses }] }.result).to be_success.with_data(values: [:success, :success, :success])
          expect(service.collection(enumerator([:success, :success, :success])).each_cons(2) { |statuses| step statuses_service, in: [statuses: -> { statuses }] }.result).to be_success.with_data(values: [:success, :success, :success])
          expect(service.collection(lazy_enumerator([:success, :success, :success])).each_cons(2) { |statuses| step statuses_service, in: [statuses: -> { statuses }] }.result).to be_success.with_data(values: [:success, :success, :success])
          expect(service.collection(chain_enumerator([:success, :success, :success])).each_cons(2) { |statuses| step statuses_service, in: [statuses: -> { statuses }] }.result).to be_success.with_data(values: [:success, :success, :success])
          expect(service.collection([:success, :success, :success]).each_cons(2) { |statuses| step statuses_service, in: [statuses: -> { statuses }] }.result).to be_success.with_data(values: [:success, :success, :success])

          expect(service.collection(set([:success])).each_cons(2) { |statuses| step statuses_service, in: [statuses: -> { statuses }] }.result).to be_success.with_data(values: [:success])
          expect(service.collection({success: :success}).each_cons(2) { |key, value| step status_service, in: [status: -> { value }] }.result).to be_success.with_data(values: [[:success, :success]])
          expect(service.collection((:success..:success)).each_cons(2) { |statuses| step statuses_service, in: [statuses: -> { statuses }] }.result).to be_success.with_data(values: [:success])

          # NOTE: Step with one output.
          expect(service.collection(enumerable([:success, :success, :success])).each_cons(2) { |statuses| step statuses_service, in: [statuses: -> { statuses }], out: :status_string }.result).to be_success.with_data(values: [:success, :success, :success])
          expect(service.collection(enumerator([:success, :success, :success])).each_cons(2) { |statuses| step statuses_service, in: [statuses: -> { statuses }], out: :status_string }.result).to be_success.with_data(values: [:success, :success, :success])
          expect(service.collection(lazy_enumerator([:success, :success, :success])).each_cons(2) { |statuses| step statuses_service, in: [statuses: -> { statuses }], out: :status_string }.result).to be_success.with_data(values: [:success, :success, :success])
          expect(service.collection(chain_enumerator([:success, :success, :success])).each_cons(2) { |statuses| step statuses_service, in: [statuses: -> { statuses }], out: :status_string }.result).to be_success.with_data(values: [:success, :success, :success])
          expect(service.collection([:success, :success, :success]).each_cons(2) { |statuses| step statuses_service, in: [statuses: -> { statuses }], out: :status_string }.result).to be_success.with_data(values: [:success, :success, :success])

          expect(service.collection(set([:success])).each_cons(2) { |statuses| step statuses_service, in: [statuses: -> { statuses }], out: :status_string }.result).to be_success.with_data(values: [:success])
          expect(service.collection({success: :success}).each_cons(2) { |key, value| step status_service, in: [status: -> { value }], out: :status_string }.result).to be_success.with_data(values: [[:success, :success]])
          expect(service.collection((:success..:success)).each_cons(2) { |statuses| step statuses_service, in: [statuses: -> { statuses }], out: :status_string }.result).to be_success.with_data(values: [:success])

          # NOTE: Step with multiple outputs.
          expect(service.collection(enumerable([:success, :success, :success])).each_cons(2) { |statuses| step statuses_service, in: [statuses: -> { statuses }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [:success, :success, :success])
          expect(service.collection(enumerator([:success, :success, :success])).each_cons(2) { |statuses| step statuses_service, in: [statuses: -> { statuses }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [:success, :success, :success])
          expect(service.collection(lazy_enumerator([:success, :success, :success])).each_cons(2) { |statuses| step statuses_service, in: [statuses: -> { statuses }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [:success, :success, :success])
          expect(service.collection(chain_enumerator([:success, :success, :success])).each_cons(2) { |statuses| step statuses_service, in: [statuses: -> { statuses }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [:success, :success, :success])
          expect(service.collection([:success, :success, :success]).each_cons(2) { |statuses| step statuses_service, in: [statuses: -> { statuses }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [:success, :success, :success])

          expect(service.collection(set([:success])).each_cons(2) { |statuses| step statuses_service, in: [statuses: -> { statuses }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [:success])
          expect(service.collection({success: :success}).each_cons(2) { |key, value| step status_service, in: [status: -> { value }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [[:success, :success]])
          expect(service.collection((:success..:success)).each_cons(2) { |statuses| step statuses_service, in: [statuses: -> { statuses }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [:success])

          # NOTE: Error result.
          expect(service.collection(enumerable([:success, :error, :exception])).each_cons(2) { |statuses| step statuses_service, in: [statuses: -> { statuses }] }.result).to be_error.without_data
          expect(service.collection(enumerator([:success, :error, :exception])).each_cons(2) { |statuses| step statuses_service, in: [statuses: -> { statuses }] }.result).to be_error.without_data
          expect(service.collection(lazy_enumerator([:success, :error, :exception])).each_cons(2) { |statuses| step statuses_service, in: [statuses: -> { statuses }] }.result).to be_error.without_data
          expect(service.collection(chain_enumerator([:success, :error, :exception])).each_cons(2) { |statuses| step statuses_service, in: [statuses: -> { statuses }] }.result).to be_error.without_data
          expect(service.collection([:success, :error, :exception]).each_cons(2) { |statuses| step statuses_service, in: [statuses: -> { statuses }] }.result).to be_error.without_data

          expect(service.collection(set([:success, :error, :exception])).each_cons(2) { |statuses| step statuses_service, in: [statuses: -> { statuses }] }.result).to be_error.without_data
          expect(service.collection({success: :success, error: :error, exception: :exception}).each_cons(2) { |statuses| step statuses_service, in: [statuses: -> { statuses.map(&:last) }] }.result).to be_error.without_data
          expect(service.collection((:error..:error)).each_cons(1) { |statuses| step statuses_service, in: [statuses: -> { statuses }] }.result).to be_error.without_data

          expect((:error..:error).each_cons(2) { raise }).to eq((:error..:error))
          expect(service.collection((:error..:error)).each_cons(2) { raise }.result).to be_success.with_data(values: [:error])

          # NOTE: Error propagation.
          expect(service.collection(enumerable([:success, :error, :exception])).filter { |status| step status_service, in: [status: -> { status }] }.each_cons(2) { |statuses| statuses.map(&condition) }.result).to be_error.without_data
          expect(service.collection(enumerator([:success, :error, :exception])).filter { |status| step status_service, in: [status: -> { status }] }.each_cons(2) { |statuses| statuses.map(&condition) }.result).to be_error.without_data
          expect(service.collection(lazy_enumerator([:success, :error, :exception])).filter { |status| step status_service, in: [status: -> { status }] }.each_cons(2) { |statuses| statuses.map(&condition) }.result).to be_error.without_data
          expect(service.collection(chain_enumerator([:success, :error, :exception])).filter { |status| step status_service, in: [status: -> { status }] }.each_cons(2) { |statuses| statuses.map(&condition) }.result).to be_error.without_data
          expect(service.collection([:success, :error, :exception]).filter { |status| step status_service, in: [status: -> { status }] }.each_cons(2) { |statuses| statuses.map(&condition) }.result).to be_error.without_data

          expect(service.collection(set([:success, :error, :exception])).filter { |status| step status_service, in: [status: -> { status }] }.each_cons(2) { |statuses| statuses.map(&condition) }.result).to be_error.without_data
          expect(service.collection({success: :success, error: :error, exception: :exception}).filter { |key, value| step status_service, in: [status: -> { value }] }.each_cons(2) { |statuses| statuses.map(&:last).map(&condition) }.result).to be_error.without_data
          expect(service.collection((:error..:error)).filter { |status| step status_service, in: [status: -> { status }] }.each_cons(1) { |statuses| statuses.map(&condition) }.result).to be_error.without_data

          # NOTE: Usage on terminal chaining.
          expect { service.collection(enumerable([:success, :exception, :exception])).first.each_cons(2) { |status| condition[status] }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection(enumerator([:success, :exception, :exception])).first.each_cons(2) { |status| condition[status] }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection(lazy_enumerator([:success, :exception, :exception])).first.each_cons(2) { |status| condition[status] }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection(chain_enumerator([:success, :exception, :exception])).first.each_cons(2) { |status| condition[status] }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection([:success, :exception, :exception]).first.each_cons(2) { |status| condition[status] }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)

          expect { service.collection(set([:success, :exception, :exception])).first.each_cons(2) { |status| condition[status] }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection({success: :success, exception: :exception}).first.each_cons(2) { |key, value| condition[value] }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection((:success..:success)).first.each_cons(2) { |status| condition[status] }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
        end
      end

      describe "#each_entry" do
        specify do
          # NOTE: Empty collection.
          expect([].each_entry { |status| condition[status] }).to eq([])
          expect(service.collection(enumerable([])).each_entry { |status| condition[status] }.result).to be_success.with_data(values: [])
          expect(service.collection(enumerator([])).each_entry { |status| condition[status] }.result).to be_success.with_data(values: [])
          expect(service.collection(lazy_enumerator([])).each_entry { |status| condition[status] }.result).to be_success.with_data(values: [])
          expect(service.collection(chain_enumerator([])).each_entry { |status| condition[status] }.result).to be_success.with_data(values: [])
          expect(service.collection([]).each_entry { |status| condition[status] }.result).to be_success.with_data(values: [])
          expect(service.collection(set([])).each_entry { |status| condition[status] }.result).to be_success.with_data(values: [])
          expect(service.collection({}).each_entry { |status| condition[status] }.result).to be_success.with_data(values: [])
          expect(service.collection((:success...:success)).each_entry { |status| condition[status] }.result).to be_success.with_data(values: [])

          # NOTE: No block.
          expect([0, 1, 2, 3, 4, 5].each_entry.to_a).to eq([0, 1, 2, 3, 4, 5])
          expect(service.collection(enumerable([0, 1, 2, 3, 4, 5])).each_entry.result).to be_success.with_data(values: [0, 1, 2, 3, 4, 5])
          expect(service.collection(enumerator([0, 1, 2, 3, 4, 5])).each_entry.result).to be_success.with_data(values: [0, 1, 2, 3, 4, 5])
          expect(service.collection(lazy_enumerator([0, 1, 2, 3, 4, 5])).each_entry.result).to be_success.with_data(values: [0, 1, 2, 3, 4, 5])
          expect(service.collection(chain_enumerator([0, 1, 2, 3, 4, 5])).each_entry.result).to be_success.with_data(values: [0, 1, 2, 3, 4, 5])
          expect(service.collection([0, 1, 2, 3, 4, 5]).each_entry.result).to be_success.with_data(values: [0, 1, 2, 3, 4, 5])

          expect(service.collection(set([0, 1, 2, 3, 4, 5])).each_entry.result).to be_success.with_data(values: [0, 1, 2, 3, 4, 5])
          expect(service.collection({0 => 0, 1 => 1, 2 => 2, 3 => 3, 4 => 4, 5 => 5}).each_entry.result).to be_success.with_data(values: [[0, 0], [1, 1], [2, 2], [3, 3], [4, 4], [5, 5]])
          expect(service.collection((0..5)).each_entry.result).to be_success.with_data(values: [0, 1, 2, 3, 4, 5])

          # NOTE: Block.
          expect([0, 1, 2, 3, 4, 5].each_entry { |number| number.even? }).to eq([0, 1, 2, 3, 4, 5])
          expect(service.collection(enumerable([0, 1, 2, 3, 4, 5])).each_entry { |number| number.even? }.result).to be_success.with_data(values: [0, 1, 2, 3, 4, 5])
          expect(service.collection(enumerator([0, 1, 2, 3, 4, 5])).each_entry { |number| number.even? }.result).to be_success.with_data(values: [0, 1, 2, 3, 4, 5])
          expect(service.collection(lazy_enumerator([0, 1, 2, 3, 4, 5])).each_entry { |number| number.even? }.result).to be_success.with_data(values: [0, 1, 2, 3, 4, 5])
          expect(service.collection(chain_enumerator([0, 1, 2, 3, 4, 5])).each_entry { |number| number.even? }.result).to be_success.with_data(values: [0, 1, 2, 3, 4, 5])
          expect(service.collection([0, 1, 2, 3, 4, 5]).each_entry { |number| number.even? }.result).to be_success.with_data(values: [0, 1, 2, 3, 4, 5])

          expect(service.collection(set([0, 1, 2, 3, 4, 5])).each_entry { |number| number.even? }.result).to be_success.with_data(values: [0, 1, 2, 3, 4, 5])
          expect(service.collection({0 => 0, 1 => 1, 2 => 2, 3 => 3, 4 => 4, 5 => 5}).each_entry { |(key, value)| value.even? }.result).to be_success.with_data(values: [[0, 0], [1, 1], [2, 2], [3, 3], [4, 4], [5, 5]])
          expect(service.collection((0..5)).each_entry { |number| number.even? }.result).to be_success.with_data(values: [0, 1, 2, 3, 4, 5])

          # NOTE: Step with no outputs.
          expect(service.collection(enumerable([:success, :success, :success])).each_entry { |status| step status_service, in: [status: -> { status }] }.result).to be_success.with_data(values: [:success, :success, :success])
          expect(service.collection(enumerator([:success, :success, :success])).each_entry { |status| step status_service, in: [status: -> { status }] }.result).to be_success.with_data(values: [:success, :success, :success])
          expect(service.collection(lazy_enumerator([:success, :success, :success])).each_entry { |status| step status_service, in: [status: -> { status }] }.result).to be_success.with_data(values: [:success, :success, :success])
          expect(service.collection([:success, :success, :success]).each_entry { |status| step status_service, in: [status: -> { status }] }.result).to be_success.with_data(values: [:success, :success, :success])

          expect(service.collection(set([:success])).each_entry { |status| step status_service, in: [status: -> { status }] }.result).to be_success.with_data(values: [:success])
          expect(service.collection({success: :success}).each_entry { |(key, value)| step status_service, in: [status: -> { value }] }.result).to be_success.with_data(values: [[:success, :success]])
          expect(service.collection((:success..:success)).each_entry { |status| step status_service, in: [status: -> { status }] }.result).to be_success.with_data(values: [:success])

          # NOTE: Step with one output.
          expect(service.collection(enumerable([:success, :success, :success])).each_entry { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(values: [:success, :success, :success])
          expect(service.collection(enumerator([:success, :success, :success])).each_entry { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(values: [:success, :success, :success])
          expect(service.collection(lazy_enumerator([:success, :success, :success])).each_entry { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(values: [:success, :success, :success])
          expect(service.collection([:success, :success, :success]).each_entry { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(values: [:success, :success, :success])

          expect(service.collection(set([:success])).each_entry { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(values: [:success])
          expect(service.collection({success: :success}).each_entry { |(key, value)| step status_service, in: [status: -> { value }], out: :status_string }.result).to be_success.with_data(values: [[:success, :success]])
          expect(service.collection((:success..:success)).each_entry { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(values: [:success])

          # NOTE: Step with multiple outputs.
          expect(service.collection(enumerable([:success, :success, :success])).each_entry { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [:success, :success, :success])
          expect(service.collection(enumerator([:success, :success, :success])).each_entry { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [:success, :success, :success])
          expect(service.collection(lazy_enumerator([:success, :success, :success])).each_entry { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [:success, :success, :success])
          expect(service.collection([:success, :success, :success]).each_entry { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [:success, :success, :success])

          expect(service.collection(set([:success])).each_entry { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [:success])
          expect(service.collection({success: :success}).each_entry { |(key, value)| step status_service, in: [status: -> { value }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [[:success, :success]])
          expect(service.collection((:success..:success)).each_entry { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [:success])

          # NOTE: Error result.
          expect(service.collection(enumerable([:success, :error, :exception])).each_entry { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection(enumerator([:success, :error, :exception])).each_entry { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection(lazy_enumerator([:success, :error, :exception])).each_entry { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection([:success, :error, :exception]).each_entry { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data

          expect(service.collection(set([:success, :error, :exception])).each_entry { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection({success: :success, error: :error, exception: :exception}).each_entry { |(key, value)| step status_service, in: [status: -> { value }] }.result).to be_error.without_data
          expect(service.collection((:error..:error)).each_entry { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data

          # NOTE: Error propagation.
          expect(service.collection(enumerable([:success, :error, :exception])).filter { |status| step status_service, in: [status: -> { status }] }.each_entry { |status| condition[status] }.result).to be_error.without_data
          expect(service.collection(enumerator([:success, :error, :exception])).filter { |status| step status_service, in: [status: -> { status }] }.each_entry { |status| condition[status] }.result).to be_error.without_data
          expect(service.collection(lazy_enumerator([:success, :error, :exception])).filter { |status| step status_service, in: [status: -> { status }] }.each_entry { |status| condition[status] }.result).to be_error.without_data
          expect(service.collection(chain_enumerator([:success, :error, :exception])).filter { |status| step status_service, in: [status: -> { status }] }.each_entry { |status| condition[status] }.result).to be_error.without_data
          expect(service.collection([:success, :error, :exception]).filter { |status| step status_service, in: [status: -> { status }] }.each_entry { |status| condition[status] }.result).to be_error.without_data

          expect(service.collection(set([:success, :error, :exception])).filter { |status| step status_service, in: [status: -> { status }] }.each_entry { |status| condition[status] }.result).to be_error.without_data
          expect(service.collection({success: :success, error: :error, exception: :exception}).filter { |key, value| step status_service, in: [status: -> { value }] }.each_entry { |(key, value)| condition[value] }.result).to be_error.without_data
          expect(service.collection((:error..:error)).filter { |status| step status_service, in: [status: -> { status }] }.each_entry { |status| condition[status] }.result).to be_error.without_data

          # NOTE: Usage on terminal chaining.
          expect { service.collection(enumerable([:success, :exception, :exception])).first.each_entry { |status| condition[status] }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection(enumerator([:success, :exception, :exception])).first.each_entry { |status| condition[status] }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection(lazy_enumerator([:success, :exception, :exception])).first.each_entry { |status| condition[status] }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection(chain_enumerator([:success, :exception, :exception])).first.each_entry { |status| condition[status] }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection([:success, :exception, :exception]).first.each_entry { |status| condition[status] }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)

          expect { service.collection(set([:success, :exception, :exception])).first.each_entry { |status| condition[status] }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection({success: :success, exception: :exception}).first.each_entry { |(key, value)| condition[value] }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection((:success..:success)).first.each_entry { |status| condition[status] }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
        end
      end

      describe "#each_slice" do
        specify do
          # NOTE: Empty collection.
          expect([].each_slice(2) { |numbers| numbers.map(&:even?) }).to eq([])
          expect(service.collection(enumerable([])).each_slice(2) { |numbers| numbers.map(&:even?) }.result).to be_success.with_data(values: [])
          expect(service.collection(enumerator([])).each_slice(2) { |numbers| numbers.map(&:even?) }.result).to be_success.with_data(values: [])
          expect(service.collection(lazy_enumerator([])).each_slice(2) { |numbers| numbers.map(&:even?) }.result).to be_success.with_data(values: [])
          expect(service.collection(chain_enumerator([])).each_slice(2) { |numbers| numbers.map(&:even?) }.result).to be_success.with_data(values: [])
          expect(service.collection([]).each_slice(2) { |numbers| numbers.map(&:even?) }.result).to be_success.with_data(values: [])
          expect(service.collection(set([])).each_slice(2) { |numbers| numbers.map(&:even?) }.result).to be_success.with_data(values: [])
          expect(service.collection({}).each_slice(2) { |numbers| numbers.map(&:even?) }.result).to be_success.with_data(values: [])
          expect(service.collection((:success...:success)).each_slice(2) { |numbers| numbers.map(&:even?) }.result).to be_success.with_data(values: [])

          # NOTE: No block.
          expect([0, 1, 2, 3, 4, 5].each_slice(2).to_a).to eq([[0, 1], [2, 3], [4, 5]])
          expect(service.collection(enumerable([0, 1, 2, 3, 4, 5])).each_slice(2).result).to be_success.with_data(values: [[0, 1], [2, 3], [4, 5]])
          expect(service.collection(enumerator([0, 1, 2, 3, 4, 5])).each_slice(2).result).to be_success.with_data(values: [[0, 1], [2, 3], [4, 5]])
          expect(service.collection(lazy_enumerator([0, 1, 2, 3, 4, 5])).each_slice(2).result).to be_success.with_data(values: [[0, 1], [2, 3], [4, 5]])
          expect(service.collection(chain_enumerator([0, 1, 2, 3, 4, 5])).each_slice(2).result).to be_success.with_data(values: [[0, 1], [2, 3], [4, 5]])
          expect(service.collection([0, 1, 2, 3, 4, 5]).each_slice(2).result).to be_success.with_data(values: [[0, 1], [2, 3], [4, 5]])

          expect(service.collection(set([0, 1, 2, 3, 4, 5])).each_slice(2).result).to be_success.with_data(values: [[0, 1], [2, 3], [4, 5]])
          expect(service.collection({0 => 0, 1 => 1, 2 => 2, 3 => 3, 4 => 4, 5 => 5}).each_slice(2).result).to be_success.with_data(values: [[[0, 0], [1, 1]], [[2, 2], [3, 3]], [[4, 4], [5, 5]]])
          expect(service.collection((0..5)).each_slice(2).result).to be_success.with_data(values: [[0, 1], [2, 3], [4, 5]])

          # NOTE: Block.
          expect([0, 1, 2, 3, 4, 5].each_slice(2) { |numbers| numbers.map(&:even?) }).to eq([0, 1, 2, 3, 4, 5])
          expect(service.collection(enumerable([0, 1, 2, 3, 4, 5])).each_slice(2) { |numbers| numbers.map(&:even?) }.result).to be_success.with_data(values: [0, 1, 2, 3, 4, 5])
          expect(service.collection(enumerator([0, 1, 2, 3, 4, 5])).each_slice(2) { |numbers| numbers.map(&:even?) }.result).to be_success.with_data(values: [0, 1, 2, 3, 4, 5])
          expect(service.collection(lazy_enumerator([0, 1, 2, 3, 4, 5])).each_slice(2) { |numbers| numbers.map(&:even?) }.result).to be_success.with_data(values: [0, 1, 2, 3, 4, 5])
          expect(service.collection(chain_enumerator([0, 1, 2, 3, 4, 5])).each_slice(2) { |numbers| numbers.map(&:even?) }.result).to be_success.with_data(values: [0, 1, 2, 3, 4, 5])
          expect(service.collection([0, 1, 2, 3, 4, 5]).each_slice(2) { |numbers| numbers.map(&:even?) }.result).to be_success.with_data(values: [0, 1, 2, 3, 4, 5])

          expect(service.collection(set([0, 1, 2, 3, 4, 5])).each_slice(2) { |numbers| numbers.map(&:even?) }.result).to be_success.with_data(values: [0, 1, 2, 3, 4, 5])
          expect(service.collection({0 => 0, 1 => 1, 2 => 2, 3 => 3, 4 => 4, 5 => 5}).each_slice(2) { |(key, value), index| value.to_s.ord }.result).to be_success.with_data(values: [[0, 0], [1, 1], [2, 2], [3, 3], [4, 4], [5, 5]])
          expect(service.collection((0..5)).each_slice(2) { |numbers| numbers.map(&:even?) }.result).to be_success.with_data(values: [0, 1, 2, 3, 4, 5])

          # NOTE: Step with no outputs.
          expect(service.collection(enumerable([:success, :success, :success])).each_slice(2) { |statuses| step statuses_service, in: [statuses: -> { statuses }] }.result).to be_success.with_data(values: [:success, :success, :success])
          expect(service.collection(enumerator([:success, :success, :success])).each_slice(2) { |statuses| step statuses_service, in: [statuses: -> { statuses }] }.result).to be_success.with_data(values: [:success, :success, :success])
          expect(service.collection(lazy_enumerator([:success, :success, :success])).each_slice(2) { |statuses| step statuses_service, in: [statuses: -> { statuses }] }.result).to be_success.with_data(values: [:success, :success, :success])
          expect(service.collection([:success, :success, :success]).each_slice(2) { |statuses| step statuses_service, in: [statuses: -> { statuses }] }.result).to be_success.with_data(values: [:success, :success, :success])

          expect(service.collection(set([:success])).each_slice(2) { |statuses| step statuses_service, in: [statuses: -> { statuses }] }.result).to be_success.with_data(values: [:success])
          expect(service.collection({success: :success}).each_slice(2) { |statuses| step statuses_service, in: [statuses: -> { statuses.map(&:last) }] }.result).to be_success.with_data(values: [[:success, :success]])
          expect(service.collection((:success..:success)).each_slice(2) { |statuses| step statuses_service, in: [statuses: -> { statuses }] }.result).to be_success.with_data(values: [:success])

          # NOTE: Step with one output.
          expect(service.collection(enumerable([:success, :success, :success])).each_slice(2) { |statuses| step statuses_service, in: [statuses: -> { statuses }], out: :status_string }.result).to be_success.with_data(values: [:success, :success, :success])
          expect(service.collection(enumerator([:success, :success, :success])).each_slice(2) { |statuses| step statuses_service, in: [statuses: -> { statuses }], out: :status_string }.result).to be_success.with_data(values: [:success, :success, :success])
          expect(service.collection(lazy_enumerator([:success, :success, :success])).each_slice(2) { |statuses| step statuses_service, in: [statuses: -> { statuses }], out: :status_string }.result).to be_success.with_data(values: [:success, :success, :success])
          expect(service.collection([:success, :success, :success]).each_slice(2) { |statuses| step statuses_service, in: [statuses: -> { statuses }], out: :status_string }.result).to be_success.with_data(values: [:success, :success, :success])

          expect(service.collection(set([:success])).each_slice(2) { |statuses| step statuses_service, in: [statuses: -> { statuses }], out: :status_string }.result).to be_success.with_data(values: [:success])
          expect(service.collection({success: :success}).each_slice(2) { |statuses| step statuses_service, in: [statuses: -> { statuses.map(&:last) }], out: :status_string }.result).to be_success.with_data(values: [[:success, :success]])
          expect(service.collection((:success..:success)).each_slice(2) { |statuses| step statuses_service, in: [statuses: -> { statuses }], out: :status_string }.result).to be_success.with_data(values: [:success])

          # NOTE: Step with multiple outputs.
          expect(service.collection(enumerable([:success, :success, :success])).each_slice(2) { |statuses| step statuses_service, in: [statuses: -> { statuses }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [:success, :success, :success])
          expect(service.collection(enumerator([:success, :success, :success])).each_slice(2) { |statuses| step statuses_service, in: [statuses: -> { statuses }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [:success, :success, :success])
          expect(service.collection(lazy_enumerator([:success, :success, :success])).each_slice(2) { |statuses| step statuses_service, in: [statuses: -> { statuses }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [:success, :success, :success])
          expect(service.collection([:success, :success, :success]).each_slice(2) { |statuses| step statuses_service, in: [statuses: -> { statuses }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [:success, :success, :success])

          expect(service.collection(set([:success])).each_slice(2) { |statuses| step statuses_service, in: [statuses: -> { statuses }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [:success])
          expect(service.collection({success: :success}).each_slice(2) { |statuses| step statuses_service, in: [statuses: -> { statuses.map(&:last) }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [[:success, :success]])
          expect(service.collection((:success..:success)).each_slice(2) { |statuses| step statuses_service, in: [statuses: -> { statuses }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [:success])

          # NOTE: Error result.
          expect(service.collection(enumerable([:success, :error, :exception])).each_slice(2) { |statuses| step statuses_service, in: [statuses: -> { statuses }] }.result).to be_error.without_data
          expect(service.collection(enumerator([:success, :error, :exception])).each_slice(2) { |statuses| step statuses_service, in: [statuses: -> { statuses }] }.result).to be_error.without_data
          expect(service.collection(lazy_enumerator([:success, :error, :exception])).each_slice(2) { |statuses| step statuses_service, in: [statuses: -> { statuses }] }.result).to be_error.without_data
          expect(service.collection([:success, :error, :exception]).each_slice(2) { |statuses| step statuses_service, in: [statuses: -> { statuses }] }.result).to be_error.without_data

          expect(service.collection(set([:success, :error, :exception])).each_slice(2) { |statuses| step statuses_service, in: [statuses: -> { statuses }] }.result).to be_error.without_data
          expect(service.collection({success: :success, error: :error, exception: :exception}).each_slice(2) { |statuses| step statuses_service, in: [statuses: -> { statuses.map(&:last) }] }.result).to be_error.without_data
          expect(service.collection((:error..:error)).each_slice(2) { |statuses| step statuses_service, in: [statuses: -> { statuses }] }.result).to be_error.without_data

          # NOTE: Error propagation.
          expect(service.collection(enumerable([:success, :error, :exception])).filter { |status| step status_service, in: [status: -> { status }] }.each_slice(2) { |numbers| numbers.map(&:even?) }.result).to be_error.without_data
          expect(service.collection(enumerator([:success, :error, :exception])).filter { |status| step status_service, in: [status: -> { status }] }.each_slice(2) { |numbers| numbers.map(&:even?) }.result).to be_error.without_data
          expect(service.collection(lazy_enumerator([:success, :error, :exception])).filter { |status| step status_service, in: [status: -> { status }] }.each_slice(2) { |numbers| numbers.map(&:even?) }.result).to be_error.without_data
          expect(service.collection(chain_enumerator([:success, :error, :exception])).filter { |status| step status_service, in: [status: -> { status }] }.each_slice(2) { |numbers| numbers.map(&:even?) }.result).to be_error.without_data
          expect(service.collection([:success, :error, :exception]).filter { |status| step status_service, in: [status: -> { status }] }.each_slice(2) { |numbers| numbers.map(&:even?) }.result).to be_error.without_data

          expect(service.collection(set([:success, :error, :exception])).filter { |status| step status_service, in: [status: -> { status }] }.each_slice(2) { |numbers| numbers.map(&:even?) }.result).to be_error.without_data
          expect(service.collection({success: :success, error: :error, exception: :exception}).filter { |key, value| step status_service, in: [status: -> { value }] }.each_slice(2) { |(key, value), index| condition[value] }.result).to be_error.without_data
          expect(service.collection((:error..:error)).filter { |status| step status_service, in: [status: -> { status }] }.each_slice(2) { |numbers| numbers.map(&:even?) }.result).to be_error.without_data

          # NOTE: Usage on terminal chaining.
          expect { service.collection(enumerable([:success, :exception, :exception])).first.each_slice(2) { |numbers| numbers.map(&:even?) }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection(enumerator([:success, :exception, :exception])).first.each_slice(2) { |numbers| numbers.map(&:even?) }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection(lazy_enumerator([:success, :exception, :exception])).first.each_slice(2) { |numbers| numbers.map(&:even?) }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection(chain_enumerator([:success, :exception, :exception])).first.each_slice(2) { |numbers| numbers.map(&:even?) }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection([:success, :exception, :exception]).first.each_slice(2) { |numbers| numbers.map(&:even?) }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)

          expect { service.collection(set([:success, :exception, :exception])).first.each_slice(2) { |numbers| numbers.map(&:even?) }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection({success: :success, exception: :exception}).first.each_slice(2) { |(key, value), index| condition[value] }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection((:success..:success)).first.each_slice(2) { |numbers| numbers.map(&:even?) }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
        end
      end

      describe "#each_with_index" do
        specify do
          # NOTE: Empty collection.
          expect([].each_with_index { |status, index| index.abs }).to eq([])
          expect(service.collection(enumerable([])).each_with_index { |status, index| index.abs }.result).to be_success.with_data(values: [])
          expect(service.collection(enumerator([])).each_with_index { |status, index| index.abs }.result).to be_success.with_data(values: [])
          expect(service.collection(lazy_enumerator([])).each_with_index { |status, index| index.abs }.result).to be_success.with_data(values: [])
          expect { chain_enumerator([]).each_with_index { |status, index| index.abs } }.to raise_error(TypeError).with_message("wrong argument type chain (expected enumerator)")
          expect { service.collection(chain_enumerator([])).each_with_index { |status, index| index.abs }.result }.to raise_error(TypeError).with_message("wrong argument type chain (expected enumerator)")
          expect(service.collection([]).each_with_index { |status, index| index.abs }.result).to be_success.with_data(values: [])
          expect(service.collection(set([])).each_with_index { |status, index| index.abs }.result).to be_success.with_data(values: [])
          expect(service.collection({}).each_with_index { |status, index| index.abs }.result).to be_success.with_data(values: [])
          expect(service.collection((:success...:success)).each_with_index { |status, index| index.abs }.result).to be_success.with_data(values: [])

          # NOTE: No block.
          expect([0, 1, 2, 3, 4, 5].each_with_index.to_a).to eq([[0, 0], [1, 1], [2, 2], [3, 3], [4, 4], [5, 5]])
          expect(service.collection(enumerable([0, 1, 2, 3, 4, 5])).each_with_index.result).to be_success.with_data(values: [[0, 0], [1, 1], [2, 2], [3, 3], [4, 4], [5, 5]])
          expect(service.collection(enumerator([0, 1, 2, 3, 4, 5])).each_with_index.result).to be_success.with_data(values: [[0, 0], [1, 1], [2, 2], [3, 3], [4, 4], [5, 5]])
          expect(service.collection(lazy_enumerator([0, 1, 2, 3, 4, 5])).each_with_index.result).to be_success.with_data(values: [[0, 0], [1, 1], [2, 2], [3, 3], [4, 4], [5, 5]])
          expect(service.collection(chain_enumerator([0, 1, 2, 3, 4, 5])).each_with_index.result).to be_success.with_data(values: [[0, 0], [1, 1], [2, 2], [3, 3], [4, 4], [5, 5]])
          expect(service.collection([0, 1, 2, 3, 4, 5]).each_with_index.result).to be_success.with_data(values: [[0, 0], [1, 1], [2, 2], [3, 3], [4, 4], [5, 5]])

          expect(service.collection(set([0, 1, 2, 3, 4, 5])).each_with_index.result).to be_success.with_data(values: [[0, 0], [1, 1], [2, 2], [3, 3], [4, 4], [5, 5]])
          expect(service.collection({0 => 0, 1 => 1, 2 => 2, 3 => 3, 4 => 4, 5 => 5}).each_with_index.result).to be_success.with_data(values: [[[0, 0], 0], [[1, 1], 1], [[2, 2], 2], [[3, 3], 3], [[4, 4], 4], [[5, 5], 5]])
          expect(service.collection((0..5)).each_with_index.result).to be_success.with_data(values: [[0, 0], [1, 1], [2, 2], [3, 3], [4, 4], [5, 5]])

          # NOTE: Block.
          expect([0, 1, 2, 3, 4, 5].each_with_index { |number, index| index.abs }).to eq([0, 1, 2, 3, 4, 5])
          expect(service.collection(enumerable([0, 1, 2, 3, 4, 5])).each_with_index { |number, index| index.abs }.result).to be_success.with_data(values: [0, 1, 2, 3, 4, 5])
          expect(service.collection(enumerator([0, 1, 2, 3, 4, 5])).each_with_index { |number, index| index.abs }.result).to be_success.with_data(values: [0, 1, 2, 3, 4, 5])
          expect(service.collection(lazy_enumerator([0, 1, 2, 3, 4, 5])).each_with_index { |number, index| index.abs }.result).to be_success.with_data(values: [0, 1, 2, 3, 4, 5])
          expect { chain_enumerator([0, 1, 2, 3, 4, 5]).each_with_index { |status, index| index.abs } }.to raise_error(TypeError).with_message("wrong argument type chain (expected enumerator)")
          expect(service.collection([0, 1, 2, 3, 4, 5]).each_with_index { |number, index| index.abs }.result).to be_success.with_data(values: [0, 1, 2, 3, 4, 5])

          expect(service.collection(set([0, 1, 2, 3, 4, 5])).each_with_index { |number, index| index.abs }.result).to be_success.with_data(values: [0, 1, 2, 3, 4, 5])
          expect(service.collection({0 => 0, 1 => 1, 2 => 2, 3 => 3, 4 => 4, 5 => 5}).each_with_index { |(key, value), index| value.to_s.ord }.result).to be_success.with_data(values: [[0, 0], [1, 1], [2, 2], [3, 3], [4, 4], [5, 5]])
          expect(service.collection((0..5)).each_with_index { |number, index| index.abs }.result).to be_success.with_data(values: [0, 1, 2, 3, 4, 5])

          # NOTE: Step with no outputs.
          expect(service.collection(enumerable([:success, :success, :success])).each_with_index { |status, index| step status_service, in: [status: -> { status }] }.result).to be_success.with_data(values: [:success, :success, :success])
          expect(service.collection(enumerator([:success, :success, :success])).each_with_index { |status, index| step status_service, in: [status: -> { status }] }.result).to be_success.with_data(values: [:success, :success, :success])
          expect(service.collection(lazy_enumerator([:success, :success, :success])).each_with_index { |status, index| step status_service, in: [status: -> { status }] }.result).to be_success.with_data(values: [:success, :success, :success])
          expect(service.collection([:success, :success, :success]).each_with_index { |status, index| step status_service, in: [status: -> { status }] }.result).to be_success.with_data(values: [:success, :success, :success])

          expect(service.collection(set([:success])).each_with_index { |status, index| step status_service, in: [status: -> { status }] }.result).to be_success.with_data(values: [:success])
          expect(service.collection({success: :success}).each_with_index { |(key, value), index| step status_service, in: [status: -> { value }] }.result).to be_success.with_data(values: [[:success, :success]])
          expect(service.collection((:success..:success)).each_with_index { |status, index| step status_service, in: [status: -> { status }] }.result).to be_success.with_data(values: [:success])

          # NOTE: Step with one output.
          expect(service.collection(enumerable([:success, :success, :success])).each_with_index { |status, index| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(values: [:success, :success, :success])
          expect(service.collection(enumerator([:success, :success, :success])).each_with_index { |status, index| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(values: [:success, :success, :success])
          expect(service.collection(lazy_enumerator([:success, :success, :success])).each_with_index { |status, index| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(values: [:success, :success, :success])
          expect(service.collection([:success, :success, :success]).each_with_index { |status, index| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(values: [:success, :success, :success])

          expect(service.collection(set([:success])).each_with_index { |status, index| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(values: [:success])
          expect(service.collection({success: :success}).each_with_index { |(key, value), index| step status_service, in: [status: -> { value }], out: :status_string }.result).to be_success.with_data(values: [[:success, :success]])
          expect(service.collection((:success..:success)).each_with_index { |status, index| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(values: [:success])

          # NOTE: Step with multiple outputs.
          expect(service.collection(enumerable([:success, :success, :success])).each_with_index { |status, index| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [:success, :success, :success])
          expect(service.collection(enumerator([:success, :success, :success])).each_with_index { |status, index| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [:success, :success, :success])
          expect(service.collection(lazy_enumerator([:success, :success, :success])).each_with_index { |status, index| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [:success, :success, :success])
          expect(service.collection([:success, :success, :success]).each_with_index { |status, index| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [:success, :success, :success])

          expect(service.collection(set([:success])).each_with_index { |status, index| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [:success])
          expect(service.collection({success: :success}).each_with_index { |(key, value), index| step status_service, in: [status: -> { value }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [[:success, :success]])
          expect(service.collection((:success..:success)).each_with_index { |status, index| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [:success])

          # NOTE: Error result.
          expect(service.collection(enumerable([:success, :error, :exception])).each_with_index { |status, index| step status_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection(enumerator([:success, :error, :exception])).each_with_index { |status, index| step status_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection(lazy_enumerator([:success, :error, :exception])).each_with_index { |status, index| step status_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection([:success, :error, :exception]).each_with_index { |status, index| step status_service, in: [status: -> { status }] }.result).to be_error.without_data

          expect(service.collection(set([:success, :error, :exception])).each_with_index { |status, index| step status_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection({success: :success, error: :error, exception: :exception}).each_with_index { |(key, value), index| step status_service, in: [status: -> { value }] }.result).to be_error.without_data
          expect(service.collection((:error..:error)).each_with_index { |status, index| step status_service, in: [status: -> { status }] }.result).to be_error.without_data

          # NOTE: Error propagation.
          expect(service.collection(enumerable([:success, :error, :exception])).filter { |status| step status_service, in: [status: -> { status }] }.each_with_index { |status, index| condition[status] }.result).to be_error.without_data
          expect(service.collection(enumerator([:success, :error, :exception])).filter { |status| step status_service, in: [status: -> { status }] }.each_with_index { |status, index| condition[status] }.result).to be_error.without_data
          expect(service.collection(lazy_enumerator([:success, :error, :exception])).filter { |status| step status_service, in: [status: -> { status }] }.each_with_index { |status, index| condition[status] }.result).to be_error.without_data
          expect(service.collection(chain_enumerator([:success, :error, :exception])).filter { |status| step status_service, in: [status: -> { status }] }.each_with_index { |status, index| condition[status] }.result).to be_error.without_data
          expect(service.collection([:success, :error, :exception]).filter { |status| step status_service, in: [status: -> { status }] }.each_with_index { |status, index| condition[status] }.result).to be_error.without_data

          expect(service.collection(set([:success, :error, :exception])).filter { |status| step status_service, in: [status: -> { status }] }.each_with_index { |status, index| condition[status] }.result).to be_error.without_data
          expect(service.collection({success: :success, error: :error, exception: :exception}).filter { |key, value| step status_service, in: [status: -> { value }] }.each_with_index { |(key, value), index| condition[value] }.result).to be_error.without_data
          expect(service.collection((:error..:error)).filter { |status| step status_service, in: [status: -> { status }] }.each_with_index { |status, index| condition[status] }.result).to be_error.without_data

          # NOTE: Usage on terminal chaining.
          expect { service.collection(enumerable([:success, :exception, :exception])).first.each_with_index { |status, index| condition[status] }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection(enumerator([:success, :exception, :exception])).first.each_with_index { |status, index| condition[status] }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection(lazy_enumerator([:success, :exception, :exception])).first.each_with_index { |status, index| condition[status] }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection(chain_enumerator([:success, :exception, :exception])).first.each_with_index { |status, index| condition[status] }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection([:success, :exception, :exception]).first.each_with_index { |status, index| condition[status] }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)

          expect { service.collection(set([:success, :exception, :exception])).first.each_with_index { |status, index| condition[status] }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection({success: :success, exception: :exception}).first.each_with_index { |(key, value), index| condition[value] }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection((:success..:success)).first.each_with_index { |status, index| condition[status] }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
        end
      end

      describe "#each_with_object" do
        specify do
          # NOTE: Empty collection.
          expect([].each_with_object("") { |string, object| object.concat(string) }).to eq("")
          expect(service.collection(enumerable([])).each_with_object("") { |string, object| object.concat(string) }.result).to be_success.with_data(value: "")
          expect(service.collection(enumerator([])).each_with_object("") { |string, object| object.concat(string) }.result).to be_success.with_data(value: "")
          expect(service.collection(lazy_enumerator([])).each_with_object("") { |string, object| object.concat(string) }.result).to be_success.with_data(value: "")
          expect { chain_enumerator([]).each_with_object("") { |string, object| object.concat(string) } }.to raise_error(TypeError).with_message("wrong argument type chain (expected enumerator)")
          expect { service.collection(chain_enumerator([])).each_with_object("") { |string, object| object.concat(string) }.result }.to raise_error(TypeError).with_message("wrong argument type chain (expected enumerator)")
          expect(service.collection([]).each_with_object("") { |string, object| object.concat(string) }.result).to be_success.with_data(value: "")
          expect(service.collection(set([])).each_with_object("") { |string, object| object.concat(string) }.result).to be_success.with_data(value: "")
          expect(service.collection({}).each_with_object("") { |string, object| object.concat(string) }.result).to be_success.with_data(value: "")
          expect(service.collection((:success...:success)).each_with_object("") { |string, object| object.concat(string) }.result).to be_success.with_data(value: "")

          # NOTE: No block.
          expect(["0", "1", "2", "3", "4", "5"].each_with_object("").to_a).to eq([["0", ""], ["1", ""], ["2", ""], ["3", ""], ["4", ""], ["5", ""]])
          expect(service.collection(enumerable(["0", "1", "2", "3", "4", "5"])).each_with_object("").result).to be_success.with_data(values: [["0", ""], ["1", ""], ["2", ""], ["3", ""], ["4", ""], ["5", ""]])
          expect(service.collection(enumerator(["0", "1", "2", "3", "4", "5"])).each_with_object("").result).to be_success.with_data(values: [["0", ""], ["1", ""], ["2", ""], ["3", ""], ["4", ""], ["5", ""]])
          expect(service.collection(lazy_enumerator(["0", "1", "2", "3", "4", "5"])).each_with_object("").result).to be_success.with_data(values: [["0", ""], ["1", ""], ["2", ""], ["3", ""], ["4", ""], ["5", ""]])
          expect(service.collection(chain_enumerator(["0", "1", "2", "3", "4", "5"])).each_with_object("").result).to be_success.with_data(values: [["0", ""], ["1", ""], ["2", ""], ["3", ""], ["4", ""], ["5", ""]])
          expect(service.collection(["0", "1", "2", "3", "4", "5"]).each_with_object("").result).to be_success.with_data(values: [["0", ""], ["1", ""], ["2", ""], ["3", ""], ["4", ""], ["5", ""]])

          expect(service.collection(set(["0", "1", "2", "3", "4", "5"])).each_with_object("").result).to be_success.with_data(values: [["0", ""], ["1", ""], ["2", ""], ["3", ""], ["4", ""], ["5", ""]])
          expect(service.collection({"0" => "0", "1" => "1", "2" => "2", "3" => "3", "4" => "4", "5" => "5"}).each_with_object("").result).to be_success.with_data(values: [[["0", "0"], ""], [["1", "1"], ""], [["2", "2"], ""], [["3", "3"], ""], [["4", "4"], ""], [["5", "5"], ""]])
          expect(service.collection(("0".."5")).each_with_object("").result).to be_success.with_data(values: [["0", ""], ["1", ""], ["2", ""], ["3", ""], ["4", ""], ["5", ""]])

          # NOTE: Block.
          expect(["0", "1", "2", "3", "4", "5"].each_with_object(+"") { |string, object| object.concat(string) }).to eq("012345")
          expect(service.collection(enumerable(["0", "1", "2", "3", "4", "5"])).each_with_object(+"") { |string, object| object.concat(string) }.result).to be_success.with_data(value: "012345")
          expect(service.collection(enumerator(["0", "1", "2", "3", "4", "5"])).each_with_object(+"") { |string, object| object.concat(string) }.result).to be_success.with_data(value: "012345")
          expect(service.collection(lazy_enumerator(["0", "1", "2", "3", "4", "5"])).each_with_object(+"") { |string, object| object.concat(string) }.result).to be_success.with_data(value: "012345")
          expect { chain_enumerator(["0", "1", "2", "3", "4", "5"]).each_with_object(+"") { |string, object| object.concat(string) } }.to raise_error(TypeError).with_message("wrong argument type chain (expected enumerator)")
          expect { service.collection(chain_enumerator(["0", "1", "2", "3", "4", "5"])).each_with_object(+"") { |string, object| object.concat(string) }.result }.to raise_error(TypeError).with_message("wrong argument type chain (expected enumerator)")
          expect(service.collection(["0", "1", "2", "3", "4", "5"]).each_with_object(+"") { |string, object| object.concat(string) }.result).to be_success.with_data(value: "012345")

          expect(service.collection(set(["0", "1", "2", "3", "4", "5"])).each_with_object(+"") { |string, object| object.concat(string) }.result).to be_success.with_data(value: "012345")
          expect({"0" => "0", "1" => "1", "2" => "2", "3" => "3", "4" => "4", "5" => "5"}.each_with_object(+"") { |(key, value), object| object.concat(value) }).to eq("012345")
          expect(service.collection({"0" => "0", "1" => "1", "2" => "2", "3" => "3", "4" => "4", "5" => "5"}).each_with_object(+"") { |(key, value), object| object.concat(value) }.result).to be_success.with_data(value: "012345")
          expect(service.collection(("0".."5")).each_with_object(+"") { |string, object| object.concat(string) }.result).to be_success.with_data(value: "012345")

          # NOTE: Step with no outputs.
          expect(service.collection(enumerable(["0", "1", "2", "3", "4", "5"])).each_with_object(+"") { |string, object| step concat_strings_service, in: [string: -> { object }, other_string: -> { string }] }.result).to be_success.with_data(value: "012345")
          expect(service.collection(enumerator(["0", "1", "2", "3", "4", "5"])).each_with_object(+"") { |string, object| step concat_strings_service, in: [string: -> { object }, other_string: -> { string }] }.result).to be_success.with_data(value: "012345")
          expect(service.collection(lazy_enumerator(["0", "1", "2", "3", "4", "5"])).each_with_object(+"") { |string, object| step concat_strings_service, in: [string: -> { object }, other_string: -> { string }] }.result).to be_success.with_data(value: "012345")
          expect(service.collection(["0", "1", "2", "3", "4", "5"]).each_with_object(+"") { |string, object| step concat_strings_service, in: [string: -> { object }, other_string: -> { string }] }.result).to be_success.with_data(value: "012345")

          expect(service.collection(set(["0", "1", "2", "3", "4", "5"])).each_with_object(+"") { |string, object| step concat_strings_service, in: [string: -> { object }, other_string: -> { string }] }.result).to be_success.with_data(value: "012345")
          expect(service.collection({"0" => "0", "1" => "1", "2" => "2", "3" => "3", "4" => "4", "5" => "5"}).each_with_object(+"") { |(key, value), object| step concat_strings_service, in: [string: -> { object }, other_string: -> { value }] }.result).to be_success.with_data(value: "012345")
          expect(service.collection(("0".."5")).each_with_object(+"") { |string, object| step concat_strings_service, in: [string: -> { object }, other_string: -> { string }] }.result).to be_success.with_data(value: "012345")

          # NOTE: Step with one output.
          expect(service.collection(enumerable(["0", "1", "2", "3", "4", "5"])).each_with_object(+"") { |string, object| step concat_strings_service, in: [string: -> { object }, other_string: -> { string }], out: :concatenation }.result).to be_success.with_data(value: "012345")
          expect(service.collection(enumerator(["0", "1", "2", "3", "4", "5"])).each_with_object(+"") { |string, object| step concat_strings_service, in: [string: -> { object }, other_string: -> { string }], out: :concatenation }.result).to be_success.with_data(value: "012345")
          expect(service.collection(lazy_enumerator(["0", "1", "2", "3", "4", "5"])).each_with_object(+"") { |string, object| step concat_strings_service, in: [string: -> { object }, other_string: -> { string }], out: :concatenation }.result).to be_success.with_data(value: "012345")
          expect(service.collection(["0", "1", "2", "3", "4", "5"]).each_with_object(+"") { |string, object| step concat_strings_service, in: [string: -> { object }, other_string: -> { string }], out: :concatenation }.result).to be_success.with_data(value: "012345")

          expect(service.collection(set(["0", "1", "2", "3", "4", "5"])).each_with_object(+"") { |string, object| step concat_strings_service, in: [string: -> { object }, other_string: -> { string }], out: :concatenation }.result).to be_success.with_data(value: "012345")
          expect(service.collection({"0" => "0", "1" => "1", "2" => "2", "3" => "3", "4" => "4", "5" => "5"}).each_with_object(+"") { |(key, value), object| step concat_strings_service, in: [string: -> { object }, other_string: -> { value }], out: :concatenation }.result).to be_success.with_data(value: "012345")
          expect(service.collection(("0".."5")).each_with_object(+"") { |string, object| step concat_strings_service, in: [string: -> { object }, other_string: -> { string }], out: :concatenation }.result).to be_success.with_data(value: "012345")

          # NOTE: Step with multiple outputs.
          expect(service.collection(enumerable(["0", "1", "2", "3", "4", "5"])).each_with_object(+"") { |string, object| step concat_strings_service, in: [string: -> { object }, other_string: -> { string }], out: [:concatenation, :operator] }.result).to be_success.with_data(value: "012345")
          expect(service.collection(enumerator(["0", "1", "2", "3", "4", "5"])).each_with_object(+"") { |string, object| step concat_strings_service, in: [string: -> { object }, other_string: -> { string }], out: [:concatenation, :operator] }.result).to be_success.with_data(value: "012345")
          expect(service.collection(lazy_enumerator(["0", "1", "2", "3", "4", "5"])).each_with_object(+"") { |string, object| step concat_strings_service, in: [string: -> { object }, other_string: -> { string }], out: [:concatenation, :operator] }.result).to be_success.with_data(value: "012345")
          expect(service.collection(["0", "1", "2", "3", "4", "5"]).each_with_object(+"") { |string, object| step concat_strings_service, in: [string: -> { object }, other_string: -> { string }], out: [:concatenation, :operator] }.result).to be_success.with_data(value: "012345")

          expect(service.collection(set(["0", "1", "2", "3", "4", "5"])).each_with_object(+"") { |string, object| step concat_strings_service, in: [string: -> { object }, other_string: -> { string }], out: [:concatenation, :operator] }.result).to be_success.with_data(value: "012345")
          expect(service.collection({"0" => "0", "1" => "1", "2" => "2", "3" => "3", "4" => "4", "5" => "5"}).each_with_object(+"") { |(key, value), object| step concat_strings_service, in: [string: -> { object }, other_string: -> { value }], out: [:concatenation, :operator] }.result).to be_success.with_data(value: "012345")
          expect(service.collection(("0".."5")).each_with_object(+"") { |string, object| step concat_strings_service, in: [string: -> { object }, other_string: -> { string }], out: [:concatenation, :operator] }.result).to be_success.with_data(value: "012345")

          # NOTE: Error result.
          expect(service.collection(enumerable(["0", "-1", :exception])).each_with_object(+"") { |string, object| step concat_strings_service, in: [string: -> { object }, other_string: -> { string }] }.result).to be_error.without_data
          expect(service.collection(enumerator(["0", "-1", :exception])).each_with_object(+"") { |string, object| step concat_strings_service, in: [string: -> { object }, other_string: -> { string }] }.result).to be_error.without_data
          expect(service.collection(lazy_enumerator(["0", "-1", :exception])).each_with_object(+"") { |string, object| step concat_strings_service, in: [string: -> { object }, other_string: -> { string }] }.result).to be_error.without_data
          expect(service.collection(["0", "-1", :exception]).each_with_object(+"") { |string, object| step concat_strings_service, in: [string: -> { object }, other_string: -> { string }] }.result).to be_error.without_data
          expect(service.collection(set(["0", "-1", :exception])).each_with_object(+"") { |string, object| step concat_strings_service, in: [string: -> { object }, other_string: -> { string }] }.result).to be_error.without_data

          expect(service.collection({"0" => "0", "-1" => "-1", :exception => :exception}).each_with_object(+"") { |(key, value), object| step concat_strings_service, in: [string: -> { object }, other_string: -> { value }] }.result).to be_error.without_data
          expect(service.collection(("-1".."-1")).each_with_object(+"") { |string, object| step concat_strings_service, in: [string: -> { object }, other_string: -> { string }] }.result).to be_error.without_data

          # NOTE: Error propagation.
          expect(service.collection(enumerable([:success, :error, :exception])).filter { |status| step status_service, in: [status: -> { status }] }.each_with_object(+"") { |status, object| object.concat(status.to_s) }.result).to be_error.without_data
          expect(service.collection(enumerator([:success, :error, :exception])).filter { |status| step status_service, in: [status: -> { status }] }.each_with_object(+"") { |status, object| object.concat(status.to_s) }.result).to be_error.without_data
          expect(service.collection(lazy_enumerator([:success, :error, :exception])).filter { |status| step status_service, in: [status: -> { status }] }.each_with_object(+"") { |status, object| object.concat(status.to_s) }.result).to be_error.without_data
          expect(service.collection([:success, :error, :exception]).filter { |status| step status_service, in: [status: -> { status }] }.each_with_object(+"") { |status, object| object.concat(status.to_s) }.result).to be_error.without_data

          expect(service.collection(set([:success, :error, :exception])).filter { |status| step status_service, in: [status: -> { status }] }.each_with_object(+"") { |status, object| object.concat(status.to_s) }.result).to be_error.without_data
          expect(service.collection({success: :success, error: :error, exception: :exception}).filter { |key, value| step status_service, in: [status: -> { value }] }.each_with_object(+"") { |(key, value), object| object.concat(status.to_s) }.result).to be_error.without_data
          expect(service.collection((:error..:error)).filter { |status| step status_service, in: [status: -> { status }] }.each_with_object(+"") { |status, object| object.concat(status.to_s) }.result).to be_error.without_data

          # NOTE: Usage on terminal chaining.
          expect { service.collection(enumerable([:success, :exception, :exception])).first.each_with_object(+"") { |string, object| object.concat(string) }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection(enumerator([:success, :exception, :exception])).first.each_with_object(+"") { |string, object| object.concat(string) }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection(lazy_enumerator([:success, :exception, :exception])).first.each_with_object(+"") { |string, object| object.concat(string) }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection([:success, :exception, :exception]).first.each_with_object(+"") { |string, object| object.concat(string) }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection(set([:success, :exception, :exception])).first.each_with_object(+"") { |string, object| object.concat(string) }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)

          expect { service.collection({success: :success, exception: :exception}).first.each_with_object(+"") { |(key, value), object| object.concat(status.to_s) }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection((:success..:success)).first.each_with_object(+"") { |string, object| object.concat(string) }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
        end
      end

      describe "#entries" do
        specify do
          # NOTE: Empty collection.
          expect([].entries).to eq([])
          expect(service.collection(enumerable([])).entries.result).to be_success.with_data(values: [])
          expect(service.collection(enumerator([])).entries.result).to be_success.with_data(values: [])
          expect(service.collection(lazy_enumerator([])).entries.result).to be_success.with_data(values: [])
          expect(service.collection(chain_enumerator([])).entries.result).to be_success.with_data(values: [])
          expect(service.collection([]).entries.result).to be_success.with_data(values: [])
          expect(service.collection({}).entries.result).to be_success.with_data(values: [])
          expect(service.collection((:success...:success)).entries.result).to be_success.with_data(values: [])
          expect(service.collection(set([])).entries.result).to be_success.with_data(values: [])

          # NOTE: Not empty collection.
          expect([:success, :success, :success].entries).to eq([:success, :success, :success])
          expect(service.collection(enumerable([:success, :success, :success])).entries.result).to be_success.with_data(values: [:success, :success, :success])
          expect(service.collection(enumerator([:success, :success, :success])).entries.result).to be_success.with_data(values: [:success, :success, :success])
          expect(service.collection(lazy_enumerator([:success, :success, :success])).entries.result).to be_success.with_data(values: [:success, :success, :success])
          expect(service.collection(chain_enumerator([:success, :success, :success])).entries.result).to be_success.with_data(values: [:success, :success, :success])
          expect(service.collection([:success, :success, :success]).entries.result).to be_success.with_data(values: [:success, :success, :success])
          expect(service.collection(set([:success])).entries.result).to be_success.with_data(values: [:success])
          expect(service.collection({success: :success}).entries.result).to be_success.with_data(values: [[:success, :success]])
          expect(service.collection((:success..:success)).entries.result).to be_success.with_data(values: [:success])

          # NOTE: Error propagation.
          expect(service.collection(enumerable([:success, :error, :exception])).select { |status| step status_service, in: [status: -> { status }] }.entries.result).to be_error.without_data
          expect(service.collection(enumerator([:success, :error, :exception])).select { |status| step status_service, in: [status: -> { status }] }.entries.result).to be_error.without_data
          expect(service.collection(lazy_enumerator([:success, :error, :exception])).select { |status| step status_service, in: [status: -> { status }] }.entries.result).to be_error.without_data
          expect(service.collection(chain_enumerator([:success, :error, :exception])).select { |status| step status_service, in: [status: -> { status }] }.entries.result).to be_error.without_data
          expect(service.collection([:success, :error, :exception]).select { |status| step status_service, in: [status: -> { status }] }.entries.result).to be_error.without_data
          expect(service.collection(set([:success, :error, :exception])).select { |status| step status_service, in: [status: -> { status }] }.entries.result).to be_error.without_data

          expect(service.collection({success: :success, error: :error, exception: :exception}).select { |key, value| step status_service, in: [status: -> { value }] }.entries.result).to be_error.without_data
          expect(service.collection((:error..:error)).select { |status| step status_service, in: [status: -> { status }] }.entries.result).to be_error.without_data

          # NOTE: Usage on terminal chaining.
          expect { service.collection(enumerable([:success, :exception, :exception])).first.entries.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection(enumerator([:success, :exception, :exception])).first.entries.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection(lazy_enumerator([:success, :exception, :exception])).first.entries.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection(chain_enumerator([:success, :exception, :exception])).first.entries.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection([:success, :exception, :exception]).first.entries.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection(set([:success, :exception, :exception])).first.entries.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)

          expect { service.collection({success: :success, exception: :exception}).first.entries.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection((:success..:success)).first.entries.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
        end
      end

      describe "#filter" do
        specify do
          # NOTE: Empty collection.
          expect([].filter { |status| condition[status] }).to eq([])
          expect(service.collection(enumerable([])).filter { |status| condition[status] }.result).to be_success.with_data(values: [])
          expect(service.collection(enumerator([])).filter { |status| condition[status] }.result).to be_success.with_data(values: [])
          expect(service.collection(lazy_enumerator([])).filter { |status| condition[status] }.result).to be_success.with_data(values: [])
          expect(service.collection(chain_enumerator([])).filter { |status| condition[status] }.result).to be_success.with_data(values: [])
          expect(service.collection([]).filter { |status| condition[status] }.result).to be_success.with_data(values: [])
          expect(service.collection(set([])).filter { |status| condition[status] }.result).to be_success.with_data(values: [])
          expect(service.collection({}).filter { |status| condition[status] }.result).to be_success.with_data(values: {})
          expect(service.collection((:success...:success)).filter { |status| condition[status] }.result).to be_success.with_data(values: [])

          # NOTE: No block.
          expect([:success, :failure, :success, :failure].filter.to_a).to eq([:success, :failure, :success, :failure])
          expect(service.collection(enumerable([:success, :failure, :success, :failure])).filter.result).to be_success.with_data(values: [:success, :failure, :success, :failure])
          expect(service.collection(enumerator([:success, :failure, :success, :failure])).filter.result).to be_success.with_data(values: [:success, :failure, :success, :failure])
          expect { service.collection(lazy_enumerator([:success, :failure, :success, :failure])).filter.result }.to raise_error(ArgumentError).with_message("tried to call lazy select without a block")
          expect(service.collection(chain_enumerator([:success, :failure, :success, :failure])).filter.result).to be_success.with_data(values: [:success, :failure, :success, :failure])
          expect(service.collection([:success, :failure, :success, :failure]).filter.result).to be_success.with_data(values: [:success, :failure, :success, :failure])

          expect(service.collection(set([:success, :failure])).filter.result).to be_success.with_data(values: [:success, :failure])
          expect(service.collection({success: :success, failure: :failure}).filter.result).to be_success.with_data(values: [[:success, :success], [:failure, :failure]])
          expect(service.collection((:success..:success)).filter.result).to be_success.with_data(values: [:success])

          # NOTE: Block.
          expect([:success, :failure, :success, :failure].filter { |status| condition[status] }).to eq([:success, :success])
          expect(service.collection(enumerable([:success, :failure, :success, :failure])).filter { |status| condition[status] }.result).to be_success.with_data(values: [:success, :success])
          expect(service.collection(enumerator([:success, :failure, :success, :failure])).filter { |status| condition[status] }.result).to be_success.with_data(values: [:success, :success])
          expect(service.collection(lazy_enumerator([:success, :failure, :success, :failure])).filter { |status| condition[status] }.result).to be_success.with_data(values: [:success, :success])
          expect(service.collection(chain_enumerator([:success, :failure, :success, :failure])).filter { |status| condition[status] }.result).to be_success.with_data(values: [:success, :success])
          expect(service.collection([:success, :failure, :success, :failure]).filter { |status| condition[status] }.result).to be_success.with_data(values: [:success, :success])

          expect(service.collection(set([:success, :failure])).filter { |status| condition[status] }.result).to be_success.with_data(values: [:success])
          expect(service.collection({success: :success, failure: :failure}).filter { |key, value| condition[value] }.result).to be_success.with_data(values: {success: :success})
          expect(service.collection((:success..:success)).filter { |status| condition[status] }.result).to be_success.with_data(values: [:success])
          expect(service.collection((:failure..:failure)).filter { |status| condition[status] }.result).to be_success.with_data(values: [])

          # NOTE: Step with no outputs.
          expect(service.collection(enumerable([:success, :failure, :success, :failure])).filter { |status| step status_service, in: [status: -> { status }] }.result).to be_success.with_data(values: [:success, :success])
          expect(service.collection(enumerator([:success, :failure, :success, :failure])).filter { |status| step status_service, in: [status: -> { status }] }.result).to be_success.with_data(values: [:success, :success])
          expect(service.collection(lazy_enumerator([:success, :failure, :success, :failure])).filter { |status| step status_service, in: [status: -> { status }] }.result).to be_success.with_data(values: [:success, :success])
          expect(service.collection(chain_enumerator([:success, :failure, :success, :failure])).filter { |status| step status_service, in: [status: -> { status }] }.result).to be_success.with_data(values: [:success, :success])
          expect(service.collection([:success, :failure, :success, :failure]).filter { |status| step status_service, in: [status: -> { status }] }.result).to be_success.with_data(values: [:success, :success])

          expect(service.collection(set([:success, :failure])).filter { |status| step status_service, in: [status: -> { status }] }.result).to be_success.with_data(values: [:success])
          expect(service.collection({success: :success, failure: :failure}).filter { |key, value| step status_service, in: [status: -> { value }] }.result).to be_success.with_data(values: {success: :success})
          expect(service.collection((:success..:success)).filter { |status| step status_service, in: [status: -> { status }] }.result).to be_success.with_data(values: [:success])
          expect(service.collection((:failure..:failure)).filter { |status| step status_service, in: [status: -> { status }] }.result).to be_success.with_data(values: [])

          # NOTE: Step with one output.
          expect(service.collection(enumerable([:success, :failure, :success, :failure])).filter { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(values: [:success, :success])
          expect(service.collection(enumerator([:success, :failure, :success, :failure])).filter { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(values: [:success, :success])
          expect(service.collection(lazy_enumerator([:success, :failure, :success, :failure])).filter { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(values: [:success, :success])
          expect(service.collection(chain_enumerator([:success, :failure, :success, :failure])).filter { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(values: [:success, :success])
          expect(service.collection([:success, :failure, :success, :failure]).filter { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(values: [:success, :success])

          expect(service.collection(set([:success, :failure])).filter { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(values: [:success])
          expect(service.collection({success: :success, failure: :failure}).filter { |key, value| step status_service, in: [status: -> { value }], out: :status_string }.result).to be_success.with_data(values: {success: :success})
          expect(service.collection((:success..:success)).filter { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(values: [:success])
          expect(service.collection((:failure..:failure)).filter { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(values: [])

          # NOTE: Step with multiple outputs.
          expect(service.collection(enumerable([:success, :failure, :success, :failure])).filter { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [:success, :success])
          expect(service.collection(enumerator([:success, :failure, :success, :failure])).filter { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [:success, :success])
          expect(service.collection(lazy_enumerator([:success, :failure, :success, :failure])).filter { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [:success, :success])
          expect(service.collection(chain_enumerator([:success, :failure, :success, :failure])).filter { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [:success, :success])
          expect(service.collection([:success, :failure, :success, :failure]).filter { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [:success, :success])

          expect(service.collection(set([:success, :failure])).filter { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [:success])
          expect(service.collection({success: :success, failure: :failure}).filter { |key, value| step status_service, in: [status: -> { value }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: {success: :success})
          expect(service.collection((:success..:success)).filter { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [:success])
          expect(service.collection((:failure..:failure)).filter { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [])

          # NOTE: Error result.
          expect(service.collection(enumerable([:success, :error, :exception])).filter { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection(enumerator([:success, :error, :exception])).filter { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection(lazy_enumerator([:success, :error, :exception])).filter { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection(chain_enumerator([:success, :error, :exception])).filter { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection([:success, :error, :exception]).filter { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data

          expect(service.collection(set([:success, :error, :exception])).filter { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection({success: :success, error: :error, exception: :exception}).filter { |key, value| step status_service, in: [status: -> { value }] }.result).to be_error.without_data
          expect(service.collection((:error..:error)).filter { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data

          # NOTE: Error propagation.
          expect(service.collection(enumerable([:success, :error, :exception])).select { |status| step status_service, in: [status: -> { status }] }.filter { |status| condition[status] }.result).to be_error.without_data
          expect(service.collection(enumerator([:success, :error, :exception])).select { |status| step status_service, in: [status: -> { status }] }.filter { |status| condition[status] }.result).to be_error.without_data
          expect(service.collection(lazy_enumerator([:success, :error, :exception])).select { |status| step status_service, in: [status: -> { status }] }.filter { |status| condition[status] }.result).to be_error.without_data
          expect(service.collection(chain_enumerator([:success, :error, :exception])).select { |status| step status_service, in: [status: -> { status }] }.filter { |status| condition[status] }.result).to be_error.without_data
          expect(service.collection([:success, :error, :exception]).select { |status| step status_service, in: [status: -> { status }] }.filter { |status| condition[status] }.result).to be_error.without_data

          expect(service.collection(set([:success, :error, :exception])).select { |status| step status_service, in: [status: -> { status }] }.filter { |status| condition[status] }.result).to be_error.without_data
          expect(service.collection({success: :success, error: :error, exception: :exception}).select { |key, value| step status_service, in: [status: -> { value }] }.filter { |key, value| condition[value] }.result).to be_error.without_data
          expect(service.collection((:error..:error)).select { |status| step status_service, in: [status: -> { status }] }.filter { |status| condition[status] }.result).to be_error.without_data

          # NOTE: Usage on terminal chaining.
          expect { service.collection(enumerable([:success, :exception, :exception])).first.filter { |status| condition[status] }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection(enumerator([:success, :exception, :exception])).first.filter { |status| condition[status] }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection(lazy_enumerator([:success, :exception, :exception])).first.filter { |status| condition[status] }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection(chain_enumerator([:success, :exception, :exception])).first.filter { |status| condition[status] }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection([:success, :exception, :exception]).first.filter { |status| condition[status] }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)

          expect { service.collection(set([:success, :exception, :exception])).first.filter { |status| condition[status] }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection({success: :success, exception: :exception}).first.filter { |key, value| condition[value] }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection((:success..:success)).first.filter { |status| condition[status] }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
        end
      end

      describe "#filter_map" do
        specify do
          # NOTE: Empty collection.
          expect([].filter_map { |status| condition[status] }).to eq([])
          expect(service.collection(enumerable([])).filter_map { |status| condition[status] }.result).to be_success.with_data(values: [])
          expect(service.collection(enumerator([])).filter_map { |status| condition[status] }.result).to be_success.with_data(values: [])
          expect(service.collection(lazy_enumerator([])).filter_map { |status| condition[status] }.result).to be_success.with_data(values: [])
          expect(service.collection(chain_enumerator([])).filter_map { |status| condition[status] }.result).to be_success.with_data(values: [])
          expect(service.collection([]).filter_map { |status| condition[status] }.result).to be_success.with_data(values: [])
          expect(service.collection(set([])).filter_map { |status| condition[status] }.result).to be_success.with_data(values: [])
          expect(service.collection({}).filter_map { |status| condition[status] }.result).to be_success.with_data(values: [])
          expect(service.collection((:success...:success)).filter_map { |status| condition[status] }.result).to be_success.with_data(values: [])

          # NOTE: No block.
          expect([:success, :success, :success].filter_map.to_a).to eq([:success, :success, :success])
          expect(service.collection(enumerable([:success, :success, :success])).filter_map.result).to be_success.with_data(values: [:success, :success, :success])
          expect(service.collection(enumerator([:success, :success, :success])).filter_map.result).to be_success.with_data(values: [:success, :success, :success])
          expect { service.collection(lazy_enumerator([:success, :success, :success])).filter_map.result }.to raise_error(ArgumentError).with_message("tried to call lazy filter_map without a block")
          expect(service.collection(chain_enumerator([:success, :success, :success])).filter_map.result).to be_success.with_data(values: [:success, :success, :success])
          expect(service.collection([:success, :success, :success]).filter_map.result).to be_success.with_data(values: [:success, :success, :success])

          expect(service.collection(set([:success, :failure])).filter_map.result).to be_success.with_data(values: [:success, :failure])
          expect(service.collection({success: :success, failure: :failure}).filter_map.result).to be_success.with_data(values: [[:success, :success], [:failure, :failure]])
          expect(service.collection((:success..:success)).filter_map.result).to be_success.with_data(values: [:success])

          # NOTE: Block.
          expect([:success, :failure, :success, :failure].filter_map { |status| condition[status] }).to eq([true, true])
          expect(service.collection(enumerable([:success, :failure, :success, :failure])).filter_map { |status| condition[status] }.result).to be_success.with_data(values: [true, true])
          expect(service.collection(enumerator([:success, :failure, :success, :failure])).filter_map { |status| condition[status] }.result).to be_success.with_data(values: [true, true])
          expect(service.collection(lazy_enumerator([:success, :failure, :success, :failure])).filter_map { |status| condition[status] }.result).to be_success.with_data(values: [true, true])
          expect(service.collection(chain_enumerator([:success, :failure, :success, :failure])).filter_map { |status| condition[status] }.result).to be_success.with_data(values: [true, true])
          expect(service.collection([:success, :failure, :success, :failure]).filter_map { |status| condition[status] }.result).to be_success.with_data(values: [true, true])

          expect(service.collection(set([:success, :failure])).filter_map { |status| condition[status] }.result).to be_success.with_data(values: [true])
          expect(service.collection({success: :success, failure: :failure}).filter_map { |key, value| condition[value] }.result).to be_success.with_data(values: [true])
          expect(service.collection((:success..:success)).filter_map { |status| condition[status] }.result).to be_success.with_data(values: [true])
          expect(service.collection((:failure..:failure)).filter_map { |status| condition[status] }.result).to be_success.with_data(values: [])

          # NOTE: Step with no outputs.
          expect(service.collection(enumerable([:success, :failure, :success, :failure])).filter_map { |status| step status_service, in: [status: -> { status }] }.result).to be_success.with_data(values: [true, true])
          expect(service.collection(enumerator([:success, :failure, :success, :failure])).filter_map { |status| step status_service, in: [status: -> { status }] }.result).to be_success.with_data(values: [true, true])
          expect(service.collection(lazy_enumerator([:success, :failure, :success, :failure])).filter_map { |status| step status_service, in: [status: -> { status }] }.result).to be_success.with_data(values: [true, true])
          expect(service.collection(chain_enumerator([:success, :failure, :success, :failure])).filter_map { |status| step status_service, in: [status: -> { status }] }.result).to be_success.with_data(values: [true, true])
          expect(service.collection([:success, :failure, :success, :failure]).filter_map { |status| step status_service, in: [status: -> { status }] }.result).to be_success.with_data(values: [true, true])

          expect(service.collection(set([:success, :failure])).filter_map { |status| step status_service, in: [status: -> { status }] }.result).to be_success.with_data(values: [true])
          expect(service.collection({success: :success, failure: :failure}).filter_map { |key, value| step status_service, in: [status: -> { value }] }.result).to be_success.with_data(values: [true])
          expect(service.collection((:success..:success)).filter_map { |status| step status_service, in: [status: -> { status }] }.result).to be_success.with_data(values: [true])
          expect(service.collection((:failure..:failure)).filter_map { |status| step status_service, in: [status: -> { status }] }.result).to be_success.with_data(values: [])

          # NOTE: Step with one output.
          expect(service.collection(enumerable([:success, :failure, :success, :failure])).filter_map { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(values: ["ok", "ok"])
          expect(service.collection(enumerator([:success, :failure, :success, :failure])).filter_map { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(values: ["ok", "ok"])
          expect(service.collection(lazy_enumerator([:success, :failure, :success, :failure])).filter_map { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(values: ["ok", "ok"])
          expect(service.collection(chain_enumerator([:success, :failure, :success, :failure])).filter_map { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(values: ["ok", "ok"])
          expect(service.collection([:success, :failure, :success, :failure]).filter_map { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(values: ["ok", "ok"])

          expect(service.collection(set([:success, :failure])).filter_map { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(values: ["ok"])
          expect(service.collection({success: :success, failure: :failure}).filter_map { |key, value| step status_service, in: [status: -> { value }], out: :status_string }.result).to be_success.with_data(values: ["ok"])
          expect(service.collection((:success..:success)).filter_map { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(values: ["ok"])
          expect(service.collection((:failure..:failure)).filter_map { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(values: [])

          # NOTE: Step with multiple outputs.
          expect(service.collection(enumerable([:success, :failure, :success, :failure])).filter_map { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [{status_string: "ok", status_code: 200}, {status_string: "ok", status_code: 200}])
          expect(service.collection(enumerator([:success, :failure, :success, :failure])).filter_map { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [{status_string: "ok", status_code: 200}, {status_string: "ok", status_code: 200}])
          expect(service.collection(lazy_enumerator([:success, :failure, :success, :failure])).filter_map { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [{status_string: "ok", status_code: 200}, {status_string: "ok", status_code: 200}])
          expect(service.collection(chain_enumerator([:success, :failure, :success, :failure])).filter_map { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [{status_string: "ok", status_code: 200}, {status_string: "ok", status_code: 200}])
          expect(service.collection([:success, :failure, :success, :failure]).filter_map { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [{status_string: "ok", status_code: 200}, {status_string: "ok", status_code: 200}])

          expect(service.collection(set([:success, :failure])).filter_map { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [{status_string: "ok", status_code: 200}])
          expect(service.collection({success: :success, failure: :failure}).filter_map { |key, value| step status_service, in: [status: -> { value }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [{status_string: "ok", status_code: 200}])
          expect(service.collection((:success..:success)).filter_map { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [{status_string: "ok", status_code: 200}])
          expect(service.collection((:failure..:failure)).filter_map { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [])

          # NOTE: Error result.
          expect(service.collection(enumerable([:success, :error, :exception])).filter_map { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection(enumerator([:success, :error, :exception])).filter_map { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection(lazy_enumerator([:success, :error, :exception])).filter_map { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection(chain_enumerator([:success, :error, :exception])).filter_map { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection([:success, :error, :exception]).filter_map { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data

          expect(service.collection(set([:success, :error, :exception])).filter_map { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection({success: :success, error: :error, exception: :exception}).filter_map { |key, value| step status_service, in: [status: -> { value }] }.result).to be_error.without_data
          expect(service.collection((:error..:error)).filter_map { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data

          # NOTE: Error propagation.
          expect(service.collection(enumerable([:success, :error, :exception])).select { |status| step status_service, in: [status: -> { status }] }.filter_map { |status| condition[status] }.result).to be_error.without_data
          expect(service.collection(enumerator([:success, :error, :exception])).select { |status| step status_service, in: [status: -> { status }] }.filter_map { |status| condition[status] }.result).to be_error.without_data
          expect(service.collection(lazy_enumerator([:success, :error, :exception])).select { |status| step status_service, in: [status: -> { status }] }.filter_map { |status| condition[status] }.result).to be_error.without_data
          expect(service.collection(chain_enumerator([:success, :error, :exception])).select { |status| step status_service, in: [status: -> { status }] }.filter_map { |status| condition[status] }.result).to be_error.without_data
          expect(service.collection([:success, :error, :exception]).select { |status| step status_service, in: [status: -> { status }] }.filter_map { |status| condition[status] }.result).to be_error.without_data

          expect(service.collection(set([:success, :error, :exception])).select { |status| step status_service, in: [status: -> { status }] }.filter_map { |status| condition[status] }.result).to be_error.without_data
          expect(service.collection({success: :success, error: :error, exception: :exception}).select { |key, value| step status_service, in: [status: -> { value }] }.filter_map { |key, value| condition[value] }.result).to be_error.without_data
          expect(service.collection((:error..:error)).select { |status| step status_service, in: [status: -> { status }] }.filter_map { |status| condition[status] }.result).to be_error.without_data

          # NOTE: Usage on terminal chaining.
          expect { service.collection(enumerable([:success, :exception, :exception])).first.filter_map { |status| condition[status] }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection(enumerator([:success, :exception, :exception])).first.filter_map { |status| condition[status] }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection(lazy_enumerator([:success, :exception, :exception])).first.filter_map { |status| condition[status] }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection(chain_enumerator([:success, :exception, :exception])).first.filter_map { |status| condition[status] }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection([:success, :exception, :exception]).first.filter_map { |status| condition[status] }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)

          expect { service.collection(set([:success, :exception, :exception])).first.filter_map { |status| condition[status] }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection({success: :success, exception: :exception}).first.filter_map { |key, value| condition[value] }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection((:success..:success)).first.filter_map { |status| condition[status] }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
        end
      end

      describe "#find" do
        specify do
          # NOTE: Empty collection.
          expect([].find { |status| condition[status] }).to eq(nil)
          expect(service.collection(enumerable([])).find { |status| condition[status] }.result).to be_failure.without_data
          expect(service.collection(enumerator([])).find { |status| condition[status] }.result).to be_failure.without_data
          expect(service.collection(lazy_enumerator([])).find { |status| condition[status] }.result).to be_failure.without_data
          expect(service.collection(chain_enumerator([])).find { |status| condition[status] }.result).to be_failure.without_data
          expect(service.collection([]).find { |status| condition[status] }.result).to be_failure.without_data
          expect(service.collection({}).find { |status| condition[status] }.result).to be_failure.without_data
          expect(service.collection((:success...:success)).find { |status| condition[status] }.result).to be_failure.without_data
          expect(service.collection(set([])).find { |status| condition[status] }.result).to be_failure.without_data

          # NOTE: No block.
          expect([:success].find.to_a).to eq([:success])
          expect(service.collection(enumerable([:success])).find.result).to be_success.with_data(values: [:success])
          expect(service.collection(enumerator([:success])).find.result).to be_success.with_data(values: [:success])
          expect(service.collection(lazy_enumerator([:success])).find.result).to be_success.with_data(values: [:success])
          expect(service.collection(chain_enumerator([:success])).find.result).to be_success.with_data(values: [:success])
          expect(service.collection([:success]).find.result).to be_success.with_data(values: [:success])
          expect(service.collection(set([:success])).find.result).to be_success.with_data(values: [:success])
          expect(service.collection({success: :success}).find.result).to be_success.with_data(values: [[:success, :success]])
          expect(service.collection((:success..:success)).find.result).to be_success.with_data(values: [:success])

          # NOTE: Matched block.
          expect([:failure, :success, :exception].find { |status| condition[status] }).to eq(:success)
          expect(service.collection(enumerable([:failure, :success, :exception])).find { |status| condition[status] }.result).to be_success.with_data(value: :success)
          expect(service.collection(enumerator([:failure, :success, :exception])).find { |status| condition[status] }.result).to be_success.with_data(value: :success)
          expect(service.collection(lazy_enumerator([:failure, :success, :exception])).find { |status| condition[status] }.result).to be_success.with_data(value: :success)
          expect(service.collection(chain_enumerator([:failure, :success, :exception])).find { |status| condition[status] }.result).to be_success.with_data(value: :success)
          expect(service.collection([:failure, :success, :exception]).find { |status| condition[status] }.result).to be_success.with_data(value: :success)
          expect(service.collection(set([:failure, :success, :exception])).find { |status| condition[status] }.result).to be_success.with_data(value: :success)

          expect(service.collection({success: :success}).find { |key, value| condition[value] }.result).to be_success.with_data(value: [:success, :success])
          expect(service.collection((:success..:success)).find { |status| condition[status] }.result).to be_success.with_data(value: :success)

          # NOTE: Not matched block.
          expect([:failure, :failure, :failure].find { |status| condition[status] }).to eq(nil)
          expect(service.collection(enumerable([:failure, :failure, :failure])).find { |status| condition[status] }.result).to be_failure.without_data
          expect(service.collection(enumerator([:failure, :failure, :failure])).find { |status| condition[status] }.result).to be_failure.without_data
          expect(service.collection(lazy_enumerator([:failure, :failure, :failure])).find { |status| condition[status] }.result).to be_failure.without_data
          expect(service.collection(chain_enumerator([:failure, :failure, :failure])).find { |status| condition[status] }.result).to be_failure.without_data
          expect(service.collection([:failure, :failure, :failure]).find { |status| condition[status] }.result).to be_failure.without_data
          expect(service.collection(set([:failure, :failure, :failure])).find { |status| condition[status] }.result).to be_failure.without_data

          expect(service.collection({failure: :failure}).find { |key, value| condition[value] }.result).to be_failure.without_data
          expect(service.collection((:failure..:failure)).find { |status| condition[status] }.result).to be_failure.without_data

          # NOTE: Not matched block with ifnode.
          expect([:failure, :failure, :failure].find(-> { :default }) { |status| condition[status] }).to eq(:default)
          expect(service.collection(enumerable([:failure, :failure, :failure])).find(-> { :default }) { |status| condition[status] }.result).to be_success.with_data(value: :default)
          expect(service.collection(enumerator([:failure, :failure, :failure])).find(-> { :default }) { |status| condition[status] }.result).to be_success.with_data(value: :default)
          expect(service.collection(lazy_enumerator([:failure, :failure, :failure])).find(-> { :default }) { |status| condition[status] }.result).to be_success.with_data(value: :default)
          expect(service.collection(chain_enumerator([:failure, :failure, :failure])).find(-> { :default }) { |status| condition[status] }.result).to be_success.with_data(value: :default)
          expect(service.collection([:failure, :failure, :failure]).find(-> { :default }) { |status| condition[status] }.result).to be_success.with_data(value: :default)
          expect(service.collection(set([:failure, :failure, :failure])).find(-> { :default }) { |status| condition[status] }.result).to be_success.with_data(value: :default)

          expect(service.collection({failure: :failure}).find(-> { :default }) { |key, value| condition[value] }.result).to be_success.with_data(value: :default)
          expect(service.collection((:failure..:failure)).find(-> { :default }) { |status| condition[status] }.result).to be_success.with_data(value: :default)

          # NOTE: Matched step with no outputs.
          expect(service.collection(enumerable([:failure, :success, :exception])).find { |status| step status_service, in: [status: -> { status }] }.result).to be_success.with_data(value: :success)
          expect(service.collection(enumerator([:failure, :success, :exception])).find { |status| step status_service, in: [status: -> { status }] }.result).to be_success.with_data(value: :success)
          expect(service.collection(lazy_enumerator([:failure, :success, :exception])).find { |status| step status_service, in: [status: -> { status }] }.result).to be_success.with_data(value: :success)
          expect(service.collection(chain_enumerator([:failure, :success, :exception])).find { |status| step status_service, in: [status: -> { status }] }.result).to be_success.with_data(value: :success)
          expect(service.collection([:failure, :success, :exception]).find { |status| step status_service, in: [status: -> { status }] }.result).to be_success.with_data(value: :success)
          expect(service.collection(set([:failure, :success, :exception])).find { |status| step status_service, in: [status: -> { status }] }.result).to be_success.with_data(value: :success)

          expect(service.collection({success: :success}).find { |key, value| step status_service, in: [status: -> { value }] }.result).to be_success.with_data(value: [:success, :success])
          expect(service.collection((:success..:success)).find { |status| step status_service, in: [status: -> { status }] }.result).to be_success.with_data(value: :success)

          # NOTE: Not matched step with no outputs.
          expect(service.collection(enumerable([:failure, :failure, :failure])).find { |status| step status_service, in: [status: -> { status }] }.result).to be_failure.without_data
          expect(service.collection(enumerator([:failure, :failure, :failure])).find { |status| step status_service, in: [status: -> { status }] }.result).to be_failure.without_data
          expect(service.collection(lazy_enumerator([:failure, :failure, :failure])).find { |status| step status_service, in: [status: -> { status }] }.result).to be_failure.without_data
          expect(service.collection(chain_enumerator([:failure, :failure, :failure])).find { |status| step status_service, in: [status: -> { status }] }.result).to be_failure.without_data
          expect(service.collection([:failure, :failure, :failure]).find { |status| step status_service, in: [status: -> { status }] }.result).to be_failure.without_data
          expect(service.collection(set([:failure, :failure, :failure])).find { |status| step status_service, in: [status: -> { status }] }.result).to be_failure.without_data

          expect(service.collection({failure: :failure}).find { |key, value| step status_service, in: [status: -> { value }] }.result).to be_failure.without_data
          expect(service.collection((:failure..:failure)).find { |status| step status_service, in: [status: -> { status }] }.result).to be_failure.without_data

          # NOTE: Not matched step with no outputs with ifnode.
          expect(service.collection(enumerable([:failure, :failure, :failure])).find(-> { :default }) { |status| step status_service, in: [status: -> { status }] }.result).to be_success.with_data(value: :default)
          expect(service.collection(enumerator([:failure, :failure, :failure])).find(-> { :default }) { |status| step status_service, in: [status: -> { status }] }.result).to be_success.with_data(value: :default)
          expect(service.collection(lazy_enumerator([:failure, :failure, :failure])).find(-> { :default }) { |status| step status_service, in: [status: -> { status }] }.result).to be_success.with_data(value: :default)
          expect(service.collection(chain_enumerator([:failure, :failure, :failure])).find(-> { :default }) { |status| step status_service, in: [status: -> { status }] }.result).to be_success.with_data(value: :default)
          expect(service.collection([:failure, :failure, :failure]).find(-> { :default }) { |status| step status_service, in: [status: -> { status }] }.result).to be_success.with_data(value: :default)
          expect(service.collection(set([:failure, :failure, :failure])).find(-> { :default }) { |status| step status_service, in: [status: -> { status }] }.result).to be_success.with_data(value: :default)

          expect(service.collection({failure: :failure}).find(-> { :default }) { |key, value| step status_service, in: [status: -> { value }] }.result).to be_success.with_data(value: :default)
          expect(service.collection((:failure..:failure)).find(-> { :default }) { |status| step status_service, in: [status: -> { status }] }.result).to be_success.with_data(value: :default)

          # NOTE: Matched step with one output.
          expect(service.collection(enumerable([:failure, :success, :exception])).find { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(value: :success)
          expect(service.collection(enumerator([:failure, :success, :exception])).find { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(value: :success)
          expect(service.collection(lazy_enumerator([:failure, :success, :exception])).find { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(value: :success)
          expect(service.collection(chain_enumerator([:failure, :success, :exception])).find { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(value: :success)
          expect(service.collection([:failure, :success, :exception]).find { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(value: :success)
          expect(service.collection(set([:failure, :success, :exception])).find { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(value: :success)

          expect(service.collection({success: :success}).find { |key, value| step status_service, in: [status: -> { value }], out: :status_string }.result).to be_success.with_data(value: [:success, :success])
          expect(service.collection((:success..:success)).find { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(value: :success)

          # NOTE: Not matched step with one output.
          expect(service.collection(enumerable([:failure, :failure, :failure])).find { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_failure.without_data
          expect(service.collection(enumerator([:failure, :failure, :failure])).find { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_failure.without_data
          expect(service.collection(lazy_enumerator([:failure, :failure, :failure])).find { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_failure.without_data
          expect(service.collection(chain_enumerator([:failure, :failure, :failure])).find { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_failure.without_data
          expect(service.collection([:failure, :failure, :failure]).find { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_failure.without_data
          expect(service.collection(set([:failure, :failure, :failure])).find { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_failure.without_data

          expect(service.collection({failure: :failure}).find { |key, value| step status_service, in: [status: -> { value }], out: :status_string }.result).to be_failure.without_data
          expect(service.collection((:failure..:failure)).find { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_failure.without_data

          # NOTE: Not matched step with one output with ifnode.
          expect(service.collection(enumerable([:failure, :failure, :failure])).find(-> { :default }) { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(value: :default)
          expect(service.collection(enumerator([:failure, :failure, :failure])).find(-> { :default }) { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(value: :default)
          expect(service.collection(lazy_enumerator([:failure, :failure, :failure])).find(-> { :default }) { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(value: :default)
          expect(service.collection(chain_enumerator([:failure, :failure, :failure])).find(-> { :default }) { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(value: :default)
          expect(service.collection([:failure, :failure, :failure]).find(-> { :default }) { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(value: :default)
          expect(service.collection(set([:failure, :failure, :failure])).find(-> { :default }) { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(value: :default)

          expect(service.collection({failure: :failure}).find(-> { :default }) { |key, value| step status_service, in: [status: -> { value }], out: :status_string }.result).to be_success.with_data(value: :default)
          expect(service.collection((:failure..:failure)).find(-> { :default }) { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(value: :default)

          # NOTE: Matched step with multiple outputs.
          expect(service.collection(enumerable([:failure, :success, :exception])).find { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(value: :success)
          expect(service.collection(enumerator([:failure, :success, :exception])).find { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(value: :success)
          expect(service.collection(lazy_enumerator([:failure, :success, :exception])).find { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(value: :success)
          expect(service.collection(chain_enumerator([:failure, :success, :exception])).find { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(value: :success)
          expect(service.collection([:failure, :success, :exception]).find { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(value: :success)
          expect(service.collection(set([:failure, :success, :exception])).find { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(value: :success)

          expect(service.collection({success: :success}).find { |key, value| step status_service, in: [status: -> { value }], out: [:status_string, :status_code] }.result).to be_success.with_data(value: [:success, :success])
          expect(service.collection((:success..:success)).find { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(value: :success)

          # NOTE: Not matched step with multiple outputs.
          expect(service.collection(enumerable([:failure, :failure, :failure])).find { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_failure.without_data
          expect(service.collection(enumerator([:failure, :failure, :failure])).find { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_failure.without_data
          expect(service.collection(lazy_enumerator([:failure, :failure, :failure])).find { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_failure.without_data
          expect(service.collection(chain_enumerator([:failure, :failure, :failure])).find { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_failure.without_data
          expect(service.collection([:failure, :failure, :failure]).find { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_failure.without_data
          expect(service.collection(set([:failure, :failure, :failure])).find { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_failure.without_data

          expect(service.collection({failure: :failure}).find { |key, value| step status_service, in: [status: -> { value }], out: [:status_string, :status_code] }.result).to be_failure.without_data
          expect(service.collection((:failure..:failure)).find { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_failure.without_data

          # NOTE: Not matched step with multiple outputs with ifnode.
          expect(service.collection(enumerable([:failure, :failure, :failure])).find(-> { :default }) { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(value: :default)
          expect(service.collection(enumerator([:failure, :failure, :failure])).find(-> { :default }) { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(value: :default)
          expect(service.collection(lazy_enumerator([:failure, :failure, :failure])).find(-> { :default }) { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(value: :default)
          expect(service.collection(chain_enumerator([:failure, :failure, :failure])).find(-> { :default }) { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(value: :default)
          expect(service.collection([:failure, :failure, :failure]).find(-> { :default }) { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(value: :default)
          expect(service.collection(set([:failure, :failure, :failure])).find(-> { :default }) { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(value: :default)

          expect(service.collection({failure: :failure}).find(-> { :default }) { |key, value| step status_service, in: [status: -> { value }], out: [:status_string, :status_code] }.result).to be_success.with_data(value: :default)
          expect(service.collection((:failure..:failure)).find(-> { :default }) { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(value: :default)

          # NOTE: Error result.
          expect(service.collection(enumerable([:failure, :error, :exception])).find { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection(enumerator([:failure, :error, :exception])).find { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection(lazy_enumerator([:failure, :error, :exception])).find { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection(chain_enumerator([:failure, :error, :exception])).find { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection([:failure, :error, :exception]).find { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection(set([:failure, :error, :exception])).find { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data

          expect(service.collection({failure: :failure, error: :error, exception: :exception}).find { |key, value| step status_service, in: [status: -> { value }] }.result).to be_error.without_data
          expect(service.collection((:error..:error)).find { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data

          # NOTE: Error propagation.
          expect(service.collection(enumerable([:failure, :error, :exception])).select { |status| step status_service, in: [status: -> { status }] }.find { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection(enumerator([:failure, :error, :exception])).select { |status| step status_service, in: [status: -> { status }] }.find { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection(lazy_enumerator([:failure, :error, :exception])).select { |status| step status_service, in: [status: -> { status }] }.find { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection(chain_enumerator([:failure, :error, :exception])).select { |status| step status_service, in: [status: -> { status }] }.find { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection([:failure, :error, :exception]).select { |status| step status_service, in: [status: -> { status }] }.find { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection(set([:failure, :error, :exception])).select { |status| step status_service, in: [status: -> { status }] }.find { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data

          expect(service.collection({failure: :failure, error: :error, exception: :exception}).select { |key, value| step status_service, in: [status: -> { value }] }.find { |key, value| step status_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection((:error..:error)).select { |status| step status_service, in: [status: -> { status }] }.find { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data

          # NOTE: Usage on terminal chaining.
          expect { service.collection(enumerable([:success, :exception, :exception])).first.find { |status| condition[status] }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection(enumerator([:success, :exception, :exception])).first.find { |status| condition[status] }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection(lazy_enumerator([:success, :exception, :exception])).first.find { |status| condition[status] }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection(chain_enumerator([:success, :exception, :exception])).first.find { |status| condition[status] }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection([:success, :exception, :exception]).first.find { |status| condition[status] }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection(set([:success, :exception, :exception])).first.find { |status| condition[status] }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)

          expect { service.collection({success: :success, exception: :exception}).first.find { |status| condition[status] }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection((:success..:success)).first.find { |status| condition[status] }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
        end
      end

      describe "#find_all" do
        specify do
          # NOTE: Empty collection.
          expect([].find_all { |status| condition[status] }).to eq([])
          expect(service.collection(enumerable([])).find_all { |status| condition[status] }.result).to be_success.with_data(values: [])
          expect(service.collection(enumerator([])).find_all { |status| condition[status] }.result).to be_success.with_data(values: [])
          expect(service.collection(lazy_enumerator([])).find_all { |status| condition[status] }.result).to be_success.with_data(values: [])
          expect(service.collection(chain_enumerator([])).find_all { |status| condition[status] }.result).to be_success.with_data(values: [])
          expect(service.collection([]).find_all { |status| condition[status] }.result).to be_success.with_data(values: [])
          expect(service.collection(set([])).find_all { |status| condition[status] }.result).to be_success.with_data(values: [])
          expect(service.collection({}).find_all { |status| condition[status] }.result).to be_success.with_data(values: [])
          expect(service.collection((:success...:success)).find_all { |status| condition[status] }.result).to be_success.with_data(values: [])

          # NOTE: No block.
          expect([:success, :failure, :success, :failure].find_all.to_a).to eq([:success, :failure, :success, :failure])
          expect(service.collection(enumerable([:success, :failure, :success, :failure])).find_all.result).to be_success.with_data(values: [:success, :failure, :success, :failure])
          expect(service.collection(enumerator([:success, :failure, :success, :failure])).find_all.result).to be_success.with_data(values: [:success, :failure, :success, :failure])
          expect { service.collection(lazy_enumerator([:success, :failure, :success, :failure])).find_all.result }.to raise_error(ArgumentError).with_message("tried to call lazy select without a block")
          expect(service.collection(chain_enumerator([:success, :failure, :success, :failure])).find_all.result).to be_success.with_data(values: [:success, :failure, :success, :failure])
          expect(service.collection([:success, :failure, :success, :failure]).find_all.result).to be_success.with_data(values: [:success, :failure, :success, :failure])

          expect(service.collection(set([:success, :failure])).find_all.result).to be_success.with_data(values: [:success, :failure])
          expect(service.collection({success: :success, failure: :failure}).find_all.result).to be_success.with_data(values: [[:success, :success], [:failure, :failure]])
          expect(service.collection((:success..:success)).find_all.result).to be_success.with_data(values: [:success])
          expect(service.collection((:failure..:failure)).find_all.result).to be_success.with_data(values: [:failure])

          # NOTE: Block.
          expect([:success, :failure, :success, :failure].find_all { |status| condition[status] }).to eq([:success, :success])
          expect(service.collection(enumerable([:success, :failure, :success, :failure])).find_all { |status| condition[status] }.result).to be_success.with_data(values: [:success, :success])
          expect(service.collection(enumerator([:success, :failure, :success, :failure])).find_all { |status| condition[status] }.result).to be_success.with_data(values: [:success, :success])
          expect(service.collection(lazy_enumerator([:success, :failure, :success, :failure])).find_all { |status| condition[status] }.result).to be_success.with_data(values: [:success, :success])
          expect(service.collection(chain_enumerator([:success, :failure, :success, :failure])).find_all { |status| condition[status] }.result).to be_success.with_data(values: [:success, :success])
          expect(service.collection([:success, :failure, :success, :failure]).find_all { |status| condition[status] }.result).to be_success.with_data(values: [:success, :success])

          expect(service.collection(set([:success, :failure])).find_all { |status| condition[status] }.result).to be_success.with_data(values: [:success])
          expect(service.collection({success: :success, failure: :failure}).find_all { |key, value| condition[value] }.result).to be_success.with_data(values: [[:success, :success]])
          expect(service.collection((:success..:success)).find_all { |status| condition[status] }.result).to be_success.with_data(values: [:success])
          expect(service.collection((:failure..:failure)).find_all { |status| condition[status] }.result).to be_success.with_data(values: [])

          # NOTE: Step with no outputs.
          expect(service.collection(enumerable([:success, :failure, :success, :failure])).find_all { |status| step status_service, in: [status: -> { status }] }.result).to be_success.with_data(values: [:success, :success])
          expect(service.collection(enumerator([:success, :failure, :success, :failure])).find_all { |status| step status_service, in: [status: -> { status }] }.result).to be_success.with_data(values: [:success, :success])
          expect(service.collection(lazy_enumerator([:success, :failure, :success, :failure])).find_all { |status| step status_service, in: [status: -> { status }] }.result).to be_success.with_data(values: [:success, :success])
          expect(service.collection(chain_enumerator([:success, :failure, :success, :failure])).find_all { |status| step status_service, in: [status: -> { status }] }.result).to be_success.with_data(values: [:success, :success])
          expect(service.collection([:success, :failure, :success, :failure]).find_all { |status| step status_service, in: [status: -> { status }] }.result).to be_success.with_data(values: [:success, :success])

          expect(service.collection(set([:success, :failure])).find_all { |status| step status_service, in: [status: -> { status }] }.result).to be_success.with_data(values: [:success])
          expect(service.collection({success: :success, failure: :failure}).find_all { |key, value| step status_service, in: [status: -> { value }] }.result).to be_success.with_data(values: [[:success, :success]])
          expect(service.collection((:success..:success)).find_all { |status| step status_service, in: [status: -> { status }] }.result).to be_success.with_data(values: [:success])
          expect(service.collection((:failure..:failure)).find_all { |status| step status_service, in: [status: -> { status }] }.result).to be_success.with_data(values: [])

          # NOTE: Step with one output.
          expect(service.collection(enumerable([:success, :failure, :success, :failure])).find_all { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(values: [:success, :success])
          expect(service.collection(enumerator([:success, :failure, :success, :failure])).find_all { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(values: [:success, :success])
          expect(service.collection(lazy_enumerator([:success, :failure, :success, :failure])).find_all { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(values: [:success, :success])
          expect(service.collection(chain_enumerator([:success, :failure, :success, :failure])).find_all { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(values: [:success, :success])
          expect(service.collection([:success, :failure, :success, :failure]).find_all { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(values: [:success, :success])

          expect(service.collection(set([:success, :failure])).find_all { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(values: [:success])
          expect(service.collection({success: :success, failure: :failure}).find_all { |key, value| step status_service, in: [status: -> { value }], out: :status_string }.result).to be_success.with_data(values: [[:success, :success]])
          expect(service.collection((:success..:success)).find_all { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(values: [:success])
          expect(service.collection((:failure..:failure)).find_all { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(values: [])

          # NOTE: Step with multiple outputs.
          expect(service.collection(enumerable([:success, :failure, :success, :failure])).find_all { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [:success, :success])
          expect(service.collection(enumerator([:success, :failure, :success, :failure])).find_all { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [:success, :success])
          expect(service.collection(lazy_enumerator([:success, :failure, :success, :failure])).find_all { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [:success, :success])
          expect(service.collection(chain_enumerator([:success, :failure, :success, :failure])).find_all { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [:success, :success])
          expect(service.collection([:success, :failure, :success, :failure]).find_all { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [:success, :success])

          expect(service.collection(set([:success, :failure])).find_all { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [:success])
          expect(service.collection({success: :success, failure: :failure}).find_all { |key, value| step status_service, in: [status: -> { value }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [[:success, :success]])
          expect(service.collection((:success..:success)).find_all { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [:success])
          expect(service.collection((:failure..:failure)).find_all { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [])

          # NOTE: Error result.
          expect(service.collection(enumerable([:success, :error, :exception])).find_all { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection(enumerator([:success, :error, :exception])).find_all { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection(lazy_enumerator([:success, :error, :exception])).find_all { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection(chain_enumerator([:success, :error, :exception])).find_all { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection([:success, :error, :exception]).find_all { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data

          expect(service.collection(set([:success, :error, :exception])).find_all { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection({success: :success, error: :error, exception: :exception}).find_all { |key, value| step status_service, in: [status: -> { value }] }.result).to be_error.without_data
          expect(service.collection((:error..:error)).find_all { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data

          # NOTE: Error propagation.
          expect(service.collection(enumerable([:success, :error, :exception])).filter { |status| step status_service, in: [status: -> { status }] }.find_all { |status| condition[status] }.result).to be_error.without_data
          expect(service.collection(enumerator([:success, :error, :exception])).filter { |status| step status_service, in: [status: -> { status }] }.find_all { |status| condition[status] }.result).to be_error.without_data
          expect(service.collection(lazy_enumerator([:success, :error, :exception])).filter { |status| step status_service, in: [status: -> { status }] }.find_all { |status| condition[status] }.result).to be_error.without_data
          expect(service.collection(chain_enumerator([:success, :error, :exception])).filter { |status| step status_service, in: [status: -> { status }] }.find_all { |status| condition[status] }.result).to be_error.without_data
          expect(service.collection([:success, :error, :exception]).filter { |status| step status_service, in: [status: -> { status }] }.find_all { |status| condition[status] }.result).to be_error.without_data

          expect(service.collection(set([:success, :error, :exception])).filter { |status| step status_service, in: [status: -> { status }] }.find_all { |status| condition[status] }.result).to be_error.without_data
          expect(service.collection({success: :success, error: :error, exception: :exception}).filter { |key, value| step status_service, in: [status: -> { value }] }.find_all { |key, value| condition[value] }.result).to be_error.without_data
          expect(service.collection((:error..:error)).filter { |status| step status_service, in: [status: -> { status }] }.find_all { |status| condition[status] }.result).to be_error.without_data

          # NOTE: Usage on terminal chaining.
          expect { service.collection(enumerable([:success, :exception, :exception])).first.find_all { |status| condition[status] }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection(enumerator([:success, :exception, :exception])).first.find_all { |status| condition[status] }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection(lazy_enumerator([:success, :exception, :exception])).first.find_all { |status| condition[status] }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection(chain_enumerator([:success, :exception, :exception])).first.find_all { |status| condition[status] }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection([:success, :exception, :exception]).first.find_all { |status| condition[status] }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)

          expect { service.collection(set([:success, :exception, :exception])).first.find_all { |status| condition[status] }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection({success: :success, exception: :exception}).first.find_all { |key, value| condition[value] }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection((:success..:success)).first.find_all { |status| condition[status] }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
        end
      end

      describe "#find_index" do
        specify do
          # NOTE: Empty collection.
          expect([].find_index { |status| condition[status] }).to eq(nil)
          expect(service.collection(enumerable([])).find_index { |status| condition[status] }.result).to be_failure.without_data
          expect(service.collection(enumerator([])).find_index { |status| condition[status] }.result).to be_failure.without_data
          expect(service.collection(lazy_enumerator([])).find_index { |status| condition[status] }.result).to be_failure.without_data
          expect(service.collection(chain_enumerator([])).find_index { |status| condition[status] }.result).to be_failure.without_data
          expect(service.collection([]).find_index { |status| condition[status] }.result).to be_failure.without_data
          expect(service.collection({}).find_index { |status| condition[status] }.result).to be_failure.without_data
          expect(service.collection((:success...:success)).find_index { |status| condition[status] }.result).to be_failure.without_data
          expect(service.collection(set([])).find_index { |status| condition[status] }.result).to be_failure.without_data

          # NOTE: Matched value.
          expect([:failure, :success, :exception].find_index(:success)).to eq(1)
          expect(service.collection(enumerable([:failure, :success, :exception])).find_index(:success).result).to be_success.with_data(value: 1)
          expect(service.collection(enumerator([:failure, :success, :exception])).find_index(:success).result).to be_success.with_data(value: 1)
          expect(service.collection(lazy_enumerator([:failure, :success, :exception])).find_index(:success).result).to be_success.with_data(value: 1)
          expect(service.collection(chain_enumerator([:failure, :success, :exception])).find_index(:success).result).to be_success.with_data(value: 1)
          expect(service.collection([:failure, :success, :exception]).find_index(:success).result).to be_success.with_data(value: 1)

          expect(service.collection(set([:failure, :success, :exception])).find_index(:success).result).to be_success.with_data(value: 1)
          expect(service.collection({success: :success}).find_index([:success, :success]).result).to be_success.with_data(value: 0)
          expect(service.collection((:success..:success)).find_index(:success).result).to be_success.with_data(value: 0)

          # NOTE: Not matched value.
          expect([:failure, :failure, :failure].find_index(:success)).to eq(nil)
          expect(service.collection(enumerable([:failure, :failure, :failure])).find_index(:success).result).to be_failure.without_data
          expect(service.collection(enumerator([:failure, :failure, :failure])).find_index(:success).result).to be_failure.without_data
          expect(service.collection(lazy_enumerator([:failure, :failure, :failure])).find_index(:success).result).to be_failure.without_data
          expect(service.collection(chain_enumerator([:failure, :failure, :failure])).find_index(:success).result).to be_failure.without_data
          expect(service.collection([:failure, :failure, :failure]).find_index(:success).result).to be_failure.without_data

          expect(service.collection(set([:failure])).find_index(:success).result).to be_failure.without_data
          expect(service.collection({failure: :failure}).find_index(:success).result).to be_failure.without_data
          expect(service.collection((:failure..:failure)).find_index(:success).result).to be_failure.without_data

          # NOTE: No block.
          expect([:success].find_index.to_a).to eq([:success])
          expect(service.collection(enumerable([:success])).find_index.result).to be_success.with_data(values: [:success])
          expect(service.collection(enumerator([:success])).find_index.result).to be_success.with_data(values: [:success])
          expect(service.collection(lazy_enumerator([:success])).find_index.result).to be_success.with_data(values: [:success])
          expect(service.collection(chain_enumerator([:success])).find_index.result).to be_success.with_data(values: [:success])
          expect(service.collection([:success]).find_index.result).to be_success.with_data(values: [:success])
          expect(service.collection(set([:success])).find_index.result).to be_success.with_data(values: [:success])
          expect(service.collection({success: :success}).find_index.result).to be_success.with_data(values: [[:success, :success]])
          expect(service.collection((:success..:success)).find_index.result).to be_success.with_data(values: [:success])

          # NOTE: Matched block.
          expect([:failure, :success, :exception].find_index { |status| condition[status] }).to eq(1)
          expect(service.collection(enumerable([:failure, :success, :exception])).find_index { |status| condition[status] }.result).to be_success.with_data(value: 1)
          expect(service.collection(enumerator([:failure, :success, :exception])).find_index { |status| condition[status] }.result).to be_success.with_data(value: 1)
          expect(service.collection(lazy_enumerator([:failure, :success, :exception])).find_index { |status| condition[status] }.result).to be_success.with_data(value: 1)
          expect(service.collection(chain_enumerator([:failure, :success, :exception])).find_index { |status| condition[status] }.result).to be_success.with_data(value: 1)
          expect(service.collection([:failure, :success, :exception]).find_index { |status| condition[status] }.result).to be_success.with_data(value: 1)
          expect(service.collection(set([:failure, :success, :exception])).find_index { |status| condition[status] }.result).to be_success.with_data(value: 1)

          expect(service.collection({success: :success}).find_index { |key, value| condition[value] }.result).to be_success.with_data(value: 0)
          expect(service.collection((:success..:success)).find_index { |status| condition[status] }.result).to be_success.with_data(value: 0)

          # NOTE: Not matched block.
          expect([:failure, :failure, :failure].find_index { |status| condition[status] }).to eq(nil)
          expect(service.collection(enumerable([:failure, :failure, :failure])).find_index { |status| condition[status] }.result).to be_failure.without_data
          expect(service.collection(enumerator([:failure, :failure, :failure])).find_index { |status| condition[status] }.result).to be_failure.without_data
          expect(service.collection(lazy_enumerator([:failure, :failure, :failure])).find_index { |status| condition[status] }.result).to be_failure.without_data
          expect(service.collection(chain_enumerator([:failure, :failure, :failure])).find_index { |status| condition[status] }.result).to be_failure.without_data
          expect(service.collection([:failure, :failure, :failure]).find_index { |status| condition[status] }.result).to be_failure.without_data
          expect(service.collection(set([:failure, :failure, :failure])).find_index { |status| condition[status] }.result).to be_failure.without_data

          expect(service.collection({failure: :failure}).find_index { |key, value| condition[value] }.result).to be_failure.without_data
          expect(service.collection((:failure..:failure)).find_index { |status| condition[status] }.result).to be_failure.without_data

          # NOTE: Matched step with no outputs.
          expect(service.collection(enumerable([:failure, :success, :exception])).find_index { |status| step status_service, in: [status: -> { status }] }.result).to be_success.with_data(value: 1)
          expect(service.collection(enumerator([:failure, :success, :exception])).find_index { |status| step status_service, in: [status: -> { status }] }.result).to be_success.with_data(value: 1)
          expect(service.collection(lazy_enumerator([:failure, :success, :exception])).find_index { |status| step status_service, in: [status: -> { status }] }.result).to be_success.with_data(value: 1)
          expect(service.collection(chain_enumerator([:failure, :success, :exception])).find_index { |status| step status_service, in: [status: -> { status }] }.result).to be_success.with_data(value: 1)
          expect(service.collection([:failure, :success, :exception]).find_index { |status| step status_service, in: [status: -> { status }] }.result).to be_success.with_data(value: 1)
          expect(service.collection(set([:failure, :success, :exception])).find_index { |status| step status_service, in: [status: -> { status }] }.result).to be_success.with_data(value: 1)

          expect(service.collection({success: :success}).find_index { |key, value| step status_service, in: [status: -> { value }] }.result).to be_success.with_data(value: 0)
          expect(service.collection((:success..:success)).find_index { |status| step status_service, in: [status: -> { status }] }.result).to be_success.with_data(value: 0)

          # NOTE: Not matched step with no outputs.
          expect(service.collection(enumerable([:failure, :failure, :failure])).find_index { |status| step status_service, in: [status: -> { status }] }.result).to be_failure.without_data
          expect(service.collection(enumerator([:failure, :failure, :failure])).find_index { |status| step status_service, in: [status: -> { status }] }.result).to be_failure.without_data
          expect(service.collection(lazy_enumerator([:failure, :failure, :failure])).find_index { |status| step status_service, in: [status: -> { status }] }.result).to be_failure.without_data
          expect(service.collection(chain_enumerator([:failure, :failure, :failure])).find_index { |status| step status_service, in: [status: -> { status }] }.result).to be_failure.without_data
          expect(service.collection([:failure, :failure, :failure]).find_index { |status| step status_service, in: [status: -> { status }] }.result).to be_failure.without_data
          expect(service.collection(set([:failure, :failure, :failure])).find_index { |status| step status_service, in: [status: -> { status }] }.result).to be_failure.without_data

          expect(service.collection({failure: :failure}).find_index { |key, value| step status_service, in: [status: -> { value }] }.result).to be_failure.without_data
          expect(service.collection((:failure..:failure)).find_index { |status| step status_service, in: [status: -> { status }] }.result).to be_failure.without_data

          # NOTE: Matched step with one output.
          expect(service.collection(enumerable([:failure, :success, :exception])).find_index { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(value: 1)
          expect(service.collection(enumerator([:failure, :success, :exception])).find_index { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(value: 1)
          expect(service.collection(lazy_enumerator([:failure, :success, :exception])).find_index { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(value: 1)
          expect(service.collection(chain_enumerator([:failure, :success, :exception])).find_index { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(value: 1)
          expect(service.collection([:failure, :success, :exception]).find_index { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(value: 1)

          expect(service.collection(set([:failure, :success, :exception])).find_index { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(value: 1)
          expect(service.collection({success: :success}).find_index { |key, value| step status_service, in: [status: -> { value }], out: :status_string }.result).to be_success.with_data(value: 0)
          expect(service.collection((:success..:success)).find_index { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(value: 0)

          # NOTE: Not matched step with one output.
          expect(service.collection(enumerable([:failure, :failure, :failure])).find_index { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_failure.without_data
          expect(service.collection(enumerator([:failure, :failure, :failure])).find_index { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_failure.without_data
          expect(service.collection(lazy_enumerator([:failure, :failure, :failure])).find_index { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_failure.without_data
          expect(service.collection(chain_enumerator([:failure, :failure, :failure])).find_index { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_failure.without_data
          expect(service.collection([:failure, :failure, :failure]).find_index { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_failure.without_data

          expect(service.collection(set([:failure])).find_index { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_failure.without_data
          expect(service.collection({failure: :failure}).find_index { |key, value| step status_service, in: [status: -> { value }], out: :status_string }.result).to be_failure.without_data
          expect(service.collection((:failure..:failure)).find_index { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_failure.without_data

          # NOTE: Matched step with multiple outputs.
          expect(service.collection(enumerable([:failure, :success, :exception])).find_index { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(value: 1)
          expect(service.collection(enumerator([:failure, :success, :exception])).find_index { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(value: 1)
          expect(service.collection(lazy_enumerator([:failure, :success, :exception])).find_index { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(value: 1)
          expect(service.collection(chain_enumerator([:failure, :success, :exception])).find_index { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(value: 1)
          expect(service.collection([:failure, :success, :exception]).find_index { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(value: 1)

          expect(service.collection(set([:failure, :success, :exception])).find_index { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(value: 1)
          expect(service.collection({success: :success}).find_index { |key, value| step status_service, in: [status: -> { value }], out: [:status_string, :status_code] }.result).to be_success.with_data(value: 0)
          expect(service.collection((:success..:success)).find_index { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(value: 0)

          # NOTE: Not matched step with multiple outputs.
          expect(service.collection(enumerable([:failure, :failure, :failure])).find_index { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_failure.without_data
          expect(service.collection(enumerator([:failure, :failure, :failure])).find_index { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_failure.without_data
          expect(service.collection(lazy_enumerator([:failure, :failure, :failure])).find_index { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_failure.without_data
          expect(service.collection(chain_enumerator([:failure, :failure, :failure])).find_index { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_failure.without_data
          expect(service.collection([:failure, :failure, :failure]).find_index { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_failure.without_data

          expect(service.collection(set([:failure])).find_index { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_failure.without_data
          expect(service.collection({failure: :failure}).find_index { |key, value| step status_service, in: [status: -> { value }], out: [:status_string, :status_code] }.result).to be_failure.without_data
          expect(service.collection((:failure..:failure)).find_index { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_failure.without_data

          # NOTE: Error result.
          expect(service.collection(enumerable([:failure, :error, :exception])).find_index { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection(enumerator([:failure, :error, :exception])).find_index { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection(lazy_enumerator([:failure, :error, :exception])).find_index { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection(chain_enumerator([:failure, :error, :exception])).find_index { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection([:failure, :error, :exception]).find_index { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data

          expect(service.collection(set([:failure, :error, :exception])).find_index { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection({failure: :failure, error: :error, exception: :exception}).find_index { |key, value| step status_service, in: [status: -> { value }] }.result).to be_error.without_data
          expect(service.collection((:error..:error)).find_index { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data

          # NOTE: Error propagation.
          expect(service.collection(enumerable([:failure, :error, :exception])).select { |status| step status_service, in: [status: -> { status }] }.find_index { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection(enumerator([:failure, :error, :exception])).select { |status| step status_service, in: [status: -> { status }] }.find_index { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection(lazy_enumerator([:failure, :error, :exception])).select { |status| step status_service, in: [status: -> { status }] }.find_index { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection(chain_enumerator([:failure, :error, :exception])).select { |status| step status_service, in: [status: -> { status }] }.find_index { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection([:failure, :error, :exception]).select { |status| step status_service, in: [status: -> { status }] }.find_index { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data

          expect(service.collection(set([:failure, :error, :exception])).select { |status| step status_service, in: [status: -> { status }] }.find_index { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection({failure: :failure, error: :error, exception: :exception}).select { |key, value| step status_service, in: [status: -> { value }] }.find_index { |key, value| step status_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection((:error..:error)).select { |status| step status_service, in: [status: -> { status }] }.find_index { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data

          # NOTE: Usage on terminal chaining.
          expect { service.collection(enumerable([:success, :exception, :exception])).first.find_index { |status| condition[status] }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection(enumerator([:success, :exception, :exception])).first.find_index { |status| condition[status] }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection(lazy_enumerator([:success, :exception, :exception])).first.find_index { |status| condition[status] }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection(chain_enumerator([:success, :exception, :exception])).first.find_index { |status| condition[status] }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection([:success, :exception, :exception]).first.find_index { |status| condition[status] }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)

          expect { service.collection(set([:success, :exception, :exception])).first.find_index { |status| condition[status] }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection({success: :success, exception: :exception}).first.find_index { |status| condition[status] }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection((:success..:success)).first.find_index { |status| condition[status] }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
        end
      end

      describe "#first" do
        specify do
          # NOTE: Empty collection.
          expect([].first).to eq(nil)
          expect(service.collection(enumerable([])).first.result).to be_failure.without_data
          expect(service.collection(enumerator([])).first.result).to be_failure.without_data
          expect(service.collection(lazy_enumerator([])).first.result).to be_failure.without_data
          expect(service.collection(chain_enumerator([])).first.result).to be_failure.without_data
          expect(service.collection([]).first.result).to be_failure.without_data
          expect(service.collection(set([])).first.result).to be_failure.without_data
          expect(service.collection({}).first.result).to be_failure.without_data
          expect(service.collection((:success...:success)).first.result).to be_success.with_data(value: :success)

          # NOTE: No n.
          expect([:success, :success, :failure].first).to eq(:success)
          expect(service.collection(enumerable([:success, :failure, :failure])).first.result).to be_success.with_data(value: :success)
          expect(service.collection(enumerator([:success, :failure, :failure])).first.result).to be_success.with_data(value: :success)
          expect(service.collection(lazy_enumerator([:success, :failure, :failure])).first.result).to be_success.with_data(value: :success)
          expect(service.collection(chain_enumerator([:success, :failure, :failure])).first.result).to be_success.with_data(value: :success)
          expect(service.collection([:success, :failure, :failure]).first.result).to be_success.with_data(value: :success)
          expect(service.collection(set([:success, :failure, :failure])).first.result).to be_success.with_data(value: :success)
          expect(service.collection({success: :success}).first.result).to be_success.with_data(value: [:success, :success])
          expect(service.collection((:success..:success)).first.result).to be_success.with_data(value: :success)

          # NOTE: N.
          expect([:success, :success, :failure].first(2)).to eq([:success, :success])
          expect(service.collection(enumerable([:success, :success, :failure])).first(2).result).to be_success.with_data(values: [:success, :success])
          expect(service.collection(enumerator([:success, :success, :failure])).first(2).result).to be_success.with_data(values: [:success, :success])
          expect(service.collection(lazy_enumerator([:success, :success, :failure])).first(2).result).to be_success.with_data(values: [:success, :success])
          expect(service.collection(chain_enumerator([:success, :success, :failure])).first(2).result).to be_success.with_data(values: [:success, :success])
          expect(service.collection([:success, :success, :failure]).first(2).result).to be_success.with_data(values: [:success, :success])
          expect(service.collection(set([:success])).first(1).result).to be_success.with_data(values: [:success])

          expect(service.collection({success: :success}).first(1) { |key, value| value.to_s.ord }.result).to be_success.with_data(values: [[:success, :success]])
          expect(service.collection((:success..:success)).first(1).result).to be_success.with_data(values: [:success])

          # NOTE: Too big N.
          expect([:success, :success].first(4)).to eq([:success, :success])
          expect(service.collection(enumerable([:success, :success])).first(4).result).to be_success.with_data(values: [:success, :success])
          expect(service.collection(enumerator([:success, :success])).first(4).result).to be_success.with_data(values: [:success, :success])
          expect(service.collection(lazy_enumerator([:success, :success])).first(4).result).to be_success.with_data(values: [:success, :success])
          expect(service.collection(chain_enumerator([:success, :success])).first(4).result).to be_success.with_data(values: [:success, :success])
          expect(service.collection([:success, :success]).first(4).result).to be_success.with_data(values: [:success, :success])
          expect(service.collection(set([:success])).first(4).result).to be_success.with_data(values: [:success])

          expect(service.collection({success: :success}).first(4) { |key, value| value.to_s.ord }.result).to be_success.with_data(values: [[:success, :success]])
          expect(service.collection((:success..:success)).first(4).result).to be_success.with_data(values: [:success])

          # NOTE: Error propagation.
          expect(service.collection(enumerable([:failure, :error, :exception])).find { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection(enumerator([:failure, :error, :exception])).find { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection(lazy_enumerator([:failure, :error, :exception])).find { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection(chain_enumerator([:failure, :error, :exception])).find { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection([:failure, :error, :exception]).find { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection(set([:failure, :error, :exception])).find { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data

          expect(service.collection({failure: :failure, error: :error, exception: :exception}).find { |key, value| step status_service, in: [status: -> { value }] }.result).to be_error.without_data
          expect(service.collection((:error..:error)).find { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data

          # NOTE: Usage on terminal chaining.
          expect { service.collection(enumerable([:success, :exception, :exception])).any?.first.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection(enumerator([:success, :exception, :exception])).any?.first.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection(lazy_enumerator([:success, :exception, :exception])).any?.first.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection(chain_enumerator([:success, :exception, :exception])).any?.first.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection([:success, :exception, :exception]).any?.first.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection(set([:success, :exception, :exception])).any?.first.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)

          expect { service.collection({success: :success, exception: :exception}).any?.first.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection((:success..:success)).any?.first.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
        end
      end

      describe "#flat_map" do
        specify do
          # NOTE: Empty collection.
          expect([].flat_map { |status| condition[status] }).to eq([])
          expect(service.collection(enumerable([])).flat_map { |status| condition[status] }.result).to be_success.with_data(values: [])
          expect(service.collection(enumerator([])).flat_map { |status| condition[status] }.result).to be_success.with_data(values: [])
          expect(service.collection(lazy_enumerator([])).flat_map { |status| condition[status] }.result).to be_success.with_data(values: [])
          expect(service.collection(chain_enumerator([])).flat_map { |status| condition[status] }.result).to be_success.with_data(values: [])
          expect(service.collection([]).flat_map { |status| condition[status] }.result).to be_success.with_data(values: [])
          expect(service.collection(set([])).flat_map { |status| condition[status] }.result).to be_success.with_data(values: [])
          expect(service.collection({}).flat_map { |status| condition[status] }.result).to be_success.with_data(values: [])
          expect(service.collection((:success...:success)).flat_map { |status| condition[status] }.result).to be_success.with_data(values: [])

          # NOTE: No block.
          expect([:success, :success, :success].flat_map.to_a).to eq([:success, :success, :success])
          expect(service.collection(enumerable([:success, :success, :success])).flat_map.result).to be_success.with_data(values: [:success, :success, :success])
          expect(service.collection(enumerator([:success, :success, :success])).flat_map.result).to be_success.with_data(values: [:success, :success, :success])
          expect { service.collection(lazy_enumerator([:success, :success, :success])).flat_map.result }.to raise_error(ArgumentError).with_message("tried to call lazy flat_map without a block")
          expect(service.collection(chain_enumerator([:success, :success, :success])).flat_map.result).to be_success.with_data(values: [:success, :success, :success])
          expect(service.collection([:success, :success, :success]).flat_map.result).to be_success.with_data(values: [:success, :success, :success])

          expect(service.collection(set([:success])).flat_map.result).to be_success.with_data(values: [:success])
          expect(service.collection({success: :success}).flat_map.result).to be_success.with_data(values: [[:success, :success]])
          expect(service.collection((:success..:success)).flat_map.result).to be_success.with_data(values: [:success])

          # NOTE: Block.
          expect([:success, :success, :success].flat_map { |status| condition[status] }).to eq([true, true, true])
          expect(service.collection(enumerable([:success, :success, :success])).flat_map { |status| condition[status] }.result).to be_success.with_data(values: [true, true, true])
          expect(service.collection(enumerator([:success, :success, :success])).flat_map { |status| condition[status] }.result).to be_success.with_data(values: [true, true, true])
          expect(service.collection(lazy_enumerator([:success, :success, :success])).flat_map { |status| condition[status] }.result).to be_success.with_data(values: [true, true, true])
          expect(service.collection(chain_enumerator([:success, :success, :success])).flat_map { |status| condition[status] }.result).to be_success.with_data(values: [true, true, true])
          expect(service.collection([:success, :success, :success]).flat_map { |status| condition[status] }.result).to be_success.with_data(values: [true, true, true])

          expect(service.collection(set([:success])).flat_map { |status| condition[status] }.result).to be_success.with_data(values: [true])
          expect(service.collection({success: :success}).flat_map { |key, value| condition[value] }.result).to be_success.with_data(values: [true])
          expect(service.collection((:success..:success)).flat_map { |status| condition[status] }.result).to be_success.with_data(values: [true])

          # NOTE: Flatten.
          expect([:success, :success, :success].flat_map { |status| [condition[status], condition[status]] }).to eq([true, true, true, true, true, true])
          expect(service.collection(enumerable([:success, :success, :success])).flat_map { |status| [condition[status], condition[status]] }.result).to be_success.with_data(values: [true, true, true, true, true, true])
          expect(service.collection(enumerator([:success, :success, :success])).flat_map { |status| [condition[status], condition[status]] }.result).to be_success.with_data(values: [true, true, true, true, true, true])
          expect(service.collection(lazy_enumerator([:success, :success, :success])).flat_map { |status| [condition[status], condition[status]] }.result).to be_success.with_data(values: [true, true, true, true, true, true])
          expect(service.collection(chain_enumerator([:success, :success, :success])).flat_map { |status| [condition[status], condition[status]] }.result).to be_success.with_data(values: [true, true, true, true, true, true])
          expect(service.collection([:success, :success, :success]).flat_map { |status| [condition[status], condition[status]] }.result).to be_success.with_data(values: [true, true, true, true, true, true])

          expect(service.collection(set([:success])).flat_map { |status| [condition[status], condition[status]] }.result).to be_success.with_data(values: [true, true])
          expect(service.collection({success: :success}).flat_map { |key, value| [condition[value], condition[value]] }.result).to be_success.with_data(values: [true, true])
          expect(service.collection((:success..:success)).flat_map { |status| [condition[status], condition[status]] }.result).to be_success.with_data(values: [true, true])

          # NOTE: Step with no outputs.
          expect(service.collection(enumerable([:success, :success, :success])).flat_map { |status| step status_service, in: [status: -> { status }] }.result).to be_success.with_data(values: [true, true, true])
          expect(service.collection(enumerator([:success, :success, :success])).flat_map { |status| step status_service, in: [status: -> { status }] }.result).to be_success.with_data(values: [true, true, true])
          expect(service.collection(lazy_enumerator([:success, :success, :success])).flat_map { |status| step status_service, in: [status: -> { status }] }.result).to be_success.with_data(values: [true, true, true])
          expect(service.collection(chain_enumerator([:success, :success, :success])).flat_map { |status| step status_service, in: [status: -> { status }] }.result).to be_success.with_data(values: [true, true, true])
          expect(service.collection([:success, :success, :success]).flat_map { |status| step status_service, in: [status: -> { status }] }.result).to be_success.with_data(values: [true, true, true])

          expect(service.collection(set([:success])).flat_map { |status| step status_service, in: [status: -> { status }] }.result).to be_success.with_data(values: [true])
          expect(service.collection({success: :success}).flat_map { |key, value| step status_service, in: [status: -> { value }] }.result).to be_success.with_data(values: [true])
          expect(service.collection((:success..:success)).flat_map { |status| step status_service, in: [status: -> { status }] }.result).to be_success.with_data(values: [true])

          # NOTE: Step with one output.
          expect(service.collection(enumerable([:success, :success, :success])).flat_map { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(values: ["ok", "ok", "ok"])
          expect(service.collection(enumerator([:success, :success, :success])).flat_map { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(values: ["ok", "ok", "ok"])
          expect(service.collection(lazy_enumerator([:success, :success, :success])).flat_map { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(values: ["ok", "ok", "ok"])
          expect(service.collection(chain_enumerator([:success, :success, :success])).flat_map { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(values: ["ok", "ok", "ok"])
          expect(service.collection([:success, :success, :success]).flat_map { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(values: ["ok", "ok", "ok"])

          expect(service.collection(set([:success])).flat_map { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(values: ["ok"])
          expect(service.collection({success: :success}).flat_map { |key, value| step status_service, in: [status: -> { value }], out: :status_string }.result).to be_success.with_data(values: ["ok"])
          expect(service.collection((:success..:success)).flat_map { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(values: ["ok"])

          # NOTE: Step with multiple outputs.
          expect(service.collection(enumerable([:success, :success, :success])).flat_map { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [{status_string: "ok", status_code: 200}, {status_string: "ok", status_code: 200}, {status_string: "ok", status_code: 200}])
          expect(service.collection(enumerator([:success, :success, :success])).flat_map { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [{status_string: "ok", status_code: 200}, {status_string: "ok", status_code: 200}, {status_string: "ok", status_code: 200}])
          expect(service.collection(lazy_enumerator([:success, :success, :success])).flat_map { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [{status_string: "ok", status_code: 200}, {status_string: "ok", status_code: 200}, {status_string: "ok", status_code: 200}])
          expect(service.collection(chain_enumerator([:success, :success, :success])).flat_map { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [{status_string: "ok", status_code: 200}, {status_string: "ok", status_code: 200}, {status_string: "ok", status_code: 200}])
          expect(service.collection([:success, :success, :success]).flat_map { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [{status_string: "ok", status_code: 200}, {status_string: "ok", status_code: 200}, {status_string: "ok", status_code: 200}])

          expect(service.collection(set([:success])).flat_map { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [{status_string: "ok", status_code: 200}])
          expect(service.collection({success: :success}).flat_map { |key, value| step status_service, in: [status: -> { value }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [{status_string: "ok", status_code: 200}])
          expect(service.collection((:success..:success)).flat_map { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [{status_string: "ok", status_code: 200}])

          # NOTE: Error result.
          expect(service.collection(enumerable([:success, :error, :exception])).flat_map { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection(enumerator([:success, :error, :exception])).flat_map { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection(lazy_enumerator([:success, :error, :exception])).flat_map { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection(chain_enumerator([:success, :error, :exception])).flat_map { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection([:success, :error, :exception]).flat_map { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data

          expect(service.collection(set([:success, :error, :exception])).flat_map { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection({success: :success, error: :error, exception: :exception}).flat_map { |key, value| step status_service, in: [status: -> { value }] }.result).to be_error.without_data
          expect(service.collection((:error..:error)).flat_map { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data

          # NOTE: Error propagation.
          expect(service.collection(enumerable([:success, :error, :exception])).select { |status| step status_service, in: [status: -> { status }] }.flat_map { |status| condition[status] }.result).to be_error.without_data
          expect(service.collection(enumerator([:success, :error, :exception])).select { |status| step status_service, in: [status: -> { status }] }.flat_map { |status| condition[status] }.result).to be_error.without_data
          expect(service.collection(lazy_enumerator([:success, :error, :exception])).select { |status| step status_service, in: [status: -> { status }] }.flat_map { |status| condition[status] }.result).to be_error.without_data
          expect(service.collection(chain_enumerator([:success, :error, :exception])).select { |status| step status_service, in: [status: -> { status }] }.flat_map { |status| condition[status] }.result).to be_error.without_data
          expect(service.collection([:success, :error, :exception]).select { |status| step status_service, in: [status: -> { status }] }.flat_map { |status| condition[status] }.result).to be_error.without_data

          expect(service.collection(set([:success, :error, :exception])).select { |status| step status_service, in: [status: -> { status }] }.flat_map { |status| condition[status] }.result).to be_error.without_data
          expect(service.collection({success: :success, error: :error, exception: :exception}).select { |key, value| step status_service, in: [status: -> { value }] }.flat_map { |key, value| condition[value] }.result).to be_error.without_data
          expect(service.collection((:error..:error)).select { |status| step status_service, in: [status: -> { status }] }.flat_map { |status| condition[status] }.result).to be_error.without_data

          # NOTE: Usage on terminal chaining.
          expect { service.collection(enumerable([:success, :exception, :exception])).first.flat_map { |status| condition[status] }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection(enumerator([:success, :exception, :exception])).first.flat_map { |status| condition[status] }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection(lazy_enumerator([:success, :exception, :exception])).first.flat_map { |status| condition[status] }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection(chain_enumerator([:success, :exception, :exception])).first.flat_map { |status| condition[status] }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection([:success, :exception, :exception]).first.flat_map { |status| condition[status] }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)

          expect { service.collection(set([:success, :exception, :exception])).first.flat_map { |status| condition[status] }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection({success: :success, exception: :exception}).first.flat_map { |key, value| condition[value] }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection((:success..:success)).first.flat_map { |status| condition[status] }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
        end
      end

      describe "#grep" do
        specify do
          # NOTE: Empty collection.
          expect([].grep(/success/) { |status| condition[status] }).to eq([])
          expect(service.collection(enumerable([])).grep(/success/) { |status| condition[status] }.result).to be_success.with_data(values: [])
          expect(service.collection(enumerator([])).grep(/success/) { |status| condition[status] }.result).to be_success.with_data(values: [])
          expect(service.collection(lazy_enumerator([])).grep(/success/) { |status| condition[status] }.result).to be_success.with_data(values: [])
          expect(service.collection(chain_enumerator([])).grep(/success/) { |status| condition[status] }.result).to be_success.with_data(values: [])
          expect(service.collection([]).grep(/success/) { |status| condition[status] }.result).to be_success.with_data(values: [])
          expect(service.collection(set([])).grep(/success/) { |status| condition[status] }.result).to be_success.with_data(values: [])
          expect(service.collection({}).grep(/success/) { |key, value| condition[value] }.result).to be_success.with_data(values: [])
          expect(service.collection((:success...:success)).grep(/success/) { |status| condition[status] }.result).to be_success.with_data(values: [])

          # NOTE: Only pattern.
          expect([:failure, :success, :failure, :success].grep(/success/)).to eq([:success, :success])
          expect(service.collection(enumerable([:failure, :success, :failure, :success])).grep(/success/).result).to be_success.with_data(values: [:success, :success])
          expect(service.collection(enumerator([:failure, :success, :failure, :success])).grep(/success/).result).to be_success.with_data(values: [:success, :success])
          expect(service.collection(lazy_enumerator([:failure, :success, :failure, :success])).grep(/success/).result).to be_success.with_data(values: [:success, :success])
          expect(service.collection(chain_enumerator([:failure, :success, :failure, :success])).grep(/success/).result).to be_success.with_data(values: [:success, :success])
          expect(service.collection([:failure, :success, :failure, :success]).grep(/success/).result).to be_success.with_data(values: [:success, :success])

          expect(service.collection(set([:failure, :success])).grep(/success/).result).to be_success.with_data(values: [:success])
          expect(service.collection({failure: :failure, success: :success}).grep([:success, :success]).result).to be_success.with_data(values: [[:success, :success]])
          expect(service.collection((:success..:success)).grep(/success/).result).to be_success.with_data(values: [:success])
          expect(service.collection((:failure..:failure)).grep(/success/).result).to be_success.with_data(values: [])

          # NOTE: Block.
          expect([:failure, :success, :failure, :success].grep(/success/) { |status| condition[status] }).to eq([true, true])
          expect(service.collection(enumerable([:failure, :success, :failure, :success])).grep(/success/) { |status| condition[status] }.result).to be_success.with_data(values: [true, true])
          expect(service.collection(enumerator([:failure, :success, :failure, :success])).grep(/success/) { |status| condition[status] }.result).to be_success.with_data(values: [true, true])
          expect(service.collection(lazy_enumerator([:failure, :success, :failure, :success])).grep(/success/) { |status| condition[status] }.result).to be_success.with_data(values: [true, true])
          expect(service.collection(chain_enumerator([:failure, :success, :failure, :success])).grep(/success/) { |status| condition[status] }.result).to be_success.with_data(values: [true, true])
          expect(service.collection([:failure, :success, :failure, :success]).grep(/success/) { |status| condition[status] }.result).to be_success.with_data(values: [true, true])

          expect(service.collection(set([:failure, :success])).grep(/success/) { |status| condition[status] }.result).to be_success.with_data(values: [true])
          expect(service.collection({failure: :failure, success: :success}).grep([:success, :success]) { |key, value| condition[value] }.result).to be_success.with_data(values: [true])
          expect(service.collection((:success..:success)).grep(/success/) { |status| condition[status] }.result).to be_success.with_data(values: [true])
          expect(service.collection((:failure..:failure)).grep(/success/) { |status| condition[status] }.result).to be_success.with_data(values: [])

          # NOTE: Step with no outputs.
          expect(service.collection(enumerable([:failure, :success, :failure, :success])).grep(/success/) { |status| step status_service, in: [status: -> { status }] }.result).to be_success.with_data(values: [true, true])
          expect(service.collection(enumerator([:failure, :success, :failure, :success])).grep(/success/) { |status| step status_service, in: [status: -> { status }] }.result).to be_success.with_data(values: [true, true])
          expect(service.collection(lazy_enumerator([:failure, :success, :failure, :success])).grep(/success/) { |status| step status_service, in: [status: -> { status }] }.result).to be_success.with_data(values: [true, true])
          expect(service.collection(chain_enumerator([:failure, :success, :failure, :success])).grep(/success/) { |status| step status_service, in: [status: -> { status }] }.result).to be_success.with_data(values: [true, true])
          expect(service.collection([:failure, :success, :failure, :success]).grep(/success/) { |status| step status_service, in: [status: -> { status }] }.result).to be_success.with_data(values: [true, true])

          expect(service.collection(set([:failure, :success])).grep(/success/) { |status| step status_service, in: [status: -> { status }] }.result).to be_success.with_data(values: [true])
          expect(service.collection({failure: :failure, success: :success}).grep([:success, :success]) { |key, value| step status_service, in: [status: -> { value }] }.result).to be_success.with_data(values: [true])
          expect(service.collection((:success..:success)).grep(/success/) { |status| step status_service, in: [status: -> { status }] }.result).to be_success.with_data(values: [true])
          expect(service.collection((:failure..:failure)).grep(/success/) { |status| step status_service, in: [status: -> { status }] }.result).to be_success.with_data(values: [])

          # NOTE: Step with one output.
          expect(service.collection(enumerable([:failure, :success, :failure, :success])).grep(/success/) { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(values: ["ok", "ok"])
          expect(service.collection(enumerator([:failure, :success, :failure, :success])).grep(/success/) { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(values: ["ok", "ok"])
          expect(service.collection(lazy_enumerator([:failure, :success, :failure, :success])).grep(/success/) { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(values: ["ok", "ok"])
          expect(service.collection(chain_enumerator([:failure, :success, :failure, :success])).grep(/success/) { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(values: ["ok", "ok"])
          expect(service.collection([:failure, :success, :failure, :success]).grep(/success/) { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(values: ["ok", "ok"])

          expect(service.collection(set([:failure, :success])).grep(/success/) { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(values: ["ok"])
          expect(service.collection({failure: :failure, success: :success}).grep([:success, :success]) { |key, value| step status_service, in: [status: -> { value }], out: :status_string }.result).to be_success.with_data(values: ["ok"])
          expect(service.collection((:success..:success)).grep(/success/) { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(values: ["ok"])
          expect(service.collection((:failure..:failure)).grep(/success/) { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(values: [])

          # NOTE: Step with multiple outputs.
          expect(service.collection(enumerable([:failure, :success, :failure, :success])).grep(/success/) { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [{status_string: "ok", status_code: 200}, {status_string: "ok", status_code: 200}])
          expect(service.collection(enumerator([:failure, :success, :failure, :success])).grep(/success/) { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [{status_string: "ok", status_code: 200}, {status_string: "ok", status_code: 200}])
          expect(service.collection(lazy_enumerator([:failure, :success, :failure, :success])).grep(/success/) { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [{status_string: "ok", status_code: 200}, {status_string: "ok", status_code: 200}])
          expect(service.collection(chain_enumerator([:failure, :success, :failure, :success])).grep(/success/) { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [{status_string: "ok", status_code: 200}, {status_string: "ok", status_code: 200}])
          expect(service.collection([:failure, :success, :failure, :success]).grep(/success/) { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [{status_string: "ok", status_code: 200}, {status_string: "ok", status_code: 200}])

          expect(service.collection(set([:failure, :success])).grep(/success/) { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [{status_string: "ok", status_code: 200}])
          expect(service.collection({failure: :failure, success: :success}).grep([:success, :success]) { |key, value| step status_service, in: [status: -> { value }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [{status_string: "ok", status_code: 200}])
          expect(service.collection((:success..:success)).grep(/success/) { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [{status_string: "ok", status_code: 200}])
          expect(service.collection((:failure..:failure)).grep(/success/) { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [])

          # NOTE: Error result.
          expect(service.collection(enumerable([:failure, :error, :exception])).grep(/error/) { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection(enumerator([:failure, :error, :exception])).grep(/error/) { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection(lazy_enumerator([:failure, :error, :exception])).grep(/error/) { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection(chain_enumerator([:failure, :error, :exception])).grep(/error/) { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection([:failure, :error, :exception]).grep(/error/) { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data

          expect(service.collection(set([:failure, :error, :exception])).grep(/error/) { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection({failure: :failure, error: :error, exception: :exception}).grep([:error, :error]) { |key, value| step status_service, in: [status: -> { value }] }.result).to be_error.without_data
          expect(service.collection((:error..:error)).grep(/error/) { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data

          # NOTE: Error propagation.
          expect(service.collection(enumerable([:success, :error, :exception])).select { |status| step status_service, in: [status: -> { status }] }.grep(/success/) { |status| condition[status] }.result).to be_error.without_data
          expect(service.collection(enumerator([:success, :error, :exception])).select { |status| step status_service, in: [status: -> { status }] }.grep(/success/) { |status| condition[status] }.result).to be_error.without_data
          expect(service.collection(lazy_enumerator([:success, :error, :exception])).select { |status| step status_service, in: [status: -> { status }] }.grep(/success/) { |status| condition[status] }.result).to be_error.without_data
          expect(service.collection(chain_enumerator([:success, :error, :exception])).select { |status| step status_service, in: [status: -> { status }] }.grep(/success/) { |status| condition[status] }.result).to be_error.without_data
          expect(service.collection([:success, :error, :exception]).select { |status| step status_service, in: [status: -> { status }] }.grep(/success/) { |status| condition[status] }.result).to be_error.without_data

          expect(service.collection(set([:success, :error, :exception])).select { |status| step status_service, in: [status: -> { status }] }.grep(/success/) { |status| condition[status] }.result).to be_error.without_data
          expect(service.collection({success: :success, error: :error, exception: :exception}).select { |key, value| step status_service, in: [status: -> { value }] }.grep([:success, :success]) { |key, value| condition[value] }.result).to be_error.without_data
          expect(service.collection((:error..:error)).select { |status| step status_service, in: [status: -> { status }] }.grep(/success/) { |status| condition[status] }.result).to be_error.without_data

          # NOTE: Usage on terminal chaining.
          expect { service.collection(enumerable([:success, :exception, :exception])).first.grep(/success/) { |status| condition[status] }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection(enumerator([:success, :exception, :exception])).first.grep(/success/) { |status| condition[status] }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection(lazy_enumerator([:success, :exception, :exception])).first.grep(/success/) { |status| condition[status] }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection(chain_enumerator([:success, :exception, :exception])).first.grep(/success/) { |status| condition[status] }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection([:success, :exception, :exception]).first.grep(/success/) { |status| condition[status] }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)

          expect { service.collection(set([:success, :exception, :exception])).first.grep(/success/) { |status| condition[status] }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection({success: :success, exception: :exception}).first.grep([:success, :success]) { |key, value| condition[value] }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection((:success..:success)).first.grep(/success/) { |status| condition[status] }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
        end
      end

      describe "#grep_v" do
        specify do
          # NOTE: Empty collection.
          expect([].grep_v(/success/) { |status| condition[status] }).to eq([])
          expect(service.collection(enumerable([])).grep_v(/success/) { |status| condition[status] }.result).to be_success.with_data(values: [])
          expect(service.collection(enumerator([])).grep_v(/success/) { |status| condition[status] }.result).to be_success.with_data(values: [])
          expect(service.collection(lazy_enumerator([])).grep_v(/success/) { |status| condition[status] }.result).to be_success.with_data(values: [])
          expect(service.collection(chain_enumerator([])).grep_v(/success/) { |status| condition[status] }.result).to be_success.with_data(values: [])
          expect(service.collection([]).grep_v(/success/) { |status| condition[status] }.result).to be_success.with_data(values: [])
          expect(service.collection(set([])).grep_v(/success/) { |status| condition[status] }.result).to be_success.with_data(values: [])
          expect(service.collection({}).grep_v(/success/) { |key, value| condition[value] }.result).to be_success.with_data(values: [])
          expect(service.collection((:success...:success)).grep_v(/success/) { |status| condition[status] }.result).to be_success.with_data(values: [])

          # NOTE: Only pattern.
          expect([:failure, :success, :failure, :success].grep_v(/success/)).to eq([:failure, :failure])
          expect(service.collection(enumerable([:failure, :success, :failure, :success])).grep_v(/success/).result).to be_success.with_data(values: [:failure, :failure])
          expect(service.collection(enumerator([:failure, :success, :failure, :success])).grep_v(/success/).result).to be_success.with_data(values: [:failure, :failure])
          expect(service.collection(lazy_enumerator([:failure, :success, :failure, :success])).grep_v(/success/).result).to be_success.with_data(values: [:failure, :failure])
          expect(service.collection(chain_enumerator([:failure, :success, :failure, :success])).grep_v(/success/).result).to be_success.with_data(values: [:failure, :failure])
          expect(service.collection([:failure, :success, :failure, :success]).grep_v(/success/).result).to be_success.with_data(values: [:failure, :failure])

          expect(service.collection(set([:failure, :success])).grep_v(/success/).result).to be_success.with_data(values: [:failure])
          expect(service.collection({failure: :failure, success: :success}).grep_v([:success, :success]).result).to be_success.with_data(values: [[:failure, :failure]])
          expect(service.collection((:success..:success)).grep_v(/success/).result).to be_success.with_data(values: [])
          expect(service.collection((:failure..:failure)).grep_v(/success/).result).to be_success.with_data(values: [:failure])

          # NOTE: Block.
          expect([:failure, :success, :failure, :success].grep_v(/success/) { |status| condition[status] }).to eq([false, false])
          expect(service.collection(enumerable([:failure, :success, :failure, :success])).grep_v(/success/) { |status| condition[status] }.result).to be_success.with_data(values: [false, false])
          expect(service.collection(enumerator([:failure, :success, :failure, :success])).grep_v(/success/) { |status| condition[status] }.result).to be_success.with_data(values: [false, false])
          expect(service.collection(lazy_enumerator([:failure, :success, :failure, :success])).grep_v(/success/) { |status| condition[status] }.result).to be_success.with_data(values: [false, false])
          expect(service.collection(chain_enumerator([:failure, :success, :failure, :success])).grep_v(/success/) { |status| condition[status] }.result).to be_success.with_data(values: [false, false])
          expect(service.collection([:failure, :success, :failure, :success]).grep_v(/success/) { |status| condition[status] }.result).to be_success.with_data(values: [false, false])

          expect(service.collection(set([:failure, :success])).grep_v(/success/) { |status| condition[status] }.result).to be_success.with_data(values: [false])
          expect(service.collection({failure: :failure, success: :success}).grep_v([:success, :success]) { |key, value| condition[value] }.result).to be_success.with_data(values: [false])
          expect(service.collection((:success..:success)).grep_v(/success/) { |status| condition[status] }.result).to be_success.with_data(values: [])
          expect(service.collection((:failure..:failure)).grep_v(/success/) { |status| condition[status] }.result).to be_success.with_data(values: [false])

          # NOTE: Step with no outputs.
          expect(service.collection(enumerable([:failure, :success, :failure, :success])).grep_v(/success/) { |status| step status_service, in: [status: -> { status }] }.result).to be_success.with_data(values: [false, false])
          expect(service.collection(enumerator([:failure, :success, :failure, :success])).grep_v(/success/) { |status| step status_service, in: [status: -> { status }] }.result).to be_success.with_data(values: [false, false])
          expect(service.collection(lazy_enumerator([:failure, :success, :failure, :success])).grep_v(/success/) { |status| step status_service, in: [status: -> { status }] }.result).to be_success.with_data(values: [false, false])
          expect(service.collection(chain_enumerator([:failure, :success, :failure, :success])).grep_v(/success/) { |status| step status_service, in: [status: -> { status }] }.result).to be_success.with_data(values: [false, false])
          expect(service.collection([:failure, :success, :failure, :success]).grep_v(/success/) { |status| step status_service, in: [status: -> { status }] }.result).to be_success.with_data(values: [false, false])

          expect(service.collection(set([:failure, :success])).grep_v(/success/) { |status| step status_service, in: [status: -> { status }] }.result).to be_success.with_data(values: [false])
          expect(service.collection({failure: :failure, success: :success}).grep_v([:success, :success]) { |key, value| step status_service, in: [status: -> { value }] }.result).to be_success.with_data(values: [false])
          expect(service.collection((:success..:success)).grep_v(/success/) { |status| step status_service, in: [status: -> { status }] }.result).to be_success.with_data(values: [])
          expect(service.collection((:failure..:failure)).grep_v(/success/) { |status| step status_service, in: [status: -> { status }] }.result).to be_success.with_data(values: [false])

          # NOTE: Step with one output.
          expect(service.collection(enumerable([:failure, :success, :failure, :success])).grep_v(/success/) { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(values: [nil, nil])
          expect(service.collection(enumerator([:failure, :success, :failure, :success])).grep_v(/success/) { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(values: [nil, nil])
          expect(service.collection(lazy_enumerator([:failure, :success, :failure, :success])).grep_v(/success/) { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(values: [nil, nil])
          expect(service.collection(chain_enumerator([:failure, :success, :failure, :success])).grep_v(/success/) { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(values: [nil, nil])
          expect(service.collection([:failure, :success, :failure, :success]).grep_v(/success/) { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(values: [nil, nil])

          expect(service.collection(set([:failure, :success])).grep_v(/success/) { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(values: [nil])
          expect(service.collection({failure: :failure, success: :success}).grep_v([:success, :success]) { |key, value| step status_service, in: [status: -> { value }], out: :status_string }.result).to be_success.with_data(values: [nil])
          expect(service.collection((:success..:success)).grep_v(/success/) { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(values: [])
          expect(service.collection((:failure..:failure)).grep_v(/success/) { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(values: [nil])

          # NOTE: Step with multiple outputs.
          expect(service.collection(enumerable([:failure, :success, :failure, :success])).grep_v(/success/) { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [nil, nil])
          expect(service.collection(enumerator([:failure, :success, :failure, :success])).grep_v(/success/) { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [nil, nil])
          expect(service.collection(lazy_enumerator([:failure, :success, :failure, :success])).grep_v(/success/) { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [nil, nil])
          expect(service.collection(chain_enumerator([:failure, :success, :failure, :success])).grep_v(/success/) { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [nil, nil])
          expect(service.collection([:failure, :success, :failure, :success]).grep_v(/success/) { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [nil, nil])

          expect(service.collection(set([:failure, :success])).grep_v(/success/) { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [nil])
          expect(service.collection({failure: :failure, success: :success}).grep_v([:success, :success]) { |key, value| step status_service, in: [status: -> { value }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [nil])
          expect(service.collection((:success..:success)).grep_v(/success/) { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [])
          expect(service.collection((:failure..:failure)).grep_v(/success/) { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [nil])

          # NOTE: Error result.
          expect(service.collection(enumerable([:failure, :error, :exception])).grep_v(/failure/) { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection(enumerator([:failure, :error, :exception])).grep_v(/failure/) { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection(lazy_enumerator([:failure, :error, :exception])).grep_v(/failure/) { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection(chain_enumerator([:failure, :error, :exception])).grep_v(/failure/) { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection([:failure, :error, :exception]).grep_v(/failure/) { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data

          expect(service.collection(set([:failure, :error, :exception])).grep_v(/failure/) { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection({failure: :failure, error: :error, exception: :exception}).grep_v([:failure, :failure]) { |key, value| step status_service, in: [status: -> { value }] }.result).to be_error.without_data
          expect(service.collection((:error..:error)).grep_v(/failure/) { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data

          # NOTE: Error propagation.
          expect(service.collection(enumerable([:success, :error, :exception])).select { |status| step status_service, in: [status: -> { status }] }.grep_v(/success/) { |status| condition[status] }.result).to be_error.without_data
          expect(service.collection(enumerator([:success, :error, :exception])).select { |status| step status_service, in: [status: -> { status }] }.grep_v(/success/) { |status| condition[status] }.result).to be_error.without_data
          expect(service.collection(lazy_enumerator([:success, :error, :exception])).select { |status| step status_service, in: [status: -> { status }] }.grep_v(/success/) { |status| condition[status] }.result).to be_error.without_data
          expect(service.collection(chain_enumerator([:success, :error, :exception])).select { |status| step status_service, in: [status: -> { status }] }.grep_v(/success/) { |status| condition[status] }.result).to be_error.without_data
          expect(service.collection([:success, :error, :exception]).select { |status| step status_service, in: [status: -> { status }] }.grep_v(/success/) { |status| condition[status] }.result).to be_error.without_data

          expect(service.collection(set([:success, :error, :exception])).select { |status| step status_service, in: [status: -> { status }] }.grep_v(/success/) { |status| condition[status] }.result).to be_error.without_data
          expect(service.collection({success: :success, error: :error, exception: :exception}).select { |key, value| step status_service, in: [status: -> { value }] }.grep_v([:success, :success]) { |key, value| condition[value] }.result).to be_error.without_data
          expect(service.collection((:error..:error)).select { |status| step status_service, in: [status: -> { status }] }.grep_v(/success/) { |status| condition[status] }.result).to be_error.without_data

          # NOTE: Usage on terminal chaining.
          expect { service.collection(enumerable([:success, :exception, :exception])).first.grep_v(/success/) { |status| condition[status] }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection(enumerator([:success, :exception, :exception])).first.grep_v(/success/) { |status| condition[status] }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection(lazy_enumerator([:success, :exception, :exception])).first.grep_v(/success/) { |status| condition[status] }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection(chain_enumerator([:success, :exception, :exception])).first.grep_v(/success/) { |status| condition[status] }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection([:success, :exception, :exception]).first.grep_v(/success/) { |status| condition[status] }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)

          expect { service.collection(set([:success, :exception, :exception])).first.grep_v(/success/) { |status| condition[status] }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection({success: :success, exception: :exception}).first.grep_v([:success, :success]) { |key, value| condition[value] }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection((:success..:success)).first.grep_v(/success/) { |status| condition[status] }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
        end
      end

      describe "#group_by" do
        specify do
          # NOTE: Empty collection.
          expect([].group_by { |status| condition[status] }).to eq({})
          expect(service.collection(enumerable([])).group_by { |status| condition[status] }.result).to be_success.with_data(values: {})
          expect(service.collection(enumerator([])).group_by { |status| condition[status] }.result).to be_success.with_data(values: {})
          expect(service.collection(lazy_enumerator([])).group_by { |status| condition[status] }.result).to be_success.with_data(values: {})
          expect(service.collection(chain_enumerator([])).group_by { |status| condition[status] }.result).to be_success.with_data(values: {})
          expect(service.collection([]).group_by { |status| condition[status] }.result).to be_success.with_data(values: {})
          expect(service.collection(set([])).group_by { |status| condition[status] }.result).to be_success.with_data(values: {})
          expect(service.collection({}).group_by { |status| condition[status] }.result).to be_success.with_data(values: {})
          expect(service.collection((:success...:success)).group_by { |status| condition[status] }.result).to be_success.with_data(values: {})

          # NOTE: No block.
          expect([:success, :success, :success].group_by.to_a).to eq([:success, :success, :success])
          expect(service.collection(enumerable([:success, :success, :success])).group_by.result).to be_success.with_data(values: [:success, :success, :success])
          expect(service.collection(enumerator([:success, :success, :success])).group_by.result).to be_success.with_data(values: [:success, :success, :success])
          expect(service.collection(lazy_enumerator([:success, :success, :success])).group_by.result).to be_success.with_data(values: [:success, :success, :success])
          expect(service.collection(chain_enumerator([:success, :success, :success])).group_by.result).to be_success.with_data(values: [:success, :success, :success])
          expect(service.collection([:success, :success, :success]).group_by.result).to be_success.with_data(values: [:success, :success, :success])

          expect(service.collection(set([:success])).group_by.result).to be_success.with_data(values: [:success])
          expect(service.collection({success: :success}).group_by.result).to be_success.with_data(values: [[:success, :success]])
          expect(service.collection((:success..:success)).group_by.result).to be_success.with_data(values: [:success])

          # NOTE: Block.
          expect([:success, :failure, :success, :failure].group_by { |status| condition[status] }).to eq({true => [:success, :success], false => [:failure, :failure]})
          expect(service.collection(enumerable([:success, :failure, :success, :failure])).group_by { |status| condition[status] }.result).to be_success.with_data(values: {true => [:success, :success], false => [:failure, :failure]})
          expect(service.collection(enumerator([:success, :failure, :success, :failure])).group_by { |status| condition[status] }.result).to be_success.with_data(values: {true => [:success, :success], false => [:failure, :failure]})
          expect(service.collection(lazy_enumerator([:success, :failure, :success, :failure])).group_by { |status| condition[status] }.result).to be_success.with_data(values: {true => [:success, :success], false => [:failure, :failure]})
          expect(service.collection(chain_enumerator([:success, :failure, :success, :failure])).group_by { |status| condition[status] }.result).to be_success.with_data(values: {true => [:success, :success], false => [:failure, :failure]})
          expect(service.collection([:success, :failure, :success, :failure]).group_by { |status| condition[status] }.result).to be_success.with_data(values: {true => [:success, :success], false => [:failure, :failure]})

          expect(service.collection(set([:success, :failure])).group_by { |status| condition[status] }.result).to be_success.with_data(values: {true => [:success], false => [:failure]})
          expect(service.collection({success: :success, failure: :failure}).group_by { |key, value| condition[value] }.result).to be_success.with_data(values: {true => [[:success, :success]], false => [[:failure, :failure]]})
          expect(service.collection((:success..:success)).group_by { |status| condition[status] }.result).to be_success.with_data(values: {true => [:success]})
          expect(service.collection((:failure..:failure)).group_by { |status| condition[status] }.result).to be_success.with_data(values: {false => [:failure]})

          # NOTE: Step with no outputs.
          expect(service.collection(enumerable([:success, :failure, :success, :failure])).group_by { |status| step status_service, in: [status: -> { status }] }.result).to be_success.with_data(values: {true => [:success, :success], false => [:failure, :failure]})
          expect(service.collection(enumerator([:success, :failure, :success, :failure])).group_by { |status| step status_service, in: [status: -> { status }] }.result).to be_success.with_data(values: {true => [:success, :success], false => [:failure, :failure]})
          expect(service.collection(lazy_enumerator([:success, :failure, :success, :failure])).group_by { |status| step status_service, in: [status: -> { status }] }.result).to be_success.with_data(values: {true => [:success, :success], false => [:failure, :failure]})
          expect(service.collection(chain_enumerator([:success, :failure, :success, :failure])).group_by { |status| step status_service, in: [status: -> { status }] }.result).to be_success.with_data(values: {true => [:success, :success], false => [:failure, :failure]})
          expect(service.collection([:success, :failure, :success, :failure]).group_by { |status| step status_service, in: [status: -> { status }] }.result).to be_success.with_data(values: {true => [:success, :success], false => [:failure, :failure]})

          expect(service.collection(set([:success, :failure])).group_by { |status| step status_service, in: [status: -> { status }] }.result).to be_success.with_data(values: {true => [:success], false => [:failure]})
          expect(service.collection({success: :success, failure: :failure}).group_by { |key, value| step status_service, in: [status: -> { value }] }.result).to be_success.with_data(values: {true => [[:success, :success]], false => [[:failure, :failure]]})
          expect(service.collection((:success..:success)).group_by { |status| step status_service, in: [status: -> { status }] }.result).to be_success.with_data(values: {true => [:success]})
          expect(service.collection((:failure..:failure)).group_by { |status| step status_service, in: [status: -> { status }] }.result).to be_success.with_data(values: {false => [:failure]})

          # NOTE: Step with one output.
          expect(service.collection(enumerable([:success, :failure, :success, :failure])).group_by { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(values: {"ok" => [:success, :success], nil => [:failure, :failure]})
          expect(service.collection(enumerator([:success, :failure, :success, :failure])).group_by { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(values: {"ok" => [:success, :success], nil => [:failure, :failure]})
          expect(service.collection(lazy_enumerator([:success, :failure, :success, :failure])).group_by { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(values: {"ok" => [:success, :success], nil => [:failure, :failure]})
          expect(service.collection(chain_enumerator([:success, :failure, :success, :failure])).group_by { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(values: {"ok" => [:success, :success], nil => [:failure, :failure]})
          expect(service.collection([:success, :failure, :success, :failure]).group_by { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(values: {"ok" => [:success, :success], nil => [:failure, :failure]})

          expect(service.collection(set([:success, :failure])).group_by { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(values: {"ok" => [:success], nil => [:failure]})
          expect(service.collection({success: :success, failure: :failure}).group_by { |key, value| step status_service, in: [status: -> { value }], out: :status_string }.result).to be_success.with_data(values: {"ok" => [[:success, :success]], nil => [[:failure, :failure]]})
          expect(service.collection((:success..:success)).group_by { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(values: {"ok" => [:success]})
          expect(service.collection((:failure..:failure)).group_by { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(values: {nil => [:failure]})

          # NOTE: Step with multiple outputs.
          expect(service.collection(enumerable([:success, :failure, :success, :failure])).group_by { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: {{status_string: "ok", status_code: 200} => [:success, :success], nil => [:failure, :failure]})
          expect(service.collection(enumerator([:success, :failure, :success, :failure])).group_by { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: {{status_string: "ok", status_code: 200} => [:success, :success], nil => [:failure, :failure]})
          expect(service.collection(lazy_enumerator([:success, :failure, :success, :failure])).group_by { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: {{status_string: "ok", status_code: 200} => [:success, :success], nil => [:failure, :failure]})
          expect(service.collection(chain_enumerator([:success, :failure, :success, :failure])).group_by { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: {{status_string: "ok", status_code: 200} => [:success, :success], nil => [:failure, :failure]})
          expect(service.collection([:success, :failure, :success, :failure]).group_by { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: {{status_string: "ok", status_code: 200} => [:success, :success], nil => [:failure, :failure]})

          expect(service.collection(set([:success, :failure])).group_by { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: {{status_string: "ok", status_code: 200} => [:success], nil => [:failure]})
          expect(service.collection({success: :success, failure: :failure}).group_by { |key, value| step status_service, in: [status: -> { value }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: {{status_string: "ok", status_code: 200} => [[:success, :success]], nil => [[:failure, :failure]]})
          expect(service.collection((:success..:success)).group_by { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: {{status_string: "ok", status_code: 200} => [:success]})
          expect(service.collection((:failure..:failure)).group_by { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: {nil => [:failure]})

          # NOTE: Error result.
          expect(service.collection(enumerable([:success, :error, :exception])).group_by { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection(enumerator([:success, :error, :exception])).group_by { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection(lazy_enumerator([:success, :error, :exception])).group_by { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection(chain_enumerator([:success, :error, :exception])).group_by { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection([:success, :error, :exception]).group_by { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data

          expect(service.collection(set([:success, :error, :exception])).group_by { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection({success: :success, error: :error, exception: :exception}).group_by { |key, value| step status_service, in: [status: -> { value }] }.result).to be_error.without_data
          expect(service.collection((:error..:error)).group_by { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data

          # NOTE: Error propagation.
          expect(service.collection(enumerable([:success, :error, :exception])).select { |status| step status_service, in: [status: -> { status }] }.group_by { |status| condition[status] }.result).to be_error.without_data
          expect(service.collection(enumerator([:success, :error, :exception])).select { |status| step status_service, in: [status: -> { status }] }.group_by { |status| condition[status] }.result).to be_error.without_data
          expect(service.collection(lazy_enumerator([:success, :error, :exception])).select { |status| step status_service, in: [status: -> { status }] }.group_by { |status| condition[status] }.result).to be_error.without_data
          expect(service.collection(chain_enumerator([:success, :error, :exception])).select { |status| step status_service, in: [status: -> { status }] }.group_by { |status| condition[status] }.result).to be_error.without_data
          expect(service.collection([:success, :error, :exception]).select { |status| step status_service, in: [status: -> { status }] }.group_by { |status| condition[status] }.result).to be_error.without_data

          expect(service.collection(set([:success, :error, :exception])).select { |status| step status_service, in: [status: -> { status }] }.group_by { |status| condition[status] }.result).to be_error.without_data
          expect(service.collection({success: :success, error: :error, exception: :exception}).select { |key, value| step status_service, in: [status: -> { value }] }.group_by { |key, value| condition[value] }.result).to be_error.without_data
          expect(service.collection((:error..:error)).select { |status| step status_service, in: [status: -> { status }] }.group_by { |status| condition[status] }.result).to be_error.without_data

          # NOTE: Usage on terminal chaining.
          expect { service.collection(enumerable([:success, :exception, :exception])).first.group_by { |status| condition[status] }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection(enumerator([:success, :exception, :exception])).first.group_by { |status| condition[status] }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection(lazy_enumerator([:success, :exception, :exception])).first.group_by { |status| condition[status] }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection(chain_enumerator([:success, :exception, :exception])).first.group_by { |status| condition[status] }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection([:success, :exception, :exception]).first.group_by { |status| condition[status] }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)

          expect { service.collection(set([:success, :exception, :exception])).first.group_by { |status| condition[status] }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection({success: :success, exception: :exception}).first.group_by { |key, value| condition[value] }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection((:success..:success)).first.group_by { |status| condition[status] }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
        end
      end

      describe "#include?" do
        specify do
          # NOTE: Empty collection.
          expect([].include?(:success)).to eq(false)
          expect(service.collection(enumerable([])).include?(:success).result).to be_failure.without_data
          expect(service.collection(enumerator([])).include?(:success).result).to be_failure.without_data
          expect(service.collection(lazy_enumerator([])).include?(:success).result).to be_failure.without_data
          expect(service.collection(chain_enumerator([])).include?(:success).result).to be_failure.without_data
          expect(service.collection([]).include?(:success).result).to be_failure.without_data
          expect(service.collection({}).include?(:success).result).to be_failure.without_data
          expect(service.collection((:success...:success)).include?(:success).result).to be_failure.without_data
          expect(service.collection(set([])).include?(:success).result).to be_failure.without_data

          # NOTE: Matched pattern.
          expect([:failure, :success, :exception].include?(:success)).to eq(true)
          expect(service.collection(enumerable([:failure, :success, :exception])).include?(:success).result).to be_success.without_data
          expect(service.collection(enumerator([:failure, :success, :exception])).include?(:success).result).to be_success.without_data
          expect(service.collection(lazy_enumerator([:failure, :success, :exception])).include?(:success).result).to be_success.without_data
          expect(service.collection(chain_enumerator([:failure, :success, :exception])).include?(:success).result).to be_success.without_data
          expect(service.collection([:failure, :success, :exception]).include?(:success).result).to be_success.without_data
          expect(service.collection(set([:failure, :success, :exception])).include?(:success).result).to be_success.without_data

          expect(service.collection({success: :success}).include?(:success).result).to be_success.without_data
          expect(service.collection((:success..:success)).include?(:success).result).to be_success.without_data

          # NOTE: Not matched pattern.
          expect([:failure, :failure, :failure].include?(/success/)).to eq(false)
          expect(service.collection(enumerable([:failure, :failure, :failure])).include?(:success).result).to be_failure.without_data
          expect(service.collection(enumerator([:failure, :failure, :failure])).include?(:success).result).to be_failure.without_data
          expect(service.collection(lazy_enumerator([:failure, :failure, :failure])).include?(:success).result).to be_failure.without_data
          expect(service.collection(chain_enumerator([:failure, :failure, :failure])).include?(:success).result).to be_failure.without_data
          expect(service.collection([:failure, :failure, :failure]).include?(:success).result).to be_failure.without_data
          expect(service.collection(set([:failure, :failure, :failure])).include?(:success).result).to be_failure.without_data

          expect(service.collection({failure: :failure}).include?(:success).result).to be_failure.without_data
          expect(service.collection((:failure..:failure)).include?(:success).result).to be_failure.without_data

          # NOTE: Error propagation.
          expect(service.collection(enumerable([:failure, :error, :exception])).select { |status| step status_service, in: [status: -> { status }] }.include?(:success).result).to be_error.without_data
          expect(service.collection(enumerator([:failure, :error, :exception])).select { |status| step status_service, in: [status: -> { status }] }.include?(:success).result).to be_error.without_data
          expect(service.collection(lazy_enumerator([:failure, :error, :exception])).select { |status| step status_service, in: [status: -> { status }] }.include?(:success).result).to be_error.without_data
          expect(service.collection(chain_enumerator([:failure, :error, :exception])).select { |status| step status_service, in: [status: -> { status }] }.include?(:success).result).to be_error.without_data
          expect(service.collection([:failure, :error, :exception]).select { |status| step status_service, in: [status: -> { status }] }.include?(:success).result).to be_error.without_data
          expect(service.collection(set([:failure, :error, :exception])).select { |status| step status_service, in: [status: -> { status }] }.include?(:success).result).to be_error.without_data

          expect(service.collection({failure: :failure, error: :error, exception: :exception}).select { |key, value| step status_service, in: [status: -> { value }] }.include?(:success).result).to be_error.without_data
          expect(service.collection((:error..:error)).select { |status| step status_service, in: [status: -> { status }] }.include?(:success).result).to be_error.without_data

          # NOTE: Usage on terminal chaining.
          expect { service.collection(enumerable([:success, :exception, :exception])).first.include?(:success).result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection(enumerator([:success, :exception, :exception])).first.include?(:success).result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection(lazy_enumerator([:success, :exception, :exception])).first.include?(:success).result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection(chain_enumerator([:success, :exception, :exception])).first.include?(:success).result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection([:success, :exception, :exception]).first.include?(:success).result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection(set([:success, :exception, :exception])).first.include?(:success).result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)

          expect { service.collection({success: :success, exception: :exception}).first.include?(:success).result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection((:success..:success)).first.include?(:success).result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
        end
      end

      describe "#inject" do
        specify do
          # NOTE: Empty collection.
          expect([].inject(0) { |memo, number| memo + number }).to eq(0)
          expect(service.collection(enumerable([])).inject(0) { |memo, number| memo + number }.result).to be_success.with_data(value: 0)
          expect(service.collection(enumerator([])).inject(0) { |memo, number| memo + number }.result).to be_success.with_data(value: 0)
          expect(service.collection(lazy_enumerator([])).inject(0) { |memo, number| memo + number }.result).to be_success.with_data(value: 0)
          expect(service.collection(chain_enumerator([])).inject(0) { |memo, number| memo + number }.result).to be_success.with_data(value: 0)
          expect(service.collection([]).inject(0) { |memo, number| memo + number }.result).to be_success.with_data(value: 0)
          expect(service.collection(set([])).inject(0) { |memo, number| memo + number }.result).to be_success.with_data(value: 0)
          expect(service.collection({}).inject(0) { |memo, number| memo + number }.result).to be_success.with_data(value: 0)
          expect(service.collection((:success...:success)).inject(0) { |memo, number| memo + number }.result).to be_success.with_data(value: 0)

          # NOTE: No initial, no sym, no block.
          expect { [0, 1, 2, 3, 4, 5].inject }.to raise_error(ArgumentError).with_message("wrong number of arguments (given 0, expected 1..2)")
          expect { service.collection(enumerable([0, 1, 2, 3, 4, 5])).inject.result }.to raise_error(ArgumentError).with_message("wrong number of arguments (given 0, expected 1..2)")
          expect { service.collection(enumerator([0, 1, 2, 3, 4, 5])).inject.result }.to raise_error(ArgumentError).with_message("wrong number of arguments (given 0, expected 1..2)")
          expect { service.collection(lazy_enumerator([0, 1, 2, 3, 4, 5])).inject.result }.to raise_error(ArgumentError).with_message("wrong number of arguments (given 0, expected 1..2)")
          expect { service.collection(chain_enumerator([0, 1, 2, 3, 4, 5])).inject.result }.to raise_error(ArgumentError).with_message("wrong number of arguments (given 0, expected 1..2)")
          expect { service.collection([0, 1, 2, 3, 4, 5]).inject.result }.to raise_error(ArgumentError).with_message("wrong number of arguments (given 0, expected 1..2)")

          expect { service.collection(set([0, 1, 2, 3, 4, 5])).inject.result }.to raise_error(ArgumentError).with_message("wrong number of arguments (given 0, expected 1..2)")
          expect { service.collection({0 => 0, 1 => 1, 2 => 2, 3 => 3, 4 => 4, 5 => 5}).inject.result }.to raise_error(ArgumentError).with_message("wrong number of arguments (given 0, expected 1..2)")
          expect { service.collection((0..5)).inject.result }.to raise_error(ArgumentError).with_message("wrong number of arguments (given 0, expected 1..2)")

          # NOTE: Sym.
          expect([0, 1, 2, 3, 4, 5].inject(:+)).to eq(15)
          expect(service.collection(enumerable([0, 1, 2, 3, 4, 5])).inject(:+).result).to be_success.with_data(value: 15)
          expect(service.collection(enumerator([0, 1, 2, 3, 4, 5])).inject(:+).result).to be_success.with_data(value: 15)
          expect(service.collection(lazy_enumerator([0, 1, 2, 3, 4, 5])).inject(:+).result).to be_success.with_data(value: 15)
          expect(service.collection(chain_enumerator([0, 1, 2, 3, 4, 5])).inject(:+).result).to be_success.with_data(value: 15)
          expect(service.collection([0, 1, 2, 3, 4, 5]).inject(:+).result).to be_success.with_data(value: 15)

          expect(service.collection(set([0, 1, 2, 3, 4, 5])).inject(:+).result).to be_success.with_data(value: 15)
          expect({0 => 0, 1 => 1, 2 => 2, 3 => 3, 4 => 4, 5 => 5}.inject(:+)).to eq([0, 0, 1, 1, 2, 2, 3, 3, 4, 4, 5, 5])
          expect(service.collection({0 => 0, 1 => 1, 2 => 2, 3 => 3, 4 => 4, 5 => 5}).inject(:+).result).to be_success.with_data(value: [0, 0, 1, 1, 2, 2, 3, 3, 4, 4, 5, 5])
          expect(service.collection((0..5)).inject(:+).result).to be_success.with_data(value: 15)

          # NOTE: Initial, sym.
          expect([0, 1, 2, 3, 4, 5].inject(10, :+)).to eq(25)
          expect(service.collection(enumerable([0, 1, 2, 3, 4, 5])).inject(10, :+).result).to be_success.with_data(value: 25)
          expect(service.collection(enumerator([0, 1, 2, 3, 4, 5])).inject(10, :+).result).to be_success.with_data(value: 25)
          expect(service.collection(lazy_enumerator([0, 1, 2, 3, 4, 5])).inject(10, :+).result).to be_success.with_data(value: 25)
          expect(service.collection(chain_enumerator([0, 1, 2, 3, 4, 5])).inject(10, :+).result).to be_success.with_data(value: 25)
          expect(service.collection([0, 1, 2, 3, 4, 5]).inject(10, :+).result).to be_success.with_data(value: 25)

          expect(service.collection(set([0, 1, 2, 3, 4, 5])).inject(10, :+).result).to be_success.with_data(value: 25)
          expect({0 => 0, 1 => 1, 2 => 2, 3 => 3, 4 => 4, 5 => 5}.inject([10, 10], :+)).to eq([10, 10, 0, 0, 1, 1, 2, 2, 3, 3, 4, 4, 5, 5])
          expect(service.collection({0 => 0, 1 => 1, 2 => 2, 3 => 3, 4 => 4, 5 => 5}).inject([10, 10], :+).result).to be_success.with_data(value: [10, 10, 0, 0, 1, 1, 2, 2, 3, 3, 4, 4, 5, 5])
          expect(service.collection((0..5)).inject(10, :+).result).to be_success.with_data(value: 25)

          # NOTE: Block.
          expect([0, 1, 2, 3, 4, 5].inject { |memo, number| memo + number }).to eq(15)
          expect(service.collection(enumerable([0, 1, 2, 3, 4, 5])).inject { |memo, number| memo + number }.result).to be_success.with_data(value: 15)
          expect(service.collection(enumerator([0, 1, 2, 3, 4, 5])).inject { |memo, number| memo + number }.result).to be_success.with_data(value: 15)
          expect(service.collection(lazy_enumerator([0, 1, 2, 3, 4, 5])).inject { |memo, number| memo + number }.result).to be_success.with_data(value: 15)
          expect(service.collection(chain_enumerator([0, 1, 2, 3, 4, 5])).inject { |memo, number| memo + number }.result).to be_success.with_data(value: 15)
          expect(service.collection([0, 1, 2, 3, 4, 5]).inject { |memo, number| memo + number }.result).to be_success.with_data(value: 15)

          expect(service.collection(set([0, 1, 2, 3, 4, 5])).inject { |memo, number| memo + number }.result).to be_success.with_data(value: 15)
          expect({0 => 0, 1 => 1, 2 => 2, 3 => 3, 4 => 4, 5 => 5}.inject { |memo, number| memo + number }).to eq([0, 0, 1, 1, 2, 2, 3, 3, 4, 4, 5, 5])
          expect(service.collection({0 => 0, 1 => 1, 2 => 2, 3 => 3, 4 => 4, 5 => 5}).inject { |memo, number| memo + number }.result).to be_success.with_data(value: [0, 0, 1, 1, 2, 2, 3, 3, 4, 4, 5, 5])
          expect(service.collection((0..5)).inject { |memo, number| memo + number }.result).to be_success.with_data(value: 15)

          # NOTE: Initial, block.
          expect([0, 1, 2, 3, 4, 5].inject(10) { |memo, number| memo + number }).to eq(25)
          expect(service.collection(enumerable([0, 1, 2, 3, 4, 5])).inject(10) { |memo, number| memo + number }.result).to be_success.with_data(value: 25)
          expect(service.collection(enumerator([0, 1, 2, 3, 4, 5])).inject(10) { |memo, number| memo + number }.result).to be_success.with_data(value: 25)
          expect(service.collection(lazy_enumerator([0, 1, 2, 3, 4, 5])).inject(10) { |memo, number| memo + number }.result).to be_success.with_data(value: 25)
          expect(service.collection(chain_enumerator([0, 1, 2, 3, 4, 5])).inject(10) { |memo, number| memo + number }.result).to be_success.with_data(value: 25)
          expect(service.collection([0, 1, 2, 3, 4, 5]).inject(10) { |memo, number| memo + number }.result).to be_success.with_data(value: 25)

          expect(service.collection(set([0, 1, 2, 3, 4, 5])).inject(10) { |memo, number| memo + number }.result).to be_success.with_data(value: 25)
          expect({0 => 0, 1 => 1, 2 => 2, 3 => 3, 4 => 4, 5 => 5}.inject([10, 10]) { |memo, number| memo + number }).to eq([10, 10, 0, 0, 1, 1, 2, 2, 3, 3, 4, 4, 5, 5])
          expect(service.collection({0 => 0, 1 => 1, 2 => 2, 3 => 3, 4 => 4, 5 => 5}).inject([10, 10]) { |memo, number| memo + number }.result).to be_success.with_data(value: [10, 10, 0, 0, 1, 1, 2, 2, 3, 3, 4, 4, 5, 5])
          expect(service.collection((0..5)).inject(10) { |memo, number| memo + number }.result).to be_success.with_data(value: 25)

          # NOTE: Step with no outputs.
          expect { service.collection(enumerable([0, 1, 2, 3, 4, 5])).inject { |memo, number| step add_numbers_service, in: [number: -> { memo }, other_number: -> { number }] }.result }.to raise_error(NoMethodError).with_message("undefined method '+' for true")
          expect { service.collection(enumerator([0, 1, 2, 3, 4, 5])).inject { |memo, number| step add_numbers_service, in: [number: -> { memo }, other_number: -> { number }] }.result }.to raise_error(NoMethodError).with_message("undefined method '+' for true")
          expect { service.collection(lazy_enumerator([0, 1, 2, 3, 4, 5])).inject { |memo, number| step add_numbers_service, in: [number: -> { memo }, other_number: -> { number }] }.result }.to raise_error(NoMethodError).with_message("undefined method '+' for true")
          expect { service.collection(chain_enumerator([0, 1, 2, 3, 4, 5])).inject { |memo, number| step add_numbers_service, in: [number: -> { memo }, other_number: -> { number }] }.result }.to raise_error(NoMethodError).with_message("undefined method '+' for true")
          expect { service.collection([0, 1, 2, 3, 4, 5]).inject { |memo, number| step add_numbers_service, in: [number: -> { memo }, other_number: -> { number }] }.result }.to raise_error(NoMethodError).with_message("undefined method '+' for true")

          expect { service.collection(set([0, 1, 2, 3, 4, 5])).inject { |memo, number| step add_numbers_service, in: [number: -> { memo }, other_number: -> { number }] }.result }.to raise_error(NoMethodError).with_message("undefined method '+' for true")
          expect { service.collection({0 => 0, 1 => 1, 2 => 2, 3 => 3, 4 => 4, 5 => 5}).inject(0) { |memo, (key, value)| step add_numbers_service, in: [number: -> { memo }, other_number: -> { value }] }.result }.to raise_error(NoMethodError).with_message("undefined method '+' for true")
          expect { service.collection((0..5)).inject { |memo, number| step add_numbers_service, in: [number: -> { memo }, other_number: -> { number }] }.result }.to raise_error(NoMethodError).with_message("undefined method '+' for true")

          # NOTE: Step with one output.
          expect(service.collection(enumerable([0, 1, 2])).inject { |memo, number| step add_numbers_service, in: [number: -> { memo }, other_number: -> { number }], out: :sum }.result).to be_success.with_data(value: 3)
          expect(service.collection(enumerator([0, 1, 2])).inject { |memo, number| step add_numbers_service, in: [number: -> { memo }, other_number: -> { number }], out: :sum }.result).to be_success.with_data(value: 3)
          expect(service.collection(lazy_enumerator([0, 1, 2])).inject { |memo, number| step add_numbers_service, in: [number: -> { memo }, other_number: -> { number }], out: :sum }.result).to be_success.with_data(value: 3)
          expect(service.collection(chain_enumerator([0, 1, 2])).inject { |memo, number| step add_numbers_service, in: [number: -> { memo }, other_number: -> { number }], out: :sum }.result).to be_success.with_data(value: 3)
          expect(service.collection([0, 1, 2]).inject { |memo, number| step add_numbers_service, in: [number: -> { memo }, other_number: -> { number }], out: :sum }.result).to be_success.with_data(value: 3)

          expect(service.collection(set([0, 1, 2])).inject { |memo, number| step add_numbers_service, in: [number: -> { memo }, other_number: -> { number }], out: :sum }.result).to be_success.with_data(value: 3)
          expect(service.collection({0 => 0, 1 => 1, 2 => 2}).inject(0) { |memo, (key, value)| step add_numbers_service, in: [number: -> { memo }, other_number: -> { value }], out: :sum }.result).to be_success.with_data(value: 3)
          expect(service.collection((0..2)).inject { |memo, number| step add_numbers_service, in: [number: -> { memo }, other_number: -> { number }], out: :sum }.result).to be_success.with_data(value: 3)

          # NOTE: Step with multiple outputs.
          expect(service.collection(enumerable([0, 1, 2, 3, 4, 5])).inject({sum: 0}) { |memo, number| step add_numbers_service, in: [number: -> { memo[:sum] }, other_number: -> { number }], out: [:sum, :operator] }.result).to be_success.with_data(value: {sum: 15, operator: "+"})
          expect(service.collection(enumerator([0, 1, 2, 3, 4, 5])).inject({sum: 0}) { |memo, number| step add_numbers_service, in: [number: -> { memo[:sum] }, other_number: -> { number }], out: [:sum, :operator] }.result).to be_success.with_data(value: {sum: 15, operator: "+"})
          expect(service.collection(lazy_enumerator([0, 1, 2, 3, 4, 5])).inject({sum: 0}) { |memo, number| step add_numbers_service, in: [number: -> { memo[:sum] }, other_number: -> { number }], out: [:sum, :operator] }.result).to be_success.with_data(value: {sum: 15, operator: "+"})
          expect(service.collection(chain_enumerator([0, 1, 2, 3, 4, 5])).inject({sum: 0}) { |memo, number| step add_numbers_service, in: [number: -> { memo[:sum] }, other_number: -> { number }], out: [:sum, :operator] }.result).to be_success.with_data(value: {sum: 15, operator: "+"})
          expect(service.collection([0, 1, 2, 3, 4, 5]).inject({sum: 0}) { |memo, number| step add_numbers_service, in: [number: -> { memo[:sum] }, other_number: -> { number }], out: [:sum, :operator] }.result).to be_success.with_data(value: {sum: 15, operator: "+"})

          expect(service.collection(set([0, 1, 2, 3, 4, 5])).inject({sum: 0}) { |memo, number| step add_numbers_service, in: [number: -> { memo[:sum] }, other_number: -> { number }], out: [:sum, :operator] }.result).to be_success.with_data(value: {sum: 15, operator: "+"})
          expect(service.collection({0 => 0, 1 => 1, 2 => 2, 3 => 3, 4 => 4, 5 => 5}).inject({sum: 0}) { |memo, (key, value)| step add_numbers_service, in: [number: -> { memo[:sum] }, other_number: -> { value }], out: [:sum, :operator] }.result).to be_success.with_data(value: {sum: 15, operator: "+"})
          expect(service.collection((0..5)).inject({sum: 0}) { |memo, number| step add_numbers_service, in: [number: -> { memo[:sum] }, other_number: -> { number }], out: [:sum, :operator] }.result).to be_success.with_data(value: {sum: 15, operator: "+"})

          # NOTE: Error result.
          expect(service.collection(enumerable([0, -1, :exception])).inject { |memo, number| step add_numbers_service, in: [number: -> { memo }, other_number: -> { number }], out: :sum }.result).to be_error.without_data
          expect(service.collection(enumerator([0, -1, :exception])).inject { |memo, number| step add_numbers_service, in: [number: -> { memo }, other_number: -> { number }], out: :sum }.result).to be_error.without_data
          expect(service.collection(lazy_enumerator([0, -1, :exception])).inject { |memo, number| step add_numbers_service, in: [number: -> { memo }, other_number: -> { number }], out: :sum }.result).to be_error.without_data
          expect(service.collection(chain_enumerator([0, -1, :exception])).inject { |memo, number| step add_numbers_service, in: [number: -> { memo }, other_number: -> { number }], out: :sum }.result).to be_error.without_data
          expect(service.collection([0, -1, :exception]).inject { |memo, number| step add_numbers_service, in: [number: -> { memo }, other_number: -> { number }], out: :sum }.result).to be_error.without_data
          expect(service.collection(set([0, -1, :exception])).inject { |memo, number| step add_numbers_service, in: [number: -> { memo }, other_number: -> { number }], out: :sum }.result).to be_error.without_data

          expect(service.collection({0 => 0, -1 => -1, :exception => :exception}).inject(0) { |memo, (key, value)| step add_numbers_service, in: [number: -> { memo }, other_number: -> { value }], out: :sum }.result).to be_error.without_data
          expect((-1..-1).inject { |memo, number| raise }).to eq(-1)
          expect(service.collection((-1..-1)).inject { |memo, number| step add_numbers_service, in: [number: -> { memo }, other_number: -> { number }], out: :sum }.result).to be_success.with_data(value: -1)

          # NOTE: Error propagation.
          expect(service.collection(enumerable([:success, :error, :exception])).filter { |status| step status_service, in: [status: -> { status }] }.inject { |memo, number| memo + number }.result).to be_error.without_data
          expect(service.collection(enumerator([:success, :error, :exception])).filter { |status| step status_service, in: [status: -> { status }] }.inject { |memo, number| memo + number }.result).to be_error.without_data
          expect(service.collection(lazy_enumerator([:success, :error, :exception])).filter { |status| step status_service, in: [status: -> { status }] }.inject { |memo, number| memo + number }.result).to be_error.without_data
          expect(service.collection(chain_enumerator([:success, :error, :exception])).filter { |status| step status_service, in: [status: -> { status }] }.inject { |memo, number| memo + number }.result).to be_error.without_data
          expect(service.collection([:success, :error, :exception]).filter { |status| step status_service, in: [status: -> { status }] }.inject { |memo, number| memo + number }.result).to be_error.without_data

          expect(service.collection(set([:success, :error, :exception])).filter { |status| step status_service, in: [status: -> { status }] }.inject { |memo, number| memo + number }.result).to be_error.without_data
          expect(service.collection({success: :success, error: :error, exception: :exception}).filter { |key, value| step status_service, in: [status: -> { value }] }.inject(0) { |memo, (key, value)| memo + value }.result).to be_error.without_data
          expect(service.collection((:error..:error)).filter { |status| step status_service, in: [status: -> { status }] }.inject { |memo, number| memo + number }.result).to be_error.without_data

          # NOTE: Usage on terminal chaining.
          expect { service.collection(enumerable([:success, :exception, :exception])).first.inject { |memo, number| memo + number }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection(enumerator([:success, :exception, :exception])).first.inject { |memo, number| memo + number }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection(lazy_enumerator([:success, :exception, :exception])).first.inject { |memo, number| memo + number }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection(chain_enumerator([:success, :exception, :exception])).first.inject { |memo, number| memo + number }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection([:success, :exception, :exception]).first.inject { |memo, number| memo + number }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection(set([:success, :exception, :exception])).first.inject { |memo, number| memo + number }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)

          expect { service.collection({success: :success, exception: :exception}).first.inject { |memo, (key, value)| memo + value }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection((:success..:success)).first.inject { |memo, number| memo + number }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
        end
      end

      describe "#lazy" do
        specify do
          # NOTE: Empty collection.
          expect([].lazy.to_a).to eq([])
          expect(service.collection(enumerable([])).lazy.result).to be_success.with_data(values: [])
          expect(service.collection(enumerator([])).lazy.result).to be_success.with_data(values: [])
          expect(service.collection(lazy_enumerator([])).lazy.result).to be_success.with_data(values: [])
          expect(service.collection(chain_enumerator([])).lazy.result).to be_success.with_data(values: [])
          expect(service.collection([]).lazy.result).to be_success.with_data(values: [])
          expect(service.collection({}).lazy.result).to be_success.with_data(values: [])
          expect(service.collection((:success...:success)).lazy.result).to be_success.with_data(values: [])
          expect(service.collection(set([])).lazy.result).to be_success.with_data(values: [])

          # NOTE: Not empty collection.
          expect([:success, :success, :success].lazy.to_a).to eq([:success, :success, :success])
          expect(service.collection(enumerable([:success, :success, :success])).lazy.result).to be_success.with_data(values: [:success, :success, :success])
          expect(service.collection(enumerator([:success, :success, :success])).lazy.result).to be_success.with_data(values: [:success, :success, :success])
          expect(service.collection(lazy_enumerator([:success, :success, :success])).lazy.result).to be_success.with_data(values: [:success, :success, :success])
          expect(service.collection(chain_enumerator([:success, :success, :success])).lazy.result).to be_success.with_data(values: [:success, :success, :success])
          expect(service.collection([:success, :success, :success]).lazy.result).to be_success.with_data(values: [:success, :success, :success])
          expect(service.collection(set([:success])).lazy.result).to be_success.with_data(values: [:success])
          expect(service.collection({success: :success}).lazy.result).to be_success.with_data(values: [[:success, :success]])
          expect(service.collection((:success..:success)).lazy.result).to be_success.with_data(values: [:success])

          # NOTE: Error propagation.
          expect(service.collection(enumerable([:success, :error, :exception])).select { |status| step status_service, in: [status: -> { status }] }.lazy.result).to be_error.without_data
          expect(service.collection(enumerator([:success, :error, :exception])).select { |status| step status_service, in: [status: -> { status }] }.lazy.result).to be_error.without_data
          expect(service.collection(lazy_enumerator([:success, :error, :exception])).select { |status| step status_service, in: [status: -> { status }] }.lazy.result).to be_error.without_data
          expect(service.collection(chain_enumerator([:success, :error, :exception])).select { |status| step status_service, in: [status: -> { status }] }.lazy.result).to be_error.without_data
          expect(service.collection([:success, :error, :exception]).select { |status| step status_service, in: [status: -> { status }] }.lazy.result).to be_error.without_data
          expect(service.collection(set([:success, :error, :exception])).select { |status| step status_service, in: [status: -> { status }] }.lazy.result).to be_error.without_data

          expect(service.collection({success: :success, error: :error, exception: :exception}).select { |key, value| step status_service, in: [status: -> { value }] }.lazy.result).to be_error.without_data
          expect(service.collection((:error..:error)).select { |status| step status_service, in: [status: -> { status }] }.lazy.result).to be_error.without_data

          # NOTE: Usage on terminal chaining.
          expect { service.collection(enumerable([:success, :exception, :exception])).first.lazy.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection(enumerator([:success, :exception, :exception])).first.lazy.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection(lazy_enumerator([:success, :exception, :exception])).first.lazy.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection(chain_enumerator([:success, :exception, :exception])).first.lazy.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection([:success, :exception, :exception]).first.lazy.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection(set([:success, :exception, :exception])).first.lazy.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)

          expect { service.collection({success: :success, exception: :exception}).first.lazy.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection((:success..:success)).first.lazy.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
        end
      end

      describe "#map" do
        specify do
          # NOTE: Empty collection.
          expect([].map { |status| condition[status] }).to eq([])
          expect(service.collection(enumerable([])).map { |status| condition[status] }.result).to be_success.with_data(values: [])
          expect(service.collection(enumerator([])).map { |status| condition[status] }.result).to be_success.with_data(values: [])
          expect(service.collection(lazy_enumerator([])).map { |status| condition[status] }.result).to be_success.with_data(values: [])
          expect(service.collection(chain_enumerator([])).map { |status| condition[status] }.result).to be_success.with_data(values: [])
          expect(service.collection([]).map { |status| condition[status] }.result).to be_success.with_data(values: [])
          expect(service.collection(set([])).map { |status| condition[status] }.result).to be_success.with_data(values: [])
          expect(service.collection({}).map { |status| condition[status] }.result).to be_success.with_data(values: [])
          expect(service.collection((:success...:success)).map { |status| condition[status] }.result).to be_success.with_data(values: [])

          # NOTE: No block.
          expect([:success, :success, :success].map.to_a).to eq([:success, :success, :success])
          expect(service.collection(enumerable([:success, :success, :success])).map.result).to be_success.with_data(values: [:success, :success, :success])
          expect(service.collection(enumerator([:success, :success, :success])).map.result).to be_success.with_data(values: [:success, :success, :success])
          expect { service.collection(lazy_enumerator([:success, :success, :success])).map.result }.to raise_error(ArgumentError).with_message("tried to call lazy map without a block")
          expect(service.collection(chain_enumerator([:success, :success, :success])).map.result).to be_success.with_data(values: [:success, :success, :success])
          expect(service.collection([:success, :success, :success]).map.result).to be_success.with_data(values: [:success, :success, :success])

          expect(service.collection(set([:success])).map.result).to be_success.with_data(values: [:success])
          expect(service.collection({success: :success}).map.result).to be_success.with_data(values: [[:success, :success]])
          expect(service.collection((:success..:success)).map.result).to be_success.with_data(values: [:success])

          # NOTE: Block.
          expect([:success, :success, :success].map { |status| condition[status] }).to eq([true, true, true])
          expect(service.collection(enumerable([:success, :success, :success])).map { |status| condition[status] }.result).to be_success.with_data(values: [true, true, true])
          expect(service.collection(enumerator([:success, :success, :success])).map { |status| condition[status] }.result).to be_success.with_data(values: [true, true, true])
          expect(service.collection(lazy_enumerator([:success, :success, :success])).map { |status| condition[status] }.result).to be_success.with_data(values: [true, true, true])
          expect(service.collection(chain_enumerator([:success, :success, :success])).map { |status| condition[status] }.result).to be_success.with_data(values: [true, true, true])
          expect(service.collection([:success, :success, :success]).map { |status| condition[status] }.result).to be_success.with_data(values: [true, true, true])

          expect(service.collection(set([:success])).map { |status| condition[status] }.result).to be_success.with_data(values: [true])
          expect(service.collection({success: :success}).map { |key, value| condition[value] }.result).to be_success.with_data(values: [true])
          expect(service.collection((:success..:success)).map { |status| condition[status] }.result).to be_success.with_data(values: [true])

          # NOTE: Step with no outputs.
          expect(service.collection(enumerable([:success, :success, :success])).map { |status| step status_service, in: [status: -> { status }] }.result).to be_success.with_data(values: [true, true, true])
          expect(service.collection(enumerator([:success, :success, :success])).map { |status| step status_service, in: [status: -> { status }] }.result).to be_success.with_data(values: [true, true, true])
          expect(service.collection(lazy_enumerator([:success, :success, :success])).map { |status| step status_service, in: [status: -> { status }] }.result).to be_success.with_data(values: [true, true, true])
          expect(service.collection(chain_enumerator([:success, :success, :success])).map { |status| step status_service, in: [status: -> { status }] }.result).to be_success.with_data(values: [true, true, true])
          expect(service.collection([:success, :success, :success]).map { |status| step status_service, in: [status: -> { status }] }.result).to be_success.with_data(values: [true, true, true])

          expect(service.collection(set([:success])).map { |status| step status_service, in: [status: -> { status }] }.result).to be_success.with_data(values: [true])
          expect(service.collection({success: :success}).map { |key, value| step status_service, in: [status: -> { value }] }.result).to be_success.with_data(values: [true])
          expect(service.collection((:success..:success)).map { |status| step status_service, in: [status: -> { status }] }.result).to be_success.with_data(values: [true])

          # NOTE: Step with one output.
          expect(service.collection(enumerable([:success, :success, :success])).map { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(values: ["ok", "ok", "ok"])
          expect(service.collection(enumerator([:success, :success, :success])).map { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(values: ["ok", "ok", "ok"])
          expect(service.collection(lazy_enumerator([:success, :success, :success])).map { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(values: ["ok", "ok", "ok"])
          expect(service.collection(chain_enumerator([:success, :success, :success])).map { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(values: ["ok", "ok", "ok"])
          expect(service.collection([:success, :success, :success]).map { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(values: ["ok", "ok", "ok"])

          expect(service.collection(set([:success])).map { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(values: ["ok"])
          expect(service.collection({success: :success}).map { |key, value| step status_service, in: [status: -> { value }], out: :status_string }.result).to be_success.with_data(values: ["ok"])
          expect(service.collection((:success..:success)).map { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(values: ["ok"])

          # NOTE: Step with multiple outputs.
          expect(service.collection(enumerable([:success, :success, :success])).map { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [{status_string: "ok", status_code: 200}, {status_string: "ok", status_code: 200}, {status_string: "ok", status_code: 200}])
          expect(service.collection(enumerator([:success, :success, :success])).map { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [{status_string: "ok", status_code: 200}, {status_string: "ok", status_code: 200}, {status_string: "ok", status_code: 200}])
          expect(service.collection(lazy_enumerator([:success, :success, :success])).map { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [{status_string: "ok", status_code: 200}, {status_string: "ok", status_code: 200}, {status_string: "ok", status_code: 200}])
          expect(service.collection(chain_enumerator([:success, :success, :success])).map { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [{status_string: "ok", status_code: 200}, {status_string: "ok", status_code: 200}, {status_string: "ok", status_code: 200}])
          expect(service.collection([:success, :success, :success]).map { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [{status_string: "ok", status_code: 200}, {status_string: "ok", status_code: 200}, {status_string: "ok", status_code: 200}])

          expect(service.collection(set([:success])).map { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [{status_string: "ok", status_code: 200}])
          expect(service.collection({success: :success}).map { |key, value| step status_service, in: [status: -> { value }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [{status_string: "ok", status_code: 200}])
          expect(service.collection((:success..:success)).map { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [{status_string: "ok", status_code: 200}])

          # NOTE: Error result.
          expect(service.collection(enumerable([:success, :error, :exception])).map { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection(enumerator([:success, :error, :exception])).map { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection(lazy_enumerator([:success, :error, :exception])).map { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection(chain_enumerator([:success, :error, :exception])).map { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection([:success, :error, :exception]).map { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data

          expect(service.collection(set([:success, :error, :exception])).map { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection({success: :success, error: :error, exception: :exception}).map { |key, value| step status_service, in: [status: -> { value }] }.result).to be_error.without_data
          expect(service.collection((:error..:error)).map { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data

          # NOTE: Error propagation.
          expect(service.collection(enumerable([:success, :error, :exception])).select { |status| step status_service, in: [status: -> { status }] }.map { |status| condition[status] }.result).to be_error.without_data
          expect(service.collection(enumerator([:success, :error, :exception])).select { |status| step status_service, in: [status: -> { status }] }.map { |status| condition[status] }.result).to be_error.without_data
          expect(service.collection(lazy_enumerator([:success, :error, :exception])).select { |status| step status_service, in: [status: -> { status }] }.map { |status| condition[status] }.result).to be_error.without_data
          expect(service.collection(chain_enumerator([:success, :error, :exception])).select { |status| step status_service, in: [status: -> { status }] }.map { |status| condition[status] }.result).to be_error.without_data
          expect(service.collection([:success, :error, :exception]).select { |status| step status_service, in: [status: -> { status }] }.map { |status| condition[status] }.result).to be_error.without_data

          expect(service.collection(set([:success, :error, :exception])).select { |status| step status_service, in: [status: -> { status }] }.map { |status| condition[status] }.result).to be_error.without_data
          expect(service.collection({success: :success, error: :error, exception: :exception}).select { |key, value| step status_service, in: [status: -> { value }] }.map { |key, value| condition[value] }.result).to be_error.without_data
          expect(service.collection((:error..:error)).select { |status| step status_service, in: [status: -> { status }] }.map { |status| condition[status] }.result).to be_error.without_data

          # NOTE: Usage on terminal chaining.
          expect { service.collection(enumerable([:success, :exception, :exception])).first.map { |status| condition[status] }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection(enumerator([:success, :exception, :exception])).first.map { |status| condition[status] }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection(lazy_enumerator([:success, :exception, :exception])).first.map { |status| condition[status] }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection(chain_enumerator([:success, :exception, :exception])).first.map { |status| condition[status] }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection([:success, :exception, :exception]).first.map { |status| condition[status] }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)

          expect { service.collection(set([:success, :exception, :exception])).first.map { |status| condition[status] }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection({success: :success, exception: :exception}).first.map { |key, value| condition[value] }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection((:success..:success)).first.map { |status| condition[status] }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
        end
      end

      describe "#max" do
        specify do
          # NOTE: Empty collection.
          expect([].max).to eq(nil)
          expect(service.collection(enumerable([])).max.result).to be_failure.without_data
          expect(service.collection(enumerator([])).max.result).to be_failure.without_data
          expect(service.collection(lazy_enumerator([])).max.result).to be_failure.without_data
          expect(service.collection(chain_enumerator([])).max.result).to be_failure.without_data
          expect(service.collection([]).max.result).to be_failure.without_data
          expect(service.collection({}).max.result).to be_failure.without_data
          expect(service.collection((:success...:success)).max.result).to be_failure.without_data
          expect(service.collection(set([])).max.result).to be_failure.without_data

          # NOTE: No block, no n.
          expect([0, 1, 2, 3, 4, 5].max).to eq(5)
          expect(service.collection(enumerable([0, 1, 2, 3, 4, 5])).max.result).to be_success.with_data(value: 5)
          expect(service.collection(enumerator([0, 1, 2, 3, 4, 5])).max.result).to be_success.with_data(value: 5)
          expect(service.collection(lazy_enumerator([0, 1, 2, 3, 4, 5])).max.result).to be_success.with_data(value: 5)
          expect(service.collection(chain_enumerator([0, 1, 2, 3, 4, 5])).max.result).to be_success.with_data(value: 5)
          expect(service.collection([0, 1, 2, 3, 4, 5]).max.result).to be_success.with_data(value: 5)
          expect(service.collection(set([0, 1, 2, 3, 4, 5])).max.result).to be_success.with_data(value: 5)
          expect(service.collection({0 => 0, 1 => 1, 2 => 2, 3 => 3, 4 => 4, 5 => 5}).max.result).to be_success.with_data(value: [5, 5])
          expect(service.collection((0..5)).max.result).to be_success.with_data(value: 5)

          # NOTE: Block, no n.
          expect([0, 1, 2, 3, 4, 5].max { |number, other_number| number <=> other_number }).to eq(5)
          expect(service.collection(enumerable([0, 1, 2, 3, 4, 5])).max { |number, other_number| number <=> other_number }.result).to be_success.with_data(value: 5)
          expect(service.collection(enumerator([0, 1, 2, 3, 4, 5])).max { |number, other_number| number <=> other_number }.result).to be_success.with_data(value: 5)
          expect(service.collection(lazy_enumerator([0, 1, 2, 3, 4, 5])).max { |number, other_number| number <=> other_number }.result).to be_success.with_data(value: 5)
          expect(service.collection(chain_enumerator([0, 1, 2, 3, 4, 5])).max { |number, other_number| number <=> other_number }.result).to be_success.with_data(value: 5)
          expect(service.collection([0, 1, 2, 3, 4, 5]).max { |number, other_number| number <=> other_number }.result).to be_success.with_data(value: 5)
          expect(service.collection(set([0, 1, 2, 3, 4, 5])).max { |number, other_number| number <=> other_number }.result).to be_success.with_data(value: 5)

          expect(service.collection({0 => 0, 1 => 1, 2 => 2, 3 => 3, 4 => 4, 5 => 5}).max { |number, other_number| number <=> other_number }.result).to be_success.with_data(value: [5, 5])
          expect(service.collection((0..5)).max { |number, other_number| number <=> other_number }.result).to be_success.with_data(value: 5)

          # NOTE: Block, n.
          # - https://gist.github.com/marian13/a40f3be1379376d8991a98b9f1b37dcc
          expect([0, 1, 2, 3, 4, 5].max(2) { |number, other_number| number <=> other_number }).to eq([5, 4])
          expect(service.collection(enumerable([0, 1, 2, 3, 4, 5])).max(2) { |number, other_number| number <=> other_number }.result).to be_success.with_data(values: [5, 4])
          expect(service.collection(enumerator([0, 1, 2, 3, 4, 5])).max(2) { |number, other_number| number <=> other_number }.result).to be_success.with_data(values: [5, 4])
          expect(service.collection(lazy_enumerator([0, 1, 2, 3, 4, 5])).max(2) { |number, other_number| number <=> other_number }.result).to be_success.with_data(values: [5, 4])
          expect(service.collection(chain_enumerator([0, 1, 2, 3, 4, 5])).max(2) { |number, other_number| number <=> other_number }.result).to be_success.with_data(values: [5, 4])
          expect(service.collection([0, 1, 2, 3, 4, 5]).max(2) { |number, other_number| number <=> other_number }.result).to be_success.with_data(values: [5, 4])
          expect(service.collection(set([0, 1, 2, 3, 4, 5])).max(2) { |number, other_number| number <=> other_number }.result).to be_success.with_data(values: [5, 4])

          expect(service.collection({0 => 0, 1 => 1, 2 => 2, 3 => 3, 4 => 4, 5 => 5}).max(2) { |number, other_number| number <=> other_number }.result).to be_success.with_data(values: [[5, 5], [4, 4]])
          expect(service.collection((0..5)).max(2) { |number, other_number| number <=> other_number }.result).to be_success.with_data(values: [5, 4])

          # NOTE: Step with no outputs.
          expect { service.collection(enumerable([0, 1, 2, 3, 4, 5])).max { |number, other_number| step compare_numbers_service, in: [number: -> { number }, other_number: -> { other_number }] }.result }.to raise_error(NoMethodError).with_message("undefined method '>' for true")
          expect { service.collection(enumerator([0, 1, 2, 3, 4, 5])).max { |number, other_number| step compare_numbers_service, in: [number: -> { number }, other_number: -> { other_number }] }.result }.to raise_error(NoMethodError).with_message("undefined method '>' for true")
          expect { service.collection(lazy_enumerator([0, 1, 2, 3, 4, 5])).max { |number, other_number| step compare_numbers_service, in: [number: -> { number }, other_number: -> { other_number }] }.result }.to raise_error(NoMethodError).with_message("undefined method '>' for true")
          expect { service.collection(chain_enumerator([0, 1, 2, 3, 4, 5])).max { |number, other_number| step compare_numbers_service, in: [number: -> { number }, other_number: -> { other_number }] }.result }.to raise_error(NoMethodError).with_message("undefined method '>' for true")
          expect { service.collection([0, 1, 2, 3, 4, 5]).max { |number, other_number| step compare_numbers_service, in: [number: -> { number }, other_number: -> { other_number }] }.result }.to raise_error(NoMethodError).with_message("undefined method '>' for true")
          expect { service.collection(set([0, 1, 2, 3, 4, 5])).max { |number, other_number| step compare_numbers_service, in: [number: -> { number }, other_number: -> { other_number }] }.result }.to raise_error(NoMethodError).with_message("undefined method '>' for true")
          expect { service.collection({0 => 0, 1 => 1, 2 => 2, 3 => 3, 4 => 4, 5 => 5}).max { |hash, other_hash| step compare_numbers_service, in: [number: -> { hash.last }, other_number: -> { other_hash.last }] }.result }.to raise_error(NoMethodError).with_message("undefined method '>' for true")
          expect { service.collection((0..5)).max { |number, other_number| step compare_numbers_service, in: [number: -> { number }, other_number: -> { other_number }] }.result }.to raise_error(NoMethodError).with_message("undefined method '>' for true")

          # NOTE: Step with one output.
          expect(service.collection(enumerable([0, 1, 2, 3, 4, 5])).max { |number, other_number| step compare_numbers_service, in: [number: -> { number }, other_number: -> { other_number }], out: :integer }.result).to be_success.with_data(value: 5)
          expect(service.collection(enumerator([0, 1, 2, 3, 4, 5])).max { |number, other_number| step compare_numbers_service, in: [number: -> { number }, other_number: -> { other_number }], out: :integer }.result).to be_success.with_data(value: 5)
          expect(service.collection(lazy_enumerator([0, 1, 2, 3, 4, 5])).max { |number, other_number| step compare_numbers_service, in: [number: -> { number }, other_number: -> { other_number }], out: :integer }.result).to be_success.with_data(value: 5)
          expect(service.collection(chain_enumerator([0, 1, 2, 3, 4, 5])).max { |number, other_number| step compare_numbers_service, in: [number: -> { number }, other_number: -> { other_number }], out: :integer }.result).to be_success.with_data(value: 5)
          expect(service.collection([0, 1, 2, 3, 4, 5]).max { |number, other_number| step compare_numbers_service, in: [number: -> { number }, other_number: -> { other_number }], out: :integer }.result).to be_success.with_data(value: 5)
          expect(service.collection(set([0, 1, 2, 3, 4, 5])).max { |number, other_number| step compare_numbers_service, in: [number: -> { number }, other_number: -> { other_number }], out: :integer }.result).to be_success.with_data(value: 5)

          expect(service.collection({0 => 0, 1 => 1, 2 => 2, 3 => 3, 4 => 4, 5 => 5}).max { |hash, other_hash| step compare_numbers_service, in: [number: -> { hash.last }, other_number: -> { other_hash.last }], out: :integer }.result).to be_success.with_data(value: [5, 5])
          expect(service.collection((0..5)).max { |number, other_number| step compare_numbers_service, in: [number: -> { number }, other_number: -> { other_number }], out: :integer }.result).to be_success.with_data(value: 5)

          # NOTE: Step with multiple outputs.
          expect { service.collection(enumerable([0, 1, 2, 3, 4, 5])).max { |number, other_number| step compare_numbers_service, in: [number: -> { number }, other_number: -> { other_number }], out: [:integer, :operator] }.result }.to raise_error(TypeError).with_message("no implicit conversion of Integer into Hash")
          expect { service.collection(enumerator([0, 1, 2, 3, 4, 5])).max { |number, other_number| step compare_numbers_service, in: [number: -> { number }, other_number: -> { other_number }], out: [:integer, :operator] }.result }.to raise_error(TypeError).with_message("no implicit conversion of Integer into Hash")
          expect { service.collection(lazy_enumerator([0, 1, 2, 3, 4, 5])).max { |number, other_number| step compare_numbers_service, in: [number: -> { number }, other_number: -> { other_number }], out: [:integer, :operator] }.result }.to raise_error(TypeError).with_message("no implicit conversion of Integer into Hash")
          expect { service.collection(chain_enumerator([0, 1, 2, 3, 4, 5])).max { |number, other_number| step compare_numbers_service, in: [number: -> { number }, other_number: -> { other_number }], out: [:integer, :operator] }.result }.to raise_error(TypeError).with_message("no implicit conversion of Integer into Hash")
          expect { service.collection([0, 1, 2, 3, 4, 5]).max { |number, other_number| step compare_numbers_service, in: [number: -> { number }, other_number: -> { other_number }], out: [:integer, :operator] }.result }.to raise_error(TypeError).with_message("no implicit conversion of Integer into Hash")
          expect { service.collection(set([0, 1, 2, 3, 4, 5])).max { |number, other_number| step compare_numbers_service, in: [number: -> { number }, other_number: -> { other_number }], out: [:integer, :operator] }.result }.to raise_error(TypeError).with_message("no implicit conversion of Integer into Hash")

          expect { service.collection({0 => 0, 1 => 1, 2 => 2, 3 => 3, 4 => 4, 5 => 5}).max { |hash, other_hash| step compare_numbers_service, in: [number: -> { hash.last }, other_number: -> { other_hash.last }], out: [:integer, :operator] }.result }.to raise_error(TypeError).with_message("no implicit conversion of Integer into Hash")
          expect { service.collection((0..5)).max { |number, other_number| step compare_numbers_service, in: [number: -> { number }, other_number: -> { other_number }], out: [:integer, :operator] }.result }.to raise_error(TypeError).with_message("no implicit conversion of Integer into Hash")

          # NOTE: Error result.
          expect(service.collection(enumerable([0, -1, :exception])).max { |number, other_number| step compare_numbers_service, in: [number: -> { number }, other_number: -> { other_number }], out: :number_code }.result).to be_error.without_data
          expect(service.collection(enumerator([0, -1, :exception])).max { |number, other_number| step compare_numbers_service, in: [number: -> { number }, other_number: -> { other_number }], out: :number_code }.result).to be_error.without_data
          expect(service.collection(lazy_enumerator([0, -1, :exception])).max { |number, other_number| step compare_numbers_service, in: [number: -> { number }, other_number: -> { other_number }], out: :number_code }.result).to be_error.without_data
          expect(service.collection(chain_enumerator([0, -1, :exception])).max { |number, other_number| step compare_numbers_service, in: [number: -> { number }, other_number: -> { other_number }], out: :number_code }.result).to be_error.without_data
          expect(service.collection([0, -1, :exception]).max { |number, other_number| step compare_numbers_service, in: [number: -> { number }, other_number: -> { other_number }], out: :number_code }.result).to be_error.without_data
          expect(service.collection(set([0, -1, :exception])).max { |number, other_number| step compare_numbers_service, in: [number: -> { number }, other_number: -> { other_number }], out: :number_code }.result).to be_error.without_data

          expect(service.collection({0 => 0, -1 => -1, :exception => :exception}).max { |hash, other_hash| step compare_numbers_service, in: [number: -> { hash.last }, other_number: -> { other_hash.last }], out: :number_code }.result).to be_error.without_data
          expect(service.collection((-2..-1)).max { |number, other_number| step compare_numbers_service, in: [number: -> { number }, other_number: -> { other_number }], out: :number_code }.result).to be_error.without_data

          expect((-1..-1).max { raise }).to eq(-1)
          expect(service.collection((-1..-1)).max { raise }.result).to be_success.with_data(value: -1)

          # NOTE: Error propagation.
          expect(service.collection(enumerable([:success, :error, :exception])).select { |status| step status_service, in: [status: -> { status }] }.max.result).to be_error.without_data
          expect(service.collection(enumerator([:success, :error, :exception])).select { |status| step status_service, in: [status: -> { status }] }.max.result).to be_error.without_data
          expect(service.collection(lazy_enumerator([:success, :error, :exception])).select { |status| step status_service, in: [status: -> { status }] }.max.result).to be_error.without_data
          expect(service.collection(chain_enumerator([:success, :error, :exception])).select { |status| step status_service, in: [status: -> { status }] }.max.result).to be_error.without_data
          expect(service.collection([:success, :error, :exception]).select { |status| step status_service, in: [status: -> { status }] }.max.result).to be_error.without_data
          expect(service.collection(set([:success, :error, :exception])).select { |status| step status_service, in: [status: -> { status }] }.max.result).to be_error.without_data

          expect(service.collection({success: :success, error: :error, exception: :exception}).select { |key, value| step status_service, in: [status: -> { value }] }.max.result).to be_error.without_data
          expect(service.collection((:error..:error)).select { |status| step status_service, in: [status: -> { status }] }.max.result).to be_error.without_data

          # NOTE: Usage on terminal chaining.
          expect { service.collection(enumerable([:success, :exception, :exception])).first.max.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection(enumerator([:success, :exception, :exception])).first.max.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection(lazy_enumerator([:success, :exception, :exception])).first.max.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection(chain_enumerator([:success, :exception, :exception])).first.max.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection([:success, :exception, :exception]).first.max.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection(set([:success, :exception, :exception])).first.max.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)

          expect { service.collection({success: :success, exception: :exception}).first.max.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection((:success..:success)).first.max.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
        end
      end

      describe "#max_by" do
        specify do
          # NOTE: Empty collection.
          expect([].max_by { |number| number.to_s.ord }).to eq(nil)
          expect(service.collection(enumerable([])).max_by { |number| number.to_s.ord }.result).to be_failure.without_data
          expect(service.collection(enumerator([])).max_by { |number| number.to_s.ord }.result).to be_failure.without_data
          expect(service.collection(lazy_enumerator([])).max_by { |number| number.to_s.ord }.result).to be_failure.without_data
          expect(service.collection(chain_enumerator([])).max_by { |number| number.to_s.ord }.result).to be_failure.without_data
          expect(service.collection([]).max_by { |number| number.to_s.ord }.result).to be_failure.without_data
          expect(service.collection({}).max_by { |number| number.to_s.ord }.result).to be_failure.without_data
          expect(service.collection((:success...:success)).max_by { |number| number.to_s.ord }.result).to be_failure.without_data
          expect(service.collection(set([])).max_by { |number| number.to_s.ord }.result).to be_failure.without_data

          # NOTE: No block, no n.
          expect([0, 1, 2, 3, 4, 5].max_by.to_a).to eq([0, 1, 2, 3, 4, 5])
          expect(service.collection(enumerable([0, 1, 2, 3, 4, 5])).max_by.result).to be_success.with_data(values: [0, 1, 2, 3, 4, 5])
          expect(service.collection(enumerator([0, 1, 2, 3, 4, 5])).max_by.result).to be_success.with_data(values: [0, 1, 2, 3, 4, 5])
          expect(service.collection(lazy_enumerator([0, 1, 2, 3, 4, 5])).max_by.result).to be_success.with_data(values: [0, 1, 2, 3, 4, 5])
          expect(service.collection(chain_enumerator([0, 1, 2, 3, 4, 5])).max_by.result).to be_success.with_data(values: [0, 1, 2, 3, 4, 5])
          expect(service.collection([0, 1, 2, 3, 4, 5]).max_by.result).to be_success.with_data(values: [0, 1, 2, 3, 4, 5])
          expect(service.collection(set([0, 1, 2, 3, 4, 5])).max_by.result).to be_success.with_data(values: [0, 1, 2, 3, 4, 5])
          expect(service.collection({0 => 0, 1 => 1, 2 => 2, 3 => 3, 4 => 4, 5 => 5}).max_by.result).to be_success.with_data(values: [[0, 0], [1, 1], [2, 2], [3, 3], [4, 4], [5, 5]])
          expect(service.collection((0..5)).max_by.result).to be_success.with_data(values: [0, 1, 2, 3, 4, 5])

          # NOTE: No block, n.
          expect([0, 1, 2, 3, 4, 5].max_by(2).to_a).to eq([0, 1, 2, 3, 4, 5])
          expect(service.collection(enumerable([0, 1, 2, 3, 4, 5])).max_by(2).result).to be_success.with_data(values: [0, 1, 2, 3, 4, 5])
          expect(service.collection(enumerator([0, 1, 2, 3, 4, 5])).max_by(2).result).to be_success.with_data(values: [0, 1, 2, 3, 4, 5])
          expect(service.collection(lazy_enumerator([0, 1, 2, 3, 4, 5])).max_by(2).result).to be_success.with_data(values: [0, 1, 2, 3, 4, 5])
          expect(service.collection(chain_enumerator([0, 1, 2, 3, 4, 5])).max_by(2).result).to be_success.with_data(values: [0, 1, 2, 3, 4, 5])
          expect(service.collection([0, 1, 2, 3, 4, 5]).max_by(2).result).to be_success.with_data(values: [0, 1, 2, 3, 4, 5])
          expect(service.collection(set([0, 1, 2, 3, 4, 5])).max_by(2).result).to be_success.with_data(values: [0, 1, 2, 3, 4, 5])
          expect(service.collection({0 => 0, 1 => 1, 2 => 2, 3 => 3, 4 => 4, 5 => 5}).max_by(2).result).to be_success.with_data(values: [[0, 0], [1, 1], [2, 2], [3, 3], [4, 4], [5, 5]])
          expect(service.collection((0..5)).max_by(2).result).to be_success.with_data(values: [0, 1, 2, 3, 4, 5])

          # NOTE: Block, no n.
          expect([0, 1, 2, 3, 4, 5].max_by { |number| number.to_s.ord }).to eq(5)
          expect(service.collection(enumerable([0, 1, 2, 3, 4, 5])).max_by { |number| number.to_s.ord }.result).to be_success.with_data(value: 5)
          expect(service.collection(enumerator([0, 1, 2, 3, 4, 5])).max_by { |number| number.to_s.ord }.result).to be_success.with_data(value: 5)
          expect(service.collection(lazy_enumerator([0, 1, 2, 3, 4, 5])).max_by { |number| number.to_s.ord }.result).to be_success.with_data(value: 5)
          expect(service.collection(chain_enumerator([0, 1, 2, 3, 4, 5])).max_by { |number| number.to_s.ord }.result).to be_success.with_data(value: 5)
          expect(service.collection([0, 1, 2, 3, 4, 5]).max_by { |number| number.to_s.ord }.result).to be_success.with_data(value: 5)
          expect(service.collection(set([0, 1, 2, 3, 4, 5])).max_by { |number| number.to_s.ord }.result).to be_success.with_data(value: 5)

          expect(service.collection({0 => 0, 1 => 1, 2 => 2, 3 => 3, 4 => 4, 5 => 5}).max_by { |key, value| value.to_s.ord }.result).to be_success.with_data(value: [5, 5])
          expect(service.collection((0..5)).max_by { |number| number.to_s.ord }.result).to be_success.with_data(value: 5)

          # NOTE: Block, n.
          expect([0, 1, 2, 3, 4, 5].max_by(2) { |number| number.to_s.ord }).to eq([5, 4])
          expect(service.collection(enumerable([0, 1, 2, 3, 4, 5])).max_by(2) { |number| number.to_s.ord }.result).to be_success.with_data(values: [5, 4])
          expect(service.collection(enumerator([0, 1, 2, 3, 4, 5])).max_by(2) { |number| number.to_s.ord }.result).to be_success.with_data(values: [5, 4])
          expect(service.collection(lazy_enumerator([0, 1, 2, 3, 4, 5])).max_by(2) { |number| number.to_s.ord }.result).to be_success.with_data(values: [5, 4])
          expect(service.collection(chain_enumerator([0, 1, 2, 3, 4, 5])).max_by(2) { |number| number.to_s.ord }.result).to be_success.with_data(values: [5, 4])
          expect(service.collection([0, 1, 2, 3, 4, 5]).max_by(2) { |number| number.to_s.ord }.result).to be_success.with_data(values: [5, 4])
          expect(service.collection(set([0, 1, 2, 3, 4, 5])).max_by(2) { |number| number.to_s.ord }.result).to be_success.with_data(values: [5, 4])

          expect(service.collection({0 => 0, 1 => 1, 2 => 2, 3 => 3, 4 => 4, 5 => 5}).max_by(2) { |key, value| value.to_s.ord }.result).to be_success.with_data(values: [[5, 5], [4, 4]])
          expect(service.collection((0..5)).max_by(2) { |number| number.to_s.ord }.result).to be_success.with_data(values: [5, 4])

          # NOTE: Step with no outputs.
          expect(service.collection(enumerable([0, 1, 2, 3, 4, 5])).max_by { |number| step number_service, in: [number: -> { number }] }.result).to be_success.with_data(value: 0)
          expect(service.collection(enumerator([0, 1, 2, 3, 4, 5])).max_by { |number| step number_service, in: [number: -> { number }] }.result).to be_success.with_data(value: 0)
          expect(service.collection(lazy_enumerator([0, 1, 2, 3, 4, 5])).max_by { |number| step number_service, in: [number: -> { number }] }.result).to be_success.with_data(value: 0)
          expect(service.collection(chain_enumerator([0, 1, 2, 3, 4, 5])).max_by { |number| step number_service, in: [number: -> { number }] }.result).to be_success.with_data(value: 0)
          expect(service.collection([0, 1, 2, 3, 4, 5]).max_by { |number| step number_service, in: [number: -> { number }] }.result).to be_success.with_data(value: 0)
          expect(service.collection(set([0, 1, 2, 3, 4, 5])).max_by { |number| step number_service, in: [number: -> { number }] }.result).to be_success.with_data(value: 0)
          expect(service.collection({0 => 0, 1 => 1, 2 => 2, 3 => 3, 4 => 4, 5 => 5}).max_by { |(key, value)| step number_service, in: [number: -> { value }] }.result).to be_success.with_data(value: [0, 0])
          expect(service.collection((0..5)).max_by { |number| step number_service, in: [number: -> { number }] }.result).to be_success.with_data(value: 0)

          # NOTE: Step with one output.
          expect(service.collection(enumerable([0, 1, 2, 3, 4, 5])).max_by { |number| step number_service, in: [number: -> { number }], out: :number_code }.result).to be_success.with_data(value: 5)
          expect(service.collection(enumerator([0, 1, 2, 3, 4, 5])).max_by { |number| step number_service, in: [number: -> { number }], out: :number_code }.result).to be_success.with_data(value: 5)
          expect(service.collection(lazy_enumerator([0, 1, 2, 3, 4, 5])).max_by { |number| step number_service, in: [number: -> { number }], out: :number_code }.result).to be_success.with_data(value: 5)
          expect(service.collection(chain_enumerator([0, 1, 2, 3, 4, 5])).max_by { |number| step number_service, in: [number: -> { number }], out: :number_code }.result).to be_success.with_data(value: 5)
          expect(service.collection([0, 1, 2, 3, 4, 5]).max_by { |number| step number_service, in: [number: -> { number }], out: :number_code }.result).to be_success.with_data(value: 5)
          expect(service.collection(set([0, 1, 2, 3, 4, 5])).max_by { |number| step number_service, in: [number: -> { number }], out: :number_code }.result).to be_success.with_data(value: 5)

          expect(service.collection({0 => 0, 1 => 1, 2 => 2, 3 => 3, 4 => 4, 5 => 5}).max_by { |(key, value)| step number_service, in: [number: -> { value }], out: :number_code }.result).to be_success.with_data(value: [5, 5])
          expect(service.collection((0..5)).max_by { |number| step number_service, in: [number: -> { number }], out: :number_code }.result).to be_success.with_data(value: 5)

          # NOTE: Step with multiple outputs.
          expect { service.collection(enumerable([0, 1, 2, 3, 4, 5])).max_by { |number| step number_service, in: [number: -> { number }], out: [:number_string, :number_code] }.result }.to raise_error(ArgumentError).with_message("comparison of Hash with Hash failed")
          expect { service.collection(enumerator([0, 1, 2, 3, 4, 5])).max_by { |number| step number_service, in: [number: -> { number }], out: [:number_string, :number_code] }.result }.to raise_error(ArgumentError).with_message("comparison of Hash with Hash failed")
          expect { service.collection(lazy_enumerator([0, 1, 2, 3, 4, 5])).max_by { |number| step number_service, in: [number: -> { number }], out: [:number_string, :number_code] }.result }.to raise_error(ArgumentError).with_message("comparison of Hash with Hash failed")
          expect { service.collection(chain_enumerator([0, 1, 2, 3, 4, 5])).max_by { |number| step number_service, in: [number: -> { number }], out: [:number_string, :number_code] }.result }.to raise_error(ArgumentError).with_message("comparison of Hash with Hash failed")
          expect { service.collection([0, 1, 2, 3, 4, 5]).max_by { |number| step number_service, in: [number: -> { number }], out: [:number_string, :number_code] }.result }.to raise_error(ArgumentError).with_message("comparison of Hash with Hash failed")
          expect { service.collection(set([0, 1, 2, 3, 4, 5])).max_by { |number| step number_service, in: [number: -> { number }], out: [:number_string, :number_code] }.result }.to raise_error(ArgumentError).with_message("comparison of Hash with Hash failed")

          expect { service.collection({0 => 0, 1 => 1, 2 => 2, 3 => 3, 4 => 4, 5 => 5}).max_by { |(key, value)| step number_service, in: [number: -> { value }], out: [:number_string, :number_code] }.result }.to raise_error(ArgumentError).with_message("comparison of Hash with Hash failed")
          expect { service.collection((0..5)).max_by { |number| step number_service, in: [number: -> { number }], out: [:number_string, :number_code] }.result }.to raise_error(ArgumentError).with_message("comparison of Hash with Hash failed")

          # NOTE: Error result.
          expect(service.collection(enumerable([0, -1, :exception])).max_by { |number| step number_service, in: [number: -> { number }], out: :number_code }.result).to be_error.without_data
          expect(service.collection(enumerator([0, -1, :exception])).max_by { |number| step number_service, in: [number: -> { number }], out: :number_code }.result).to be_error.without_data
          expect(service.collection(lazy_enumerator([0, -1, :exception])).max_by { |number| step number_service, in: [number: -> { number }], out: :number_code }.result).to be_error.without_data
          expect(service.collection(chain_enumerator([0, -1, :exception])).max_by { |number| step number_service, in: [number: -> { number }], out: :number_code }.result).to be_error.without_data
          expect(service.collection([0, -1, :exception]).max_by { |number| step number_service, in: [number: -> { number }], out: :number_code }.result).to be_error.without_data
          expect(service.collection(set([0, -1, :exception])).max_by { |number| step number_service, in: [number: -> { number }], out: :number_code }.result).to be_error.without_data

          expect(service.collection({0 => 0, -1 => -1, :exception => :exception}).max_by { |(key, value)| step number_service, in: [number: -> { value }], out: :number_code }.result).to be_error.without_data
          expect(service.collection((-1..-1)).max_by { |number| step number_service, in: [number: -> { number }], out: :number_code }.result).to be_error.without_data

          # NOTE: Error propagation.
          expect(service.collection(enumerable([:success, :error, :exception])).select { |status| step status_service, in: [status: -> { status }] }.max_by { |number| number.to_s.ord }.result).to be_error.without_data
          expect(service.collection(enumerator([:success, :error, :exception])).select { |status| step status_service, in: [status: -> { status }] }.max_by { |number| number.to_s.ord }.result).to be_error.without_data
          expect(service.collection(lazy_enumerator([:success, :error, :exception])).select { |status| step status_service, in: [status: -> { status }] }.max_by { |number| number.to_s.ord }.result).to be_error.without_data
          expect(service.collection(chain_enumerator([:success, :error, :exception])).select { |status| step status_service, in: [status: -> { status }] }.max_by { |number| number.to_s.ord }.result).to be_error.without_data
          expect(service.collection([:success, :error, :exception]).select { |status| step status_service, in: [status: -> { status }] }.max_by { |number| number.to_s.ord }.result).to be_error.without_data
          expect(service.collection(set([:success, :error, :exception])).select { |status| step status_service, in: [status: -> { status }] }.max_by { |number| number.to_s.ord }.result).to be_error.without_data

          expect(service.collection({success: :success, error: :error, exception: :exception}).select { |key, value| step status_service, in: [status: -> { value }] }.max_by { |number| number.to_s.ord }.result).to be_error.without_data
          expect(service.collection((:error..:error)).select { |status| step status_service, in: [status: -> { status }] }.max_by { |number| number.to_s.ord }.result).to be_error.without_data

          # NOTE: Usage on terminal chaining.
          expect { service.collection(enumerable([:success, :exception, :exception])).first.max_by { |number| number.to_s.ord }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection(enumerator([:success, :exception, :exception])).first.max_by { |number| number.to_s.ord }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection(lazy_enumerator([:success, :exception, :exception])).first.max_by { |number| number.to_s.ord }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection(chain_enumerator([:success, :exception, :exception])).first.max_by { |number| number.to_s.ord }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection([:success, :exception, :exception]).first.max_by { |number| number.to_s.ord }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection(set([:success, :exception, :exception])).first.max_by { |number| number.to_s.ord }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)

          expect { service.collection({success: :success, exception: :exception}).first.max_by { |number| number.to_s.ord }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection((:success..:success)).first.max_by { |number| number.to_s.ord }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
        end
      end

      describe "#member?" do
        specify do
          # NOTE: Empty collection.
          expect([].member?(:success)).to eq(false)
          expect(service.collection(enumerable([])).member?(:success).result).to be_failure.without_data
          expect(service.collection(enumerator([])).member?(:success).result).to be_failure.without_data
          expect(service.collection(lazy_enumerator([])).member?(:success).result).to be_failure.without_data
          expect(service.collection(chain_enumerator([])).member?(:success).result).to be_failure.without_data
          expect(service.collection([]).member?(:success).result).to be_failure.without_data
          expect(service.collection({}).member?(:success).result).to be_failure.without_data
          expect(service.collection((:success...:success)).member?(:success).result).to be_failure.without_data
          expect(service.collection(set([])).member?(:success).result).to be_failure.without_data

          # NOTE: Matched pattern.
          expect([:failure, :success, :exception].member?(:success)).to eq(true)
          expect(service.collection(enumerable([:failure, :success, :exception])).member?(:success).result).to be_success.without_data
          expect(service.collection(enumerator([:failure, :success, :exception])).member?(:success).result).to be_success.without_data
          expect(service.collection(lazy_enumerator([:failure, :success, :exception])).member?(:success).result).to be_success.without_data
          expect(service.collection(chain_enumerator([:failure, :success, :exception])).member?(:success).result).to be_success.without_data
          expect(service.collection([:failure, :success, :exception]).member?(:success).result).to be_success.without_data
          expect(service.collection(set([:failure, :success, :exception])).member?(:success).result).to be_success.without_data

          expect(service.collection({success: :success}).member?(:success).result).to be_success.without_data
          expect(service.collection((:success..:success)).member?(:success).result).to be_success.without_data

          # NOTE: Not matched pattern.
          expect([:failure, :failure, :failure].member?(/success/)).to eq(false)
          expect(service.collection(enumerable([:failure, :failure, :failure])).member?(:success).result).to be_failure.without_data
          expect(service.collection(enumerator([:failure, :failure, :failure])).member?(:success).result).to be_failure.without_data
          expect(service.collection(lazy_enumerator([:failure, :failure, :failure])).member?(:success).result).to be_failure.without_data
          expect(service.collection(chain_enumerator([:failure, :failure, :failure])).member?(:success).result).to be_failure.without_data
          expect(service.collection([:failure, :failure, :failure]).member?(:success).result).to be_failure.without_data
          expect(service.collection(set([:failure, :failure, :failure])).member?(:success).result).to be_failure.without_data

          expect(service.collection({failure: :failure}).member?(:success).result).to be_failure.without_data
          expect(service.collection((:failure..:failure)).member?(:success).result).to be_failure.without_data

          # NOTE: Error propagation.
          expect(service.collection(enumerable([:failure, :error, :exception])).select { |status| step status_service, in: [status: -> { status }] }.member?(:success).result).to be_error.without_data
          expect(service.collection(enumerator([:failure, :error, :exception])).select { |status| step status_service, in: [status: -> { status }] }.member?(:success).result).to be_error.without_data
          expect(service.collection(lazy_enumerator([:failure, :error, :exception])).select { |status| step status_service, in: [status: -> { status }] }.member?(:success).result).to be_error.without_data
          expect(service.collection(chain_enumerator([:failure, :error, :exception])).select { |status| step status_service, in: [status: -> { status }] }.member?(:success).result).to be_error.without_data
          expect(service.collection([:failure, :error, :exception]).select { |status| step status_service, in: [status: -> { status }] }.member?(:success).result).to be_error.without_data
          expect(service.collection(set([:failure, :error, :exception])).select { |status| step status_service, in: [status: -> { status }] }.member?(:success).result).to be_error.without_data

          expect(service.collection({failure: :failure, error: :error, exception: :exception}).select { |key, value| step status_service, in: [status: -> { value }] }.member?(:success).result).to be_error.without_data
          expect(service.collection((:error..:error)).select { |status| step status_service, in: [status: -> { status }] }.member?(:success).result).to be_error.without_data

          # NOTE: Usage on terminal chaining.
          expect { service.collection(enumerable([:success, :exception, :exception])).first.member?(:success).result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection(enumerator([:success, :exception, :exception])).first.member?(:success).result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection(lazy_enumerator([:success, :exception, :exception])).first.member?(:success).result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection(chain_enumerator([:success, :exception, :exception])).first.member?(:success).result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection([:success, :exception, :exception]).first.member?(:success).result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection(set([:success, :exception, :exception])).first.member?(:success).result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)

          expect { service.collection({success: :success, exception: :exception}).first.member?(:success).result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection((:success..:success)).first.member?(:success).result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
        end
      end

      describe "#min" do
        specify do
          # NOTE: Empty collection.
          expect([].min).to eq(nil)
          expect(service.collection(enumerable([])).min.result).to be_failure.without_data
          expect(service.collection(enumerator([])).min.result).to be_failure.without_data
          expect(service.collection(lazy_enumerator([])).min.result).to be_failure.without_data
          expect(service.collection(chain_enumerator([])).min.result).to be_failure.without_data
          expect(service.collection([]).min.result).to be_failure.without_data
          expect(service.collection({}).min.result).to be_failure.without_data
          expect(service.collection((:success...:success)).min.result).to be_failure.without_data
          expect(service.collection(set([])).min.result).to be_failure.without_data

          # NOTE: No block, no n.
          expect([0, 1, 2, 3, 4, 5].min).to eq(0)
          expect(service.collection(enumerable([0, 1, 2, 3, 4, 5])).min.result).to be_success.with_data(value: 0)
          expect(service.collection(enumerator([0, 1, 2, 3, 4, 5])).min.result).to be_success.with_data(value: 0)
          expect(service.collection(lazy_enumerator([0, 1, 2, 3, 4, 5])).min.result).to be_success.with_data(value: 0)
          expect(service.collection(chain_enumerator([0, 1, 2, 3, 4, 5])).min.result).to be_success.with_data(value: 0)
          expect(service.collection([0, 1, 2, 3, 4, 5]).min.result).to be_success.with_data(value: 0)
          expect(service.collection(set([0, 1, 2, 3, 4, 5])).min.result).to be_success.with_data(value: 0)
          expect(service.collection({0 => 0, 1 => 1, 2 => 2, 3 => 3, 4 => 4, 5 => 5}).min.result).to be_success.with_data(value: [0, 0])
          expect(service.collection((0..5)).min.result).to be_success.with_data(value: 0)

          # NOTE: Block, no n.
          expect([0, 1, 2, 3, 4, 5].min { |number, other_number| number <=> other_number }).to eq(0)
          expect(service.collection(enumerable([0, 1, 2, 3, 4, 5])).min { |number, other_number| number <=> other_number }.result).to be_success.with_data(value: 0)
          expect(service.collection(enumerator([0, 1, 2, 3, 4, 5])).min { |number, other_number| number <=> other_number }.result).to be_success.with_data(value: 0)
          expect(service.collection(lazy_enumerator([0, 1, 2, 3, 4, 5])).min { |number, other_number| number <=> other_number }.result).to be_success.with_data(value: 0)
          expect(service.collection(chain_enumerator([0, 1, 2, 3, 4, 5])).min { |number, other_number| number <=> other_number }.result).to be_success.with_data(value: 0)
          expect(service.collection([0, 1, 2, 3, 4, 5]).min { |number, other_number| number <=> other_number }.result).to be_success.with_data(value: 0)
          expect(service.collection(set([0, 1, 2, 3, 4, 5])).min { |number, other_number| number <=> other_number }.result).to be_success.with_data(value: 0)

          expect(service.collection({0 => 0, 1 => 1, 2 => 2, 3 => 3, 4 => 4, 5 => 5}).min { |number, other_number| number <=> other_number }.result).to be_success.with_data(value: [0, 0])
          expect(service.collection((0..5)).min { |number, other_number| number <=> other_number }.result).to be_success.with_data(value: 0)

          # NOTE: Block, n.
          # - https://gist.github.com/marian13/a40f3be1379376d8991a98b9f1b37dcc
          expect([0, 1, 2, 3, 4, 5].min(2) { |number, other_number| number <=> other_number }).to eq([0, 1])
          expect(service.collection(enumerable([0, 1, 2, 3, 4, 5])).min(2) { |number, other_number| number <=> other_number }.result).to be_success.with_data(values: [0, 1])
          expect(service.collection(enumerator([0, 1, 2, 3, 4, 5])).min(2) { |number, other_number| number <=> other_number }.result).to be_success.with_data(values: [0, 1])
          expect(service.collection(lazy_enumerator([0, 1, 2, 3, 4, 5])).min(2) { |number, other_number| number <=> other_number }.result).to be_success.with_data(values: [0, 1])
          expect(service.collection(chain_enumerator([0, 1, 2, 3, 4, 5])).min(2) { |number, other_number| number <=> other_number }.result).to be_success.with_data(values: [0, 1])
          expect(service.collection([0, 1, 2, 3, 4, 5]).min(2) { |number, other_number| number <=> other_number }.result).to be_success.with_data(values: [0, 1])
          expect(service.collection(set([0, 1, 2, 3, 4, 5])).min(2) { |number, other_number| number <=> other_number }.result).to be_success.with_data(values: [0, 1])

          expect(service.collection({0 => 0, 1 => 1, 2 => 2, 3 => 3, 4 => 4, 5 => 5}).min(2) { |number, other_number| number <=> other_number }.result).to be_success.with_data(values: [[0, 0], [1, 1]])
          expect(service.collection((0..5)).min(2) { |number, other_number| number <=> other_number }.result).to be_success.with_data(values: [0, 1])

          # NOTE: Step with no outputs.
          expect { service.collection(enumerable([0, 1, 2, 3, 4, 5])).min { |number, other_number| step compare_numbers_service, in: [number: -> { number }, other_number: -> { other_number }] }.result }.to raise_error(NoMethodError).with_message("undefined method '>' for true")
          expect { service.collection(enumerator([0, 1, 2, 3, 4, 5])).min { |number, other_number| step compare_numbers_service, in: [number: -> { number }, other_number: -> { other_number }] }.result }.to raise_error(NoMethodError).with_message("undefined method '>' for true")
          expect { service.collection(lazy_enumerator([0, 1, 2, 3, 4, 5])).min { |number, other_number| step compare_numbers_service, in: [number: -> { number }, other_number: -> { other_number }] }.result }.to raise_error(NoMethodError).with_message("undefined method '>' for true")
          expect { service.collection(chain_enumerator([0, 1, 2, 3, 4, 5])).min { |number, other_number| step compare_numbers_service, in: [number: -> { number }, other_number: -> { other_number }] }.result }.to raise_error(NoMethodError).with_message("undefined method '>' for true")
          expect { service.collection([0, 1, 2, 3, 4, 5]).min { |number, other_number| step compare_numbers_service, in: [number: -> { number }, other_number: -> { other_number }] }.result }.to raise_error(NoMethodError).with_message("undefined method '>' for true")
          expect { service.collection(set([0, 1, 2, 3, 4, 5])).min { |number, other_number| step compare_numbers_service, in: [number: -> { number }, other_number: -> { other_number }] }.result }.to raise_error(NoMethodError).with_message("undefined method '>' for true")
          expect { service.collection({0 => 0, 1 => 1, 2 => 2, 3 => 3, 4 => 4, 5 => 5}).min { |hash, other_hash| step compare_numbers_service, in: [number: -> { hash.last }, other_number: -> { other_hash.last }] }.result }.to raise_error(NoMethodError).with_message("undefined method '>' for true")
          expect { service.collection((0..5)).min { |number, other_number| step compare_numbers_service, in: [number: -> { number }, other_number: -> { other_number }] }.result }.to raise_error(NoMethodError).with_message("undefined method '>' for true")

          # NOTE: Step with one output.
          expect(service.collection(enumerable([0, 1, 2, 3, 4, 5])).min { |number, other_number| step compare_numbers_service, in: [number: -> { number }, other_number: -> { other_number }], out: :integer }.result).to be_success.with_data(value: 0)
          expect(service.collection(enumerator([0, 1, 2, 3, 4, 5])).min { |number, other_number| step compare_numbers_service, in: [number: -> { number }, other_number: -> { other_number }], out: :integer }.result).to be_success.with_data(value: 0)
          expect(service.collection(lazy_enumerator([0, 1, 2, 3, 4, 5])).min { |number, other_number| step compare_numbers_service, in: [number: -> { number }, other_number: -> { other_number }], out: :integer }.result).to be_success.with_data(value: 0)
          expect(service.collection(chain_enumerator([0, 1, 2, 3, 4, 5])).min { |number, other_number| step compare_numbers_service, in: [number: -> { number }, other_number: -> { other_number }], out: :integer }.result).to be_success.with_data(value: 0)
          expect(service.collection([0, 1, 2, 3, 4, 5]).min { |number, other_number| step compare_numbers_service, in: [number: -> { number }, other_number: -> { other_number }], out: :integer }.result).to be_success.with_data(value: 0)
          expect(service.collection(set([0, 1, 2, 3, 4, 5])).min { |number, other_number| step compare_numbers_service, in: [number: -> { number }, other_number: -> { other_number }], out: :integer }.result).to be_success.with_data(value: 0)

          expect(service.collection({0 => 0, 1 => 1, 2 => 2, 3 => 3, 4 => 4, 5 => 5}).min { |hash, other_hash| step compare_numbers_service, in: [number: -> { hash.last }, other_number: -> { other_hash.last }], out: :integer }.result).to be_success.with_data(value: [0, 0])
          expect(service.collection((0..5)).min { |number, other_number| step compare_numbers_service, in: [number: -> { number }, other_number: -> { other_number }], out: :integer }.result).to be_success.with_data(value: 0)

          # NOTE: Step with multiple outputs.
          expect { service.collection(enumerable([0, 1, 2, 3, 4, 5])).min { |number, other_number| step compare_numbers_service, in: [number: -> { number }, other_number: -> { other_number }], out: [:integer, :operator] }.result }.to raise_error(TypeError).with_message("no implicit conversion of Integer into Hash")
          expect { service.collection(enumerator([0, 1, 2, 3, 4, 5])).min { |number, other_number| step compare_numbers_service, in: [number: -> { number }, other_number: -> { other_number }], out: [:integer, :operator] }.result }.to raise_error(TypeError).with_message("no implicit conversion of Integer into Hash")
          expect { service.collection(lazy_enumerator([0, 1, 2, 3, 4, 5])).min { |number, other_number| step compare_numbers_service, in: [number: -> { number }, other_number: -> { other_number }], out: [:integer, :operator] }.result }.to raise_error(TypeError).with_message("no implicit conversion of Integer into Hash")
          expect { service.collection(chain_enumerator([0, 1, 2, 3, 4, 5])).min { |number, other_number| step compare_numbers_service, in: [number: -> { number }, other_number: -> { other_number }], out: [:integer, :operator] }.result }.to raise_error(TypeError).with_message("no implicit conversion of Integer into Hash")
          expect { service.collection([0, 1, 2, 3, 4, 5]).min { |number, other_number| step compare_numbers_service, in: [number: -> { number }, other_number: -> { other_number }], out: [:integer, :operator] }.result }.to raise_error(TypeError).with_message("no implicit conversion of Integer into Hash")
          expect { service.collection(set([0, 1, 2, 3, 4, 5])).min { |number, other_number| step compare_numbers_service, in: [number: -> { number }, other_number: -> { other_number }], out: [:integer, :operator] }.result }.to raise_error(TypeError).with_message("no implicit conversion of Integer into Hash")

          expect { service.collection({0 => 0, 1 => 1, 2 => 2, 3 => 3, 4 => 4, 5 => 5}).min { |hash, other_hash| step compare_numbers_service, in: [number: -> { hash.last }, other_number: -> { other_hash.last }], out: [:integer, :operator] }.result }.to raise_error(TypeError).with_message("no implicit conversion of Integer into Hash")
          expect { service.collection((0..5)).min { |number, other_number| step compare_numbers_service, in: [number: -> { number }, other_number: -> { other_number }], out: [:integer, :operator] }.result }.to raise_error(TypeError).with_message("no implicit conversion of Integer into Hash")

          # NOTE: Error result.
          expect(service.collection(enumerable([0, -1, :exception])).min { |number, other_number| step compare_numbers_service, in: [number: -> { number }, other_number: -> { other_number }], out: :number_code }.result).to be_error.without_data
          expect(service.collection(enumerator([0, -1, :exception])).min { |number, other_number| step compare_numbers_service, in: [number: -> { number }, other_number: -> { other_number }], out: :number_code }.result).to be_error.without_data
          expect(service.collection(lazy_enumerator([0, -1, :exception])).min { |number, other_number| step compare_numbers_service, in: [number: -> { number }, other_number: -> { other_number }], out: :number_code }.result).to be_error.without_data
          expect(service.collection(chain_enumerator([0, -1, :exception])).min { |number, other_number| step compare_numbers_service, in: [number: -> { number }, other_number: -> { other_number }], out: :number_code }.result).to be_error.without_data
          expect(service.collection([0, -1, :exception]).min { |number, other_number| step compare_numbers_service, in: [number: -> { number }, other_number: -> { other_number }], out: :number_code }.result).to be_error.without_data
          expect(service.collection(set([0, -1, :exception])).min { |number, other_number| step compare_numbers_service, in: [number: -> { number }, other_number: -> { other_number }], out: :number_code }.result).to be_error.without_data

          expect(service.collection({0 => 0, -1 => -1, :exception => :exception}).min { |hash, other_hash| step compare_numbers_service, in: [number: -> { hash.last }, other_number: -> { other_hash.last }], out: :number_code }.result).to be_error.without_data
          expect(service.collection((-2..-1)).min { |number, other_number| step compare_numbers_service, in: [number: -> { number }, other_number: -> { other_number }], out: :number_code }.result).to be_error.without_data

          expect((-1..-1).min { raise }).to eq(-1)
          expect(service.collection((-1..-1)).min { raise }.result).to be_success.with_data(value: -1)

          # NOTE: Error propagation.
          expect(service.collection(enumerable([:success, :error, :exception])).select { |status| step status_service, in: [status: -> { status }] }.min.result).to be_error.without_data
          expect(service.collection(enumerator([:success, :error, :exception])).select { |status| step status_service, in: [status: -> { status }] }.min.result).to be_error.without_data
          expect(service.collection(lazy_enumerator([:success, :error, :exception])).select { |status| step status_service, in: [status: -> { status }] }.min.result).to be_error.without_data
          expect(service.collection(chain_enumerator([:success, :error, :exception])).select { |status| step status_service, in: [status: -> { status }] }.min.result).to be_error.without_data
          expect(service.collection([:success, :error, :exception]).select { |status| step status_service, in: [status: -> { status }] }.min.result).to be_error.without_data
          expect(service.collection(set([:success, :error, :exception])).select { |status| step status_service, in: [status: -> { status }] }.min.result).to be_error.without_data

          expect(service.collection({success: :success, error: :error, exception: :exception}).select { |key, value| step status_service, in: [status: -> { value }] }.min.result).to be_error.without_data
          expect(service.collection((:error..:error)).select { |status| step status_service, in: [status: -> { status }] }.min.result).to be_error.without_data

          # NOTE: Usage on terminal chaining.
          expect { service.collection(enumerable([:success, :exception, :exception])).first.min.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection(enumerator([:success, :exception, :exception])).first.min.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection(lazy_enumerator([:success, :exception, :exception])).first.min.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection(chain_enumerator([:success, :exception, :exception])).first.min.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection([:success, :exception, :exception]).first.min.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection(set([:success, :exception, :exception])).first.min.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)

          expect { service.collection({success: :success, exception: :exception}).first.min.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection((:success..:success)).first.min.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
        end
      end

      describe "#min_by" do
        specify do
          # NOTE: Empty collection.
          expect([].min_by { |number| number.to_s.ord }).to eq(nil)
          expect(service.collection(enumerable([])).min_by { |number| number.to_s.ord }.result).to be_failure.without_data
          expect(service.collection(enumerator([])).min_by { |number| number.to_s.ord }.result).to be_failure.without_data
          expect(service.collection(lazy_enumerator([])).min_by { |number| number.to_s.ord }.result).to be_failure.without_data
          expect(service.collection(chain_enumerator([])).min_by { |number| number.to_s.ord }.result).to be_failure.without_data
          expect(service.collection([]).min_by { |number| number.to_s.ord }.result).to be_failure.without_data
          expect(service.collection({}).min_by { |number| number.to_s.ord }.result).to be_failure.without_data
          expect(service.collection((:success...:success)).min_by { |number| number.to_s.ord }.result).to be_failure.without_data
          expect(service.collection(set([])).min_by { |number| number.to_s.ord }.result).to be_failure.without_data

          # NOTE: No block, no n.
          expect([0, 1, 2, 3, 4, 5].min_by.to_a).to eq([0, 1, 2, 3, 4, 5])
          expect(service.collection(enumerable([0, 1, 2, 3, 4, 5])).min_by.result).to be_success.with_data(values: [0, 1, 2, 3, 4, 5])
          expect(service.collection(enumerator([0, 1, 2, 3, 4, 5])).min_by.result).to be_success.with_data(values: [0, 1, 2, 3, 4, 5])
          expect(service.collection(lazy_enumerator([0, 1, 2, 3, 4, 5])).min_by.result).to be_success.with_data(values: [0, 1, 2, 3, 4, 5])
          expect(service.collection(chain_enumerator([0, 1, 2, 3, 4, 5])).min_by.result).to be_success.with_data(values: [0, 1, 2, 3, 4, 5])
          expect(service.collection([0, 1, 2, 3, 4, 5]).min_by.result).to be_success.with_data(values: [0, 1, 2, 3, 4, 5])
          expect(service.collection(set([0, 1, 2, 3, 4, 5])).min_by.result).to be_success.with_data(values: [0, 1, 2, 3, 4, 5])
          expect(service.collection({0 => 0, 1 => 1, 2 => 2, 3 => 3, 4 => 4, 5 => 5}).min_by.result).to be_success.with_data(values: [[0, 0], [1, 1], [2, 2], [3, 3], [4, 4], [5, 5]])
          expect(service.collection((0..5)).min_by.result).to be_success.with_data(values: [0, 1, 2, 3, 4, 5])

          # NOTE: No block, n.
          expect([0, 1, 2, 3, 4, 5].min_by(2).to_a).to eq([0, 1, 2, 3, 4, 5])
          expect(service.collection(enumerable([0, 1, 2, 3, 4, 5])).min_by(2).result).to be_success.with_data(values: [0, 1, 2, 3, 4, 5])
          expect(service.collection(enumerator([0, 1, 2, 3, 4, 5])).min_by(2).result).to be_success.with_data(values: [0, 1, 2, 3, 4, 5])
          expect(service.collection(lazy_enumerator([0, 1, 2, 3, 4, 5])).min_by(2).result).to be_success.with_data(values: [0, 1, 2, 3, 4, 5])
          expect(service.collection(chain_enumerator([0, 1, 2, 3, 4, 5])).min_by(2).result).to be_success.with_data(values: [0, 1, 2, 3, 4, 5])
          expect(service.collection([0, 1, 2, 3, 4, 5]).min_by(2).result).to be_success.with_data(values: [0, 1, 2, 3, 4, 5])
          expect(service.collection(set([0, 1, 2, 3, 4, 5])).min_by(2).result).to be_success.with_data(values: [0, 1, 2, 3, 4, 5])
          expect(service.collection({0 => 0, 1 => 1, 2 => 2, 3 => 3, 4 => 4, 5 => 5}).min_by(2).result).to be_success.with_data(values: [[0, 0], [1, 1], [2, 2], [3, 3], [4, 4], [5, 5]])
          expect(service.collection((0..5)).min_by(2).result).to be_success.with_data(values: [0, 1, 2, 3, 4, 5])

          # NOTE: Block, no n.
          expect([0, 1, 2, 3, 4, 5].min_by { |number| number.to_s.ord }).to eq(0)
          expect(service.collection(enumerable([0, 1, 2, 3, 4, 5])).min_by { |number| number.to_s.ord }.result).to be_success.with_data(value: 0)
          expect(service.collection(enumerator([0, 1, 2, 3, 4, 5])).min_by { |number| number.to_s.ord }.result).to be_success.with_data(value: 0)
          expect(service.collection(lazy_enumerator([0, 1, 2, 3, 4, 5])).min_by { |number| number.to_s.ord }.result).to be_success.with_data(value: 0)
          expect(service.collection(chain_enumerator([0, 1, 2, 3, 4, 5])).min_by { |number| number.to_s.ord }.result).to be_success.with_data(value: 0)
          expect(service.collection([0, 1, 2, 3, 4, 5]).min_by { |number| number.to_s.ord }.result).to be_success.with_data(value: 0)
          expect(service.collection(set([0, 1, 2, 3, 4, 5])).min_by { |number| number.to_s.ord }.result).to be_success.with_data(value: 0)

          expect(service.collection({0 => 0, 1 => 1, 2 => 2, 3 => 3, 4 => 4, 5 => 5}).min_by { |key, value| value.to_s.ord }.result).to be_success.with_data(value: [0, 0])
          expect(service.collection((0..5)).min_by { |number| number.to_s.ord }.result).to be_success.with_data(value: 0)

          # NOTE: Block, n.
          expect([0, 1, 2, 3, 4, 5].min_by(2) { |number| number.to_s.ord }).to eq([0, 1])
          expect(service.collection(enumerable([0, 1, 2, 3, 4, 5])).min_by(2) { |number| number.to_s.ord }.result).to be_success.with_data(values: [0, 1])
          expect(service.collection(enumerator([0, 1, 2, 3, 4, 5])).min_by(2) { |number| number.to_s.ord }.result).to be_success.with_data(values: [0, 1])
          expect(service.collection(lazy_enumerator([0, 1, 2, 3, 4, 5])).min_by(2) { |number| number.to_s.ord }.result).to be_success.with_data(values: [0, 1])
          expect(service.collection(chain_enumerator([0, 1, 2, 3, 4, 5])).min_by(2) { |number| number.to_s.ord }.result).to be_success.with_data(values: [0, 1])
          expect(service.collection([0, 1, 2, 3, 4, 5]).min_by(2) { |number| number.to_s.ord }.result).to be_success.with_data(values: [0, 1])
          expect(service.collection(set([0, 1, 2, 3, 4, 5])).min_by(2) { |number| number.to_s.ord }.result).to be_success.with_data(values: [0, 1])

          expect(service.collection({0 => 0, 1 => 1, 2 => 2, 3 => 3, 4 => 4, 5 => 5}).min_by(2) { |key, value| value.to_s.ord }.result).to be_success.with_data(values: [[0, 0], [1, 1]])
          expect(service.collection((0..5)).min_by(2) { |number| number.to_s.ord }.result).to be_success.with_data(values: [0, 1])

          # NOTE: Step with no outputs.
          expect(service.collection(enumerable([0, 1, 2, 3, 4, 5])).min_by { |number| step number_service, in: [number: -> { number }] }.result).to be_success.with_data(value: 0)
          expect(service.collection(enumerator([0, 1, 2, 3, 4, 5])).min_by { |number| step number_service, in: [number: -> { number }] }.result).to be_success.with_data(value: 0)
          expect(service.collection(lazy_enumerator([0, 1, 2, 3, 4, 5])).min_by { |number| step number_service, in: [number: -> { number }] }.result).to be_success.with_data(value: 0)
          expect(service.collection(chain_enumerator([0, 1, 2, 3, 4, 5])).min_by { |number| step number_service, in: [number: -> { number }] }.result).to be_success.with_data(value: 0)
          expect(service.collection([0, 1, 2, 3, 4, 5]).min_by { |number| step number_service, in: [number: -> { number }] }.result).to be_success.with_data(value: 0)
          expect(service.collection(set([0, 1, 2, 3, 4, 5])).min_by { |number| step number_service, in: [number: -> { number }] }.result).to be_success.with_data(value: 0)
          expect(service.collection({0 => 0, 1 => 1, 2 => 2, 3 => 3, 4 => 4, 5 => 5}).min_by { |(key, value)| step number_service, in: [number: -> { value }] }.result).to be_success.with_data(value: [0, 0])
          expect(service.collection((0..5)).min_by { |number| step number_service, in: [number: -> { number }] }.result).to be_success.with_data(value: 0)

          # NOTE: Step with one output.
          expect(service.collection(enumerable([0, 1, 2, 3, 4, 5])).min_by { |number| step number_service, in: [number: -> { number }], out: :number_code }.result).to be_success.with_data(value: 0)
          expect(service.collection(enumerator([0, 1, 2, 3, 4, 5])).min_by { |number| step number_service, in: [number: -> { number }], out: :number_code }.result).to be_success.with_data(value: 0)
          expect(service.collection(lazy_enumerator([0, 1, 2, 3, 4, 5])).min_by { |number| step number_service, in: [number: -> { number }], out: :number_code }.result).to be_success.with_data(value: 0)
          expect(service.collection(chain_enumerator([0, 1, 2, 3, 4, 5])).min_by { |number| step number_service, in: [number: -> { number }], out: :number_code }.result).to be_success.with_data(value: 0)
          expect(service.collection([0, 1, 2, 3, 4, 5]).min_by { |number| step number_service, in: [number: -> { number }], out: :number_code }.result).to be_success.with_data(value: 0)
          expect(service.collection(set([0, 1, 2, 3, 4, 5])).min_by { |number| step number_service, in: [number: -> { number }], out: :number_code }.result).to be_success.with_data(value: 0)

          expect(service.collection({0 => 0, 1 => 1, 2 => 2, 3 => 3, 4 => 4, 5 => 5}).min_by { |(key, value)| step number_service, in: [number: -> { value }], out: :number_code }.result).to be_success.with_data(value: [0, 0])
          expect(service.collection((0..5)).min_by { |number| step number_service, in: [number: -> { number }], out: :number_code }.result).to be_success.with_data(value: 0)

          # NOTE: Step with multiple outputs.
          expect { service.collection(enumerable([0, 1, 2, 3, 4, 5])).min_by { |number| step number_service, in: [number: -> { number }], out: [:number_string, :number_code] }.result }.to raise_error(ArgumentError).with_message("comparison of Hash with Hash failed")
          expect { service.collection(enumerator([0, 1, 2, 3, 4, 5])).min_by { |number| step number_service, in: [number: -> { number }], out: [:number_string, :number_code] }.result }.to raise_error(ArgumentError).with_message("comparison of Hash with Hash failed")
          expect { service.collection(lazy_enumerator([0, 1, 2, 3, 4, 5])).min_by { |number| step number_service, in: [number: -> { number }], out: [:number_string, :number_code] }.result }.to raise_error(ArgumentError).with_message("comparison of Hash with Hash failed")
          expect { service.collection(chain_enumerator([0, 1, 2, 3, 4, 5])).min_by { |number| step number_service, in: [number: -> { number }], out: [:number_string, :number_code] }.result }.to raise_error(ArgumentError).with_message("comparison of Hash with Hash failed")
          expect { service.collection([0, 1, 2, 3, 4, 5]).min_by { |number| step number_service, in: [number: -> { number }], out: [:number_string, :number_code] }.result }.to raise_error(ArgumentError).with_message("comparison of Hash with Hash failed")
          expect { service.collection(set([0, 1, 2, 3, 4, 5])).min_by { |number| step number_service, in: [number: -> { number }], out: [:number_string, :number_code] }.result }.to raise_error(ArgumentError).with_message("comparison of Hash with Hash failed")

          expect { service.collection({0 => 0, 1 => 1, 2 => 2, 3 => 3, 4 => 4, 5 => 5}).min_by { |(key, value)| step number_service, in: [number: -> { value }], out: [:number_string, :number_code] }.result }.to raise_error(ArgumentError).with_message("comparison of Hash with Hash failed")
          expect { service.collection((0..5)).min_by { |number| step number_service, in: [number: -> { number }], out: [:number_string, :number_code] }.result }.to raise_error(ArgumentError).with_message("comparison of Hash with Hash failed")

          # NOTE: Error result.
          expect(service.collection(enumerable([0, -1, :exception])).min_by { |number| step number_service, in: [number: -> { number }], out: :number_code }.result).to be_error.without_data
          expect(service.collection(enumerator([0, -1, :exception])).min_by { |number| step number_service, in: [number: -> { number }], out: :number_code }.result).to be_error.without_data
          expect(service.collection(lazy_enumerator([0, -1, :exception])).min_by { |number| step number_service, in: [number: -> { number }], out: :number_code }.result).to be_error.without_data
          expect(service.collection(chain_enumerator([0, -1, :exception])).min_by { |number| step number_service, in: [number: -> { number }], out: :number_code }.result).to be_error.without_data
          expect(service.collection([0, -1, :exception]).min_by { |number| step number_service, in: [number: -> { number }], out: :number_code }.result).to be_error.without_data
          expect(service.collection(set([0, -1, :exception])).min_by { |number| step number_service, in: [number: -> { number }], out: :number_code }.result).to be_error.without_data

          expect(service.collection({0 => 0, -1 => -1, :exception => :exception}).min_by { |(key, value)| step number_service, in: [number: -> { value }], out: :number_code }.result).to be_error.without_data
          expect(service.collection((-1..-1)).min_by { |number| step number_service, in: [number: -> { number }], out: :number_code }.result).to be_error.without_data

          # NOTE: Error propagation.
          expect(service.collection(enumerable([:success, :error, :exception])).select { |status| step status_service, in: [status: -> { status }] }.min_by { |number| number.to_s.ord }.result).to be_error.without_data
          expect(service.collection(enumerator([:success, :error, :exception])).select { |status| step status_service, in: [status: -> { status }] }.min_by { |number| number.to_s.ord }.result).to be_error.without_data
          expect(service.collection(lazy_enumerator([:success, :error, :exception])).select { |status| step status_service, in: [status: -> { status }] }.min_by { |number| number.to_s.ord }.result).to be_error.without_data
          expect(service.collection(chain_enumerator([:success, :error, :exception])).select { |status| step status_service, in: [status: -> { status }] }.min_by { |number| number.to_s.ord }.result).to be_error.without_data
          expect(service.collection([:success, :error, :exception]).select { |status| step status_service, in: [status: -> { status }] }.min_by { |number| number.to_s.ord }.result).to be_error.without_data
          expect(service.collection(set([:success, :error, :exception])).select { |status| step status_service, in: [status: -> { status }] }.min_by { |number| number.to_s.ord }.result).to be_error.without_data

          expect(service.collection({success: :success, error: :error, exception: :exception}).select { |key, value| step status_service, in: [status: -> { value }] }.min_by { |number| number.to_s.ord }.result).to be_error.without_data
          expect(service.collection((:error..:error)).select { |status| step status_service, in: [status: -> { status }] }.min_by { |number| number.to_s.ord }.result).to be_error.without_data

          # NOTE: Usage on terminal chaining.
          expect { service.collection(enumerable([:success, :exception, :exception])).first.min_by { |number| number.to_s.ord }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection(enumerator([:success, :exception, :exception])).first.min_by { |number| number.to_s.ord }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection(lazy_enumerator([:success, :exception, :exception])).first.min_by { |number| number.to_s.ord }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection(chain_enumerator([:success, :exception, :exception])).first.min_by { |number| number.to_s.ord }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection([:success, :exception, :exception]).first.min_by { |number| number.to_s.ord }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection(set([:success, :exception, :exception])).first.min_by { |number| number.to_s.ord }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)

          expect { service.collection({success: :success, exception: :exception}).first.min_by { |number| number.to_s.ord }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection((:success..:success)).first.min_by { |number| number.to_s.ord }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
        end
      end

      describe "#minmax" do
        specify do
          # NOTE: Empty collection.
          expect([].minmax).to eq([nil, nil])
          expect(service.collection(enumerable([])).minmax.result).to be_success.with_data(values: [nil, nil])
          expect(service.collection(enumerator([])).minmax.result).to be_success.with_data(values: [nil, nil])
          expect(service.collection(lazy_enumerator([])).minmax.result).to be_success.with_data(values: [nil, nil])
          expect(service.collection(chain_enumerator([])).minmax.result).to be_success.with_data(values: [nil, nil])
          expect(service.collection([]).minmax.result).to be_success.with_data(values: [nil, nil])
          expect(service.collection({}).minmax.result).to be_success.with_data(values: [nil, nil])
          expect(service.collection((:success...:success)).minmax.result).to be_success.with_data(values: [nil, nil])
          expect(service.collection(set([])).minmax.result).to be_success.with_data(values: [nil, nil])

          # NOTE: No block.
          expect([0, 1, 2, 3, 4, 5].minmax).to eq([0, 5])
          expect(service.collection(enumerable([0, 1, 2, 3, 4, 5])).minmax.result).to be_success.with_data(values: [0, 5])
          expect(service.collection(enumerator([0, 1, 2, 3, 4, 5])).minmax.result).to be_success.with_data(values: [0, 5])
          expect(service.collection(lazy_enumerator([0, 1, 2, 3, 4, 5])).minmax.result).to be_success.with_data(values: [0, 5])
          expect(service.collection(chain_enumerator([0, 1, 2, 3, 4, 5])).minmax.result).to be_success.with_data(values: [0, 5])
          expect(service.collection([0, 1, 2, 3, 4, 5]).minmax.result).to be_success.with_data(values: [0, 5])
          expect(service.collection(set([0, 1, 2, 3, 4, 5])).minmax.result).to be_success.with_data(values: [0, 5])
          expect(service.collection({0 => 0, 1 => 1, 2 => 2, 3 => 3, 4 => 4, 5 => 5}).minmax.result).to be_success.with_data(values: [[0, 0], [5, 5]])
          expect(service.collection((0..5)).minmax.result).to be_success.with_data(values: [0, 5])

          # NOTE: Block.
          expect([0, 1, 2, 3, 4, 5].minmax { |number, other_number| number <=> other_number }).to eq([0, 5])
          expect(service.collection(enumerable([0, 1, 2, 3, 4, 5])).minmax { |number, other_number| number <=> other_number }.result).to be_success.with_data(values: [0, 5])
          expect(service.collection(enumerator([0, 1, 2, 3, 4, 5])).minmax { |number, other_number| number <=> other_number }.result).to be_success.with_data(values: [0, 5])
          expect(service.collection(lazy_enumerator([0, 1, 2, 3, 4, 5])).minmax { |number, other_number| number <=> other_number }.result).to be_success.with_data(values: [0, 5])
          expect(service.collection(chain_enumerator([0, 1, 2, 3, 4, 5])).minmax { |number, other_number| number <=> other_number }.result).to be_success.with_data(values: [0, 5])
          expect(service.collection([0, 1, 2, 3, 4, 5]).minmax { |number, other_number| number <=> other_number }.result).to be_success.with_data(values: [0, 5])
          expect(service.collection(set([0, 1, 2, 3, 4, 5])).minmax { |number, other_number| number <=> other_number }.result).to be_success.with_data(values: [0, 5])

          expect(service.collection({0 => 0, 1 => 1, 2 => 2, 3 => 3, 4 => 4, 5 => 5}).minmax { |number, other_number| number <=> other_number }.result).to be_success.with_data(values: [[0, 0], [5, 5]])
          expect(service.collection((0..5)).minmax { |number, other_number| number <=> other_number }.result).to be_success.with_data(values: [0, 5])

          # NOTE: Step with no outputs.
          expect { service.collection(enumerable([0, 1, 2, 3, 4, 5])).minmax { |number, other_number| step compare_numbers_service, in: [number: -> { number }, other_number: -> { other_number }] }.result }.to raise_error(NoMethodError).with_message("undefined method '>' for true")
          expect { service.collection(enumerator([0, 1, 2, 3, 4, 5])).minmax { |number, other_number| step compare_numbers_service, in: [number: -> { number }, other_number: -> { other_number }] }.result }.to raise_error(NoMethodError).with_message("undefined method '>' for true")
          expect { service.collection(lazy_enumerator([0, 1, 2, 3, 4, 5])).minmax { |number, other_number| step compare_numbers_service, in: [number: -> { number }, other_number: -> { other_number }] }.result }.to raise_error(NoMethodError).with_message("undefined method '>' for true")
          expect { service.collection(chain_enumerator([0, 1, 2, 3, 4, 5])).minmax { |number, other_number| step compare_numbers_service, in: [number: -> { number }, other_number: -> { other_number }] }.result }.to raise_error(NoMethodError).with_message("undefined method '>' for true")
          expect { service.collection([0, 1, 2, 3, 4, 5]).minmax { |number, other_number| step compare_numbers_service, in: [number: -> { number }, other_number: -> { other_number }] }.result }.to raise_error(NoMethodError).with_message("undefined method '>' for true")
          expect { service.collection(set([0, 1, 2, 3, 4, 5])).minmax { |number, other_number| step compare_numbers_service, in: [number: -> { number }, other_number: -> { other_number }] }.result }.to raise_error(NoMethodError).with_message("undefined method '>' for true")
          expect { service.collection({0 => 0, 1 => 1, 2 => 2, 3 => 3, 4 => 4, 5 => 5}).minmax { |hash, other_hash| step compare_numbers_service, in: [number: -> { hash.last }, other_number: -> { other_hash.last }] }.result }.to raise_error(NoMethodError).with_message("undefined method '>' for true")
          expect { service.collection((0..5)).minmax { |number, other_number| step compare_numbers_service, in: [number: -> { number }, other_number: -> { other_number }] }.result }.to raise_error(NoMethodError).with_message("undefined method '>' for true")

          # NOTE: Step with one output.
          expect(service.collection(enumerable([0, 1, 2, 3, 4, 5])).minmax { |number, other_number| step compare_numbers_service, in: [number: -> { number }, other_number: -> { other_number }], out: :integer }.result).to be_success.with_data(values: [0, 5])
          expect(service.collection(enumerator([0, 1, 2, 3, 4, 5])).minmax { |number, other_number| step compare_numbers_service, in: [number: -> { number }, other_number: -> { other_number }], out: :integer }.result).to be_success.with_data(values: [0, 5])
          expect(service.collection(lazy_enumerator([0, 1, 2, 3, 4, 5])).minmax { |number, other_number| step compare_numbers_service, in: [number: -> { number }, other_number: -> { other_number }], out: :integer }.result).to be_success.with_data(values: [0, 5])
          expect(service.collection(chain_enumerator([0, 1, 2, 3, 4, 5])).minmax { |number, other_number| step compare_numbers_service, in: [number: -> { number }, other_number: -> { other_number }], out: :integer }.result).to be_success.with_data(values: [0, 5])
          expect(service.collection([0, 1, 2, 3, 4, 5]).minmax { |number, other_number| step compare_numbers_service, in: [number: -> { number }, other_number: -> { other_number }], out: :integer }.result).to be_success.with_data(values: [0, 5])
          expect(service.collection(set([0, 1, 2, 3, 4, 5])).minmax { |number, other_number| step compare_numbers_service, in: [number: -> { number }, other_number: -> { other_number }], out: :integer }.result).to be_success.with_data(values: [0, 5])

          expect(service.collection({0 => 0, 1 => 1, 2 => 2, 3 => 3, 4 => 4, 5 => 5}).minmax { |hash, other_hash| step compare_numbers_service, in: [number: -> { hash.last }, other_number: -> { other_hash.last }], out: :integer }.result).to be_success.with_data(values: [[0, 0], [5, 5]])
          expect(service.collection((0..5)).minmax { |number, other_number| step compare_numbers_service, in: [number: -> { number }, other_number: -> { other_number }], out: :integer }.result).to be_success.with_data(values: [0, 5])

          # NOTE: Step with multiple outputs.
          expect { service.collection(enumerable([0, 1, 2, 3, 4, 5])).minmax { |number, other_number| step compare_numbers_service, in: [number: -> { number }, other_number: -> { other_number }], out: [:integer, :operator] }.result }.to raise_error(TypeError).with_message("no implicit conversion of Integer into Hash")
          expect { service.collection(enumerator([0, 1, 2, 3, 4, 5])).minmax { |number, other_number| step compare_numbers_service, in: [number: -> { number }, other_number: -> { other_number }], out: [:integer, :operator] }.result }.to raise_error(TypeError).with_message("no implicit conversion of Integer into Hash")
          expect { service.collection(lazy_enumerator([0, 1, 2, 3, 4, 5])).minmax { |number, other_number| step compare_numbers_service, in: [number: -> { number }, other_number: -> { other_number }], out: [:integer, :operator] }.result }.to raise_error(TypeError).with_message("no implicit conversion of Integer into Hash")
          expect { service.collection(chain_enumerator([0, 1, 2, 3, 4, 5])).minmax { |number, other_number| step compare_numbers_service, in: [number: -> { number }, other_number: -> { other_number }], out: [:integer, :operator] }.result }.to raise_error(TypeError).with_message("no implicit conversion of Integer into Hash")
          expect { service.collection([0, 1, 2, 3, 4, 5]).minmax { |number, other_number| step compare_numbers_service, in: [number: -> { number }, other_number: -> { other_number }], out: [:integer, :operator] }.result }.to raise_error(TypeError).with_message("no implicit conversion of Integer into Hash")
          expect { service.collection(set([0, 1, 2, 3, 4, 5])).minmax { |number, other_number| step compare_numbers_service, in: [number: -> { number }, other_number: -> { other_number }], out: [:integer, :operator] }.result }.to raise_error(TypeError).with_message("no implicit conversion of Integer into Hash")

          expect { service.collection({0 => 0, 1 => 1, 2 => 2, 3 => 3, 4 => 4, 5 => 5}).minmax { |hash, other_hash| step compare_numbers_service, in: [number: -> { hash.last }, other_number: -> { other_hash.last }], out: [:integer, :operator] }.result }.to raise_error(TypeError).with_message("no implicit conversion of Integer into Hash")
          expect { service.collection((0..5)).minmax { |number, other_number| step compare_numbers_service, in: [number: -> { number }, other_number: -> { other_number }], out: [:integer, :operator] }.result }.to raise_error(TypeError).with_message("no implicit conversion of Integer into Hash")

          # NOTE: Error result.
          expect(service.collection(enumerable([0, -1, :exception])).minmax { |number, other_number| step compare_numbers_service, in: [number: -> { number }, other_number: -> { other_number }], out: :number_code }.result).to be_error.without_data
          expect(service.collection(enumerator([0, -1, :exception])).minmax { |number, other_number| step compare_numbers_service, in: [number: -> { number }, other_number: -> { other_number }], out: :number_code }.result).to be_error.without_data
          expect(service.collection(lazy_enumerator([0, -1, :exception])).minmax { |number, other_number| step compare_numbers_service, in: [number: -> { number }, other_number: -> { other_number }], out: :number_code }.result).to be_error.without_data
          expect(service.collection(chain_enumerator([0, -1, :exception])).minmax { |number, other_number| step compare_numbers_service, in: [number: -> { number }, other_number: -> { other_number }], out: :number_code }.result).to be_error.without_data
          expect(service.collection([0, -1, :exception]).minmax { |number, other_number| step compare_numbers_service, in: [number: -> { number }, other_number: -> { other_number }], out: :number_code }.result).to be_error.without_data
          expect(service.collection(set([0, -1, :exception])).minmax { |number, other_number| step compare_numbers_service, in: [number: -> { number }, other_number: -> { other_number }], out: :number_code }.result).to be_error.without_data

          expect(service.collection({0 => 0, -1 => -1, :exception => :exception}).minmax { |hash, other_hash| step compare_numbers_service, in: [number: -> { hash.last }, other_number: -> { other_hash.last }], out: :number_code }.result).to be_error.without_data
          expect(service.collection((-2..-1)).minmax { |number, other_number| step compare_numbers_service, in: [number: -> { number }, other_number: -> { other_number }], out: :number_code }.result).to be_error.without_data

          expect((-1..-1).minmax { raise }).to eq([-1, -1])
          expect(service.collection((-1..-1)).minmax { raise }.result).to be_success.with_data(values: [-1, -1])

          # NOTE: Error propagation.
          expect(service.collection(enumerable([:success, :error, :exception])).select { |status| step status_service, in: [status: -> { status }] }.minmax.result).to be_error.without_data
          expect(service.collection(enumerator([:success, :error, :exception])).select { |status| step status_service, in: [status: -> { status }] }.minmax.result).to be_error.without_data
          expect(service.collection(lazy_enumerator([:success, :error, :exception])).select { |status| step status_service, in: [status: -> { status }] }.minmax.result).to be_error.without_data
          expect(service.collection(chain_enumerator([:success, :error, :exception])).select { |status| step status_service, in: [status: -> { status }] }.minmax.result).to be_error.without_data
          expect(service.collection([:success, :error, :exception]).select { |status| step status_service, in: [status: -> { status }] }.minmax.result).to be_error.without_data
          expect(service.collection(set([:success, :error, :exception])).select { |status| step status_service, in: [status: -> { status }] }.minmax.result).to be_error.without_data

          expect(service.collection({success: :success, error: :error, exception: :exception}).select { |key, value| step status_service, in: [status: -> { value }] }.minmax.result).to be_error.without_data
          expect(service.collection((:error..:error)).select { |status| step status_service, in: [status: -> { status }] }.minmax.result).to be_error.without_data

          # NOTE: Usage on terminmaxal chaining.
          expect { service.collection(enumerable([:success, :exception, :exception])).first.minmax.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection(enumerator([:success, :exception, :exception])).first.minmax.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection(lazy_enumerator([:success, :exception, :exception])).first.minmax.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection(chain_enumerator([:success, :exception, :exception])).first.minmax.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection([:success, :exception, :exception]).first.minmax.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection(set([:success, :exception, :exception])).first.minmax.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)

          expect { service.collection({success: :success, exception: :exception}).first.minmax.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection((:success..:success)).first.minmax.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
        end
      end

      describe "#minmax_by" do
        specify do
          # NOTE: Empty collection.
          expect([].minmax_by { |number| number.to_s.ord }).to eq([nil, nil])
          expect(service.collection(enumerable([])).minmax_by { |number| number.to_s.ord }.result).to be_success.with_data(values: [nil, nil])
          expect(service.collection(enumerator([])).minmax_by { |number| number.to_s.ord }.result).to be_success.with_data(values: [nil, nil])
          expect(service.collection(lazy_enumerator([])).minmax_by { |number| number.to_s.ord }.result).to be_success.with_data(values: [nil, nil])
          expect(service.collection(chain_enumerator([])).minmax_by { |number| number.to_s.ord }.result).to be_success.with_data(values: [nil, nil])
          expect(service.collection([]).minmax_by { |number| number.to_s.ord }.result).to be_success.with_data(values: [nil, nil])
          expect(service.collection({}).minmax_by { |number| number.to_s.ord }.result).to be_success.with_data(values: [nil, nil])
          expect(service.collection((:success...:success)).minmax_by { |number| number.to_s.ord }.result).to be_success.with_data(values: [nil, nil])
          expect(service.collection(set([])).minmax_by { |number| number.to_s.ord }.result).to be_success.with_data(values: [nil, nil])

          # NOTE: No block.
          expect([0, 1, 2, 3, 4, 5].minmax_by.to_a).to eq([0, 1, 2, 3, 4, 5])
          expect(service.collection(enumerable([0, 1, 2, 3, 4, 5])).minmax_by.result).to be_success.with_data(values: [0, 1, 2, 3, 4, 5])
          expect(service.collection(enumerator([0, 1, 2, 3, 4, 5])).minmax_by.result).to be_success.with_data(values: [0, 1, 2, 3, 4, 5])
          expect(service.collection(lazy_enumerator([0, 1, 2, 3, 4, 5])).minmax_by.result).to be_success.with_data(values: [0, 1, 2, 3, 4, 5])
          expect(service.collection(chain_enumerator([0, 1, 2, 3, 4, 5])).minmax_by.result).to be_success.with_data(values: [0, 1, 2, 3, 4, 5])
          expect(service.collection([0, 1, 2, 3, 4, 5]).minmax_by.result).to be_success.with_data(values: [0, 1, 2, 3, 4, 5])
          expect(service.collection(set([0, 1, 2, 3, 4, 5])).minmax_by.result).to be_success.with_data(values: [0, 1, 2, 3, 4, 5])
          expect(service.collection({0 => 0, 1 => 1, 2 => 2, 3 => 3, 4 => 4, 5 => 5}).minmax_by.result).to be_success.with_data(values: [[0, 0], [1, 1], [2, 2], [3, 3], [4, 4], [5, 5]])
          expect(service.collection((0..5)).minmax_by.result).to be_success.with_data(values: [0, 1, 2, 3, 4, 5])

          # NOTE: Block.
          expect([0, 1, 2, 3, 4, 5].minmax_by { |number| number.to_s.ord }).to eq([0, 5])
          expect(service.collection(enumerable([0, 1, 2, 3, 4, 5])).minmax_by { |number| number.to_s.ord }.result).to be_success.with_data(values: [0, 5])
          expect(service.collection(enumerator([0, 1, 2, 3, 4, 5])).minmax_by { |number| number.to_s.ord }.result).to be_success.with_data(values: [0, 5])
          expect(service.collection(lazy_enumerator([0, 1, 2, 3, 4, 5])).minmax_by { |number| number.to_s.ord }.result).to be_success.with_data(values: [0, 5])
          expect(service.collection(chain_enumerator([0, 1, 2, 3, 4, 5])).minmax_by { |number| number.to_s.ord }.result).to be_success.with_data(values: [0, 5])
          expect(service.collection([0, 1, 2, 3, 4, 5]).minmax_by { |number| number.to_s.ord }.result).to be_success.with_data(values: [0, 5])
          expect(service.collection(set([0, 1, 2, 3, 4, 5])).minmax_by { |number| number.to_s.ord }.result).to be_success.with_data(values: [0, 5])

          expect(service.collection({0 => 0, 1 => 1, 2 => 2, 3 => 3, 4 => 4, 5 => 5}).minmax_by { |key, value| value.to_s.ord }.result).to be_success.with_data(values: [[0, 0], [5, 5]])
          expect(service.collection((0..5)).minmax_by { |number| number.to_s.ord }.result).to be_success.with_data(values: [0, 5])

          # NOTE: Step with no outputs.
          expect(service.collection(enumerable([0, 1, 2, 3, 4, 5])).minmax_by { |number| step number_service, in: [number: -> { number }] }.result).to be_success.with_data(values: [0, 0])
          expect(service.collection(enumerator([0, 1, 2, 3, 4, 5])).minmax_by { |number| step number_service, in: [number: -> { number }] }.result).to be_success.with_data(values: [0, 0])
          expect(service.collection(lazy_enumerator([0, 1, 2, 3, 4, 5])).minmax_by { |number| step number_service, in: [number: -> { number }] }.result).to be_success.with_data(values: [0, 0])
          expect(service.collection(chain_enumerator([0, 1, 2, 3, 4, 5])).minmax_by { |number| step number_service, in: [number: -> { number }] }.result).to be_success.with_data(values: [0, 0])
          expect(service.collection([0, 1, 2, 3, 4, 5]).minmax_by { |number| step number_service, in: [number: -> { number }] }.result).to be_success.with_data(values: [0, 0])
          expect(service.collection(set([0, 1, 2, 3, 4, 5])).minmax_by { |number| step number_service, in: [number: -> { number }] }.result).to be_success.with_data(values: [0, 0])
          expect(service.collection({0 => 0, 1 => 1, 2 => 2, 3 => 3, 4 => 4, 5 => 5}).minmax_by { |(key, value)| step number_service, in: [number: -> { value }] }.result).to be_success.with_data(values: [[0, 0], [0, 0]])
          expect(service.collection((0..5)).minmax_by { |number| step number_service, in: [number: -> { number }] }.result).to be_success.with_data(values: [0, 0])

          # NOTE: Step with one output.
          expect(service.collection(enumerable([0, 1, 2, 3, 4, 5])).minmax_by { |number| step number_service, in: [number: -> { number }], out: :number_code }.result).to be_success.with_data(values: [0, 5])
          expect(service.collection(enumerator([0, 1, 2, 3, 4, 5])).minmax_by { |number| step number_service, in: [number: -> { number }], out: :number_code }.result).to be_success.with_data(values: [0, 5])
          expect(service.collection(lazy_enumerator([0, 1, 2, 3, 4, 5])).minmax_by { |number| step number_service, in: [number: -> { number }], out: :number_code }.result).to be_success.with_data(values: [0, 5])
          expect(service.collection(chain_enumerator([0, 1, 2, 3, 4, 5])).minmax_by { |number| step number_service, in: [number: -> { number }], out: :number_code }.result).to be_success.with_data(values: [0, 5])
          expect(service.collection([0, 1, 2, 3, 4, 5]).minmax_by { |number| step number_service, in: [number: -> { number }], out: :number_code }.result).to be_success.with_data(values: [0, 5])
          expect(service.collection(set([0, 1, 2, 3, 4, 5])).minmax_by { |number| step number_service, in: [number: -> { number }], out: :number_code }.result).to be_success.with_data(values: [0, 5])

          expect(service.collection({0 => 0, 1 => 1, 2 => 2, 3 => 3, 4 => 4, 5 => 5}).minmax_by { |(key, value)| step number_service, in: [number: -> { value }], out: :number_code }.result).to be_success.with_data(values: [[0, 0], [5, 5]])
          expect(service.collection((0..5)).minmax_by { |number| step number_service, in: [number: -> { number }], out: :number_code }.result).to be_success.with_data(values: [0, 5])

          # NOTE: Step with multiple outputs.
          expect { service.collection(enumerable([0, 1, 2, 3, 4, 5])).minmax_by { |number| step number_service, in: [number: -> { number }], out: [:number_string, :number_code] }.result }.to raise_error(ArgumentError).with_message("comparison of Hash with Hash failed")
          expect { service.collection(enumerator([0, 1, 2, 3, 4, 5])).minmax_by { |number| step number_service, in: [number: -> { number }], out: [:number_string, :number_code] }.result }.to raise_error(ArgumentError).with_message("comparison of Hash with Hash failed")
          expect { service.collection(lazy_enumerator([0, 1, 2, 3, 4, 5])).minmax_by { |number| step number_service, in: [number: -> { number }], out: [:number_string, :number_code] }.result }.to raise_error(ArgumentError).with_message("comparison of Hash with Hash failed")
          expect { service.collection(chain_enumerator([0, 1, 2, 3, 4, 5])).minmax_by { |number| step number_service, in: [number: -> { number }], out: [:number_string, :number_code] }.result }.to raise_error(ArgumentError).with_message("comparison of Hash with Hash failed")
          expect { service.collection([0, 1, 2, 3, 4, 5]).minmax_by { |number| step number_service, in: [number: -> { number }], out: [:number_string, :number_code] }.result }.to raise_error(ArgumentError).with_message("comparison of Hash with Hash failed")
          expect { service.collection(set([0, 1, 2, 3, 4, 5])).minmax_by { |number| step number_service, in: [number: -> { number }], out: [:number_string, :number_code] }.result }.to raise_error(ArgumentError).with_message("comparison of Hash with Hash failed")

          expect { service.collection({0 => 0, 1 => 1, 2 => 2, 3 => 3, 4 => 4, 5 => 5}).minmax_by { |(key, value)| step number_service, in: [number: -> { value }], out: [:number_string, :number_code] }.result }.to raise_error(ArgumentError).with_message("comparison of Hash with Hash failed")
          expect { service.collection((0..5)).minmax_by { |number| step number_service, in: [number: -> { number }], out: [:number_string, :number_code] }.result }.to raise_error(ArgumentError).with_message("comparison of Hash with Hash failed")

          # NOTE: Error result.
          expect(service.collection(enumerable([0, -1, :exception])).minmax_by { |number| step number_service, in: [number: -> { number }], out: :number_code }.result).to be_error.without_data
          expect(service.collection(enumerator([0, -1, :exception])).minmax_by { |number| step number_service, in: [number: -> { number }], out: :number_code }.result).to be_error.without_data
          expect(service.collection(lazy_enumerator([0, -1, :exception])).minmax_by { |number| step number_service, in: [number: -> { number }], out: :number_code }.result).to be_error.without_data
          expect(service.collection(chain_enumerator([0, -1, :exception])).minmax_by { |number| step number_service, in: [number: -> { number }], out: :number_code }.result).to be_error.without_data
          expect(service.collection([0, -1, :exception]).minmax_by { |number| step number_service, in: [number: -> { number }], out: :number_code }.result).to be_error.without_data
          expect(service.collection(set([0, -1, :exception])).minmax_by { |number| step number_service, in: [number: -> { number }], out: :number_code }.result).to be_error.without_data

          expect(service.collection({0 => 0, -1 => -1, :exception => :exception}).minmax_by { |(key, value)| step number_service, in: [number: -> { value }], out: :number_code }.result).to be_error.without_data
          expect(service.collection((-1..-1)).minmax_by { |number| step number_service, in: [number: -> { number }], out: :number_code }.result).to be_error.without_data

          # NOTE: Error propagation.
          expect(service.collection(enumerable([:success, :error, :exception])).select { |status| step status_service, in: [status: -> { status }] }.minmax_by { |number| number.to_s.ord }.result).to be_error.without_data
          expect(service.collection(enumerator([:success, :error, :exception])).select { |status| step status_service, in: [status: -> { status }] }.minmax_by { |number| number.to_s.ord }.result).to be_error.without_data
          expect(service.collection(lazy_enumerator([:success, :error, :exception])).select { |status| step status_service, in: [status: -> { status }] }.minmax_by { |number| number.to_s.ord }.result).to be_error.without_data
          expect(service.collection(chain_enumerator([:success, :error, :exception])).select { |status| step status_service, in: [status: -> { status }] }.minmax_by { |number| number.to_s.ord }.result).to be_error.without_data
          expect(service.collection([:success, :error, :exception]).select { |status| step status_service, in: [status: -> { status }] }.minmax_by { |number| number.to_s.ord }.result).to be_error.without_data
          expect(service.collection(set([:success, :error, :exception])).select { |status| step status_service, in: [status: -> { status }] }.minmax_by { |number| number.to_s.ord }.result).to be_error.without_data

          expect(service.collection({success: :success, error: :error, exception: :exception}).select { |key, value| step status_service, in: [status: -> { value }] }.minmax_by { |number| number.to_s.ord }.result).to be_error.without_data
          expect(service.collection((:error..:error)).select { |status| step status_service, in: [status: -> { status }] }.minmax_by { |number| number.to_s.ord }.result).to be_error.without_data

          # NOTE: Usage on terminal chaining.
          expect { service.collection(enumerable([:success, :exception, :exception])).first.minmax_by { |number| number.to_s.ord }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection(enumerator([:success, :exception, :exception])).first.minmax_by { |number| number.to_s.ord }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection(lazy_enumerator([:success, :exception, :exception])).first.minmax_by { |number| number.to_s.ord }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection(chain_enumerator([:success, :exception, :exception])).first.minmax_by { |number| number.to_s.ord }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection([:success, :exception, :exception]).first.minmax_by { |number| number.to_s.ord }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection(set([:success, :exception, :exception])).first.minmax_by { |number| number.to_s.ord }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)

          expect { service.collection({success: :success, exception: :exception}).first.minmax_by { |number| number.to_s.ord }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection((:success..:success)).first.minmax_by { |number| number.to_s.ord }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
        end
      end

      describe "#none?" do
        specify do
          # NOTE: Empty collection.
          expect([].none?).to eq(true)
          expect(service.collection(enumerable([])).none?.result).to be_success.without_data
          expect(service.collection(enumerator([])).none?.result).to be_success.without_data
          expect(service.collection(lazy_enumerator([])).none?.result).to be_success.without_data
          expect(service.collection(chain_enumerator([])).none?.result).to be_success.without_data
          expect(service.collection([]).none?.result).to be_success.without_data
          expect(service.collection({}).none?.result).to be_success.without_data
          expect(service.collection((:success...:success)).none?.result).to be_success.without_data
          expect(service.collection(set([])).none?.result).to be_success.without_data

          # NOTE: No block, no pattern.
          expect([:success].none?).to eq(false)
          expect(service.collection(enumerable([:success])).none?.result).to be_failure.without_data
          expect(service.collection(enumerator([:success])).none?.result).to be_failure.without_data
          expect(service.collection(lazy_enumerator([:success])).none?.result).to be_failure.without_data
          expect(service.collection(chain_enumerator([:success])).none?.result).to be_failure.without_data
          expect(service.collection([:success]).none?.result).to be_failure.without_data
          expect(service.collection(set([:success])).none?.result).to be_failure.without_data
          expect(service.collection({success: :success}).none?.result).to be_failure.without_data
          expect(service.collection((:success..:success)).none?.result).to be_failure.without_data

          # NOTE: Matched pattern.
          expect([:failure, :success, :exception].none?(/success/)).to eq(false)
          expect(service.collection(enumerable([:failure, :success, :exception])).none?(/success/).result).to be_failure.without_data
          expect(service.collection(enumerator([:failure, :success, :exception])).none?(/success/).result).to be_failure.without_data
          expect(service.collection(lazy_enumerator([:failure, :success, :exception])).none?(/success/).result).to be_failure.without_data
          expect(service.collection(chain_enumerator([:failure, :success, :exception])).none?(/success/).result).to be_failure.without_data
          expect(service.collection([:failure, :success, :exception]).none?(/success/).result).to be_failure.without_data
          expect(service.collection(set([:failure, :success, :exception])).none?(/success/).result).to be_failure.without_data

          expect(service.collection({success: :success}).none?([:success, :success]).result).to be_failure.without_data
          expect(service.collection((:success..:success)).none?(/success/).result).to be_failure.without_data

          # NOTE: Not matched pattern.
          expect([:failure, :failure, :failure].none?(/success/)).to eq(true)
          expect(service.collection(enumerable([:failure, :failure, :failure])).none?(/success/).result).to be_success.without_data
          expect(service.collection(enumerator([:failure, :failure, :failure])).none?(/success/).result).to be_success.without_data
          expect(service.collection(lazy_enumerator([:failure, :failure, :failure])).none?(/success/).result).to be_success.without_data
          expect(service.collection(chain_enumerator([:failure, :failure, :failure])).none?(/success/).result).to be_success.without_data
          expect(service.collection([:failure, :failure, :failure]).none?(/success/).result).to be_success.without_data
          expect(service.collection(set([:failure, :failure, :failure])).none?(/success/).result).to be_success.without_data

          expect(service.collection({failure: :failure}).none?([:success, :success]).result).to be_success.without_data
          expect(service.collection((:failure..:failure)).none?(/success/).result).to be_success.without_data

          # NOTE: Matched block.
          expect([:failure, :success, :exception].none? { |status| condition[status] }).to eq(false)
          expect(service.collection(enumerable([:failure, :success, :exception])).none? { |status| condition[status] }.result).to be_failure.without_data
          expect(service.collection(enumerator([:failure, :success, :exception])).none? { |status| condition[status] }.result).to be_failure.without_data
          expect(service.collection(lazy_enumerator([:failure, :success, :exception])).none? { |status| condition[status] }.result).to be_failure.without_data
          expect(service.collection(chain_enumerator([:failure, :success, :exception])).none? { |status| condition[status] }.result).to be_failure.without_data
          expect(service.collection([:failure, :success, :exception]).none? { |status| condition[status] }.result).to be_failure.without_data
          expect(service.collection(set([:failure, :success, :exception])).none? { |status| condition[status] }.result).to be_failure.without_data

          expect(service.collection({failure: :failure, success: :success, exception: :exception}).none? { |key, value| condition[value] }.result).to be_failure.without_data
          expect(service.collection((:success..:success)).none? { |status| condition[status] }.result).to be_failure.without_data

          # NOTE: Not matched block.
          expect([:failure, :failure, :failure].none? { |status| condition[status] }).to eq(true)
          expect(service.collection(enumerable([:failure, :failure, :failure])).none? { |status| condition[status] }.result).to be_success.without_data
          expect(service.collection(enumerator([:failure, :failure, :failure])).none? { |status| condition[status] }.result).to be_success.without_data
          expect(service.collection(lazy_enumerator([:failure, :failure, :failure])).none? { |status| condition[status] }.result).to be_success.without_data
          expect(service.collection(chain_enumerator([:failure, :failure, :failure])).none? { |status| condition[status] }.result).to be_success.without_data
          expect(service.collection([:failure, :failure, :failure]).none? { |status| condition[status] }.result).to be_success.without_data
          expect(service.collection(set([:failure, :failure, :failure])).none? { |status| condition[status] }.result).to be_success.without_data

          expect(service.collection({failure: :failure}).none? { |key, value| condition[value] }.result).to be_success.without_data
          expect(service.collection((:failure..:failure)).none? { |status| condition[status] }.result).to be_success.without_data

          # NOTE: Matched step with no outputs.
          expect(service.collection(enumerable([:failure, :success, :exception])).none? { |status| step status_service, in: [status: -> { status }] }.result).to be_failure.without_data
          expect(service.collection(enumerator([:failure, :success, :exception])).none? { |status| step status_service, in: [status: -> { status }] }.result).to be_failure.without_data
          expect(service.collection(lazy_enumerator([:failure, :success, :exception])).none? { |status| step status_service, in: [status: -> { status }] }.result).to be_failure.without_data
          expect(service.collection(chain_enumerator([:failure, :success, :exception])).none? { |status| step status_service, in: [status: -> { status }] }.result).to be_failure.without_data
          expect(service.collection([:failure, :success, :exception]).none? { |status| step status_service, in: [status: -> { status }] }.result).to be_failure.without_data
          expect(service.collection(set([:failure, :success, :exception])).none? { |status| step status_service, in: [status: -> { status }] }.result).to be_failure.without_data

          expect(service.collection({failure: :failure, success: :success, exception: :exception}).none? { |key, value| step status_service, in: [status: -> { value }] }.result).to be_failure.without_data
          expect(service.collection((:success..:success)).none? { |status| step status_service, in: [status: -> { status }] }.result).to be_failure.without_data

          # NOTE: Not matched step with no outputs.
          expect(service.collection(enumerable([:failure, :failure, :failure])).none? { |status| step status_service, in: [status: -> { status }] }.result).to be_success.without_data
          expect(service.collection(enumerator([:failure, :failure, :failure])).none? { |status| step status_service, in: [status: -> { status }] }.result).to be_success.without_data
          expect(service.collection(lazy_enumerator([:failure, :failure, :failure])).none? { |status| step status_service, in: [status: -> { status }] }.result).to be_success.without_data
          expect(service.collection(chain_enumerator([:failure, :failure, :failure])).none? { |status| step status_service, in: [status: -> { status }] }.result).to be_success.without_data
          expect(service.collection([:failure, :failure, :failure]).none? { |status| step status_service, in: [status: -> { status }] }.result).to be_success.without_data
          expect(service.collection(set([:failure, :failure, :failure])).none? { |status| step status_service, in: [status: -> { status }] }.result).to be_success.without_data

          expect(service.collection({failure: :failure}).none? { |key, value| step status_service, in: [status: -> { value }] }.result).to be_success.without_data
          expect(service.collection((:failure..:failure)).none? { |status| step status_service, in: [status: -> { status }] }.result).to be_success.without_data

          # NOTE: Matched step with one output.
          expect(service.collection(enumerable([:failure, :success, :exception])).none? { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_failure.without_data
          expect(service.collection(enumerator([:failure, :success, :exception])).none? { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_failure.without_data
          expect(service.collection(lazy_enumerator([:failure, :success, :exception])).none? { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_failure.without_data
          expect(service.collection(chain_enumerator([:failure, :success, :exception])).none? { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_failure.without_data
          expect(service.collection([:failure, :success, :exception]).none? { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_failure.without_data
          expect(service.collection(set([:failure, :success, :exception])).none? { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_failure.without_data

          expect(service.collection({failure: :failure, success: :success, exception: :exception}).none? { |key, value| step status_service, in: [status: -> { value }], out: :status_string }.result).to be_failure.without_data
          expect(service.collection((:success..:success)).none? { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_failure.without_data

          # NOTE: Not matched step with one output.
          expect(service.collection(enumerable([:failure, :failure, :failure])).none? { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.without_data
          expect(service.collection(enumerator([:failure, :failure, :failure])).none? { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.without_data
          expect(service.collection(lazy_enumerator([:failure, :failure, :failure])).none? { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.without_data
          expect(service.collection(chain_enumerator([:failure, :failure, :failure])).none? { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.without_data
          expect(service.collection([:failure, :failure, :failure]).none? { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.without_data
          expect(service.collection(set([:failure, :failure, :failure])).none? { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.without_data

          expect(service.collection({failure: :failure}).none? { |key, value| step status_service, in: [status: -> { value }], out: :status_string }.result).to be_success.without_data
          expect(service.collection((:failure..:failure)).none? { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.without_data

          # NOTE: Matched step with multiple outputs.
          expect(service.collection(enumerable([:failure, :success, :exception])).none? { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_failure.without_data
          expect(service.collection(enumerator([:failure, :success, :exception])).none? { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_failure.without_data
          expect(service.collection(lazy_enumerator([:failure, :success, :exception])).none? { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_failure.without_data
          expect(service.collection(chain_enumerator([:failure, :success, :exception])).none? { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_failure.without_data
          expect(service.collection([:failure, :success, :exception]).none? { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_failure.without_data
          expect(service.collection(set([:failure, :success, :exception])).none? { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_failure.without_data

          expect(service.collection({failure: :failure, success: :success, exception: :exception}).none? { |key, value| step status_service, in: [status: -> { value }], out: [:status_string, :status_code] }.result).to be_failure.without_data
          expect(service.collection((:success..:success)).none? { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_failure.without_data

          # NOTE: Not matched step with multiple outputs.
          expect(service.collection(enumerable([:failure, :failure, :failure])).none? { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.without_data
          expect(service.collection(enumerator([:failure, :failure, :failure])).none? { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.without_data
          expect(service.collection(lazy_enumerator([:failure, :failure, :failure])).none? { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.without_data
          expect(service.collection(chain_enumerator([:failure, :failure, :failure])).none? { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.without_data
          expect(service.collection([:failure, :failure, :failure]).none? { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.without_data
          expect(service.collection(set([:failure, :failure, :failure])).none? { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.without_data

          expect(service.collection({failure: :failure}).none? { |key, value| step status_service, in: [status: -> { value }], out: [:status_string, :status_code] }.result).to be_success.without_data
          expect(service.collection((:failure..:failure)).none? { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.without_data

          # NOTE: Error result.
          expect(service.collection(enumerable([:failure, :error, :exception])).none? { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection(enumerator([:failure, :error, :exception])).none? { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection(lazy_enumerator([:failure, :error, :exception])).none? { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection(chain_enumerator([:failure, :error, :exception])).none? { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection([:failure, :error, :exception]).none? { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection(set([:failure, :error, :exception])).none? { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data

          expect(service.collection({failure: :failure, error: :error, exception: :exception}).none? { |key, value| step status_service, in: [status: -> { value }] }.result).to be_error.without_data
          expect(service.collection((:error..:error)).none? { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data

          # NOTE: Error propagation.
          expect(service.collection(enumerable([:failure, :error, :exception])).select { |status| step status_service, in: [status: -> { status }] }.none?.result).to be_error.without_data
          expect(service.collection(enumerator([:failure, :error, :exception])).select { |status| step status_service, in: [status: -> { status }] }.none?.result).to be_error.without_data
          expect(service.collection(lazy_enumerator([:failure, :error, :exception])).select { |status| step status_service, in: [status: -> { status }] }.none?.result).to be_error.without_data
          expect(service.collection(chain_enumerator([:failure, :error, :exception])).select { |status| step status_service, in: [status: -> { status }] }.none?.result).to be_error.without_data
          expect(service.collection([:failure, :error, :exception]).select { |status| step status_service, in: [status: -> { status }] }.none?.result).to be_error.without_data
          expect(service.collection(set([:failure, :error, :exception])).select { |status| step status_service, in: [status: -> { status }] }.none?.result).to be_error.without_data

          expect(service.collection({failure: :failure, error: :error, exception: :exception}).select { |key, value| step status_service, in: [status: -> { value }] }.none?.result).to be_error.without_data
          expect(service.collection((:error..:error)).select { |status| step status_service, in: [status: -> { status }] }.none?.result).to be_error.without_data

          # NOTE: Usage on terminal chaining.
          expect { service.collection(enumerable([:success, :exception, :exception])).first.none?.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection(enumerator([:success, :exception, :exception])).first.none?.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection(lazy_enumerator([:success, :exception, :exception])).first.none?.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection(chain_enumerator([:success, :exception, :exception])).first.none?.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection([:success, :exception, :exception]).first.none?.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection(set([:success, :exception, :exception])).first.none?.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)

          expect { service.collection({success: :success, exception: :exception}).first.none?.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection((:success..:success)).first.none?.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
        end
      end

      describe "#one?" do
        specify do
          # NOTE: Empty collection.
          expect([].one?).to eq(false)
          expect(service.collection(enumerable([])).one?.result).to be_failure.without_data
          expect(service.collection(enumerator([])).one?.result).to be_failure.without_data
          expect(service.collection(lazy_enumerator([])).one?.result).to be_failure.without_data
          expect(service.collection(chain_enumerator([])).one?.result).to be_failure.without_data
          expect(service.collection([]).one?.result).to be_failure.without_data
          expect(service.collection({}).one?.result).to be_failure.without_data
          expect(service.collection((:success...:success)).one?.result).to be_failure.without_data
          expect(service.collection(set([])).one?.result).to be_failure.without_data

          # NOTE: No block, no pattern.
          expect([:success].one?).to eq(true)
          expect(service.collection(enumerable([:success])).one?.result).to be_success.without_data
          expect(service.collection(enumerator([:success])).one?.result).to be_success.without_data
          expect(service.collection(lazy_enumerator([:success])).one?.result).to be_success.without_data
          expect(service.collection(chain_enumerator([:success])).one?.result).to be_success.without_data
          expect(service.collection([:success]).one?.result).to be_success.without_data
          expect(service.collection(set([:success])).one?.result).to be_success.without_data
          expect(service.collection({success: :success}).one?.result).to be_success.without_data
          expect(service.collection((:success..:success)).one?.result).to be_success.without_data

          # NOTE: Matched pattern.
          expect([:failure, :success, :failure].one?(/success/)).to eq(true)
          expect(service.collection(enumerable([:failure, :success, :failure])).one?(/success/).result).to be_success.without_data
          expect(service.collection(enumerator([:failure, :success, :failure])).one?(/success/).result).to be_success.without_data
          expect(service.collection(lazy_enumerator([:failure, :success, :failure])).one?(/success/).result).to be_success.without_data
          expect(service.collection(chain_enumerator([:failure, :success, :failure])).one?(/success/).result).to be_success.without_data
          expect(service.collection([:failure, :success, :failure]).one?(/success/).result).to be_success.without_data
          expect(service.collection(set([:failure, :success, :failure])).one?(/success/).result).to be_success.without_data

          expect(service.collection({success: :success}).one?([:success, :success]).result).to be_success.without_data
          expect(service.collection((:success..:success)).one?(/success/).result).to be_success.without_data

          # NOTE: Not matched pattern.
          expect([:success, :success, :exception].one?(/success/)).to eq(false)
          expect(service.collection(enumerable([:success, :success, :exception])).one?(/success/).result).to be_failure.without_data
          expect(service.collection(enumerator([:success, :success, :exception])).one?(/success/).result).to be_failure.without_data
          expect(service.collection(lazy_enumerator([:success, :success, :exception])).one?(/success/).result).to be_failure.without_data
          expect(service.collection(chain_enumerator([:success, :success, :exception])).one?(/success/).result).to be_failure.without_data
          expect(service.collection([:success, :success, :exception]).one?(/success/).result).to be_failure.without_data
          expect(service.collection(set([:failure])).one?(/success/).result).to be_failure.without_data

          expect(service.collection({failure: :failure}).one?([:success, :success]).result).to be_failure.without_data
          expect(service.collection((:failure..:failure)).one?(/success/).result).to be_failure.without_data

          # NOTE: Matched block.
          expect([:failure, :success, :failure].one? { |status| condition[status] }).to eq(true)
          expect(service.collection(enumerable([:failure, :success, :failure])).one? { |status| condition[status] }.result).to be_success.without_data
          expect(service.collection(enumerator([:failure, :success, :failure])).one? { |status| condition[status] }.result).to be_success.without_data
          expect(service.collection(lazy_enumerator([:failure, :success, :failure])).one? { |status| condition[status] }.result).to be_success.without_data
          expect(service.collection(chain_enumerator([:failure, :success, :failure])).one? { |status| condition[status] }.result).to be_success.without_data
          expect(service.collection([:failure, :success, :failure]).one? { |status| condition[status] }.result).to be_success.without_data
          expect(service.collection(set([:failure, :success, :failure])).one? { |status| condition[status] }.result).to be_success.without_data

          expect(service.collection({failure: :failure, success: :success}).one? { |key, value| condition[value] }.result).to be_success.without_data
          expect(service.collection((:success..:success)).one? { |status| condition[status] }.result).to be_success.without_data

          # NOTE: Not matched block.
          expect([:success, :success, :exception].one? { |status| condition[status] }).to eq(false)
          expect(service.collection(enumerable([:success, :success, :exception])).one? { |status| condition[status] }.result).to be_failure.without_data
          expect(service.collection(enumerator([:success, :success, :exception])).one? { |status| condition[status] }.result).to be_failure.without_data
          expect(service.collection(lazy_enumerator([:success, :success, :exception])).one? { |status| condition[status] }.result).to be_failure.without_data
          expect(service.collection(chain_enumerator([:success, :success, :exception])).one? { |status| condition[status] }.result).to be_failure.without_data
          expect(service.collection([:success, :success, :exception]).one? { |status| condition[status] }.result).to be_failure.without_data
          expect(service.collection(set([:failure])).one? { |status| condition[status] }.result).to be_failure.without_data

          expect(service.collection({failure: :failure}).one? { |key, value| condition[value] }.result).to be_failure.without_data
          expect(service.collection((:failure..:failure)).one? { |status| condition[status] }.result).to be_failure.without_data

          # NOTE: Matched step with no outputs.
          expect(service.collection(enumerable([:failure, :success, :failure])).one? { |status| step status_service, in: [status: -> { status }] }.result).to be_success.without_data
          expect(service.collection(enumerator([:failure, :success, :failure])).one? { |status| step status_service, in: [status: -> { status }] }.result).to be_success.without_data
          expect(service.collection(lazy_enumerator([:failure, :success, :failure])).one? { |status| step status_service, in: [status: -> { status }] }.result).to be_success.without_data
          expect(service.collection(chain_enumerator([:failure, :success, :failure])).one? { |status| step status_service, in: [status: -> { status }] }.result).to be_success.without_data
          expect(service.collection([:failure, :success, :failure]).one? { |status| step status_service, in: [status: -> { status }] }.result).to be_success.without_data
          expect(service.collection(set([:failure, :success, :failure])).one? { |status| step status_service, in: [status: -> { status }] }.result).to be_success.without_data

          expect(service.collection({failure: :failure, success: :success}).one? { |key, value| step status_service, in: [status: -> { value }] }.result).to be_success.without_data
          expect(service.collection((:success..:success)).one? { |status| step status_service, in: [status: -> { status }] }.result).to be_success.without_data

          # NOTE: Not matched step with no outputs.
          expect(service.collection(enumerable([:success, :success, :exception])).one? { |status| step status_service, in: [status: -> { status }] }.result).to be_failure.without_data
          expect(service.collection(enumerator([:success, :success, :exception])).one? { |status| step status_service, in: [status: -> { status }] }.result).to be_failure.without_data
          expect(service.collection(lazy_enumerator([:success, :success, :exception])).one? { |status| step status_service, in: [status: -> { status }] }.result).to be_failure.without_data
          expect(service.collection(chain_enumerator([:success, :success, :exception])).one? { |status| step status_service, in: [status: -> { status }] }.result).to be_failure.without_data
          expect(service.collection([:success, :success, :exception]).one? { |status| step status_service, in: [status: -> { status }] }.result).to be_failure.without_data
          expect(service.collection(set([:failure])).one? { |status| step status_service, in: [status: -> { status }] }.result).to be_failure.without_data

          expect(service.collection({failure: :failure}).one? { |key, value| step status_service, in: [status: -> { value }] }.result).to be_failure.without_data
          expect(service.collection((:failure..:failure)).one? { |status| step status_service, in: [status: -> { status }] }.result).to be_failure.without_data

          # NOTE: Matched step with one output.
          expect(service.collection(enumerable([:failure, :success, :failure])).one? { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.without_data
          expect(service.collection(enumerator([:failure, :success, :failure])).one? { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.without_data
          expect(service.collection(lazy_enumerator([:failure, :success, :failure])).one? { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.without_data
          expect(service.collection(chain_enumerator([:failure, :success, :failure])).one? { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.without_data
          expect(service.collection([:failure, :success, :failure]).one? { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.without_data
          expect(service.collection(set([:failure, :success, :failure])).one? { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.without_data

          expect(service.collection({failure: :failure, success: :success}).one? { |key, value| step status_service, in: [status: -> { value }], out: :status_string }.result).to be_success.without_data
          expect(service.collection((:success..:success)).one? { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.without_data

          # NOTE: Not matched step with one output.
          expect(service.collection(enumerable([:success, :success, :exception])).one? { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_failure.without_data
          expect(service.collection(enumerator([:success, :success, :exception])).one? { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_failure.without_data
          expect(service.collection(lazy_enumerator([:success, :success, :exception])).one? { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_failure.without_data
          expect(service.collection(chain_enumerator([:success, :success, :exception])).one? { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_failure.without_data
          expect(service.collection([:success, :success, :exception]).one? { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_failure.without_data
          expect(service.collection(set([:failure])).one? { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_failure.without_data

          expect(service.collection({failure: :failure}).one? { |key, value| step status_service, in: [status: -> { value }], out: :status_string }.result).to be_failure.without_data
          expect(service.collection((:failure..:failure)).one? { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_failure.without_data

          # NOTE: Matched step with multiple outputs.
          expect(service.collection(enumerable([:failure, :success, :failure])).one? { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.without_data
          expect(service.collection(enumerator([:failure, :success, :failure])).one? { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.without_data
          expect(service.collection(lazy_enumerator([:failure, :success, :failure])).one? { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.without_data
          expect(service.collection(chain_enumerator([:failure, :success, :failure])).one? { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.without_data
          expect(service.collection([:failure, :success, :failure]).one? { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.without_data
          expect(service.collection(set([:failure, :success, :failure])).one? { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.without_data

          expect(service.collection({failure: :failure, success: :success}).one? { |key, value| step status_service, in: [status: -> { value }], out: [:status_string, :status_code] }.result).to be_success.without_data
          expect(service.collection((:success..:success)).one? { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.without_data

          # NOTE: Not matched step with multiple outputs.
          expect(service.collection(enumerable([:success, :success, :exception])).one? { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_failure.without_data
          expect(service.collection(enumerator([:success, :success, :exception])).one? { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_failure.without_data
          expect(service.collection(lazy_enumerator([:success, :success, :exception])).one? { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_failure.without_data
          expect(service.collection(chain_enumerator([:success, :success, :exception])).one? { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_failure.without_data
          expect(service.collection([:success, :success, :exception]).one? { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_failure.without_data
          expect(service.collection(set([:failure])).one? { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_failure.without_data

          expect(service.collection({failure: :failure}).one? { |key, value| step status_service, in: [status: -> { value }], out: [:status_string, :status_code] }.result).to be_failure.without_data
          expect(service.collection((:failure..:failure)).one? { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_failure.without_data

          # NOTE: Error result.
          expect(service.collection(enumerable([:failure, :error, :exception])).one? { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection(enumerator([:failure, :error, :exception])).one? { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection(lazy_enumerator([:failure, :error, :exception])).one? { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection(chain_enumerator([:failure, :error, :exception])).one? { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection([:failure, :error, :exception]).one? { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection(set([:failure, :error, :exception])).one? { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data

          expect(service.collection({failure: :failure, error: :error, exception: :exception}).one? { |key, value| step status_service, in: [status: -> { value }] }.result).to be_error.without_data
          expect(service.collection((:error..:error)).one? { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data

          # NOTE: Error propagation.
          expect(service.collection(enumerable([:failure, :error, :exception])).select { |status| step status_service, in: [status: -> { status }] }.one?.result).to be_error.without_data
          expect(service.collection(enumerator([:failure, :error, :exception])).select { |status| step status_service, in: [status: -> { status }] }.one?.result).to be_error.without_data
          expect(service.collection(lazy_enumerator([:failure, :error, :exception])).select { |status| step status_service, in: [status: -> { status }] }.one?.result).to be_error.without_data
          expect(service.collection(chain_enumerator([:failure, :error, :exception])).select { |status| step status_service, in: [status: -> { status }] }.one?.result).to be_error.without_data
          expect(service.collection([:failure, :error, :exception]).select { |status| step status_service, in: [status: -> { status }] }.one?.result).to be_error.without_data
          expect(service.collection(set([:failure, :error, :exception])).select { |status| step status_service, in: [status: -> { status }] }.one?.result).to be_error.without_data

          expect(service.collection({failure: :failure, error: :error, exception: :exception}).select { |key, value| step status_service, in: [status: -> { value }] }.one?.result).to be_error.without_data
          expect(service.collection((:error..:error)).select { |status| step status_service, in: [status: -> { status }] }.one?.result).to be_error.without_data

          # NOTE: Usage on terminal chaining.
          expect { service.collection(enumerable([:success, :exception, :exception])).first.one?.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection(enumerator([:success, :exception, :exception])).first.one?.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection(lazy_enumerator([:success, :exception, :exception])).first.one?.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection(chain_enumerator([:success, :exception, :exception])).first.one?.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection([:success, :exception, :exception]).first.one?.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection(set([:success, :exception, :exception])).first.one?.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)

          expect { service.collection({success: :success, exception: :exception}).first.one?.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection((:success..:success)).first.one?.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
        end
      end

      describe "#partition" do
        specify do
          # NOTE: Empty collection.
          expect([].partition { |status| condition[status] }).to eq([[], []])
          expect(service.collection(enumerable([])).partition { |status| condition[status] }.result).to be_success.with_data(values: [[], []])
          expect(service.collection(enumerator([])).partition { |status| condition[status] }.result).to be_success.with_data(values: [[], []])
          expect(service.collection(lazy_enumerator([])).partition { |status| condition[status] }.result).to be_success.with_data(values: [[], []])
          expect(service.collection(chain_enumerator([])).partition { |status| condition[status] }.result).to be_success.with_data(values: [[], []])
          expect(service.collection([]).partition { |status| condition[status] }.result).to be_success.with_data(values: [[], []])
          expect(service.collection(set([])).partition { |status| condition[status] }.result).to be_success.with_data(values: [[], []])
          expect(service.collection({}).partition { |status| condition[status] }.result).to be_success.with_data(values: [[], []])
          expect(service.collection((:success...:success)).partition { |status| condition[status] }.result).to be_success.with_data(values: [[], []])

          # NOTE: No block.
          expect([:success, :failure, :success, :failure].partition.to_a).to eq([:success, :failure, :success, :failure])
          expect(service.collection(enumerable([:success, :failure, :success, :failure])).partition.result).to be_success.with_data(values: [:success, :failure, :success, :failure])
          expect(service.collection(enumerator([:success, :failure, :success, :failure])).partition.result).to be_success.with_data(values: [:success, :failure, :success, :failure])
          expect(service.collection(lazy_enumerator([:success, :failure, :success, :failure])).partition.result).to be_success.with_data(values: [:success, :failure, :success, :failure])
          expect(service.collection(chain_enumerator([:success, :failure, :success, :failure])).partition.result).to be_success.with_data(values: [:success, :failure, :success, :failure])
          expect(service.collection([:success, :failure, :success, :failure]).partition.result).to be_success.with_data(values: [:success, :failure, :success, :failure])

          # NOTE: Block.
          expect([:success, :failure, :success, :failure].partition { |status| condition[status] }).to eq([[:success, :success], [:failure, :failure]])
          expect(service.collection(enumerable([:success, :failure, :success, :failure])).partition { |status| condition[status] }.result).to be_success.with_data(values: [[:success, :success], [:failure, :failure]])
          expect(service.collection(enumerator([:success, :failure, :success, :failure])).partition { |status| condition[status] }.result).to be_success.with_data(values: [[:success, :success], [:failure, :failure]])
          expect(service.collection(lazy_enumerator([:success, :failure, :success, :failure])).partition { |status| condition[status] }.result).to be_success.with_data(values: [[:success, :success], [:failure, :failure]])
          expect(service.collection(chain_enumerator([:success, :failure, :success, :failure])).partition { |status| condition[status] }.result).to be_success.with_data(values: [[:success, :success], [:failure, :failure]])
          expect(service.collection([:success, :failure, :success, :failure]).partition { |status| condition[status] }.result).to be_success.with_data(values: [[:success, :success], [:failure, :failure]])

          expect(service.collection(set([:success, :failure])).partition { |status| condition[status] }.result).to be_success.with_data(values: [[:success], [:failure]])
          expect(service.collection({success: :success, failure: :failure}).partition { |key, value| condition[value] }.result).to be_success.with_data(values: [[[:success, :success]], [[:failure, :failure]]])
          expect(service.collection((:success..:success)).partition { |status| condition[status] }.result).to be_success.with_data(values: [[:success], []])
          expect(service.collection((:failure..:failure)).partition { |status| condition[status] }.result).to be_success.with_data(values: [[], [:failure]])

          # NOTE: Step with no outputs.
          expect(service.collection(enumerable([:success, :failure, :success, :failure])).partition { |status| step status_service, in: [status: -> { status }] }.result).to be_success.with_data(values: [[:success, :success], [:failure, :failure]])
          expect(service.collection(enumerator([:success, :failure, :success, :failure])).partition { |status| step status_service, in: [status: -> { status }] }.result).to be_success.with_data(values: [[:success, :success], [:failure, :failure]])
          expect(service.collection(lazy_enumerator([:success, :failure, :success, :failure])).partition { |status| step status_service, in: [status: -> { status }] }.result).to be_success.with_data(values: [[:success, :success], [:failure, :failure]])
          expect(service.collection(chain_enumerator([:success, :failure, :success, :failure])).partition { |status| step status_service, in: [status: -> { status }] }.result).to be_success.with_data(values: [[:success, :success], [:failure, :failure]])
          expect(service.collection([:success, :failure, :success, :failure]).partition { |status| step status_service, in: [status: -> { status }] }.result).to be_success.with_data(values: [[:success, :success], [:failure, :failure]])

          expect(service.collection(set([:success, :failure])).partition { |status| step status_service, in: [status: -> { status }] }.result).to be_success.with_data(values: [[:success], [:failure]])
          expect(service.collection({success: :success, failure: :failure}).partition { |key, value| step status_service, in: [status: -> { value }] }.result).to be_success.with_data(values: [[[:success, :success]], [[:failure, :failure]]])
          expect(service.collection((:success..:success)).partition { |status| step status_service, in: [status: -> { status }] }.result).to be_success.with_data(values: [[:success], []])
          expect(service.collection((:failure..:failure)).partition { |status| step status_service, in: [status: -> { status }] }.result).to be_success.with_data(values: [[], [:failure]])

          # NOTE: Step with one output.
          expect(service.collection(enumerable([:success, :failure, :success, :failure])).partition { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(values: [[:success, :success], [:failure, :failure]])
          expect(service.collection(enumerator([:success, :failure, :success, :failure])).partition { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(values: [[:success, :success], [:failure, :failure]])
          expect(service.collection(lazy_enumerator([:success, :failure, :success, :failure])).partition { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(values: [[:success, :success], [:failure, :failure]])
          expect(service.collection(chain_enumerator([:success, :failure, :success, :failure])).partition { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(values: [[:success, :success], [:failure, :failure]])
          expect(service.collection([:success, :failure, :success, :failure]).partition { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(values: [[:success, :success], [:failure, :failure]])

          expect(service.collection(set([:success, :failure])).partition { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(values: [[:success], [:failure]])
          expect(service.collection({success: :success, failure: :failure}).partition { |key, value| step status_service, in: [status: -> { value }], out: :status_string }.result).to be_success.with_data(values: [[[:success, :success]], [[:failure, :failure]]])
          expect(service.collection((:success..:success)).partition { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(values: [[:success], []])
          expect(service.collection((:failure..:failure)).partition { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(values: [[], [:failure]])

          # NOTE: Step with multiple outputs.
          expect(service.collection(enumerable([:success, :failure, :success, :failure])).partition { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [[:success, :success], [:failure, :failure]])
          expect(service.collection(enumerator([:success, :failure, :success, :failure])).partition { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [[:success, :success], [:failure, :failure]])
          expect(service.collection(lazy_enumerator([:success, :failure, :success, :failure])).partition { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [[:success, :success], [:failure, :failure]])
          expect(service.collection(chain_enumerator([:success, :failure, :success, :failure])).partition { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [[:success, :success], [:failure, :failure]])
          expect(service.collection([:success, :failure, :success, :failure]).partition { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [[:success, :success], [:failure, :failure]])

          expect(service.collection(set([:success, :failure])).partition { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [[:success], [:failure]])
          expect(service.collection({success: :success, failure: :failure}).partition { |key, value| step status_service, in: [status: -> { value }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [[[:success, :success]], [[:failure, :failure]]])
          expect(service.collection((:success..:success)).partition { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [[:success], []])
          expect(service.collection((:failure..:failure)).partition { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [[], [:failure]])

          # NOTE: Error result.
          expect(service.collection(enumerable([:success, :error, :exception])).partition { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection(enumerator([:success, :error, :exception])).partition { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection(lazy_enumerator([:success, :error, :exception])).partition { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection(chain_enumerator([:success, :error, :exception])).partition { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection([:success, :error, :exception]).partition { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data

          expect(service.collection(set([:success, :error, :exception])).partition { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection({success: :success, error: :error, exception: :exception}).partition { |key, value| step status_service, in: [status: -> { value }] }.result).to be_error.without_data
          expect(service.collection((:error..:error)).partition { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data

          # NOTE: Error propagation.
          expect(service.collection(enumerable([:success, :error, :exception])).filter { |status| step status_service, in: [status: -> { status }] }.partition { |status| condition[status] }.result).to be_error.without_data
          expect(service.collection(enumerator([:success, :error, :exception])).filter { |status| step status_service, in: [status: -> { status }] }.partition { |status| condition[status] }.result).to be_error.without_data
          expect(service.collection(lazy_enumerator([:success, :error, :exception])).filter { |status| step status_service, in: [status: -> { status }] }.partition { |status| condition[status] }.result).to be_error.without_data
          expect(service.collection(chain_enumerator([:success, :error, :exception])).filter { |status| step status_service, in: [status: -> { status }] }.partition { |status| condition[status] }.result).to be_error.without_data
          expect(service.collection([:success, :error, :exception]).filter { |status| step status_service, in: [status: -> { status }] }.partition { |status| condition[status] }.result).to be_error.without_data

          expect(service.collection(set([:success, :error, :exception])).filter { |status| step status_service, in: [status: -> { status }] }.partition { |status| condition[status] }.result).to be_error.without_data
          expect(service.collection({success: :success, error: :error, exception: :exception}).filter { |key, value| step status_service, in: [status: -> { value }] }.partition { |key, value| condition[value] }.result).to be_error.without_data
          expect(service.collection((:error..:error)).filter { |status| step status_service, in: [status: -> { status }] }.partition { |status| condition[status] }.result).to be_error.without_data

          # NOTE: Usage on terminal chaining.
          expect { service.collection(enumerable([:success, :exception, :exception])).first.partition { |status| condition[status] }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection(enumerator([:success, :exception, :exception])).first.partition { |status| condition[status] }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection(lazy_enumerator([:success, :exception, :exception])).first.partition { |status| condition[status] }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection(chain_enumerator([:success, :exception, :exception])).first.partition { |status| condition[status] }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection([:success, :exception, :exception]).first.partition { |status| condition[status] }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)

          expect { service.collection(set([:success, :exception, :exception])).first.partition { |status| condition[status] }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection({success: :success, exception: :exception}).first.partition { |key, value| condition[value] }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection((:success..:success)).first.partition { |status| condition[status] }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
        end
      end

      describe "#reduce" do
        specify do
          # NOTE: Empty collection.
          expect([].reduce(0) { |memo, number| memo + number }).to eq(0)
          expect(service.collection(enumerable([])).reduce(0) { |memo, number| memo + number }.result).to be_success.with_data(value: 0)
          expect(service.collection(enumerator([])).reduce(0) { |memo, number| memo + number }.result).to be_success.with_data(value: 0)
          expect(service.collection(lazy_enumerator([])).reduce(0) { |memo, number| memo + number }.result).to be_success.with_data(value: 0)
          expect(service.collection(chain_enumerator([])).reduce(0) { |memo, number| memo + number }.result).to be_success.with_data(value: 0)
          expect(service.collection([]).reduce(0) { |memo, number| memo + number }.result).to be_success.with_data(value: 0)
          expect(service.collection(set([])).reduce(0) { |memo, number| memo + number }.result).to be_success.with_data(value: 0)
          expect(service.collection({}).reduce(0) { |memo, number| memo + number }.result).to be_success.with_data(value: 0)
          expect(service.collection((:success...:success)).reduce(0) { |memo, number| memo + number }.result).to be_success.with_data(value: 0)

          # NOTE: No initial, no sym, no block.
          expect { [0, 1, 2, 3, 4, 5].reduce }.to raise_error(ArgumentError).with_message("wrong number of arguments (given 0, expected 1..2)")
          expect { service.collection(enumerable([0, 1, 2, 3, 4, 5])).reduce.result }.to raise_error(ArgumentError).with_message("wrong number of arguments (given 0, expected 1..2)")
          expect { service.collection(enumerator([0, 1, 2, 3, 4, 5])).reduce.result }.to raise_error(ArgumentError).with_message("wrong number of arguments (given 0, expected 1..2)")
          expect { service.collection(lazy_enumerator([0, 1, 2, 3, 4, 5])).reduce.result }.to raise_error(ArgumentError).with_message("wrong number of arguments (given 0, expected 1..2)")
          expect { service.collection(chain_enumerator([0, 1, 2, 3, 4, 5])).reduce.result }.to raise_error(ArgumentError).with_message("wrong number of arguments (given 0, expected 1..2)")
          expect { service.collection([0, 1, 2, 3, 4, 5]).reduce.result }.to raise_error(ArgumentError).with_message("wrong number of arguments (given 0, expected 1..2)")

          expect { service.collection(set([0, 1, 2, 3, 4, 5])).reduce.result }.to raise_error(ArgumentError).with_message("wrong number of arguments (given 0, expected 1..2)")
          expect { service.collection({0 => 0, 1 => 1, 2 => 2, 3 => 3, 4 => 4, 5 => 5}).reduce.result }.to raise_error(ArgumentError).with_message("wrong number of arguments (given 0, expected 1..2)")
          expect { service.collection((0..5)).reduce.result }.to raise_error(ArgumentError).with_message("wrong number of arguments (given 0, expected 1..2)")

          # NOTE: Sym.
          expect([0, 1, 2, 3, 4, 5].reduce(:+)).to eq(15)
          expect(service.collection(enumerable([0, 1, 2, 3, 4, 5])).reduce(:+).result).to be_success.with_data(value: 15)
          expect(service.collection(enumerator([0, 1, 2, 3, 4, 5])).reduce(:+).result).to be_success.with_data(value: 15)
          expect(service.collection(lazy_enumerator([0, 1, 2, 3, 4, 5])).reduce(:+).result).to be_success.with_data(value: 15)
          expect(service.collection(chain_enumerator([0, 1, 2, 3, 4, 5])).reduce(:+).result).to be_success.with_data(value: 15)
          expect(service.collection([0, 1, 2, 3, 4, 5]).reduce(:+).result).to be_success.with_data(value: 15)

          expect(service.collection(set([0, 1, 2, 3, 4, 5])).reduce(:+).result).to be_success.with_data(value: 15)
          expect({0 => 0, 1 => 1, 2 => 2, 3 => 3, 4 => 4, 5 => 5}.reduce(:+)).to eq([0, 0, 1, 1, 2, 2, 3, 3, 4, 4, 5, 5])
          expect(service.collection({0 => 0, 1 => 1, 2 => 2, 3 => 3, 4 => 4, 5 => 5}).reduce(:+).result).to be_success.with_data(value: [0, 0, 1, 1, 2, 2, 3, 3, 4, 4, 5, 5])
          expect(service.collection((0..5)).reduce(:+).result).to be_success.with_data(value: 15)

          # NOTE: Initial, sym.
          expect([0, 1, 2, 3, 4, 5].reduce(10, :+)).to eq(25)
          expect(service.collection(enumerable([0, 1, 2, 3, 4, 5])).reduce(10, :+).result).to be_success.with_data(value: 25)
          expect(service.collection(enumerator([0, 1, 2, 3, 4, 5])).reduce(10, :+).result).to be_success.with_data(value: 25)
          expect(service.collection(lazy_enumerator([0, 1, 2, 3, 4, 5])).reduce(10, :+).result).to be_success.with_data(value: 25)
          expect(service.collection(chain_enumerator([0, 1, 2, 3, 4, 5])).reduce(10, :+).result).to be_success.with_data(value: 25)
          expect(service.collection([0, 1, 2, 3, 4, 5]).reduce(10, :+).result).to be_success.with_data(value: 25)

          expect(service.collection(set([0, 1, 2, 3, 4, 5])).reduce(10, :+).result).to be_success.with_data(value: 25)
          expect({0 => 0, 1 => 1, 2 => 2, 3 => 3, 4 => 4, 5 => 5}.reduce([10, 10], :+)).to eq([10, 10, 0, 0, 1, 1, 2, 2, 3, 3, 4, 4, 5, 5])
          expect(service.collection({0 => 0, 1 => 1, 2 => 2, 3 => 3, 4 => 4, 5 => 5}).reduce([10, 10], :+).result).to be_success.with_data(value: [10, 10, 0, 0, 1, 1, 2, 2, 3, 3, 4, 4, 5, 5])
          expect(service.collection((0..5)).reduce(10, :+).result).to be_success.with_data(value: 25)

          # NOTE: Block.
          expect([0, 1, 2, 3, 4, 5].reduce { |memo, number| memo + number }).to eq(15)
          expect(service.collection(enumerable([0, 1, 2, 3, 4, 5])).reduce { |memo, number| memo + number }.result).to be_success.with_data(value: 15)
          expect(service.collection(enumerator([0, 1, 2, 3, 4, 5])).reduce { |memo, number| memo + number }.result).to be_success.with_data(value: 15)
          expect(service.collection(lazy_enumerator([0, 1, 2, 3, 4, 5])).reduce { |memo, number| memo + number }.result).to be_success.with_data(value: 15)
          expect(service.collection(chain_enumerator([0, 1, 2, 3, 4, 5])).reduce { |memo, number| memo + number }.result).to be_success.with_data(value: 15)
          expect(service.collection([0, 1, 2, 3, 4, 5]).reduce { |memo, number| memo + number }.result).to be_success.with_data(value: 15)

          expect(service.collection(set([0, 1, 2, 3, 4, 5])).reduce { |memo, number| memo + number }.result).to be_success.with_data(value: 15)
          expect({0 => 0, 1 => 1, 2 => 2, 3 => 3, 4 => 4, 5 => 5}.reduce { |memo, number| memo + number }).to eq([0, 0, 1, 1, 2, 2, 3, 3, 4, 4, 5, 5])
          expect(service.collection({0 => 0, 1 => 1, 2 => 2, 3 => 3, 4 => 4, 5 => 5}).reduce { |memo, number| memo + number }.result).to be_success.with_data(value: [0, 0, 1, 1, 2, 2, 3, 3, 4, 4, 5, 5])
          expect(service.collection((0..5)).reduce { |memo, number| memo + number }.result).to be_success.with_data(value: 15)

          # NOTE: Initial, block.
          expect([0, 1, 2, 3, 4, 5].reduce(10) { |memo, number| memo + number }).to eq(25)
          expect(service.collection(enumerable([0, 1, 2, 3, 4, 5])).reduce(10) { |memo, number| memo + number }.result).to be_success.with_data(value: 25)
          expect(service.collection(enumerator([0, 1, 2, 3, 4, 5])).reduce(10) { |memo, number| memo + number }.result).to be_success.with_data(value: 25)
          expect(service.collection(lazy_enumerator([0, 1, 2, 3, 4, 5])).reduce(10) { |memo, number| memo + number }.result).to be_success.with_data(value: 25)
          expect(service.collection(chain_enumerator([0, 1, 2, 3, 4, 5])).reduce(10) { |memo, number| memo + number }.result).to be_success.with_data(value: 25)
          expect(service.collection([0, 1, 2, 3, 4, 5]).reduce(10) { |memo, number| memo + number }.result).to be_success.with_data(value: 25)

          expect(service.collection(set([0, 1, 2, 3, 4, 5])).reduce(10) { |memo, number| memo + number }.result).to be_success.with_data(value: 25)
          expect({0 => 0, 1 => 1, 2 => 2, 3 => 3, 4 => 4, 5 => 5}.reduce([10, 10]) { |memo, number| memo + number }).to eq([10, 10, 0, 0, 1, 1, 2, 2, 3, 3, 4, 4, 5, 5])
          expect(service.collection({0 => 0, 1 => 1, 2 => 2, 3 => 3, 4 => 4, 5 => 5}).reduce([10, 10]) { |memo, number| memo + number }.result).to be_success.with_data(value: [10, 10, 0, 0, 1, 1, 2, 2, 3, 3, 4, 4, 5, 5])
          expect(service.collection((0..5)).reduce(10) { |memo, number| memo + number }.result).to be_success.with_data(value: 25)

          # NOTE: Step with no outputs.
          expect { service.collection(enumerable([0, 1, 2, 3, 4, 5])).reduce { |memo, number| step add_numbers_service, in: [number: -> { memo }, other_number: -> { number }] }.result }.to raise_error(NoMethodError).with_message("undefined method '+' for true")
          expect { service.collection(enumerator([0, 1, 2, 3, 4, 5])).reduce { |memo, number| step add_numbers_service, in: [number: -> { memo }, other_number: -> { number }] }.result }.to raise_error(NoMethodError).with_message("undefined method '+' for true")
          expect { service.collection(lazy_enumerator([0, 1, 2, 3, 4, 5])).reduce { |memo, number| step add_numbers_service, in: [number: -> { memo }, other_number: -> { number }] }.result }.to raise_error(NoMethodError).with_message("undefined method '+' for true")
          expect { service.collection(chain_enumerator([0, 1, 2, 3, 4, 5])).reduce { |memo, number| step add_numbers_service, in: [number: -> { memo }, other_number: -> { number }] }.result }.to raise_error(NoMethodError).with_message("undefined method '+' for true")
          expect { service.collection([0, 1, 2, 3, 4, 5]).reduce { |memo, number| step add_numbers_service, in: [number: -> { memo }, other_number: -> { number }] }.result }.to raise_error(NoMethodError).with_message("undefined method '+' for true")

          expect { service.collection(set([0, 1, 2, 3, 4, 5])).reduce { |memo, number| step add_numbers_service, in: [number: -> { memo }, other_number: -> { number }] }.result }.to raise_error(NoMethodError).with_message("undefined method '+' for true")
          expect { service.collection({0 => 0, 1 => 1, 2 => 2, 3 => 3, 4 => 4, 5 => 5}).reduce(0) { |memo, (key, value)| step add_numbers_service, in: [number: -> { memo }, other_number: -> { value }] }.result }.to raise_error(NoMethodError).with_message("undefined method '+' for true")
          expect { service.collection((0..5)).reduce { |memo, number| step add_numbers_service, in: [number: -> { memo }, other_number: -> { number }] }.result }.to raise_error(NoMethodError).with_message("undefined method '+' for true")

          # NOTE: Step with one output.
          expect(service.collection(enumerable([0, 1, 2])).reduce { |memo, number| step add_numbers_service, in: [number: -> { memo }, other_number: -> { number }], out: :sum }.result).to be_success.with_data(value: 3)
          expect(service.collection(enumerator([0, 1, 2])).reduce { |memo, number| step add_numbers_service, in: [number: -> { memo }, other_number: -> { number }], out: :sum }.result).to be_success.with_data(value: 3)
          expect(service.collection(lazy_enumerator([0, 1, 2])).reduce { |memo, number| step add_numbers_service, in: [number: -> { memo }, other_number: -> { number }], out: :sum }.result).to be_success.with_data(value: 3)
          expect(service.collection(chain_enumerator([0, 1, 2])).reduce { |memo, number| step add_numbers_service, in: [number: -> { memo }, other_number: -> { number }], out: :sum }.result).to be_success.with_data(value: 3)
          expect(service.collection([0, 1, 2]).reduce { |memo, number| step add_numbers_service, in: [number: -> { memo }, other_number: -> { number }], out: :sum }.result).to be_success.with_data(value: 3)

          expect(service.collection(set([0, 1, 2])).reduce { |memo, number| step add_numbers_service, in: [number: -> { memo }, other_number: -> { number }], out: :sum }.result).to be_success.with_data(value: 3)
          expect(service.collection({0 => 0, 1 => 1, 2 => 2}).reduce(0) { |memo, (key, value)| step add_numbers_service, in: [number: -> { memo }, other_number: -> { value }], out: :sum }.result).to be_success.with_data(value: 3)
          expect(service.collection((0..2)).reduce { |memo, number| step add_numbers_service, in: [number: -> { memo }, other_number: -> { number }], out: :sum }.result).to be_success.with_data(value: 3)

          # NOTE: Step with multiple outputs.
          expect(service.collection(enumerable([0, 1, 2, 3, 4, 5])).reduce({sum: 0}) { |memo, number| step add_numbers_service, in: [number: -> { memo[:sum] }, other_number: -> { number }], out: [:sum, :operator] }.result).to be_success.with_data(value: {sum: 15, operator: "+"})
          expect(service.collection(enumerator([0, 1, 2, 3, 4, 5])).reduce({sum: 0}) { |memo, number| step add_numbers_service, in: [number: -> { memo[:sum] }, other_number: -> { number }], out: [:sum, :operator] }.result).to be_success.with_data(value: {sum: 15, operator: "+"})
          expect(service.collection(lazy_enumerator([0, 1, 2, 3, 4, 5])).reduce({sum: 0}) { |memo, number| step add_numbers_service, in: [number: -> { memo[:sum] }, other_number: -> { number }], out: [:sum, :operator] }.result).to be_success.with_data(value: {sum: 15, operator: "+"})
          expect(service.collection(chain_enumerator([0, 1, 2, 3, 4, 5])).reduce({sum: 0}) { |memo, number| step add_numbers_service, in: [number: -> { memo[:sum] }, other_number: -> { number }], out: [:sum, :operator] }.result).to be_success.with_data(value: {sum: 15, operator: "+"})
          expect(service.collection([0, 1, 2, 3, 4, 5]).reduce({sum: 0}) { |memo, number| step add_numbers_service, in: [number: -> { memo[:sum] }, other_number: -> { number }], out: [:sum, :operator] }.result).to be_success.with_data(value: {sum: 15, operator: "+"})

          expect(service.collection(set([0, 1, 2, 3, 4, 5])).reduce({sum: 0}) { |memo, number| step add_numbers_service, in: [number: -> { memo[:sum] }, other_number: -> { number }], out: [:sum, :operator] }.result).to be_success.with_data(value: {sum: 15, operator: "+"})
          expect(service.collection({0 => 0, 1 => 1, 2 => 2, 3 => 3, 4 => 4, 5 => 5}).reduce({sum: 0}) { |memo, (key, value)| step add_numbers_service, in: [number: -> { memo[:sum] }, other_number: -> { value }], out: [:sum, :operator] }.result).to be_success.with_data(value: {sum: 15, operator: "+"})
          expect(service.collection((0..5)).reduce({sum: 0}) { |memo, number| step add_numbers_service, in: [number: -> { memo[:sum] }, other_number: -> { number }], out: [:sum, :operator] }.result).to be_success.with_data(value: {sum: 15, operator: "+"})

          # NOTE: Error result.
          expect(service.collection(enumerable([0, -1, :exception])).reduce { |memo, number| step add_numbers_service, in: [number: -> { memo }, other_number: -> { number }], out: :sum }.result).to be_error.without_data
          expect(service.collection(enumerator([0, -1, :exception])).reduce { |memo, number| step add_numbers_service, in: [number: -> { memo }, other_number: -> { number }], out: :sum }.result).to be_error.without_data
          expect(service.collection(lazy_enumerator([0, -1, :exception])).reduce { |memo, number| step add_numbers_service, in: [number: -> { memo }, other_number: -> { number }], out: :sum }.result).to be_error.without_data
          expect(service.collection(chain_enumerator([0, -1, :exception])).reduce { |memo, number| step add_numbers_service, in: [number: -> { memo }, other_number: -> { number }], out: :sum }.result).to be_error.without_data
          expect(service.collection([0, -1, :exception]).reduce { |memo, number| step add_numbers_service, in: [number: -> { memo }, other_number: -> { number }], out: :sum }.result).to be_error.without_data
          expect(service.collection(set([0, -1, :exception])).reduce { |memo, number| step add_numbers_service, in: [number: -> { memo }, other_number: -> { number }], out: :sum }.result).to be_error.without_data

          expect(service.collection({0 => 0, -1 => -1, :exception => :exception}).reduce(0) { |memo, (key, value)| step add_numbers_service, in: [number: -> { memo }, other_number: -> { value }], out: :sum }.result).to be_error.without_data
          expect((-1..-1).reduce { |memo, number| raise }).to eq(-1)
          expect(service.collection((-1..-1)).reduce { |memo, number| step add_numbers_service, in: [number: -> { memo }, other_number: -> { number }], out: :sum }.result).to be_success.with_data(value: -1)

          # NOTE: Error propagation.
          expect(service.collection(enumerable([:success, :error, :exception])).filter { |status| step status_service, in: [status: -> { status }] }.reduce { |memo, number| memo + number }.result).to be_error.without_data
          expect(service.collection(enumerator([:success, :error, :exception])).filter { |status| step status_service, in: [status: -> { status }] }.reduce { |memo, number| memo + number }.result).to be_error.without_data
          expect(service.collection(lazy_enumerator([:success, :error, :exception])).filter { |status| step status_service, in: [status: -> { status }] }.reduce { |memo, number| memo + number }.result).to be_error.without_data
          expect(service.collection(chain_enumerator([:success, :error, :exception])).filter { |status| step status_service, in: [status: -> { status }] }.reduce { |memo, number| memo + number }.result).to be_error.without_data
          expect(service.collection([:success, :error, :exception]).filter { |status| step status_service, in: [status: -> { status }] }.reduce { |memo, number| memo + number }.result).to be_error.without_data

          expect(service.collection(set([:success, :error, :exception])).filter { |status| step status_service, in: [status: -> { status }] }.reduce { |memo, number| memo + number }.result).to be_error.without_data
          expect(service.collection({success: :success, error: :error, exception: :exception}).filter { |key, value| step status_service, in: [status: -> { value }] }.reduce(0) { |memo, (key, value)| memo + value }.result).to be_error.without_data
          expect(service.collection((:error..:error)).filter { |status| step status_service, in: [status: -> { status }] }.reduce { |memo, number| memo + number }.result).to be_error.without_data

          # NOTE: Usage on terminal chaining.
          expect { service.collection(enumerable([:success, :exception, :exception])).first.reduce { |memo, number| memo + number }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection(enumerator([:success, :exception, :exception])).first.reduce { |memo, number| memo + number }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection(lazy_enumerator([:success, :exception, :exception])).first.reduce { |memo, number| memo + number }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection(chain_enumerator([:success, :exception, :exception])).first.reduce { |memo, number| memo + number }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection([:success, :exception, :exception]).first.reduce { |memo, number| memo + number }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection(set([:success, :exception, :exception])).first.reduce { |memo, number| memo + number }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)

          expect { service.collection({success: :success, exception: :exception}).first.reduce { |memo, (key, value)| memo + value }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection((:success..:success)).first.reduce { |memo, number| memo + number }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
        end
      end

      describe "#reject" do
        specify do
          # NOTE: Empty collection.
          expect([].reject { |status| condition[status] }).to eq([])
          expect(service.collection(enumerable([])).reject { |status| condition[status] }.result).to be_success.with_data(values: [])
          expect(service.collection(enumerator([])).reject { |status| condition[status] }.result).to be_success.with_data(values: [])
          expect(service.collection(lazy_enumerator([])).reject { |status| condition[status] }.result).to be_success.with_data(values: [])
          expect(service.collection(chain_enumerator([])).reject { |status| condition[status] }.result).to be_success.with_data(values: [])
          expect(service.collection([]).reject { |status| condition[status] }.result).to be_success.with_data(values: [])
          expect(service.collection(set([])).reject { |status| condition[status] }.result).to be_success.with_data(values: [])
          expect(service.collection({}).reject { |status| condition[status] }.result).to be_success.with_data(values: {})
          expect(service.collection((:success...:success)).reject { |status| condition[status] }.result).to be_success.with_data(values: [])

          # NOTE: No block.
          expect([:success, :failure, :success, :failure].reject.to_a).to eq([:success, :failure, :success, :failure])
          expect(service.collection(enumerable([:success, :failure, :success, :failure])).reject.result).to be_success.with_data(values: [:success, :failure, :success, :failure])
          expect(service.collection(enumerator([:success, :failure, :success, :failure])).reject.result).to be_success.with_data(values: [:success, :failure, :success, :failure])
          expect { service.collection(lazy_enumerator([:success, :failure, :success, :failure])).reject.result }.to raise_error(ArgumentError).with_message("tried to call lazy reject without a block")
          expect(service.collection(chain_enumerator([:success, :failure, :success, :failure])).reject.result).to be_success.with_data(values: [:success, :failure, :success, :failure])
          expect(service.collection([:success, :failure, :success, :failure]).reject.result).to be_success.with_data(values: [:success, :failure, :success, :failure])

          # NOTE: Block.
          expect([:success, :failure, :success, :failure].reject { |status| condition[status] }).to eq([:failure, :failure])
          expect(service.collection(enumerable([:success, :failure, :success, :failure])).reject { |status| condition[status] }.result).to be_success.with_data(values: [:failure, :failure])
          expect(service.collection(enumerator([:success, :failure, :success, :failure])).reject { |status| condition[status] }.result).to be_success.with_data(values: [:failure, :failure])
          expect(service.collection(lazy_enumerator([:success, :failure, :success, :failure])).reject { |status| condition[status] }.result).to be_success.with_data(values: [:failure, :failure])
          expect(service.collection(chain_enumerator([:success, :failure, :success, :failure])).reject { |status| condition[status] }.result).to be_success.with_data(values: [:failure, :failure])
          expect(service.collection([:success, :failure, :success, :failure]).reject { |status| condition[status] }.result).to be_success.with_data(values: [:failure, :failure])

          expect(service.collection(set([:success, :failure])).reject { |status| condition[status] }.result).to be_success.with_data(values: [:failure])
          expect(service.collection({success: :success, failure: :failure}).reject { |key, value| condition[value] }.result).to be_success.with_data(values: {failure: :failure})
          expect(service.collection((:success..:success)).reject { |status| condition[status] }.result).to be_success.with_data(values: [])
          expect(service.collection((:failure..:failure)).reject { |status| condition[status] }.result).to be_success.with_data(values: [:failure])

          # NOTE: Step with no outputs.
          expect(service.collection(enumerable([:success, :failure, :success, :failure])).reject { |status| step status_service, in: [status: -> { status }] }.result).to be_success.with_data(values: [:failure, :failure])
          expect(service.collection(enumerator([:success, :failure, :success, :failure])).reject { |status| step status_service, in: [status: -> { status }] }.result).to be_success.with_data(values: [:failure, :failure])
          expect(service.collection(lazy_enumerator([:success, :failure, :success, :failure])).reject { |status| step status_service, in: [status: -> { status }] }.result).to be_success.with_data(values: [:failure, :failure])
          expect(service.collection(chain_enumerator([:success, :failure, :success, :failure])).reject { |status| step status_service, in: [status: -> { status }] }.result).to be_success.with_data(values: [:failure, :failure])
          expect(service.collection([:success, :failure, :success, :failure]).reject { |status| step status_service, in: [status: -> { status }] }.result).to be_success.with_data(values: [:failure, :failure])

          expect(service.collection(set([:success, :failure])).reject { |status| step status_service, in: [status: -> { status }] }.result).to be_success.with_data(values: [:failure])
          expect(service.collection({success: :success, failure: :failure}).reject { |key, value| step status_service, in: [status: -> { value }] }.result).to be_success.with_data(values: {failure: :failure})
          expect(service.collection((:success..:success)).reject { |status| step status_service, in: [status: -> { status }] }.result).to be_success.with_data(values: [])
          expect(service.collection((:failure..:failure)).reject { |status| step status_service, in: [status: -> { status }] }.result).to be_success.with_data(values: [:failure])

          # NOTE: Step with one output.
          expect(service.collection(enumerable([:success, :failure, :success, :failure])).reject { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(values: [:failure, :failure])
          expect(service.collection(enumerator([:success, :failure, :success, :failure])).reject { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(values: [:failure, :failure])
          expect(service.collection(lazy_enumerator([:success, :failure, :success, :failure])).reject { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(values: [:failure, :failure])
          expect(service.collection(chain_enumerator([:success, :failure, :success, :failure])).reject { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(values: [:failure, :failure])
          expect(service.collection([:success, :failure, :success, :failure]).reject { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(values: [:failure, :failure])

          expect(service.collection(set([:success, :failure])).reject { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(values: [:failure])
          expect(service.collection({success: :success, failure: :failure}).reject { |key, value| step status_service, in: [status: -> { value }], out: :status_string }.result).to be_success.with_data(values: {failure: :failure})
          expect(service.collection((:success..:success)).reject { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(values: [])
          expect(service.collection((:failure..:failure)).reject { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(values: [:failure])

          # NOTE: Step with multiple outputs.
          expect(service.collection(enumerable([:success, :failure, :success, :failure])).reject { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [:failure, :failure])
          expect(service.collection(enumerator([:success, :failure, :success, :failure])).reject { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [:failure, :failure])
          expect(service.collection(lazy_enumerator([:success, :failure, :success, :failure])).reject { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [:failure, :failure])
          expect(service.collection(chain_enumerator([:success, :failure, :success, :failure])).reject { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [:failure, :failure])
          expect(service.collection([:success, :failure, :success, :failure]).reject { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [:failure, :failure])

          expect(service.collection(set([:success, :failure])).reject { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [:failure])
          expect(service.collection({success: :success, failure: :failure}).reject { |key, value| step status_service, in: [status: -> { value }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: {failure: :failure})
          expect(service.collection((:success..:success)).reject { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [])
          expect(service.collection((:failure..:failure)).reject { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [:failure])

          # NOTE: Error result.
          expect(service.collection(enumerable([:success, :error, :exception])).reject { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection(enumerator([:success, :error, :exception])).reject { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection(lazy_enumerator([:success, :error, :exception])).reject { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection(chain_enumerator([:success, :error, :exception])).reject { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection([:success, :error, :exception]).reject { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data

          expect(service.collection(set([:success, :error, :exception])).reject { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection({success: :success, error: :error, exception: :exception}).reject { |key, value| step status_service, in: [status: -> { value }] }.result).to be_error.without_data
          expect(service.collection((:error..:error)).reject { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data

          # NOTE: Error propagation.
          expect(service.collection(enumerable([:success, :error, :exception])).filter { |status| step status_service, in: [status: -> { status }] }.reject { |status| condition[status] }.result).to be_error.without_data
          expect(service.collection(enumerator([:success, :error, :exception])).filter { |status| step status_service, in: [status: -> { status }] }.reject { |status| condition[status] }.result).to be_error.without_data
          expect(service.collection(lazy_enumerator([:success, :error, :exception])).filter { |status| step status_service, in: [status: -> { status }] }.reject { |status| condition[status] }.result).to be_error.without_data
          expect(service.collection(chain_enumerator([:success, :error, :exception])).filter { |status| step status_service, in: [status: -> { status }] }.reject { |status| condition[status] }.result).to be_error.without_data
          expect(service.collection([:success, :error, :exception]).filter { |status| step status_service, in: [status: -> { status }] }.reject { |status| condition[status] }.result).to be_error.without_data

          expect(service.collection(set([:success, :error, :exception])).filter { |status| step status_service, in: [status: -> { status }] }.reject { |status| condition[status] }.result).to be_error.without_data
          expect(service.collection({success: :success, error: :error, exception: :exception}).filter { |key, value| step status_service, in: [status: -> { value }] }.reject { |key, value| condition[value] }.result).to be_error.without_data
          expect(service.collection((:error..:error)).filter { |status| step status_service, in: [status: -> { status }] }.reject { |status| condition[status] }.result).to be_error.without_data

          # NOTE: Usage on terminal chaining.
          expect { service.collection(enumerable([:success, :exception, :exception])).first.reject { |status| condition[status] }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection(enumerator([:success, :exception, :exception])).first.reject { |status| condition[status] }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection(lazy_enumerator([:success, :exception, :exception])).first.reject { |status| condition[status] }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection(chain_enumerator([:success, :exception, :exception])).first.reject { |status| condition[status] }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection([:success, :exception, :exception]).first.reject { |status| condition[status] }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)

          expect { service.collection(set([:success, :exception, :exception])).first.reject { |status| condition[status] }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection({success: :success, exception: :exception}).first.reject { |key, value| condition[value] }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection((:success..:success)).first.reject { |status| condition[status] }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
        end
      end

      describe "#reverse_each" do
        specify do
          # NOTE: Empty collection.
          expect([].reverse_each { |status| condition[status] }).to eq([])
          expect(service.collection(enumerable([])).reverse_each { |status| condition[status] }.result).to be_success.with_data(values: [])
          expect(service.collection(enumerator([])).reverse_each { |status| condition[status] }.result).to be_success.with_data(values: [])
          expect(service.collection(lazy_enumerator([])).reverse_each { |status| condition[status] }.result).to be_success.with_data(values: [])
          expect(service.collection(chain_enumerator([])).reverse_each { |status| condition[status] }.result).to be_success.with_data(values: [])
          expect(service.collection([]).reverse_each { |status| condition[status] }.result).to be_success.with_data(values: [])
          expect(service.collection(set([])).reverse_each { |status| condition[status] }.result).to be_success.with_data(values: [])
          expect(service.collection({}).reverse_each { |status| condition[status] }.result).to be_success.with_data(values: {})
          expect(service.collection((:success...:success)).reverse_each { |status| condition[status] }.result).to be_success.with_data(values: [])

          # NOTE: No block.
          expect([0, 1, 2, 3, 4, 5].reverse_each.to_a).to eq([5, 4, 3, 2, 1, 0])
          expect(service.collection(enumerable([0, 1, 2, 3, 4, 5])).reverse_each.result).to be_success.with_data(values: [5, 4, 3, 2, 1, 0])
          expect(service.collection(enumerator([0, 1, 2, 3, 4, 5])).reverse_each.result).to be_success.with_data(values: [5, 4, 3, 2, 1, 0])
          expect(lazy_enumerator([0, 1, 2, 3, 4, 5]).reverse_each.to_a).to eq([5, 4, 3, 2, 1, 0])
          expect(service.collection(lazy_enumerator([0, 1, 2, 3, 4, 5])).reverse_each.result).to be_success.with_data(values: [5, 4, 3, 2, 1, 0])
          expect(service.collection(chain_enumerator([0, 1, 2, 3, 4, 5])).reverse_each.result).to be_success.with_data(values: [5, 4, 3, 2, 1, 0])
          expect(service.collection([0, 1, 2, 3, 4, 5]).reverse_each.result).to be_success.with_data(values: [5, 4, 3, 2, 1, 0])

          # NOTE: Block.
          expect([0, 1, 2, 3, 4, 5].reverse_each { |number| number.to_s.ord }).to eq([0, 1, 2, 3, 4, 5])
          expect(service.collection(enumerable([0, 1, 2, 3, 4, 5])).reverse_each { |number| number.to_s.ord }.result).to be_success.with_data(values: [0, 1, 2, 3, 4, 5])
          expect(service.collection(enumerator([0, 1, 2, 3, 4, 5])).reverse_each { |number| number.to_s.ord }.result).to be_success.with_data(values: [0, 1, 2, 3, 4, 5])
          expect(service.collection(lazy_enumerator([0, 1, 2, 3, 4, 5])).reverse_each { |number| number.to_s.ord }.result).to be_success.with_data(values: [0, 1, 2, 3, 4, 5])
          expect(service.collection(chain_enumerator([0, 1, 2, 3, 4, 5])).reverse_each { |number| number.to_s.ord }.result).to be_success.with_data(values: [0, 1, 2, 3, 4, 5])
          expect(service.collection([0, 1, 2, 3, 4, 5]).reverse_each { |number| number.to_s.ord }.result).to be_success.with_data(values: [0, 1, 2, 3, 4, 5])

          expect(service.collection(set([0, 1, 2, 3, 4, 5])).reverse_each { |number| number.to_s.ord }.result).to be_success.with_data(values: [0, 1, 2, 3, 4, 5])
          expect({0 => 0, 1 => 1, 2 => 2, 3 => 3, 4 => 4, 5 => 5}.reverse_each { |key, value| value.to_s.ord }.to_h).to eq({5 => 5, 4 => 4, 3 => 3, 2 => 2, 1 => 1, 0 => 0})
          expect(service.collection({0 => 0, 1 => 1, 2 => 2, 3 => 3, 4 => 4, 5 => 5}).reverse_each { |key, value| value.to_s.ord }.result).to be_success.with_data(values: {5 => 5, 4 => 4, 3 => 3, 2 => 2, 1 => 1, 0 => 0})
          expect(service.collection((0..5)).reverse_each { |number| number.to_s.ord }.result).to be_success.with_data(values: [0, 1, 2, 3, 4, 5])

          # NOTE: Step with no outputs.
          expect(service.collection(enumerable([:success, :success, :success])).reverse_each { |status| step status_service, in: [status: -> { status }] }.result).to be_success.with_data(values: [:success, :success, :success])
          expect(service.collection(enumerator([:success, :success, :success])).reverse_each { |status| step status_service, in: [status: -> { status }] }.result).to be_success.with_data(values: [:success, :success, :success])
          expect(service.collection(lazy_enumerator([:success, :success, :success])).reverse_each { |status| step status_service, in: [status: -> { status }] }.result).to be_success.with_data(values: [:success, :success, :success])
          expect(service.collection(chain_enumerator([:success, :success, :success])).reverse_each { |status| step status_service, in: [status: -> { status }] }.result).to be_success.with_data(values: [:success, :success, :success])
          expect(service.collection([:success, :success, :success]).reverse_each { |status| step status_service, in: [status: -> { status }] }.result).to be_success.with_data(values: [:success, :success, :success])

          expect(service.collection(set([:success])).reverse_each { |status| step status_service, in: [status: -> { status }] }.result).to be_success.with_data(values: [:success])
          expect(service.collection({success: :success}).reverse_each { |key, value| step status_service, in: [status: -> { value }] }.result).to be_success.with_data(values: {success: :success})
          expect(service.collection((:success..:success)).reverse_each { |status| step status_service, in: [status: -> { status }] }.result).to be_success.with_data(values: [:success])

          # NOTE: Step with one output.
          expect(service.collection(enumerable([:success, :success, :success])).reverse_each { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(values: [:success, :success, :success])
          expect(service.collection(enumerator([:success, :success, :success])).reverse_each { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(values: [:success, :success, :success])
          expect(service.collection(lazy_enumerator([:success, :success, :success])).reverse_each { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(values: [:success, :success, :success])
          expect(service.collection(chain_enumerator([:success, :success, :success])).reverse_each { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(values: [:success, :success, :success])
          expect(service.collection([:success, :success, :success]).reverse_each { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(values: [:success, :success, :success])

          expect(service.collection(set([:success])).reverse_each { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(values: [:success])
          expect(service.collection({success: :success}).reverse_each { |key, value| step status_service, in: [status: -> { value }], out: :status_string }.result).to be_success.with_data(values: {success: :success})
          expect(service.collection((:success..:success)).reverse_each { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(values: [:success])

          # NOTE: Step with multiple outputs.
          expect(service.collection(enumerable([:success, :success, :success])).reverse_each { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [:success, :success, :success])
          expect(service.collection(enumerator([:success, :success, :success])).reverse_each { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [:success, :success, :success])
          expect(service.collection(lazy_enumerator([:success, :success, :success])).reverse_each { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [:success, :success, :success])
          expect(service.collection(chain_enumerator([:success, :success, :success])).reverse_each { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [:success, :success, :success])
          expect(service.collection([:success, :success, :success]).reverse_each { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [:success, :success, :success])

          expect(service.collection(set([:success])).reverse_each { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [:success])
          expect(service.collection({success: :success}).reverse_each { |key, value| step status_service, in: [status: -> { value }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: {success: :success})
          expect(service.collection((:success..:success)).reverse_each { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [:success])

          # NOTE: Error result.
          expect(service.collection(enumerable([:exception, :error, :success])).reverse_each { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection(enumerator([:exception, :error, :success])).reverse_each { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection(lazy_enumerator([:exception, :error, :success])).reverse_each { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection(chain_enumerator([:exception, :error, :success])).reverse_each { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection([:exception, :error, :success]).reverse_each { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data

          expect(service.collection(set([:exception, :error, :success])).reverse_each { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection({exception: :exception, error: :error, success: :success}).reverse_each { |key, value| step status_service, in: [status: -> { value }] }.result).to be_error.without_data
          expect(service.collection((:error..:error)).reverse_each { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data

          # NOTE: Error propagation.
          expect(service.collection(enumerable([:success, :error, :exception])).filter { |status| step status_service, in: [status: -> { status }] }.reverse_each { |status| condition[status] }.result).to be_error.without_data
          expect(service.collection(enumerator([:success, :error, :exception])).filter { |status| step status_service, in: [status: -> { status }] }.reverse_each { |status| condition[status] }.result).to be_error.without_data
          expect(service.collection(lazy_enumerator([:success, :error, :exception])).filter { |status| step status_service, in: [status: -> { status }] }.reverse_each { |status| condition[status] }.result).to be_error.without_data
          expect(service.collection(chain_enumerator([:success, :error, :exception])).filter { |status| step status_service, in: [status: -> { status }] }.reverse_each { |status| condition[status] }.result).to be_error.without_data
          expect(service.collection([:success, :error, :exception]).filter { |status| step status_service, in: [status: -> { status }] }.reverse_each { |status| condition[status] }.result).to be_error.without_data

          expect(service.collection(set([:success, :error, :exception])).filter { |status| step status_service, in: [status: -> { status }] }.reverse_each { |status| condition[status] }.result).to be_error.without_data
          expect(service.collection({success: :success, error: :error, exception: :exception}).filter { |key, value| step status_service, in: [status: -> { value }] }.reverse_each { |key, value| condition[value] }.result).to be_error.without_data
          expect(service.collection((:error..:error)).filter { |status| step status_service, in: [status: -> { status }] }.reverse_each { |status| condition[status] }.result).to be_error.without_data

          # NOTE: Usage on terminal chaining.
          expect { service.collection(enumerable([:success, :exception, :exception])).first.reverse_each { |status| condition[status] }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection(enumerator([:success, :exception, :exception])).first.reverse_each { |status| condition[status] }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection(lazy_enumerator([:success, :exception, :exception])).first.reverse_each { |status| condition[status] }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection(chain_enumerator([:success, :exception, :exception])).first.reverse_each { |status| condition[status] }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection([:success, :exception, :exception]).first.reverse_each { |status| condition[status] }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)

          expect { service.collection(set([:success, :exception, :exception])).first.reverse_each { |status| condition[status] }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection({success: :success, exception: :exception}).first.reverse_each { |key, value| condition[value] }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection((:success..:success)).first.reverse_each { |status| condition[status] }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
        end
      end

      describe "#select" do
        specify do
          # NOTE: Empty collection.
          expect([].select { |status| condition[status] }).to eq([])
          expect(service.collection(enumerable([])).select { |status| condition[status] }.result).to be_success.with_data(values: [])
          expect(service.collection(enumerator([])).select { |status| condition[status] }.result).to be_success.with_data(values: [])
          expect(service.collection(lazy_enumerator([])).select { |status| condition[status] }.result).to be_success.with_data(values: [])
          expect(service.collection(chain_enumerator([])).select { |status| condition[status] }.result).to be_success.with_data(values: [])
          expect(service.collection([]).select { |status| condition[status] }.result).to be_success.with_data(values: [])
          expect(service.collection(set([])).select { |status| condition[status] }.result).to be_success.with_data(values: [])
          expect(service.collection({}).select { |status| condition[status] }.result).to be_success.with_data(values: {})
          expect(service.collection((:success...:success)).select { |status| condition[status] }.result).to be_success.with_data(values: [])

          # NOTE: No block.
          expect([:success, :failure, :success, :failure].select.to_a).to eq([:success, :failure, :success, :failure])
          expect(service.collection(enumerable([:success, :failure, :success, :failure])).select.result).to be_success.with_data(values: [:success, :failure, :success, :failure])
          expect(service.collection(enumerator([:success, :failure, :success, :failure])).select.result).to be_success.with_data(values: [:success, :failure, :success, :failure])
          expect { service.collection(lazy_enumerator([:success, :failure, :success, :failure])).select.result }.to raise_error(ArgumentError).with_message("tried to call lazy select without a block")
          expect(service.collection(chain_enumerator([:success, :failure, :success, :failure])).select.result).to be_success.with_data(values: [:success, :failure, :success, :failure])
          expect(service.collection([:success, :failure, :success, :failure]).select.result).to be_success.with_data(values: [:success, :failure, :success, :failure])

          expect(service.collection(set([:success, :failure])).select.result).to be_success.with_data(values: [:success, :failure])
          expect(service.collection({success: :success, failure: :failure}).select.result).to be_success.with_data(values: [[:success, :success], [:failure, :failure]])
          expect(service.collection((:success..:success)).select.result).to be_success.with_data(values: [:success])

          # NOTE: Block.
          expect([:success, :failure, :success, :failure].select { |status| condition[status] }).to eq([:success, :success])
          expect(service.collection(enumerable([:success, :failure, :success, :failure])).select { |status| condition[status] }.result).to be_success.with_data(values: [:success, :success])
          expect(service.collection(enumerator([:success, :failure, :success, :failure])).select { |status| condition[status] }.result).to be_success.with_data(values: [:success, :success])
          expect(service.collection(lazy_enumerator([:success, :failure, :success, :failure])).select { |status| condition[status] }.result).to be_success.with_data(values: [:success, :success])
          expect(service.collection(chain_enumerator([:success, :failure, :success, :failure])).select { |status| condition[status] }.result).to be_success.with_data(values: [:success, :success])
          expect(service.collection([:success, :failure, :success, :failure]).select { |status| condition[status] }.result).to be_success.with_data(values: [:success, :success])

          expect(service.collection(set([:success, :failure])).select { |status| condition[status] }.result).to be_success.with_data(values: [:success])
          expect(service.collection({success: :success, failure: :failure}).select { |key, value| condition[value] }.result).to be_success.with_data(values: {success: :success})
          expect(service.collection((:success..:success)).select { |status| condition[status] }.result).to be_success.with_data(values: [:success])
          expect(service.collection((:failure..:failure)).select { |status| condition[status] }.result).to be_success.with_data(values: [])

          # NOTE: Step with no outputs.
          expect(service.collection(enumerable([:success, :failure, :success, :failure])).select { |status| step status_service, in: [status: -> { status }] }.result).to be_success.with_data(values: [:success, :success])
          expect(service.collection(enumerator([:success, :failure, :success, :failure])).select { |status| step status_service, in: [status: -> { status }] }.result).to be_success.with_data(values: [:success, :success])
          expect(service.collection(lazy_enumerator([:success, :failure, :success, :failure])).select { |status| step status_service, in: [status: -> { status }] }.result).to be_success.with_data(values: [:success, :success])
          expect(service.collection(chain_enumerator([:success, :failure, :success, :failure])).select { |status| step status_service, in: [status: -> { status }] }.result).to be_success.with_data(values: [:success, :success])
          expect(service.collection([:success, :failure, :success, :failure]).select { |status| step status_service, in: [status: -> { status }] }.result).to be_success.with_data(values: [:success, :success])

          expect(service.collection(set([:success, :failure])).select { |status| step status_service, in: [status: -> { status }] }.result).to be_success.with_data(values: [:success])
          expect(service.collection({success: :success, failure: :failure}).select { |key, value| step status_service, in: [status: -> { value }] }.result).to be_success.with_data(values: {success: :success})
          expect(service.collection((:success..:success)).select { |status| step status_service, in: [status: -> { status }] }.result).to be_success.with_data(values: [:success])
          expect(service.collection((:failure..:failure)).select { |status| step status_service, in: [status: -> { status }] }.result).to be_success.with_data(values: [])

          # NOTE: Step with one output.
          expect(service.collection(enumerable([:success, :failure, :success, :failure])).select { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(values: [:success, :success])
          expect(service.collection(enumerator([:success, :failure, :success, :failure])).select { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(values: [:success, :success])
          expect(service.collection(lazy_enumerator([:success, :failure, :success, :failure])).select { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(values: [:success, :success])
          expect(service.collection(chain_enumerator([:success, :failure, :success, :failure])).select { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(values: [:success, :success])
          expect(service.collection([:success, :failure, :success, :failure]).select { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(values: [:success, :success])

          expect(service.collection(set([:success, :failure])).select { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(values: [:success])
          expect(service.collection({success: :success, failure: :failure}).select { |key, value| step status_service, in: [status: -> { value }], out: :status_string }.result).to be_success.with_data(values: {success: :success})
          expect(service.collection((:success..:success)).select { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(values: [:success])
          expect(service.collection((:failure..:failure)).select { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(values: [])

          # NOTE: Step with multiple outputs.
          expect(service.collection(enumerable([:success, :failure, :success, :failure])).select { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [:success, :success])
          expect(service.collection(enumerator([:success, :failure, :success, :failure])).select { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [:success, :success])
          expect(service.collection(lazy_enumerator([:success, :failure, :success, :failure])).select { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [:success, :success])
          expect(service.collection(chain_enumerator([:success, :failure, :success, :failure])).select { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [:success, :success])
          expect(service.collection([:success, :failure, :success, :failure]).select { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [:success, :success])

          expect(service.collection(set([:success, :failure])).select { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [:success])
          expect(service.collection({success: :success, failure: :failure}).select { |key, value| step status_service, in: [status: -> { value }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: {success: :success})
          expect(service.collection((:success..:success)).select { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [:success])
          expect(service.collection((:failure..:failure)).select { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [])

          # NOTE: Error result.
          expect(service.collection(enumerable([:success, :error, :exception])).select { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection(enumerator([:success, :error, :exception])).select { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection(lazy_enumerator([:success, :error, :exception])).select { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection(chain_enumerator([:success, :error, :exception])).select { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection([:success, :error, :exception]).select { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data

          expect(service.collection(set([:success, :error, :exception])).select { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection({success: :success, error: :error, exception: :exception}).select { |key, value| step status_service, in: [status: -> { value }] }.result).to be_error.without_data
          expect(service.collection((:error..:error)).select { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data

          # NOTE: Error propagation.
          expect(service.collection(enumerable([:success, :error, :exception])).filter { |status| step status_service, in: [status: -> { status }] }.select { |status| condition[status] }.result).to be_error.without_data
          expect(service.collection(enumerator([:success, :error, :exception])).filter { |status| step status_service, in: [status: -> { status }] }.select { |status| condition[status] }.result).to be_error.without_data
          expect(service.collection(lazy_enumerator([:success, :error, :exception])).filter { |status| step status_service, in: [status: -> { status }] }.select { |status| condition[status] }.result).to be_error.without_data
          expect(service.collection(chain_enumerator([:success, :error, :exception])).filter { |status| step status_service, in: [status: -> { status }] }.select { |status| condition[status] }.result).to be_error.without_data
          expect(service.collection([:success, :error, :exception]).filter { |status| step status_service, in: [status: -> { status }] }.select { |status| condition[status] }.result).to be_error.without_data

          expect(service.collection(set([:success, :error, :exception])).filter { |status| step status_service, in: [status: -> { status }] }.select { |status| condition[status] }.result).to be_error.without_data
          expect(service.collection({success: :success, error: :error, exception: :exception}).filter { |key, value| step status_service, in: [status: -> { value }] }.select { |key, value| condition[value] }.result).to be_error.without_data
          expect(service.collection((:error..:error)).filter { |status| step status_service, in: [status: -> { status }] }.select { |status| condition[status] }.result).to be_error.without_data

          # NOTE: Usage on terminal chaining.
          expect { service.collection(enumerable([:success, :exception, :exception])).first.select { |status| condition[status] }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection(enumerator([:success, :exception, :exception])).first.select { |status| condition[status] }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection(lazy_enumerator([:success, :exception, :exception])).first.select { |status| condition[status] }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection(chain_enumerator([:success, :exception, :exception])).first.select { |status| condition[status] }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection([:success, :exception, :exception]).first.select { |status| condition[status] }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)

          expect { service.collection(set([:success, :exception, :exception])).first.select { |status| condition[status] }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection({success: :success, exception: :exception}).first.select { |key, value| condition[value] }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection((:success..:success)).first.select { |status| condition[status] }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
        end
      end

      describe "#slice_after" do
        specify do
          # NOTE: Empty collection.
          expect([].slice_after { |number| number % 3 == 0 }.to_a).to eq([])
          expect(service.collection(enumerable([])).slice_after { |number| number % 3 == 0 }.result).to be_success.with_data(values: [])
          expect(service.collection(enumerator([])).slice_after { |number| number % 3 == 0 }.result).to be_success.with_data(values: [])
          expect(service.collection(lazy_enumerator([])).slice_after { |number| number % 3 == 0 }.result).to be_success.with_data(values: [])
          expect(service.collection(chain_enumerator([])).slice_after { |number| number % 3 == 0 }.result).to be_success.with_data(values: [])
          expect(service.collection([]).slice_after { |number| number % 3 == 0 }.result).to be_success.with_data(values: [])
          expect(service.collection({}).slice_after { |key, value| value <= 2 }.result).to be_success.with_data(values: [])
          expect(service.collection((0...0)).slice_after { |number| number % 3 == 0 }.result).to be_success.with_data(values: [])
          expect(service.collection(set([])).slice_after { |number| number % 3 == 0 }.result).to be_success.with_data(values: [])

          # NOTE: No block, no pattern.
          expect { [0, 1, 2, 3, 4, 5].slice_after.to_a }.to raise_error(ArgumentError).with_message("wrong number of arguments (given 0, expected 1)")
          expect { service.collection(enumerable([0, 1, 2, 3, 4, 5])).slice_after.result }.to raise_error(ArgumentError).with_message("wrong number of arguments (given 0, expected 1)")
          expect { service.collection(enumerator([0, 1, 2, 3, 4, 5])).slice_after.result }.to raise_error(ArgumentError).with_message("wrong number of arguments (given 0, expected 1)")
          expect { service.collection(lazy_enumerator([0, 1, 2, 3, 4, 5])).slice_after.result }.to raise_error(ArgumentError).with_message("wrong number of arguments (given 0, expected 1)")
          expect { service.collection(chain_enumerator([0, 1, 2, 3, 4, 5])).slice_after.result }.to raise_error(ArgumentError).with_message("wrong number of arguments (given 0, expected 1)")
          expect { service.collection([0, 1, 2, 3, 4, 5]).slice_after.result }.to raise_error(ArgumentError).with_message("wrong number of arguments (given 0, expected 1)")
          expect { service.collection(set([0, 1, 2, 3, 4, 5])).slice_after.result }.to raise_error(ArgumentError).with_message("wrong number of arguments (given 0, expected 1)")
          expect { service.collection({0 => 0, 1 => 1, 2 => 2, 3 => 3, 4 => 4, 5 => 5}).slice_after.result }.to raise_error(ArgumentError).with_message("wrong number of arguments (given 0, expected 1)")
          expect { service.collection((0..5)).slice_after.result }.to raise_error(ArgumentError).with_message("wrong number of arguments (given 0, expected 1)")

          # NOTE: No block, pattern.
          expect([0, 1, 2, 3, 4, 5].slice_after({0 => true, 3 => true}.to_proc).to_a).to eq([[0], [1, 2, 3], [4, 5]])
          expect(service.collection(enumerable([0, 1, 2, 3, 4, 5])).slice_after({0 => true, 3 => true}.to_proc).result).to be_success.with_data(values: [[0], [1, 2, 3], [4, 5]])
          expect(service.collection(enumerator([0, 1, 2, 3, 4, 5])).slice_after({0 => true, 3 => true}.to_proc).result).to be_success.with_data(values: [[0], [1, 2, 3], [4, 5]])
          expect(service.collection(lazy_enumerator([0, 1, 2, 3, 4, 5])).slice_after({0 => true, 3 => true}.to_proc).result).to be_success.with_data(values: [[0], [1, 2, 3], [4, 5]])
          expect(service.collection(chain_enumerator([0, 1, 2, 3, 4, 5])).slice_after({0 => true, 3 => true}.to_proc).result).to be_success.with_data(values: [[0], [1, 2, 3], [4, 5]])
          expect(service.collection([0, 1, 2, 3, 4, 5]).slice_after({0 => true, 3 => true}.to_proc).result).to be_success.with_data(values: [[0], [1, 2, 3], [4, 5]])
          expect(service.collection(set([0, 1, 2, 3, 4, 5])).slice_after({0 => true, 3 => true}.to_proc).result).to be_success.with_data(values: [[0], [1, 2, 3], [4, 5]])
          expect(service.collection({0 => 0, 1 => 1, 2 => 2, 3 => 3, 4 => 4, 5 => 5}).slice_after({[0, 0] => true, [3, 3] => true}.to_proc).result).to be_success.with_data(values: [[[0, 0]], [[1, 1], [2, 2], [3, 3]], [[4, 4], [5, 5]]])
          expect(service.collection((0..5)).slice_after({0 => true, 3 => true}.to_proc).result).to be_success.with_data(values: [[0], [1, 2, 3], [4, 5]])

          # NOTE: Block, no pattern.
          expect([0, 1, 2, 3, 4, 5].slice_after { |number| number % 3 == 0 }.to_a).to eq([[0], [1, 2, 3], [4, 5]])
          expect(service.collection(enumerable([0, 1, 2, 3, 4, 5])).slice_after { |number| number % 3 == 0 }.result).to be_success.with_data(values: [[0], [1, 2, 3], [4, 5]])
          expect(service.collection(enumerator([0, 1, 2, 3, 4, 5])).slice_after { |number| number % 3 == 0 }.result).to be_success.with_data(values: [[0], [1, 2, 3], [4, 5]])
          expect(service.collection(lazy_enumerator([0, 1, 2, 3, 4, 5])).slice_after { |number| number % 3 == 0 }.result).to be_success.with_data(values: [[0], [1, 2, 3], [4, 5]])
          expect(service.collection(chain_enumerator([0, 1, 2, 3, 4, 5])).slice_after { |number| number % 3 == 0 }.result).to be_success.with_data(values: [[0], [1, 2, 3], [4, 5]])
          expect(service.collection([0, 1, 2, 3, 4, 5]).slice_after { |number| number % 3 == 0 }.result).to be_success.with_data(values: [[0], [1, 2, 3], [4, 5]])
          expect(service.collection(set([0, 1, 2, 3, 4, 5])).slice_after { |number| number % 3 == 0 }.result).to be_success.with_data(values: [[0], [1, 2, 3], [4, 5]])
          expect(service.collection({0 => 0, 1 => 1, 2 => 2, 3 => 3, 4 => 4, 5 => 5}).slice_after { |(key, value)| value % 3 == 0 }.result).to be_success.with_data(values: [[[0, 0]], [[1, 1], [2, 2], [3, 3]], [[4, 4], [5, 5]]])
          expect(service.collection((0..5)).slice_after { |number| number % 3 == 0 }.result).to be_success.with_data(values: [[0], [1, 2, 3], [4, 5]])

          # NOTE: Step with no outputs.
          expect(service.collection(enumerable([:success, :success, :success])).slice_after { |status| step status_service, in: [status: -> { status }] }.result).to be_success.with_data(values: [[:success], [:success], [:success]])
          expect(service.collection(enumerator([:success, :success, :success])).slice_after { |status| step status_service, in: [status: -> { status }] }.result).to be_success.with_data(values: [[:success], [:success], [:success]])
          expect(service.collection(lazy_enumerator([:success, :success, :success])).slice_after { |status| step status_service, in: [status: -> { status }] }.result).to be_success.with_data(values: [[:success], [:success], [:success]])
          expect(service.collection(chain_enumerator([:success, :success, :success])).slice_after { |status| step status_service, in: [status: -> { status }] }.result).to be_success.with_data(values: [[:success], [:success], [:success]])
          expect(service.collection([:success, :success, :success]).slice_after { |status| step status_service, in: [status: -> { status }] }.result).to be_success.with_data(values: [[:success], [:success], [:success]])
          expect(service.collection(set([:success])).slice_after { |status| step status_service, in: [status: -> { status }] }.result).to be_success.with_data(values: [[:success]])
          expect(service.collection({success: :success}).slice_after { |(key, value)| step status_service, in: [status: -> { value }] }.result).to be_success.with_data(values: [[[:success, :success]]])
          expect(service.collection((:success..:success)).slice_after { |status| step status_service, in: [status: -> { status }] }.result).to be_success.with_data(values: [[:success]])

          # NOTE: Step with one output.
          expect(service.collection(enumerable([:success, :success, :success])).slice_after { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(values: [[:success], [:success], [:success]])
          expect(service.collection(enumerator([:success, :success, :success])).slice_after { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(values: [[:success], [:success], [:success]])
          expect(service.collection(lazy_enumerator([:success, :success, :success])).slice_after { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(values: [[:success], [:success], [:success]])
          expect(service.collection(chain_enumerator([:success, :success, :success])).slice_after { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(values: [[:success], [:success], [:success]])
          expect(service.collection([:success, :success, :success]).slice_after { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(values: [[:success], [:success], [:success]])
          expect(service.collection(set([:success])).slice_after { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(values: [[:success]])
          expect(service.collection({success: :success}).slice_after { |(key, value)| step status_service, in: [status: -> { value }], out: :status_string }.result).to be_success.with_data(values: [[[:success, :success]]])
          expect(service.collection((:success..:success)).slice_after { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(values: [[:success]])

          # NOTE: Step with multiple outputs.
          expect(service.collection(enumerable([:success, :success, :success])).slice_after { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [[:success], [:success], [:success]])
          expect(service.collection(enumerator([:success, :success, :success])).slice_after { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [[:success], [:success], [:success]])
          expect(service.collection(lazy_enumerator([:success, :success, :success])).slice_after { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [[:success], [:success], [:success]])
          expect(service.collection(chain_enumerator([:success, :success, :success])).slice_after { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [[:success], [:success], [:success]])
          expect(service.collection([:success, :success, :success]).slice_after { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [[:success], [:success], [:success]])
          expect(service.collection(set([:success])).slice_after { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [[:success]])
          expect(service.collection({success: :success}).slice_after { |(key, value)| step status_service, in: [status: -> { value }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [[[:success, :success]]])
          expect(service.collection((:success..:success)).slice_after { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [[:success]])

          # NOTE: Error result.
          expect(service.collection(enumerable([:success, :error, :exception])).slice_after { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection(enumerator([:success, :error, :exception])).slice_after { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection(lazy_enumerator([:success, :error, :exception])).slice_after { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection(chain_enumerator([:success, :error, :exception])).slice_after { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection([:success, :error, :exception]).slice_after { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection(set([:success, :error, :exception])).slice_after { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection({success: :success, error: :error, exception: :exception}).slice_after { |(key, value)| step status_service, in: [status: -> { value }] }.result).to be_error.without_data
          expect(service.collection((:error..:error)).slice_after { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data

          # NOTE: Error propagation.
          expect(service.collection(enumerable([:success, :error, :exception])).select { |status| step status_service, in: [status: -> { status }] }.slice_after { |status| status == :success }.result).to be_error.without_data
          expect(service.collection(enumerator([:success, :error, :exception])).select { |status| step status_service, in: [status: -> { status }] }.slice_after { |status| status == :success }.result).to be_error.without_data
          expect(service.collection(lazy_enumerator([:success, :error, :exception])).select { |status| step status_service, in: [status: -> { status }] }.slice_after { |status| status == :success }.result).to be_error.without_data
          expect(service.collection(chain_enumerator([:success, :error, :exception])).select { |status| step status_service, in: [status: -> { status }] }.slice_after { |status| status == :success }.result).to be_error.without_data
          expect(service.collection([:success, :error, :exception]).select { |status| step status_service, in: [status: -> { status }] }.slice_after { |status| status == :success }.result).to be_error.without_data
          expect(service.collection(set([:success, :error, :exception])).select { |status| step status_service, in: [status: -> { status }] }.slice_after { |status| status == :success }.result).to be_error.without_data

          expect(service.collection({success: :success, error: :error, exception: :exception}).select { |key, value| step status_service, in: [status: -> { value }] }.slice_after { |key, value| value == :success }.result).to be_error.without_data
          expect(service.collection((:error..:error)).select { |status| step status_service, in: [status: -> { status }] }.slice_after { |status| status == :success }.result).to be_error.without_data

          # NOTE: Usage on terminal chaining.
          expect { service.collection(enumerable([:success, :exception, :exception])).first.slice_after { |status| status == :success }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection(enumerator([:success, :exception, :exception])).first.slice_after { |status| status == :success }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection(lazy_enumerator([:success, :exception, :exception])).first.slice_after { |status| status == :success }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection(chain_enumerator([:success, :exception, :exception])).first.slice_after { |status| status == :success }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection([:success, :exception, :exception]).first.slice_after { |status| status == :success }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection(set([:success, :exception, :exception])).first.slice_after { |status| status == :success }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)

          expect { service.collection({success: :success, exception: :exception}).first.slice_after { |key, value| value == :success }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection((:success..:success)).first.slice_after { |status| status == :success }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
        end
      end

      describe "#slice_before" do
        specify do
          # NOTE: Empty collection.
          expect([].slice_before { |number| number % 3 == 0 }.to_a).to eq([])
          expect(service.collection(enumerable([])).slice_before { |number| number % 3 == 0 }.result).to be_success.with_data(values: [])
          expect(service.collection(enumerator([])).slice_before { |number| number % 3 == 0 }.result).to be_success.with_data(values: [])
          expect(service.collection(lazy_enumerator([])).slice_before { |number| number % 3 == 0 }.result).to be_success.with_data(values: [])
          expect(service.collection(chain_enumerator([])).slice_before { |number| number % 3 == 0 }.result).to be_success.with_data(values: [])
          expect(service.collection([]).slice_before { |number| number % 3 == 0 }.result).to be_success.with_data(values: [])
          expect(service.collection({}).slice_before { |key, value| value <= 2 }.result).to be_success.with_data(values: [])
          expect(service.collection((0...0)).slice_before { |number| number % 3 == 0 }.result).to be_success.with_data(values: [])
          expect(service.collection(set([])).slice_before { |number| number % 3 == 0 }.result).to be_success.with_data(values: [])

          # NOTE: No block, no pattern.
          expect { [0, 1, 2, 3, 4, 5].slice_before.to_a }.to raise_error(ArgumentError).with_message("wrong number of arguments (given 0, expected 1)")
          expect { service.collection(enumerable([0, 1, 2, 3, 4, 5])).slice_before.result }.to raise_error(ArgumentError).with_message("wrong number of arguments (given 0, expected 1)")
          expect { service.collection(enumerator([0, 1, 2, 3, 4, 5])).slice_before.result }.to raise_error(ArgumentError).with_message("wrong number of arguments (given 0, expected 1)")
          expect { service.collection(lazy_enumerator([0, 1, 2, 3, 4, 5])).slice_before.result }.to raise_error(ArgumentError).with_message("wrong number of arguments (given 0, expected 1)")
          expect { service.collection(chain_enumerator([0, 1, 2, 3, 4, 5])).slice_before.result }.to raise_error(ArgumentError).with_message("wrong number of arguments (given 0, expected 1)")
          expect { service.collection([0, 1, 2, 3, 4, 5]).slice_before.result }.to raise_error(ArgumentError).with_message("wrong number of arguments (given 0, expected 1)")
          expect { service.collection(set([0, 1, 2, 3, 4, 5])).slice_before.result }.to raise_error(ArgumentError).with_message("wrong number of arguments (given 0, expected 1)")
          expect { service.collection({0 => 0, 1 => 1, 2 => 2, 3 => 3, 4 => 4, 5 => 5}).slice_before.result }.to raise_error(ArgumentError).with_message("wrong number of arguments (given 0, expected 1)")
          expect { service.collection((0..5)).slice_before.result }.to raise_error(ArgumentError).with_message("wrong number of arguments (given 0, expected 1)")

          # NOTE: No block, pattern.
          expect([0, 1, 2, 3, 4, 5].slice_before({0 => true, 3 => true}.to_proc).to_a).to eq([[0, 1, 2], [3, 4, 5]])
          expect(service.collection(enumerable([0, 1, 2, 3, 4, 5])).slice_before({0 => true, 3 => true}.to_proc).result).to be_success.with_data(values: [[0, 1, 2], [3, 4, 5]])
          expect(service.collection(enumerator([0, 1, 2, 3, 4, 5])).slice_before({0 => true, 3 => true}.to_proc).result).to be_success.with_data(values: [[0, 1, 2], [3, 4, 5]])
          expect(service.collection(lazy_enumerator([0, 1, 2, 3, 4, 5])).slice_before({0 => true, 3 => true}.to_proc).result).to be_success.with_data(values: [[0, 1, 2], [3, 4, 5]])
          expect(service.collection(chain_enumerator([0, 1, 2, 3, 4, 5])).slice_before({0 => true, 3 => true}.to_proc).result).to be_success.with_data(values: [[0, 1, 2], [3, 4, 5]])
          expect(service.collection([0, 1, 2, 3, 4, 5]).slice_before({0 => true, 3 => true}.to_proc).result).to be_success.with_data(values: [[0, 1, 2], [3, 4, 5]])
          expect(service.collection(set([0, 1, 2, 3, 4, 5])).slice_before({0 => true, 3 => true}.to_proc).result).to be_success.with_data(values: [[0, 1, 2], [3, 4, 5]])
          expect(service.collection({0 => 0, 1 => 1, 2 => 2, 3 => 3, 4 => 4, 5 => 5}).slice_before({[0, 0] => true, [3, 3] => true}.to_proc).result).to be_success.with_data(values: [[[0, 0], [1, 1], [2, 2]], [[3, 3], [4, 4], [5, 5]]])
          expect(service.collection((0..5)).slice_before({0 => true, 3 => true}.to_proc).result).to be_success.with_data(values: [[0, 1, 2], [3, 4, 5]])

          # NOTE: Block, no pattern.
          expect([0, 1, 2, 3, 4, 5].slice_before { |number| number % 3 == 0 }.to_a).to eq([[0, 1, 2], [3, 4, 5]])
          expect(service.collection(enumerable([0, 1, 2, 3, 4, 5])).slice_before { |number| number % 3 == 0 }.result).to be_success.with_data(values: [[0, 1, 2], [3, 4, 5]])
          expect(service.collection(enumerator([0, 1, 2, 3, 4, 5])).slice_before { |number| number % 3 == 0 }.result).to be_success.with_data(values: [[0, 1, 2], [3, 4, 5]])
          expect(service.collection(lazy_enumerator([0, 1, 2, 3, 4, 5])).slice_before { |number| number % 3 == 0 }.result).to be_success.with_data(values: [[0, 1, 2], [3, 4, 5]])
          expect(service.collection(chain_enumerator([0, 1, 2, 3, 4, 5])).slice_before { |number| number % 3 == 0 }.result).to be_success.with_data(values: [[0, 1, 2], [3, 4, 5]])
          expect(service.collection([0, 1, 2, 3, 4, 5]).slice_before { |number| number % 3 == 0 }.result).to be_success.with_data(values: [[0, 1, 2], [3, 4, 5]])
          expect(service.collection(set([0, 1, 2, 3, 4, 5])).slice_before { |number| number % 3 == 0 }.result).to be_success.with_data(values: [[0, 1, 2], [3, 4, 5]])
          expect(service.collection({0 => 0, 1 => 1, 2 => 2, 3 => 3, 4 => 4, 5 => 5}).slice_before { |(key, value)| value % 3 == 0 }.result).to be_success.with_data(values: [[[0, 0], [1, 1], [2, 2]], [[3, 3], [4, 4], [5, 5]]])
          expect(service.collection((0..5)).slice_before { |number| number % 3 == 0 }.result).to be_success.with_data(values: [[0, 1, 2], [3, 4, 5]])

          # NOTE: Step with no outputs.
          expect(service.collection(enumerable([:success, :success, :success])).slice_before { |status| step status_service, in: [status: -> { status }] }.result).to be_success.with_data(values: [[:success], [:success], [:success]])
          expect(service.collection(enumerator([:success, :success, :success])).slice_before { |status| step status_service, in: [status: -> { status }] }.result).to be_success.with_data(values: [[:success], [:success], [:success]])
          expect(service.collection(lazy_enumerator([:success, :success, :success])).slice_before { |status| step status_service, in: [status: -> { status }] }.result).to be_success.with_data(values: [[:success], [:success], [:success]])
          expect(service.collection(chain_enumerator([:success, :success, :success])).slice_before { |status| step status_service, in: [status: -> { status }] }.result).to be_success.with_data(values: [[:success], [:success], [:success]])
          expect(service.collection([:success, :success, :success]).slice_before { |status| step status_service, in: [status: -> { status }] }.result).to be_success.with_data(values: [[:success], [:success], [:success]])
          expect(service.collection(set([:success])).slice_before { |status| step status_service, in: [status: -> { status }] }.result).to be_success.with_data(values: [[:success]])
          expect(service.collection({success: :success}).slice_before { |(key, value)| step status_service, in: [status: -> { value }] }.result).to be_success.with_data(values: [[[:success, :success]]])
          expect(service.collection((:success..:success)).slice_before { |status| step status_service, in: [status: -> { status }] }.result).to be_success.with_data(values: [[:success]])

          # NOTE: Step with one output.
          expect(service.collection(enumerable([:success, :success, :success])).slice_before { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(values: [[:success], [:success], [:success]])
          expect(service.collection(enumerator([:success, :success, :success])).slice_before { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(values: [[:success], [:success], [:success]])
          expect(service.collection(lazy_enumerator([:success, :success, :success])).slice_before { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(values: [[:success], [:success], [:success]])
          expect(service.collection(chain_enumerator([:success, :success, :success])).slice_before { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(values: [[:success], [:success], [:success]])
          expect(service.collection([:success, :success, :success]).slice_before { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(values: [[:success], [:success], [:success]])
          expect(service.collection(set([:success])).slice_before { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(values: [[:success]])
          expect(service.collection({success: :success}).slice_before { |(key, value)| step status_service, in: [status: -> { value }], out: :status_string }.result).to be_success.with_data(values: [[[:success, :success]]])
          expect(service.collection((:success..:success)).slice_before { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(values: [[:success]])

          # NOTE: Step with multiple outputs.
          expect(service.collection(enumerable([:success, :success, :success])).slice_before { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [[:success], [:success], [:success]])
          expect(service.collection(enumerator([:success, :success, :success])).slice_before { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [[:success], [:success], [:success]])
          expect(service.collection(lazy_enumerator([:success, :success, :success])).slice_before { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [[:success], [:success], [:success]])
          expect(service.collection(chain_enumerator([:success, :success, :success])).slice_before { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [[:success], [:success], [:success]])
          expect(service.collection([:success, :success, :success]).slice_before { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [[:success], [:success], [:success]])
          expect(service.collection(set([:success])).slice_before { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [[:success]])
          expect(service.collection({success: :success}).slice_before { |(key, value)| step status_service, in: [status: -> { value }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [[[:success, :success]]])
          expect(service.collection((:success..:success)).slice_before { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [[:success]])

          # NOTE: Error result.
          expect(service.collection(enumerable([:success, :error, :exception])).slice_before { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection(enumerator([:success, :error, :exception])).slice_before { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection(lazy_enumerator([:success, :error, :exception])).slice_before { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection(chain_enumerator([:success, :error, :exception])).slice_before { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection([:success, :error, :exception]).slice_before { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection(set([:success, :error, :exception])).slice_before { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection({success: :success, error: :error, exception: :exception}).slice_before { |(key, value)| step status_service, in: [status: -> { value }] }.result).to be_error.without_data
          expect(service.collection((:error..:error)).slice_before { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data

          # NOTE: Error propagation.
          expect(service.collection(enumerable([:success, :error, :exception])).select { |status| step status_service, in: [status: -> { status }] }.slice_before { |status| status == :success }.result).to be_error.without_data
          expect(service.collection(enumerator([:success, :error, :exception])).select { |status| step status_service, in: [status: -> { status }] }.slice_before { |status| status == :success }.result).to be_error.without_data
          expect(service.collection(lazy_enumerator([:success, :error, :exception])).select { |status| step status_service, in: [status: -> { status }] }.slice_before { |status| status == :success }.result).to be_error.without_data
          expect(service.collection(chain_enumerator([:success, :error, :exception])).select { |status| step status_service, in: [status: -> { status }] }.slice_before { |status| status == :success }.result).to be_error.without_data
          expect(service.collection([:success, :error, :exception]).select { |status| step status_service, in: [status: -> { status }] }.slice_before { |status| status == :success }.result).to be_error.without_data
          expect(service.collection(set([:success, :error, :exception])).select { |status| step status_service, in: [status: -> { status }] }.slice_before { |status| status == :success }.result).to be_error.without_data

          expect(service.collection({success: :success, error: :error, exception: :exception}).select { |key, value| step status_service, in: [status: -> { value }] }.slice_before { |key, value| value == :success }.result).to be_error.without_data
          expect(service.collection((:error..:error)).select { |status| step status_service, in: [status: -> { status }] }.slice_before { |status| status == :success }.result).to be_error.without_data

          # NOTE: Usage on terminal chaining.
          expect { service.collection(enumerable([:success, :exception, :exception])).first.slice_before { |status| status == :success }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection(enumerator([:success, :exception, :exception])).first.slice_before { |status| status == :success }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection(lazy_enumerator([:success, :exception, :exception])).first.slice_before { |status| status == :success }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection(chain_enumerator([:success, :exception, :exception])).first.slice_before { |status| status == :success }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection([:success, :exception, :exception]).first.slice_before { |status| status == :success }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection(set([:success, :exception, :exception])).first.slice_before { |status| status == :success }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)

          expect { service.collection({success: :success, exception: :exception}).first.slice_before { |key, value| value == :success }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection((:success..:success)).first.slice_before { |status| status == :success }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
        end
      end

      describe "#slice_when" do
        specify do
          # NOTE: Empty collection.
          expect([].slice_when { |number| number % 3 == 0 }.to_a).to eq([])
          expect(service.collection(enumerable([])).slice_when { |number| number % 3 == 0 }.result).to be_success.with_data(values: [])
          expect(service.collection(enumerator([])).slice_when { |number| number % 3 == 0 }.result).to be_success.with_data(values: [])
          expect(service.collection(lazy_enumerator([])).slice_when { |number| number % 3 == 0 }.result).to be_success.with_data(values: [])
          expect(service.collection(chain_enumerator([])).slice_when { |number| number % 3 == 0 }.result).to be_success.with_data(values: [])
          expect(service.collection([]).slice_when { |number| number % 3 == 0 }.result).to be_success.with_data(values: [])
          expect(service.collection({}).slice_when { |key, value| value <= 2 }.result).to be_success.with_data(values: [])
          expect(service.collection((0...0)).slice_when { |number| number % 3 == 0 }.result).to be_success.with_data(values: [])
          expect(service.collection(set([])).slice_when { |number| number % 3 == 0 }.result).to be_success.with_data(values: [])

          # NOTE: No block.
          expect { [0, 1, 2, 3, 4, 5].slice_when.to_a }.to raise_error(ArgumentError).with_message("tried to create Proc object without a block")
          expect { service.collection(enumerable([0, 1, 2, 3, 4, 5])).slice_when.result }.to raise_error(ArgumentError).with_message("tried to create Proc object without a block")
          expect { service.collection(enumerator([0, 1, 2, 3, 4, 5])).slice_when.result }.to raise_error(ArgumentError).with_message("tried to create Proc object without a block")
          expect { service.collection(lazy_enumerator([0, 1, 2, 3, 4, 5])).slice_when.result }.to raise_error(ArgumentError).with_message("tried to create Proc object without a block")
          expect { service.collection(chain_enumerator([0, 1, 2, 3, 4, 5])).slice_when.result }.to raise_error(ArgumentError).with_message("tried to create Proc object without a block")
          expect { service.collection([0, 1, 2, 3, 4, 5]).slice_when.result }.to raise_error(ArgumentError).with_message("tried to create Proc object without a block")
          expect { service.collection(set([0, 1, 2, 3, 4, 5])).slice_when.result }.to raise_error(ArgumentError).with_message("tried to create Proc object without a block")
          expect { service.collection({0 => 0, 1 => 1, 2 => 2, 3 => 3, 4 => 4, 5 => 5}).slice_when.result }.to raise_error(ArgumentError).with_message("tried to create Proc object without a block")
          expect { service.collection((0..5)).slice_when.result }.to raise_error(ArgumentError).with_message("tried to create Proc object without a block")

          # NOTE: Block with one argument.
          expect([0, 1, 2, 3, 4, 5].slice_when { |number| number % 3 == 0 }.to_a).to eq([[0], [1, 2, 3], [4, 5]])
          expect(service.collection(enumerable([0, 1, 2, 3, 4, 5])).slice_when { |number| number % 3 == 0 }.result).to be_success.with_data(values: [[0], [1, 2, 3], [4, 5]])
          expect(service.collection(enumerator([0, 1, 2, 3, 4, 5])).slice_when { |number| number % 3 == 0 }.result).to be_success.with_data(values: [[0], [1, 2, 3], [4, 5]])
          expect(service.collection(lazy_enumerator([0, 1, 2, 3, 4, 5])).slice_when { |number| number % 3 == 0 }.result).to be_success.with_data(values: [[0], [1, 2, 3], [4, 5]])
          expect(service.collection(chain_enumerator([0, 1, 2, 3, 4, 5])).slice_when { |number| number % 3 == 0 }.result).to be_success.with_data(values: [[0], [1, 2, 3], [4, 5]])
          expect(service.collection([0, 1, 2, 3, 4, 5]).slice_when { |number| number % 3 == 0 }.result).to be_success.with_data(values: [[0], [1, 2, 3], [4, 5]])
          expect(service.collection(set([0, 1, 2, 3, 4, 5])).slice_when { |number| number % 3 == 0 }.result).to be_success.with_data(values: [[0], [1, 2, 3], [4, 5]])
          expect(service.collection({0 => 0, 1 => 1, 2 => 2, 3 => 3, 4 => 4, 5 => 5}).slice_when { |(key, value)| value % 3 == 0 }.result).to be_success.with_data(values: [[[0, 0]], [[1, 1], [2, 2], [3, 3]], [[4, 4], [5, 5]]])
          expect(service.collection((0..5)).slice_when { |number| number % 3 == 0 }.result).to be_success.with_data(values: [[0], [1, 2, 3], [4, 5]])

          # NOTE: Block with multiple arguments.
          expect([0, 1, 2, 3, 4, 5].slice_when { |number, other_number| (number + other_number) % 3 == 0 }.to_a).to eq([[0, 1], [2, 3, 4], [5]])
          expect(service.collection(enumerable([0, 1, 2, 3, 4, 5])).slice_when { |number, other_number| (number + other_number) % 3 == 0 }.result).to be_success.with_data(values: [[0, 1], [2, 3, 4], [5]])
          expect(service.collection(enumerator([0, 1, 2, 3, 4, 5])).slice_when { |number, other_number| (number + other_number) % 3 == 0 }.result).to be_success.with_data(values: [[0, 1], [2, 3, 4], [5]])
          expect(service.collection(lazy_enumerator([0, 1, 2, 3, 4, 5])).slice_when { |number, other_number| (number + other_number) % 3 == 0 }.result).to be_success.with_data(values: [[0, 1], [2, 3, 4], [5]])
          expect(service.collection(chain_enumerator([0, 1, 2, 3, 4, 5])).slice_when { |number, other_number| (number + other_number) % 3 == 0 }.result).to be_success.with_data(values: [[0, 1], [2, 3, 4], [5]])
          expect(service.collection([0, 1, 2, 3, 4, 5]).slice_when { |number, other_number| (number + other_number) % 3 == 0 }.result).to be_success.with_data(values: [[0, 1], [2, 3, 4], [5]])
          expect(service.collection(set([0, 1, 2, 3, 4, 5])).slice_when { |number, other_number| (number + other_number) % 3 == 0 }.result).to be_success.with_data(values: [[0, 1], [2, 3, 4], [5]])
          expect(service.collection({0 => 0, 1 => 1, 2 => 2, 3 => 3, 4 => 4, 5 => 5}).slice_when { |(key, value), (other_key, other_value)| (value + other_value) % 3 == 0 }.result).to be_success.with_data(values: [[[0, 0], [1, 1]], [[2, 2], [3, 3], [4, 4]], [[5, 5]]])
          expect(service.collection((0..5)).slice_when { |number, other_number| (number + other_number) % 3 == 0 }.result).to be_success.with_data(values: [[0, 1], [2, 3, 4], [5]])

          # NOTE: Step with no outputs.
          expect(service.collection(enumerable([:success, :success, :success])).slice_when { |status| step status_service, in: [status: -> { status }] }.result).to be_success.with_data(values: [[:success], [:success], [:success]])
          expect(service.collection(enumerator([:success, :success, :success])).slice_when { |status| step status_service, in: [status: -> { status }] }.result).to be_success.with_data(values: [[:success], [:success], [:success]])
          expect(service.collection(lazy_enumerator([:success, :success, :success])).slice_when { |status| step status_service, in: [status: -> { status }] }.result).to be_success.with_data(values: [[:success], [:success], [:success]])
          expect(service.collection(chain_enumerator([:success, :success, :success])).slice_when { |status| step status_service, in: [status: -> { status }] }.result).to be_success.with_data(values: [[:success], [:success], [:success]])
          expect(service.collection([:success, :success, :success]).slice_when { |status| step status_service, in: [status: -> { status }] }.result).to be_success.with_data(values: [[:success], [:success], [:success]])
          expect(service.collection(set([:success])).slice_when { |status| step status_service, in: [status: -> { status }] }.result).to be_success.with_data(values: [[:success]])
          expect(service.collection({success: :success}).slice_when { |(key, value)| step status_service, in: [status: -> { value }] }.result).to be_success.with_data(values: [[[:success, :success]]])
          expect(service.collection((:success..:success)).slice_when { |status| step status_service, in: [status: -> { status }] }.result).to be_success.with_data(values: [[:success]])

          # NOTE: Step with one output.
          expect(service.collection(enumerable([:success, :success, :success])).slice_when { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(values: [[:success], [:success], [:success]])
          expect(service.collection(enumerator([:success, :success, :success])).slice_when { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(values: [[:success], [:success], [:success]])
          expect(service.collection(lazy_enumerator([:success, :success, :success])).slice_when { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(values: [[:success], [:success], [:success]])
          expect(service.collection(chain_enumerator([:success, :success, :success])).slice_when { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(values: [[:success], [:success], [:success]])
          expect(service.collection([:success, :success, :success]).slice_when { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(values: [[:success], [:success], [:success]])
          expect(service.collection(set([:success])).slice_when { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(values: [[:success]])
          expect(service.collection({success: :success}).slice_when { |(key, value)| step status_service, in: [status: -> { value }], out: :status_string }.result).to be_success.with_data(values: [[[:success, :success]]])
          expect(service.collection((:success..:success)).slice_when { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(values: [[:success]])

          # NOTE: Step with multiple outputs.
          expect(service.collection(enumerable([:success, :success, :success])).slice_when { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [[:success], [:success], [:success]])
          expect(service.collection(enumerator([:success, :success, :success])).slice_when { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [[:success], [:success], [:success]])
          expect(service.collection(lazy_enumerator([:success, :success, :success])).slice_when { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [[:success], [:success], [:success]])
          expect(service.collection(chain_enumerator([:success, :success, :success])).slice_when { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [[:success], [:success], [:success]])
          expect(service.collection([:success, :success, :success]).slice_when { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [[:success], [:success], [:success]])
          expect(service.collection(set([:success])).slice_when { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [[:success]])
          expect(service.collection({success: :success}).slice_when { |(key, value)| step status_service, in: [status: -> { value }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [[[:success, :success]]])
          expect(service.collection((:success..:success)).slice_when { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [[:success]])

          # NOTE: Error result.
          expect(service.collection(enumerable([:success, :error, :exception])).slice_when { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection(enumerator([:success, :error, :exception])).slice_when { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection(lazy_enumerator([:success, :error, :exception])).slice_when { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection(chain_enumerator([:success, :error, :exception])).slice_when { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection([:success, :error, :exception]).slice_when { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection(set([:success, :error, :exception])).slice_when { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection({success: :success, error: :error, exception: :exception}).slice_when { |(key, value)| step status_service, in: [status: -> { value }] }.result).to be_error.without_data
          expect((:error..:error).slice_when { raise }.to_a).to eq([[:error]])
          expect(service.collection((:error..:error)).slice_when { |status| step status_service, in: [status: -> { status }] }.result).to be_success.with_data(values: [[:error]])

          # NOTE: Error propagation.
          expect(service.collection(enumerable([:success, :error, :exception])).select { |status| step status_service, in: [status: -> { status }] }.slice_when { |status| status == :success }.result).to be_error.without_data
          expect(service.collection(enumerator([:success, :error, :exception])).select { |status| step status_service, in: [status: -> { status }] }.slice_when { |status| status == :success }.result).to be_error.without_data
          expect(service.collection(lazy_enumerator([:success, :error, :exception])).select { |status| step status_service, in: [status: -> { status }] }.slice_when { |status| status == :success }.result).to be_error.without_data
          expect(service.collection(chain_enumerator([:success, :error, :exception])).select { |status| step status_service, in: [status: -> { status }] }.slice_when { |status| status == :success }.result).to be_error.without_data
          expect(service.collection([:success, :error, :exception]).select { |status| step status_service, in: [status: -> { status }] }.slice_when { |status| status == :success }.result).to be_error.without_data
          expect(service.collection(set([:success, :error, :exception])).select { |status| step status_service, in: [status: -> { status }] }.slice_when { |status| status == :success }.result).to be_error.without_data

          expect(service.collection({success: :success, error: :error, exception: :exception}).select { |key, value| step status_service, in: [status: -> { value }] }.slice_when { |key, value| value == :success }.result).to be_error.without_data
          expect(service.collection((:error..:error)).select { |status| step status_service, in: [status: -> { status }] }.slice_when { |status| status == :success }.result).to be_error.without_data

          # NOTE: Usage on terminal chaining.
          expect { service.collection(enumerable([:success, :exception, :exception])).first.slice_when { |status| status == :success }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection(enumerator([:success, :exception, :exception])).first.slice_when { |status| status == :success }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection(lazy_enumerator([:success, :exception, :exception])).first.slice_when { |status| status == :success }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection(chain_enumerator([:success, :exception, :exception])).first.slice_when { |status| status == :success }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection([:success, :exception, :exception]).first.slice_when { |status| status == :success }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection(set([:success, :exception, :exception])).first.slice_when { |status| status == :success }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)

          expect { service.collection({success: :success, exception: :exception}).first.slice_when { |key, value| value == :success }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection((:success..:success)).first.slice_when { |status| status == :success }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
        end
      end

      describe "#sort" do
        specify do
          # NOTE: Empty collection.
          expect([].sort { |number, other_number| number <=> other_number }).to eq([])
          expect(service.collection(enumerable([])).sort { |number, other_number| number <=> other_number }.result).to be_success.with_data(values: [])
          expect(service.collection(enumerator([])).sort { |number, other_number| number <=> other_number }.result).to be_success.with_data(values: [])
          expect(service.collection(lazy_enumerator([])).sort { |number, other_number| number <=> other_number }.result).to be_success.with_data(values: [])
          expect(service.collection(chain_enumerator([])).sort { |number, other_number| number <=> other_number }.result).to be_success.with_data(values: [])
          expect(service.collection([]).sort { |number, other_number| number <=> other_number }.result).to be_success.with_data(values: [])
          expect(service.collection(set([])).sort { |number, other_number| number <=> other_number }.result).to be_success.with_data(values: [])
          expect(service.collection({}).sort { |number, other_number| number <=> other_number }.result).to be_success.with_data(values: [])
          expect(service.collection((:success...:success)).sort { |number, other_number| number <=> other_number }.result).to be_success.with_data(values: [])

          # NOTE: No block.
          expect([3, 2, 4, 5, 1].sort.to_a).to eq([1, 2, 3, 4, 5])
          expect(service.collection(enumerable([3, 2, 4, 5, 1])).sort.result).to be_success.with_data(values: [1, 2, 3, 4, 5])
          expect(service.collection(enumerator([3, 2, 4, 5, 1])).sort.result).to be_success.with_data(values: [1, 2, 3, 4, 5])
          expect(service.collection(lazy_enumerator([3, 2, 4, 5, 1])).sort.result).to be_success.with_data(values: [1, 2, 3, 4, 5])
          expect(service.collection(chain_enumerator([3, 2, 4, 5, 1])).sort.result).to be_success.with_data(values: [1, 2, 3, 4, 5])
          expect(service.collection([3, 2, 4, 5, 1]).sort.result).to be_success.with_data(values: [1, 2, 3, 4, 5])

          expect(service.collection(set([3, 2, 4, 5, 1])).sort.result).to be_success.with_data(values: [1, 2, 3, 4, 5])
          expect(service.collection({3 => 3, 2 => 2, 4 => 4, 5 => 5, 1 => 1}).sort.result).to be_success.with_data(values: [[1, 1], [2, 2], [3, 3], [4, 4], [5, 5]])
          expect(service.collection((1..5)).sort.result).to be_success.with_data(values: [1, 2, 3, 4, 5])

          # NOTE: Block.
          expect([3, 2, 4, 5, 1].sort { |number, other_number| number <=> other_number }).to eq([1, 2, 3, 4, 5])
          expect(service.collection(enumerable([3, 2, 4, 5, 1])).sort { |number, other_number| number <=> other_number }.result).to be_success.with_data(values: [1, 2, 3, 4, 5])
          expect(service.collection(enumerator([3, 2, 4, 5, 1])).sort { |number, other_number| number <=> other_number }.result).to be_success.with_data(values: [1, 2, 3, 4, 5])
          expect(service.collection(lazy_enumerator([3, 2, 4, 5, 1])).sort { |number, other_number| number <=> other_number }.result).to be_success.with_data(values: [1, 2, 3, 4, 5])
          expect(service.collection(chain_enumerator([3, 2, 4, 5, 1])).sort { |number, other_number| number <=> other_number }.result).to be_success.with_data(values: [1, 2, 3, 4, 5])
          expect(service.collection([3, 2, 4, 5, 1]).sort { |number, other_number| number <=> other_number }.result).to be_success.with_data(values: [1, 2, 3, 4, 5])

          expect(service.collection(set([3, 2, 4, 5, 1])).sort { |number, other_number| number <=> other_number }.result).to be_success.with_data(values: [1, 2, 3, 4, 5])
          expect(service.collection({3 => 3, 2 => 2, 4 => 4, 5 => 5, 1 => 1}).sort { |number, other_number| number <=> other_number }.result).to be_success.with_data(values: [[1, 1], [2, 2], [3, 3], [4, 4], [5, 5]])
          expect(service.collection((1..5)).sort { |number, other_number| number <=> other_number }.result).to be_success.with_data(values: [1, 2, 3, 4, 5])

          # NOTE: Step with no outputs.

          expect { service.collection(enumerable([3, 2, 4, 5, 1])).sort { |number, other_number| step compare_numbers_service, in: [number: -> { number }, other_number: -> { other_number }] }.result }.to raise_error(NoMethodError).with_message("undefined method '>' for true")
          expect { service.collection(enumerator([3, 2, 4, 5, 1])).sort { |number, other_number| step compare_numbers_service, in: [number: -> { number }, other_number: -> { other_number }] }.result }.to raise_error(NoMethodError).with_message("undefined method '>' for true")
          expect { service.collection(lazy_enumerator([3, 2, 4, 5, 1])).sort { |number, other_number| step compare_numbers_service, in: [number: -> { number }, other_number: -> { other_number }] }.result }.to raise_error(NoMethodError).with_message("undefined method '>' for true")
          expect { service.collection(chain_enumerator([3, 2, 4, 5, 1])).sort { |number, other_number| step compare_numbers_service, in: [number: -> { number }, other_number: -> { other_number }] }.result }.to raise_error(NoMethodError).with_message("undefined method '>' for true")
          expect { service.collection([3, 2, 4, 5, 1]).sort { |number, other_number| step compare_numbers_service, in: [number: -> { number }, other_number: -> { other_number }] }.result }.to raise_error(NoMethodError).with_message("undefined method '>' for true")

          expect { service.collection(set([3, 2, 4, 5, 1])).sort { |number, other_number| step compare_numbers_service, in: [number: -> { number }, other_number: -> { other_number }] }.result }.to raise_error(NoMethodError).with_message("undefined method '>' for true")
          expect { service.collection({3 => 3, 2 => 2, 4 => 4, 5 => 5, 1 => 1}).sort { |number, other_number| step compare_numbers_service, in: [number: -> { number }, other_number: -> { other_number }] }.result }.to raise_error(NoMethodError).with_message("undefined method '>' for true")
          expect { service.collection((1..5)).sort { |number, other_number| step compare_numbers_service, in: [number: -> { number }, other_number: -> { other_number }] }.result }.to raise_error(NoMethodError).with_message("undefined method '>' for true")

          # NOTE: Step with one output.
          expect(service.collection(enumerable([3, 2, 4, 5, 1])).sort { |number, other_number| step compare_numbers_service, in: [number: -> { number }, other_number: -> { other_number }], out: :integer }.result).to be_success.with_data(values: [1, 2, 3, 4, 5])
          expect(service.collection(enumerator([3, 2, 4, 5, 1])).sort { |number, other_number| step compare_numbers_service, in: [number: -> { number }, other_number: -> { other_number }], out: :integer }.result).to be_success.with_data(values: [1, 2, 3, 4, 5])
          expect(service.collection(lazy_enumerator([3, 2, 4, 5, 1])).sort { |number, other_number| step compare_numbers_service, in: [number: -> { number }, other_number: -> { other_number }], out: :integer }.result).to be_success.with_data(values: [1, 2, 3, 4, 5])
          expect(service.collection(chain_enumerator([3, 2, 4, 5, 1])).sort { |number, other_number| step compare_numbers_service, in: [number: -> { number }, other_number: -> { other_number }], out: :integer }.result).to be_success.with_data(values: [1, 2, 3, 4, 5])
          expect(service.collection([3, 2, 4, 5, 1]).sort { |number, other_number| step compare_numbers_service, in: [number: -> { number }, other_number: -> { other_number }], out: :integer }.result).to be_success.with_data(values: [1, 2, 3, 4, 5])

          expect(service.collection(set([3, 2, 4, 5, 1])).sort { |number, other_number| step compare_numbers_service, in: [number: -> { number }, other_number: -> { other_number }], out: :integer }.result).to be_success.with_data(values: [1, 2, 3, 4, 5])
          expect(service.collection({3 => 3, 2 => 2, 4 => 4, 5 => 5, 1 => 1}).sort { |number, other_number| step compare_numbers_service, in: [number: -> { number }, other_number: -> { other_number }], out: :integer }.result).to be_success.with_data(values: [[1, 1], [2, 2], [3, 3], [4, 4], [5, 5]])
          expect(service.collection((1..5)).sort { |number, other_number| step compare_numbers_service, in: [number: -> { number }, other_number: -> { other_number }], out: :integer }.result).to be_success.with_data(values: [1, 2, 3, 4, 5])

          # NOTE: Step with multiple outputs.
          expect { service.collection(enumerable([3, 2, 4, 5, 1])).sort { |number, other_number| step compare_numbers_service, in: [number: -> { number }, other_number: -> { other_number }], out: [:integer, :operator] }.result }.to raise_error(TypeError).with_message("no implicit conversion of Integer into Hash")
          expect { service.collection(enumerator([3, 2, 4, 5, 1])).sort { |number, other_number| step compare_numbers_service, in: [number: -> { number }, other_number: -> { other_number }], out: [:integer, :operator] }.result }.to raise_error(TypeError).with_message("no implicit conversion of Integer into Hash")
          expect { service.collection(lazy_enumerator([3, 2, 4, 5, 1])).sort { |number, other_number| step compare_numbers_service, in: [number: -> { number }, other_number: -> { other_number }], out: [:integer, :operator] }.result }.to raise_error(TypeError).with_message("no implicit conversion of Integer into Hash")
          expect { service.collection(chain_enumerator([3, 2, 4, 5, 1])).sort { |number, other_number| step compare_numbers_service, in: [number: -> { number }, other_number: -> { other_number }], out: [:integer, :operator] }.result }.to raise_error(TypeError).with_message("no implicit conversion of Integer into Hash")
          expect { service.collection([3, 2, 4, 5, 1]).sort { |number, other_number| step compare_numbers_service, in: [number: -> { number }, other_number: -> { other_number }], out: [:integer, :operator] }.result }.to raise_error(TypeError).with_message("no implicit conversion of Integer into Hash")

          expect { service.collection(set([3, 2, 4, 5, 1])).sort { |number, other_number| step compare_numbers_service, in: [number: -> { number }, other_number: -> { other_number }], out: [:integer, :operator] }.result }.to raise_error(TypeError).with_message("no implicit conversion of Integer into Hash")
          expect { service.collection({3 => 3, 2 => 2, 4 => 4, 5 => 5, 1 => 1}).sort { |number, other_number| step compare_numbers_service, in: [number: -> { number }, other_number: -> { other_number }], out: [:integer, :operator] }.result }.to raise_error(TypeError).with_message("no implicit conversion of Integer into Hash")
          expect { service.collection((1..5)).sort { |number, other_number| step compare_numbers_service, in: [number: -> { number }, other_number: -> { other_number }], out: [:integer, :operator] }.result }.to raise_error(TypeError).with_message("no implicit conversion of Integer into Hash")

          # NOTE: Error result.
          expect(service.collection(enumerable([1, -1, :exception])).sort { |number, other_number| step compare_numbers_service, in: [number: -> { number }, other_number: -> { other_number }], out: :integer }.result).to be_error.without_data
          expect(service.collection(enumerator([1, -1, :exception])).sort { |number, other_number| step compare_numbers_service, in: [number: -> { number }, other_number: -> { other_number }], out: :integer }.result).to be_error.without_data
          expect(service.collection(lazy_enumerator([1, -1, :exception])).sort { |number, other_number| step compare_numbers_service, in: [number: -> { number }, other_number: -> { other_number }], out: :integer }.result).to be_error.without_data
          expect(service.collection(chain_enumerator([1, -1, :exception])).sort { |number, other_number| step compare_numbers_service, in: [number: -> { number }, other_number: -> { other_number }], out: :integer }.result).to be_error.without_data
          expect(service.collection([1, -1, :exception]).sort { |number, other_number| step compare_numbers_service, in: [number: -> { number }, other_number: -> { other_number }], out: :integer }.result).to be_error.without_data

          expect(service.collection(set([1, -1, :exception])).sort { |number, other_number| step compare_numbers_service, in: [number: -> { number }, other_number: -> { other_number }], out: :integer }.result).to be_error.without_data
          expect(service.collection({1 => 1, -1 => -1, :exception => :exception}).sort { |hash, other_hash| step compare_numbers_service, in: [number: -> { hash.last }, other_number: -> { other_hash.last }], out: :integer }.result).to be_error.without_data
          expect((-1..-1).sort).to eq([-1])
          expect(service.collection((-1..-1)).sort { |number, other_number| step compare_numbers_service, in: [number: -> { number }, other_number: -> { other_number }], out: :integer }.result).to be_success.with_data(values: [-1])

          # NOTE: Error propagation.
          expect(service.collection(enumerable([:success, :error, :exception])).filter { |status| step status_service, in: [status: -> { status }] }.sort.result).to be_error.without_data
          expect(service.collection(enumerator([:success, :error, :exception])).filter { |status| step status_service, in: [status: -> { status }] }.sort.result).to be_error.without_data
          expect(service.collection(lazy_enumerator([:success, :error, :exception])).filter { |status| step status_service, in: [status: -> { status }] }.sort.result).to be_error.without_data
          expect(service.collection(chain_enumerator([:success, :error, :exception])).filter { |status| step status_service, in: [status: -> { status }] }.sort.result).to be_error.without_data
          expect(service.collection([:success, :error, :exception]).filter { |status| step status_service, in: [status: -> { status }] }.sort.result).to be_error.without_data

          expect(service.collection(set([:success, :error, :exception])).filter { |status| step status_service, in: [status: -> { status }] }.sort.result).to be_error.without_data
          expect(service.collection({success: :success, error: :error, exception: :exception}).filter { |key, value| step status_service, in: [status: -> { value }] }.sort.result).to be_error.without_data
          expect(service.collection((:error..:error)).filter { |status| step status_service, in: [status: -> { status }] }.sort.result).to be_error.without_data

          # NOTE: Usage on terminal chaining.
          expect { service.collection(enumerable([:success, :exception, :exception])).first.sort.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection(enumerator([:success, :exception, :exception])).first.sort.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection(lazy_enumerator([:success, :exception, :exception])).first.sort.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection(chain_enumerator([:success, :exception, :exception])).first.sort.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection([:success, :exception, :exception]).first.sort.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)

          expect { service.collection(set([:success, :exception, :exception])).first.sort.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection({success: :success, exception: :exception}).first.sort.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection((:success..:success)).first.sort.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
        end
      end

      describe "#sort_by" do
        specify do
          # NOTE: Empty collection.
          expect([].sort_by { |number| number.to_s.ord }).to eq([])
          expect(service.collection(enumerable([])).sort_by { |number| number.to_s.ord }.result).to be_success.with_data(values: [])
          expect(service.collection(enumerator([])).sort_by { |number| number.to_s.ord }.result).to be_success.with_data(values: [])
          expect(service.collection(lazy_enumerator([])).sort_by { |number| number.to_s.ord }.result).to be_success.with_data(values: [])
          expect(service.collection(chain_enumerator([])).sort_by { |number| number.to_s.ord }.result).to be_success.with_data(values: [])
          expect(service.collection([]).sort_by { |number| number.to_s.ord }.result).to be_success.with_data(values: [])
          expect(service.collection(set([])).sort_by { |number| number.to_s.ord }.result).to be_success.with_data(values: [])
          expect(service.collection({}).sort_by { |number| number.to_s.ord }.result).to be_success.with_data(values: [])
          expect(service.collection((:success...:success)).sort_by { |number| number.to_s.ord }.result).to be_success.with_data(values: [])

          # NOTE: No block.
          expect([3, 2, 4, 5, 1].sort_by.to_a).to eq([3, 2, 4, 5, 1])
          expect(service.collection(enumerable([3, 2, 4, 5, 1])).sort_by.result).to be_success.with_data(values: [3, 2, 4, 5, 1])
          expect(service.collection(enumerator([3, 2, 4, 5, 1])).sort_by.result).to be_success.with_data(values: [3, 2, 4, 5, 1])
          expect(service.collection(lazy_enumerator([3, 2, 4, 5, 1])).sort_by.result).to be_success.with_data(values: [3, 2, 4, 5, 1])
          expect(service.collection(chain_enumerator([3, 2, 4, 5, 1])).sort_by.result).to be_success.with_data(values: [3, 2, 4, 5, 1])
          expect(service.collection([3, 2, 4, 5, 1]).sort_by.result).to be_success.with_data(values: [3, 2, 4, 5, 1])

          expect(service.collection(set([3, 2, 4, 5, 1])).sort_by.result).to be_success.with_data(values: [3, 2, 4, 5, 1])
          expect(service.collection({3 => 3, 2 => 2, 4 => 4, 5 => 5, 1 => 1}).sort_by.result).to be_success.with_data(values: [[3, 3], [2, 2], [4, 4], [5, 5], [1, 1]])
          expect(service.collection((1..5)).sort_by.result).to be_success.with_data(values: [1, 2, 3, 4, 5])

          # NOTE: Block.
          expect([3, 2, 4, 5, 1].sort_by { |number| number.to_s.ord }).to eq([1, 2, 3, 4, 5])
          expect(service.collection(enumerable([3, 2, 4, 5, 1])).sort_by { |number| number.to_s.ord }.result).to be_success.with_data(values: [1, 2, 3, 4, 5])
          expect(service.collection(enumerator([3, 2, 4, 5, 1])).sort_by { |number| number.to_s.ord }.result).to be_success.with_data(values: [1, 2, 3, 4, 5])
          expect(service.collection(lazy_enumerator([3, 2, 4, 5, 1])).sort_by { |number| number.to_s.ord }.result).to be_success.with_data(values: [1, 2, 3, 4, 5])
          expect(service.collection(chain_enumerator([3, 2, 4, 5, 1])).sort_by { |number| number.to_s.ord }.result).to be_success.with_data(values: [1, 2, 3, 4, 5])
          expect(service.collection([3, 2, 4, 5, 1]).sort_by { |number| number.to_s.ord }.result).to be_success.with_data(values: [1, 2, 3, 4, 5])

          expect(service.collection(set([3, 2, 4, 5, 1])).sort_by { |number| number.to_s.ord }.result).to be_success.with_data(values: [1, 2, 3, 4, 5])
          expect(service.collection({3 => 3, 2 => 2, 4 => 4, 5 => 5, 1 => 1}).sort_by { |key, value| value.to_s.ord }.result).to be_success.with_data(values: [[1, 1], [2, 2], [3, 3], [4, 4], [5, 5]])
          expect(service.collection((1..5)).sort_by { |number| number.to_s.ord }.result).to be_success.with_data(values: [1, 2, 3, 4, 5])
          expect(service.collection((5..1).step(-1)).sort_by { |number| number.to_s.ord }.result).to be_success.with_data(values: [1, 2, 3, 4, 5])

          # NOTE: Step with no outputs.
          expect(service.collection(enumerable([3, 2, 4, 5, 1])).sort_by { |number| step number_service, in: [number: -> { number }] }.result).to be_success.with_data(values: [3, 2, 4, 5, 1])
          expect(service.collection(enumerator([3, 2, 4, 5, 1])).sort_by { |number| step number_service, in: [number: -> { number }] }.result).to be_success.with_data(values: [3, 2, 4, 5, 1])
          expect(service.collection(lazy_enumerator([3, 2, 4, 5, 1])).sort_by { |number| step number_service, in: [number: -> { number }] }.result).to be_success.with_data(values: [3, 2, 4, 5, 1])
          expect(service.collection(chain_enumerator([3, 2, 4, 5, 1])).sort_by { |number| step number_service, in: [number: -> { number }] }.result).to be_success.with_data(values: [3, 2, 4, 5, 1])
          expect(service.collection([3, 2, 4, 5, 1]).sort_by { |number| step number_service, in: [number: -> { number }] }.result).to be_success.with_data(values: [3, 2, 4, 5, 1])

          expect(service.collection(set([3, 2, 4, 5, 1])).sort_by { |number| step number_service, in: [number: -> { number }] }.result).to be_success.with_data(values: [3, 2, 4, 5, 1])
          expect(service.collection({3 => 3, 2 => 2, 4 => 4, 5 => 5, 1 => 1}).sort_by { |key, value| step number_service, in: [number: -> { value }] }.result).to be_success.with_data(values: [[3, 3], [2, 2], [4, 4], [5, 5], [1, 1]])
          expect(service.collection((1..5)).sort_by { |number| step number_service, in: [number: -> { number }] }.result).to be_success.with_data(values: [1, 2, 3, 4, 5])
          expect(service.collection((5..1).step(-1)).sort_by { |number| step number_service, in: [number: -> { number }] }.result).to be_success.with_data(values: [5, 4, 3, 2, 1])

          # NOTE: Step with one output.
          expect(service.collection(enumerable([3, 2, 4, 5, 1])).sort_by { |number| step number_service, in: [number: -> { number }], out: :number_code }.result).to be_success.with_data(values: [1, 2, 3, 4, 5])
          expect(service.collection(enumerator([3, 2, 4, 5, 1])).sort_by { |number| step number_service, in: [number: -> { number }], out: :number_code }.result).to be_success.with_data(values: [1, 2, 3, 4, 5])
          expect(service.collection(lazy_enumerator([3, 2, 4, 5, 1])).sort_by { |number| step number_service, in: [number: -> { number }], out: :number_code }.result).to be_success.with_data(values: [1, 2, 3, 4, 5])
          expect(service.collection(chain_enumerator([3, 2, 4, 5, 1])).sort_by { |number| step number_service, in: [number: -> { number }], out: :number_code }.result).to be_success.with_data(values: [1, 2, 3, 4, 5])
          expect(service.collection([3, 2, 4, 5, 1]).sort_by { |number| step number_service, in: [number: -> { number }], out: :number_code }.result).to be_success.with_data(values: [1, 2, 3, 4, 5])

          expect(service.collection(set([3, 2, 4, 5, 1])).sort_by { |number| step number_service, in: [number: -> { number }], out: :number_code }.result).to be_success.with_data(values: [1, 2, 3, 4, 5])
          expect(service.collection({3 => 3, 2 => 2, 4 => 4, 5 => 5, 1 => 1}).sort_by { |key, value| step number_service, in: [number: -> { value }], out: :number_code }.result).to be_success.with_data(values: [[1, 1], [2, 2], [3, 3], [4, 4], [5, 5]])
          expect(service.collection((1..5)).sort_by { |number| step number_service, in: [number: -> { number }], out: :number_code }.result).to be_success.with_data(values: [1, 2, 3, 4, 5])
          expect(service.collection((5..1).step(-1)).sort_by { |number| step number_service, in: [number: -> { number }], out: :number_code }.result).to be_success.with_data(values: [1, 2, 3, 4, 5])

          # NOTE: Step with multiple outputs.
          expect { service.collection(enumerable([3, 2, 4, 5, 1])).sort_by { |number| step number_service, in: [number: -> { number }], out: [:number_string, :number_code] }.result }.to raise_error(ArgumentError).with_message("comparison of Hash with Hash failed")
          expect { service.collection(enumerator([3, 2, 4, 5, 1])).sort_by { |number| step number_service, in: [number: -> { number }], out: [:number_string, :number_code] }.result }.to raise_error(ArgumentError).with_message("comparison of Hash with Hash failed")
          expect { service.collection(lazy_enumerator([3, 2, 4, 5, 1])).sort_by { |number| step number_service, in: [number: -> { number }], out: [:number_string, :number_code] }.result }.to raise_error(ArgumentError).with_message("comparison of Hash with Hash failed")
          expect { service.collection(chain_enumerator([3, 2, 4, 5, 1])).sort_by { |number| step number_service, in: [number: -> { number }], out: [:number_string, :number_code] }.result }.to raise_error(ArgumentError).with_message("comparison of Hash with Hash failed")
          expect { service.collection([3, 2, 4, 5, 1]).sort_by { |number| step number_service, in: [number: -> { number }], out: [:number_string, :number_code] }.result }.to raise_error(ArgumentError).with_message("comparison of Hash with Hash failed")

          expect { service.collection(set([3, 2, 4, 5, 1])).sort_by { |number| step number_service, in: [number: -> { number }], out: [:number_string, :number_code] }.result }.to raise_error(ArgumentError).with_message("comparison of Hash with Hash failed")
          expect { service.collection({3 => 3, 2 => 2, 4 => 4, 5 => 5, 1 => 1}).sort_by { |key, value| step number_service, in: [number: -> { value }], out: [:number_string, :number_code] }.result }.to raise_error(ArgumentError).with_message("comparison of Hash with Hash failed")
          expect { service.collection((1..5)).sort_by { |number| step number_service, in: [number: -> { number }], out: [:number_string, :number_code] }.result }.to raise_error(ArgumentError).with_message("comparison of Hash with Hash failed")
          expect { service.collection((5..1).step(-1)).sort_by { |number| step number_service, in: [number: -> { number }], out: [:number_string, :number_code] }.result }.to raise_error(ArgumentError).with_message("comparison of Hash with Hash failed")

          # NOTE: Error result.
          expect(service.collection(enumerable([1, -1, :exception])).sort_by { |number| step number_service, in: [number: -> { number }], out: :number_code }.result).to be_error.without_data
          expect(service.collection(enumerator([1, -1, :exception])).sort_by { |number| step number_service, in: [number: -> { number }], out: :number_code }.result).to be_error.without_data
          expect(service.collection(lazy_enumerator([1, -1, :exception])).sort_by { |number| step number_service, in: [number: -> { number }], out: :number_code }.result).to be_error.without_data
          expect(service.collection(chain_enumerator([1, -1, :exception])).sort_by { |number| step number_service, in: [number: -> { number }], out: :number_code }.result).to be_error.without_data
          expect(service.collection([1, -1, :exception]).sort_by { |number| step number_service, in: [number: -> { number }], out: :number_code }.result).to be_error.without_data

          expect(service.collection(set([1, -1, :exception])).sort_by { |number| step number_service, in: [number: -> { number }], out: :number_code }.result).to be_error.without_data
          expect(service.collection({1 => 1, -1 => -1, :exception => :exception}).sort_by { |key, value| step number_service, in: [number: -> { value }], out: :number_code }.result).to be_error.without_data
          expect(service.collection((-1..-1)).sort_by { |number| step number_service, in: [number: -> { number }], out: :number_code }.result).to be_error.without_data

          # NOTE: Error propagation.
          expect(service.collection(enumerable([:success, :error, :exception])).filter { |status| step status_service, in: [status: -> { status }] }.sort_by.result).to be_error.without_data
          expect(service.collection(enumerator([:success, :error, :exception])).filter { |status| step status_service, in: [status: -> { status }] }.sort_by.result).to be_error.without_data
          expect(service.collection(lazy_enumerator([:success, :error, :exception])).filter { |status| step status_service, in: [status: -> { status }] }.sort_by.result).to be_error.without_data
          expect(service.collection(chain_enumerator([:success, :error, :exception])).filter { |status| step status_service, in: [status: -> { status }] }.sort_by.result).to be_error.without_data
          expect(service.collection([:success, :error, :exception]).filter { |status| step status_service, in: [status: -> { status }] }.sort_by.result).to be_error.without_data

          expect(service.collection(set([:success, :error, :exception])).filter { |status| step status_service, in: [status: -> { status }] }.sort_by.result).to be_error.without_data
          expect(service.collection({success: :success, error: :error, exception: :exception}).filter { |key, value| step status_service, in: [status: -> { value }] }.sort_by.result).to be_error.without_data
          expect(service.collection((:error..:error)).filter { |status| step status_service, in: [status: -> { status }] }.sort_by.result).to be_error.without_data

          # NOTE: Usage on terminal chaining.
          expect { service.collection(enumerable([:success, :exception, :exception])).first.sort_by.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection(enumerator([:success, :exception, :exception])).first.sort_by.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection(lazy_enumerator([:success, :exception, :exception])).first.sort_by.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection(chain_enumerator([:success, :exception, :exception])).first.sort_by.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection([:success, :exception, :exception]).first.sort_by.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)

          expect { service.collection(set([:success, :exception, :exception])).first.sort_by.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection({success: :success, exception: :exception}).first.sort_by.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection((:success..:success)).first.sort_by.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
        end
      end

      describe "#sum" do
        specify do
          # NOTE: Empty collection.
          expect([].sum).to eq(0)
          expect(service.collection(enumerable([])).sum.result).to be_success.with_data(value: 0)
          expect(service.collection(enumerator([])).sum.result).to be_success.with_data(value: 0)
          expect(service.collection(lazy_enumerator([])).sum.result).to be_success.with_data(value: 0)
          expect(service.collection(chain_enumerator([])).sum.result).to be_success.with_data(value: 0)
          expect(service.collection([]).sum.result).to be_success.with_data(value: 0)
          expect(service.collection({}).sum.result).to be_success.with_data(value: 0)
          expect(service.collection((:success...:success)).sum.result).to be_success.with_data(value: 0)
          expect(service.collection(set([])).sum.result).to be_success.with_data(value: 0)

          # NOTE: No block, no n.
          expect([0, 1, 2, 3, 4, 5].sum).to eq(15)
          expect(service.collection(enumerable([0, 1, 2, 3, 4, 5])).sum.result).to be_success.with_data(value: 15)
          expect(service.collection(enumerator([0, 1, 2, 3, 4, 5])).sum.result).to be_success.with_data(value: 15)
          expect(service.collection(lazy_enumerator([0, 1, 2, 3, 4, 5])).sum.result).to be_success.with_data(value: 15)
          expect(service.collection(chain_enumerator([0, 1, 2, 3, 4, 5])).sum.result).to be_success.with_data(value: 15)
          expect(service.collection([0, 1, 2, 3, 4, 5]).sum.result).to be_success.with_data(value: 15)
          expect(service.collection(set([0, 1, 2, 3, 4, 5])).sum.result).to be_success.with_data(value: 15)
          expect { {0 => 0, 1 => 1, 2 => 2, 3 => 3, 4 => 4, 5 => 5}.sum }.to raise_error(TypeError).with_message("Array can't be coerced into Integer")
          expect { service.collection({0 => 0, 1 => 1, 2 => 2, 3 => 3, 4 => 4, 5 => 5}).sum.result }.to raise_error(TypeError).with_message("Array can't be coerced into Integer")
          expect(service.collection((0..5)).sum.result).to be_success.with_data(value: 15)

          # NOTE: Block, no n.
          expect([0, 1, 2, 3, 4, 5].sum { |number| -number }).to eq(-15)
          expect(service.collection(enumerable([0, 1, 2, 3, 4, 5])).sum { |number| -number }.result).to be_success.with_data(value: -15)
          expect(service.collection(enumerator([0, 1, 2, 3, 4, 5])).sum { |number| -number }.result).to be_success.with_data(value: -15)
          expect(service.collection(lazy_enumerator([0, 1, 2, 3, 4, 5])).sum { |number| -number }.result).to be_success.with_data(value: -15)
          expect(service.collection(chain_enumerator([0, 1, 2, 3, 4, 5])).sum { |number| -number }.result).to be_success.with_data(value: -15)
          expect(service.collection([0, 1, 2, 3, 4, 5]).sum { |number| -number }.result).to be_success.with_data(value: -15)
          expect(service.collection(set([0, 1, 2, 3, 4, 5])).sum { |number| -number }.result).to be_success.with_data(value: -15)

          expect(service.collection({0 => 0, 1 => 1, 2 => 2, 3 => 3, 4 => 4, 5 => 5}).sum { |key, value| -value }.result).to be_success.with_data(value: -15)
          expect(service.collection((0..5)).sum { |number| -number }.result).to be_success.with_data(value: -15)

          # NOTE: Block, n.
          expect([0, 1, 2, 3, 4, 5].sum(15) { |number| -number }).to eq(0)
          expect(service.collection(enumerable([0, 1, 2, 3, 4, 5])).sum(15) { |number| -number }.result).to be_success.with_data(value: 0)
          expect(service.collection(enumerator([0, 1, 2, 3, 4, 5])).sum(15) { |number| -number }.result).to be_success.with_data(value: 0)
          expect(service.collection(lazy_enumerator([0, 1, 2, 3, 4, 5])).sum(15) { |number| -number }.result).to be_success.with_data(value: 0)
          expect(service.collection(chain_enumerator([0, 1, 2, 3, 4, 5])).sum(15) { |number| -number }.result).to be_success.with_data(value: 0)
          expect(service.collection([0, 1, 2, 3, 4, 5]).sum(15) { |number| -number }.result).to be_success.with_data(value: 0)
          expect(service.collection(set([0, 1, 2, 3, 4, 5])).sum(15) { |number| -number }.result).to be_success.with_data(value: 0)

          expect(service.collection({0 => 0, 1 => 1, 2 => 2, 3 => 3, 4 => 4, 5 => 5}).sum(15) { |key, value| -value }.result).to be_success.with_data(value: 0)
          expect(service.collection((0..5)).sum(15) { |number| -number }.result).to be_success.with_data(value: 0)

          # NOTE: Step with no outputs.
          expect { service.collection(enumerable([0, 1, 2, 3, 4, 5])).sum { |number| step number_service, in: [number: -> { number }] }.result }.to raise_error(TypeError).with_message("true can't be coerced into Integer")
          expect { service.collection(enumerator([0, 1, 2, 3, 4, 5])).sum { |number| step number_service, in: [number: -> { number }] }.result }.to raise_error(TypeError).with_message("true can't be coerced into Integer")
          expect { service.collection(lazy_enumerator([0, 1, 2, 3, 4, 5])).sum { |number| step number_service, in: [number: -> { number }] }.result }.to raise_error(TypeError).with_message("true can't be coerced into Integer")
          expect { service.collection(chain_enumerator([0, 1, 2, 3, 4, 5])).sum { |number| step number_service, in: [number: -> { number }] }.result }.to raise_error(TypeError).with_message("true can't be coerced into Integer")
          expect { service.collection([0, 1, 2, 3, 4, 5]).sum { |number| step number_service, in: [number: -> { number }] }.result }.to raise_error(TypeError).with_message("true can't be coerced into Integer")
          expect { service.collection(set([0, 1, 2, 3, 4, 5])).sum { |number| step number_service, in: [number: -> { number }] }.result }.to raise_error(TypeError).with_message("true can't be coerced into Integer")
          expect { service.collection({0 => 0, 1 => 1, 2 => 2, 3 => 3, 4 => 4, 5 => 5}).sum { |(key, value)| step number_service, in: [number: -> { value }] }.result }.to raise_error(TypeError).with_message("true can't be coerced into Integer")
          expect { service.collection((0..5)).sum { |number| step number_service, in: [number: -> { number }] }.result }.to raise_error(TypeError).with_message("true can't be coerced into Integer")

          # NOTE: Step with one output.
          expect(service.collection(enumerable([0, 1, 2, 3, 4, 5])).sum { |number| step number_service, in: [number: -> { number }], out: :number_code }.result).to be_success.with_data(value: 303)
          expect(service.collection(enumerator([0, 1, 2, 3, 4, 5])).sum { |number| step number_service, in: [number: -> { number }], out: :number_code }.result).to be_success.with_data(value: 303)
          expect(service.collection(lazy_enumerator([0, 1, 2, 3, 4, 5])).sum { |number| step number_service, in: [number: -> { number }], out: :number_code }.result).to be_success.with_data(value: 303)
          expect(service.collection(chain_enumerator([0, 1, 2, 3, 4, 5])).sum { |number| step number_service, in: [number: -> { number }], out: :number_code }.result).to be_success.with_data(value: 303)
          expect(service.collection([0, 1, 2, 3, 4, 5]).sum { |number| step number_service, in: [number: -> { number }], out: :number_code }.result).to be_success.with_data(value: 303)
          expect(service.collection(set([0, 1, 2, 3, 4, 5])).sum { |number| step number_service, in: [number: -> { number }], out: :number_code }.result).to be_success.with_data(value: 303)

          expect(service.collection({0 => 0, 1 => 1, 2 => 2, 3 => 3, 4 => 4, 5 => 5}).sum { |(key, value)| step number_service, in: [number: -> { value }], out: :number_code }.result).to be_success.with_data(value: 303)
          expect(service.collection((0..5)).sum { |number| step number_service, in: [number: -> { number }], out: :number_code }.result).to be_success.with_data(value: 303)

          # NOTE: Step with multiple outputs.
          expect { service.collection(enumerable([0, 1, 2, 3, 4, 5])).sum { |number| step number_service, in: [number: -> { number }], out: [:number_string, :number_code] }.result }.to raise_error(TypeError).with_message("Hash can't be coerced into Integer")
          expect { service.collection(enumerator([0, 1, 2, 3, 4, 5])).sum { |number| step number_service, in: [number: -> { number }], out: [:number_string, :number_code] }.result }.to raise_error(TypeError).with_message("Hash can't be coerced into Integer")
          expect { service.collection(lazy_enumerator([0, 1, 2, 3, 4, 5])).sum { |number| step number_service, in: [number: -> { number }], out: [:number_string, :number_code] }.result }.to raise_error(TypeError).with_message("Hash can't be coerced into Integer")
          expect { service.collection(chain_enumerator([0, 1, 2, 3, 4, 5])).sum { |number| step number_service, in: [number: -> { number }], out: [:number_string, :number_code] }.result }.to raise_error(TypeError).with_message("Hash can't be coerced into Integer")
          expect { service.collection([0, 1, 2, 3, 4, 5]).sum { |number| step number_service, in: [number: -> { number }], out: [:number_string, :number_code] }.result }.to raise_error(TypeError).with_message("Hash can't be coerced into Integer")
          expect { service.collection(set([0, 1, 2, 3, 4, 5])).sum { |number| step number_service, in: [number: -> { number }], out: [:number_string, :number_code] }.result }.to raise_error(TypeError).with_message("Hash can't be coerced into Integer")

          expect { service.collection({0 => 0, 1 => 1, 2 => 2, 3 => 3, 4 => 4, 5 => 5}).sum { |(key, value)| step number_service, in: [number: -> { value }], out: [:number_string, :number_code] }.result }.to raise_error(TypeError).with_message("Hash can't be coerced into Integer")
          expect { service.collection((0..5)).sum { |number| step number_service, in: [number: -> { number }], out: [:number_string, :number_code] }.result }.to raise_error(TypeError).with_message("Hash can't be coerced into Integer")

          # NOTE: Error result.
          expect(service.collection(enumerable([0, -1, :exception])).sum { |number| step number_service, in: [number: -> { number }], out: :number_code }.result).to be_error.without_data
          expect(service.collection(enumerator([0, -1, :exception])).sum { |number| step number_service, in: [number: -> { number }], out: :number_code }.result).to be_error.without_data
          expect(service.collection(lazy_enumerator([0, -1, :exception])).sum { |number| step number_service, in: [number: -> { number }], out: :number_code }.result).to be_error.without_data
          expect(service.collection(chain_enumerator([0, -1, :exception])).sum { |number| step number_service, in: [number: -> { number }], out: :number_code }.result).to be_error.without_data
          expect(service.collection([0, -1, :exception]).sum { |number| step number_service, in: [number: -> { number }], out: :number_code }.result).to be_error.without_data
          expect(service.collection(set([0, -1, :exception])).sum { |number| step number_service, in: [number: -> { number }], out: :number_code }.result).to be_error.without_data

          expect(service.collection({0 => 0, -1 => -1, :exception => :exception}).sum { |(key, value)| step number_service, in: [number: -> { value }], out: :number_code }.result).to be_error.without_data
          expect(service.collection((-1..-1)).sum { |number| step number_service, in: [number: -> { number }], out: :number_code }.result).to be_error.without_data

          # NOTE: Error propagation.
          expect(service.collection(enumerable([1, -1, :exception])).select { |number| step number_service, in: [number: -> { number }] }.sum.result).to be_error.without_data
          expect(service.collection(enumerator([1, -1, :exception])).select { |number| step number_service, in: [number: -> { number }] }.sum.result).to be_error.without_data
          expect(service.collection(lazy_enumerator([1, -1, :exception])).select { |number| step number_service, in: [number: -> { number }] }.sum.result).to be_error.without_data
          expect(service.collection(chain_enumerator([1, -1, :exception])).select { |number| step number_service, in: [number: -> { number }] }.sum.result).to be_error.without_data
          expect(service.collection([1, -1, :exception]).select { |number| step number_service, in: [number: -> { number }] }.sum.result).to be_error.without_data
          expect(service.collection(set([1, -1, :exception])).select { |number| step number_service, in: [number: -> { number }] }.sum.result).to be_error.without_data

          expect(service.collection({1 => 1, -1 => -1, :exception => :exception}).select { |key, value| step number_service, in: [number: -> { value }] }.sum.result).to be_error.without_data
          expect(service.collection((-1..-1)).select { |number| step number_service, in: [number: -> { number }] }.sum.result).to be_error.without_data

          # NOTE: Usage on terminal chaining.
          expect { service.collection(enumerable([:success, :exception, :exception])).first.sum.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection(enumerator([:success, :exception, :exception])).first.sum.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection(lazy_enumerator([:success, :exception, :exception])).first.sum.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection(chain_enumerator([:success, :exception, :exception])).first.sum.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection([:success, :exception, :exception]).first.sum.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection(set([:success, :exception, :exception])).first.sum.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)

          expect { service.collection({success: :success, exception: :exception}).first.sum.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection((:success..:success)).first.sum.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
        end
      end

      describe "#take" do
        specify do
          # NOTE: Empty collection.
          expect([].take(2)).to eq([])
          expect(service.collection(enumerable([])).take(2).result).to be_success.with_data(values: [])
          expect(service.collection(enumerator([])).take(2).result).to be_success.with_data(values: [])
          expect(service.collection(lazy_enumerator([])).take(2).result).to be_success.with_data(values: [])
          expect(service.collection(chain_enumerator([])).take(2).result).to be_success.with_data(values: [])
          expect(service.collection([]).take(2).result).to be_success.with_data(values: [])
          expect(service.collection({}).take(2).result).to be_success.with_data(values: [])
          expect(service.collection((:success...:success)).take(2).result).to be_success.with_data(values: [])
          expect(service.collection(set([])).take(2).result).to be_success.with_data(values: [])

          # NOTE: 0.
          expect([:success, :success, :failure, :failure].take(0)).to eq([])
          expect(service.collection(enumerable([:success, :success, :failure, :failure])).take(0).result).to be_success.with_data(values: [])
          expect(service.collection(enumerator([:success, :success, :failure, :failure])).take(0).result).to be_success.with_data(values: [])
          expect(service.collection(lazy_enumerator([:success, :success, :failure, :failure])).take(0).result).to be_success.with_data(values: [])
          expect(service.collection(chain_enumerator([:success, :success, :failure, :failure])).take(0).result).to be_success.with_data(values: [])
          expect(service.collection([:success, :success, :failure, :failure]).take(0).result).to be_success.with_data(values: [])
          expect(service.collection(set([:success, :failure])).take(0).result).to be_success.with_data(values: [])
          expect(service.collection({success: :success, failure: :failure}).take(0).result).to be_success.with_data(values: [])
          expect(service.collection((:success..:success)).take(0).result).to be_success.with_data(values: [])

          # NOTE: n.
          expect([:success, :success, :failure, :failure].take(2)).to eq([:success, :success])
          expect(service.collection(enumerable([:success, :success, :failure, :failure])).take(2).result).to be_success.with_data(values: [:success, :success])
          expect(service.collection(enumerator([:success, :success, :failure, :failure])).take(2).result).to be_success.with_data(values: [:success, :success])
          expect(service.collection(lazy_enumerator([:success, :success, :failure, :failure])).take(2).result).to be_success.with_data(values: [:success, :success])
          expect(service.collection(chain_enumerator([:success, :success, :failure, :failure])).take(2).result).to be_success.with_data(values: [:success, :success])
          expect(service.collection([:success, :success, :failure, :failure]).take(2).result).to be_success.with_data(values: [:success, :success])
          expect(service.collection(set([:success, :failure])).take(1).result).to be_success.with_data(values: [:success])
          expect(service.collection({success: :success, failure: :failure}).take(1).result).to be_success.with_data(values: [[:success, :success]])
          expect(service.collection((:success..:success)).take(1).result).to be_success.with_data(values: [:success])

          # NOTE: Error propagation.
          expect(service.collection(enumerable([:success, :error, :exception])).select { |status| step status_service, in: [status: -> { status }] }.take(2).result).to be_error.without_data
          expect(service.collection(enumerator([:success, :error, :exception])).select { |status| step status_service, in: [status: -> { status }] }.take(2).result).to be_error.without_data
          expect(service.collection(lazy_enumerator([:success, :error, :exception])).select { |status| step status_service, in: [status: -> { status }] }.take(2).result).to be_error.without_data
          expect(service.collection(chain_enumerator([:success, :error, :exception])).select { |status| step status_service, in: [status: -> { status }] }.take(2).result).to be_error.without_data
          expect(service.collection([:success, :error, :exception]).select { |status| step status_service, in: [status: -> { status }] }.take(2).result).to be_error.without_data
          expect(service.collection(set([:success, :error, :exception])).select { |status| step status_service, in: [status: -> { status }] }.take(2).result).to be_error.without_data

          expect(service.collection({success: :success, error: :error, exception: :exception}).select { |key, value| step status_service, in: [status: -> { value }] }.take(2).result).to be_error.without_data
          expect(service.collection((:error..:error)).select { |status| step status_service, in: [status: -> { status }] }.take(2).result).to be_error.without_data

          # NOTE: Usage on terminal chaining.
          expect { service.collection(enumerable([:success, :exception, :exception])).first.take(2).result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection(enumerator([:success, :exception, :exception])).first.take(2).result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection(lazy_enumerator([:success, :exception, :exception])).first.take(2).result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection(chain_enumerator([:success, :exception, :exception])).first.take(2).result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection([:success, :exception, :exception]).first.take(2).result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection(set([:success, :exception, :exception])).first.take(2).result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)

          expect { service.collection({success: :success, exception: :exception}).first.take(2).result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection((:success..:success)).first.take(2).result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
        end
      end

      describe "#take_while" do
        specify do
          # NOTE: Empty collection.
          expect([].take_while { |number| number <= 2 }).to eq([])
          expect(service.collection(enumerable([])).take_while { |number| number <= 2 }.result).to be_success.with_data(values: [])
          expect(service.collection(enumerator([])).take_while { |number| number <= 2 }.result).to be_success.with_data(values: [])
          expect(service.collection(lazy_enumerator([])).take_while { |number| number <= 2 }.result).to be_success.with_data(values: [])
          expect(service.collection(chain_enumerator([])).take_while { |number| number <= 2 }.result).to be_success.with_data(values: [])
          expect(service.collection([]).take_while { |number| number <= 2 }.result).to be_success.with_data(values: [])
          expect(service.collection({}).take_while { |key, value| value <= 2 }.result).to be_success.with_data(values: [])
          expect(service.collection((0...0)).take_while { |number| number <= 2 }.result).to be_success.with_data(values: [])
          expect(service.collection(set([])).take_while { |number| number <= 2 }.result).to be_success.with_data(values: [])

          # NOTE: No block.
          expect([0, 1, 2, 3, 4, 5].take_while.to_a).to eq([0])
          expect(service.collection(enumerable([0, 1, 2, 3, 4, 5])).take_while.result).to be_success.with_data(values: [0])
          expect(service.collection(enumerator([0, 1, 2, 3, 4, 5])).take_while.result).to be_success.with_data(values: [0])
          expect { service.collection(lazy_enumerator([0, 1, 2, 3, 4, 5])).take_while.result }.to raise_error(ArgumentError).with_message("tried to call lazy take_while without a block")
          expect(service.collection(chain_enumerator([0, 1, 2, 3, 4, 5])).take_while.result).to be_success.with_data(values: [0])
          expect(service.collection([0, 1, 2, 3, 4, 5]).take_while.result).to be_success.with_data(values: [0])
          expect(service.collection(set([0, 1, 2, 3, 4, 5])).take_while.result).to be_success.with_data(values: [0])
          expect(service.collection({0 => 0, 1 => 1, 2 => 2, 3 => 3, 4 => 4, 5 => 5}).take_while.result).to be_success.with_data(values: [[0, 0]])
          expect(service.collection((0..5)).take_while.result).to be_success.with_data(values: [0])

          # NOTE: Block.
          expect([0, 1, 2, 3, 4, 5].take_while { |number| number <= 2 }).to eq([0, 1, 2])
          expect(service.collection(enumerable([0, 1, 2, 3, 4, 5])).take_while { |number| number <= 2 }.result).to be_success.with_data(values: [0, 1, 2])
          expect(service.collection(enumerator([0, 1, 2, 3, 4, 5])).take_while { |number| number <= 2 }.result).to be_success.with_data(values: [0, 1, 2])
          expect(service.collection(lazy_enumerator([0, 1, 2, 3, 4, 5])).take_while { |number| number <= 2 }.result).to be_success.with_data(values: [0, 1, 2])
          expect(service.collection(chain_enumerator([0, 1, 2, 3, 4, 5])).take_while { |number| number <= 2 }.result).to be_success.with_data(values: [0, 1, 2])
          expect(service.collection([0, 1, 2, 3, 4, 5]).take_while { |number| number <= 2 }.result).to be_success.with_data(values: [0, 1, 2])
          expect(service.collection(set([0, 1, 2, 3, 4, 5])).take_while { |number| number <= 2 }.result).to be_success.with_data(values: [0, 1, 2])
          expect(service.collection({0 => 0, 1 => 1, 2 => 2, 3 => 3, 4 => 4, 5 => 5}).take_while { |key, value| value <= 2 }.result).to be_success.with_data(values: [[0, 0], [1, 1], [2, 2]])
          expect(service.collection((0..5)).take_while { |number| number <= 2 }.result).to be_success.with_data(values: [0, 1, 2])

          # NOTE: Step with no outputs.
          expect(service.collection(enumerable([:success, :success, :failure, :exception])).take_while { |status| step status_service, in: [status: -> { status }] }.result).to be_success.with_data(values: [:success, :success])
          expect(service.collection(enumerator([:success, :success, :failure, :exception])).take_while { |status| step status_service, in: [status: -> { status }] }.result).to be_success.with_data(values: [:success, :success])
          expect(service.collection(lazy_enumerator([:success, :success, :failure, :exception])).take_while { |status| step status_service, in: [status: -> { status }] }.result).to be_success.with_data(values: [:success, :success])
          expect(service.collection(chain_enumerator([:success, :success, :failure, :exception])).take_while { |status| step status_service, in: [status: -> { status }] }.result).to be_success.with_data(values: [:success, :success])
          expect(service.collection([:success, :success, :failure, :exception]).take_while { |status| step status_service, in: [status: -> { status }] }.result).to be_success.with_data(values: [:success, :success])
          expect(service.collection(set([:success, :failure, :exception])).take_while { |status| step status_service, in: [status: -> { status }] }.result).to be_success.with_data(values: [:success])
          expect(service.collection({success: :success, failure: :failure, exception: :exception}).take_while { |key, value| step status_service, in: [status: -> { value }] }.result).to be_success.with_data(values: [[:success, :success]])
          expect(service.collection((:success..:success)).take_while { |status| step status_service, in: [status: -> { status }] }.result).to be_success.with_data(values: [:success])

          # NOTE: Step with no outputs.
          expect(service.collection(enumerable([:success, :success, :failure, :exception])).take_while { |status| step status_service, in: [status: -> { status }] }.result).to be_success.with_data(values: [:success, :success])
          expect(service.collection(enumerator([:success, :success, :failure, :exception])).take_while { |status| step status_service, in: [status: -> { status }] }.result).to be_success.with_data(values: [:success, :success])
          expect(service.collection(lazy_enumerator([:success, :success, :failure, :exception])).take_while { |status| step status_service, in: [status: -> { status }] }.result).to be_success.with_data(values: [:success, :success])
          expect(service.collection(chain_enumerator([:success, :success, :failure, :exception])).take_while { |status| step status_service, in: [status: -> { status }] }.result).to be_success.with_data(values: [:success, :success])
          expect(service.collection([:success, :success, :failure, :exception]).take_while { |status| step status_service, in: [status: -> { status }] }.result).to be_success.with_data(values: [:success, :success])
          expect(service.collection(set([:success, :failure, :exception])).take_while { |status| step status_service, in: [status: -> { status }] }.result).to be_success.with_data(values: [:success])
          expect(service.collection({success: :success, failure: :failure, exception: :exception}).take_while { |key, value| step status_service, in: [status: -> { value }] }.result).to be_success.with_data(values: [[:success, :success]])
          expect(service.collection((:success..:success)).take_while { |status| step status_service, in: [status: -> { status }] }.result).to be_success.with_data(values: [:success])

          # NOTE: Step with one output.
          expect(service.collection(enumerable([:success, :success, :failure, :exception])).take_while { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(values: [:success, :success])
          expect(service.collection(enumerator([:success, :success, :failure, :exception])).take_while { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(values: [:success, :success])
          expect(service.collection(lazy_enumerator([:success, :success, :failure, :exception])).take_while { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(values: [:success, :success])
          expect(service.collection(chain_enumerator([:success, :success, :failure, :exception])).take_while { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(values: [:success, :success])
          expect(service.collection([:success, :success, :failure, :exception]).take_while { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(values: [:success, :success])
          expect(service.collection(set([:success, :failure, :exception])).take_while { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(values: [:success])
          expect(service.collection({success: :success, failure: :failure, exception: :exception}).take_while { |key, value| step status_service, in: [status: -> { value }], out: :status_string }.result).to be_success.with_data(values: [[:success, :success]])
          expect(service.collection((:success..:success)).take_while { |status| step status_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(values: [:success])

          # NOTE: Step with multiple outputs.
          expect(service.collection(enumerable([:success, :success, :failure, :exception])).take_while { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [:success, :success])
          expect(service.collection(enumerator([:success, :success, :failure, :exception])).take_while { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [:success, :success])
          expect(service.collection(lazy_enumerator([:success, :success, :failure, :exception])).take_while { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [:success, :success])
          expect(service.collection(chain_enumerator([:success, :success, :failure, :exception])).take_while { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [:success, :success])
          expect(service.collection([:success, :success, :failure, :exception]).take_while { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [:success, :success])
          expect(service.collection(set([:success, :failure, :exception])).take_while { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [:success])
          expect(service.collection({success: :success, failure: :failure, exception: :exception}).take_while { |key, value| step status_service, in: [status: -> { value }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [[:success, :success]])
          expect(service.collection((:success..:success)).take_while { |status| step status_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [:success])

          # NOTE: Error result.
          expect(service.collection(enumerable([:success, :error, :exception])).take_while { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection(enumerator([:success, :error, :exception])).take_while { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection(lazy_enumerator([:success, :error, :exception])).take_while { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection(chain_enumerator([:success, :error, :exception])).take_while { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection([:success, :error, :exception]).take_while { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection(set([:success, :error, :exception])).take_while { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection({success: :success, error: :error, exception: :exception}).take_while { |key, value| step status_service, in: [status: -> { value }] }.result).to be_error.without_data
          expect(service.collection((:error..:error)).take_while { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data

          # NOTE: Error propagation.
          expect(service.collection(enumerable([:success, :error, :exception])).select { |status| step status_service, in: [status: -> { status }] }.take_while { |status| status == :success }.result).to be_error.without_data
          expect(service.collection(enumerator([:success, :error, :exception])).select { |status| step status_service, in: [status: -> { status }] }.take_while { |status| status == :success }.result).to be_error.without_data
          expect(service.collection(lazy_enumerator([:success, :error, :exception])).select { |status| step status_service, in: [status: -> { status }] }.take_while { |status| status == :success }.result).to be_error.without_data
          expect(service.collection(chain_enumerator([:success, :error, :exception])).select { |status| step status_service, in: [status: -> { status }] }.take_while { |status| status == :success }.result).to be_error.without_data
          expect(service.collection([:success, :error, :exception]).select { |status| step status_service, in: [status: -> { status }] }.take_while { |status| status == :success }.result).to be_error.without_data
          expect(service.collection(set([:success, :error, :exception])).select { |status| step status_service, in: [status: -> { status }] }.take_while { |status| status == :success }.result).to be_error.without_data

          expect(service.collection({success: :success, error: :error, exception: :exception}).select { |key, value| step status_service, in: [status: -> { value }] }.take_while { |key, value| value == :success }.result).to be_error.without_data
          expect(service.collection((:error..:error)).select { |status| step status_service, in: [status: -> { status }] }.take_while { |status| status == :success }.result).to be_error.without_data

          # NOTE: Usage on terminal chaining.
          expect { service.collection(enumerable([:success, :exception, :exception])).first.take_while { |status| status == :success }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection(enumerator([:success, :exception, :exception])).first.take_while { |status| status == :success }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection(lazy_enumerator([:success, :exception, :exception])).first.take_while { |status| status == :success }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection(chain_enumerator([:success, :exception, :exception])).first.take_while { |status| status == :success }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection([:success, :exception, :exception]).first.take_while { |status| status == :success }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection(set([:success, :exception, :exception])).first.take_while { |status| status == :success }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)

          expect { service.collection({success: :success, exception: :exception}).first.take_while { |key, value| value == :success }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection((:success..:success)).first.take_while { |status| status == :success }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
        end
      end

      describe "#tally" do
        specify do
          # NOTE: Empty collection.
          expect([].tally).to eq({})
          expect(service.collection(enumerable([])).tally.result).to be_success.with_data(values: {})
          expect(service.collection(enumerator([])).tally.result).to be_success.with_data(values: {})
          expect(service.collection(lazy_enumerator([])).tally.result).to be_success.with_data(values: {})
          expect(service.collection(chain_enumerator([])).tally.result).to be_success.with_data(values: {})
          expect(service.collection([]).tally.result).to be_success.with_data(values: {})
          expect(service.collection({}).tally.result).to be_success.with_data(values: {})
          expect(service.collection((:success...:success)).tally.result).to be_success.with_data(values: {})
          expect(service.collection(set([])).tally.result).to be_success.with_data(values: {})

          # NOTE: Not empty collection.
          expect([1, 2, 2, 3, 3, 3].tally).to eq({1 => 1, 2 => 2, 3 => 3})
          expect(service.collection(enumerable([1, 2, 2, 3, 3, 3])).tally.result).to be_success.with_data(values: {1 => 1, 2 => 2, 3 => 3})
          expect(service.collection(enumerator([1, 2, 2, 3, 3, 3])).tally.result).to be_success.with_data(values: {1 => 1, 2 => 2, 3 => 3})
          expect(service.collection(lazy_enumerator([1, 2, 2, 3, 3, 3])).tally.result).to be_success.with_data(values: {1 => 1, 2 => 2, 3 => 3})
          expect(service.collection(chain_enumerator([1, 2, 2, 3, 3, 3])).tally.result).to be_success.with_data(values: {1 => 1, 2 => 2, 3 => 3})
          expect(service.collection([1, 2, 2, 3, 3, 3]).tally.result).to be_success.with_data(values: {1 => 1, 2 => 2, 3 => 3})
          expect(service.collection(set([1, 2, 3])).tally.result).to be_success.with_data(values: {1 => 1, 2 => 1, 3 => 1})
          expect(service.collection({1 => 1, 2 => 2, 3 => 3}).tally.result).to be_success.with_data(values: {[1, 1] => 1, [2, 2] => 1, [3, 3] => 1})
          expect(service.collection((1..3)).tally.result).to be_success.with_data(values: {1 => 1, 2 => 1, 3 => 1})

          # NOTE: Error propagation.
          expect(service.collection(enumerable([:success, :error, :exception])).select { |status| step status_service, in: [status: -> { status }] }.tally.result).to be_error.without_data
          expect(service.collection(enumerator([:success, :error, :exception])).select { |status| step status_service, in: [status: -> { status }] }.tally.result).to be_error.without_data
          expect(service.collection(lazy_enumerator([:success, :error, :exception])).select { |status| step status_service, in: [status: -> { status }] }.tally.result).to be_error.without_data
          expect(service.collection(chain_enumerator([:success, :error, :exception])).select { |status| step status_service, in: [status: -> { status }] }.tally.result).to be_error.without_data
          expect(service.collection([:success, :error, :exception]).select { |status| step status_service, in: [status: -> { status }] }.tally.result).to be_error.without_data
          expect(service.collection(set([:success, :error, :exception])).select { |status| step status_service, in: [status: -> { status }] }.tally.result).to be_error.without_data

          expect(service.collection({success: :success, error: :error, exception: :exception}).select { |key, value| step status_service, in: [status: -> { value }] }.tally.result).to be_error.without_data
          expect(service.collection((:error..:error)).select { |status| step status_service, in: [status: -> { status }] }.tally.result).to be_error.without_data

          # NOTE: Usage on terminal chaining.
          expect { service.collection(enumerable([:success, :exception, :exception])).first.tally.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection(enumerator([:success, :exception, :exception])).first.tally.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection(lazy_enumerator([:success, :exception, :exception])).first.tally.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection(chain_enumerator([:success, :exception, :exception])).first.tally.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection([:success, :exception, :exception]).first.tally.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection(set([:success, :exception, :exception])).first.tally.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)

          expect { service.collection({success: :success, exception: :exception}).first.tally.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection((:success..:success)).first.tally.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
        end
      end

      describe "#to_a" do
        specify do
          # NOTE: Empty collection.
          expect([].to_a).to eq([])
          expect(service.collection(enumerable([])).to_a.result).to be_success.with_data(values: [])
          expect(service.collection(enumerator([])).to_a.result).to be_success.with_data(values: [])
          expect(service.collection(lazy_enumerator([])).to_a.result).to be_success.with_data(values: [])
          expect(service.collection(chain_enumerator([])).to_a.result).to be_success.with_data(values: [])
          expect(service.collection([]).to_a.result).to be_success.with_data(values: [])
          expect(service.collection({}).to_a.result).to be_success.with_data(values: [])
          expect(service.collection((:success...:success)).to_a.result).to be_success.with_data(values: [])
          expect(service.collection(set([])).to_a.result).to be_success.with_data(values: [])

          # NOTE: Not empty collection.
          expect([:success, :success, :success].to_a).to eq([:success, :success, :success])
          expect(service.collection(enumerable([:success, :success, :success])).to_a.result).to be_success.with_data(values: [:success, :success, :success])
          expect(service.collection(enumerator([:success, :success, :success])).to_a.result).to be_success.with_data(values: [:success, :success, :success])
          expect(service.collection(lazy_enumerator([:success, :success, :success])).to_a.result).to be_success.with_data(values: [:success, :success, :success])
          expect(service.collection(chain_enumerator([:success, :success, :success])).to_a.result).to be_success.with_data(values: [:success, :success, :success])
          expect(service.collection([:success, :success, :success]).to_a.result).to be_success.with_data(values: [:success, :success, :success])
          expect(service.collection(set([:success])).to_a.result).to be_success.with_data(values: [:success])
          expect(service.collection({success: :success}).to_a.result).to be_success.with_data(values: [[:success, :success]])
          expect(service.collection((:success..:success)).to_a.result).to be_success.with_data(values: [:success])

          # NOTE: Error propagation.
          expect(service.collection(enumerable([:success, :error, :exception])).select { |status| step status_service, in: [status: -> { status }] }.to_a.result).to be_error.without_data
          expect(service.collection(enumerator([:success, :error, :exception])).select { |status| step status_service, in: [status: -> { status }] }.to_a.result).to be_error.without_data
          expect(service.collection(lazy_enumerator([:success, :error, :exception])).select { |status| step status_service, in: [status: -> { status }] }.to_a.result).to be_error.without_data
          expect(service.collection(chain_enumerator([:success, :error, :exception])).select { |status| step status_service, in: [status: -> { status }] }.to_a.result).to be_error.without_data
          expect(service.collection([:success, :error, :exception]).select { |status| step status_service, in: [status: -> { status }] }.to_a.result).to be_error.without_data
          expect(service.collection(set([:success, :error, :exception])).select { |status| step status_service, in: [status: -> { status }] }.to_a.result).to be_error.without_data

          expect(service.collection({success: :success, error: :error, exception: :exception}).select { |key, value| step status_service, in: [status: -> { value }] }.to_a.result).to be_error.without_data
          expect(service.collection((:error..:error)).select { |status| step status_service, in: [status: -> { status }] }.to_a.result).to be_error.without_data

          # NOTE: Usage on terminal chaining.
          expect { service.collection(enumerable([:success, :exception, :exception])).first.to_a.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection(enumerator([:success, :exception, :exception])).first.to_a.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection(lazy_enumerator([:success, :exception, :exception])).first.to_a.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection(chain_enumerator([:success, :exception, :exception])).first.to_a.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection([:success, :exception, :exception]).first.to_a.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection(set([:success, :exception, :exception])).first.to_a.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)

          expect { service.collection({success: :success, exception: :exception}).first.to_a.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection((:success..:success)).first.to_a.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
        end
      end

      describe "#to_h" do
        specify do
          # NOTE: Empty collection.
          expect([].to_h).to eq({})
          expect(service.collection(enumerable([])).to_h.result).to be_success.with_data(values: {})
          expect(service.collection(enumerator([])).to_h.result).to be_success.with_data(values: {})
          expect(service.collection(lazy_enumerator([])).to_h.result).to be_success.with_data(values: {})
          expect(service.collection(chain_enumerator([])).to_h.result).to be_success.with_data(values: {})
          expect(service.collection([]).to_h.result).to be_success.with_data(values: {})
          expect(service.collection(set([])).to_h.result).to be_success.with_data(values: {})
          expect(service.collection({}).to_h.result).to be_success.with_data(values: {})
          expect(service.collection((:success...:success)).to_h.result).to be_success.with_data(values: {})

          # NOTE: Not empty collection.
          expect([[0, 0], [1, 1], [2, 2]].to_h).to eq({0 => 0, 1 => 1, 2 => 2})
          expect(service.collection(enumerable([[0, 0], [1, 1], [2, 2]])).to_h.result).to be_success.with_data(values: {0 => 0, 1 => 1, 2 => 2})
          expect(service.collection(enumerator([[0, 0], [1, 1], [2, 2]])).to_h.result).to be_success.with_data(values: {0 => 0, 1 => 1, 2 => 2})
          expect(service.collection(lazy_enumerator([[0, 0], [1, 1], [2, 2]])).to_h.result).to be_success.with_data(values: {0 => 0, 1 => 1, 2 => 2})
          expect(service.collection(chain_enumerator([[0, 0], [1, 1], [2, 2]])).to_h.result).to be_success.with_data(values: {0 => 0, 1 => 1, 2 => 2})
          expect(service.collection([[0, 0], [1, 1], [2, 2]]).to_h.result).to be_success.with_data(values: {0 => 0, 1 => 1, 2 => 2})
          expect(service.collection(set([[0, 0], [1, 1], [2, 2]])).to_h.result).to be_success.with_data(values: {0 => 0, 1 => 1, 2 => 2})
          expect(service.collection({0 => 0, 1 => 1, 2 => 2}).to_h.result).to be_success.with_data(values: {0 => 0, 1 => 1, 2 => 2})

          expect { (:success..:success).to_h }.to raise_error(TypeError).with_message("wrong element type Symbol (expected array)")
          expect { ([:success, :success]..[:success, :success]).to_h }.to raise_error(TypeError).with_message("can't iterate from Array")
          expect { service.collection((:success..:success)).to_h.result }.to raise_error(TypeError).with_message("wrong element type Symbol (expected array)")
          expect { service.collection(([:success, :success]..[:success, :success])).to_h.result }.to raise_error(TypeError).with_message("can't iterate from Array")

          # # NOTE: Not empty collection.
          expect { [:success, :success, :success].to_h }.to raise_error(TypeError).with_message("wrong element type Symbol at 0 (expected array)")
          expect { service.collection(enumerable([:success, :success, :success])).to_h.result }.to raise_error(TypeError).with_message("wrong element type Symbol (expected array)")
          expect { service.collection(enumerator([:success, :success, :success])).to_h.result }.to raise_error(TypeError).with_message("wrong element type Symbol (expected array)")
          expect { service.collection(lazy_enumerator([:success, :success, :success])).to_h.result }.to raise_error(TypeError).with_message("wrong element type Symbol (expected array)")
          expect { service.collection(chain_enumerator([:success, :success, :success])).to_h.result }.to raise_error(TypeError).with_message("wrong element type Symbol (expected array)")
          expect { service.collection([:success, :success, :success]).to_h.result }.to raise_error(TypeError).with_message("wrong element type Symbol at 0 (expected array)")
          expect { service.collection(set([:success])).to_h.result }.to raise_error(TypeError).with_message("wrong element type Symbol (expected array)")
          expect(service.collection({success: :success}).to_h.result).to be_success.with_data(values: {success: :success})

          # NOTE: Error propagation.
          expect(service.collection(enumerable([[:success, :success], [:error, :error], [:exception, :exception]])).select { |key, value| step status_service, in: [status: -> { value }] }.to_h.result).to be_error.without_data
          expect(service.collection(enumerator([[:success, :success], [:error, :error], [:exception, :exception]])).select { |key, value| step status_service, in: [status: -> { value }] }.to_h.result).to be_error.without_data
          expect(service.collection(lazy_enumerator([[:success, :success], [:error, :error], [:exception, :exception]])).select { |key, value| step status_service, in: [status: -> { value }] }.to_h.result).to be_error.without_data
          expect(service.collection(chain_enumerator([[:success, :success], [:error, :error], [:exception, :exception]])).select { |key, value| step status_service, in: [status: -> { value }] }.to_h.result).to be_error.without_data
          expect(service.collection([[:success, :success], [:error, :error], [:exception, :exception]]).select { |key, value| step status_service, in: [status: -> { value }] }.to_h.result).to be_error.without_data
          expect(service.collection(set([[:success, :success], [:error, :error], [:exception, :exception]])).select { |key, value| step status_service, in: [status: -> { value }] }.to_h.result).to be_error.without_data
          expect(service.collection({success: :success, error: :error, exception: :exception}).select { |key, value| step status_service, in: [status: -> { value }] }.to_h.result).to be_error.without_data

          # NOTE: Usage on terminal chaining.
          expect { service.collection(enumerable([[:success, :success], [:exception, :exception], [:exception, :exception]])).first.to_h.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection(enumerator([[:success, :success], [:exception, :exception], [:exception, :exception]])).first.to_h.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection(lazy_enumerator([[:success, :success], [:exception, :exception], [:exception, :exception]])).first.to_h.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection(chain_enumerator([[:success, :success], [:exception, :exception], [:exception, :exception]])).first.to_h.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection([[:success, :success], [:exception, :exception], [:exception, :exception]]).first.to_h.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection(set([[:success, :success], [:exception, :exception], [:exception, :exception]])).first.to_h.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection({success: :success, exception: :exception}).first.to_h.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
        end
      end

      describe "#to_set" do
        specify do
          # NOTE: Empty collection.
          expect([].to_set).to eq(Set.new([]))
          expect(service.collection(enumerable([])).to_set.result).to be_success.with_data(values: Set.new([]))
          expect(service.collection(enumerator([])).to_set.result).to be_success.with_data(values: Set.new([]))
          expect(service.collection(lazy_enumerator([])).to_set.result).to be_success.with_data(values: Set.new([]))
          expect(service.collection(chain_enumerator([])).to_set.result).to be_success.with_data(values: Set.new([]))
          expect(service.collection([]).to_set.result).to be_success.with_data(values: Set.new([]))
          expect(service.collection({}).to_set.result).to be_success.with_data(values: Set.new([]))
          expect(service.collection((:success...:success)).to_set.result).to be_success.with_data(values: Set.new([]))
          expect(service.collection(set([])).to_set.result).to be_success.with_data(values: Set.new([]))

          # NOTE: Not empty collection.
          expect([:success, :success, :success].to_set).to eq(Set.new([:success]))
          expect(service.collection(enumerable([:success, :success, :success])).to_set.result).to be_success.with_data(values: Set.new([:success]))
          expect(service.collection(enumerator([:success, :success, :success])).to_set.result).to be_success.with_data(values: Set.new([:success]))
          expect(service.collection(lazy_enumerator([:success, :success, :success])).to_set.result).to be_success.with_data(values: Set.new([:success]))
          expect(service.collection(chain_enumerator([:success, :success, :success])).to_set.result).to be_success.with_data(values: Set.new([:success]))
          expect(service.collection([:success, :success, :success]).to_set.result).to be_success.with_data(values: Set.new([:success]))
          expect(service.collection(set([:success])).to_set.result).to be_success.with_data(values: Set.new([:success]))
          expect(service.collection({success: :success}).to_set.result).to be_success.with_data(values: Set.new([[:success, :success]]))
          expect(service.collection((:success..:success)).to_set.result).to be_success.with_data(values: Set.new([:success]))

          # NOTE: Error propagation.
          expect(service.collection(enumerable([:success, :error, :exception])).select { |status| step status_service, in: [status: -> { status }] }.to_set.result).to be_error.without_data
          expect(service.collection(enumerator([:success, :error, :exception])).select { |status| step status_service, in: [status: -> { status }] }.to_set.result).to be_error.without_data
          expect(service.collection(lazy_enumerator([:success, :error, :exception])).select { |status| step status_service, in: [status: -> { status }] }.to_set.result).to be_error.without_data
          expect(service.collection(chain_enumerator([:success, :error, :exception])).select { |status| step status_service, in: [status: -> { status }] }.to_set.result).to be_error.without_data
          expect(service.collection([:success, :error, :exception]).select { |status| step status_service, in: [status: -> { status }] }.to_set.result).to be_error.without_data
          expect(service.collection(set([:success, :error, :exception])).select { |status| step status_service, in: [status: -> { status }] }.to_set.result).to be_error.without_data

          expect(service.collection({success: :success, error: :error, exception: :exception}).select { |key, value| step status_service, in: [status: -> { value }] }.to_set.result).to be_error.without_data
          expect(service.collection((:error..:error)).select { |status| step status_service, in: [status: -> { status }] }.to_set.result).to be_error.without_data

          # NOTE: Usage on terminal chaining.
          expect { service.collection(enumerable([:success, :exception, :exception])).first.to_set.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection(enumerator([:success, :exception, :exception])).first.to_set.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection(lazy_enumerator([:success, :exception, :exception])).first.to_set.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection(chain_enumerator([:success, :exception, :exception])).first.to_set.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection([:success, :exception, :exception]).first.to_set.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection(set([:success, :exception, :exception])).first.to_set.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)

          expect { service.collection({success: :success, exception: :exception}).first.to_set.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection((:success..:success)).first.to_set.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
        end
      end

      describe "#uniq" do
        specify do
          # NOTE: Empty collection.
          expect([].uniq { |number| number.to_s.ord }).to eq([])
          expect(service.collection(enumerable([])).uniq { |number| number.to_s.ord }.result).to be_success.with_data(values: [])
          expect(service.collection(enumerator([])).uniq { |number| number.to_s.ord }.result).to be_success.with_data(values: [])
          expect(service.collection(lazy_enumerator([])).uniq { |number| number.to_s.ord }.result).to be_success.with_data(values: [])
          expect(service.collection(chain_enumerator([])).uniq { |number| number.to_s.ord }.result).to be_success.with_data(values: [])
          expect(service.collection([]).uniq { |number| number.to_s.ord }.result).to be_success.with_data(values: [])
          expect(service.collection(set([])).uniq { |number| number.to_s.ord }.result).to be_success.with_data(values: [])
          expect(service.collection({}).uniq { |key, value| value.to_s.ord }.result).to be_success.with_data(values: [])
          expect(service.collection((:success...:success)).uniq { |number| number.to_s.ord }.result).to be_success.with_data(values: [])

          # NOTE: No block.
          expect([1, 2, 2, 3, 3, 3].uniq.to_a).to eq([1, 2, 3])
          expect(service.collection(enumerable([1, 2, 2, 3, 3, 3])).uniq.result).to be_success.with_data(values: [1, 2, 3])
          expect(service.collection(enumerator([1, 2, 2, 3, 3, 3])).uniq.result).to be_success.with_data(values: [1, 2, 3])
          expect(service.collection(lazy_enumerator([1, 2, 2, 3, 3, 3])).uniq.result).to be_success.with_data(values: [1, 2, 3])
          expect(service.collection(chain_enumerator([1, 2, 2, 3, 3, 3])).uniq.result).to be_success.with_data(values: [1, 2, 3])
          expect(service.collection([1, 2, 2, 3, 3, 3]).uniq.result).to be_success.with_data(values: [1, 2, 3])

          expect(service.collection(set([1, 2, 3])).uniq.result).to be_success.with_data(values: [1, 2, 3])
          expect(service.collection({1 => 1, 2 => 2, 3 => 3}).uniq.result).to be_success.with_data(values: [[1, 1], [2, 2], [3, 3]])
          expect(service.collection((1..3)).uniq.result).to be_success.with_data(values: [1, 2, 3])

          # NOTE: Block.
          expect([1, 2, 2, 3, 3, 3].uniq { |number| number.to_s.ord }).to eq([1, 2, 3])
          expect(service.collection(enumerable([1, 2, 2, 3, 3, 3])).uniq { |number| number.to_s.ord }.result).to be_success.with_data(values: [1, 2, 3])
          expect(service.collection(enumerator([1, 2, 2, 3, 3, 3])).uniq { |number| number.to_s.ord }.result).to be_success.with_data(values: [1, 2, 3])
          expect(service.collection(lazy_enumerator([1, 2, 2, 3, 3, 3])).uniq { |number| number.to_s.ord }.result).to be_success.with_data(values: [1, 2, 3])
          expect(service.collection(chain_enumerator([1, 2, 2, 3, 3, 3])).uniq { |number| number.to_s.ord }.result).to be_success.with_data(values: [1, 2, 3])
          expect(service.collection([1, 2, 2, 3, 3, 3]).uniq { |number| number.to_s.ord }.result).to be_success.with_data(values: [1, 2, 3])

          expect(service.collection(set([1, 2, 2, 3, 3, 3])).uniq { |number| number.to_s.ord }.result).to be_success.with_data(values: [1, 2, 3])
          expect(service.collection({1 => 1, 2 => 2, 3 => 3}).uniq { |key, value| value.to_s.ord }.result).to be_success.with_data(values: [[1, 1], [2, 2], [3, 3]])
          expect(service.collection((1..3)).uniq { |number| number.to_s.ord }.result).to be_success.with_data(values: [1, 2, 3])

          # NOTE: Step with no outputs.
          expect(service.collection(enumerable([1, 2, 2, 3, 3, 3])).uniq { |number| step number_service, in: [number: -> { number }] }.result).to be_success.with_data(values: [1])
          expect(service.collection(enumerator([1, 2, 2, 3, 3, 3])).uniq { |number| step number_service, in: [number: -> { number }] }.result).to be_success.with_data(values: [1])
          expect(service.collection(lazy_enumerator([1, 2, 2, 3, 3, 3])).uniq { |number| step number_service, in: [number: -> { number }] }.result).to be_success.with_data(values: [1])
          expect(service.collection(chain_enumerator([1, 2, 2, 3, 3, 3])).uniq { |number| step number_service, in: [number: -> { number }] }.result).to be_success.with_data(values: [1])
          expect(service.collection([1, 2, 2, 3, 3, 3]).uniq { |number| step number_service, in: [number: -> { number }] }.result).to be_success.with_data(values: [1])

          expect(service.collection(set([1, 2, 3])).uniq { |number| step number_service, in: [number: -> { number }] }.result).to be_success.with_data(values: [1])
          expect(service.collection({1 => 1, 2 => 2, 3 => 3}).uniq { |key, value| step number_service, in: [number: -> { value }] }.result).to be_success.with_data(values: [[1, 1]])
          expect(service.collection((1..3)).uniq { |number| step number_service, in: [number: -> { number }] }.result).to be_success.with_data(values: [1])

          # NOTE: Step with one output.
          expect(service.collection(enumerable([1, 2, 2, 3, 3, 3])).uniq { |number| step number_service, in: [number: -> { number }], out: :number_code }.result).to be_success.with_data(values: [1, 2, 3])
          expect(service.collection(enumerator([1, 2, 2, 3, 3, 3])).uniq { |number| step number_service, in: [number: -> { number }], out: :number_code }.result).to be_success.with_data(values: [1, 2, 3])
          expect(service.collection(lazy_enumerator([1, 2, 2, 3, 3, 3])).uniq { |number| step number_service, in: [number: -> { number }], out: :number_code }.result).to be_success.with_data(values: [1, 2, 3])
          expect(service.collection(chain_enumerator([1, 2, 2, 3, 3, 3])).uniq { |number| step number_service, in: [number: -> { number }], out: :number_code }.result).to be_success.with_data(values: [1, 2, 3])
          expect(service.collection([1, 2, 2, 3, 3, 3]).uniq { |number| step number_service, in: [number: -> { number }], out: :number_code }.result).to be_success.with_data(values: [1, 2, 3])

          expect(service.collection(set([1, 2, 3])).uniq { |number| step number_service, in: [number: -> { number }], out: :number_code }.result).to be_success.with_data(values: [1, 2, 3])
          expect(service.collection({1 => 1, 2 => 2, 3 => 3}).uniq { |key, value| step number_service, in: [number: -> { value }], out: :number_code }.result).to be_success.with_data(values: [[1, 1], [2, 2], [3, 3]])
          expect(service.collection((1..3)).uniq { |number| step number_service, in: [number: -> { number }], out: :number_code }.result).to be_success.with_data(values: [1, 2, 3])

          # NOTE: Step with multiple outputs.
          expect(service.collection(enumerable([1, 2, 2, 3, 3, 3])).uniq { |number| step number_service, in: [number: -> { number }], out: [:number_string, :number_code] }.result).to be_success.with_data(values: [1, 2, 3])
          expect(service.collection(enumerator([1, 2, 2, 3, 3, 3])).uniq { |number| step number_service, in: [number: -> { number }], out: [:number_string, :number_code] }.result).to be_success.with_data(values: [1, 2, 3])
          expect(service.collection(lazy_enumerator([1, 2, 2, 3, 3, 3])).uniq { |number| step number_service, in: [number: -> { number }], out: [:number_string, :number_code] }.result).to be_success.with_data(values: [1, 2, 3])
          expect(service.collection(chain_enumerator([1, 2, 2, 3, 3, 3])).uniq { |number| step number_service, in: [number: -> { number }], out: [:number_string, :number_code] }.result).to be_success.with_data(values: [1, 2, 3])
          expect(service.collection([1, 2, 2, 3, 3, 3]).uniq { |number| step number_service, in: [number: -> { number }], out: [:number_string, :number_code] }.result).to be_success.with_data(values: [1, 2, 3])

          expect(service.collection(set([1, 2, 3])).uniq { |number| step number_service, in: [number: -> { number }], out: [:number_string, :number_code] }.result).to be_success.with_data(values: [1, 2, 3])
          expect(service.collection({1 => 1, 2 => 2, 3 => 3}).uniq { |key, value| step number_service, in: [number: -> { value }], out: [:number_string, :number_code] }.result).to be_success.with_data(values: [[1, 1], [2, 2], [3, 3]])
          expect(service.collection((1..3)).uniq { |number| step number_service, in: [number: -> { number }], out: [:number_string, :number_code] }.result).to be_success.with_data(values: [1, 2, 3])

          # NOTE: Error result.
          expect(service.collection(enumerable([:success, :error, :exception])).uniq { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection(enumerator([:success, :error, :exception])).uniq { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection(lazy_enumerator([:success, :error, :exception])).uniq { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection(chain_enumerator([:success, :error, :exception])).uniq { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection([:success, :error, :exception]).uniq { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data

          expect(service.collection(set([:success, :error, :exception])).uniq { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection({success: :success, error: :error, exception: :exception}).uniq { |key, value| step status_service, in: [status: -> { value }] }.result).to be_error.without_data
          expect(service.collection((:error..:error)).uniq { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data

          # NOTE: Error propagation.
          expect(service.collection(enumerable([:success, :error, :exception])).filter { |status| step status_service, in: [status: -> { status }] }.uniq { |status| condition[status] }.result).to be_error.without_data
          expect(service.collection(enumerator([:success, :error, :exception])).filter { |status| step status_service, in: [status: -> { status }] }.uniq { |status| condition[status] }.result).to be_error.without_data
          expect(service.collection(lazy_enumerator([:success, :error, :exception])).filter { |status| step status_service, in: [status: -> { status }] }.uniq { |status| condition[status] }.result).to be_error.without_data
          expect(service.collection(chain_enumerator([:success, :error, :exception])).filter { |status| step status_service, in: [status: -> { status }] }.uniq { |status| condition[status] }.result).to be_error.without_data
          expect(service.collection([:success, :error, :exception]).filter { |status| step status_service, in: [status: -> { status }] }.uniq { |status| condition[status] }.result).to be_error.without_data

          expect(service.collection(set([:success, :error, :exception])).filter { |status| step status_service, in: [status: -> { status }] }.uniq { |status| condition[status] }.result).to be_error.without_data
          expect(service.collection({success: :success, error: :error, exception: :exception}).filter { |key, value| step status_service, in: [status: -> { value }] }.uniq { |key, value| condition[value] }.result).to be_error.without_data
          expect(service.collection((:error..:error)).filter { |status| step status_service, in: [status: -> { status }] }.uniq { |status| condition[status] }.result).to be_error.without_data

          # NOTE: Usage on terminal chaining.
          expect { service.collection(enumerable([:success, :exception, :exception])).first.uniq { |status| condition[status] }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection(enumerator([:success, :exception, :exception])).first.uniq { |status| condition[status] }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection(lazy_enumerator([:success, :exception, :exception])).first.uniq { |status| condition[status] }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection(chain_enumerator([:success, :exception, :exception])).first.uniq { |status| condition[status] }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection([:success, :exception, :exception]).first.uniq { |status| condition[status] }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)

          expect { service.collection(set([:success, :exception, :exception])).first.uniq { |status| condition[status] }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection({success: :success, exception: :exception}).first.uniq { |key, value| condition[value] }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection((:success..:success)).first.uniq { |status| condition[status] }.result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
        end
      end

      describe "#zip" do
        specify do
          # NOTE: Empty collection.
          expect([].zip([2])).to eq([])
          expect(service.collection(enumerable([])).zip([2]).result).to be_success.with_data(values: [])
          expect(service.collection(enumerator([])).zip([2]).result).to be_success.with_data(values: [])
          expect(service.collection(lazy_enumerator([])).zip([2]).result).to be_success.with_data(values: [])
          expect(service.collection(chain_enumerator([])).zip([2]).result).to be_success.with_data(values: [])
          expect(service.collection([]).zip([2]).result).to be_success.with_data(values: [])
          expect(service.collection(set([])).zip([2]).result).to be_success.with_data(values: [])
          expect(service.collection({}).zip([2]).result).to be_success.with_data(values: [])
          expect(service.collection((1...1)).zip([2]).result).to be_success.with_data(values: [])

          # No argument, no block.
          expect([1].zip).to eq([[1]])
          expect(service.collection(enumerable([1])).zip.result).to be_success.with_data(values: [[1]])
          expect(service.collection(enumerator([1])).zip.result).to be_success.with_data(values: [[1]])
          expect(service.collection(lazy_enumerator([1])).zip.result).to be_success.with_data(values: [[1]])
          expect(service.collection(chain_enumerator([1])).zip.result).to be_success.with_data(values: [[1]])
          expect(service.collection([1]).zip.result).to be_success.with_data(values: [[1]])
          expect(service.collection(set([1])).zip.result).to be_success.with_data(values: [[1]])
          expect({1 => 1}.zip).to eq([[[1, 1]]])
          expect(service.collection({1 => 1}).zip.result).to be_success.with_data(values: [[[1, 1]]])
          expect(service.collection({1 => 1}).zip.result).to be_success.with_data(values: [[[1, 1]]])
          expect(service.collection((1..1)).zip.result).to be_success.with_data(values: [[1]])

          # One argument, no block.
          expect([1].zip([2])).to eq([[1, 2]])
          expect(service.collection(enumerable([1])).zip([2]).result).to be_success.with_data(values: [[1, 2]])
          expect(service.collection(enumerator([1])).zip([2]).result).to be_success.with_data(values: [[1, 2]])
          expect(service.collection(lazy_enumerator([1])).zip([2]).result).to be_success.with_data(values: [[1, 2]])
          expect(service.collection(chain_enumerator([1])).zip([2]).result).to be_success.with_data(values: [[1, 2]])
          expect(service.collection([1]).zip([2]).result).to be_success.with_data(values: [[1, 2]])
          expect(service.collection(set([1])).zip([2]).result).to be_success.with_data(values: [[1, 2]])
          expect({1 => 1}.zip([2])).to eq([[[1, 1], 2]])
          expect({1 => 1}.zip({2 => 2})).to eq([[[1, 1], [2, 2]]])
          expect(service.collection({1 => 1}).zip([2]).result).to be_success.with_data(values: [[[1, 1], 2]])
          expect(service.collection({1 => 1}).zip({2 => 2}).result).to be_success.with_data(values: [[[1, 1], [2, 2]]])
          expect(service.collection((1..1)).zip([2]).result).to be_success.with_data(values: [[1, 2]])

          # Multiple arguments, no block.
          expect([1].zip([2], [3])).to eq([[1, 2, 3]])
          expect(service.collection(enumerable([1])).zip([2], [3]).result).to be_success.with_data(values: [[1, 2, 3]])
          expect(service.collection(enumerator([1])).zip([2], [3]).result).to be_success.with_data(values: [[1, 2, 3]])
          expect(service.collection(lazy_enumerator([1])).zip([2], [3]).result).to be_success.with_data(values: [[1, 2, 3]])
          expect(service.collection(chain_enumerator([1])).zip([2], [3]).result).to be_success.with_data(values: [[1, 2, 3]])
          expect(service.collection([1]).zip([2], [3]).result).to be_success.with_data(values: [[1, 2, 3]])
          expect(service.collection(set([1])).zip([2], [3]).result).to be_success.with_data(values: [[1, 2, 3]])
          expect({1 => 1}.zip([2], [3])).to eq([[[1, 1], 2, 3]])
          expect({1 => 1}.zip({2 => 2}, {3 => 3})).to eq([[[1, 1], [2, 2], [3, 3]]])
          expect(service.collection({1 => 1}).zip([2], [3]).result).to be_success.with_data(values: [[[1, 1], 2, 3]])
          expect(service.collection({1 => 1}).zip({2 => 2}, {3 => 3}).result).to be_success.with_data(values: [[[1, 1], [2, 2], [3, 3]]])
          expect(service.collection((1..1)).zip([2], [3]).result).to be_success.with_data(values: [[1, 2, 3]])

          # No argument, block.
          expect([1].zip { |array| raise if array.sum != 1 }).to eq(nil)
          expect(service.collection(enumerable([1])).zip { |integer| raise if integer != 1 }.result).to be_success.with_data(value: nil)
          expect(service.collection(enumerator([1])).zip { |integer| raise if integer != 1 }.result).to be_success.with_data(value: nil)
          expect(service.collection(lazy_enumerator([1])).zip { |integer| raise if integer != 1 }.result).to be_success.with_data(value: nil)
          expect(service.collection(chain_enumerator([1])).zip { |integer| raise if integer != 1 }.result).to be_success.with_data(value: nil)
          expect(service.collection([1]).zip { |array| raise if array.sum != 1 }.result).to be_success.with_data(value: nil)
          expect(set([1]).zip { |integer| raise if integer != 1 }).to eq(nil)
          expect(service.collection(set([1])).zip { |integer| raise if integer != 1 }.result).to be_success.with_data(value: nil)
          expect({1 => 1}.zip { |array| raise if array.flatten.sum != 2 }).to eq(nil)
          expect(service.collection({1 => 1}).zip { |array| raise if array.flatten.sum != 2 }.result).to be_success.with_data(value: nil)
          expect((1..1).zip { |integer| raise if integer != 1 }).to eq(nil)
          expect(service.collection((1..1)).zip { |integer| raise if integer != 1 }.result).to be_success.with_data(value: nil)

          # One argument, block.
          expect([1].zip([2]) { |array| raise if array.sum != 3 }).to eq(nil)
          expect(service.collection(enumerable([1])).zip([2]) { |array| raise if array.sum != 3 }.result).to be_success.with_data(value: nil)
          expect(service.collection(enumerator([1])).zip([2]) { |array| raise if array.sum != 3 }.result).to be_success.with_data(value: nil)
          expect(service.collection(lazy_enumerator([1])).zip([2]) { |array| raise if array.sum != 3 }.result).to be_success.with_data(value: nil)
          expect(service.collection(chain_enumerator([1])).zip([2]) { |array| raise if array.sum != 3 }.result).to be_success.with_data(value: nil)
          expect(service.collection([1]).zip([2]) { |array| raise if array.sum != 3 }.result).to be_success.with_data(value: nil)
          expect(set([1]).zip([2]) { |array| raise if array.sum != 3 }).to eq(nil)
          expect(service.collection(set([1])).zip([2]) { |array| raise if array.sum != 3 }.result).to be_success.with_data(value: nil)
          expect({1 => 1}.zip([2]) { |array| raise if array.flatten.sum != 4 }).to eq(nil)
          expect({1 => 1}.zip({2 => 2}) { |array| raise if array.flatten.sum != 6 }).to eq(nil)
          expect(service.collection({1 => 1}).zip([2]) { |array| raise if array.flatten.sum != 4 }.result).to be_success.with_data(value: nil)
          expect(service.collection({1 => 1}).zip({2 => 2}) { |array| raise if array.flatten.sum != 6 }.result).to be_success.with_data(value: nil)
          expect((1..1).zip([2]) { |array| raise if array.sum != 3 }).to eq(nil)
          expect(service.collection((1..1)).zip([2]) { |array| raise if array.sum != 3 }.result).to be_success.with_data(value: nil)

          # Multiple arguments, block.
          expect([1].zip([2], [3]) { |array| raise if array.sum != 6 }).to eq(nil)
          expect(service.collection(enumerable([1])).zip([2], [3]) { |array| raise if array.sum != 6 }.result).to be_success.with_data(value: nil)
          expect(service.collection(enumerator([1])).zip([2], [3]) { |array| raise if array.sum != 6 }.result).to be_success.with_data(value: nil)
          expect(service.collection(lazy_enumerator([1])).zip([2], [3]) { |array| raise if array.sum != 6 }.result).to be_success.with_data(value: nil)
          expect(service.collection(chain_enumerator([1])).zip([2], [3]) { |array| raise if array.sum != 6 }.result).to be_success.with_data(value: nil)
          expect(service.collection([1]).zip([2], [3]) { |array| raise if array.sum != 6 }.result).to be_success.with_data(value: nil)
          expect(set([1]).zip([2], [3]) { |array| raise if array.sum != 6 }).to eq(nil)
          expect(service.collection(set([1])).zip([2], [3]) { |array| raise if array.sum != 6 }.result).to be_success.with_data(value: nil)
          expect({1 => 1}.zip([2], [3]) { |array| raise if array.flatten.sum != 7 }).to eq(nil)
          expect({1 => 1}.zip({2 => 2}, {3 => 3}) { |array| raise if array.flatten.sum != 12 }).to eq(nil)
          expect(service.collection({1 => 1}).zip([2], [3]) { |array| raise if array.flatten.sum != 7 }.result).to be_success.with_data(value: nil)
          expect(service.collection({1 => 1}).zip({2 => 2}, {3 => 3}) { |array| raise if array.flatten.sum != 12 }.result).to be_success.with_data(value: nil)
          expect((1..1).zip([2], [3]) { |array| raise if array.sum != 6 }).to eq(nil)
          expect(service.collection((1..1)).zip([2], [3]) { |array| raise if array.sum != 6 }.result).to be_success.with_data(value: nil)

          # Step with no outputs.
          expect([1].zip([2], [3]) { |numbers| step numbers_service, in: [numbers: -> { numbers }] }).to eq(nil)
          expect(service.collection(enumerable([1])).zip([2], [3]) { |numbers| step numbers_service, in: [numbers: -> { numbers }] }.result).to be_success.with_data(value: nil)
          expect(service.collection(enumerator([1])).zip([2], [3]) { |numbers| step numbers_service, in: [numbers: -> { numbers }] }.result).to be_success.with_data(value: nil)
          expect(service.collection(lazy_enumerator([1])).zip([2], [3]) { |numbers| step numbers_service, in: [numbers: -> { numbers }] }.result).to be_success.with_data(value: nil)
          expect(service.collection(chain_enumerator([1])).zip([2], [3]) { |numbers| step numbers_service, in: [numbers: -> { numbers }] }.result).to be_success.with_data(value: nil)
          expect(service.collection([1]).zip([2], [3]) { |numbers| step numbers_service, in: [numbers: -> { numbers }] }.result).to be_success.with_data(value: nil)
          expect(set([1]).zip([2], [3]) { |numbers| step numbers_service, in: [numbers: -> { numbers }] }).to eq(nil)
          expect(service.collection(set([1])).zip([2], [3]) { |numbers| step numbers_service, in: [numbers: -> { numbers }] }.result).to be_success.with_data(value: nil)
          expect(service.collection({1 => 1}).zip({2 => 2}, {3 => 3}) { |numbers| step numbers_service, in: [numbers: -> { numbers.flatten }] }.result).to be_success.with_data(value: nil)
          expect((1..1).zip([2], [3]) { |numbers| step numbers_service, in: [numbers: -> { numbers }] }).to eq(nil)
          expect(service.collection((1..1)).zip([2], [3]) { |numbers| step numbers_service, in: [numbers: -> { numbers }] }.result).to be_success.with_data(value: nil)

          # Step with one output.
          expect([1].zip([2], [3]) { |numbers| step numbers_service, in: [numbers: -> { numbers }], out: :number_strings }).to eq(nil)
          expect(service.collection(enumerable([1])).zip([2], [3]) { |numbers| step numbers_service, in: [numbers: -> { numbers }], out: :number_strings }.result).to be_success.with_data(value: nil)
          expect(service.collection(enumerator([1])).zip([2], [3]) { |numbers| step numbers_service, in: [numbers: -> { numbers }], out: :number_strings }.result).to be_success.with_data(value: nil)
          expect(service.collection(lazy_enumerator([1])).zip([2], [3]) { |numbers| step numbers_service, in: [numbers: -> { numbers }], out: :number_strings }.result).to be_success.with_data(value: nil)
          expect(service.collection(chain_enumerator([1])).zip([2], [3]) { |numbers| step numbers_service, in: [numbers: -> { numbers }], out: :number_strings }.result).to be_success.with_data(value: nil)
          expect(service.collection([1]).zip([2], [3]) { |numbers| step numbers_service, in: [numbers: -> { numbers }], out: :number_strings }.result).to be_success.with_data(value: nil)
          expect(set([1]).zip([2], [3]) { |numbers| step numbers_service, in: [numbers: -> { numbers }], out: :number_strings }).to eq(nil)
          expect(service.collection(set([1])).zip([2], [3]) { |numbers| step numbers_service, in: [numbers: -> { numbers }], out: :number_strings }.result).to be_success.with_data(value: nil)
          expect(service.collection({1 => 1}).zip([2], [3]) { |numbers| step numbers_service, in: [numbers: -> { numbers.flatten }], out: :number_strings }.result).to be_success.with_data(value: nil)
          expect(service.collection({1 => 1}).zip({2 => 2}, {3 => 3}) { |numbers| step numbers_service, in: [numbers: -> { numbers.flatten }], out: :number_strings }.result).to be_success.with_data(value: nil)
          expect((1..1).zip([2], [3]) { |numbers| step numbers_service, in: [numbers: -> { numbers }], out: :number_strings }).to eq(nil)
          expect(service.collection((1..1)).zip([2], [3]) { |numbers| step numbers_service, in: [numbers: -> { numbers }], out: :number_strings }.result).to be_success.with_data(value: nil)

          # Step with multiple outputs.
          expect([1].zip([2], [3]) { |numbers| step numbers_service, in: [numbers: -> { numbers }], out: [:number_strings, :number_codes] }).to eq(nil)
          expect(service.collection(enumerable([1])).zip([2], [3]) { |numbers| step numbers_service, in: [numbers: -> { numbers }], out: [:number_strings, :number_codes] }.result).to be_success.with_data(value: nil)
          expect(service.collection(enumerator([1])).zip([2], [3]) { |numbers| step numbers_service, in: [numbers: -> { numbers }], out: [:number_strings, :number_codes] }.result).to be_success.with_data(value: nil)
          expect(service.collection(lazy_enumerator([1])).zip([2], [3]) { |numbers| step numbers_service, in: [numbers: -> { numbers }], out: [:number_strings, :number_codes] }.result).to be_success.with_data(value: nil)
          expect(service.collection(chain_enumerator([1])).zip([2], [3]) { |numbers| step numbers_service, in: [numbers: -> { numbers }], out: [:number_strings, :number_codes] }.result).to be_success.with_data(value: nil)
          expect(service.collection([1]).zip([2], [3]) { |numbers| step numbers_service, in: [numbers: -> { numbers }], out: [:number_strings, :number_codes] }.result).to be_success.with_data(value: nil)
          expect(set([1]).zip([2], [3]) { |numbers| step numbers_service, in: [numbers: -> { numbers }], out: [:number_strings, :number_codes] }).to eq(nil)
          expect(service.collection(set([1])).zip([2], [3]) { |numbers| step numbers_service, in: [numbers: -> { numbers }], out: [:number_strings, :number_codes] }.result).to be_success.with_data(value: nil)
          expect(service.collection({1 => 1}).zip([2], [3]) { |numbers| step numbers_service, in: [numbers: -> { numbers.flatten }], out: [:number_strings, :number_codes] }.result).to be_success.with_data(value: nil)
          expect(service.collection({1 => 1}).zip({2 => 2}, {3 => 3}) { |numbers| step numbers_service, in: [numbers: -> { numbers.flatten }], out: [:number_strings, :number_codes] }.result).to be_success.with_data(value: nil)
          expect((1..1).zip([2], [3]) { |numbers| step numbers_service, in: [numbers: -> { numbers }], out: [:number_strings, :number_codes] }).to eq(nil)
          expect(service.collection((1..1)).zip([2], [3]) { |numbers| step numbers_service, in: [numbers: -> { numbers }], out: [:number_strings, :number_codes] }.result).to be_success.with_data(value: nil)

          # NOTE: Error result.
          expect([1].zip([-1], [3]) { |numbers| step numbers_service, in: [numbers: -> { numbers }], out: [:number_strings, :number_codes] }).to eq(nil)
          expect(service.collection(enumerable([1])).zip([-1], [3]) { |numbers| step numbers_service, in: [numbers: -> { numbers }], out: [:number_strings, :number_codes] }.result).to be_error.without_data
          expect(service.collection(enumerator([1])).zip([-1], [3]) { |numbers| step numbers_service, in: [numbers: -> { numbers }], out: [:number_strings, :number_codes] }.result).to be_error.without_data
          expect(service.collection(lazy_enumerator([1])).zip([-1], [3]) { |numbers| step numbers_service, in: [numbers: -> { numbers }], out: [:number_strings, :number_codes] }.result).to be_error.without_data
          expect(service.collection(chain_enumerator([1])).zip([-1], [3]) { |numbers| step numbers_service, in: [numbers: -> { numbers }], out: [:number_strings, :number_codes] }.result).to be_error.without_data
          expect(service.collection([1]).zip([-1], [3]) { |numbers| step numbers_service, in: [numbers: -> { numbers }], out: [:number_strings, :number_codes] }.result).to be_error.without_data
          expect(set([1]).zip([-1], [3]) { |numbers| step numbers_service, in: [numbers: -> { numbers }], out: [:number_strings, :number_codes] }).to eq(nil)
          expect(service.collection(set([1])).zip([-1], [3]) { |numbers| step numbers_service, in: [numbers: -> { numbers }], out: [:number_strings, :number_codes] }.result).to be_error.without_data
          expect(service.collection({1 => 1}).zip([-1], [3]) { |numbers| step numbers_service, in: [numbers: -> { numbers.flatten }], out: [:number_strings, :number_codes] }.result).to be_error.without_data
          expect(service.collection({1 => 1}).zip({-1 => -1}, {3 => 3}) { |numbers| step numbers_service, in: [numbers: -> { numbers.flatten }], out: [:number_strings, :number_codes] }.result).to be_error.without_data
          expect(service.collection((1..1)).zip([-1], [3]) { |numbers| step numbers_service, in: [numbers: -> { numbers }], out: [:number_strings, :number_codes] }.result).to be_error.without_data

          # NOTE: Error propagation.
          expect(service.collection(enumerable([:success, :error, :exception])).filter { |status| step status_service, in: [status: -> { status }] }.zip([2], [3]).result).to be_error.without_data
          expect(service.collection(enumerator([:success, :error, :exception])).filter { |status| step status_service, in: [status: -> { status }] }.zip([2], [3]).result).to be_error.without_data
          expect(service.collection(lazy_enumerator([:success, :error, :exception])).filter { |status| step status_service, in: [status: -> { status }] }.zip([2], [3]).result).to be_error.without_data
          expect(service.collection(chain_enumerator([:success, :error, :exception])).filter { |status| step status_service, in: [status: -> { status }] }.zip([2], [3]).result).to be_error.without_data
          expect(service.collection([:success, :error, :exception]).filter { |status| step status_service, in: [status: -> { status }] }.zip([2], [3]).result).to be_error.without_data

          expect(service.collection(set([:success, :error, :exception])).filter { |status| step status_service, in: [status: -> { status }] }.zip([2], [3]).result).to be_error.without_data
          expect(service.collection({success: :success, error: :error, exception: :exception}).filter { |key, value| step status_service, in: [status: -> { value }] }.zip([2], [3]).result).to be_error.without_data
          expect(service.collection((:error..:error)).filter { |status| step status_service, in: [status: -> { status }] }.zip([2], [3]).result).to be_error.without_data

          # NOTE: Usage on terminal chaining.
          expect { service.collection(enumerable([:success, :exception, :exception])).first.zip([2], [3]) }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection(enumerator([:success, :exception, :exception])).first.zip([2], [3]) }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection(lazy_enumerator([:success, :exception, :exception])).first.zip([2], [3]) }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection(chain_enumerator([:success, :exception, :exception])).first.zip([2], [3]) }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection([:success, :exception, :exception]).first.zip([2], [3]) }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)

          expect { service.collection(set([:success, :exception, :exception])).first.zip([2], [3]) }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection({success: :success, exception: :exception}).first.zip([2], [3]).result }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
          expect { service.collection((:success..:success)).first.zip([2], [3]) }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
        end
      end

      # first(2) => [only_one] # What to do? success of failure?
      # cycle(2) => nil # What to do? success without data?
      # drop(2) => [] # What to do? success when nothing dropped?

      # add not_step specs.
      # failure propagation

      # check return type
      # delegate
      # select no block
      # failure and error messages
      # range skip evaluate_by
      # arithmetic sequence
      # more reliable check than number.to_s.ord
      # review missing no block for set, hash
      # cast in zip and chain
      # return step_aware_set_from(enumerable.to_set,
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers, RSpec/DescribeClass, RSpec/ExampleLength, RSpec/MissingExampleGroupArgument, RSpec/MultipleExpectations
