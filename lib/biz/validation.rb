# frozen_string_literal: true

module Biz
  class Validation

    def self.perform(configuration)
      new(configuration).perform
    end

    def initialize(configuration)
      @configuration = configuration
    end

    def perform
      RULES.each do |rule| rule.check(configuration) end

      self
    end

    private

    attr_reader :configuration

    class Rule

      def initialize(message, &condition)
        @message   = message
        @condition = condition
      end

      def check(configuration)
        fail Error::Configuration, message if condition.call(configuration)
      end

      private

      attr_reader :message,
                  :condition

    end

    RULES = [
      Rule.new('nonsensical hours provided') { |configuration|
        configuration.intervals.any?(&:empty?)
      }
    ].freeze

    private_constant :RULES

  end
end
