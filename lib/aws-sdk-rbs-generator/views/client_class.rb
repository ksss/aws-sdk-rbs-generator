# frozen_string_literal: true

module AwsSdkRbsGenerator
  module Views
    class ClientClass < View
      def initialize(shape_dictionary:)
        @shape_dictionary = shape_dictionary
      end

      def service_name
        @shape_dictionary.service_id
      end

      def client_option
        require "aws-sdk-#{@shape_dictionary.identifier}"
        client_class = Aws.const_get(@shape_dictionary.service_id)::Client
        public_options = client_class.plugins.map(&:options).flatten.select(&:documented?)
        # see also aws-sdk-ruby/build_tools/aws-sdk-code-generator/lib/aws-sdk-code-generator/client_constructor.rb
        ordered_public_options = public_options.sort_by.with_index do |opt, i|
          [opt.required ? 'a' : 'b', opt.name, i]
        end
        buffer = ordered_public_options.map do |opt|
          type = case opt.name
            when :retry_mode
              '("legacy" | "standard" | "adaptive")'
            when :retry_jitter
              "(:none | :equal | :full | ^(Integer) -> Integer)"
            when :endpoint, :credentials, :log_formatter, :client_side_monitoring_publisher, :logger
              # TODO: Just not supported yet
              "untyped"
            else
              case opt.doc_type
              when "Boolean"
                "bool"
              when nil
                raise opt.inspect
              else
                opt.doc_type
              end
            end
          [opt.name, "?#{opt.name}: #{type}#{opt.required ? "" : "?"}", opt.doc_type]
        end
        # Find duplicated key
        grouped = buffer.group_by { |name, rbs| name }
        grouped.transform_values(&:count).find_all { |name, v| 1 < v }.each do |name,|
          warn("Duprecate client option: `#{grouped[name].map { |g| g.values_at(0, 2) }}`", uplevel: 0)
        end
        buffer.uniq { |b| b[0] }.map { |b| b[1] }.join(", ")
      end

      def operations
        @shape_dictionary.service.api["operations"].map do |key, body|
          MethodSignature.new(
            method_name: body.fetch("name").underscore,
            arguments: body.dig("input", "shape")&.then { @shape_dictionary[_1].find(&:input?).as_keyword_arguments(from: :operations) },
            returns: body.dig("output", "shape")&.then { "Types::#{_1}" } || "Aws::EmptyStructure",
          )
        end
      end
    end
  end
end
