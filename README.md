# Ruby::Text2sql

Text2SQL is a gem designed to generate SQL queries from natural language inputs.
It leverages machine learning models to interpret schema files and user inputs,
generating SQL queries that can be executed and returning results in a human-readable format.

## Installation

Install the gem and add to the application's Gemfile by executing:

    $ bundle add ruby-text2sq

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install ruby-text2sq

## Usage

After installing the gem, you need to configure your OpenAI API key to enable the text-to-SQL generation.
Set the `OPENAI_API_KEY` as an environment variable in `.env`.

To generate SQL queries based on user requests, use the `Text2sql.call` method with a plain-text query. Here’s an example:
```
    require 'text2sql'

    response = Ruby::Text2sql.call("List all users who registered in the last 30 days")
    puts "SQL Query: #{response[:sql_query]}"                    # Outputs the generated SQL query
    puts "Query Result: #{response[:query_result]}"              # Outputs the result of the SQL query
    puts "Response: #{response[:natural_language_response]}"     # Outputs a human-readable response
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/nicofh/ruby-text2sql. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/nicofh/ruby-text2sql/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Ruby::Text2sql project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/nicofh/ruby-text2sql/blob/master/CODE_OF_CONDUCT.md).
