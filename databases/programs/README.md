# Programs database

[programs.sql](./programs.sql) creates the `programs` schema and loads development seed data in a single transaction.

## Setup

Use PostgreSQL 18 or later. The script uses `uuidv7()` for UUID defaults. Run it from the repository root against an existing development database where the `programs` schema is absent. The connecting role needs permission to create schemas in that database and will own the created objects.

```sh
psql --set=ON_ERROR_STOP=1 --dbname=nova_bank --file=databases/programs/programs.sql
```

Replace `nova_bank` with your database name if it differs.

## Tables

All four tables are in the `programs` schema.

| Table | Purpose | Foreign key |
| --- | --- | --- |
| `information` | Program name, description, and public UUID | |
| `program` | Program record with author, status, and timestamps | `information_id` → `information.id` |
| `group_configuration` | Named group of settings for a program | `programs_id` → `program.id` |
| `configurations` | Settings stored as key-value pairs with validation type and status | `group_id` → `group_configuration.id` |

## Development seed

The script creates an active program named `Develop` with a `day_past_due` configuration group. The group contains one active `day_past_due` setting with the stored value `'30'` and validation type `number`.
