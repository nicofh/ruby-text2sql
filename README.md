# Ruby::Text2sql

**Chat with your Database!**

How It Works?

Text2SQL takes:
- **Your natural language Query** (in any language).
- **Your OpenAI API Key** to process the query.
- **Your Database Schema** to understand table structures.

Using these, Text2SQL generates SQL queries, executes them, and returns results in a human-readable format—simplifying data access for both developers and non-developers.

## Installation

Install the gem and add to the application's Gemfile by executing:

    $ bundle add ruby-text2sql

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install ruby-text2sql

## Usage

- Set your `OPENAI_API_KEY` as an environment variable in `.env`.

- Use `Ruby::Text2sql.call` method with a plain-text query. Here's an example:
```
response = Ruby::Text2sql.call("List all users who registered in the last 30 days")
puts "SQL Query: #{response[:sql_query]}"                    # Outputs the generated SQL query
puts "Query Result: #{response[:query_result]}"              # Outputs the result of the SQL query
puts "Response: #{response[:natural_language_response]}"     # Outputs a human-readable response
```

## Configuration: Allowed SQL Actions

After installing the gem, you can generate an initializer to control which SQL actions are permitted by running:

```sh
rails generate ruby_text2sql:install
```

This will create `config/initializers/ruby_text2sql.rb` with content like:

```ruby
Ruby::Text2sql.configure do |config|
  # Allow only SELECT queries by default (safest)
  config.allowed_actions = [:select]

  # Example: Allow SELECT, INSERT, and UPDATE queries
  # config.allowed_actions = [:select, :insert, :update]

  # Example: To allow DELETE queries (use with caution)
  # config.allowed_actions = [:select, :insert, :update, :delete]
end
```

**Note:** Only the actions listed in `allowed_actions` (as symbols) will be permitted for execution. This helps protect your database from dangerous or unwanted queries.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/nicofh/ruby-text2sql. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/nicofh/ruby-text2sql/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Ruby::Text2sql project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/nicofh/ruby-text2sql/blob/master/CODE_OF_CONDUCT.md).
