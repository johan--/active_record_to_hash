module ActiveRecordToHash
  class Railtie < ::Rails::Railtie
    config.after_initialize do |_app|
      require 'active_record_to_hash/active_record'
      ::ActiveRecord::Base.send(:include, ::ActiveRecordToHash::ActiveRecord)
    end
  end
end
