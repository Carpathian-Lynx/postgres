 CREATE TABLE users.users (
          id bigint NOT NULL GENERATED BY DEFAULT AS IDENTITY,
          first_name text NULL,
          last_name text NULL,
          CONSTRAINT pk_users PRIMARY KEY (id)
      );