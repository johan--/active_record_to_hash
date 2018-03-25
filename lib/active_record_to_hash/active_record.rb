module ActiveRecordToHash
  module_function
  def handle_with_option(record, attr_name, options)
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
        hash = attributes.each_with_object({}) do |(k, v), hash|
          key = k.to_sym
          next if options[:except] && options[:except].include?(key)
          next if options[:only] && !options[:only].include?(key)
          hash[key] = v
        end

        options.each do |k, v|
          next unless k.to_s.start_with?('with_')

          attr_name = k['with_'.length..-1].to_sym
          hash_key = options[k] == true || options[k][:key].nil? ? attr_name : options[k][:key]
          options = options[k] == true ? {} : options[k]
          hash[hash_key] = ActiveRecordToHash.handle_with_option(self, attr_name, options)
        end

        hash
      end
    end
  end
end
