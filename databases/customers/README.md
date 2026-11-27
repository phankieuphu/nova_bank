# Customers database

[customers.sql](./customers.sql) creates the `customers` schema and loads development seed data in a single transaction.

## Setup

Use PostgreSQL 18 or later. The script uses `uuidv7()` for the public identifier default. Run it from the repository root against an existing development database where the `customers` schema is absent. The connecting role needs permission to create schemas in that database and will own the created objects.

```sh
psql --set=ON_ERROR_STOP=1 --dbname=nova_bank --file=databases/customers/customers.sql
```

Replace `nova_bank` with your database name if it differs.

## Tables

| Table | Purpose |
| --- | --- |
| `customer` | Customer name, status, timestamps, and unique public UUID |
| `customer_information` | Optional contact profile with one row per customer |
| `customer_address` | Mailing addresses with multiple rows per customer |
| `auth_identity` | Maps a verified identity provider's issuer and subject to a customer |
| `permission` | Named application actions |
| `permission_group` | Named collections of permissions |
| `permission_group_permission` | Permissions included in each group |
| `customer_permission_group` | Group memberships assigned to customers |

After verifying an identity with the provider, the application resolves the customer by issuer and subject, checks the customer's status, and reads permissions through group membership. Programs use `customer.public_id` to identify the author.

## Development seed

The script creates one active customer named `Development Customer`. Its public UUID matches the author UUID used by the programs development seed. Each module can be loaded independently.

The `program_author` group includes `programs.write`. Customers receive that permission when the application assigns them to the group.
