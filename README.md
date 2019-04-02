# ActiveRecordToHash

## Summary

Add `to_hash` method to ActiveRecord of Rails. The `to_hash` method can also acquire related records with relations by Hash, by passing the options to the argument.You can filter the values to retrieve, and change the keys of Hash using options.

ActiveRecordToHash will be useful when creating a Web API that returns a response with JSON.

## Installation

```
gem 'active_record_to_hash', '~>0.1'
```


## Usage

### Options

| Key | Description | Type |
|:--|:--|:--|
| attrs_reader | Specify a method to get the hash of the value and column name. If you omitt it, `attributes` is used. | Symbol |
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
 
 def to_api_hash
     {
       id: id,
       name: name
    }
 end
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

p shop.to_hash(attrs_reader: to_api_hash)
# {
#   :id=>1,
#   :name=>"Shop No1",
# }

p shop.to_hash(attrs_reader: ->(shop){ {shop_id: shop.id} })
# {
#   :shop_id=>1,
# }

p shop.to_hash(only: :name)
# {:name => "Shop No1"}

p shop.to_hash(except: [:created_at, :updated_at])
# {:id => 1, :name => "Shop No1"}

p shop.to_hash(only: [:id], with_name: {key: :foobar})
# {:id=>1, :foobar=>"Shop No1"}

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

p shop.to_hash(only: [:id, :name], with_areas: {key: :area_list})
# {
#  :id=>1,
#  :name=>"Shop No1",
#  :area_list=>[
#   {:id=>1, :name=>"Area No1", :wide_area_id=>1, :created_at=>Mon, 26 Mar 2018 07:53:26 UTC +00:00, :updated_at=>Mon, 26 Mar 2018 07:53:26 UTC +00:00},
#   {:id=>2, :name=>"Area No2", :wide_area_id=>2, :created_at=>Mon, 26 Mar 2018 07:53:26 UTC +00:00, :updated_at=>Mon, 26 Mar 2018 07:53:26 UTC +00:00},
#   {:id=>3, :name=>"Area No3", :wide_area_id=>3, :created_at=>Mon, 26 Mar 2018 07:53:26 UTC +00:00, :updated_at=>Mon, 26 Mar 2018 07:53:26 UTC +00:00}
#  ]
# }

p shop.to_hash(only: [:id, :name], with_areas: {scope: ->{ where(id: 1) }})
# {
#  :id=>1,
#  :name=>"Shop No1",
#  :areas=>[
#   {:id=>1, :name=>"Area No1", :wide_area_id=>1, :created_at=>Mon, 26 Mar 2018 07:53:26 UTC +00:00, :updated_at=>Mon, 26 Mar 2018 07:53:26 UTC +00:00}
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


p shop.to_hash(
  only: [:id, :name],
  with_areas: {
    alter: ->(areas){ areas.each_with_object({}) {|area, memo| memo[area[:id]] = area[:name] } }
  }
)
# {
#   :id=>1,
#   :name=>"Shop No1",
#   :areas=>{1=>"Area No1", 2=>"Area No2", 3=>"Area No3"}
# }

```

### Configuration

#### method_name

You can change the method name from `:to_hash` to you want.

```rb
# config/application.rb
module   YourApp
 class   Application < Rails::Application
   ...
   config.active_record_to_hash.method_name = :to_your_hash
 end
end
```

#### aliases

You can set an aliases for the method.

```rb
# config/application.rb
module   YourApp
 class   Application < Rails::Application
   ...
   config.active_record_to_hash.aliases = [:to_api_hash]
 end
end
```

This is useful for overriding and preparing hashed methods of various patterns. The same alias method is also called for the related record specified in `with_[attribute_name]` option.

```rb
# app/model/application_record.rb

  def to_api_hash(options = {})
    options = {
      except: [:created_at, :updated_at, :sequence],
      attrs_reader: :attributes_for_api
    }.merge(options)
    
    super(options)
  end
  
  # Time type value is converted to timestamp.
  def attributes_for_api
    hash = attributes.each_with_object({}.with_indifferent_access) do |(k, v), obj|
      v = v.to_i if v.is_a? Time
      obj[k] = v
    end
    hash
  end
```



## Contributing

* Run rspec test.
* Check source code with the rubocop.


## License
The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).