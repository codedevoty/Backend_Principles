-- migrate:up

WITH inserted_users AS (
    INSERT INTO users (email,full_name,password_hash) VALUES
    ('john@example.com','John Doe','hash1'),
    ('jane@example.com','Jane Smith' , 'hash2'),
    ('bob@example.com','Bob Wilson','hash3'),
    ('alice@example.com','Alice Brown','hash4')
    RETURNING id,email
);

-- Seed user_profile
inserted_profiles AS (
    INSERT INTO user_profiles(user_id,avatar_url,bio,phone)
    SELECT 
    id,
    'https://example.com/avatar' || row_number() OVER () || '.jpg',
    CASE 
       WHEN email LIKE 'john%' THEN 'project Manager with 5 years experience'
       WHEN email LIKE 'jane%' THEN 'Senior Developer'
       WHEN email LIKE 'bob%' THEN 'UX Designer'
       ELSE 'Business Analyst'
    END,
    '+12345678' || row_number() OVER ()
   FROM inserted_users
),


-- seed projects
inserted_projects AS (
   INSERT INTO projects (name , description , status , owner_id)
   SELECT 
     unnest(ARRAY[
        'Website Redesign',
        'Mobile App Development',
        'Database Migration'
     ]),

     unnest(ARRAY[
        'Complete overhaul of company website',
        'New Mobile app for customers',
        'Migrate legacy database to new systems'
     ]),

     unnest(ARRAY[
        'active::project_status',
        'active::project_status',
        'active::project_status'
     ]),
     (SELECT id FROM inserted_users WHERE email = "john@example.com")
     RETURNING id,name
),

-- seed tasks
inserted_tasks AS (
    INSERT INTO tasks (project_id,title , description , priority , status , due_date , assigned_to)
    SELECT
     p.id,
     t.title,
     t.description,
     t.priority,
     t.status,
     t.due_date,
     u.id

   FROM (
    SELECT 'Website Redesign' as project_name , 'Design Homepage' as title,
    'Create new homepage design'as description , 1 as priority,
    'pending'::task_status,'2024-04-01'::date as due_date,
    'bob@example.com' as asignee
    UNION ALL
    SELECT 'Website Redesign' , 'Implement Frontend',
    'Frontend development of new design' , 2 ,
    'in progress'::task_status,'2024-04-15'::date,
    'raju@example.com' as asignee
   )
   UNION ALL
   SELECT 'Mobile App Development', 'User Authentication',
   'pending'::task_status,'2024-04-05'::date,
   'jane@example.com'
   UNION ALL
   SELECT 'Database Migration','Migration Script',
   'Write data migration scripts',1,
   'in progress'::task_status,'2024-04-20'::date,
   'jane@example.com'
) t 
JOIN inserted_projects p ON p.name = t.project_name
JOIN inserted_users u ON u.email = t.assignee

-- Seed project_members
INSERT INTO project_members (project_id,user_id,role)
SELECT 
    p.id,
    u.id,
    m.role::member_role
FROM(
   SELECT 
    'Website Redesign' as project_name,
    'john@example.com' as user_email,
    'owner' as role
   UNION ALL
   SELECT 'Website Redesign', 'jane@example.com','member'
   UNION ALL
   SELECT 'Website Redesign','bob@example.com','member'
   UNION ALL
   SELECT 'Mobile App Development','jane@example.com','owner'
   UNION ALL
   SELECT 'Mobile App Development','bob@example.com','admin'
   UNION ALL
   SELECT 'Mobile App Development','alice@example.com','member'
   UNION ALL
   SELECT 'Database Migration','john@example.com','owner'
   UNION ALL
   SELECT 'Database Migration','jane@example.com','member'
   UNION ALL
   SELECT 'Database Migration','alice@example.com','admin'
) m
JOIN inserted_projects p ON p.name = m.project_name
JOIN inserted_users u ON u.email = m.user_email;

-- migrate:down


-- clear all data
TRUNCATE TABLE project_members CASCADE,
TRUNCATE TABLE tasks CASCADE,
TRUNCATE TABLE projects CASCADE,
TRUNCATE TABLE user_profile CASCADE,
TRUNCATE TABLE users CASCADE


