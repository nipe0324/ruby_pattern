require 'pathname'

module Model
  class Migrator
    # SQLite3 Migrator
    class SQLiteAdapter < Adapter
      # No-op for in-memory databases
      module Memory
        def create
        end

        def drop
        end
      end

      def initialize(configuration)
        super
        extend Memory if memory?
      end

      def create
        path.dirname.mkpath
        FileUtils.touch(path)
      rescue Errno::EACCES, Errno::EPERM
        raise MigrationError.new("Permission denied: #{path.sub(/\A\/\//, '')}")
      end

      def drop
        path.delete
      rescue Errno::ENOENT
        raise MigrationError.new("Cannot find database: #{path.sub(/\A\/\//, '')}")
      end

      private

      def memory?
        uri = path.to_s
        uri.match(/sqlite\:\/\z/) ||
          uri.match(/\:memory\:/)
      end

      def path
        db_root.join(
          @connection.uri.sub(/\A(jdbc:sqlite:\/\/|sqlite:\/\/)/, "")
        )
      end

      def db_root
        Pathname.pwd.join("tmp", "db")
      end
    end
  end
end
