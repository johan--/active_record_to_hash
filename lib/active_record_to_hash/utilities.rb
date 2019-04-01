module ActiveRecordToHash
  module_function

  def call_scope(relation, scope)
    if scope.is_a? Proc
      ret = relation.instance_exec(&scope)
      return ret || relation
    end

    relation.public_send(scope)
  end

  def to_a(value)
    return value if value.is_a? Array
    return [] if value.nil?

    [value]
  end

  def retrieve_child_attribute(record, attr_name, options, callee)
    args = options[:args] || []
    value = record.public_send(attr_name, *args)
    ActiveRecordToHash.to_a(options[:scope]).each do |scope|
      value = ActiveRecordToHash.call_scope(value, scope)
    end
    return value.public_send(callee, options) if value.is_a? ::ActiveRecord::Base

    if value.respond_to?(:map)
      return value.map do |obj|
        next obj.public_send(callee, options) if obj.is_a? ::ActiveRecord::Base

        obj
      end
    end

    value
  end

  def handle_with_options(options)
    options.each_key do |key|
      next unless key.to_s.start_with?('with_')

      attr_name = key[5..-1].to_sym # 5 is 'with_'.length
      hash_key = options[key] == true || options[key][:key].nil? ? attr_name : options[key][:key]
      child_options = options[key] == true ? {} : options[key]
      yield(hash_key, attr_name, child_options)
    end
  end
end
