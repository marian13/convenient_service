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
      end
    end

    example_group "instance methods" do
      let(:service_class) do
        Class.new do
          include ConvenientService::Standard::Config
        end
      end

      let(:service) { service_class.new }

      let(:nested_service) do
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

      let(:conditional_block_with_nested_arrays) do
        proc do |status|
          case status
          when :success then [true]
          when :failure then [false]
          when :exception then raise
          else
            raise
          end
        end
      end

      let(:step_with_one_output_block) do
        proc do |status|
          service.step nested_service,
            in: [status: -> { status }],
            out: :status_string
        end
      end

      let(:step_with_multiple_outputs_block) do
        proc do |status|
          service.step nested_service,
            in: [status: -> { status }],
            out: [
              :status_string,
              :status_code
            ]
        end
      end

      let(:exception_block) { proc { raise } }

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

      example_group "combinations" do
        specify do
          # NOTE: Boolean.
          # expect(service.collection(enumerable([:success, :success, :success])).all?.all?.result).to be_success.without_data
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
          expect(service.collection(enumerable([:success, :success, :success])).all? { |status| step nested_service, in: [status: -> { status }] }.result).to be_success.without_data
          expect(service.collection(enumerator([:success, :success, :success])).all? { |status| step nested_service, in: [status: -> { status }] }.result).to be_success.without_data
          expect(service.collection(lazy_enumerator([:success, :success, :success])).all? { |status| step nested_service, in: [status: -> { status }] }.result).to be_success.without_data
          expect(service.collection(chain_enumerator([:success, :success, :success])).all? { |status| step nested_service, in: [status: -> { status }] }.result).to be_success.without_data
          expect(service.collection([:success, :success, :success]).all? { |status| step nested_service, in: [status: -> { status }] }.result).to be_success.without_data
          expect(service.collection(set([:success, :success, :success])).all? { |status| step nested_service, in: [status: -> { status }] }.result).to be_success.without_data

          expect(service.collection({success: :success}).all? { |key, value| step nested_service, in: [status: -> { value }] }.result).to be_success.without_data
          expect(service.collection((:success..:success)).all? { |status| step nested_service, in: [status: -> { status }] }.result).to be_success.without_data

          # NOTE: Not matched step with no outputs.
          expect(service.collection(enumerable([:success, :failure, :exception])).all? { |status| step nested_service, in: [status: -> { status }] }.result).to be_failure.without_data
          expect(service.collection(enumerator([:success, :failure, :exception])).all? { |status| step nested_service, in: [status: -> { status }] }.result).to be_failure.without_data
          expect(service.collection(lazy_enumerator([:success, :failure, :exception])).all? { |status| step nested_service, in: [status: -> { status }] }.result).to be_failure.without_data
          expect(service.collection(chain_enumerator([:success, :failure, :exception])).all? { |status| step nested_service, in: [status: -> { status }] }.result).to be_failure.without_data
          expect(service.collection([:success, :failure, :exception]).all? { |status| step nested_service, in: [status: -> { status }] }.result).to be_failure.without_data
          expect(service.collection(set([:success, :failure, :exception])).all? { |status| step nested_service, in: [status: -> { status }] }.result).to be_failure.without_data

          expect(service.collection({success: :success, failure: :failure, exception: :exception}).all? { |key, value| step nested_service, in: [status: -> { value }] }.result).to be_failure.without_data
          expect(service.collection((:failure..:failure)).all? { |status| step nested_service, in: [status: -> { status }] }.result).to be_failure.without_data

          # NOTE: Matched step with one output.
          expect(service.collection(enumerable([:success, :success, :success])).all? { |status| step nested_service, in: [status: -> { status }], out: :status_string }.result).to be_success.without_data
          expect(service.collection(enumerator([:success, :success, :success])).all? { |status| step nested_service, in: [status: -> { status }], out: :status_string }.result).to be_success.without_data
          expect(service.collection(lazy_enumerator([:success, :success, :success])).all? { |status| step nested_service, in: [status: -> { status }], out: :status_string }.result).to be_success.without_data
          expect(service.collection(chain_enumerator([:success, :success, :success])).all? { |status| step nested_service, in: [status: -> { status }], out: :status_string }.result).to be_success.without_data
          expect(service.collection([:success, :success, :success]).all? { |status| step nested_service, in: [status: -> { status }], out: :status_string }.result).to be_success.without_data
          expect(service.collection(set([:success, :success, :success])).all? { |status| step nested_service, in: [status: -> { status }], out: :status_string }.result).to be_success.without_data

          expect(service.collection({success: :success}).all? { |key, value| step nested_service, in: [status: -> { value }], out: :status_string }.result).to be_success.without_data
          expect(service.collection((:success..:success)).all? { |status| step nested_service, in: [status: -> { status }], out: :status_string }.result).to be_success.without_data

          # NOTE: Not matched step with one output.
          expect(service.collection(enumerable([:success, :failure, :exception])).all? { |status| step nested_service, in: [status: -> { status }], out: :status_string }.result).to be_failure.without_data
          expect(service.collection(enumerator([:success, :failure, :exception])).all? { |status| step nested_service, in: [status: -> { status }], out: :status_string }.result).to be_failure.without_data
          expect(service.collection(lazy_enumerator([:success, :failure, :exception])).all? { |status| step nested_service, in: [status: -> { status }], out: :status_string }.result).to be_failure.without_data
          expect(service.collection(chain_enumerator([:success, :failure, :exception])).all? { |status| step nested_service, in: [status: -> { status }], out: :status_string }.result).to be_failure.without_data
          expect(service.collection([:success, :failure, :exception]).all? { |status| step nested_service, in: [status: -> { status }], out: :status_string }.result).to be_failure.without_data
          expect(service.collection(set([:success, :failure, :exception])).all? { |status| step nested_service, in: [status: -> { status }], out: :status_string }.result).to be_failure.without_data

          expect(service.collection({success: :success, failure: :failure, exception: :exception}).all? { |key, value| step nested_service, in: [status: -> { value }], out: :status_string }.result).to be_failure.without_data
          expect(service.collection((:failure..:failure)).all? { |status| step nested_service, in: [status: -> { status }], out: :status_string }.result).to be_failure.without_data

          # NOTE: Matched step with multiple outputs.
          expect(service.collection(enumerable([:success, :success, :success])).all? { |status| step nested_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.without_data
          expect(service.collection(enumerator([:success, :success, :success])).all? { |status| step nested_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.without_data
          expect(service.collection(lazy_enumerator([:success, :success, :success])).all? { |status| step nested_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.without_data
          expect(service.collection(chain_enumerator([:success, :success, :success])).all? { |status| step nested_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.without_data
          expect(service.collection([:success, :success, :success]).all? { |status| step nested_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.without_data
          expect(service.collection(set([:success, :success, :success])).all? { |status| step nested_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.without_data

          expect(service.collection({success: :success}).all? { |key, value| step nested_service, in: [status: -> { value }], out: [:status_string, :status_code] }.result).to be_success.without_data
          expect(service.collection((:success..:success)).all? { |status| step nested_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.without_data

          # NOTE: Not matched step with multiple outputs.
          expect(service.collection(enumerable([:success, :failure, :exception])).all? { |status| step nested_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_failure.without_data
          expect(service.collection(enumerator([:success, :failure, :exception])).all? { |status| step nested_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_failure.without_data
          expect(service.collection(lazy_enumerator([:success, :failure, :exception])).all? { |status| step nested_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_failure.without_data
          expect(service.collection(chain_enumerator([:success, :failure, :exception])).all? { |status| step nested_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_failure.without_data
          expect(service.collection([:success, :failure, :exception]).all? { |status| step nested_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_failure.without_data
          expect(service.collection(set([:success, :failure, :exception])).all? { |status| step nested_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_failure.without_data

          expect(service.collection({success: :success, failure: :failure, exception: :exception}).all? { |key, value| step nested_service, in: [status: -> { value }], out: [:status_string, :status_code] }.result).to be_failure.without_data
          expect(service.collection((:failure..:failure)).all? { |status| step nested_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_failure.without_data

          # NOTE: Error result.
          expect(service.collection(enumerable([:success, :error, :exception])).all? { |status| step nested_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection(enumerator([:success, :error, :exception])).all? { |status| step nested_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection(lazy_enumerator([:success, :error, :exception])).all? { |status| step nested_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection(chain_enumerator([:success, :error, :exception])).all? { |status| step nested_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection([:success, :error, :exception]).all? { |status| step nested_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection(set([:success, :error, :exception])).all? { |status| step nested_service, in: [status: -> { status }] }.result).to be_error.without_data

          expect(service.collection({success: :success, error: :error, exception: :exception}).all? { |key, value| step nested_service, in: [status: -> { value }] }.result).to be_error.without_data
          expect(service.collection((:error..:error)).all? { |status| step nested_service, in: [status: -> { status }] }.result).to be_error.without_data

          # NOTE: Error propagation.
          expect(service.collection(enumerable([:success, :error, :exception])).select { |status| step nested_service, in: [status: -> { status }] }.all?.result).to be_error.without_data
          expect(service.collection(enumerator([:success, :error, :exception])).select { |status| step nested_service, in: [status: -> { status }] }.all?.result).to be_error.without_data
          expect(service.collection(lazy_enumerator([:success, :error, :exception])).select { |status| step nested_service, in: [status: -> { status }] }.all?.result).to be_error.without_data
          expect(service.collection(chain_enumerator([:success, :error, :exception])).select { |status| step nested_service, in: [status: -> { status }] }.all?.result).to be_error.without_data
          expect(service.collection([:success, :error, :exception]).select { |status| step nested_service, in: [status: -> { status }] }.all?.result).to be_error.without_data
          expect(service.collection(set([:success, :error, :exception])).select { |status| step nested_service, in: [status: -> { status }] }.all?.result).to be_error.without_data

          expect(service.collection({success: :success, error: :error, exception: :exception}).select { |key, value| step nested_service, in: [status: -> { value }] }.all?.result).to be_error.without_data
          expect(service.collection((:error..:error)).select { |status| step nested_service, in: [status: -> { status }] }.all?.result).to be_error.without_data

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
          expect(service.collection(enumerable([:failure, :success, :exception])).any? { |status| step nested_service, in: [status: -> { status }] }.result).to be_success.without_data
          expect(service.collection(enumerator([:failure, :success, :exception])).any? { |status| step nested_service, in: [status: -> { status }] }.result).to be_success.without_data
          expect(service.collection(lazy_enumerator([:failure, :success, :exception])).any? { |status| step nested_service, in: [status: -> { status }] }.result).to be_success.without_data
          expect(service.collection(chain_enumerator([:failure, :success, :exception])).any? { |status| step nested_service, in: [status: -> { status }] }.result).to be_success.without_data
          expect(service.collection([:failure, :success, :exception]).any? { |status| step nested_service, in: [status: -> { status }] }.result).to be_success.without_data
          expect(service.collection(set([:failure, :success, :exception])).any? { |status| step nested_service, in: [status: -> { status }] }.result).to be_success.without_data

          expect(service.collection({failure: :failure, success: :success, exception: :exception}).any? { |key, value| step nested_service, in: [status: -> { value }] }.result).to be_success.without_data
          expect(service.collection((:success..:success)).any? { |status| step nested_service, in: [status: -> { status }] }.result).to be_success.without_data

          # NOTE: Not matched step with no outputs.
          expect(service.collection(enumerable([:failure, :failure, :failure])).any? { |status| step nested_service, in: [status: -> { status }] }.result).to be_failure.without_data
          expect(service.collection(enumerator([:failure, :failure, :failure])).any? { |status| step nested_service, in: [status: -> { status }] }.result).to be_failure.without_data
          expect(service.collection(lazy_enumerator([:failure, :failure, :failure])).any? { |status| step nested_service, in: [status: -> { status }] }.result).to be_failure.without_data
          expect(service.collection(chain_enumerator([:failure, :failure, :failure])).any? { |status| step nested_service, in: [status: -> { status }] }.result).to be_failure.without_data
          expect(service.collection([:failure, :failure, :failure]).any? { |status| step nested_service, in: [status: -> { status }] }.result).to be_failure.without_data
          expect(service.collection(set([:failure, :failure, :failure])).any? { |status| step nested_service, in: [status: -> { status }] }.result).to be_failure.without_data

          expect(service.collection({failure: :failure}).any? { |key, value| step nested_service, in: [status: -> { value }] }.result).to be_failure.without_data
          expect(service.collection((:failure..:failure)).any? { |status| step nested_service, in: [status: -> { status }] }.result).to be_failure.without_data

          # NOTE: Matched step with one output.
          expect(service.collection(enumerable([:failure, :success, :exception])).any? { |status| step nested_service, in: [status: -> { status }], out: :status_string }.result).to be_success.without_data
          expect(service.collection(enumerator([:failure, :success, :exception])).any? { |status| step nested_service, in: [status: -> { status }], out: :status_string }.result).to be_success.without_data
          expect(service.collection(lazy_enumerator([:failure, :success, :exception])).any? { |status| step nested_service, in: [status: -> { status }], out: :status_string }.result).to be_success.without_data
          expect(service.collection(chain_enumerator([:failure, :success, :exception])).any? { |status| step nested_service, in: [status: -> { status }], out: :status_string }.result).to be_success.without_data
          expect(service.collection([:failure, :success, :exception]).any? { |status| step nested_service, in: [status: -> { status }], out: :status_string }.result).to be_success.without_data
          expect(service.collection(set([:failure, :success, :exception])).any? { |status| step nested_service, in: [status: -> { status }], out: :status_string }.result).to be_success.without_data

          expect(service.collection({failure: :failure, success: :success, exception: :exception}).any? { |key, value| step nested_service, in: [status: -> { value }], out: :status_string }.result).to be_success.without_data
          expect(service.collection((:success..:success)).any? { |status| step nested_service, in: [status: -> { status }], out: :status_string }.result).to be_success.without_data

          # NOTE: Not matched step with one output.
          expect(service.collection(enumerable([:failure, :failure, :failure])).any? { |status| step nested_service, in: [status: -> { status }], out: :status_string }.result).to be_failure.without_data
          expect(service.collection(enumerator([:failure, :failure, :failure])).any? { |status| step nested_service, in: [status: -> { status }], out: :status_string }.result).to be_failure.without_data
          expect(service.collection(lazy_enumerator([:failure, :failure, :failure])).any? { |status| step nested_service, in: [status: -> { status }], out: :status_string }.result).to be_failure.without_data
          expect(service.collection(chain_enumerator([:failure, :failure, :failure])).any? { |status| step nested_service, in: [status: -> { status }], out: :status_string }.result).to be_failure.without_data
          expect(service.collection([:failure, :failure, :failure]).any? { |status| step nested_service, in: [status: -> { status }], out: :status_string }.result).to be_failure.without_data
          expect(service.collection(set([:failure, :failure, :failure])).any? { |status| step nested_service, in: [status: -> { status }], out: :status_string }.result).to be_failure.without_data

          expect(service.collection({failure: :failure}).any? { |key, value| step nested_service, in: [status: -> { value }], out: :status_string }.result).to be_failure.without_data
          expect(service.collection((:failure..:failure)).any? { |status| step nested_service, in: [status: -> { status }], out: :status_string }.result).to be_failure.without_data

          # NOTE: Matched step with multiple outputs.
          expect(service.collection(enumerable([:failure, :success, :exception])).any? { |status| step nested_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.without_data
          expect(service.collection(enumerator([:failure, :success, :exception])).any? { |status| step nested_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.without_data
          expect(service.collection(lazy_enumerator([:failure, :success, :exception])).any? { |status| step nested_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.without_data
          expect(service.collection(chain_enumerator([:failure, :success, :exception])).any? { |status| step nested_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.without_data
          expect(service.collection([:failure, :success, :exception]).any? { |status| step nested_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.without_data
          expect(service.collection(set([:failure, :success, :exception])).any? { |status| step nested_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.without_data

          expect(service.collection({failure: :failure, success: :success, exception: :exception}).any? { |key, value| step nested_service, in: [status: -> { value }], out: [:status_string, :status_code] }.result).to be_success.without_data
          expect(service.collection((:success..:success)).any? { |status| step nested_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.without_data

          # NOTE: Not matched step with multiple outputs.
          expect(service.collection(enumerable([:failure, :failure, :failure])).any? { |status| step nested_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_failure.without_data
          expect(service.collection(enumerator([:failure, :failure, :failure])).any? { |status| step nested_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_failure.without_data
          expect(service.collection(lazy_enumerator([:failure, :failure, :failure])).any? { |status| step nested_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_failure.without_data
          expect(service.collection(chain_enumerator([:failure, :failure, :failure])).any? { |status| step nested_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_failure.without_data
          expect(service.collection([:failure, :failure, :failure]).any? { |status| step nested_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_failure.without_data
          expect(service.collection(set([:failure, :failure, :failure])).any? { |status| step nested_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_failure.without_data

          expect(service.collection({failure: :failure}).any? { |key, value| step nested_service, in: [status: -> { value }], out: [:status_string, :status_code] }.result).to be_failure.without_data
          expect(service.collection((:failure..:failure)).any? { |status| step nested_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_failure.without_data

          # NOTE: Error result.
          expect(service.collection(enumerable([:failure, :error, :exception])).any? { |status| step nested_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection(enumerator([:failure, :error, :exception])).any? { |status| step nested_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection(lazy_enumerator([:failure, :error, :exception])).any? { |status| step nested_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection(chain_enumerator([:failure, :error, :exception])).any? { |status| step nested_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection([:failure, :error, :exception]).any? { |status| step nested_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection(set([:failure, :error, :exception])).any? { |status| step nested_service, in: [status: -> { status }] }.result).to be_error.without_data

          expect(service.collection({failure: :failure, error: :error, exception: :exception}).any? { |key, value| step nested_service, in: [status: -> { value }] }.result).to be_error.without_data
          expect(service.collection((:error..:error)).any? { |status| step nested_service, in: [status: -> { status }] }.result).to be_error.without_data

          # NOTE: Error propagation.
          expect(service.collection(enumerable([:failure, :error, :exception])).select { |status| step nested_service, in: [status: -> { status }] }.any?.result).to be_error.without_data
          expect(service.collection(enumerator([:failure, :error, :exception])).select { |status| step nested_service, in: [status: -> { status }] }.any?.result).to be_error.without_data
          expect(service.collection(lazy_enumerator([:failure, :error, :exception])).select { |status| step nested_service, in: [status: -> { status }] }.any?.result).to be_error.without_data
          expect(service.collection(chain_enumerator([:failure, :error, :exception])).select { |status| step nested_service, in: [status: -> { status }] }.any?.result).to be_error.without_data
          expect(service.collection([:failure, :error, :exception]).select { |status| step nested_service, in: [status: -> { status }] }.any?.result).to be_error.without_data
          expect(service.collection(set([:failure, :error, :exception])).select { |status| step nested_service, in: [status: -> { status }] }.any?.result).to be_error.without_data

          expect(service.collection({failure: :failure, error: :error, exception: :exception}).select { |key, value| step nested_service, in: [status: -> { value }] }.any?.result).to be_error.without_data
          expect(service.collection((:error..:error)).select { |status| step nested_service, in: [status: -> { status }] }.any?.result).to be_error.without_data

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

      xdescribe "#chain" do
        specify do
          # empty
          expect([].chain([:success], [:success]).to_a).to eq([:success, :success])
          expect(service.collection([]).chain([:success], [:success]).result).to be_success.with_data(values: instance_of(Enumerator::Chain)).comparing_by(:===)
          expect(service.collection([]).chain([:success], [:success]).result.unsafe_data[:values].to_a).to eq([:success, :success])

          # not empty
          expect([:success].chain([:success], [:success]).to_a).to eq([:success, :success, :success])
          expect(service.collection([:success]).chain([:success], [:success]).result).to be_success.with_data(values: instance_of(Enumerator::Chain)).comparing_by(:===)
          expect(service.collection([:success]).chain([:success], [:success]).result.unsafe_data[:values].to_a).to eq([:success, :success, :success])

          # no args
          expect([:success].chain.to_a).to eq([:success])
          expect(service.collection([:success]).chain.result).to be_success.with_data(values: instance_of(Enumerator::Chain)).comparing_by(:===)
          expect(service.collection([:success]).chain.result.unsafe_data[:values].to_a).to eq([:success])

          # with `Enumerator` arg
          expect([:success].chain([:success].each).to_a).to eq([:success, :success])
          expect(service.collection([:success]).chain([:success].each).result).to be_success.with_data(values: instance_of(Enumerator::Chain)).comparing_by(:===)
          expect(service.collection([:success]).chain([:success].each).result.unsafe_data[:values].to_a).to eq([:success, :success])

          # with `Enumerator::Lazy` arg
          expect([:success].chain([:success].lazy).to_a).to eq([:success, :success])
          expect(service.collection([:success]).chain([:success].lazy).result).to be_success.with_data(values: instance_of(Enumerator::Lazy)).comparing_by(:===)
          expect(service.collection([:success]).chain([:success].lazy).result.unsafe_data[:values].to_a).to eq([:success, :success])

          # with `StepAwareCollections::Enumerable` arg
          expect([:success].chain(service.collection([:success])).to_a).to eq([:success, :success])
          expect(service.collection([:success]).chain(service.collection([:success])).result).to be_success.with_data(values: instance_of(Enumerator::Chain)).comparing_by(:===)
          expect(service.collection([:success]).chain(service.collection([:success])).result.unsafe_data[:values].to_a).to eq([:success, :success])

          # with `StepAwareCollections::Enumerator` arg
          expect([:success].chain(service.collection([:success].each)).to_a).to eq([:success, :success])
          expect(service.collection([:success]).chain(service.collection([:success].each)).result).to be_success.with_data(values: instance_of(Enumerator::Chain)).comparing_by(:===)
          expect(service.collection([:success]).chain(service.collection([:success].each)).result.unsafe_data[:values].to_a).to eq([:success, :success])

          # with `StepAwareCollections::LazyEnumerator` arg
          expect([:success].chain(service.collection([:success].lazy)).to_a).to eq([:success, :success])
          expect(service.collection([:success]).chain(service.collection([:success].lazy)).result).to be_success.with_data(values: instance_of(Enumerator::Lazy)).comparing_by(:===)
          expect(service.collection([:success]).chain(service.collection([:success].lazy)).result.unsafe_data[:values].to_a).to eq([:success, :success])

          # invalid cast
          expect { service.collection([:success]).chain(:exception) }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::CollectionIsNotEnumerable)

          # error propagation
          expect(service.collection([:failure, :error, :exception]).each(&step_without_outputs_block).chain([:exception]).result).to be_error.without_data

          # already used boolean value terminal chaining
          expect { service.collection([:success]).all?.chain([:success]) }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)

          # already used singular value terminal chaining
          expect { service.collection([:success]).first.chain([:success]) }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
        end
      end

      xdescribe "#chunk" do
        let(:nested_service) do
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
              when nil then success(status_string: "ok", status_code: 200)
              when :separator then success(status_string: "ok", status_code: 200)
              when :alone then success(status_string: "ok", status_code: 200)
              when :exception then raise
              else
                raise
              end
            end
          end
        end

        let(:conditional_block) do
          proc do |status|
            case status
            when :success then true
            when :failure then false
            when nil then nil
            when :separator then :_separator
            when :alone then :_alone
            when :exception then raise
            else
              raise
            end
          end
        end

        let(:indirect_service) do
          Class.new do
            include ConvenientService::Standard::Config

            attr_reader :status

            def initialize(status:)
              @status = status
            end

            def result
              case status
              when :success then success(special_key: true)
              when :failure then success(special_key: false)
              when :error then error
              when nil then success(special_key: nil)
              when :separator then success(special_key: :_separator)
              when :alone then success(special_key: :_alone)
              when :exception then raise
              else
                raise
              end
            end
          end
        end

        let(:indirect_step_block) do
          proc do |status|
            service.step indirect_service,
              in: [status: -> { status }],
              out: :special_key
          end
        end

        specify do
          # empty
          expect([].chunk(&conditional_block).to_a).to eq([])
          expect(service.collection([]).chunk(&conditional_block).result).to be_success.with_data(values: instance_of(Array)).comparing_by(:===)
          expect(service.collection([]).chunk(&conditional_block).result.unsafe_data[:values].to_a).to eq([])
          expect(service.collection([]).chunk(&step_without_outputs_block).result).to be_success.with_data(values: instance_of(Array)).comparing_by(:===)
          expect(service.collection([]).chunk(&step_without_outputs_block).result.unsafe_data[:values].to_a).to eq([])

          # satisfied/not satisfied condition
          expect([:success, :failure, :success, :failure].chunk(&conditional_block).to_a).to eq([[true, [:success]], [false, [:failure]], [true, [:success]], [false, [:failure]]])
          expect(service.collection([:success, :failure, :success, :failure]).chunk(&conditional_block).result).to be_success.with_data(values: instance_of(Array)).comparing_by(:===)
          expect(service.collection([:success, :failure, :success, :failure]).chunk(&conditional_block).result.unsafe_data[:values].to_a).to eq([[true, [:success]], [false, [:failure]], [true, [:success]], [false, [:failure]]])
          expect(service.collection([:success, :failure, :success, :failure]).chunk(&step_without_outputs_block).result).to be_success.with_data(values: instance_of(Array)).comparing_by(:===)
          expect(service.collection([:success, :failure, :success, :failure]).chunk(&step_without_outputs_block).result.unsafe_data[:values].to_a).to eq([[true, [:success]], [false, [:failure]], [true, [:success]], [false, [:failure]]])
          expect(service.collection([:success, :failure, :success, :failure]).chunk(&step_with_one_output_block).result.unsafe_data[:values].to_a).to eq([["ok", [:success]], ["ok", [:success]]])
          expect(service.collection([:success, :failure, :success, :failure]).chunk(&step_with_multiple_outputs_block).result.unsafe_data[:values].to_a).to eq([[{status_string: "ok", status_code: 200}, [:success]], [{}, [:failure]], [{status_string: "ok", status_code: 200}, [:success]], [{}, [:failure]]])

          # direct nil, separator, alone
          expect([nil, :success, :separator, :failure, :alone].chunk(&conditional_block).to_a).to eq([[true, [:success]], [false, [:failure]], [:_alone, [:alone]]])
          expect(service.collection([nil, :success, :separator, :failure, :alone]).chunk(&conditional_block).result).to be_success.with_data(values: instance_of(Array)).comparing_by(:===)
          expect(service.collection([nil, :success, :separator, :failure, :alone]).chunk(&conditional_block).result.unsafe_data[:values].to_a).to eq([[true, [:success]], [false, [:failure]], [:_alone, [:alone]]])
          expect(service.collection([nil, :success, :separator, :failure, :alone]).chunk(&step_without_outputs_block).result).to be_success.with_data(values: instance_of(Array)).comparing_by(:===)
          expect(service.collection([nil, :success, :separator, :failure, :alone]).chunk(&step_without_outputs_block).result.unsafe_data[:values].to_a).to eq([[true, [nil, :success, :separator]], [false, [:failure]], [true, [:alone]]])
          expect(service.collection([nil, :success, :separator, :failure, :alone]).chunk(&step_with_one_output_block).result.unsafe_data[:values].to_a).to eq([["ok", [nil, :success, :separator]], ["ok", [:alone]]])
          expect(service.collection([nil, :success, :separator, :failure, :alone]).chunk(&step_with_multiple_outputs_block).result.unsafe_data[:values].to_a).to eq([[{status_string: "ok", status_code: 200}, [nil, :success, :separator]], [{}, [:failure]], [{status_string: "ok", status_code: 200}, [:alone]]])

          # indirect nil, separator, alone
          expect(service.collection([nil, :success, :separator, :failure, :alone]).chunk(&indirect_step_block).result.unsafe_data[:values].to_a).to eq([[true, [:success]], [false, [:failure]], [:_alone, [:alone]]])

          # error result
          expect(service.collection([:success, :error, :exception]).chunk(&step_without_outputs_block).result).to be_error.without_data

          # error propagation
          expect(service.collection([:success, :error, :exception]).each(&step_without_outputs_block).chunk(&exception_block).result).to be_error.without_data

          # already used boolean value terminal chaining
          expect { service.collection([:success]).all?.chunk(&exception_block) }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)

          # already used singular value terminal chaining
          expect { service.collection([:success]).first.chunk(&exception_block) }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
        end
      end

      xdescribe "#chunk_while" do
        let(:nested_service) do
          Class.new do
            include ConvenientService::Standard::Config

            attr_reader :previous_status, :current_status

            def initialize(previous_status:, current_status:)
              @previous_status = previous_status
              @current_status = current_status
            end

            def result
              if [previous_status, current_status].uniq == [:success] then success(status_string: "ok", status_code: 200)
              elsif [previous_status, current_status].include?(:error) then error
              elsif [previous_status, current_status].include?(:failure) then failure
              elsif [previous_status, current_status].include?(:exception) then raise
              else
                raise
              end
            end
          end
        end

        let(:conditional_block) do
          proc do |previous_status, current_status|
            if [previous_status, current_status].uniq == [:success] then true
            elsif [previous_status, current_status].include?(:error) then raise
            elsif [previous_status, current_status].include?(:failure) then false
            elsif [previous_status, current_status].include?(:exception) then raise
            else
              raise
            end
          end
        end

        let(:step_without_outputs_block) do
          proc do |previous_status, current_status|
            service.step nested_service,
              in: [
                previous_status: -> { previous_status },
                current_status: -> { current_status }
              ]
          end
        end

        specify do
          # empty
          expect([].chunk_while(&conditional_block).to_a).to eq([])
          expect(service.collection([]).chunk_while(&conditional_block).result).to be_success.with_data(values: instance_of(Array)).comparing_by(:===)
          expect(service.collection([]).chunk_while(&conditional_block).result.unsafe_data[:values].to_a).to eq([])
          expect(service.collection([]).chunk_while(&step_without_outputs_block).result).to be_success.with_data(values: instance_of(Array)).comparing_by(:===)
          expect(service.collection([]).chunk_while(&step_without_outputs_block).result.unsafe_data[:values].to_a).to eq([])

          # satisfied/not satisfied condition
          expect([:success, :success, :failure, :success, :success].chunk_while(&conditional_block).to_a).to eq([[:success, :success], [:failure], [:success, :success]])
          expect(service.collection([:success, :success, :failure, :success, :success]).chunk_while(&conditional_block).result).to be_success.with_data(values: instance_of(Array)).comparing_by(:===)
          expect(service.collection([:success, :success, :failure, :success, :success]).chunk_while(&conditional_block).result.unsafe_data[:values].to_a).to eq([[:success, :success], [:failure], [:success, :success]])
          expect(service.collection([:success, :success, :failure, :success, :success]).chunk_while(&step_without_outputs_block).result).to be_success.with_data(values: instance_of(Array)).comparing_by(:===)
          expect(service.collection([:success, :success, :failure, :success, :success]).chunk_while(&step_without_outputs_block).result.unsafe_data[:values].to_a).to eq([[:success, :success], [:failure], [:success, :success]])

          # error result
          expect(service.collection([:success, :success, :error, :exception]).chunk_while(&step_without_outputs_block).result).to be_error.without_data

          # error propagation
          expect(service.collection([:success, :success, :error, :exception]).each { |status| step_without_outputs_block.call(status, :error) }.chunk_while(&exception_block).result).to be_error.without_data

          # already used boolean value terminal chaining
          expect { service.collection([:success, :success]).all?.chunk_while(&exception_block) }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)

          # already used singular value terminal chaining
          expect { service.collection([:success, :success]).first.chunk_while(&exception_block) }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
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
          expect(service.collection(enumerable([:success, :success, :success])).collect { |status| step nested_service, in: [status: -> { status }] }.result).to be_success.with_data(values: [true, true, true])
          expect(service.collection(enumerator([:success, :success, :success])).collect { |status| step nested_service, in: [status: -> { status }] }.result).to be_success.with_data(values: [true, true, true])
          expect(service.collection(lazy_enumerator([:success, :success, :success])).collect { |status| step nested_service, in: [status: -> { status }] }.result).to be_success.with_data(values: [true, true, true])
          expect(service.collection(chain_enumerator([:success, :success, :success])).collect { |status| step nested_service, in: [status: -> { status }] }.result).to be_success.with_data(values: [true, true, true])
          expect(service.collection([:success, :success, :success]).collect { |status| step nested_service, in: [status: -> { status }] }.result).to be_success.with_data(values: [true, true, true])

          expect(service.collection(set([:success])).collect { |status| step nested_service, in: [status: -> { status }] }.result).to be_success.with_data(values: [true])
          expect(service.collection({success: :success}).collect { |key, value| step nested_service, in: [status: -> { value }] }.result).to be_success.with_data(values: [true])
          expect(service.collection((:success..:success)).collect { |status| step nested_service, in: [status: -> { status }] }.result).to be_success.with_data(values: [true])

          # NOTE: Step with one output.
          expect(service.collection(enumerable([:success, :success, :success])).collect { |status| step nested_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(values: ["ok", "ok", "ok"])
          expect(service.collection(enumerator([:success, :success, :success])).collect { |status| step nested_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(values: ["ok", "ok", "ok"])
          expect(service.collection(lazy_enumerator([:success, :success, :success])).collect { |status| step nested_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(values: ["ok", "ok", "ok"])
          expect(service.collection(chain_enumerator([:success, :success, :success])).collect { |status| step nested_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(values: ["ok", "ok", "ok"])
          expect(service.collection([:success, :success, :success]).collect { |status| step nested_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(values: ["ok", "ok", "ok"])

          expect(service.collection(set([:success])).collect { |status| step nested_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(values: ["ok"])
          expect(service.collection({success: :success}).collect { |key, value| step nested_service, in: [status: -> { value }], out: :status_string }.result).to be_success.with_data(values: ["ok"])
          expect(service.collection((:success..:success)).collect { |status| step nested_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(values: ["ok"])

          # NOTE: Step with multiple outputs.
          expect(service.collection(enumerable([:success, :success, :success])).collect { |status| step nested_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [{status_string: "ok", status_code: 200}, {status_string: "ok", status_code: 200}, {status_string: "ok", status_code: 200}])
          expect(service.collection(enumerator([:success, :success, :success])).collect { |status| step nested_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [{status_string: "ok", status_code: 200}, {status_string: "ok", status_code: 200}, {status_string: "ok", status_code: 200}])
          expect(service.collection(lazy_enumerator([:success, :success, :success])).collect { |status| step nested_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [{status_string: "ok", status_code: 200}, {status_string: "ok", status_code: 200}, {status_string: "ok", status_code: 200}])
          expect(service.collection(chain_enumerator([:success, :success, :success])).collect { |status| step nested_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [{status_string: "ok", status_code: 200}, {status_string: "ok", status_code: 200}, {status_string: "ok", status_code: 200}])
          expect(service.collection([:success, :success, :success]).collect { |status| step nested_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [{status_string: "ok", status_code: 200}, {status_string: "ok", status_code: 200}, {status_string: "ok", status_code: 200}])

          expect(service.collection(set([:success])).collect { |status| step nested_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [{status_string: "ok", status_code: 200}])
          expect(service.collection({success: :success}).collect { |key, value| step nested_service, in: [status: -> { value }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [{status_string: "ok", status_code: 200}])
          expect(service.collection((:success..:success)).collect { |status| step nested_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [{status_string: "ok", status_code: 200}])

          # NOTE: Error result.
          expect(service.collection(enumerable([:success, :error, :exception])).collect { |status| step nested_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection(enumerator([:success, :error, :exception])).collect { |status| step nested_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection(lazy_enumerator([:success, :error, :exception])).collect { |status| step nested_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection(chain_enumerator([:success, :error, :exception])).collect { |status| step nested_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection([:success, :error, :exception]).collect { |status| step nested_service, in: [status: -> { status }] }.result).to be_error.without_data

          expect(service.collection(set([:success, :error, :exception])).collect { |status| step nested_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection({success: :success, error: :error, exception: :exception}).collect { |key, value| step nested_service, in: [status: -> { value }] }.result).to be_error.without_data
          expect(service.collection((:error..:error)).collect { |status| step nested_service, in: [status: -> { status }] }.result).to be_error.without_data

          # NOTE: Error propagation.
          expect(service.collection(enumerable([:success, :error, :exception])).select { |status| step nested_service, in: [status: -> { status }] }.collect { |status| condition[status] }.result).to be_error.without_data
          expect(service.collection(enumerator([:success, :error, :exception])).select { |status| step nested_service, in: [status: -> { status }] }.collect { |status| condition[status] }.result).to be_error.without_data
          expect(service.collection(lazy_enumerator([:success, :error, :exception])).select { |status| step nested_service, in: [status: -> { status }] }.collect { |status| condition[status] }.result).to be_error.without_data
          expect(service.collection(chain_enumerator([:success, :error, :exception])).select { |status| step nested_service, in: [status: -> { status }] }.collect { |status| condition[status] }.result).to be_error.without_data
          expect(service.collection([:success, :error, :exception]).select { |status| step nested_service, in: [status: -> { status }] }.collect { |status| condition[status] }.result).to be_error.without_data

          expect(service.collection(set([:success, :error, :exception])).select { |status| step nested_service, in: [status: -> { status }] }.collect { |status| condition[status] }.result).to be_error.without_data
          expect(service.collection({success: :success, error: :error, exception: :exception}).select { |key, value| step nested_service, in: [status: -> { value }] }.collect { |key, value| condition[value] }.result).to be_error.without_data
          expect(service.collection((:error..:error)).select { |status| step nested_service, in: [status: -> { status }] }.collect { |status| condition[status] }.result).to be_error.without_data

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
          expect(service.collection(enumerable([:success, :success, :success])).collect_concat { |status| step nested_service, in: [status: -> { status }] }.result).to be_success.with_data(values: [true, true, true])
          expect(service.collection(enumerator([:success, :success, :success])).collect_concat { |status| step nested_service, in: [status: -> { status }] }.result).to be_success.with_data(values: [true, true, true])
          expect(service.collection(lazy_enumerator([:success, :success, :success])).collect_concat { |status| step nested_service, in: [status: -> { status }] }.result).to be_success.with_data(values: [true, true, true])
          expect(service.collection(chain_enumerator([:success, :success, :success])).collect_concat { |status| step nested_service, in: [status: -> { status }] }.result).to be_success.with_data(values: [true, true, true])
          expect(service.collection([:success, :success, :success]).collect_concat { |status| step nested_service, in: [status: -> { status }] }.result).to be_success.with_data(values: [true, true, true])

          expect(service.collection(set([:success])).collect_concat { |status| step nested_service, in: [status: -> { status }] }.result).to be_success.with_data(values: [true])
          expect(service.collection({success: :success}).collect_concat { |key, value| step nested_service, in: [status: -> { value }] }.result).to be_success.with_data(values: [true])
          expect(service.collection((:success..:success)).collect_concat { |status| step nested_service, in: [status: -> { status }] }.result).to be_success.with_data(values: [true])

          # NOTE: Step with one output.
          expect(service.collection(enumerable([:success, :success, :success])).collect_concat { |status| step nested_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(values: ["ok", "ok", "ok"])
          expect(service.collection(enumerator([:success, :success, :success])).collect_concat { |status| step nested_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(values: ["ok", "ok", "ok"])
          expect(service.collection(lazy_enumerator([:success, :success, :success])).collect_concat { |status| step nested_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(values: ["ok", "ok", "ok"])
          expect(service.collection(chain_enumerator([:success, :success, :success])).collect_concat { |status| step nested_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(values: ["ok", "ok", "ok"])
          expect(service.collection([:success, :success, :success]).collect_concat { |status| step nested_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(values: ["ok", "ok", "ok"])

          expect(service.collection(set([:success])).collect_concat { |status| step nested_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(values: ["ok"])
          expect(service.collection({success: :success}).collect_concat { |key, value| step nested_service, in: [status: -> { value }], out: :status_string }.result).to be_success.with_data(values: ["ok"])
          expect(service.collection((:success..:success)).collect_concat { |status| step nested_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(values: ["ok"])

          # NOTE: Step with multiple outputs.
          expect(service.collection(enumerable([:success, :success, :success])).collect_concat { |status| step nested_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [{status_string: "ok", status_code: 200}, {status_string: "ok", status_code: 200}, {status_string: "ok", status_code: 200}])
          expect(service.collection(enumerator([:success, :success, :success])).collect_concat { |status| step nested_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [{status_string: "ok", status_code: 200}, {status_string: "ok", status_code: 200}, {status_string: "ok", status_code: 200}])
          expect(service.collection(lazy_enumerator([:success, :success, :success])).collect_concat { |status| step nested_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [{status_string: "ok", status_code: 200}, {status_string: "ok", status_code: 200}, {status_string: "ok", status_code: 200}])
          expect(service.collection(chain_enumerator([:success, :success, :success])).collect_concat { |status| step nested_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [{status_string: "ok", status_code: 200}, {status_string: "ok", status_code: 200}, {status_string: "ok", status_code: 200}])
          expect(service.collection([:success, :success, :success]).collect_concat { |status| step nested_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [{status_string: "ok", status_code: 200}, {status_string: "ok", status_code: 200}, {status_string: "ok", status_code: 200}])

          expect(service.collection(set([:success])).collect_concat { |status| step nested_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [{status_string: "ok", status_code: 200}])
          expect(service.collection({success: :success}).collect_concat { |key, value| step nested_service, in: [status: -> { value }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [{status_string: "ok", status_code: 200}])
          expect(service.collection((:success..:success)).collect_concat { |status| step nested_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [{status_string: "ok", status_code: 200}])

          # NOTE: Error result.
          expect(service.collection(enumerable([:success, :error, :exception])).collect_concat { |status| step nested_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection(enumerator([:success, :error, :exception])).collect_concat { |status| step nested_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection(lazy_enumerator([:success, :error, :exception])).collect_concat { |status| step nested_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection(chain_enumerator([:success, :error, :exception])).collect_concat { |status| step nested_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection([:success, :error, :exception]).collect_concat { |status| step nested_service, in: [status: -> { status }] }.result).to be_error.without_data

          expect(service.collection(set([:success, :error, :exception])).collect_concat { |status| step nested_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection({success: :success, error: :error, exception: :exception}).collect_concat { |key, value| step nested_service, in: [status: -> { value }] }.result).to be_error.without_data
          expect(service.collection((:error..:error)).collect_concat { |status| step nested_service, in: [status: -> { status }] }.result).to be_error.without_data

          # NOTE: Error propagation.
          expect(service.collection(enumerable([:success, :error, :exception])).select { |status| step nested_service, in: [status: -> { status }] }.collect_concat { |status| condition[status] }.result).to be_error.without_data
          expect(service.collection(enumerator([:success, :error, :exception])).select { |status| step nested_service, in: [status: -> { status }] }.collect_concat { |status| condition[status] }.result).to be_error.without_data
          expect(service.collection(lazy_enumerator([:success, :error, :exception])).select { |status| step nested_service, in: [status: -> { status }] }.collect_concat { |status| condition[status] }.result).to be_error.without_data
          expect(service.collection(chain_enumerator([:success, :error, :exception])).select { |status| step nested_service, in: [status: -> { status }] }.collect_concat { |status| condition[status] }.result).to be_error.without_data
          expect(service.collection([:success, :error, :exception]).select { |status| step nested_service, in: [status: -> { status }] }.collect_concat { |status| condition[status] }.result).to be_error.without_data

          expect(service.collection(set([:success, :error, :exception])).select { |status| step nested_service, in: [status: -> { status }] }.collect_concat { |status| condition[status] }.result).to be_error.without_data
          expect(service.collection({success: :success, error: :error, exception: :exception}).select { |key, value| step nested_service, in: [status: -> { value }] }.collect_concat { |key, value| condition[value] }.result).to be_error.without_data
          expect(service.collection((:error..:error)).select { |status| step nested_service, in: [status: -> { status }] }.collect_concat { |status| condition[status] }.result).to be_error.without_data

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

      # rubocop:disable Performance/Size
      xdescribe "#count" do
        specify do
          # empty
          expect([].count).to eq(0)
          expect(service.collection([]).count.result).to be_success.with_data(value: 0)

          # no block
          expect([:success, :success, :success].count).to eq(3)
          expect(service.collection([:success, :success, :success]).count.result).to be_success.with_data(value: 3)

          # item
          expect([:failure, :success, :success].count(:success)).to eq(2)
          expect(service.collection([:failure, :success, :success]).count(:success).result).to be_success.with_data(value: 2)

          # condition block
          expect([:success, :success, :success].count(&conditional_block)).to eq(3)
          expect(service.collection([:success, :success, :success]).count(&conditional_block).result).to be_success.with_data(value: 3)
          expect(service.collection([:success, :success, :success]).count(&step_without_outputs_block).result).to be_success.with_data(value: 3)

          # error result
          expect(service.collection([:success, :error, :exception]).count(&step_without_outputs_block).result).to be_error.without_data

          # error propagation
          expect(service.collection([:success, :error, :exception]).each(&step_without_outputs_block).count(&exception_block).result).to be_error.without_data

          # already used boolean value terminal chaining
          expect { service.collection([:success]).all?.count(&exception_block) }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)

          # already used singular value terminal chaining
          expect { service.collection([:success]).first.count(&exception_block) }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
        end
      end
      # rubocop:enable Performance/Size

      xdescribe "#cycle" do
        specify do
          # empty
          expect([].cycle(2).to_a).to eq([])
          expect(service.collection([]).cycle(2).result).to be_success.with_data(values: instance_of(Enumerator)).comparing_by(:===)
          expect(service.collection([]).cycle(2).result.unsafe_data[:values].to_a).to eq([])

          # n
          expect([:success, :success].cycle(2).to_a).to eq([:success, :success, :success, :success])
          expect(service.collection([:success, :success]).cycle(2).result).to be_success.with_data(values: instance_of(Enumerator)).comparing_by(:===)
          expect(service.collection([:success, :success]).cycle(2).result.unsafe_data[:values].to_a).to eq([:success, :success, :success, :success])

          # condition block
          expect([:success, :success].cycle(2, &conditional_block)).to eq(nil)
          expect(service.collection([:success, :success]).cycle(2, &conditional_block).result).to be_success.with_data(value: nil)
          expect(service.collection([:success, :success]).cycle(2, &step_without_outputs_block).result).to be_success.with_data(value: nil)

          # error result
          expect(service.collection([:success, :error, :exception]).cycle(2, &step_without_outputs_block).result).to be_error.without_data

          # error propagation
          expect(service.collection([:success, :error, :exception]).each(&step_without_outputs_block).cycle(2, &exception_block).result).to be_error.without_data

          # already used boolean value terminal chaining
          expect { service.collection([:success]).all?.cycle(2, &exception_block) }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)

          # already used singular value terminal chaining
          expect { service.collection([:success]).first.cycle(2, &exception_block) }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
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
          expect(service.collection(enumerable([:failure, :success, :exception])).detect { |status| step nested_service, in: [status: -> { status }] }.result).to be_success.with_data(value: :success)
          expect(service.collection(enumerator([:failure, :success, :exception])).detect { |status| step nested_service, in: [status: -> { status }] }.result).to be_success.with_data(value: :success)
          expect(service.collection(lazy_enumerator([:failure, :success, :exception])).detect { |status| step nested_service, in: [status: -> { status }] }.result).to be_success.with_data(value: :success)
          expect(service.collection(chain_enumerator([:failure, :success, :exception])).detect { |status| step nested_service, in: [status: -> { status }] }.result).to be_success.with_data(value: :success)
          expect(service.collection([:failure, :success, :exception]).detect { |status| step nested_service, in: [status: -> { status }] }.result).to be_success.with_data(value: :success)
          expect(service.collection(set([:failure, :success, :exception])).detect { |status| step nested_service, in: [status: -> { status }] }.result).to be_success.with_data(value: :success)

          expect(service.collection({success: :success}).detect { |key, value| step nested_service, in: [status: -> { value }] }.result).to be_success.with_data(value: [:success, :success])
          expect(service.collection((:success..:success)).detect { |status| step nested_service, in: [status: -> { status }] }.result).to be_success.with_data(value: :success)

          # NOTE: Not matched step with no outputs.
          expect(service.collection(enumerable([:failure, :failure, :failure])).detect { |status| step nested_service, in: [status: -> { status }] }.result).to be_failure.without_data
          expect(service.collection(enumerator([:failure, :failure, :failure])).detect { |status| step nested_service, in: [status: -> { status }] }.result).to be_failure.without_data
          expect(service.collection(lazy_enumerator([:failure, :failure, :failure])).detect { |status| step nested_service, in: [status: -> { status }] }.result).to be_failure.without_data
          expect(service.collection(chain_enumerator([:failure, :failure, :failure])).detect { |status| step nested_service, in: [status: -> { status }] }.result).to be_failure.without_data
          expect(service.collection([:failure, :failure, :failure]).detect { |status| step nested_service, in: [status: -> { status }] }.result).to be_failure.without_data
          expect(service.collection(set([:failure, :failure, :failure])).detect { |status| step nested_service, in: [status: -> { status }] }.result).to be_failure.without_data

          expect(service.collection({failure: :failure}).detect { |key, value| step nested_service, in: [status: -> { value }] }.result).to be_failure.without_data
          expect(service.collection((:failure..:failure)).detect { |status| step nested_service, in: [status: -> { status }] }.result).to be_failure.without_data

          # NOTE: Not matched step with no outputs with ifnode.
          expect(service.collection(enumerable([:failure, :failure, :failure])).detect(-> { :default }) { |status| step nested_service, in: [status: -> { status }] }.result).to be_success.with_data(value: :default)
          expect(service.collection(enumerator([:failure, :failure, :failure])).detect(-> { :default }) { |status| step nested_service, in: [status: -> { status }] }.result).to be_success.with_data(value: :default)
          expect(service.collection(lazy_enumerator([:failure, :failure, :failure])).detect(-> { :default }) { |status| step nested_service, in: [status: -> { status }] }.result).to be_success.with_data(value: :default)
          expect(service.collection(chain_enumerator([:failure, :failure, :failure])).detect(-> { :default }) { |status| step nested_service, in: [status: -> { status }] }.result).to be_success.with_data(value: :default)
          expect(service.collection([:failure, :failure, :failure]).detect(-> { :default }) { |status| step nested_service, in: [status: -> { status }] }.result).to be_success.with_data(value: :default)
          expect(service.collection(set([:failure, :failure, :failure])).detect(-> { :default }) { |status| step nested_service, in: [status: -> { status }] }.result).to be_success.with_data(value: :default)

          expect(service.collection({failure: :failure}).detect(-> { :default }) { |key, value| step nested_service, in: [status: -> { value }] }.result).to be_success.with_data(value: :default)
          expect(service.collection((:failure..:failure)).detect(-> { :default }) { |status| step nested_service, in: [status: -> { status }] }.result).to be_success.with_data(value: :default)

          # NOTE: Matched step with one output.
          expect(service.collection(enumerable([:failure, :success, :exception])).detect { |status| step nested_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(value: :success)
          expect(service.collection(enumerator([:failure, :success, :exception])).detect { |status| step nested_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(value: :success)
          expect(service.collection(lazy_enumerator([:failure, :success, :exception])).detect { |status| step nested_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(value: :success)
          expect(service.collection(chain_enumerator([:failure, :success, :exception])).detect { |status| step nested_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(value: :success)
          expect(service.collection([:failure, :success, :exception]).detect { |status| step nested_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(value: :success)
          expect(service.collection(set([:failure, :success, :exception])).detect { |status| step nested_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(value: :success)

          expect(service.collection({success: :success}).detect { |key, value| step nested_service, in: [status: -> { value }], out: :status_string }.result).to be_success.with_data(value: [:success, :success])
          expect(service.collection((:success..:success)).detect { |status| step nested_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(value: :success)

          # NOTE: Not matched step with one output.
          expect(service.collection(enumerable([:failure, :failure, :failure])).detect { |status| step nested_service, in: [status: -> { status }], out: :status_string }.result).to be_failure.without_data
          expect(service.collection(enumerator([:failure, :failure, :failure])).detect { |status| step nested_service, in: [status: -> { status }], out: :status_string }.result).to be_failure.without_data
          expect(service.collection(lazy_enumerator([:failure, :failure, :failure])).detect { |status| step nested_service, in: [status: -> { status }], out: :status_string }.result).to be_failure.without_data
          expect(service.collection(chain_enumerator([:failure, :failure, :failure])).detect { |status| step nested_service, in: [status: -> { status }], out: :status_string }.result).to be_failure.without_data
          expect(service.collection([:failure, :failure, :failure]).detect { |status| step nested_service, in: [status: -> { status }], out: :status_string }.result).to be_failure.without_data
          expect(service.collection(set([:failure, :failure, :failure])).detect { |status| step nested_service, in: [status: -> { status }], out: :status_string }.result).to be_failure.without_data

          expect(service.collection({failure: :failure}).detect { |key, value| step nested_service, in: [status: -> { value }], out: :status_string }.result).to be_failure.without_data
          expect(service.collection((:failure..:failure)).detect { |status| step nested_service, in: [status: -> { status }], out: :status_string }.result).to be_failure.without_data

          # NOTE: Not matched step with one output with ifnode.
          expect(service.collection(enumerable([:failure, :failure, :failure])).detect(-> { :default }) { |status| step nested_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(value: :default)
          expect(service.collection(enumerator([:failure, :failure, :failure])).detect(-> { :default }) { |status| step nested_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(value: :default)
          expect(service.collection(lazy_enumerator([:failure, :failure, :failure])).detect(-> { :default }) { |status| step nested_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(value: :default)
          expect(service.collection(chain_enumerator([:failure, :failure, :failure])).detect(-> { :default }) { |status| step nested_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(value: :default)
          expect(service.collection([:failure, :failure, :failure]).detect(-> { :default }) { |status| step nested_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(value: :default)
          expect(service.collection(set([:failure, :failure, :failure])).detect(-> { :default }) { |status| step nested_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(value: :default)

          expect(service.collection({failure: :failure}).detect(-> { :default }) { |key, value| step nested_service, in: [status: -> { value }], out: :status_string }.result).to be_success.with_data(value: :default)
          expect(service.collection((:failure..:failure)).detect(-> { :default }) { |status| step nested_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(value: :default)

          # NOTE: Matched step with multiple outputs.
          expect(service.collection(enumerable([:failure, :success, :exception])).detect { |status| step nested_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(value: :success)
          expect(service.collection(enumerator([:failure, :success, :exception])).detect { |status| step nested_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(value: :success)
          expect(service.collection(lazy_enumerator([:failure, :success, :exception])).detect { |status| step nested_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(value: :success)
          expect(service.collection(chain_enumerator([:failure, :success, :exception])).detect { |status| step nested_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(value: :success)
          expect(service.collection([:failure, :success, :exception]).detect { |status| step nested_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(value: :success)
          expect(service.collection(set([:failure, :success, :exception])).detect { |status| step nested_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(value: :success)

          expect(service.collection({success: :success}).detect { |key, value| step nested_service, in: [status: -> { value }], out: [:status_string, :status_code] }.result).to be_success.with_data(value: [:success, :success])
          expect(service.collection((:success..:success)).detect { |status| step nested_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(value: :success)

          # NOTE: Not matched step with multiple outputs.
          expect(service.collection(enumerable([:failure, :failure, :failure])).detect { |status| step nested_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_failure.without_data
          expect(service.collection(enumerator([:failure, :failure, :failure])).detect { |status| step nested_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_failure.without_data
          expect(service.collection(lazy_enumerator([:failure, :failure, :failure])).detect { |status| step nested_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_failure.without_data
          expect(service.collection(chain_enumerator([:failure, :failure, :failure])).detect { |status| step nested_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_failure.without_data
          expect(service.collection([:failure, :failure, :failure]).detect { |status| step nested_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_failure.without_data
          expect(service.collection(set([:failure, :failure, :failure])).detect { |status| step nested_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_failure.without_data

          expect(service.collection({failure: :failure}).detect { |key, value| step nested_service, in: [status: -> { value }], out: [:status_string, :status_code] }.result).to be_failure.without_data
          expect(service.collection((:failure..:failure)).detect { |status| step nested_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_failure.without_data

          # NOTE: Not matched step with multiple outputs with ifnode.
          expect(service.collection(enumerable([:failure, :failure, :failure])).detect(-> { :default }) { |status| step nested_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(value: :default)
          expect(service.collection(enumerator([:failure, :failure, :failure])).detect(-> { :default }) { |status| step nested_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(value: :default)
          expect(service.collection(lazy_enumerator([:failure, :failure, :failure])).detect(-> { :default }) { |status| step nested_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(value: :default)
          expect(service.collection(chain_enumerator([:failure, :failure, :failure])).detect(-> { :default }) { |status| step nested_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(value: :default)
          expect(service.collection([:failure, :failure, :failure]).detect(-> { :default }) { |status| step nested_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(value: :default)
          expect(service.collection(set([:failure, :failure, :failure])).detect(-> { :default }) { |status| step nested_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(value: :default)

          expect(service.collection({failure: :failure}).detect(-> { :default }) { |key, value| step nested_service, in: [status: -> { value }], out: [:status_string, :status_code] }.result).to be_success.with_data(value: :default)
          expect(service.collection((:failure..:failure)).detect(-> { :default }) { |status| step nested_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(value: :default)

          # NOTE: Error result.
          expect(service.collection(enumerable([:failure, :error, :exception])).detect { |status| step nested_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection(enumerator([:failure, :error, :exception])).detect { |status| step nested_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection(lazy_enumerator([:failure, :error, :exception])).detect { |status| step nested_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection(chain_enumerator([:failure, :error, :exception])).detect { |status| step nested_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection([:failure, :error, :exception]).detect { |status| step nested_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection(set([:failure, :error, :exception])).detect { |status| step nested_service, in: [status: -> { status }] }.result).to be_error.without_data

          expect(service.collection({failure: :failure, error: :error, exception: :exception}).detect { |key, value| step nested_service, in: [status: -> { value }] }.result).to be_error.without_data
          expect(service.collection((:error..:error)).detect { |status| step nested_service, in: [status: -> { status }] }.result).to be_error.without_data

          # NOTE: Error propagation.
          expect(service.collection(enumerable([:failure, :error, :exception])).select { |status| step nested_service, in: [status: -> { status }] }.detect { |status| step nested_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection(enumerator([:failure, :error, :exception])).select { |status| step nested_service, in: [status: -> { status }] }.detect { |status| step nested_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection(lazy_enumerator([:failure, :error, :exception])).select { |status| step nested_service, in: [status: -> { status }] }.detect { |status| step nested_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection(chain_enumerator([:failure, :error, :exception])).select { |status| step nested_service, in: [status: -> { status }] }.detect { |status| step nested_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection([:failure, :error, :exception]).select { |status| step nested_service, in: [status: -> { status }] }.detect { |status| step nested_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection(set([:failure, :error, :exception])).select { |status| step nested_service, in: [status: -> { status }] }.detect { |status| step nested_service, in: [status: -> { status }] }.result).to be_error.without_data

          expect(service.collection({failure: :failure, error: :error, exception: :exception}).select { |key, value| step nested_service, in: [status: -> { value }] }.detect { |key, value| step nested_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection((:error..:error)).select { |status| step nested_service, in: [status: -> { status }] }.detect { |status| step nested_service, in: [status: -> { status }] }.result).to be_error.without_data

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

      xdescribe "#drop" do
        specify do
          # 0
          expect([].drop(0).to_a).to eq([])
          expect(service.collection([]).drop(0).result).to be_success.with_data(values: [])

          # dropping
          expect([:success, :success, :success, :success].drop(2)).to eq([:success, :success])
          expect(service.collection([:success, :success, :success, :success]).drop(2).result).to be_success.with_data(values: [:success, :success])

          # already used boolean value terminal chaining
          expect { service.collection([:success]).all?.drop(2) }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)

          # already used singular value terminal chaining
          expect { service.collection([:success]).first.drop(2) }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
        end
      end

      xdescribe "#drop_while" do
        let(:nested_service) do
          Class.new do
            include ConvenientService::Standard::Config

            attr_reader :status

            def initialize(status:)
              @status = status
            end

            def result
              case status
              when :success then success
              when :failure then failure
              when :error then error
              when :exception then raise
              else
                raise
              end
            end
          end
        end

        let(:conditional_block) do
          proc do |status|
            case status
            when :success then true
            when :failure then false
            when :exception then raise
            else
              raise
            end
          end
        end

        specify do
          # empty
          expect([].drop_while(&conditional_block)).to eq([])
          expect(service.collection([]).drop_while(&conditional_block).result).to be_success.with_data(values: [])
          expect(service.collection([]).drop_while(&step_without_outputs_block).result).to be_success.with_data(values: [])

          # no block
          expect([:failure, :success].drop_while.to_a).to eq([:failure])
          expect(service.collection([:failure, :success]).drop_while.result).to be_success.with_data(values: instance_of(Enumerator)).comparing_by(:===)
          expect(service.collection([:failure, :success]).drop_while.result.unsafe_data[:values].to_a).to eq([:failure])

          # dropping
          expect([:success, :failure, :exception].drop_while(&conditional_block)).to eq([:failure, :exception])
          expect(service.collection([:success, :failure, :exception]).drop_while(&conditional_block).result).to be_success.with_data(values: [:failure, :exception])
          expect(service.collection([:success, :failure, :exception]).drop_while(&step_without_outputs_block).result).to be_success.with_data(values: [:failure, :exception])

          # error result
          expect(service.collection([:success, :error, :exception]).drop_while(&step_without_outputs_block).result).to be_error.without_data

          # error propagation
          expect(service.collection([:success, :error, :exception]).each(&step_without_outputs_block).drop_while(&exception_block).result).to be_error.without_data

          # already used boolean value terminal chaining
          expect { service.collection([:success]).all?.drop_while(&exception_block) }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)

          # already used singular value terminal chaining
          expect { service.collection([:success]).first.drop_while(&exception_block) }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
        end
      end

      xdescribe "#each_cons" do
        let(:nested_service) do
          Class.new do
            include ConvenientService::Standard::Config

            attr_reader :previous_status, :current_status

            def initialize(previous_status:, current_status:)
              @previous_status = previous_status
              @current_status = current_status
            end

            def result
              if [previous_status, current_status].uniq == [:success] then success(status_string: "ok", status_code: 200)
              elsif [previous_status, current_status].include?(:error) then error
              elsif [previous_status, current_status].include?(:failure) then failure
              elsif [previous_status, current_status].include?(:exception) then raise
              else
                raise
              end
            end
          end
        end

        let(:conditional_block) do
          proc do |previous_status, current_status|
            if [previous_status, current_status].uniq == [:success] then true
            elsif [previous_status, current_status].include?(:error) then raise
            elsif [previous_status, current_status].include?(:failure) then false
            elsif [previous_status, current_status].include?(:exception) then raise
            else
              raise
            end
          end
        end

        let(:step_without_outputs_block) do
          proc do |previous_status, current_status|
            service.step nested_service,
              in: [
                previous_status: -> { previous_status },
                current_status: -> { current_status }
              ]
          end
        end

        specify do
          # empty
          expect([].each_cons(2).to_a).to eq([])
          expect(service.collection([]).each_cons(2).result).to be_success.with_data(values: instance_of(Enumerator)).comparing_by(:===)
          expect(service.collection([]).each_cons(2).result.unsafe_data[:values].to_a).to eq([])

          # no block
          expect([:success, :success, :success].each_cons(2).to_a).to eq([[:success, :success], [:success, :success]])
          expect(service.collection([:success, :success, :success]).each_cons(2).result).to be_success.with_data(values: instance_of(Enumerator)).comparing_by(:===)
          expect(service.collection([:success, :success, :success]).each_cons(2).result.unsafe_data[:values].to_a).to eq([[:success, :success], [:success, :success]])

          # condition block

          expect([:success, :success, :success].each_cons(2, &conditional_block)).to eq([:success, :success, :success])
          expect(service.collection([:success, :success, :success]).each_cons(2, &conditional_block).result).to be_success.with_data(values: [:success, :success, :success])
          expect(service.collection([:success, :success, :success]).each_cons(2, &step_without_outputs_block).result).to be_success.with_data(values: [:success, :success, :success])

          # error result
          expect(service.collection([:success, :error, :exception]).each_cons(2, &step_without_outputs_block).result).to be_error.without_data

          # error propagation
          expect(service.collection([:success, :error, :exception]).each { |status| step_without_outputs_block.call(status, :error) }.each_cons(2, &exception_block).result).to be_error.without_data

          # already used boolean value terminal chaining
          expect { service.collection([:success]).all?.each_cons(2, &exception_block) }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)

          # already used singular value terminal chaining
          expect { service.collection([:success]).first.each_cons(2, &exception_block) }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
        end
      end

      xdescribe "#each_entry" do
        specify do
          # empty
          expect([].each_entry(&conditional_block).to_a).to eq([])
          expect(service.collection([]).each_entry(&conditional_block).result).to be_success.with_data(values: [])
          expect(service.collection([]).each_entry(&step_without_outputs_block).result).to be_success.with_data(values: [])

          # no block
          expect([:success, :success, :success].each_entry.to_a).to eq([:success, :success, :success])
          expect(service.collection([:success, :success, :success]).each_entry.result).to be_success.with_data(values: instance_of(Enumerator)).comparing_by(:===)
          expect(service.collection([:success, :success, :success]).each_entry.result.unsafe_data[:values].to_a).to eq([:success, :success, :success])

          # block
          expect([:success, :success, :success].each_entry(&conditional_block).to_a).to eq([:success, :success, :success])
          expect(service.collection([:success, :success, :success]).each_entry(&conditional_block).result).to be_success.with_data(values: [:success, :success, :success])
          expect(service.collection([:success, :success, :success]).each_entry(&step_without_outputs_block).result).to be_success.with_data(values: [:success, :success, :success])

          # error result
          expect(service.collection([:success, :error, :exception]).each_entry(&step_without_outputs_block).result).to be_error.without_data

          # error propagation
          expect(service.collection([:success, :error, :exception]).each(&step_without_outputs_block).each_entry(&exception_block).result).to be_error.without_data

          # already used boolean value terminal chaining
          expect { service.collection([:success]).all?.each_entry(&exception_block) }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)

          # already used singular value terminal chaining
          expect { service.collection([:success]).first.each_entry(&exception_block) }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
        end
      end

      xdescribe "#each_slice" do
        let(:nested_service) do
          Class.new do
            include ConvenientService::Standard::Config

            attr_reader :slice

            def initialize(slice:)
              @slice = slice
            end

            def result
              if slice.uniq == [:success] then success(status_string: "ok", status_code: 200)
              elsif slice.include?(:error) then error
              elsif slice.include?(:failure) then failure
              elsif slice.include?(:exception) then raise
              else
                raise
              end
            end
          end
        end

        let(:conditional_block) do
          proc do |slice|
            if slice.uniq == [:success] then true
            elsif slice.include?(:error) then raise
            elsif slice.include?(:failure) then false
            elsif slice.include?(:exception) then raise
            else
              raise
            end
          end
        end

        let(:step_without_outputs_block) do
          proc do |slice|
            service.step nested_service,
              in: [
                slice: -> { slice }
              ]
          end
        end

        specify do
          # empty
          expect([].each_slice(2).to_a).to eq([])
          expect(service.collection([]).each_slice(2).result).to be_success.with_data(values: instance_of(Enumerator)).comparing_by(:===)
          expect(service.collection([]).each_slice(2).result.unsafe_data[:values].to_a).to eq([])

          # no block
          expect([:success, :success, :success].each_slice(2).to_a).to eq([[:success, :success], [:success]])
          expect(service.collection([:success, :success, :success]).each_slice(2).result).to be_success.with_data(values: instance_of(Enumerator)).comparing_by(:===)
          expect(service.collection([:success, :success, :success]).each_slice(2).result.unsafe_data[:values].to_a).to eq([[:success, :success], [:success]])

          # condition block

          expect([:success, :success, :success].each_slice(2, &conditional_block)).to eq([:success, :success, :success])
          expect(service.collection([:success, :success, :success]).each_slice(2, &conditional_block).result).to be_success.with_data(values: [:success, :success, :success])
          expect(service.collection([:success, :success, :success]).each_slice(2, &step_without_outputs_block).result).to be_success.with_data(values: [:success, :success, :success])

          # error result
          expect(service.collection([:success, :error, :exception]).each_slice(2, &step_without_outputs_block).result).to be_error.without_data

          # error propagation
          expect(service.collection([:success, :error, :exception]).each { |status| step_without_outputs_block.call([status, :error]) }.each_slice(2, &exception_block).result).to be_error.without_data

          # already used boolean value terminal chaining
          expect { service.collection([:success]).all?.each_slice(2, &exception_block) }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)

          # already used singular value terminal chaining
          expect { service.collection([:success]).first.each_slice(2, &exception_block) }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
        end
      end

      xdescribe "#each_with_index" do
        let(:nested_service) do
          Class.new do
            include ConvenientService::Standard::Config

            attr_reader :status, :index

            def initialize(status:, index:)
              @status = status
              @index = index
            end

            def result
              if status == :success then success(status_string: "ok", status_code: 200)
              elsif status == :error then error
              elsif status == :failure then failure
              elsif status == :exception then raise
              else
                raise
              end
            end
          end
        end

        let(:conditional_block) do
          proc do |status, index|
            if status == :success then true
            elsif status == :error then raise
            elsif status == :failure then false
            elsif status == :exception then raise
            else
              raise
            end
          end
        end

        let(:step_without_outputs_block) do
          proc do |status, index|
            service.step nested_service,
              in: [
                status: -> { status },
                index: -> { index }
              ]
          end
        end

        specify do
          # empty
          expect([].each_with_index.to_a).to eq([])
          expect(service.collection([]).each_with_index.result).to be_success.with_data(values: instance_of(Enumerator)).comparing_by(:===)
          expect(service.collection([]).each_with_index.result.unsafe_data[:values].to_a).to eq([])

          # no block
          expect([:success, :success, :success].each_with_index.to_a).to eq([[:success, 0], [:success, 1], [:success, 2]])
          expect(service.collection([:success, :success, :success]).each_with_index.result).to be_success.with_data(values: instance_of(Enumerator)).comparing_by(:===)
          expect(service.collection([:success, :success, :success]).each_with_index.result.unsafe_data[:values].to_a).to eq([[:success, 0], [:success, 1], [:success, 2]])

          # condition block
          expect([:success, :success, :success].each_with_index(&conditional_block)).to eq([:success, :success, :success])
          expect(service.collection([:success, :success, :success]).each_with_index(&conditional_block).result).to be_success.with_data(values: [:success, :success, :success])
          expect(service.collection([:success, :success, :success]).each_with_index(&step_without_outputs_block).result).to be_success.with_data(values: [:success, :success, :success])

          # initial index
          # expect([:success, :success, :success].each_with_index(1, &conditional_block)).to eq([:success, :success, :success])
          # expect(service.collection([:success, :success, :success]).each_with_index(1, &conditional_block).result).to be_success.with_data(values: [:success, :success, :success])
          # expect(service.collection([:success, :success, :success]).each_with_index(1, &step_without_outputs_block).result).to be_success.with_data(values: [:success, :success, :success])

          # error result
          expect(service.collection([:success, :error, :exception]).each_with_index(&step_without_outputs_block).result).to be_error.without_data

          # error propagation
          expect(service.collection([:success, :error, :exception]).each { |status| step_without_outputs_block.call(status, :error) }.each_with_index(&exception_block).result).to be_error.without_data

          # already used boolean value terminal chaining
          expect { service.collection([:success]).all?.each_with_index(&exception_block) }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)

          # already used singular value terminal chaining
          expect { service.collection([:success]).first.each_with_index(&exception_block) }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
        end
      end

      xdescribe "#each_with_object" do
        let(:nested_service) do
          Class.new do
            include ConvenientService::Standard::Config

            attr_reader :status, :index

            def initialize(status:, index:)
              @status = status
              @index = index
            end

            def result
              if status == :success then success(status_string: "ok", status_code: 200)
              elsif status == :error then error
              elsif status == :failure then failure
              elsif status == :exception then raise
              else
                raise
              end
            end
          end
        end

        let(:conditional_block) do
          proc do |status, index|
            if status == :success then true
            elsif status == :error then raise
            elsif status == :failure then false
            elsif status == :exception then raise
            else
              raise
            end
          end
        end

        let(:step_without_outputs_block) do
          proc do |status, index|
            service.step nested_service,
              in: [
                status: -> { status },
                index: -> { index }
              ]
          end
        end

        specify do
          # empty
          expect([].each_with_object({}).to_a).to eq([])
          expect(service.collection([]).each_with_object({}).result).to be_success.with_data(values: instance_of(Enumerator)).comparing_by(:===)
          expect(service.collection([]).each_with_object({}).result.unsafe_data[:values].to_a).to eq([])

          # no block
          expect([:success, :success, :success].each_with_object({}).to_a).to eq([[:success, {}], [:success, {}], [:success, {}]])
          expect(service.collection([:success, :success, :success]).each_with_object({}).result).to be_success.with_data(values: instance_of(Enumerator)).comparing_by(:===)
          expect(service.collection([:success, :success, :success]).each_with_object({}).result.unsafe_data[:values].to_a).to eq([[:success, {}], [:success, {}], [:success, {}]])

          # condition block
          expect([:success, :success, :success].each_with_object({}, &conditional_block)).to eq({})
          expect(service.collection([:success, :success, :success]).each_with_object({}, &conditional_block).result).to be_success.with_data(value: {})
          expect(service.collection([:success, :success, :success]).each_with_object({}, &step_without_outputs_block).result).to be_success.with_data(value: {})

          # error result
          expect(service.collection([:success, :error, :exception]).each_with_object({}, &step_without_outputs_block).result).to be_error.without_data

          # error propagation
          expect(service.collection([:success, :error, :exception]).each { |status| step_without_outputs_block.call(status, :error) }.each_with_object({}, &exception_block).result).to be_error.without_data

          # already used boolean value terminal chaining
          expect { service.collection([:success]).all?.each_with_object({}, &exception_block) }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)

          # already used singular value terminal chaining
          expect { service.collection([:success]).first.each_with_object({}, &exception_block) }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
        end
      end

      # ...

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
          expect(service.collection(enumerable([:failure, :success, :exception])).find { |status| step nested_service, in: [status: -> { status }] }.result).to be_success.with_data(value: :success)
          expect(service.collection(enumerator([:failure, :success, :exception])).find { |status| step nested_service, in: [status: -> { status }] }.result).to be_success.with_data(value: :success)
          expect(service.collection(lazy_enumerator([:failure, :success, :exception])).find { |status| step nested_service, in: [status: -> { status }] }.result).to be_success.with_data(value: :success)
          expect(service.collection(chain_enumerator([:failure, :success, :exception])).find { |status| step nested_service, in: [status: -> { status }] }.result).to be_success.with_data(value: :success)
          expect(service.collection([:failure, :success, :exception]).find { |status| step nested_service, in: [status: -> { status }] }.result).to be_success.with_data(value: :success)
          expect(service.collection(set([:failure, :success, :exception])).find { |status| step nested_service, in: [status: -> { status }] }.result).to be_success.with_data(value: :success)

          expect(service.collection({success: :success}).find { |key, value| step nested_service, in: [status: -> { value }] }.result).to be_success.with_data(value: [:success, :success])
          expect(service.collection((:success..:success)).find { |status| step nested_service, in: [status: -> { status }] }.result).to be_success.with_data(value: :success)

          # NOTE: Not matched step with no outputs.
          expect(service.collection(enumerable([:failure, :failure, :failure])).find { |status| step nested_service, in: [status: -> { status }] }.result).to be_failure.without_data
          expect(service.collection(enumerator([:failure, :failure, :failure])).find { |status| step nested_service, in: [status: -> { status }] }.result).to be_failure.without_data
          expect(service.collection(lazy_enumerator([:failure, :failure, :failure])).find { |status| step nested_service, in: [status: -> { status }] }.result).to be_failure.without_data
          expect(service.collection(chain_enumerator([:failure, :failure, :failure])).find { |status| step nested_service, in: [status: -> { status }] }.result).to be_failure.without_data
          expect(service.collection([:failure, :failure, :failure]).find { |status| step nested_service, in: [status: -> { status }] }.result).to be_failure.without_data
          expect(service.collection(set([:failure, :failure, :failure])).find { |status| step nested_service, in: [status: -> { status }] }.result).to be_failure.without_data

          expect(service.collection({failure: :failure}).find { |key, value| step nested_service, in: [status: -> { value }] }.result).to be_failure.without_data
          expect(service.collection((:failure..:failure)).find { |status| step nested_service, in: [status: -> { status }] }.result).to be_failure.without_data

          # NOTE: Not matched step with no outputs with ifnode.
          expect(service.collection(enumerable([:failure, :failure, :failure])).find(-> { :default }) { |status| step nested_service, in: [status: -> { status }] }.result).to be_success.with_data(value: :default)
          expect(service.collection(enumerator([:failure, :failure, :failure])).find(-> { :default }) { |status| step nested_service, in: [status: -> { status }] }.result).to be_success.with_data(value: :default)
          expect(service.collection(lazy_enumerator([:failure, :failure, :failure])).find(-> { :default }) { |status| step nested_service, in: [status: -> { status }] }.result).to be_success.with_data(value: :default)
          expect(service.collection(chain_enumerator([:failure, :failure, :failure])).find(-> { :default }) { |status| step nested_service, in: [status: -> { status }] }.result).to be_success.with_data(value: :default)
          expect(service.collection([:failure, :failure, :failure]).find(-> { :default }) { |status| step nested_service, in: [status: -> { status }] }.result).to be_success.with_data(value: :default)
          expect(service.collection(set([:failure, :failure, :failure])).find(-> { :default }) { |status| step nested_service, in: [status: -> { status }] }.result).to be_success.with_data(value: :default)

          expect(service.collection({failure: :failure}).find(-> { :default }) { |key, value| step nested_service, in: [status: -> { value }] }.result).to be_success.with_data(value: :default)
          expect(service.collection((:failure..:failure)).find(-> { :default }) { |status| step nested_service, in: [status: -> { status }] }.result).to be_success.with_data(value: :default)

          # NOTE: Matched step with one output.
          expect(service.collection(enumerable([:failure, :success, :exception])).find { |status| step nested_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(value: :success)
          expect(service.collection(enumerator([:failure, :success, :exception])).find { |status| step nested_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(value: :success)
          expect(service.collection(lazy_enumerator([:failure, :success, :exception])).find { |status| step nested_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(value: :success)
          expect(service.collection(chain_enumerator([:failure, :success, :exception])).find { |status| step nested_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(value: :success)
          expect(service.collection([:failure, :success, :exception]).find { |status| step nested_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(value: :success)
          expect(service.collection(set([:failure, :success, :exception])).find { |status| step nested_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(value: :success)

          expect(service.collection({success: :success}).find { |key, value| step nested_service, in: [status: -> { value }], out: :status_string }.result).to be_success.with_data(value: [:success, :success])
          expect(service.collection((:success..:success)).find { |status| step nested_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(value: :success)

          # NOTE: Not matched step with one output.
          expect(service.collection(enumerable([:failure, :failure, :failure])).find { |status| step nested_service, in: [status: -> { status }], out: :status_string }.result).to be_failure.without_data
          expect(service.collection(enumerator([:failure, :failure, :failure])).find { |status| step nested_service, in: [status: -> { status }], out: :status_string }.result).to be_failure.without_data
          expect(service.collection(lazy_enumerator([:failure, :failure, :failure])).find { |status| step nested_service, in: [status: -> { status }], out: :status_string }.result).to be_failure.without_data
          expect(service.collection(chain_enumerator([:failure, :failure, :failure])).find { |status| step nested_service, in: [status: -> { status }], out: :status_string }.result).to be_failure.without_data
          expect(service.collection([:failure, :failure, :failure]).find { |status| step nested_service, in: [status: -> { status }], out: :status_string }.result).to be_failure.without_data
          expect(service.collection(set([:failure, :failure, :failure])).find { |status| step nested_service, in: [status: -> { status }], out: :status_string }.result).to be_failure.without_data

          expect(service.collection({failure: :failure}).find { |key, value| step nested_service, in: [status: -> { value }], out: :status_string }.result).to be_failure.without_data
          expect(service.collection((:failure..:failure)).find { |status| step nested_service, in: [status: -> { status }], out: :status_string }.result).to be_failure.without_data

          # NOTE: Not matched step with one output with ifnode.
          expect(service.collection(enumerable([:failure, :failure, :failure])).find(-> { :default }) { |status| step nested_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(value: :default)
          expect(service.collection(enumerator([:failure, :failure, :failure])).find(-> { :default }) { |status| step nested_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(value: :default)
          expect(service.collection(lazy_enumerator([:failure, :failure, :failure])).find(-> { :default }) { |status| step nested_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(value: :default)
          expect(service.collection(chain_enumerator([:failure, :failure, :failure])).find(-> { :default }) { |status| step nested_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(value: :default)
          expect(service.collection([:failure, :failure, :failure]).find(-> { :default }) { |status| step nested_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(value: :default)
          expect(service.collection(set([:failure, :failure, :failure])).find(-> { :default }) { |status| step nested_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(value: :default)

          expect(service.collection({failure: :failure}).find(-> { :default }) { |key, value| step nested_service, in: [status: -> { value }], out: :status_string }.result).to be_success.with_data(value: :default)
          expect(service.collection((:failure..:failure)).find(-> { :default }) { |status| step nested_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(value: :default)

          # NOTE: Matched step with multiple outputs.
          expect(service.collection(enumerable([:failure, :success, :exception])).find { |status| step nested_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(value: :success)
          expect(service.collection(enumerator([:failure, :success, :exception])).find { |status| step nested_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(value: :success)
          expect(service.collection(lazy_enumerator([:failure, :success, :exception])).find { |status| step nested_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(value: :success)
          expect(service.collection(chain_enumerator([:failure, :success, :exception])).find { |status| step nested_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(value: :success)
          expect(service.collection([:failure, :success, :exception]).find { |status| step nested_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(value: :success)
          expect(service.collection(set([:failure, :success, :exception])).find { |status| step nested_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(value: :success)

          expect(service.collection({success: :success}).find { |key, value| step nested_service, in: [status: -> { value }], out: [:status_string, :status_code] }.result).to be_success.with_data(value: [:success, :success])
          expect(service.collection((:success..:success)).find { |status| step nested_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(value: :success)

          # NOTE: Not matched step with multiple outputs.
          expect(service.collection(enumerable([:failure, :failure, :failure])).find { |status| step nested_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_failure.without_data
          expect(service.collection(enumerator([:failure, :failure, :failure])).find { |status| step nested_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_failure.without_data
          expect(service.collection(lazy_enumerator([:failure, :failure, :failure])).find { |status| step nested_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_failure.without_data
          expect(service.collection(chain_enumerator([:failure, :failure, :failure])).find { |status| step nested_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_failure.without_data
          expect(service.collection([:failure, :failure, :failure]).find { |status| step nested_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_failure.without_data
          expect(service.collection(set([:failure, :failure, :failure])).find { |status| step nested_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_failure.without_data

          expect(service.collection({failure: :failure}).find { |key, value| step nested_service, in: [status: -> { value }], out: [:status_string, :status_code] }.result).to be_failure.without_data
          expect(service.collection((:failure..:failure)).find { |status| step nested_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_failure.without_data

          # NOTE: Not matched step with multiple outputs with ifnode.
          expect(service.collection(enumerable([:failure, :failure, :failure])).find(-> { :default }) { |status| step nested_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(value: :default)
          expect(service.collection(enumerator([:failure, :failure, :failure])).find(-> { :default }) { |status| step nested_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(value: :default)
          expect(service.collection(lazy_enumerator([:failure, :failure, :failure])).find(-> { :default }) { |status| step nested_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(value: :default)
          expect(service.collection(chain_enumerator([:failure, :failure, :failure])).find(-> { :default }) { |status| step nested_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(value: :default)
          expect(service.collection([:failure, :failure, :failure]).find(-> { :default }) { |status| step nested_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(value: :default)
          expect(service.collection(set([:failure, :failure, :failure])).find(-> { :default }) { |status| step nested_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(value: :default)

          expect(service.collection({failure: :failure}).find(-> { :default }) { |key, value| step nested_service, in: [status: -> { value }], out: [:status_string, :status_code] }.result).to be_success.with_data(value: :default)
          expect(service.collection((:failure..:failure)).find(-> { :default }) { |status| step nested_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(value: :default)

          # NOTE: Error result.
          expect(service.collection(enumerable([:failure, :error, :exception])).find { |status| step nested_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection(enumerator([:failure, :error, :exception])).find { |status| step nested_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection(lazy_enumerator([:failure, :error, :exception])).find { |status| step nested_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection(chain_enumerator([:failure, :error, :exception])).find { |status| step nested_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection([:failure, :error, :exception]).find { |status| step nested_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection(set([:failure, :error, :exception])).find { |status| step nested_service, in: [status: -> { status }] }.result).to be_error.without_data

          expect(service.collection({failure: :failure, error: :error, exception: :exception}).find { |key, value| step nested_service, in: [status: -> { value }] }.result).to be_error.without_data
          expect(service.collection((:error..:error)).find { |status| step nested_service, in: [status: -> { status }] }.result).to be_error.without_data

          # NOTE: Error propagation.
          expect(service.collection(enumerable([:failure, :error, :exception])).select { |status| step nested_service, in: [status: -> { status }] }.find { |status| step nested_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection(enumerator([:failure, :error, :exception])).select { |status| step nested_service, in: [status: -> { status }] }.find { |status| step nested_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection(lazy_enumerator([:failure, :error, :exception])).select { |status| step nested_service, in: [status: -> { status }] }.find { |status| step nested_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection(chain_enumerator([:failure, :error, :exception])).select { |status| step nested_service, in: [status: -> { status }] }.find { |status| step nested_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection([:failure, :error, :exception]).select { |status| step nested_service, in: [status: -> { status }] }.find { |status| step nested_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection(set([:failure, :error, :exception])).select { |status| step nested_service, in: [status: -> { status }] }.find { |status| step nested_service, in: [status: -> { status }] }.result).to be_error.without_data

          expect(service.collection({failure: :failure, error: :error, exception: :exception}).select { |key, value| step nested_service, in: [status: -> { value }] }.find { |key, value| step nested_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection((:error..:error)).select { |status| step nested_service, in: [status: -> { status }] }.find { |status| step nested_service, in: [status: -> { status }] }.result).to be_error.without_data

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

      xdescribe "#first" do
        specify do
          # empty
          expect([].first).to eq(nil)
          expect(service.collection([]).first.result).to be_failure

          # not empty
          expect([:success, :failure, :failure].first).to eq(:success)
          expect(service.collection([:success, :failure, :failure]).first.result).to be_success.with_data(value: :success)

          # item
          expect([:success, :success, :failure].first(2)).to eq([:success, :success])
          expect(service.collection([:success, :success, :failure]).first(2).result).to be_success.with_data(values: [:success, :success])

          # already used boolean value terminal chaining
          expect { service.collection([:success]).all?.first }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)

          # already used singular value terminal chaining
          expect { service.collection([:success]).first.first }.to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining)
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
          expect(service.collection(enumerable([:success, :failure, :success, :failure])).filter { |status| step nested_service, in: [status: -> { status }] }.result).to be_success.with_data(values: [:success, :success])
          expect(service.collection(enumerator([:success, :failure, :success, :failure])).filter { |status| step nested_service, in: [status: -> { status }] }.result).to be_success.with_data(values: [:success, :success])
          expect(service.collection(lazy_enumerator([:success, :failure, :success, :failure])).filter { |status| step nested_service, in: [status: -> { status }] }.result).to be_success.with_data(values: [:success, :success])
          expect(service.collection(chain_enumerator([:success, :failure, :success, :failure])).filter { |status| step nested_service, in: [status: -> { status }] }.result).to be_success.with_data(values: [:success, :success])
          expect(service.collection([:success, :failure, :success, :failure]).filter { |status| step nested_service, in: [status: -> { status }] }.result).to be_success.with_data(values: [:success, :success])

          expect(service.collection(set([:success, :failure])).filter { |status| step nested_service, in: [status: -> { status }] }.result).to be_success.with_data(values: [:success])
          expect(service.collection({success: :success, failure: :failure}).filter { |key, value| step nested_service, in: [status: -> { value }] }.result).to be_success.with_data(values: {success: :success})
          expect(service.collection((:success..:success)).filter { |status| step nested_service, in: [status: -> { status }] }.result).to be_success.with_data(values: [:success])
          expect(service.collection((:failure..:failure)).filter { |status| step nested_service, in: [status: -> { status }] }.result).to be_success.with_data(values: [])

          # NOTE: Step with one output.
          expect(service.collection(enumerable([:success, :failure, :success, :failure])).filter { |status| step nested_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(values: [:success, :success])
          expect(service.collection(enumerator([:success, :failure, :success, :failure])).filter { |status| step nested_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(values: [:success, :success])
          expect(service.collection(lazy_enumerator([:success, :failure, :success, :failure])).filter { |status| step nested_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(values: [:success, :success])
          expect(service.collection(chain_enumerator([:success, :failure, :success, :failure])).filter { |status| step nested_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(values: [:success, :success])
          expect(service.collection([:success, :failure, :success, :failure]).filter { |status| step nested_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(values: [:success, :success])

          expect(service.collection(set([:success, :failure])).filter { |status| step nested_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(values: [:success])
          expect(service.collection({success: :success, failure: :failure}).filter { |key, value| step nested_service, in: [status: -> { value }], out: :status_string }.result).to be_success.with_data(values: {success: :success})
          expect(service.collection((:success..:success)).filter { |status| step nested_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(values: [:success])
          expect(service.collection((:failure..:failure)).filter { |status| step nested_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(values: [])

          # NOTE: Step with multiple outputs.
          expect(service.collection(enumerable([:success, :failure, :success, :failure])).filter { |status| step nested_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [:success, :success])
          expect(service.collection(enumerator([:success, :failure, :success, :failure])).filter { |status| step nested_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [:success, :success])
          expect(service.collection(lazy_enumerator([:success, :failure, :success, :failure])).filter { |status| step nested_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [:success, :success])
          expect(service.collection(chain_enumerator([:success, :failure, :success, :failure])).filter { |status| step nested_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [:success, :success])
          expect(service.collection([:success, :failure, :success, :failure]).filter { |status| step nested_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [:success, :success])

          expect(service.collection(set([:success, :failure])).filter { |status| step nested_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [:success])
          expect(service.collection({success: :success, failure: :failure}).filter { |key, value| step nested_service, in: [status: -> { value }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: {success: :success})
          expect(service.collection((:success..:success)).filter { |status| step nested_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [:success])
          expect(service.collection((:failure..:failure)).filter { |status| step nested_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [])

          # NOTE: Error result.
          expect(service.collection(enumerable([:success, :error, :exception])).filter { |status| step nested_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection(enumerator([:success, :error, :exception])).filter { |status| step nested_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection(lazy_enumerator([:success, :error, :exception])).filter { |status| step nested_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection(chain_enumerator([:success, :error, :exception])).filter { |status| step nested_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection([:success, :error, :exception]).filter { |status| step nested_service, in: [status: -> { status }] }.result).to be_error.without_data

          expect(service.collection(set([:success, :error, :exception])).filter { |status| step nested_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection({success: :success, error: :error, exception: :exception}).filter { |key, value| step nested_service, in: [status: -> { value }] }.result).to be_error.without_data
          expect(service.collection((:error..:error)).filter { |status| step nested_service, in: [status: -> { status }] }.result).to be_error.without_data

          # NOTE: Error propagation.
          expect(service.collection(enumerable([:success, :error, :exception])).select { |status| step nested_service, in: [status: -> { status }] }.filter { |status| condition[status] }.result).to be_error.without_data
          expect(service.collection(enumerator([:success, :error, :exception])).select { |status| step nested_service, in: [status: -> { status }] }.filter { |status| condition[status] }.result).to be_error.without_data
          expect(service.collection(lazy_enumerator([:success, :error, :exception])).select { |status| step nested_service, in: [status: -> { status }] }.filter { |status| condition[status] }.result).to be_error.without_data
          expect(service.collection(chain_enumerator([:success, :error, :exception])).select { |status| step nested_service, in: [status: -> { status }] }.filter { |status| condition[status] }.result).to be_error.without_data
          expect(service.collection([:success, :error, :exception]).select { |status| step nested_service, in: [status: -> { status }] }.filter { |status| condition[status] }.result).to be_error.without_data

          expect(service.collection(set([:success, :error, :exception])).select { |status| step nested_service, in: [status: -> { status }] }.filter { |status| condition[status] }.result).to be_error.without_data
          expect(service.collection({success: :success, error: :error, exception: :exception}).select { |key, value| step nested_service, in: [status: -> { value }] }.filter { |key, value| condition[value] }.result).to be_error.without_data
          expect(service.collection((:error..:error)).select { |status| step nested_service, in: [status: -> { status }] }.filter { |status| condition[status] }.result).to be_error.without_data

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
          expect(service.collection(enumerable([:success, :success, :success])).flat_map { |status| step nested_service, in: [status: -> { status }] }.result).to be_success.with_data(values: [true, true, true])
          expect(service.collection(enumerator([:success, :success, :success])).flat_map { |status| step nested_service, in: [status: -> { status }] }.result).to be_success.with_data(values: [true, true, true])
          expect(service.collection(lazy_enumerator([:success, :success, :success])).flat_map { |status| step nested_service, in: [status: -> { status }] }.result).to be_success.with_data(values: [true, true, true])
          expect(service.collection(chain_enumerator([:success, :success, :success])).flat_map { |status| step nested_service, in: [status: -> { status }] }.result).to be_success.with_data(values: [true, true, true])
          expect(service.collection([:success, :success, :success]).flat_map { |status| step nested_service, in: [status: -> { status }] }.result).to be_success.with_data(values: [true, true, true])

          expect(service.collection(set([:success])).flat_map { |status| step nested_service, in: [status: -> { status }] }.result).to be_success.with_data(values: [true])
          expect(service.collection({success: :success}).flat_map { |key, value| step nested_service, in: [status: -> { value }] }.result).to be_success.with_data(values: [true])
          expect(service.collection((:success..:success)).flat_map { |status| step nested_service, in: [status: -> { status }] }.result).to be_success.with_data(values: [true])

          # NOTE: Step with one output.
          expect(service.collection(enumerable([:success, :success, :success])).flat_map { |status| step nested_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(values: ["ok", "ok", "ok"])
          expect(service.collection(enumerator([:success, :success, :success])).flat_map { |status| step nested_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(values: ["ok", "ok", "ok"])
          expect(service.collection(lazy_enumerator([:success, :success, :success])).flat_map { |status| step nested_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(values: ["ok", "ok", "ok"])
          expect(service.collection(chain_enumerator([:success, :success, :success])).flat_map { |status| step nested_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(values: ["ok", "ok", "ok"])
          expect(service.collection([:success, :success, :success]).flat_map { |status| step nested_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(values: ["ok", "ok", "ok"])

          expect(service.collection(set([:success])).flat_map { |status| step nested_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(values: ["ok"])
          expect(service.collection({success: :success}).flat_map { |key, value| step nested_service, in: [status: -> { value }], out: :status_string }.result).to be_success.with_data(values: ["ok"])
          expect(service.collection((:success..:success)).flat_map { |status| step nested_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(values: ["ok"])

          # NOTE: Step with multiple outputs.
          expect(service.collection(enumerable([:success, :success, :success])).flat_map { |status| step nested_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [{status_string: "ok", status_code: 200}, {status_string: "ok", status_code: 200}, {status_string: "ok", status_code: 200}])
          expect(service.collection(enumerator([:success, :success, :success])).flat_map { |status| step nested_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [{status_string: "ok", status_code: 200}, {status_string: "ok", status_code: 200}, {status_string: "ok", status_code: 200}])
          expect(service.collection(lazy_enumerator([:success, :success, :success])).flat_map { |status| step nested_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [{status_string: "ok", status_code: 200}, {status_string: "ok", status_code: 200}, {status_string: "ok", status_code: 200}])
          expect(service.collection(chain_enumerator([:success, :success, :success])).flat_map { |status| step nested_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [{status_string: "ok", status_code: 200}, {status_string: "ok", status_code: 200}, {status_string: "ok", status_code: 200}])
          expect(service.collection([:success, :success, :success]).flat_map { |status| step nested_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [{status_string: "ok", status_code: 200}, {status_string: "ok", status_code: 200}, {status_string: "ok", status_code: 200}])

          expect(service.collection(set([:success])).flat_map { |status| step nested_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [{status_string: "ok", status_code: 200}])
          expect(service.collection({success: :success}).flat_map { |key, value| step nested_service, in: [status: -> { value }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [{status_string: "ok", status_code: 200}])
          expect(service.collection((:success..:success)).flat_map { |status| step nested_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [{status_string: "ok", status_code: 200}])

          # NOTE: Error result.
          expect(service.collection(enumerable([:success, :error, :exception])).flat_map { |status| step nested_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection(enumerator([:success, :error, :exception])).flat_map { |status| step nested_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection(lazy_enumerator([:success, :error, :exception])).flat_map { |status| step nested_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection(chain_enumerator([:success, :error, :exception])).flat_map { |status| step nested_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection([:success, :error, :exception]).flat_map { |status| step nested_service, in: [status: -> { status }] }.result).to be_error.without_data

          expect(service.collection(set([:success, :error, :exception])).flat_map { |status| step nested_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection({success: :success, error: :error, exception: :exception}).flat_map { |key, value| step nested_service, in: [status: -> { value }] }.result).to be_error.without_data
          expect(service.collection((:error..:error)).flat_map { |status| step nested_service, in: [status: -> { status }] }.result).to be_error.without_data

          # NOTE: Error propagation.
          expect(service.collection(enumerable([:success, :error, :exception])).select { |status| step nested_service, in: [status: -> { status }] }.flat_map { |status| condition[status] }.result).to be_error.without_data
          expect(service.collection(enumerator([:success, :error, :exception])).select { |status| step nested_service, in: [status: -> { status }] }.flat_map { |status| condition[status] }.result).to be_error.without_data
          expect(service.collection(lazy_enumerator([:success, :error, :exception])).select { |status| step nested_service, in: [status: -> { status }] }.flat_map { |status| condition[status] }.result).to be_error.without_data
          expect(service.collection(chain_enumerator([:success, :error, :exception])).select { |status| step nested_service, in: [status: -> { status }] }.flat_map { |status| condition[status] }.result).to be_error.without_data
          expect(service.collection([:success, :error, :exception]).select { |status| step nested_service, in: [status: -> { status }] }.flat_map { |status| condition[status] }.result).to be_error.without_data

          expect(service.collection(set([:success, :error, :exception])).select { |status| step nested_service, in: [status: -> { status }] }.flat_map { |status| condition[status] }.result).to be_error.without_data
          expect(service.collection({success: :success, error: :error, exception: :exception}).select { |key, value| step nested_service, in: [status: -> { value }] }.flat_map { |key, value| condition[value] }.result).to be_error.without_data
          expect(service.collection((:error..:error)).select { |status| step nested_service, in: [status: -> { status }] }.flat_map { |status| condition[status] }.result).to be_error.without_data

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
          expect(service.collection(enumerable([:success, :success, :success])).map { |status| step nested_service, in: [status: -> { status }] }.result).to be_success.with_data(values: [true, true, true])
          expect(service.collection(enumerator([:success, :success, :success])).map { |status| step nested_service, in: [status: -> { status }] }.result).to be_success.with_data(values: [true, true, true])
          expect(service.collection(lazy_enumerator([:success, :success, :success])).map { |status| step nested_service, in: [status: -> { status }] }.result).to be_success.with_data(values: [true, true, true])
          expect(service.collection(chain_enumerator([:success, :success, :success])).map { |status| step nested_service, in: [status: -> { status }] }.result).to be_success.with_data(values: [true, true, true])
          expect(service.collection([:success, :success, :success]).map { |status| step nested_service, in: [status: -> { status }] }.result).to be_success.with_data(values: [true, true, true])

          expect(service.collection(set([:success])).map { |status| step nested_service, in: [status: -> { status }] }.result).to be_success.with_data(values: [true])
          expect(service.collection({success: :success}).map { |key, value| step nested_service, in: [status: -> { value }] }.result).to be_success.with_data(values: [true])
          expect(service.collection((:success..:success)).map { |status| step nested_service, in: [status: -> { status }] }.result).to be_success.with_data(values: [true])

          # NOTE: Step with one output.
          expect(service.collection(enumerable([:success, :success, :success])).map { |status| step nested_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(values: ["ok", "ok", "ok"])
          expect(service.collection(enumerator([:success, :success, :success])).map { |status| step nested_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(values: ["ok", "ok", "ok"])
          expect(service.collection(lazy_enumerator([:success, :success, :success])).map { |status| step nested_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(values: ["ok", "ok", "ok"])
          expect(service.collection(chain_enumerator([:success, :success, :success])).map { |status| step nested_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(values: ["ok", "ok", "ok"])
          expect(service.collection([:success, :success, :success]).map { |status| step nested_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(values: ["ok", "ok", "ok"])

          expect(service.collection(set([:success])).map { |status| step nested_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(values: ["ok"])
          expect(service.collection({success: :success}).map { |key, value| step nested_service, in: [status: -> { value }], out: :status_string }.result).to be_success.with_data(values: ["ok"])
          expect(service.collection((:success..:success)).map { |status| step nested_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(values: ["ok"])

          # NOTE: Step with multiple outputs.
          expect(service.collection(enumerable([:success, :success, :success])).map { |status| step nested_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [{status_string: "ok", status_code: 200}, {status_string: "ok", status_code: 200}, {status_string: "ok", status_code: 200}])
          expect(service.collection(enumerator([:success, :success, :success])).map { |status| step nested_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [{status_string: "ok", status_code: 200}, {status_string: "ok", status_code: 200}, {status_string: "ok", status_code: 200}])
          expect(service.collection(lazy_enumerator([:success, :success, :success])).map { |status| step nested_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [{status_string: "ok", status_code: 200}, {status_string: "ok", status_code: 200}, {status_string: "ok", status_code: 200}])
          expect(service.collection(chain_enumerator([:success, :success, :success])).map { |status| step nested_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [{status_string: "ok", status_code: 200}, {status_string: "ok", status_code: 200}, {status_string: "ok", status_code: 200}])
          expect(service.collection([:success, :success, :success]).map { |status| step nested_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [{status_string: "ok", status_code: 200}, {status_string: "ok", status_code: 200}, {status_string: "ok", status_code: 200}])

          expect(service.collection(set([:success])).map { |status| step nested_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [{status_string: "ok", status_code: 200}])
          expect(service.collection({success: :success}).map { |key, value| step nested_service, in: [status: -> { value }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [{status_string: "ok", status_code: 200}])
          expect(service.collection((:success..:success)).map { |status| step nested_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [{status_string: "ok", status_code: 200}])

          # NOTE: Error result.
          expect(service.collection(enumerable([:success, :error, :exception])).map { |status| step nested_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection(enumerator([:success, :error, :exception])).map { |status| step nested_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection(lazy_enumerator([:success, :error, :exception])).map { |status| step nested_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection(chain_enumerator([:success, :error, :exception])).map { |status| step nested_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection([:success, :error, :exception]).map { |status| step nested_service, in: [status: -> { status }] }.result).to be_error.without_data

          expect(service.collection(set([:success, :error, :exception])).map { |status| step nested_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection({success: :success, error: :error, exception: :exception}).map { |key, value| step nested_service, in: [status: -> { value }] }.result).to be_error.without_data
          expect(service.collection((:error..:error)).map { |status| step nested_service, in: [status: -> { status }] }.result).to be_error.without_data

          # NOTE: Error propagation.
          expect(service.collection(enumerable([:success, :error, :exception])).select { |status| step nested_service, in: [status: -> { status }] }.map { |status| condition[status] }.result).to be_error.without_data
          expect(service.collection(enumerator([:success, :error, :exception])).select { |status| step nested_service, in: [status: -> { status }] }.map { |status| condition[status] }.result).to be_error.without_data
          expect(service.collection(lazy_enumerator([:success, :error, :exception])).select { |status| step nested_service, in: [status: -> { status }] }.map { |status| condition[status] }.result).to be_error.without_data
          expect(service.collection(chain_enumerator([:success, :error, :exception])).select { |status| step nested_service, in: [status: -> { status }] }.map { |status| condition[status] }.result).to be_error.without_data
          expect(service.collection([:success, :error, :exception]).select { |status| step nested_service, in: [status: -> { status }] }.map { |status| condition[status] }.result).to be_error.without_data

          expect(service.collection(set([:success, :error, :exception])).select { |status| step nested_service, in: [status: -> { status }] }.map { |status| condition[status] }.result).to be_error.without_data
          expect(service.collection({success: :success, error: :error, exception: :exception}).select { |key, value| step nested_service, in: [status: -> { value }] }.map { |key, value| condition[value] }.result).to be_error.without_data
          expect(service.collection((:error..:error)).select { |status| step nested_service, in: [status: -> { status }] }.map { |status| condition[status] }.result).to be_error.without_data

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
          expect(service.collection(enumerable([:success, :failure, :success, :failure])).select { |status| step nested_service, in: [status: -> { status }] }.result).to be_success.with_data(values: [:success, :success])
          expect(service.collection(enumerator([:success, :failure, :success, :failure])).select { |status| step nested_service, in: [status: -> { status }] }.result).to be_success.with_data(values: [:success, :success])
          expect(service.collection(lazy_enumerator([:success, :failure, :success, :failure])).select { |status| step nested_service, in: [status: -> { status }] }.result).to be_success.with_data(values: [:success, :success])
          expect(service.collection(chain_enumerator([:success, :failure, :success, :failure])).select { |status| step nested_service, in: [status: -> { status }] }.result).to be_success.with_data(values: [:success, :success])
          expect(service.collection([:success, :failure, :success, :failure]).select { |status| step nested_service, in: [status: -> { status }] }.result).to be_success.with_data(values: [:success, :success])

          expect(service.collection(set([:success, :failure])).select { |status| step nested_service, in: [status: -> { status }] }.result).to be_success.with_data(values: [:success])
          expect(service.collection({success: :success, failure: :failure}).select { |key, value| step nested_service, in: [status: -> { value }] }.result).to be_success.with_data(values: {success: :success})
          expect(service.collection((:success..:success)).select { |status| step nested_service, in: [status: -> { status }] }.result).to be_success.with_data(values: [:success])
          expect(service.collection((:failure..:failure)).select { |status| step nested_service, in: [status: -> { status }] }.result).to be_success.with_data(values: [])

          # NOTE: Step with one output.
          expect(service.collection(enumerable([:success, :failure, :success, :failure])).select { |status| step nested_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(values: [:success, :success])
          expect(service.collection(enumerator([:success, :failure, :success, :failure])).select { |status| step nested_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(values: [:success, :success])
          expect(service.collection(lazy_enumerator([:success, :failure, :success, :failure])).select { |status| step nested_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(values: [:success, :success])
          expect(service.collection(chain_enumerator([:success, :failure, :success, :failure])).select { |status| step nested_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(values: [:success, :success])
          expect(service.collection([:success, :failure, :success, :failure]).select { |status| step nested_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(values: [:success, :success])

          expect(service.collection(set([:success, :failure])).select { |status| step nested_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(values: [:success])
          expect(service.collection({success: :success, failure: :failure}).select { |key, value| step nested_service, in: [status: -> { value }], out: :status_string }.result).to be_success.with_data(values: {success: :success})
          expect(service.collection((:success..:success)).select { |status| step nested_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(values: [:success])
          expect(service.collection((:failure..:failure)).select { |status| step nested_service, in: [status: -> { status }], out: :status_string }.result).to be_success.with_data(values: [])

          # NOTE: Step with multiple outputs.
          expect(service.collection(enumerable([:success, :failure, :success, :failure])).select { |status| step nested_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [:success, :success])
          expect(service.collection(enumerator([:success, :failure, :success, :failure])).select { |status| step nested_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [:success, :success])
          expect(service.collection(lazy_enumerator([:success, :failure, :success, :failure])).select { |status| step nested_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [:success, :success])
          expect(service.collection(chain_enumerator([:success, :failure, :success, :failure])).select { |status| step nested_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [:success, :success])
          expect(service.collection([:success, :failure, :success, :failure]).select { |status| step nested_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [:success, :success])

          expect(service.collection(set([:success, :failure])).select { |status| step nested_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [:success])
          expect(service.collection({success: :success, failure: :failure}).select { |key, value| step nested_service, in: [status: -> { value }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: {success: :success})
          expect(service.collection((:success..:success)).select { |status| step nested_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [:success])
          expect(service.collection((:failure..:failure)).select { |status| step nested_service, in: [status: -> { status }], out: [:status_string, :status_code] }.result).to be_success.with_data(values: [])

          # NOTE: Error result.
          expect(service.collection(enumerable([:success, :error, :exception])).filter { |status| step nested_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection(enumerator([:success, :error, :exception])).filter { |status| step nested_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection(lazy_enumerator([:success, :error, :exception])).filter { |status| step nested_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection(chain_enumerator([:success, :error, :exception])).filter { |status| step nested_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection([:success, :error, :exception]).filter { |status| step nested_service, in: [status: -> { status }] }.result).to be_error.without_data

          expect(service.collection(set([:success, :error, :exception])).filter { |status| step nested_service, in: [status: -> { status }] }.result).to be_error.without_data
          expect(service.collection({success: :success, error: :error, exception: :exception}).filter { |key, value| step nested_service, in: [status: -> { value }] }.result).to be_error.without_data
          expect(service.collection((:error..:error)).filter { |status| step nested_service, in: [status: -> { status }] }.result).to be_error.without_data

          # NOTE: Error propagation.
          expect(service.collection(enumerable([:success, :error, :exception])).filter { |status| step nested_service, in: [status: -> { status }] }.select { |status| condition[status] }.result).to be_error.without_data
          expect(service.collection(enumerator([:success, :error, :exception])).filter { |status| step nested_service, in: [status: -> { status }] }.select { |status| condition[status] }.result).to be_error.without_data
          expect(service.collection(lazy_enumerator([:success, :error, :exception])).filter { |status| step nested_service, in: [status: -> { status }] }.select { |status| condition[status] }.result).to be_error.without_data
          expect(service.collection(chain_enumerator([:success, :error, :exception])).filter { |status| step nested_service, in: [status: -> { status }] }.select { |status| condition[status] }.result).to be_error.without_data
          expect(service.collection([:success, :error, :exception]).filter { |status| step nested_service, in: [status: -> { status }] }.select { |status| condition[status] }.result).to be_error.without_data

          expect(service.collection(set([:success, :error, :exception])).filter { |status| step nested_service, in: [status: -> { status }] }.select { |status| condition[status] }.result).to be_error.without_data
          expect(service.collection({success: :success, error: :error, exception: :exception}).filter { |key, value| step nested_service, in: [status: -> { value }] }.select { |key, value| condition[value] }.result).to be_error.without_data
          expect(service.collection((:error..:error)).filter { |status| step nested_service, in: [status: -> { status }] }.select { |status| condition[status] }.result).to be_error.without_data

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

      # first(2) => [only_one] # What to do? success of failure?
      # cycle(2) => nil # What to do? success without data?
      # drop(2) => [] # What to do? success when nothing dropped?
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers, RSpec/DescribeClass, RSpec/ExampleLength, RSpec/MissingExampleGroupArgument, RSpec/MultipleExpectations
