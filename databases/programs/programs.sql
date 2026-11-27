-- Programs schema and development seed data (PostgreSQL 18).
BEGIN;

CREATE SCHEMA programs;

CREATE SEQUENCE programs.configurations_group_id_seq AS integer;
CREATE SEQUENCE programs.configurations_id_seq AS integer;
CREATE SEQUENCE programs.group_configuration_programs_id_seq AS integer;
CREATE SEQUENCE programs.groups_id_seq AS integer;
CREATE SEQUENCE programs.groups_name_seq AS integer;
CREATE SEQUENCE programs.information_id_seq AS integer;
CREATE SEQUENCE programs.program_id_seq AS integer;
CREATE SEQUENCE programs.program_information_id_seq AS integer;

CREATE TABLE programs.information (
    id integer DEFAULT nextval('programs.information_id_seq'::regclass) NOT NULL,
    public_id uuid DEFAULT uuidv7(),
    name text NOT NULL,
    description text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT information_pkey PRIMARY KEY (id)
);

CREATE TABLE programs.program (
    id integer DEFAULT nextval('programs.program_id_seq'::regclass) NOT NULL,
    information_id integer DEFAULT nextval('programs.program_information_id_seq'::regclass) NOT NULL,
    author uuid DEFAULT uuidv7(),
    status character varying(55),
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    CONSTRAINT program_pkey PRIMARY KEY (id),
    CONSTRAINT program_information_id_fkey FOREIGN KEY (information_id)
        REFERENCES programs.information(id)
);

CREATE TABLE programs.group_configuration (
    id integer DEFAULT nextval('programs.groups_id_seq'::regclass) CONSTRAINT groups_id_not_null NOT NULL,
    name text DEFAULT nextval('programs.groups_name_seq'::regclass) CONSTRAINT groups_name_not_null NOT NULL,
    author_id uuid CONSTRAINT groups_author_id_not_null NOT NULL,
    created_at timestamp with time zone DEFAULT now() CONSTRAINT groups_created_at_not_null NOT NULL,
    updated_at timestamp with time zone DEFAULT now() CONSTRAINT groups_updated_at_not_null NOT NULL,
    deleted_at timestamp with time zone,
    programs_id integer DEFAULT nextval('programs.group_configuration_programs_id_seq'::regclass) NOT NULL,
    CONSTRAINT groups_pkey PRIMARY KEY (id),
    CONSTRAINT group_configuration_programs_id_fkey FOREIGN KEY (programs_id)
        REFERENCES programs.program(id)
);

CREATE TABLE programs.configurations (
    id integer DEFAULT nextval('programs.configurations_id_seq'::regclass) NOT NULL,
    group_id integer DEFAULT nextval('programs.configurations_group_id_seq'::regclass) NOT NULL,
    key character varying(55),
    value character varying(55),
    validate_data_type character varying(55),
    status character varying(55),
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT configurations_pkey PRIMARY KEY (id),
    CONSTRAINT configurations_group_id_fkey FOREIGN KEY (group_id)
        REFERENCES programs.group_configuration(id)
);

ALTER SEQUENCE programs.configurations_group_id_seq OWNED BY programs.configurations.group_id;
ALTER SEQUENCE programs.configurations_id_seq OWNED BY programs.configurations.id;
ALTER SEQUENCE programs.group_configuration_programs_id_seq OWNED BY programs.group_configuration.programs_id;
ALTER SEQUENCE programs.groups_id_seq OWNED BY programs.group_configuration.id;
ALTER SEQUENCE programs.groups_name_seq OWNED BY programs.group_configuration.name;
ALTER SEQUENCE programs.information_id_seq OWNED BY programs.information.id;
ALTER SEQUENCE programs.program_id_seq OWNED BY programs.program.id;
ALTER SEQUENCE programs.program_information_id_seq OWNED BY programs.program.information_id;

-- Development seed data
INSERT INTO programs.information (
    id, public_id, name, description, created_at, updated_at
) VALUES (
    1,
    '9ecfa25d-bace-44af-99a0-398eae66e236',
    'Develop',
    'This program use for development',
    '2026-11-27 13:47:03.111837+07',
    '2026-11-27 13:47:03.111837+07'
);

INSERT INTO programs.program (
    id, information_id, author, status, created_at, updated_at, deleted_at
) VALUES (
    1,
    1,
    '43667915-74bd-4a77-86b9-84982700c2aa',
    'ACTIVE',
    '2026-11-27 14:00:06.630311+07',
    '2026-11-27 14:00:06.630311+07',
    NULL
);

INSERT INTO programs.group_configuration (
    id, name, author_id, created_at, updated_at, deleted_at, programs_id
) VALUES (
    1,
    'day_past_due',
    '43667915-74bd-4a77-86b9-84982700c2aa',
    '2026-11-27 14:43:42.084679+07',
    '2026-11-27 14:43:42.084679+07',
    NULL,
    1
);

INSERT INTO programs.configurations (
    id, group_id, key, value, validate_data_type, status, created_at, updated_at
) VALUES (
    1,
    1,
    'day_past_due',
    '30',
    'number',
    'ACTIVE',
    '2026-11-27 14:49:17.132474+07',
    '2026-11-27 14:49:17.132474+07'
);

-- Preserve sequence positions from the seed data dump.
SELECT pg_catalog.setval('programs.configurations_group_id_seq', 1, false);
SELECT pg_catalog.setval('programs.configurations_id_seq', 33, true);
SELECT pg_catalog.setval('programs.group_configuration_programs_id_seq', 1, false);
SELECT pg_catalog.setval('programs.groups_id_seq', 1, true);
SELECT pg_catalog.setval('programs.groups_name_seq', 1, false);
SELECT pg_catalog.setval('programs.information_id_seq', 1, true);
SELECT pg_catalog.setval('programs.program_id_seq', 1, true);
SELECT pg_catalog.setval('programs.program_information_id_seq', 1, false);

COMMIT;
