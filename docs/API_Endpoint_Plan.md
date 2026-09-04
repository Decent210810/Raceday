# RaceDay API Endpoint Plan

## Authentication & User Management

| HTTP Method | Route | Description | Role Required | Request Body | Expected Response |
|-------------|-------|-------------|---------------|--------------|-------------------|
| POST | `/api/auth/register` | Register a new user | None | `{ "email": "string", "password": "string", "fullName": "string", "dateOfBirth": "yyyy-MM-dd", "role": "Organiser|Participant" }` | `201 Created` - User object <br/> `400 Bad Request` - Validation errors <br/> `409 Conflict` - Email already exists |
| POST | `/api/auth/login` | Authenticate user and create session | None | `{ "email": "string", "password": "string" }` | `200 OK` - User with role <br/> `401 Unauthorized` - Invalid credentials |

## User Profile

| HTTP Method | Route | Description | Role Required | Request Body | Expected Response |
|-------------|-------|-------------|---------------|--------------|-------------------|
| GET | `/api/users/{id}` | Get user profile by ID | Any Authenticated | None | `200 OK` - User details <br/> `404 Not Found` - User not found |
| PUT | `/api/users/{id}` | Update own profile | Any Authenticated | `{ "fullName": "string", "dateOfBirth": "yyyy-MM-dd", "email": "string" }` | `200 OK` - Updated user <br/> `403 Forbidden` - Cannot update another user |

## Events

| HTTP Method | Route | Description | Role Required | Request Body | Expected Response |
|-------------|-------|-------------|---------------|--------------|-------------------|
| GET | `/api/events` | Get all events with filtering | Any | None | `200 OK` - Paginated list of events |
| GET | `/api/events/{id}` | Get specific event by ID | Any | None | `200 OK` - Full event details <br/> `404 Not Found` - Event not found |
| POST | `/api/events` | Create a new event | Organiser | `{ "name": "string", "description": "string", "eventDate": "datetime", "location": "string", "distance": 10.5, "eventType": "run|walk|cycle" }` | `201 Created` - Created event <br/> `400 Bad Request` - Validation errors <br/> `403 Forbidden` - Not an Organiser |
| PUT | `/api/events/{id}` | Update an existing event | Organiser | Same as POST | `200 OK` - Updated event <br/> `403 Forbidden` - Not the event organiser <br/> `404 Not Found` - Event not found |
| DELETE | `/api/events/{id}` | Delete an event | Organiser | None | `204 No Content` - Deleted <br/> `409 Conflict` - Has enrolments |
| PUT | `/api/events/{id}/banner` | Upload event banner image | Organiser | Multipart form: `bannerImage` | `200 OK` - Updated with image URL <br/> `400 Bad Request` - Invalid file |

## Categories

| HTTP Method | Route | Description | Role Required | Request Body | Expected Response |
|-------------|-------|-------------|---------------|--------------|-------------------|
| GET | `/api/events/{eventId}/categories` | Get all categories for an event | Any | None | `200 OK` - List of categories |
| POST | `/api/events/{eventId}/categories` | Create a new category | Organiser | `{ "categoryName": "string", "description": "string" }` | `201 Created` - Category object |
| PUT | `/api/categories/{id}` | Update a category | Organiser | `{ "categoryName": "string", "description": "string" }` | `200 OK` - Updated category |
| DELETE | `/api/categories/{id}` | Delete a category | Organiser | None | `204 No Content` - Deleted <br/> `409 Conflict` - Has enrolments |

## Enrolments

| HTTP Method | Route | Description | Role Required | Request Body | Expected Response |
|-------------|-------|-------------|---------------|--------------|-------------------|
| POST | `/api/enrolments` | Enrol in an event | Participant | `{ "eventId": 1, "categoryId": 1 }` | `201 Created` - Enrolment object <br/> `409 Conflict` - Already enrolled |
| GET | `/api/enrolments/my` | Get my enrolments | Participant | None | `200 OK` - List of enrolments |
| GET | `/api/events/{eventId}/enrolments` | Get all enrolments for an event | Organiser | None | `200 OK` - Paginated list of enrolments |
| PUT | `/api/enrolments/{id}/status` | Update enrolment status | Organiser | `{ "status": "confirmed|pending|withdrawn" }` | `200 OK` - Updated enrolment |
| DELETE | `/api/enrolments/{id}` | Withdraw from an event | Participant or Organiser | None | `204 No Content` - Withdrawn |

## Results

| HTTP Method | Route | Description | Role Required | Request Body | Expected Response |
|-------------|-------|-------------|---------------|--------------|-------------------|
| POST | `/api/events/{eventId}/results` | Capture results for participants | Organiser | `[ { "enrolmentId": 1, "finishTime": "01:30:45", "finishingPosition": 42 } ]` | `201 Created` - Results created |
| GET | `/api/results/my` | Get my results | Participant | None | `200 OK` - List of results |
| GET | `/api/events/{eventId}/results` | Get all results for an event | Any Authenticated | None | `200 OK` - List of results |
| PUT | `/api/results/{id}` | Update a specific result | Organiser | `{ "finishTime": "01:30:45", "finishingPosition": 42 }` | `200 OK` - Updated result |
| DELETE | `/api/results/{id}` | Delete a result | Organiser | None | `204 No Content` - Deleted |

## Endpoint Summary

| Resource | GET | POST | PUT | DELETE |
|----------|-----|------|-----|--------|
| Auth | - | Register, Login | - | Logout |
| Users | View | - | Update | - |
| Events | View all, View one | Create | Update | Delete |
| Categories | View | Create | Update | Delete |
| Enrolments | View my, View event | Create | Update status | Withdraw |
| Results | View my, View event | Create | Update | Delete |
