-- Verify appschema on pg
DO $$
DECLARE
    result varchar;
BEGIN

   	ASSERT (SELECT has_schema_privilege('demo_app', 'usage'));
   
   	-- Verify public.lookup_table
   	result := (SELECT tablename FROM pg_indexes WHERE schemaname = 'public' AND indexname ='idx_public_lokup_table');
   	ASSERT result = 'lookup_table';

   	result := (SELECT tablename FROM pg_indexes WHERE schemaname = 'public' AND indexname ='idx_public_lookup_table_unq_key');
   	ASSERT result = 'lookup_table';

   	result := (SELECT tablename FROM pg_indexes WHERE schemaname = 'public' AND indexname ='idx_public_unq_parent_slug');
   	ASSERT result = 'lookup_table';

   	-- Verify filomingo.users
   	result := (SELECT tablename FROM pg_indexes WHERE schemaname = 'filomingo' AND indexname ='filomingo_users_idx');
   	ASSERT result = 'users';

   	result := (SELECT tablename FROM pg_indexes WHERE schemaname = 'filomingo' AND indexname ='filomingo_users_unq_email');
   	ASSERT result = 'users';

   	result := (SELECT first_name FROM admin.users WHERE id = '69204e72-521c-4bea-bcc5-29afe3f2f25f');
   	ASSERT result = 'Efabrika';
   


   	
END $$;
