module ActiveRecordToHash
  module ActiveRecord
    extend ActiveSupport::Concern

    module ClassMethods
      def active_record_to_hash_converters
        @active_record_to_hash_converters || []
      end

      def add_active_record_to_hash_converter(&block)
        @active_record_to_hash_converters ||= []
        @active_record_to_hash_converters << block
      end

      private

        # This is for the spec only. Don't call this.
        def clear_active_record_to_hash_converters
          @active_record_to_hash_converters = []
        end
    end

    def to_hash(options = {})
      attrs_reader = options[:attrs_reader] || :attributes
      hash = public_send(attrs_reader).each_with_object({}) do |(k, v), memo|
        key = k.to_sym
        next if ActiveRecordToHash.to_a(options[:except]).include?(key)
        next if options[:only] && !ActiveRecordToHash.to_a(options[:only]).include?(key)
        memo[key] = ActiveRecordToHash.convert(self.class, key, v)
      end

      ActiveRecordToHash.handle_with_options(options) do |hash_key, attr_name, child_options|
        hash[hash_key] = ActiveRecordToHash.retrieve_child_attribute(self, attr_name, child_options, __callee__)
      end

      hash
    end
  end
end
