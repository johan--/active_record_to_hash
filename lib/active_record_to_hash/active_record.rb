module ActiveRecordToHash
  module ActiveRecord
    extend ActiveSupport::Concern

    included do
      define_method ::Rails.application.config.active_record_to_hash.method_name do |options = {}|
        attrs_reader = options[:attrs_reader] || :attributes
        hash = public_send(attrs_reader).each_with_object({}) do |(k, v), memo|
          key = k.to_sym
          next if ActiveRecordToHash.to_a(options[:except]).include?(key)
          next if options[:only] && !ActiveRecordToHash.to_a(options[:only]).include?(key)
          memo[key] = v
        end
  
        ActiveRecordToHash.handle_with_options(options) do |hash_key, attr_name, child_options|
          hash[hash_key] = ActiveRecordToHash.retrieve_child_attribute(self, attr_name, child_options, __callee__)
        end
  
        hash
      end
    end
  end
end
