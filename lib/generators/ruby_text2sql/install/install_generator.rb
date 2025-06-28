# frozen_string_literal: true

require "rails/generators"

module RubyText2sql
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path("templates", __dir__)

      desc "Creates a Ruby::Text2sql initializer in your application."

      def copy_initializer
        template "initializer.rb", "config/initializers/ruby_text2sql.rb"
      end
    end
  end
end
