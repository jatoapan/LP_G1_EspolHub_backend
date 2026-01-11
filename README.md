# 📦 Marketplace API Documentation

This API provides a RESTful interface for a marketplace platform, allowing users (Sellers) to register, manage profiles, and post announcements for items. It utilizes **JWT (JSON Web Tokens)** for authentication and standardizes responses using JSON envelopes.

## 🛠 Base Configuration

- **Base URL:** `https://espolhub.onrender.com`
- **API Version:** `v1`
- **Response Format:** JSON
- **Date Format:** ISO 8601 (`YYYY-MM-DDTHH:mm:ss.sssZ`)

---

## 📡 Response Standards

The API uses a unified response structure for success and error states.

### Success Response

Includes a `data` object and an optional `meta` object for pagination.

```json
{
  "data": { ... },
  "meta": {
    "current_page": 1,
    "per_page": 12,
    "total_count": 50,
    "total_pages": 5
  }
}

```

### Error Response

Returns an array of error messages.

```json
{
  "errors": ["Error message 1", "Error message 2"]
}
```

---

## 🔐 Authentication & Security

- **Token Type:** Bearer Token
- **Header:** `Authorization: Bearer <access_token>`
- **Expiration:** Access tokens expire in **3600 seconds** (1 hour). Clients must implement automatic refreshing via the `/refresh` endpoint when receiving a `401 Unauthorized`.

### 1. Login

**POST** `/api/v1/login`

Exchange credentials for access and refresh tokens.

<details>
<summary><strong>View Request & Response</strong></summary>

**Request Body:**

```json
{
  "email": "user@example.com",
  "password": "Password123"
}
```

**Response (200 OK):**

```json
{
  "data": {
    "access_token": "eyJhbGc...",
    "refresh_token": "eyJhbGc...",
    "token_type": "Bearer",
    "expires_in": 3600,
    "seller": {
      "id": "...",
      "type": "seller",
      "attributes": {
        "id": 1,
        "name": "John Doe",
        "faculty": "FIEC",
        "email": "user@example.com",
        "phone": "0912345678",
        "whatsapp_link": "https://wa.me/593912345678",
        "created_at": "2025-01-01T00:00:00.000Z"
      }
    }
  }
}
```

**Error (401):** `{"errors": ["Email o contraseña incorrectos"]}`

</details>

### 2. Refresh Token

**POST** `/api/v1/refresh`

Get a new access token. Requires the **Refresh Token** in the Authorization header.

- **Header:** `Authorization: Bearer <refresh_token>`

<details>
<summary><strong>View Response</strong></summary>

**Response (200 OK):**

```json
{
  "data": {
    "access_token": "eyJhbGc...",
    "token_type": "Bearer",
    "expires_in": 3600
  }
}
```

</details>

### 3. Logout

**DELETE** `/api/v1/logout`

Revoke the current refresh token.

- **Header:** `Authorization: Bearer <refresh_token>`

---

## 👤 Seller Management

### Valid Data Enums

| Field         | Valid Values / Constraints                                                   |
| ------------- | ---------------------------------------------------------------------------- |
| **Faculties** | `FIEC`, `FCNM`, `FIMCP`, `FIMCBOR`, `FCSH`, `FADCOM`, `ESPAE`, `FCV`, `FICT` |
| **Email**     | Unique, valid email format.                                                  |
| **Phone**     | Unique, Ecuadorian format `09XXXXXXXX`.                                      |
| **Password**  | Min 8 chars. Must contain 1 uppercase, 1 lowercase, 1 number.                |
| **Name**      | 2-100 characters.                                                            |

### 4. Register Seller

**POST** `/api/v1/sellers`

Create a new seller account.

<details>
<summary><strong>View Request & Response</strong></summary>

**Request Body:**

```json
{
  "seller": {
    "name": "John Doe",
    "email": "user@example.com",
    "phone": "0912345678",
    "faculty": "FIEC",
    "password": "Password123",
    "password_confirmation": "Password123"
  }
}
```

**Response (201 Created):**

```json
{
  "data": {
    "id": "...",
    "type": "seller",
    "attributes": {
      "id": 1,
      "name": "John Doe",
      "faculty": "FIEC",
      "email": "user@example.com",
      "phone": "0912345678",
      "whatsapp_link": "https://wa.me/593912345678",
      "created_at": "2025-01-01T00:00:00.000Z"
    }
  }
}
```

</details>

### 5. Get Public Profile

**GET** `/api/v1/sellers/:id`

Returns limited public information (excludes email, phone, timestamp).

### 6. Get My Profile 🔒

**GET** `/api/v1/sellers/me`

Returns full profile details for the authenticated user.

### 7. Update Profile 🔒

**PATCH** `/api/v1/sellers/me`

**Request Body:**

```json
{
  "seller": {
    "name": "Updated Name",
    "phone": "0987654321",
    "faculty": "FCNM"
  }
}
```

### 8. Delete Account 🔒

**DELETE** `/api/v1/sellers/me`

Permanently deletes the current seller's account.

### 9. Get Seller Announcements

**GET** `/api/v1/sellers/:id/announcements`

Returns all active announcements belonging to a specific seller ID.

---

## 📢 Announcements

### Query Parameters (Filtering & Pagination)

Applies to List, Search, Popular, and Recent endpoints.

| Parameter     | Description                                  | Default |
| ------------- | -------------------------------------------- | ------- |
| `q`           | Search query (title/description)             | -       |
| `category_id` | Filter by Category ID                        | -       |
| `condition`   | `new_item`, `like_new`, `good`, `acceptable` | -       |
| `min_price`   | Minimum price filter                         | -       |
| `max_price`   | Maximum price filter                         | -       |
| `sort`        | Sort order                                   | -       |
| `page`        | Page number                                  | 1       |
| `per_page`    | Items per page (Max 100)                     | 12      |

### Condition Enums

| Key          | Label       |
| ------------ | ----------- |
| `new_item`   | Nuevo       |
| `like_new`   | Como Nuevo  |
| `good`       | Buen Estado |
| `acceptable` | Aceptable   |

### 10. List Announcements

**GET** `/api/v1/announcements`

Example: `/api/v1/announcements?category_id=1&min_price=100&max_price=500`

### 11. Search Announcements

**GET** `/api/v1/announcements/search`

Alternative to using `?q=` on the index endpoint.

### 12. Popular Announcements

**GET** `/api/v1/announcements/popular`

Sorted by view count descending.

### 13. Recent Announcements

**GET** `/api/v1/announcements/recent`

Sorted by creation date descending.

### 14. Get Single Announcement

**GET** `/api/v1/announcements/:id`

Retrieves details, includes relationships (Seller, Category), and **automatically increments the view count**.

### 15. Create Announcement 🔒

**POST** `/api/v1/announcements`

**Content-Type:** `multipart/form-data`

**Validations:**

- **Title:** 5-150 chars
- **Description:** Max 2000 chars
- **Price:** > 0, Max 100,000
- **Images:** Max 5 files, Max 5MB each. Formats: JPEG, PNG, WebP.

**Form Data Fields:**

- `announcement[title]`
- `announcement[description]`
- `announcement[price]`
- `announcement[condition]` (See enums above)
- `announcement[category_id]`
- `announcement[location]` (Optional)
- `images[]` (Array of files)

### 16. Update Announcement 🔒

**PATCH** `/api/v1/announcements/:id`

**Content-Type:** `multipart/form-data`
Only the owner can update. All fields are optional.

### 17. Delete Announcement 🔒

**DELETE** `/api/v1/announcements/:id`

Only the owner can delete.

### 18. Increment Views

**PATCH** `/api/v1/announcements/:id/increment_views`

Manually increments view count (usually not needed as GET handles this).

### 19. Reserve Item 🔒

**PATCH** `/api/v1/announcements/:id/reserve`

Marks status as reserved.

### 20. Mark as Sold 🔒

**PATCH** `/api/v1/announcements/:id/mark_as_sold`

Marks status as sold.

---

## 📂 Categories

### 21. List Categories

**GET** `/api/v1/categories`

Returns all categories with their icon and active announcement counts.

<details>
<summary><strong>View Response</strong></summary>

```json
{
  "data": [
    {
      "id": "...",
      "type": "category",
      "attributes": {
        "id": 1,
        "name": "Electronics",
        "description": "Electronic devices and accessories",
        "icon": "📱",
        "active": true,
        "announcements_count": 25
      }
    }
  ]
}
```

</details>

### 22. Get Category

**GET** `/api/v1/categories/:id`

### 23. Get Category Items

**GET** `/api/v1/categories/:category_id/announcements`

Returns paginated announcements for a specific category.

---

## 🏥 System

### 24. Health Check

**GET** `/health`

Returns `200 OK`. Used for load balancers and uptime checks.

---

## ⚠️ Important Integration Notes

1. **Image Paths:**
   The API returns **relative paths** for images (e.g., `/rails/active_storage/...`).
   You must prepend the Base URL:
   `const fullUrl = 'https://espolhub.onrender.com' + image_url;`
2. **Authorization Logic:**
   Endpoints marked with 🔒 require a valid Access Token. Some actions (Update/Delete) utilize **Pundit policies** on the server side to ensure users can only modify their own resources.
3. **File Uploads:**
   Always use `FormData` objects when creating or updating announcements containing images. Do not send JSON for these requests.
