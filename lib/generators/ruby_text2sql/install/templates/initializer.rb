# frozen_string_literal: true

# config/initializers/ruby_text2sql.rb
# This initializer configures which SQL actions are allowed by the ruby-text2sql gem.
# Only the actions listed here (as symbols) will be permitted for execution.

Ruby::Text2sql.configure do |config|
  # Allow only SELECT queries by default (safest)
  config.allowed_actions = [:select]

  # Example: Allow SELECT, INSERT, and UPDATE queries
  # config.allowed_actions = [:select, :insert, :update]

  # Example: To allow DELETE queries (use with caution)
  # config.allowed_actions = [:select, :insert, :update, :delete]
end
