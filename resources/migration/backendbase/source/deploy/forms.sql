BEGIN;
CREATE TABLE "public"."forms" (
  "id" uuid NOT NULL,
  "name" varchar(255) NOT NULL,
  "created_by" uuid  NOT NULL,
  "created_at" timestamptz NOT NULL,
  "metadata" jsonb NOT NULL,
  "options" jsonb NOT NULL,
  "is_active" int2 NOT NULL,
  PRIMARY KEY ("id")
);

CREATE INDEX "forms_idx" ON "public"."forms" (
  "created_at",
  "created_by",
  "created_by",
  "metadata",
  "options",
  "is_active"
);

INSERT INTO "public"."forms" VALUES ('99800ea7-6faa-46d7-bc33-d73a6d538171', 'Contact Form', '69204e72-521c-4bea-bcc5-29afe3f2f25f','2020-06-15 08:15:29+00',  '{"titles":[{"key":"fullName","value":"Full Name"},{"key":"email","value":"E-mail Address"},{"key":"subject","value":"Subject"},{"key":"message","value":"Message"},{"key":"confirmation","value":"Legals Confirmation"}],"secondRow":["message","confirmation"]}',  '{"email": true, "emailAddresses": ["mehmet@efabrika.com"]}',  1);

CREATE TABLE "public"."form_data" (
  "id" uuid NOT NULL,
  "form_id" uuid NOT NULL,
  "post_data" jsonb NOT NULL,
  "client_ip" varchar(128) NOT NULL,
  "created_at" timestamptz NOT NULL,
  "is_moderated" int2 NOT NULL,
  PRIMARY KEY ("id")
);

CREATE INDEX "form_data_idx" ON "public"."form_data" (
  "form_id",
  "created_at",
  "is_moderated",
  "client_ip",
  "post_data"
);

GRANT ALL PRIVILEGES ON TABLE public.forms TO {{PG_USERNAME}};
GRANT ALL PRIVILEGES ON TABLE public.form_data TO {{PG_USERNAME}};
COMMIT;

