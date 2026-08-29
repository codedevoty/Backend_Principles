# PostgreSQL + Dbmate Database Management

A hands-on backend database learning project focused on **PostgreSQL**, **Neon Cloud PostgreSQL**, and **Dbmate database migrations**.

This project follows the database concepts demonstrated in the Backend Principles learning series by Sriniously and provides practical experience with schema design, migrations, seed data, indexes, triggers, relationships, and SQL queries.

---

## 📌 Project Overview

The purpose of this project is to understand how a backend application interacts with a relational database and how database schema changes can be managed safely using migrations.

The project uses:

* **PostgreSQL** — Relational database
* **Neon** — Cloud-hosted PostgreSQL database
* **Dbmate** — Database migration tool
* **SQL** — Database queries and schema definitions
* **VS Code** — Development environment

The PostgreSQL database is hosted on **Neon**, so PostgreSQL does not need to be installed locally.

---

## 🛠️ Technologies Used

| Technology | Purpose                               |
| ---------- | ------------------------------------- |
| PostgreSQL | Relational database                   |
| Neon       | Cloud PostgreSQL hosting              |
| Dbmate     | Database migration management         |
| SQL        | Schema, queries and data manipulation |
| VS Code    | Development environment               |
| Git        | Version control                       |
| GitHub     | Repository hosting                    |

---

# 📂 Project Structure

```text
postgreSql/
│
├── db/
│   └── migrations/
│       ├── 20260828062119_create_user_table.sql
│       ├── 20260828084954_seed_data.sql
│       └── add_indexes_and_triggers.sql
│
├── queries.sql
├── README.md
└── .env
```

### `db/migrations/`

Contains all database migrations managed by Dbmate.

### `queries.sql`

Contains SQL queries used for practicing and testing the database.

### `.env`

Contains the Neon PostgreSQL connection string.

This file must **not** be committed to GitHub.

### `README.md`

Project documentation and setup instructions.

---

# 🗄️ Database Schema

The project contains the following main tables:

```text
users
  │
  ├────────────── user_profile
  │
  ├────────────── projects
  │                    │
  │                    └──────── task
  │
  └────────────── project_members
```

## Tables

### Users

Stores basic user information.

```text
users
├── id
├── password_hash
├── created_at
└── updated_at
```

---

### User Profile

Stores additional information associated with a user.

```text
user_profile
├── user_id
├── avatar_url
├── bio
├── phone
├── created_at
└── updated_at
```

Relationship:

```text
users 1 ───────── 1 user_profile
```

---

### Projects

Stores projects owned by users.

```text
projects
├── id
├── name
├── description
├── status
├── owner_id
├── created_at
└── updated_at
```

Relationship:

```text
users 1 ───────── N projects
```

---

### Tasks

Stores tasks belonging to projects.

```text
task
├── id
├── project_id
├── title
├── description
├── priority
├── status
├── due_date
├── assigned_to
├── created_at
└── updated_at
```

Relationship:

```text
projects 1 ───────── N task
```

---

### Project Members

Represents the many-to-many relationship between users and projects.

```text
project_members
├── project_id
├── user_id
├── role
├── created_at
└── updated_at
```

Relationship:

```text
users N ───────── N projects
              │
              ▼
       project_members
```

---

# 🔖 PostgreSQL ENUM Types

The project uses PostgreSQL ENUM types for controlled values.

## Project Status

```sql
CREATE TYPE project_status AS ENUM (
    'active',
    'completed',
    'archived'
);
```

## Task Status

```sql
CREATE TYPE task_status AS ENUM (
    'pending',
    'in-progress',
    'completed',
    'cancelled'
);
```

## Member Role

```sql
CREATE TYPE member_role AS ENUM (
    'owner',
    'admin',
    'member'
);
```

Using ENUMs prevents invalid status or role values from being inserted into the database.

---

# 🔄 Database Migrations

Dbmate is used to manage database schema changes.

Each migration contains two sections:

```sql
-- migrate:up

-- changes to apply


-- migrate:down

-- changes to rollback
```

## Create a Migration

From the `postgreSql` directory:

```powershell
dbmate new create_users_table
```

Dbmate creates a timestamped migration file inside:

```text
db/migrations/
```

Example:

```text
20260828062119_create_user_table.sql
```

---

# ⬆️ Apply Migrations

To apply pending migrations:

```powershell
dbmate up
```

Dbmate executes migrations that have not already been applied.

---

# ⬇️ Rollback a Migration

To roll back the latest migration:

```powershell
dbmate down
```

This executes the migration's:

```sql
-- migrate:down
```

section.

---

# 📊 Check Migration Status

Use:

```powershell
dbmate status
```

This shows which migrations have been applied.

Example:

```text
Applied: 20260828062119_create_user_table.sql
Applied: 20260828084954_seed_data.sql
```

---

# 🌱 Seed Data

Seed data is used to insert sample records into the database.

The seed migration creates sample:

* Users
* User profiles
* Projects
* Tasks
* Project members

The seed data follows the foreign-key relationships between the tables.

For example:

```text
Users
  ↓
User Profiles

Users
  ↓
Projects
  ↓
Tasks

Users + Projects
  ↓
Project Members
```

Because the seed data migration is managed by Dbmate, it can also be rolled back.

---

# ⚡ Indexes

Indexes were added to frequently queried columns and foreign-key columns.

Examples include:

```sql
CREATE INDEX idx_projects_owner_id
ON projects(owner_id);
```

```sql
CREATE INDEX idx_projects_status
ON projects(status);
```

```sql
CREATE INDEX idx_task_project_id
ON task(project_id);
```

```sql
CREATE INDEX idx_task_assigned_to
ON task(assigned_to);
```

```sql
CREATE INDEX idx_project_members_user_id
ON project_members(user_id);
```

Indexes improve query performance when PostgreSQL needs to search or join data using these columns.

---

# 🔔 Triggers

A PostgreSQL trigger is used to automatically update the `updated_at` column whenever a record is modified.

The trigger function:

```sql
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;
```

The trigger is applied to tables such as:

```text
users
user_profile
projects
task
project_members
```

For example:

```sql
CREATE TRIGGER update_projects_updated_at
BEFORE UPDATE ON projects
FOR EACH ROW
EXECUTE FUNCTION update_updated_at_column();
```

This means that when a project is updated:

```text
UPDATE projects
       ↓
Trigger executes
       ↓
updated_at changes automatically
```

---

# 🔍 SQL Queries

The `queries.sql` file contains SQL queries used to practice interacting with the database.

Examples:

## Select Users

```sql
SELECT * FROM users;
```

## Select Projects

```sql
SELECT * FROM projects;
```

## Select Tasks

```sql
SELECT * FROM task;
```

## Filter Projects

```sql
SELECT *
FROM projects
WHERE status = 'active';
```

## Find Tasks by Project

```sql
SELECT *
FROM task
WHERE project_id = 'project-uuid';
```

## Join Projects and Users

```sql
SELECT
    projects.name,
    users.id AS owner_id
FROM projects
JOIN users
    ON projects.owner_id = users.id;
```

---

# ☁️ Neon PostgreSQL

The database is hosted using Neon.

The application connects to Neon using a PostgreSQL connection string stored in an environment variable.

Example:

```env
DATABASE_URL="postgresql://..."
```

The actual connection string should never be committed to GitHub.

---

# 🔐 Environment Variables

Create a `.env` file:

```env
DATABASE_URL="YOUR_NEON_DATABASE_URL"
```

The `.env` file should be added to `.gitignore`.

Example `.gitignore`:

```gitignore
.env
.env.*
!.env.example
```

A safe `.env.example` can be committed:

```env
DATABASE_URL=your_neon_postgresql_connection_string
```

---

# 🚀 Setup

## 1. Clone the Repository

```powershell
git clone <repository-url>
```

Navigate into the project:

```powershell
cd Backend_Principles
cd postgreSql
```

---

## 2. Configure Neon

Create a PostgreSQL database using Neon and obtain the PostgreSQL connection string.

Add it to:

```text
.env
```

Example:

```env
DATABASE_URL="your-neon-connection-string"
```

---

## 3. Install Dbmate

Dbmate must be available from the terminal.

Check:

```powershell
dbmate --version
```

Example:

```text
dbmate version 2.35.1
```

---

## 4. Run Migrations

From the `postgreSql` directory:

```powershell
dbmate up
```

---

## 5. Check Migration Status

```powershell
dbmate status
```

---

## 6. Execute SQL Queries

SQL queries can be executed against the Neon database using the Neon SQL Editor.

Open:

```text
queries.sql
```

Copy the required SQL query into the Neon SQL Editor and execute it.

---

# 🔄 Migration Workflow

The complete workflow used in this project is:

```text
Create Migration
       ↓
dbmate new migration_name
       ↓
Write SQL
       ↓
dbmate up
       ↓
PostgreSQL / Neon
       ↓
Test Queries
       ↓
Modify Schema
       ↓
Create New Migration
       ↓
dbmate up
```

For rollback:

```text
dbmate down
       ↓
Latest migration rolled back
       ↓
Database returns to previous state
```

---

# 🧠 Concepts Practiced

This project covers the following PostgreSQL and backend database concepts:

* Relational database design
* PostgreSQL
* Cloud PostgreSQL
* Neon
* Database migrations
* Dbmate
* Migration up/down operations
* Primary keys
* Foreign keys
* UUID
* One-to-one relationships
* One-to-many relationships
* Many-to-many relationships
* PostgreSQL ENUM types
* Constraints
* `NOT NULL`
* `UNIQUE`
* `CHECK`
* `ON DELETE CASCADE`
* `ON DELETE RESTRICT`
* `ON DELETE SET NULL`
* Seed data
* Common Table Expressions
* SQL `INSERT`
* SQL `SELECT`
* SQL `UPDATE`
* SQL joins
* Indexes
* PostgreSQL triggers
* Trigger functions
* Timestamps
* Environment variables
* Cloud database connectivity

---

# 🎯 Learning Objective

The main objective of this project is to understand how production-style backend systems manage their databases.

Instead of manually modifying the database schema, changes are tracked through version-controlled migration files.

This makes database changes:

* Repeatable
* Trackable
* Reversible
* Easier to collaborate on
* Suitable for backend application development

---

# 📚 Learning Resource

This project was created while learning backend database concepts through the Backend Principles learning series by Sriniously.

Topics covered include PostgreSQL, database design, migrations, seed data, indexes, triggers, and practical database management.

---

# 👨‍💻 Author

**Sahil Varma**

GitHub: `codedevoty`

LinkedIn: `sahil-varma-0690773ab`

---

## ⭐ Project Status

Learning project — actively used for practicing PostgreSQL and backend database development.

````

### 3. Add `.gitignore` before committing

Because your Neon URL is in `.env`, this is **very important**.

From the `Backend_Principles` folder create:

```text
.gitignore
````

Put:

```gitignore
.env
.env.*
!.env.example
```

You can also create:

```text
.env.example
```

with:

```env
DATABASE_URL=your_neon_postgresql_connection_string
```

This lets someone understand what environment variable is required without exposing your actual Neon credentials.

---

# 4. Commit `postgreSql` to `Backend_Principles`

Since your repository already exists, open PowerShell in:

```text
C:\Users\Prakash\OneDrive\Desktop\Backend_Principles
```

Check:

```powershell
pwd
```

You should get:

```text
C:\Users\Prakash\OneDrive\Desktop\Backend_Principles
```

Then:

### Check Git status

```powershell
git status
```

### Add the PostgreSQL folder

```powershell
git add postgreSql
```

If you created `.gitignore` at the repository root:

```powershell
git add .gitignore
```

Or simply:

```powershell
git add .
```

### Commit

```powershell
git commit -m "Add PostgreSQL and Dbmate learning project"
```

### Push

If your GitHub repository's remote is already configured:

```powershell
git push origin main
```

---

## 5. Verify the remote

If you're not sure whether your local repository is connected to GitHub:

```powershell
git remote -v
```

You should see something similar to:

```text
origin  https://github.com/codedevoty/Backend_Principles.git (fetch)
origin  https://github.com/codedevoty/Backend_Principles.git (push)
```

If nothing appears, add your repository:

```powershell
git remote add origin https://github.com/codedevoty/Backend_Principles.git
```

Then:

```powershell
git branch -M main
git push -u origin main
```

---

### ⚠️ Before `git add .`, check this

Run:

```powershell
git status
```

Make sure you **do not see**:

```text
postgreSql/.env
```

If `.env` appears, **stop** and fix `.gitignore` before pushing. Your Neon connection string contains database credentials and should not be published.

Your GitHub repository will ultimately look like:

```text
Backend_Principles
│
├── postgreSql
│   ├── db
│   │   └── migrations
│   │       ├── create_user_table.sql
│   │       ├── seed_data.sql
│   │       └── indexes_and_triggers.sql
│   │
│   ├── queries.sql
│   └── README.md
│
└── .gitignore
```

Later, you can add your other backend learning projects alongside it, for example:

```text
Backend_Principles/
├── postgreSql/
├── restapi/
├── ...
└── .gitignore
```
