module Model
  class Migrator
    # Sequel connection wrapper
    class Connection
      def initialize(configuration)
        @configuration = configuration
      end

      def raw
        @raw ||= begin
                  Sequel.connect(
                    @configuration.url,
                    loggers: [@configuration.migrations_logger]
                  )
                rescue Sequel::AdapterNotFound
                  raise MigrationError.new("Current adapter (#{database_type}) doesn't support SQL database operations.")
                end
      end

      def database_type
        case uri
        when /sqlite/
          :sqlite
        when /mysql/
          :mysql
        end
      end

      def uri
        @configuration.url
      end
    end
  end
end
