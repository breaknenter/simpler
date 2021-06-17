# frozen_string_literal: true

# Tasks list:
# $ rake -T
#
# Run task:
# $ rake taskname
# or
# $ rake namespace:taskname

require 'yaml'
require 'logger'
require 'sqlite3'
require 'sequel'

namespace :db do
  desc 'connect to db'
  task :connect do
    config = YAML::load_file(File.join(__dir__, 'config/database.yml'))
    @db    = Sequel.connect(config)
  end

  desc 'show db tables'
  task :show => :connect do
     puts @db.tables
  end

  desc 'fill db'
  task :fill => :connect do
    @db.create_table? :tests do
      primary_key :id
      String      :title, null:    false
      Integer     :level, default: 0
    end
  end

  desc 'clear db'
  task :clear => :connect do
    @db.drop_table? :tests
  end
end
