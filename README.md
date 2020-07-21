This gem allows you to use `destroy?` for rails `ActiveRecord` models checking to see if a record can be destroyed.

## Usage

Example scenario:
```Ruby
class User < ApplicationRecord
  has_many :posts, dependent: :destroy
end

class Post < ApplicationRecord
  belongs_to :user

  has_many :comments, dependent: :restrict_with_error
end

class Comment < ApplicationRecord
  belongs_to :post
end
```

Calling `destroy` will not return the expected `Post` error `Cannot delete record because dependent comments exist`:
```Ruby
user = User.find(1)
if !user.destroy # => false
  puts user.errors.full_messages.to_sentence # => ""
end
```

Calling `destroy?` will:
```Ruby
user = User.find(1)
if user.destroy? # => false
  user.destroy # => true
else
  puts user.errors.full_messages.to_sentence # => Cannot delete record because dependent comments exist
end
```

## Installation
Add this line to your application's Gemfile:

```ruby
gem 'activerecord-destroyable', '~> 0.1.0'
```

And then execute:
```bash
$ bundle update
```

Or install it yourself as:
```bash
$ gem install activerecord-destroyable
```

## Real talk

Ideally a consistent design pattern should be encouraged. If you are running into the usage scenario then you should probably use `:restrict_with_error` to prevent the scenario e.g.
```Ruby
class User < ApplicationRecord
  has_many :posts, dependent: :restrict_with_error
end

class Post < ApplicationRecord
  belongs_to :user

  has_many :comments, dependent: :restrict_with_error
end

class Comment < ApplicationRecord
  belongs_to :post
end
```

I have yet to use this on a production application!

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
