module ActiveRecordToHash
  module_function

  def retrieve_child_attribute(record, attr_name, options)
    value = record.public_send(attr_name)
    return value.to_hash(options) if value.is_a? ::ActiveRecord::Base
    value
  end

  module ActiveRecord
    extend ActiveSupport::Concern

    included do
      include ActiveRecordToHash::ActiveRecord::LocalInstanceMethods
    end

    module LocalInstanceMethods
      def to_hash(options = {})
        hash = attributes.each_with_object({}) do |(k, v), memo|
          key = k.to_sym
          next if options[:except] && options[:except].include?(key)
          next if options[:only] && !options[:only].include?(key)
          memo[key] = v
        end

        options.each_key do |k|
          next unless k.to_s.start_with?('with_')

          attr_name = k[5..-1].to_sym # 5 is 'with_'.length
          hash_key = options[k] == true || options[k][:key].nil? ? attr_name : options[k][:key]
          options = options[k] == true ? {} : options[k]
          hash[hash_key] = ActiveRecordToHash.retrieve_child_attribute(self, attr_name, options)
        end

        hash
      end
    end
  end
end
