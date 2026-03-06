# API Aggregator

Rails API that fetches user and todos data from [dummyjson.com](https://dummyjson.com) and exposes a consolidated status per user.

Also it saves every fetch as an UserStatus record.

## Description

The application calls the external DummyJSON API (users and todos), combines the data, and returns a **user status** that includes:

- **Full name** (firstName + lastName)
- **Experience** ("Veteran" if age > 50, "Rookie" otherwise)
- **Pending tasks count** (Task where completed = false)
- **Next urgent task** (first uncompleted task)

Results are persisted in PostgreSQL via the `UserStatus` model.

## Requirements

- **Ruby** 3.4.8
- **Rails** 7.2.2.2
- **PostgreSQL** 16

## Setup

### Dependencies

```bash
bundle install
```

### Database

Create and prepare the database:

```bash
bin/rails db:create
bin/rails db:migrate
```

For the test environment:

```bash
bin/rails db:test:prepare
```

### Environment variables

No extra environment variables are required in development for the DummyJSON API (it is public). PostgreSQL connection is configured in `config/database.yml` or via `DATABASE_URL`.

## Running the application

### Locally

```bash
bin/rails server
```

The API will be available at `http://localhost:3000`.

### With Docker

```bash
docker compose up
```

The app is served on port **3000** and PostgreSQL on **5432**. The `app` service installs dependencies and starts the Rails server.

## API

### Health check

- **GET** `/up` — Verifies the application is running (200 if healthy).

### User status

- **GET** `/user_statuses/:id` — Returns the aggregated status for the user with ID `id` (DummyJSON user IDs).

**Sample response (200):**

```json
{
  "id": 1,
  "full_name": "John Doe",
  "experience": "Rookie",
  "pending_tasks_count": 3,
  "next_urgent_task": "Complete report",
  "created_at": "2026-03-06T12:00:00.000Z",
  "updated_at": "2026-03-06T12:00:00.000Z"
}
```

If the user does not exist in DummyJSON, the client raises and the API will propagate the corresponding error.

## Tests

Run the full test suite:

```bash
bin/rails test
```

Includes model unit tests (`UserStatus`).

## Project structure

- `app/controllers/user_statuses_controller.rb` — User status endpoint
- `app/models/user_status.rb` — Model and validations
- `app/services/dummy_client.rb` — HTTP client for dummyjson.com (users, todos)
- `config/routes.rb` — Routes (`/up`, `user_statuses#show`)
- `db/schema.rb` — `user_statuses` schema
