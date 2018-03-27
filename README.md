# ActiveRecordToHash

## Summary

Add `to_hash` method to ActiveRecord of Rails. The `to_hash` method can also acquire related records with relations by Hash, by passing the options to the argument.You can filter the values to retrieve, and change the keys of Hash using options.

It is also possible to register converter methods in the model, and convert values.

## Installation

```
gem 'active_record_to_hash', '~>0.1'
```


## Usage

### Options

| Key | Description | Type |
|:--|:--|:--|
| _[key_name] | Specify a block as a value. The execution result is added to the hash with the specified key_name. The block executes in the scope of record. | Proc |
| key | Change the key of the hash. | Symbol |
| except | Remove from the hash. | Symbol Array |
| only | Retrieve only the specified key. | Symbol Array |
| with_[attribute_name] | The attribute name is passed to public_send. If the return value is ActiveRecord or ActiveRecord_Relation, call `to_hash`. The Hash specified for this value is passed to that `to_hash`. | Boolean Hash |
| scope | You can specify scope when acquiring related records. | Symbol Array Proc |


### Examples

Examples are shown assuming the following tables.

```rb
create_table :wide_areas do |t|
 t.string :name
 t.timestamps
end

create_table :areas   do |t|
 t.string :name
 t.references :wide_area, foreign_key:   true
 t.timestamps
end

create_table :shops   do |t|
 t.string :name
 t.timestamps
end

create_table :shop_areas   do |t|
 t.references :shop, foreign_key:   true
 t.references :area, foreign_key:   true
 t.timestamps
end

class   Shop < ApplicationRecord
 has_many :shop_areas
 has_many :areas, inverse_of:   :shops, through:   :shop_areas
end
```

```rb
p shop.to_hash
# {
#   :id=>1,
#   :name=>"Shop No1",
#   :created_at=>Mon, 26 Mar 2018 07:53:26 UTC +00:00,
#   :updated_at=>Mon, 26 Mar 2018 07:53:26 UTC +00:00
# }

p shop.to_hash(only: :name)
# {:name => "Shop No1"}

p shop.to_hash(except: [:created_at, :updated_at])
# {:id => 1, :name => "Shop No1"}

p shop.to_hash(only: [:id, :name], with_areas: true)
# {
#  :id=>1,
#  :name=>"Shop No1",
#  :areas=>[
#   {:id=>1, :name=>"Area No1", :wide_area_id=>1, :created_at=>Mon, 26 Mar 2018 07:53:26 UTC +00:00, :updated_at=>Mon, 26 Mar 2018 07:53:26 UTC +00:00},
#   {:id=>2, :name=>"Area No2", :wide_area_id=>2, :created_at=>Mon, 26 Mar 2018 07:53:26 UTC +00:00, :updated_at=>Mon, 26 Mar 2018 07:53:26 UTC +00:00},
#   {:id=>3, :name=>"Area No3", :wide_area_id=>3, :created_at=>Mon, 26 Mar 2018 07:53:26 UTC +00:00, :updated_at=>Mon, 26 Mar 2018 07:53:26 UTC +00:00}
#  ]
# }

p shop.to_hash(
  only: [:id, :name],
  with_areas: {
    only: [:id, :name],
    with_wide_area: {
      only: [:id, :name]
    }
  }
)
# {
#   :id=>1,
#   :name=>"Shop No1",
#   :areas=>[
#     {:id=>1, :name=>"Area No1", :wide_area=>{:id=>1, :name=>"Wide Area No1"}},
#     {:id=>2, :name=>"Area No2", :wide_area=>{:id=>2, :name=>"Wide Area No2"}},
#     {:id=>3, :name=>"Area No3", :wide_area=>{:id=>3, :name=>"Wide Area No3"}}
#   ]
# }
```

### Converter

You can register converters for each model. If the function registered in the converters returns nil, the converter will be ignored.

```rb
class Shop < ApplicationRecord
  has_many :shop_areas
  has_many :areas, inverse_of: :shops, through: :shop_areas

  add_active_record_to_hash_converter do |key, value|
    value.strftime('%Y-%m-%d %H:%M:%S') if value.is_a? Time
  end
end
```

```rb
p shop.to_hash
# {
#   :id=>1,
#   :name=>"Shop No1",
#   :created_at=>"2018-03-26 08:21:32",
#   :updated_at=>"2018-03-26 08:21:32"
# }
```


## Contributing

* Run rspec test.
* Check source code with the rubocop.


## License
The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).