
-- migrate:up

WITH inserted_users AS (
    INSERT INTO users (id, password_hash)
    VALUES
        ('11111111-1111-1111-1111-111111111111', 'hash1'),
        ('22222222-2222-2222-2222-222222222222', 'hash2'),
        ('33333333-3333-3333-3333-333333333333', 'hash3'),
        ('44444444-4444-4444-4444-444444444444', 'hash4')
    RETURNING id
)


INSERT INTO user_profile (
    user_id,
    avatar_url,
    bio,
    phone
)
SELECT
    id,
    'https://example.com/avatar' || ROW_NUMBER() OVER () || '.jpg',
    CASE
        WHEN id = '11111111-1111-1111-1111-111111111111'
            THEN 'Project Manager with 5 years experience'
        WHEN id = '22222222-2222-2222-2222-222222222222'
            THEN 'Senior Developer'
        WHEN id = '33333333-3333-3333-3333-333333333333'
            THEN 'UX Designer'
        ELSE 'Business Analyst'
    END,
    '+12345678' || ROW_NUMBER() OVER ()
FROM inserted_users;




INSERT INTO projects (
    id,
    name,
    description,
    status,
    owner_id
)
VALUES
(
    'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
    'Website Redesign',
    'Complete overhaul of company website',
    'active',
    '11111111-1111-1111-1111-111111111111'
),
(
    'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb',
    'Mobile App Development',
    'New mobile app for customers',
    'active',
    '22222222-2222-2222-2222-222222222222'
),
(
    'cccccccc-cccc-cccc-cccc-cccccccccccc',
    'Database Migration',
    'Migrate legacy database to new system',
    'active',
    '11111111-1111-1111-1111-111111111111'
);


-- ============================================
-- Seed Tasks
-- ============================================

INSERT INTO task (
    id,
    project_id,
    title,
    description,
    priority,
    status,
    due_date,
    assigned_to
)
VALUES
(
    'aaaaaaaa-1111-1111-1111-aaaaaaaaaaaa',
    'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
    'Design Homepage',
    'Create new homepage design',
    1,
    'pending',
    '2026-09-01',
    '33333333-3333-3333-3333-333333333333'
),
(
    'bbbbbbbb-2222-2222-2222-bbbbbbbbbbbb',
    'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
    'Implement Frontend',
    'Frontend development of new design',
    2,
    'in-progress',
    '2026-09-15',
    '22222222-2222-2222-2222-222222222222'
),
(
    'cccccccc-3333-3333-3333-cccccccccccc',
    'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb',
    'User Authentication',
    'Implement user authentication',
    3,
    'pending',
    '2026-09-10',
    '22222222-2222-2222-2222-222222222222'
),
(
    'dddddddd-4444-4444-4444-dddddddddddd',
    'cccccccc-cccc-cccc-cccc-cccccccccccc',
    'Migration Script',
    'Write data migration scripts',
    1,
    'in-progress',
    '2026-09-20',
    '22222222-2222-2222-2222-222222222222'
);



INSERT INTO project_members (
    project_id,
    user_id,
    role
)
VALUES
(
    'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
    '11111111-1111-1111-1111-111111111111',
    'owner'
),
(
    'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
    '22222222-2222-2222-2222-222222222222',
    'member'
),
(
    'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
    '33333333-3333-3333-3333-333333333333',
    'member'
),
(
    'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb',
    '22222222-2222-2222-2222-222222222222',
    'owner'
),
(
    'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb',
    '33333333-3333-3333-3333-333333333333',
    'admin'
),
(
    'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb',
    '44444444-4444-4444-4444-444444444444',
    'member'
),
(
    'cccccccc-cccc-cccc-cccc-cccccccccccc',
    '11111111-1111-1111-1111-111111111111',
    'owner'
),
(
    'cccccccc-cccc-cccc-cccc-cccccccccccc',
    '22222222-2222-2222-2222-222222222222',
    'member'
),
(
    'cccccccc-cccc-cccc-cccc-cccccccccccc',
    '44444444-4444-4444-4444-444444444444',
    'admin'
);



-- migrate:down
 TRUNCATE TABLE project_members CASCADE;
 TRUNCATE TABLE task CASCADE;
 TRUNCATE TABLE projects CASCADE;
 TRUNCATE TABLE user_profile CASCADE;
 TRUNCATE TABLE users CASCADE;
