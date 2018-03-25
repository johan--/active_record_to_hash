module ActiveRecordToHash
  module ActiveRecord
    extend ActiveSupport::Concern

    included do
      include ActiveRecordToHash::ActiveRecord::LocalInstanceMethods
    end

    module LocalInstanceMethods
      def to_hash(options = {})
        attributes
      end
    end
  end
end
