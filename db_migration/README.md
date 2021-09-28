# HTTP Router

DB migration

## Inspired by

* [Hanami::Model](https://github.com/hanami/model)

## Example

* Setup db configuration


```rb
Model.configure do |config|
  config.xxx = xxxx
end
```

* Create database

```rb
Model::Migrator.new.create
```

* Drop database

```rb
Model::Migrator.new.drop
```

* Migrate db schema

```rb
# Store migration file under `db/migrations`.
Model.migration do
  change do
    create_table :books do
      primary_key :id
      column :title,      String
      column :created_at, DateTime
      column :updated_at, DateTime
    end
  end
end

# run migration
Model::Migrator.migrate

# rollback migration
Model::Migrator.rollback
```
