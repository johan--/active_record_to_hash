module ActiveRecordToHash
  module ActiveRecord
    extend ActiveSupport::Concern

    included do
      include ActiveRecordToHash::ActiveRecord::LocalInstanceMethods
    end

    module LocalInstanceMethods
      def to_hash(options = {})
        attributes.each_with_object({}) do |(k, v), hash|
          key = k.to_sym
          next if options[:except] && options[:except].include?(key)
          next if options[:only] && !options[:only].include?(key)
          hash[key] = v
        end
      end
    end
  end
end
