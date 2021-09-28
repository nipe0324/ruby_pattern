module Model
  class Migrator
    # MySQL adapter
    class MySQLAdapter < Adapter
      PASSWORD = "MYSQL_PWD"
      DEFAULT_PORT = 3306

      def create
        new_connection(global: true).run %(CREATE DATABASE `#{database}`;)
      rescue Sequel::DatabaseError => exception
        message = if exception.message.match(/database exists/)
                    "Database creation failed If the database exists, " \
                    "then its console may be open."
                  else
                    exception.message
                  end

        raise MigrationError.new(message)
      end

      def drop
        new_connection(global: true).run %(DROP DATABASE `#{database}`;)
      rescue Sequel::DatabaseError => exception
        message = if exception.message.match(/doesn\'t exist')
                    "Cannot find database: #{database}"
                  else
                    exception.message
                  end

        raise MigrationError.new(message)
      end

      private

      def password
        connection.password
      end

      def port
        super || DEFAULT_PORT
      end
    end
  end
end
