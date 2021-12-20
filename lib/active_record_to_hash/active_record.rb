# frozen_string_literal: true
module ActiveRecordToHash
  module ActiveRecord
    extend ActiveSupport::Concern

    included do
      define_method ::Rails.application.config.active_record_to_hash.method_name do |options = {}|
        if options[:pluck]
          result = public_send(options[:pluck])
        else
          attrs_reader = options[:attrs_reader] || :attributes
          attrs = attrs_reader.is_a?(Proc) ? attrs_reader.call(self) : public_send(attrs_reader)
          result = attrs.each_with_object({}) do |(k, v), memo|
            key = k.to_sym
            next if ActiveRecordToHash.to_a(options[:except]).include?(key)
            next if options[:only] && !ActiveRecordToHash.to_a(options[:only]).include?(key)

            memo[key] = v
          end
          result = ActiveRecordToHash.handle_alter(result, options)
        end

        ActiveRecordToHash.handle_with_options(options) do |hash_key, attr_name, child_options|
          child = ActiveRecordToHash.retrieve_child_attribute(self, attr_name, child_options, __callee__)
          result[hash_key] = ActiveRecordToHash.handle_alter(child, child_options)
        end

        result
      end

      ::Rails.application.config.active_record_to_hash.aliases.each do |alias_name|
        send(:alias_method, alias_name, ::Rails.application.config.active_record_to_hash.method_name)
      end
    end
  end
end
