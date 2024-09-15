# frozen_string_literal: true

require_relative "lib/ruby/text2sql/version"

Gem::Specification.new do |spec|
  spec.name = "ruby-text2sql"
  spec.version = Ruby::Text2sql::VERSION
  spec.authors = ["Nicolas Fabre"]
  spec.email = ["nicofh93@gmail.com"]

  spec.summary = "A Ruby gem to convert natural language to SQL queries using LLMs."
  spec.description = "Text2SQL is a gem designed to generate SQL queries from natural language inputs. It leverages machine learning models to interpret schema files and user inputs, generating SQL queries that can be executed and returning results in a human-readable format."
  spec.homepage = "https://github.com/nicofh/ruby-text2sql"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.6.0"

  spec.metadata["allowed_push_host"] = "TODO: Set to your gem server 'https://example.com'"

  spec.metadata["homepage_uri"] = "https://github.com/nicofh/ruby-text2sql"
  spec.metadata["source_code_uri"] = "https://github.com/nicofh/ruby-text2sql"
  spec.metadata["changelog_uri"] = "https://github.com/nicofh/ruby-text2sql/blob/main/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .github appveyor Gemfile])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
