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

  def retrieve_child_attribute(record, attr_name, args)
    options = args.extract_options!
    value = record.public_send(attr_name)
    ActiveRecordToHash.to_a(options[:scope]).each do |scope|
      value = ActiveRecordToHash.call_scope(value, scope)
    end
    return value.to_hash(*args, options) if value.is_a? ::ActiveRecord::Base
    return value.map {|rec| rec.to_hash(*args, options) } if value.is_a? ::ActiveRecord::Relation
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
