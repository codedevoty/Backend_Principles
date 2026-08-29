-- migrate:up

-- ============================================
-- INDEXES
-- ============================================

-- Users
CREATE INDEX idx_users_created_at
ON users(created_at);

-- User Profile
CREATE INDEX idx_user_profile_phone
ON user_profile(phone);

-- Projects
CREATE INDEX idx_projects_owner_id
ON projects(owner_id);

CREATE INDEX idx_projects_status
ON projects(status);

CREATE INDEX idx_projects_created_at
ON projects(created_at);

-- Tasks
CREATE INDEX idx_task_project_id
ON task(project_id);

CREATE INDEX idx_task_assigned_to
ON task(assigned_to);

CREATE INDEX idx_task_status
ON task(status);

CREATE INDEX idx_task_due_date
ON task(due_date);

-- Project Members
CREATE INDEX idx_project_members_user_id
ON project_members(user_id);

CREATE INDEX idx_project_members_role
ON project_members(role);


-- ============================================
-- TRIGGER FUNCTION
-- Automatically update updated_at
-- ============================================

CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


-- ============================================
-- TRIGGERS
-- ============================================

CREATE TRIGGER update_users_updated_at
BEFORE UPDATE ON users
FOR EACH ROW
EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_user_profile_updated_at
BEFORE UPDATE ON user_profile
FOR EACH ROW
EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_projects_updated_at
BEFORE UPDATE ON projects
FOR EACH ROW
EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_task_updated_at
BEFORE UPDATE ON task
FOR EACH ROW
EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_project_members_updated_at
BEFORE UPDATE ON project_members
FOR EACH ROW
EXECUTE FUNCTION update_updated_at_column();


-- migrate:down

-- Drop triggers

DROP TRIGGER IF EXISTS update_project_members_updated_at
ON project_members;

DROP TRIGGER IF EXISTS update_task_updated_at
ON task;

DROP TRIGGER IF EXISTS update_projects_updated_at
ON projects;

DROP TRIGGER IF EXISTS update_user_profile_updated_at
ON user_profile;

DROP TRIGGER IF EXISTS update_users_updated_at
ON users;


-- Drop trigger function

DROP FUNCTION IF EXISTS update_updated_at_column();


-- Drop indexes

DROP INDEX IF EXISTS idx_project_members_role;
DROP INDEX IF EXISTS idx_project_members_user_id;

DROP INDEX IF EXISTS idx_task_due_date;
DROP INDEX IF EXISTS idx_task_status;
DROP INDEX IF EXISTS idx_task_assigned_to;
DROP INDEX IF EXISTS idx_task_project_id;

DROP INDEX IF EXISTS idx_projects_created_at;
DROP INDEX IF EXISTS idx_projects_status;
DROP INDEX IF EXISTS idx_projects_owner_id;

DROP INDEX IF EXISTS idx_user_profile_phone;

DROP INDEX IF EXISTS idx_users_created_at;