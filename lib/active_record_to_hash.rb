module ActiveRecordToHash
  class Railtie < ::Rails::Railtie
    config.active_record_to_hash = ActiveSupport::OrderedOptions.new
    config.active_record_to_hash.method_name = :to_hash
    config.active_record_to_hash.aliases = []

    config.after_initialize do |_app|
      require 'active_record_to_hash/version'
      require 'active_record_to_hash/utilities'
      require 'active_record_to_hash/active_record'
      ::ActiveRecord::Base.send(:include, ::ActiveRecordToHash::ActiveRecord)
    end
  end
end
