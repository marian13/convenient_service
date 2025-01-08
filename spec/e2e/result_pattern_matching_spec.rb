# frozen_string_literal: true

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers, RSpec/DescribeClass
RSpec.describe "Result pattern matching", type: [:standard, :e2e] do
  let(:service_class) do
    Class.new do
      include ConvenientService::Standard::Config
    end
  end

  let(:service_instance) { service_class.new }

  let(:service) { service_instance }

  example_group "array patterns" do
    def match(result)
      case result
      in [:success, {foo: "foo", bar: "bar"}, "foo", :foo]
        raise
      in [:success, {foo: "foo", bar: "bar"}, "foo"]
        raise
      in [:success, {foo: "foo", bar: "bar"}]
        1
      in [:success, {foo: /foo/, bar: /bar/}]
        2
      in [:success, {foo: "foo", **nil}]
        3
      in [:success, {foo: /foo/, **nil}]
        4
      in [:success, {foo: "foo"}]
        5
      in [:success, {foo: /foo/}]
        6
      in [:success, {}]
        7
      in [:failure, "foo", :foo]
        raise
      in [:failure, "foo"]
        8
      in [:failure, /foo/]
        9
      in [:failure, ""]
        10
      in [:error, "foo", :foo]
        raise
      in [:error, "foo"]
        11
      in [:error, /foo/]
        12
      in [:error, ""]
        13
      else
        14
      end
    end

    specify { expect(match(service.success(data: {foo: "foo", bar: "bar", baz: "baz", message: "foo", code: :foo}))).to eq(1) }
    specify { expect(match(service.success(data: {foo: "foo", bar: "bar", baz: "baz", message: "foo"}))).to eq(1) }
    specify { expect(match(service.success(data: {foo: "foo", bar: "bar", baz: "baz"}))).to eq(1) }
    specify { expect(match(service.success(data: {foo: " foo ", bar: " bar ", baz: "baz"}))).to eq(2) }
    specify { expect(match(service.success(data: {foo: "foo"}))).to eq(3) }
    specify { expect(match(service.success(data: {foo: " foo "}))).to eq(4) }
    specify { expect(match(service.success(data: {foo: "foo", baz: "baz"}))).to eq(5) }
    specify { expect(match(service.success(data: {foo: " foo ", baz: "baz"}))).to eq(6) }
    specify { expect(match(service.success(data: {}))).to eq(7) }
    specify { expect(match(service.success)).to eq(7) }

    specify { expect(match(service.failure(message: "foo", code: :foo))).to eq(8) }
    specify { expect(match(service.failure(message: "foo"))).to eq(8) }
    specify { expect(match(service.failure(message: " foo "))).to eq(9) }
    specify { expect(match(service.failure(message: ""))).to eq(10) }

    specify { expect(match(service.error(message: "foo", code: :foo))).to eq(11) }
    specify { expect(match(service.error(message: "foo"))).to eq(11) }
    specify { expect(match(service.error(message: " foo "))).to eq(12) }
    specify { expect(match(service.error(message: ""))).to eq(13) }

    specify { expect(match(service.error(message: "bar"))).to eq(14) }
  end

  example_group "hash patterns" do
    def match(result)
      case result
      in status: :success, code: "foo"
        raise
      in status: :success, code: :foo
        1
      in status: :success, code: /foo/
        2
      in status: :success, code: :default_success
        3
      in status: :success, code: ""
        raise
      in status: :success, message: "foo"
        4
      in status: :success, message: /foo/
        5
      in status: :success, message: ""
        6
      in status: :success, data: {foo: "foo", bar: "bar"}
        7
      in status: :success, data: {foo: /foo/, bar: /bar/}
        8
      in status: :success, data: {foo: "foo", **nil}
        9
      in status: :success, data: {foo: /foo/, **nil}
        10
      in status: :success, data: {foo: "foo"}
        11
      in status: :success, data: {foo: /foo/}
        12
      in status: :success, data: {}
        13
      in status: :success
        14
      in status: :failure, code: "foo"
        raise
      in status: :failure, code: :foo
        15
      in status: :failure, code: /foo/
        16
      in status: :failure, code: :default_failure
        17
      in status: :failure, code: ""
        raise
      in status: :failure, message: "foo"
        18
      in status: :failure, message: /foo/
        19
      in status: :failure, message: ""
        20
      in status: :failure, data: {foo: "foo", bar: "bar"}
        21
      in status: :failure, data: {foo: /foo/, bar: /bar/}
        22
      in status: :failure, data: {foo: "foo", **nil}
        23
      in status: :failure, data: {foo: /foo/, **nil}
        24
      in status: :failure, data: {foo: "foo"}
        25
      in status: :failure, data: {foo: /foo/}
        26
      in status: :failure, data: {}
        27
      in status: :failure
        28
      in status: :error, code: "foo"
        raise
      in status: :error, code: :foo
        29
      in status: :error, code: /foo/
        30
      in status: :error, code: :default_error
        31
      in status: :error, code: ""
        raise
      in status: :error, message: "foo"
        32
      in status: :error, message: /foo/
        33
      in status: :error, message: ""
        34
      in status: :error, data: {foo: "foo", bar: "bar"}
        35
      in status: :error, data: {foo: /foo/, bar: /bar/}
        36
      in status: :error, data: {foo: /foo/, **nil}
        37
      in status: :error, data: {foo: "foo", **nil}
        38
      in status: :error, data: {foo: /foo/}
        39
      in status: :error, data: {foo: "foo"}
        40
      in status: :error, data: {}
        41
      in status: :error
        42
      else
        43
      end
    end

    specify { expect(match(service.success(data: {qux: "qux"}, message: "bar", code: :foo))).to eq(1) }
    specify { expect(match(service.success(data: {qux: "qux"}, message: "bar", code: "foo"))).to eq(1) }
    specify { expect(match(service.success(data: {qux: "qux"}, message: "bar", code: " foo "))).to eq(2) }
    specify { expect(match(service.success(data: {qux: "qux"}, message: "bar", code: :default_success))).to eq(3) }
    specify { expect(match(service.success(data: {qux: "qux"}, message: "bar", code: ""))).to eq(14) }

    specify { expect(match(service.success(data: {qux: "qux"}, message: "foo", code: :bar))).to eq(4) }
    specify { expect(match(service.success(data: {qux: "qux"}, message: " foo ", code: :bar))).to eq(5) }
    specify { expect(match(service.success(data: {qux: "qux"}, message: "", code: :bar))).to eq(6) }

    specify { expect(match(service.success(data: {foo: "foo", bar: "bar", baz: "baz"}, message: "bar", code: :bar))).to eq(7) }
    specify { expect(match(service.success(data: {foo: " foo ", bar: " bar ", baz: "baz"}, message: "bar", code: :bar))).to eq(8) }
    specify { expect(match(service.success(data: {foo: "foo"}, message: "bar", code: :bar))).to eq(9) }
    specify { expect(match(service.success(data: {foo: " foo "}, message: "bar", code: :bar))).to eq(10) }
    specify { expect(match(service.success(data: {foo: "foo", baz: "baz"}, message: "bar", code: :bar))).to eq(11) }
    specify { expect(match(service.success(data: {foo: " foo ", baz: "baz"}, message: "bar", code: :bar))).to eq(12) }
    specify { expect(match(service.success(data: {}, message: "bar", code: :bar))).to eq(13) }
    specify { expect(match(service.success(message: "bar", code: :bar))).to eq(13) }
    specify { expect(match(service.success(data: {baz: "baz"}, message: "bar", code: :bar))).to eq(14) }
  end

  example_group "steps" do
    let(:foo_service_step) do
      Class.new do
        include ConvenientService::Standard::Config

        def result
          success(data: {foo: "foo"}, message: "foo", code: :foo)
        end
      end
    end

    let(:bar_service_step) do
      Class.new do
        include ConvenientService::Standard::Config

        def result
          success(data: {bar: "bar"}, message: "bar", code: :bar)
        end
      end
    end

    let(:baz_service_step) do
      Class.new do
        include ConvenientService::Standard::Config

        def result
          success(data: {baz: "baz"}, message: "baz", code: :baz)
        end
      end
    end

    let(:service_class) do
      Class.new.tap do |klass|
        klass.class_exec(foo_service_step, bar_service_step, baz_service_step) do |foo_service_step, bar_service_step, baz_service_step|
          include ConvenientService::Standard::Config

          step foo_service_step

          step bar_service_step

          step baz_service_step

          step foo_service_step

          step bar_service_step

          step baz_service_step

          step :foo_method_step

          step :bar_method_step

          step :baz_method_step

          step :foo_method_step

          step :bar_method_step

          step :baz_method_step

          def foo_method_step
            success(data: {foo: "foo"}, message: "foo", code: :foo)
          end

          def bar_method_step
            success(data: {bar: "bar"}, message: "bar", code: :bar)
          end

          def baz_method_step
            success(data: {baz: "baz"}, message: "baz", code: :baz)
          end
        end
      end
    end

    def match(result)
      foo_service_step = foo_service_step()
      bar_service_step = bar_service_step()
      baz_service_step = baz_service_step()

      case result
      in step: ^foo_service_step, step_index: 0
        0
      in step: ^bar_service_step, step_index: 1
        1
      in step: ^foo_service_step, step_index: 3
        2
      in step: ^bar_service_step, step_index: 4
        3
      in step_index: 5
        4
      in step: ^baz_service_step
        5
      in step: :foo_method_step, step_index: 6
        6
      in step: :bar_method_step, step_index: 7
        7
      in step: :foo_method_step, step_index: 9
        8
      in step: :bar_method_step, step_index: 10
        9
      in step_index: 11
        10
      else
        11
      end
    end

    specify { expect(match(service.steps[0].result)).to eq(0) }
    specify { expect(match(service.steps[1].result)).to eq(1) }
    specify { expect(match(service.steps[3].result)).to eq(2) }
    specify { expect(match(service.steps[4].result)).to eq(3) }
    specify { expect(match(service.steps[5].result)).to eq(4) }
    specify { expect(match(service.steps[2].result)).to eq(5) }

    specify { expect(match(service.steps[6].result)).to eq(6) }
    specify { expect(match(service.steps[7].result)).to eq(7) }
    specify { expect(match(service.steps[9].result)).to eq(8) }
    specify { expect(match(service.steps[10].result)).to eq(9) }
    specify { expect(match(service.steps[11].result)).to eq(10) }

    specify { expect(match(service.success)).to eq(11) }
  end

  example_group "original services" do
    let(:foo_service_step) do
      Class.new.tap do |klass|
        klass.class_exec(foo_nested_service_step) do |foo_nested_service_step|
          include ConvenientService::Standard::Config

          step foo_nested_service_step

          step :foo_nested_method_step

          def foo_nested_method_step
            success(data: {foo: "foo"}, message: "foo", code: :foo)
          end
        end
      end
    end

    let(:foo_nested_service_step) do
      Class.new.tap do |klass|
        klass.class_exec(foo_two_times_nested_service_step) do |foo_two_times_nested_service_step|
          include ConvenientService::Standard::Config

          step foo_two_times_nested_service_step

          step :foo_two_times_nested_method_step

          def foo_two_times_nested_method_step
            success(data: {foo: "foo"}, message: "foo", code: :foo)
          end
        end
      end
    end

    let(:foo_two_times_nested_service_step) do
      Class.new do
        include ConvenientService::Standard::Config

        def result
          success(data: {foo: "foo"}, message: "foo", code: :foo)
        end
      end
    end

    let(:bar_service_step) do
      Class.new do
        include ConvenientService::Standard::Config

        def result
          success(data: {bar: "bar"}, message: "bar", code: :bar)
        end
      end
    end

    let(:service_class) do
      Class.new.tap do |klass|
        klass.class_exec(foo_service_step, bar_service_step) do |foo_service_step, bar_service_step|
          include ConvenientService::Standard::Config

          step foo_service_step

          step :foo_method_step

          step bar_service_step

          def foo_method_step
            success(data: {foo: "foo"}, message: "foo", code: :foo)
          end
        end
      end
    end

    let(:other_service) do
      Class.new do
        include ConvenientService::Standard::Config

        def result
          success
        end
      end
    end

    def match(result)
      service = service()
      foo_service_step = foo_service_step()
      foo_nested_service_step = foo_nested_service_step()
      foo_two_times_nested_service_step = foo_two_times_nested_service_step()

      case result
      in original_service: ^foo_two_times_nested_service_step
        1
      in original_service: ^foo_nested_service_step
        2
      in original_service: ^foo_service_step
        3
      in original_service: ^service
        4
      in service: ^service
        5
      else
        6
      end
    end

    specify { expect(match(service.steps[0].service_result.service.steps[0].service_result.service.steps[0].service_result)).to eq(1) }
    specify { expect(match(service.steps[0].service_result.service.steps[0].service_result.service.steps[1].method_result)).to eq(2) }
    specify { expect(match(service.steps[0].service_result.service.steps[1].method_result)).to eq(3) }
    specify { expect(match(service.steps[1].method_result)).to eq(4) }
    specify { expect(match(service.result)).to eq(5) }
    specify { expect(match(other_service.result)).to eq(6) }
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers, RSpec/DescribeClass
