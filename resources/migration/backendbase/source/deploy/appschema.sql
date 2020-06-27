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

INSERT INTO "admin"."roles" VALUES ('905dc75a-22c2-47c8-9414-dcbdf3d405f6', 'Super Admin', 'super-admin', 100, '[]', 0, 1, '2020-05-24 05:04:30+00');
INSERT INTO "admin"."roles" VALUES ('fe1caf55-1421-4b81-bccd-90e20918d902', 'System Admin', 'admin', 90, '["collections-menu", "collections-edit", "collections-create", "users-menu", "users-edit", "user-create", "user-permissions", "cms-menu", "cms-create", "cms-edit", "demo-module-menu"]', 1, 0, '2020-05-24 05:08:16+00');
INSERT INTO "admin"."roles" VALUES ('309111c1-e74a-4b62-b09a-8fb77684a188', 'Content Manager', 'editor', 90, '[ "cms-menu", "cms-create", "cms-edit"]', 1, 0, '2020-05-24 05:08:16+00');

CREATE TABLE "admin"."permission_types" (
    "id" uuid NOT NULL,
    "name" varchar(255) NOT NULL,
    "slug" varchar(255) NOT NULL,
    "is_active" int2 NOT NULL DEFAULT 1,
    "is_protected" int2 NOT NULL DEFAULT 0,
    "created_at" timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY ("id")
)
;

CREATE INDEX "permission_types_idx" ON "admin"."permission_types" (
    "slug",
    "is_active",
    "created_at",
    "is_protected"
);
ALTER TABLE "admin"."permission_types" OWNER TO "{{PG_USERNAME}}";

INSERT INTO "admin"."permission_types" VALUES ('2b34000b-dc96-440a-b924-5fd2218eaf1b', 'Collections', 'collections', 1, 1, '2017-11-06 23:47:00+00');
INSERT INTO "admin"."permission_types" VALUES ('9a63e5b7-c1c0-4ad6-b3c3-c7ce9fdba879', 'CMS', 'cms', 1, 1, '2017-11-06 23:47:01+00');
INSERT INTO "admin"."permission_types" VALUES ('800a8903-ab58-47e3-9747-a9c87728fc0f', 'Users', 'users', 1, 1, '2017-11-06 23:47:02+00');
INSERT INTO "admin"."permission_types" VALUES ('5a4791df-7048-4b83-90bc-25a53abc5a11', 'Demo Module', 'demo-module', 1, 0, '2017-11-06 23:47:03+00');

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



INSERT INTO "public"."contents" VALUES ('fe40e096-8a8e-4a78-a5f7-0e61e3fb1f37', 'Privacy Policy', 'Privacy Policy', 'simple', 'lt:cms:legals', NULL, NULL, NULL, NULL, '[]', '{"slug": "/privacy", "videoGallery": []}', NULL, '<h4>Privacy Policy for BackendBase</h4><p>At BackendBase, accessible from https://github.com/reformo/backendbase, one of our main priorities is the privacy of our visitors. This Privacy Policy document contains types of information that is collected and recorded by BackendBase and how we use it.</p><p>If you have additional questions or require more information about our Privacy Policy, do not hesitate to contact us.</p><p>This Privacy Policy applies only to our online activities and is valid for visitors to our website with regards to the information that they shared and/or collect in BackendBase. This policy is not applicable to any information collected offline or via channels other than this website.</p><h4>Consent</h4><p>By using our website, you hereby consent to our Privacy Policy and agree to its terms.</p><h4>Information we collect</h4><p>The personal information that you are asked to provide, and the reasons why you are asked to provide it, will be made clear to you at the point we ask you to provide your personal information.</p><p>If you contact us directly, we may receive additional information about you such as your name, email address, phone number, the contents of the message and/or attachments you may send us, and any other information you may choose to provide.</p><p>When you register for an Account, we may ask for your contact information, including items such as name, company name, address, email address, and telephone number.</p><h4>How we use your information</h4><p>We use the information we collect in various ways, including to:</p><ul>
<li>Provide, operate, and maintain our website</li>
<li>Improve, personalize, and expand our website</li>
<li>Understand and analyze how you use our website</li>
<li>Develop new products, services, features, and functionality</li>
<li>Communicate with you, either directly or through one of our partners, including for customer service, to provide you with updates and other information relating to the website, and for marketing and promotional purposes</li>
<li>Send you emails</li>
<li>Find and prevent fraud</li>
</ul><h4>Log Files</h4><p>BackendBase follows a standard procedure of using log files. These files log visitors when they visit websites. All hosting companies do this and a part of hosting services'' analytics. The information collected by log files include internet protocol (IP) addresses, browser type, Internet Service Provider (ISP), date and time stamp, referring/exit pages, and possibly the number of clicks. These are not linked to any information that is personally identifiable. The purpose of the information is for analyzing trends, administering the site, tracking users'' movement on the website, and gathering demographic information. Our Privacy Policy was created with the help of the <a href="https://www.privacypolicygenerator.info">Privacy Policy Generator</a> and the <a href="https://www.privacypolicyonline.com/privacy-policy-generator/">Online Privacy Policy Generator</a>.</p><h4>Advertising Partners Privacy Policies</h4><p>You may consult this list to find the Privacy Policy for each of the advertising partners of BackendBase.</p><p>Third-party ad servers or ad networks uses technologies like cookies, JavaScript, or Web Beacons that are used in their respective advertisements and links that appear on BackendBase, which are sent directly to users'' browser. They automatically receive your IP address when this occurs. These technologies are used to measure the effectiveness of their advertising campaigns and/or to personalize the advertising content that you see on websites that you visit.</p><p>Note that BackendBase has no access to or control over these cookies that are used by third-party advertisers.</p><h4>Third Party Privacy Policies</h4><p>BackendBase''s Privacy Policy does not apply to other advertisers or websites. Thus, we are advising you to consult the respective Privacy Policies of these third-party ad servers for more detailed information. It may include their practices and instructions about how to opt-out of certain options.</p><p>You can choose to disable cookies through your individual browser options. To know more detailed information about cookie management with specific web browsers, it can be found at the browsers'' respective websites.</p><h4>CCPA Privacy Rights (Do Not Sell My Personal Information)</h4><p>Under the CCPA, among other rights, California consumers have the right to:</p><p>Request that a business that collects a consumer''s personal data disclose the categories and specific pieces of personal data that a business has collected about consumers.</p><p>Request that a business delete any personal data about the consumer that a business has collected.</p><p>Request that a business that sells a consumer''s personal data, not sell the consumer''s personal data.</p><p>If you make a request, we have one month to respond to you. If you would like to exercise any of these rights, please contact us.</p><h4>GDPR Data Protection Rights</h4><p>We would like to make sure you are fully aware of all of your data protection rights. Every user is entitled to the following:</p><p>The right to access – You have the right to request copies of your personal data. We may charge you a small fee for this service.</p><p>The right to rectification – You have the right to request that we correct any information you believe is inaccurate. You also have the right to request that we complete the information you believe is incomplete.</p><p>The right to erasure – You have the right to request that we erase your personal data, under certain conditions.</p><p>The right to restrict processing – You have the right to request that we restrict the processing of your personal data, under certain conditions.</p><p>The right to object to processing – You have the right to object to our processing of your personal data, under certain conditions.</p><p>The right to data portability – You have the right to request that we transfer the data that we have collected to another organization, or directly to you, under certain conditions.</p><p>If you make a request, we have one month to respond to you. If you would like to exercise any of these rights, please contact us.</p><h4>Children''s Information</h4><p>Another part of our priority is adding protection for children while using the internet. We encourage parents and guardians to observe, participate in, and/or monitor and guide their online activity.</p><p>BackendBase does not knowingly collect any Personal Identifiable Information from children under the age of 13. If you think that your child provided this kind of information on our website, we strongly encourage you to contact us immediately and we will do our best efforts to promptly remove such information from our records.</p>', '[]', '33700e6b09a', 1, 0, '2020-06-27 08:22:07+00', '69204e72-521c-4bea-bcc5-29afe3f2f25f', '2020-06-27 10:30:13+00', '69204e72-521c-4bea-bcc5-29afe3f2f25f');
INSERT INTO "public"."contents" VALUES ('5615d532-9fdc-4222-9eb4-71dc435563d6', 'Demo Module', 'Demo Module Serp Title', 'full', 'lt:cms:modules', NULL, NULL, NULL, NULL, '[]', '{"slug": "/legal/privacy-policy", "module": "demo-module", "videoGallery": []}', NULL, '<p>.</p>', '[]', '37f0b19325a2', 1, 0, '2020-06-26 22:03:17+00', '69204e72-521c-4bea-bcc5-29afe3f2f25f', '2020-06-27 10:27:33+00', '69204e72-521c-4bea-bcc5-29afe3f2f25f');
INSERT INTO "public"."contents" VALUES ('05a4fd76-0860-4b04-ab28-286c441b852e', 'Home', 'Home Page | Demo App', 'image-key-value', 'lt:cms:modules', NULL, NULL, NULL, NULL, '[]', '{"slug": "/", "module": "home", "videoGallery": []}', NULL, '<h2>Welcome to Demo App!</h2><p>This is a demo app to show basic structure of a BackendBase App.</p>', '[]', '36383d7051a0', 1, 0, '2020-06-26 21:31:45+00', '69204e72-521c-4bea-bcc5-29afe3f2f25f', '2020-06-27 10:59:44+00', '69204e72-521c-4bea-bcc5-29afe3f2f25f');
INSERT INTO "public"."contents" VALUES ('eb34b198-4a22-4bfa-993d-c4f22b488786', 'Disclosure', 'Disclosure', 'simple', 'lt:cms:legals', NULL, NULL, NULL, NULL, '[]', '{"slug": "/disclosure", "videoGallery": []}', NULL, '<p>disclosure</p>', '[]', 'b90a54851bd', 1, 0, '2020-06-27 10:55:08+00', '69204e72-521c-4bea-bcc5-29afe3f2f25f', '2020-06-27 11:15:34+00', '69204e72-521c-4bea-bcc5-29afe3f2f25f');
INSERT INTO "public"."contents" VALUES ('615805ee-ca80-4ae8-9ff9-37ad5f416461', 'Contact', 'Contact Serp Title', 'full', 'lt:cms:modules', NULL, NULL, NULL, NULL, '[]', '{"slug": "/contact", "module": "contact", "videoGallery": []}', NULL, '<p>.</p>', '[]', 'c36a68b7456', 1, 0, '2020-06-27 11:07:01+00', '69204e72-521c-4bea-bcc5-29afe3f2f25f', '2020-06-27 11:33:05+00', '69204e72-521c-4bea-bcc5-29afe3f2f25f');


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
INSERT INTO "public"."lookup_table" VALUES ('352ad301-2452-4beb-b7ba-a78ccbdfdf8c', 'lt:cms:blog', 'Blog', 'blog', '6af65ec6-42c9-47fe-a109-aa161957afaa', '{"v": "1.0.0", "contentType": "full"}', 1, 0);
INSERT INTO "public"."lookup_table" VALUES ('9f15382c-76ee-4b5d-b07f-90c12567a88c', 'lt:cms:legals', 'Legal Texts', 'legal-texts', '6af65ec6-42c9-47fe-a109-aa161957afaa', '{"v": "1.0.0", "contentType": "full"}', 1, 0);
INSERT INTO "public"."lookup_table" VALUES ('40088caa-c213-47f5-8fdd-87744da546e7', 'lt:cms:modules', 'Modules', 'modules', '6af65ec6-42c9-47fe-a109-aa161957afaa', '{"v": "1.0.0", "contentType": "full"}', 1, 0);
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
ALTER TABLE public.forms OWNER TO {{PG_USERNAME}};
ALTER TABLE public.form_data OWNER TO {{PG_USERNAME}};


CREATE TABLE "public"."demo_module" (
                                     "id" uuid NOT NULL,
                                     "full_name" varchar(255) NOT NULL,
                                     "email" varchar(255) NOT NULL,
                                     "created_at" timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP,
                                     PRIMARY KEY ("id")
)
;

CREATE INDEX "demo_module_idx" ON "public"."demo_module" (
                                                       "created_at",
                                                       "email"
    );
ALTER TABLE public.demo_module OWNER TO {{PG_USERNAME}};

COMMIT;