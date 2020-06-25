DO
$do$
    BEGIN
        IF NOT EXISTS (
                SELECT FROM pg_catalog.pg_roles  -- SELECT list can be empty for this
                WHERE  rolname = '{{PG_USERNAME}}') THEN

            CREATE ROLE "{{PG_USERNAME}}" LOGIN PASSWORD '{{PG_PASSWORD}}';
        END IF;
    END
$do$;

BEGIN;
GRANT ALL PRIVILEGES ON DATABASE {{PG_DBNAME}} TO {{PG_USERNAME}};

CREATE SCHEMA IF NOT EXISTS admin;

-- ----------------------------
-- Table structure for users
-- ----------------------------
DROP TABLE IF EXISTS "admin"."users";
CREATE TABLE "admin"."users" (
  "id" uuid NOT NULL,
  "email" varchar(160) COLLATE "pg_catalog"."default" NOT NULL,
  "password_hash" varchar(128) COLLATE "pg_catalog"."default" NOT NULL,
  "password_hash_algo" varchar(16) COLLATE "pg_catalog"."default" NOT NULL,
  "first_name" varchar(64) COLLATE "pg_catalog"."tr-TR-x-icu" NOT NULL,
  "last_name" varchar(64) COLLATE "pg_catalog"."tr-TR-x-icu" NOT NULL,
  "is_active" int2 NOT NULL DEFAULT 1,
  "is_deleted" int2 NOT NULL DEFAULT 0,
  "created_at" timestamptz(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "role" varchar(32) COLLATE "pg_catalog"."default" NOT NULL DEFAULT 'USER'::character varying
)
;
ALTER TABLE "admin"."users" OWNER TO "{{PG_USERNAME}}";

-- ----------------------------
-- Records of users
-- ----------------------------

INSERT INTO "admin"."users" VALUES ('69204e72-521c-4bea-bcc5-29afe3f2f25f', '{{ADMIN_USER_EMAIL}}', '{{ADMIN_PASSWORD_HASHED}}', 'argon2id', 'Admin', 'User', 1, 0, '2020-05-06 02:04:50.888721+00', 'admin');



-- ----------------------------
-- Indexes structure for table users
-- ----------------------------
CREATE INDEX "admin_users_idx" ON "admin"."users" USING btree (
  "email" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST,
  "password_hash_algo" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST,
  "is_active" "pg_catalog"."int2_ops" ASC NULLS LAST,
  "is_deleted" "pg_catalog"."int2_ops" ASC NULLS LAST,
  "created_at" "pg_catalog"."timestamptz_ops" ASC NULLS LAST,
  "role" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);
CREATE UNIQUE INDEX "admin_users_unq_email" ON "admin"."users" USING btree (
  "email" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);

-- ----------------------------
-- Primary Key structure for table users
-- ----------------------------
ALTER TABLE "admin"."users" ADD CONSTRAINT "users_pkey" PRIMARY KEY ("id");




-- ----------------------------
-- Table structure for command_logs
-- ----------------------------
DROP TABLE IF EXISTS "admin"."command_logs";
CREATE TABLE "admin"."command_logs" (
  "id" uuid NOT NULL,
  "user_id" uuid,
  "source" varchar(32) COLLATE "pg_catalog"."default" NOT NULL DEFAULT 'private-api'::character varying,
  "api_version" varchar(64) COLLATE "pg_catalog"."default" NOT NULL,
  "request" jsonb NOT NULL,
  "response" jsonb NOT NULL,
  "logged_at" timestamptz(6) NOT NULL DEFAULT CURRENT_TIMESTAMP
)
;
ALTER TABLE "admin"."command_logs" OWNER TO "{{PG_USERNAME}}";


-- ----------------------------
-- Indexes structure for table command_logs
-- ----------------------------
CREATE INDEX "command_log_idx" ON "admin"."command_logs" USING btree (
  "user_id" "pg_catalog"."uuid_ops" ASC NULLS LAST,
  "source" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST,
  "api_version" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST,
  (request -> 'method'::text) "pg_catalog"."jsonb_ops" ASC NULLS LAST,
  (request -> 'endpoint'::text) "pg_catalog"."jsonb_ops" ASC NULLS LAST,
  (response -> 'status'::text) "pg_catalog"."jsonb_ops" ASC NULLS LAST,
  "logged_at" "pg_catalog"."timestamptz_ops" ASC NULLS LAST
);

-- ----------------------------
-- Primary Key structure for table command_logs
-- ----------------------------
ALTER TABLE "admin"."command_logs" ADD CONSTRAINT "command_logs_pkey" PRIMARY KEY ("id");


-- ----------------------------
-- Table structure for permissions
-- ----------------------------
DROP TABLE IF EXISTS "admin"."permissions";
CREATE TABLE "admin"."permissions" (
  "id" uuid NOT NULL,
  "type" varchar(64) COLLATE "pg_catalog"."default" NOT NULL,
  "name" varchar(128) COLLATE "pg_catalog"."tr-TR-x-icu" NOT NULL,
  "key" varchar(64) COLLATE "pg_catalog"."default" NOT NULL,
  "created_at" timestamptz(6) NOT NULL
)
;
ALTER TABLE "admin"."permissions" OWNER TO "{{PG_USERNAME}}";

-- ----------------------------
-- Records of permissions
-- ----------------------------

INSERT INTO "admin"."permissions" VALUES ('ffeea241-94d4-4b26-920d-704376399c5d', 'collections', 'Sayfa Erişimi', 'collections-menu', '2020-05-24 05:15:53+00');
INSERT INTO "admin"."permissions" VALUES ('c45e3e82-9f1c-40f5-b35c-3f4364a5d507', 'collections', 'Collection Bilgi Güncelleme', 'collections-edit', '2020-05-24 05:17:07+00');
INSERT INTO "admin"."permissions" VALUES ('508a71b5-233d-4f4a-99e8-f59c35318b70', 'collections', 'Collection Bilgi Ekleme', 'collections-create', '2020-05-24 05:18:45+00');
INSERT INTO "admin"."permissions" VALUES ('377f69fc-1639-4a12-8294-7ae79fc5d77b', 'users', 'Sayfa Erişimi', 'users-menu', '2020-05-24 05:33:26+00');
INSERT INTO "admin"."permissions" VALUES ('b32d2c62-8616-4f79-8873-5b57e0d73c4f', 'users', 'Kullanıcı bilgi Güncelleme', 'users-edit', '2020-05-24 05:33:52+00');
INSERT INTO "admin"."permissions" VALUES ('0f8e4a70-4a01-4808-8ed0-a50f335ff23e', 'users', 'Yeni Kullanıcı Tanımlama', 'user-create', '2020-05-24 05:34:23+00');
INSERT INTO "admin"."permissions" VALUES ('37128f19-c311-4a46-b7ed-5ab6126cb260', 'users', 'Yetki Seviyesi İzinlerini Değiştirme', 'user-permissions', '2020-05-24 05:34:55+00');
INSERT INTO "admin"."permissions" VALUES ('91c36946-9841-4adc-9c3a-ffaecd8de37e', 'cms', 'Sayfa Erişimi', 'cms-menu', '2020-05-26 09:45:35+00');
INSERT INTO "admin"."permissions" VALUES ('76ca9fa9-022b-45a3-9389-36f31cb0295b', 'cms', 'İçerik Oluşturma', 'cms-create', '2020-05-26 09:45:57+00');
INSERT INTO "admin"."permissions" VALUES ('2a9002ee-7a2c-4f53-a22d-632212b493ad', 'cms', 'İçerik Güncelleme', 'cms-edit', '2020-05-26 09:46:21+00');


-- ----------------------------
-- Table structure for roles
-- ----------------------------
DROP TABLE IF EXISTS "admin"."roles";
CREATE TABLE "admin"."roles" (
  "id" uuid NOT NULL,
  "title" varchar(64) COLLATE "pg_catalog"."tr-TR-x-icu" NOT NULL,
  "key" varchar(64) COLLATE "pg_catalog"."default" NOT NULL,
  "level" int2 NOT NULL DEFAULT 0,
  "permissions" jsonb NOT NULL DEFAULT '[]'::jsonb,
  "visible" int2 NOT NULL DEFAULT 1,
  "full_permission" int2 NOT NULL DEFAULT 1,
  "created_at" timestamptz(6) NOT NULL
)
;
ALTER TABLE "admin"."roles" OWNER TO "{{PG_USERNAME}}";

-- ----------------------------
-- Records of roles
-- ----------------------------

INSERT INTO "admin"."roles" VALUES ('905dc75a-22c2-47c8-9414-dcbdf3d405f6', 'Süper Admin', 'super-admin', 100, '[]', 0, 1, '2020-05-24 05:04:30+00');
INSERT INTO "admin"."roles" VALUES ('fe1caf55-1421-4b81-bccd-90e20918d902', 'Sistem Yöneticisi', 'admin', 90, '["collections-menu", "collections-edit", "collections-create", "users-menu", "users-edit", "user-create", "user-permissions", "cms-menu", "cms-create", "cms-edit"]', 1, 0, '2020-05-24 05:08:16+00');
INSERT INTO "admin"."roles" VALUES ('309111c1-e74a-4b62-b09a-8fb77684a188', 'İçerik Editörü', 'editor', 90, '[ "cms-menu", "cms-create", "cms-edit"]', 1, 0, '2020-05-24 05:08:16+00');



-- ----------------------------
-- Indexes structure for table permissions
-- ----------------------------
CREATE INDEX "permissions_idx" ON "admin"."permissions" USING btree (
  "type" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST,
  "key" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST,
  "created_at" "pg_catalog"."timestamptz_ops" ASC NULLS LAST
);

-- ----------------------------
-- Primary Key structure for table permissions
-- ----------------------------
ALTER TABLE "admin"."permissions" ADD CONSTRAINT "permissions_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Indexes structure for table roles
-- ----------------------------
CREATE INDEX "roles_idx" ON "admin"."roles" USING btree (
  "key" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST,
  "permissions" "pg_catalog"."jsonb_ops" ASC NULLS LAST,
  "visible" "pg_catalog"."int2_ops" ASC NULLS LAST,
  "level" "pg_catalog"."int2_ops" ASC NULLS LAST,
  "full_permission" "pg_catalog"."int2_ops" ASC NULLS LAST,
  "created_at" "pg_catalog"."timestamptz_ops" ASC NULLS LAST
);

-- ----------------------------
-- Primary Key structure for table roles
-- ----------------------------
ALTER TABLE "admin"."roles" ADD CONSTRAINT "roles_pkey" PRIMARY KEY ("id");



-- ----------------------------
-- Table structure for files
-- ----------------------------
DROP TABLE IF EXISTS "public"."files";
CREATE TABLE "public"."files" (
  "id" uuid NOT NULL,
  "file_path" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "uploaded_at" timestamptz(6) NOT NULL,
  "type" varchar(32) COLLATE "pg_catalog"."default" NOT NULL,
  "metadata" jsonb
)
;
ALTER TABLE "public"."files" OWNER TO "{{PG_USERNAME}}";

-- ----------------------------
-- Indexes structure for table files
-- ----------------------------
CREATE INDEX "files_idx" ON "public"."files" USING btree (
  "type" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST,
  "metadata" "pg_catalog"."jsonb_ops" ASC NULLS LAST,
  "uploaded_at" "pg_catalog"."timestamptz_ops" ASC NULLS LAST
);

-- ----------------------------
-- Primary Key structure for table files
-- ----------------------------
ALTER TABLE "public"."files" ADD CONSTRAINT "files_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Table structure for contents
-- ----------------------------
DROP TABLE IF EXISTS "public"."contents";
CREATE TABLE "public"."contents" (
  "id" uuid NOT NULL,
  "title" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "serp_title" varchar(255) COLLATE "pg_catalog"."default",
  "type" varchar(16) COLLATE "pg_catalog"."default" NOT NULL,
  "category" varchar(64) COLLATE "pg_catalog"."default" NOT NULL,
  "meta_description" varchar(255) COLLATE "pg_catalog"."default",
  "serp_meta_description" varchar(255) COLLATE "pg_catalog"."default",
  "keywords" varchar(255) COLLATE "pg_catalog"."default",
  "robots" varchar(255) COLLATE "pg_catalog"."default",
  "canonical" jsonb,
  "metadata" jsonb NOT NULL DEFAULT '{}'::jsonb,
  "redirect" varchar(255) COLLATE "pg_catalog"."default",
  "body" text COLLATE "pg_catalog"."default" NOT NULL,
  "images" jsonb NOT NULL DEFAULT '{}'::jsonb,
  "sort_order" varchar(26) COLLATE "pg_catalog"."default" NOT NULL,
  "is_active" int2 NOT NULL DEFAULT 0,
  "is_deleted" int2 NOT NULL DEFAULT 0,
  "created_at" timestamptz(6) NOT NULL,
  "created_by" uuid NOT NULL,
  "updated_at" timestamptz(6) NOT NULL,
  "updated_by" uuid NOT NULL
)
;
ALTER TABLE "public"."contents" OWNER TO "{{PG_USERNAME}}";


-- ----------------------------
-- Indexes structure for table contents
-- ----------------------------
CREATE INDEX "contents_idx" ON "public"."contents" USING btree (
  "type" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST,
  "category" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST,
  "sort_order" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST,
  "is_active" "pg_catalog"."int2_ops" ASC NULLS LAST,
  "is_deleted" "pg_catalog"."int2_ops" ASC NULLS LAST,
  "created_at" "pg_catalog"."timestamptz_ops" ASC NULLS LAST,
  "created_by" "pg_catalog"."uuid_ops" ASC NULLS LAST,
  "updated_at" "pg_catalog"."timestamptz_ops" ASC NULLS LAST,
  "updated_by" "pg_catalog"."uuid_ops" ASC NULLS LAST
);

-- ----------------------------
-- Primary Key structure for table contents
-- ----------------------------
ALTER TABLE "public"."contents" ADD CONSTRAINT "contents_pkey" PRIMARY KEY ("id");
-- ----------------------------
-- Table structure for lookup_table
-- ----------------------------
DROP TABLE IF EXISTS "public"."lookup_table";
CREATE TABLE "public"."lookup_table" (
  "id" uuid NOT NULL,
  "key" varchar COLLATE "pg_catalog"."default" NOT NULL,
  "name" varchar COLLATE "pg_catalog"."tr-TR-x-icu" NOT NULL,
  "slug" varchar COLLATE "pg_catalog"."default" NOT NULL,
  "parent_id" uuid,
  "metadata" jsonb,
  "is_active" int2 NOT NULL DEFAULT 1,
  "is_deleted" int2 NOT NULL DEFAULT 0
)
;
ALTER TABLE "public"."lookup_table" OWNER TO "{{PG_USERNAME}}";

INSERT INTO "public"."lookup_table" VALUES ('a86582b0-19db-4bdb-961d-559a405c85dc', 'lt:root', 'root', 'root', NULL, '{"v": "1.0.0"}', 1, 0);
INSERT INTO "public"."lookup_table" VALUES ('6af65ec6-42c9-47fe-a109-aa161957afaa', 'lt:cms:categories', 'Categories', 'categories', '80f8fc96-da5e-48c5-a56f-ac304468dca9', '{"v": "1.0.0"}', 1, 0);
INSERT INTO "public"."lookup_table" VALUES ('2d4e5b53-b796-4aca-8b5b-907b067532b8', 'lt:settings', 'Settings', 'settings', 'a86582b0-19db-4bdb-961d-559a405c85dc', '{"v": "1.0.0"}', 1, 0);
INSERT INTO "public"."lookup_table" VALUES ('80f8fc96-da5e-48c5-a56f-ac304468dca9', 'lt:cms', 'CMS', 'cms', 'a86582b0-19db-4bdb-961d-559a405c85dc', '{"v": "1.0.0"}', 1, 0);
INSERT INTO "public"."lookup_table" VALUES ('c7bc13af-5b61-48ee-8fdc-dc6a42b2107c', 'lt:cms:home', 'Ana Sayfa', 'ana-sayfa', '6af65ec6-42c9-47fe-a109-aa161957afaa', '{"v": "1.0.0", "contentType": "image-key-value"}', 1, 0);
INSERT INTO "public"."lookup_table" VALUES ('352ad301-2452-4beb-b7ba-a78ccbdfdf8c', 'lt:cms:blog', 'Blog', 'blog', '6af65ec6-42c9-47fe-a109-aa161957afaa', '{"v": "1.0.0", "contentType": "full"}', 1, 0);
INSERT INTO "public"."lookup_table" VALUES ('9f15382c-76ee-4b5d-b07f-90c12567a88c', 'lt:cms:legals', 'Hukuki Metinler', 'hukuki-metinler', '6af65ec6-42c9-47fe-a109-aa161957afaa', '{"v": "1.0.0", "contentType": "simple"}', 1, 0);


-- ----------------------------
-- Indexes structure for table lookup_table
-- ----------------------------
CREATE INDEX "idx_public_lokup_table" ON "public"."lookup_table" USING btree (
  "key" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST,
  "slug" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST,
  "parent_id" "pg_catalog"."uuid_ops" ASC NULLS LAST,
  "is_active" "pg_catalog"."int2_ops" ASC NULLS LAST,
  "is_deleted" "pg_catalog"."int2_ops" ASC NULLS LAST,
  "metadata" "pg_catalog"."jsonb_ops" ASC NULLS LAST
);
CREATE UNIQUE INDEX "idx_public_lookup_table_unq_key" ON "public"."lookup_table" USING btree (
  "key" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);
CREATE UNIQUE INDEX "idx_public_unq_parent_slug" ON "public"."lookup_table" USING btree (
  "parent_id" "pg_catalog"."uuid_ops" ASC NULLS LAST,
  "slug" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);

-- ----------------------------
-- Primary Key structure for table lookup_table
-- ----------------------------
ALTER TABLE "public"."lookup_table" ADD CONSTRAINT "lookup_table_pkey" PRIMARY KEY ("id");
GRANT ALL PRIVILEGES ON SCHEMA admin, public TO {{PG_USERNAME}};

COMMIT;