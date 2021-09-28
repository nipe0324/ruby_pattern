require "uri"
require "shellwords"
require "open3"

module Model
  class Migrator
    # Migrator base adapter
    class Adapter
      MIGRATIONS_TABLE = :schema_migrations
      MIGRATIONS_TABLE_VERSION_COLUMN = :filename
      MIGRATIONS_FILE_NAME_PATTERN = /\A[\d]{14}/.freeze

      # Loads and returns a specific adapter for the given connection.
      def self.for(configuration)
        connection = Connection.new(configuration)

        case connection.database_type
        when :sqlite
          require_relative "sqlite_adapter"
          SQLiteAdapter
        when :mysql
          require_relative "mysql_adapter"
        else
          self
        end.new(connection)
      end

      def initialize(connection)
        @connection = connection
      end

      def create
        raise MigrationError.new("Current adapter (#{connection.database_type}) doesn't support create.")
      end

      def drop
        raise MigrationError.new("Current adapter (#{connection.database_type}) doesn't support drop.")
      end

      def migrate(migrations, version)
        version = Integer(version) unless version.nil?

        Sequel::Migrator.run(connection.raw, migrations, target: version, allow_missing_migration_files: true)
      rescue Sequel::Migrator::Error => exception
        raise MigrationError.new(exception.message)
      end

      def rollback(migrations, steps)
        table = migrations_table_dataset
        version = version_to_rollback(table, steps)

        Sequel::Migrator.run(connection.raw, migrations, target: version, allow_missing_migration_files: true)
      rescue Sequel::Migrator::Error => exception
        raise MigrationError.new(exception.message)
      end

      private

      attr_reader :connection

      def version_to_rollback(table, steps)
        record = table.order(Sequel.desc(MIGRATIONS_TABLE_VERSION_COLUMN).all[steps])
        return 0 unless record

        record.fetch(MIGRATIONS_TABLE_VERSION_COLUMN).scan(MIGRATIONS_FILE_NAME_PATTERN).first.to_i
      end

      def migrations_table_dataset
        connection.table(MIGRATIONS_TABLE)
      end
    end
  end
end
