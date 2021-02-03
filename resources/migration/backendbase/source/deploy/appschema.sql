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
-- Records of command_logs
-- ----------------------------
BEGIN;
COMMIT;

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
BEGIN;
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
INSERT INTO "admin"."permissions" VALUES ('a56018b4-bcb6-44d6-b000-e46b8be338a8', 'forms', 'Sayfa Erişimi', 'forms-menu', '2021-02-01 17:24:53+00');
COMMIT;

-- ----------------------------
-- Table structure for permissions_types
-- ----------------------------
DROP TABLE IF EXISTS "admin"."permissions_types";
CREATE TABLE "admin"."permissions_types" (
                                             "id" uuid NOT NULL,
                                             "name" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
                                             "slug" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
                                             "is_active" int2 NOT NULL DEFAULT 1,
                                             "is_protected" int2 NOT NULL DEFAULT 0,
                                             "created_at" timestamptz(6) NOT NULL DEFAULT CURRENT_TIMESTAMP
)
;
ALTER TABLE "admin"."permissions_types" OWNER TO "{{PG_USERNAME}}";

-- ----------------------------
-- Records of permissions_types
-- ----------------------------
BEGIN;
INSERT INTO "admin"."permissions_types" VALUES ('2b34000b-dc96-440a-b924-5fd2218eaf1b', 'Collections', 'collections', 1, 1, '2017-11-06 23:47:00+00');
INSERT INTO "admin"."permissions_types" VALUES ('9a63e5b7-c1c0-4ad6-b3c3-c7ce9fdba879', 'CMS', 'cms', 1, 1, '2017-11-06 23:47:01+00');
INSERT INTO "admin"."permissions_types" VALUES ('800a8903-ab58-47e3-9747-a9c87728fc0f', 'Users', 'users', 1, 1, '2017-11-06 23:47:02+00');
INSERT INTO "admin"."permissions_types" VALUES ('5a4791df-7048-4b83-90bc-25a53abc5a11', 'Forms', 'forms', 1, 0, '2017-11-06 23:47:03+00');
COMMIT;

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
BEGIN;
INSERT INTO "admin"."roles" VALUES ('905dc75a-22c2-47c8-9414-dcbdf3d405f6', 'Super Admin', 'super-admin', 100, '[]', 0, 1, '2020-05-24 05:04:30+00');
INSERT INTO "admin"."roles" VALUES ('309111c1-e74a-4b62-b09a-8fb77684a188', 'Content Manager', 'editor', 90, '["cms-menu", "cms-create", "cms-edit"]', 1, 0, '2020-05-24 05:08:16+00');
INSERT INTO "admin"."roles" VALUES ('fe1caf55-1421-4b81-bccd-90e20918d902', 'System Admin', 'admin', 90, '["collections-menu", "collections-edit", "collections-create", "users-menu", "users-edit", "user-create", "user-permissions", "cms-menu", "cms-create", "cms-edit", "demo-module-menu", "forms-menu"]', 1, 0, '2020-05-24 05:08:16+00');
COMMIT;

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
BEGIN;
INSERT INTO "admin"."users" VALUES ('69204e72-521c-4bea-bcc5-29afe3f2f25f', '{{ADMIN_USER_EMAIL}}', '{{ADMIN_PASSWORD_HASHED}}', 'argon2id', 'Admin', 'User', 1, 0, '2020-05-06 02:04:50.888721+00', 'admin');
COMMIT;

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
-- Indexes structure for table permissions_types
-- ----------------------------
CREATE INDEX "permission_types_idx" ON "admin"."permissions_types" USING btree (
                                                                                "slug" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST,
                                                                                "is_active" "pg_catalog"."int2_ops" ASC NULLS LAST,
                                                                                "created_at" "pg_catalog"."timestamptz_ops" ASC NULLS LAST,
                                                                                "is_protected" "pg_catalog"."int2_ops" ASC NULLS LAST
    );

-- ----------------------------
-- Primary Key structure for table permissions_types
-- ----------------------------
ALTER TABLE "admin"."permissions_types" ADD CONSTRAINT "permission_types_pkey" PRIMARY KEY ("id");

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
-- Table structure for content_details
-- ----------------------------
DROP TABLE IF EXISTS "public"."content_details";
CREATE TABLE "public"."content_details" (
                                            "id" uuid NOT NULL,
                                            "content_id" uuid NOT NULL,
                                            "language" varchar(3) COLLATE "pg_catalog"."default" NOT NULL,
                                            "region" varchar(3) COLLATE "pg_catalog"."default" NOT NULL,
                                            "title" varchar(512) COLLATE "pg_catalog"."default" NOT NULL,
                                            "slug" varchar(512) COLLATE "pg_catalog"."default" NOT NULL,
                                            "body" jsonb NOT NULL,
                                            "body_fulltext" text COLLATE "pg_catalog"."default" NOT NULL,
                                            "is_active" int2 NOT NULL DEFAULT 1,
                                            "serp_title" varchar(512) COLLATE "pg_catalog"."default" NOT NULL,
                                            "description" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
                                            "keywords" varchar(255) COLLATE "pg_catalog"."default" NOT NULL
)
;
ALTER TABLE "public"."content_details" OWNER TO "{{PG_USERNAME}}";

-- ----------------------------
-- Records of content_details
-- ----------------------------
BEGIN;
INSERT INTO "public"."content_details" VALUES ('7b0fbac3-9836-4a95-a25b-7d6b90a56669', '3793c612-fd08-4e39-88bd-545b60914704', 'en', 'en', 'BackendBase Home', '/modules/home', '{"intro": "<h4>Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. </h4><h4>Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. EN</h4>", "title": "Neque porro quisquam est qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit...", "contentBody": "deneme"}', 'deneme Neque porro quisquam est qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit... Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. EN', 1, 'BackendBase', '', '');
INSERT INTO "public"."content_details" VALUES ('f3c69d35-9faf-40c8-9d63-b0791b132232', '3793c612-fd08-4e39-88bd-545b60914704', 'tr', 'tr', 'Ana Sayfa - BackendBase', '/modules/ana-sayfa', '{"intro": "<p>Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.</p><p>Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.</p>", "title": "Neque porro quisquam est qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit...", "contentBody": "deneme"}', 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Neque porro quisquam est qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit... deneme', 1, 'BackendBase', 'meta', 'keywords');
INSERT INTO "public"."content_details" VALUES ('fdaa12f3-1ea0-47e6-850f-d5e7ed25f83b', '4102698f-a6bc-46e3-a11a-d9805a4d2b48', 'tr', 'tr', 'Demo Modülü', '/modules/demo-modulu', '[]', '', 1, 'Demo Modülü', '', '');
INSERT INTO "public"."content_details" VALUES ('51bf3914-7c4d-4e85-a98e-52dfc694626d', '4102698f-a6bc-46e3-a11a-d9805a4d2b48', 'en', 'en', 'Demo Module', '/modules/demo-module', '{"intro": "", "header1": "", "summary": "", "heroImage": "", "contentBody": "<p>deneme</p>"}', 'deneme    ', 1, 'Demo Module', '', '');
COMMIT;

-- ----------------------------
-- Table structure for contents
-- ----------------------------
DROP TABLE IF EXISTS "public"."contents";
CREATE TABLE "public"."contents" (
                                     "id" uuid NOT NULL,
                                     "category" uuid NOT NULL,
                                     "tags" jsonb,
                                     "template" varchar(64) COLLATE "pg_catalog"."default" NOT NULL,
                                     "is_active" int2 NOT NULL DEFAULT 0,
                                     "is_deleted" int2 NOT NULL DEFAULT 0,
                                     "cover_image_landscape" varchar(255) COLLATE "pg_catalog"."default",
                                     "cover_image_portrait" varchar(255) COLLATE "pg_catalog"."default",
                                     "redirect_url" varchar(255) COLLATE "pg_catalog"."default",
                                     "robots" varchar(32) COLLATE "pg_catalog"."default" NOT NULL,
                                     "publish_at" timestamptz(6) NOT NULL,
                                     "expire_at" timestamptz(6),
                                     "sort_order" varchar(32) COLLATE "pg_catalog"."default" NOT NULL,
                                     "created_at" timestamptz(6) NOT NULL,
                                     "updated_at" timestamptz(6) NOT NULL,
                                     "created_by" uuid NOT NULL,
                                     "updated_by" uuid NOT NULL
)
;
ALTER TABLE "public"."contents" OWNER TO "{{PG_USERNAME}}";

-- ----------------------------
-- Records of contents
-- ----------------------------
BEGIN;
INSERT INTO "public"."contents" VALUES ('870929cf-3a5f-498c-b5ba-1f480eadff5d', '352ad301-2452-4beb-b7ba-a78ccbdfdf8c', '[]', 'lt:cms:templates:default', 1, 0, NULL, NULL, NULL, 'noindex', '2021-01-31 18:25:43+00', NULL, '45da3c2771e84', '2021-01-31 18:25:43+00', '2021-02-02 20:50:53+00', '69204e72-521c-4bea-bcc5-29afe3f2f25f', '69204e72-521c-4bea-bcc5-29afe3f2f25f');
INSERT INTO "public"."contents" VALUES ('3793c612-fd08-4e39-88bd-545b60914704', '40088caa-c213-47f5-8fdd-87744da546e7', '[]', 'lt:cms:templates:home', 1, 0, NULL, NULL, NULL, '', '2021-02-02 20:47:20+00', NULL, '4fe702d482337', '2021-02-02 20:47:20+00', '2021-02-02 20:51:04+00', '69204e72-521c-4bea-bcc5-29afe3f2f25f', '69204e72-521c-4bea-bcc5-29afe3f2f25f');
INSERT INTO "public"."contents" VALUES ('4102698f-a6bc-46e3-a11a-d9805a4d2b48', '40088caa-c213-47f5-8fdd-87744da546e7', '[]', 'lt:cms:templates:blank', 1, 0, NULL, NULL, NULL, '', '2021-02-03 14:13:17+00', NULL, '53783bf4170f7', '2021-02-03 14:13:17+00', '2021-02-03 14:17:58+00', '69204e72-521c-4bea-bcc5-29afe3f2f25f', '69204e72-521c-4bea-bcc5-29afe3f2f25f');
COMMIT;


-- ----------------------------
-- Table structure for demo_module
-- ----------------------------
DROP TABLE IF EXISTS "public"."demo_module";
CREATE TABLE "public"."demo_module" (
                                        "id" uuid NOT NULL,
                                        "full_name" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
                                        "email" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
                                        "created_at" timestamptz(6) NOT NULL DEFAULT CURRENT_TIMESTAMP
)
;
ALTER TABLE "public"."demo_module" OWNER TO "{{PG_USERNAME}}";

-- ----------------------------
-- Records of demo_module
-- ----------------------------
BEGIN;
COMMIT;

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
-- Table structure for form_data
-- ----------------------------
DROP TABLE IF EXISTS "public"."form_data";
CREATE TABLE "public"."form_data" (
                                      "id" uuid NOT NULL,
                                      "form_id" uuid NOT NULL,
                                      "post_data" jsonb NOT NULL,
                                      "client_ip" varchar(128) COLLATE "pg_catalog"."default" NOT NULL,
                                      "created_at" timestamptz(6) NOT NULL,
                                      "is_moderated" int2 NOT NULL
)
;
ALTER TABLE "public"."form_data" OWNER TO "{{PG_USERNAME}}";

-- ----------------------------
-- Records of form_data
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for forms
-- ----------------------------
DROP TABLE IF EXISTS "public"."forms";
CREATE TABLE "public"."forms" (
                                  "id" uuid NOT NULL,
                                  "name" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
                                  "created_by" uuid NOT NULL,
                                  "created_at" timestamptz(6) NOT NULL,
                                  "metadata" jsonb NOT NULL,
                                  "options" jsonb NOT NULL,
                                  "is_active" int2 NOT NULL
)
;
ALTER TABLE "public"."forms" OWNER TO "{{PG_USERNAME}}";

-- ----------------------------
-- Records of forms
-- ----------------------------
BEGIN;
INSERT INTO "public"."forms" VALUES ('99800ea7-6faa-46d7-bc33-d73a6d538171', 'Contact Form', '69204e72-521c-4bea-bcc5-29afe3f2f25f', '2020-06-15 08:15:29+00', '{"titles": [{"key": "fullName", "value": "Full Name"}, {"key": "email", "value": "E-mail Address"}, {"key": "subject", "value": "Subject"}, {"key": "message", "value": "Message"}, {"key": "confirmation", "value": "Legals Confirmation"}], "secondRow": ["message", "confirmation"]}', '{"email": true, "emailAddresses": ["mehmet@efabrika.com"]}', 1);
COMMIT;

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

-- ----------------------------
-- Records of lookup_table
-- ----------------------------
BEGIN;
INSERT INTO "public"."lookup_table" VALUES ('a86582b0-19db-4bdb-961d-559a405c85dc', 'lt:root', 'root', 'root', NULL, '{"v": "1.0.0"}', 1, 0);
INSERT INTO "public"."lookup_table" VALUES ('40088caa-c213-47f5-8fdd-87744da546e7', 'lt:cms:modules', 'Modules', 'modules', '6af65ec6-42c9-47fe-a109-aa161957afaa', '{"itemData": {"en": "Modules", "tr": "Modules"}, "contentType": "full", "isProtected": true}', 1, 0);
INSERT INTO "public"."lookup_table" VALUES ('48d6f587-3f5c-4e10-8821-f2e6689bf351', 'lt:cms:templates:home', 'Ana Sayfa', 'ana-sayfa', '25a4b7c8-bb8f-4c9c-ae3a-3d02f618eb6c', '{"itemData": {"_model": "[{\"title\":\"İçerik öğleleri\",\"inputs\":[{\"name\":\"title\",\"label\":\"Title\",\"type\":\"text\",\"required\":true},{\"name\":\"intro\",\"label\":\"Intro\",\"type\":\"basic-html\",\"required\":true}]}]", "templateFile": "app::home-page"}, "isExposable": false, "isProtected": true}', 1, 0);
INSERT INTO "public"."lookup_table" VALUES ('270101a9-990f-45d7-82d1-b0f900099d0c', 'lt:cms:templates:default', 'Default', 'default', '25a4b7c8-bb8f-4c9c-ae3a-3d02f618eb6c', '{"v": "1.0.0", "itemData": {"_model": "[{\"title\":\"Sayfa öğeleri\",\"inputs\":[{\"name\":\"heroImage\",\"type\":\"image\",\"label\":\"Hero Image\",\"required\":true},{\"name\":\"header1\",\"type\":\"text\",\"label\":\"Başlık 1\",\"required\":true},{\"name\":\"summary\",\"type\":\"textarea\",\"label\":\"Özet\",\"required\":true}]},{\"title\":\"Sayfa içerikleri\",\"inputs\":[{\"name\":\"intro\",\"type\":\"basic-html\",\"label\":\"Giriş\",\"required\":true},{\"name\":\"contentBody\",\"type\":\"full-html\",\"label\":\"Metin\",\"required\":true}]}]", "templateFile": "app::default"}, "isExposable": false, "isProtected": true}', 1, 0);
INSERT INTO "public"."lookup_table" VALUES ('1b58a2dc-26a3-42dc-beb2-5f0c0417de03', 'lt:cms:templates:blank', 'Blank', 'blank', '25a4b7c8-bb8f-4c9c-ae3a-3d02f618eb6c', '{"itemData": {"_model": "[]", "templateFile": "app::blank"}, "isExposable": false, "isProtected": true}', 1, 0);
INSERT INTO "public"."lookup_table" VALUES ('25a4b7c8-bb8f-4c9c-ae3a-3d02f618eb6c', 'lt:cms:templates', 'Templates', 'templates', '80f8fc96-da5e-48c5-a56f-ac304468dca9', '{"v": "1.0.0", "isExposable": false, "isProtected": true, "subItemAdditionalInputs": [{"name": "_model", "type": "text", "label": "Content Data Model", "textType": "textarea"}, {"name": "templateFile", "type": "text", "label": "Template File", "textType": "text"}]}', 1, 0);
INSERT INTO "public"."lookup_table" VALUES ('a99e72c0-2b49-4bda-8da4-40e03f9f6a4d', 'lt:cms:tags', 'Tags', 'tags', '80f8fc96-da5e-48c5-a56f-ac304468dca9', '{"v": "1.0.0", "isExposable": false, "isProtected": true}', 1, 0);
INSERT INTO "public"."lookup_table" VALUES ('b4d47e56-894e-4f43-8dab-5a8525782d10', 'lt:translatations', 'Translations', 'translations', 'a86582b0-19db-4bdb-961d-559a405c85dc', '{"v": "1.0.0", "hooks": [{"type": "backendbase-command", "command": "GenerateMoFiles"}], "isExposable": false, "isProtected": true, "subItemAdditionalInputs": [{"name": "tr", "type": "text", "label": "Türkçe", "textType": "text"}, {"name": "en", "type": "text", "label": "İngilizce", "textType": "text"}]}', 1, 0);
INSERT INTO "public"."lookup_table" VALUES ('bb233c01-4ec4-49d5-b507-2e52fee3de1a', '01EXET50BRF0BAQ4M3B6DQNW8C', 'HEADER_LOGIN_BUTTON_TEXT', 'header-login-button-text', 'b4d47e56-894e-4f43-8dab-5a8525782d10', '{"itemData": {"en": "Login", "tr": "Giriş"}, "isExposable": false, "isProtected": true}', 1, 0);
INSERT INTO "public"."lookup_table" VALUES ('f6e6de16-bc95-4ec7-8df2-daf40a42bb38', '01EXET5KW0HT4ZFMMDP5PJP1W4', 'HEADER_SIGNUP_BUTTON_TEXT', 'header-signup-button-text', 'b4d47e56-894e-4f43-8dab-5a8525782d10', '{"itemData": {"en": "Signup", "tr": "Kayıt Ol"}, "isExposable": false, "isProtected": true}', 1, 0);
INSERT INTO "public"."lookup_table" VALUES ('80f8fc96-da5e-48c5-a56f-ac304468dca9', 'lt:cms', 'CMS', 'cms', 'a86582b0-19db-4bdb-961d-559a405c85dc', '{"isExposable": false, "isProtected": true}', 1, 0);
INSERT INTO "public"."lookup_table" VALUES ('2d4e5b53-b796-4aca-8b5b-907b067532b8', 'lt:settings', 'Settings', 'settings', 'a86582b0-19db-4bdb-961d-559a405c85dc', '{"isExposable": false, "isProtected": true}', 1, 0);
INSERT INTO "public"."lookup_table" VALUES ('6af65ec6-42c9-47fe-a109-aa161957afaa', 'lt:cms:categories', 'Categories', 'categories', '80f8fc96-da5e-48c5-a56f-ac304468dca9', '{"v": "1.0.0", "isExposable": false, "isProtected": true, "subItemAdditionalInputs": [{"name": "tr", "type": "text", "label": "Türkçe", "textType": "text"}, {"name": "en", "type": "text", "label": "English", "textType": "text"}]}', 1, 0);
INSERT INTO "public"."lookup_table" VALUES ('9f15382c-76ee-4b5d-b07f-90c12567a88c', 'lt:cms:legals', 'Legal Texts', 'legal-texts', '6af65ec6-42c9-47fe-a109-aa161957afaa', '{"itemData": {"en": "Legal Texts", "tr": "Hukuki Metinler"}, "contentType": "full", "isProtected": true}', 1, 0);
INSERT INTO "public"."lookup_table" VALUES ('352ad301-2452-4beb-b7ba-a78ccbdfdf8c', 'lt:cms:blog', 'Blog', 'blog', '6af65ec6-42c9-47fe-a109-aa161957afaa', '{"itemData": {"en": "Blog", "tr": "Web Günlüğü"}, "contentType": "full", "isProtected": true}', 1, 0);
COMMIT;

-- ----------------------------
-- Indexes structure for table content_details
-- ----------------------------
CREATE INDEX "content_details_idx" ON "public"."content_details" USING btree (
                                                                              "language" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST,
                                                                              "region" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST,
                                                                              "title" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST,
                                                                              "slug" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST,
                                                                              "is_active" "pg_catalog"."int2_ops" ASC NULLS LAST,
                                                                              "body_fulltext" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST,
                                                                              "content_id" "pg_catalog"."uuid_ops" ASC NULLS LAST
    );

-- ----------------------------
-- Primary Key structure for table content_details
-- ----------------------------
ALTER TABLE "public"."content_details" ADD CONSTRAINT "content_details_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Indexes structure for table contents
-- ----------------------------
CREATE INDEX "contents_idx" ON "public"."contents" USING btree (
                                                                "category" "pg_catalog"."uuid_ops" ASC NULLS LAST,
                                                                "tags" "pg_catalog"."jsonb_ops" ASC NULLS LAST,
                                                                "is_active" "pg_catalog"."int2_ops" ASC NULLS LAST,
                                                                "is_deleted" "pg_catalog"."int2_ops" ASC NULLS LAST,
                                                                "publish_at" "pg_catalog"."timestamptz_ops" ASC NULLS LAST,
                                                                "expire_at" "pg_catalog"."timestamptz_ops" ASC NULLS LAST,
                                                                "sort_order" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST,
                                                                "created_at" "pg_catalog"."timestamptz_ops" ASC NULLS LAST,
                                                                "updated_at" "pg_catalog"."timestamptz_ops" ASC NULLS LAST,
                                                                "created_by" "pg_catalog"."uuid_ops" ASC NULLS LAST,
                                                                "updated_by" "pg_catalog"."uuid_ops" ASC NULLS LAST
    );

-- ----------------------------
-- Primary Key structure for table contents
-- ----------------------------
ALTER TABLE "public"."contents" ADD CONSTRAINT "contentbase_pkey" PRIMARY KEY ("id");


-- ----------------------------
-- Indexes structure for table demo_module
-- ----------------------------
CREATE INDEX "demo_module_idx" ON "public"."demo_module" USING btree (
                                                                      "created_at" "pg_catalog"."timestamptz_ops" ASC NULLS LAST,
                                                                      "email" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
    );

-- ----------------------------
-- Primary Key structure for table demo_module
-- ----------------------------
ALTER TABLE "public"."demo_module" ADD CONSTRAINT "demo_module_pkey" PRIMARY KEY ("id");

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
-- Indexes structure for table form_data
-- ----------------------------
CREATE INDEX "form_data_idx" ON "public"."form_data" USING btree (
                                                                  "form_id" "pg_catalog"."uuid_ops" ASC NULLS LAST,
                                                                  "created_at" "pg_catalog"."timestamptz_ops" ASC NULLS LAST,
                                                                  "is_moderated" "pg_catalog"."int2_ops" ASC NULLS LAST,
                                                                  "client_ip" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST,
                                                                  "post_data" "pg_catalog"."jsonb_ops" ASC NULLS LAST
    );

-- ----------------------------
-- Primary Key structure for table form_data
-- ----------------------------
ALTER TABLE "public"."form_data" ADD CONSTRAINT "form_data_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Indexes structure for table forms
-- ----------------------------
CREATE INDEX "forms_idx" ON "public"."forms" USING btree (
                                                          "created_at" "pg_catalog"."timestamptz_ops" ASC NULLS LAST,
                                                          "created_by" "pg_catalog"."uuid_ops" ASC NULLS LAST,
                                                          "created_by" "pg_catalog"."uuid_ops" ASC NULLS LAST,
                                                          "metadata" "pg_catalog"."jsonb_ops" ASC NULLS LAST,
                                                          "options" "pg_catalog"."jsonb_ops" ASC NULLS LAST,
                                                          "is_active" "pg_catalog"."int2_ops" ASC NULLS LAST
    );

-- ----------------------------
-- Primary Key structure for table forms
-- ----------------------------
ALTER TABLE "public"."forms" ADD CONSTRAINT "forms_pkey" PRIMARY KEY ("id");

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

