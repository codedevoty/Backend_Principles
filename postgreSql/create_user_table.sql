
-- db migrate up
-- create custom enum Types
CREATE TYPE project_status AS ENUM ('active','completed','archived');
CREATE TYPE task_status AS ENUM ('pending','in-progress','completed','cancelled');
CREATE TYPE member_role AS ENUM ('owner','admin','member');



CREATE TABLE users (
    password_hash TEXT NOT NULL,
    created_at TIMESTAMP WITH THE TIME ZONE DEFAULT CURRENT_TIMESTAMP ,
    updated_at TIMESTAMP WITH THE TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- create user_profiles tables (one-to-one) with users
CREATE TABLE user_profiles(
    user_id UUID NOT NULL UNIQUE REFERENCES users ON DELETE CASCADE ,
    avatar_url TEXT,
    bio TEXT,
    phone TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- create projects tables
CREATE TABLE projects (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name TEXT NOT NULL,
    description TEXT,
    status project_status NOT NULL DEFAULT 'active',
    owner_id UUID NOT NULL REFERENCES users ON DELETE RESTRICT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP

);

-- create task table 
CREATE TABLE task(
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    project_id UUID NOT NULL REFERENCES projects ON DELETE CASCADE,
    title TEXT NOT NULL,
    description TEXT,
    priority INTEGER NOT NULL DEFAULT 1 CHECK (priority BETWEEN 1 and 5),
    status task status NOT NULL DEFAULT 'pending',
    due_date DATE,
    assigned_to UUID REFERENCES users ON DELETE SET NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- create project members (many-many between projects and users)
CREATE TABLE project_members (
    project_id UUID NOT NULL REFERENCES projects ON DELETE CASCADE ,
    user_id UUID NOT NULL REFERENCES users ON DELETE CASCADE,
    role member_role NOT NULL DEFAULT 'member',
    created_at TIMESTAMP WITH TIMEZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIMEZONE DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (project_id,user_id)
);

-- mirgate : down
-- DROP TABLES
DROP TABLE IF EXISTS project_members,
DROP TABLE IF EXISTS tasks;
DROP TABLE IF EXISTS projects;
DROP TABLE IF EXISTS user_profiles;
DROP TABLE IF EXISTS users;
