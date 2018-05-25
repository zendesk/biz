# frozen_string_literal: true

module Biz
  module Timeline
    class Proxy

      def initialize(periods)
        @periods = periods
      end

      def forward
        Forward.new(periods)
      end

      def backward
        Backward.new(periods)
      end

      private

      attr_reader :periods

    end
  end
end
