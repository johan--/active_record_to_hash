module ActiveRecordToHash
  module_function

  def convert(model, key, value)
    target_class = model
    while target_class.respond_to? :active_record_to_hash_converters
      target_class.active_record_to_hash_converters.each do |converter|
        ret = converter.call(key, value)
        value = ret unless ret.nil?
      end
      target_class = target_class.superclass
    end

    value
  end

  # Going up the class hierarchy, if one filter returns false, we remove it.
  def filter(model, key, value)
    target_class = model
    while target_class.respond_to? :active_record_to_hash_filters
      target_class.active_record_to_hash_filters.each do |filter|
        return false if filter.call(key, value) == false
      end
      target_class = target_class.superclass
    end

    true
  end

  def call_scope(relation, scope)
    if scope.is_a? Hash
      scope.each_key do |key|
        relation = relation.public_send(key, *ActiveRecordToHash.to_a(scope[key]))
      end
      return relation
    end

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

  def retrieve_child_attribute(record, attr_name, options)
    value = record.public_send(attr_name)
    ActiveRecordToHash.to_a(options[:scope]).each do |scope|
      value = ActiveRecordToHash.call_scope(value, scope)
    end
    return value.to_hash(options) if value.is_a? ::ActiveRecord::Base
    return value.map {|rec| rec.to_hash(options) } if value.is_a? ::ActiveRecord::Relation
    value
  end

  def handle_with_options(options)
    options.each_key do |k|
      next unless k.to_s.start_with?('with_')

      attr_name = k[5..-1].to_sym # 5 is 'with_'.length
      hash_key = options[k] == true || options[k][:key].nil? ? attr_name : options[k][:key]
      options = options[k] == true ? {} : options[k]
      yield(hash_key, attr_name, options)
    end
  end
end
