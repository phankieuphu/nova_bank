-- Customers schema and development seed data (PostgreSQL 18).
BEGIN;

CREATE SCHEMA customers;

CREATE SEQUENCE customers.customer_id_seq AS integer;
CREATE SEQUENCE customers.customer_address_id_seq AS integer;
CREATE SEQUENCE customers.auth_identity_id_seq AS integer;
CREATE SEQUENCE customers.permission_id_seq AS integer;
CREATE SEQUENCE customers.permission_group_id_seq AS integer;

CREATE TABLE customers.customer (
    id integer DEFAULT nextval('customers.customer_id_seq'::regclass) NOT NULL,
    public_id uuid DEFAULT uuidv7() NOT NULL,
    name text NOT NULL,
    status character varying(55),
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    CONSTRAINT customer_pkey PRIMARY KEY (id),
    CONSTRAINT customer_public_id_key UNIQUE (public_id)
);

CREATE TABLE customers.customer_information (
    customer_id integer NOT NULL,
    email text,
    phone_number text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT customer_information_pkey PRIMARY KEY (customer_id),
    CONSTRAINT customer_information_customer_id_fkey FOREIGN KEY (customer_id)
        REFERENCES customers.customer(id)
);

CREATE TABLE customers.customer_address (
    id integer DEFAULT nextval('customers.customer_address_id_seq'::regclass) NOT NULL,
    customer_id integer NOT NULL,
    address_line_1 text NOT NULL,
    address_line_2 text,
    locality text,
    region text,
    postal_code text,
    country_code varchar(2) NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT customer_address_pkey PRIMARY KEY (id),
    CONSTRAINT customer_address_customer_id_fkey FOREIGN KEY (customer_id)
        REFERENCES customers.customer(id)
);

CREATE TABLE customers.auth_identity (
    id integer DEFAULT nextval('customers.auth_identity_id_seq'::regclass) NOT NULL,
    customer_id integer NOT NULL,
    issuer text NOT NULL,
    subject text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT auth_identity_pkey PRIMARY KEY (id),
    CONSTRAINT auth_identity_issuer_subject_key UNIQUE (issuer, subject),
    CONSTRAINT auth_identity_customer_id_fkey FOREIGN KEY (customer_id)
        REFERENCES customers.customer(id)
);

CREATE TABLE customers.permission (
    id integer DEFAULT nextval('customers.permission_id_seq'::regclass) NOT NULL,
    code text NOT NULL,
    description text,
    CONSTRAINT permission_pkey PRIMARY KEY (id),
    CONSTRAINT permission_code_key UNIQUE (code)
);

CREATE TABLE customers.permission_group (
    id integer DEFAULT nextval('customers.permission_group_id_seq'::regclass) NOT NULL,
    code text NOT NULL,
    description text,
    CONSTRAINT permission_group_pkey PRIMARY KEY (id),
    CONSTRAINT permission_group_code_key UNIQUE (code)
);

CREATE TABLE customers.permission_group_permission (
    permission_group_id integer NOT NULL,
    permission_id integer NOT NULL,
    CONSTRAINT permission_group_permission_pkey PRIMARY KEY (permission_group_id, permission_id),
    CONSTRAINT permission_group_permission_group_id_fkey FOREIGN KEY (permission_group_id)
        REFERENCES customers.permission_group(id),
    CONSTRAINT permission_group_permission_permission_id_fkey FOREIGN KEY (permission_id)
        REFERENCES customers.permission(id)
);

CREATE TABLE customers.customer_permission_group (
    customer_id integer NOT NULL,
    permission_group_id integer NOT NULL,
    CONSTRAINT customer_permission_group_pkey PRIMARY KEY (customer_id, permission_group_id),
    CONSTRAINT customer_permission_group_customer_id_fkey FOREIGN KEY (customer_id)
        REFERENCES customers.customer(id),
    CONSTRAINT customer_permission_group_group_id_fkey FOREIGN KEY (permission_group_id)
        REFERENCES customers.permission_group(id)
);

ALTER SEQUENCE customers.customer_id_seq OWNED BY customers.customer.id;
ALTER SEQUENCE customers.customer_address_id_seq OWNED BY customers.customer_address.id;
ALTER SEQUENCE customers.auth_identity_id_seq OWNED BY customers.auth_identity.id;
ALTER SEQUENCE customers.permission_id_seq OWNED BY customers.permission.id;
ALTER SEQUENCE customers.permission_group_id_seq OWNED BY customers.permission_group.id;

-- Match the author UUID used by the programs development seed.
INSERT INTO customers.customer (
    public_id, name, status
) VALUES (
    '43667915-74bd-4a77-86b9-84982700c2aa',
    'Development Customer',
    'ACTIVE'
);

INSERT INTO customers.permission (code, description)
VALUES ('programs.write', 'Create and update programs');

INSERT INTO customers.permission_group (code, description)
VALUES ('program_author', 'Authors who can create and update programs');

INSERT INTO customers.permission_group_permission (permission_group_id, permission_id)
SELECT permission_group.id, permission.id
FROM customers.permission_group
CROSS JOIN customers.permission
WHERE permission_group.code = 'program_author'
    AND permission.code = 'programs.write';

COMMIT;
