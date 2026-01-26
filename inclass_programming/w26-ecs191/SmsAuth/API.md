# SMS Login API Documentation

Base URL: `https://ecs191-sms-authentication.uc.r.appspot.com` (production) or `http://localhost:5001` (local)

## Authentication

After successful verification, the API returns a session token. Include this token in subsequent requests using the `Authorization` header:

```
Authorization: Bearer <token>
```

---

## Endpoints

### POST /v1/send_sms_code

Send a verification code to a phone number via SMS.

**Request**

```json
{
  "phone_number": "+14155551234",
  "app_id": "app_id_as42fasd432asgrt"
}
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| phone_number | string | Yes | Phone number in E.164 format (e.g., +14155551234) |
| app_id | string | Yes | the app ID for this verification |

**Response**

Success (200):
```json
{
  "success": true
}
```

Errors:

| Status | Response | Description |
|--------|----------|-------------|
| 400 | `{"error": "phone_number is required"}` | Missing phone_number field |
| 400 | `{"error": "app_id is required"}` | Missing app_id field |
| 400 | `{"error": "Invalid phone number format. Use E.164 format (e.g., +14155551234)"}` | Phone number not in E.164 format |

**Example**

```bash
curl -X POST http://localhost:5001/v1/send_sms_code \
  -H "Content-Type: application/json" \
  -d '{"phone_number": "+14155551234", "app_id": "app_id_aw24asdfq234"}'
```

---

### POST /v1/verify_code

Verify the SMS code and receive a session token.

**Request**

```json
{
  "phone_number": "+14155551234",
  "app_id": "app_id_wqerasde432ads"
  "code": "123456"
}
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| phone_number | string | Yes | Phone number that received the code |
| app_id | string | Yes | The app ID for this user |
| code | string | Yes | 6-digit verification code from SMS |

**Response**

Success (200):
```json
{
  "success": true,
  "token": "abc123...",
  "user_id": "user_aweragasder"
}
```

| Field | Type | Description |
|-------|------|-------------|
| success | boolean | Always true on success |
| token | string | Session token for authenticating future requests |
| user_id | string | A unique identifier for this user |

Errors:

| Status | Response | Description |
|--------|----------|-------------|
| 400 | `{"error": "phone_number, app_id, and code are required"}` | Missing required fields |
| 401 | `{"error": "Invalid or expired code"}` | Code doesn't match or has expired (5 min TTL) |

**Example**

```bash
curl -X POST http://localhost:5001/v1/verify_code \
  -H "Content-Type: application/json" \
  -d '{"phone_number": "+14155551234", "code": "123456", "app_id": "app_id_asd423asdf"}'
```

---

### GET /v1/user

Get the authenticated user's information.

**Headers**

| Header | Required | Description |
|--------|----------|-------------|
| Authorization | Yes | Bearer token from verify_code response |

**Response**

Success (200):
```json
{
  "user_id": "user_id_asd234asdf",
  "created_at": "2025-01-13T12:00:00+00:00"
}
```

| Field | Type | Description |
|-------|------|-------------|
| user_id | string | User's unique identifier |
| created_at | string | ISO 8601 timestamp of account creation |

Errors:

| Status | Response | Description |
|--------|----------|-------------|
| 401 | `{"error": "Authorization header required"}` | Missing or malformed Authorization header |
| 401 | `{"error": "Invalid token"}` | Token not found or expired |
| 404 | `{"error": "User not found"}` | User record was deleted |

**Example**

```bash
curl http://localhost:5001/v1/user \
  -H "Authorization: Bearer abc123..."
```

---

## Phone Number Format

All phone numbers must be in [E.164 format](https://en.wikipedia.org/wiki/E.164):

- Starts with `+`
- Country code (1-3 digits)
- Subscriber number
- No spaces, dashes, or parentheses

**Examples:**
- US: `+14155551234`
- UK: `+442071234567`
- Germany: `+4930123456`

---

## Error Response Format

All errors return a JSON object with an `error` field:

```json
{
  "error": "Description of what went wrong"
}
```

---

## Rate Limits

Currently no rate limits are enforced. For production use, consider implementing rate limiting on the `/v1/send_sms_code` endpoint to prevent SMS abuse.

---

## Food Analysis APIs

These endpoints allow authenticated users to upload food images and receive nutritional estimates.

### GET /v1/food/upload_url

Get a signed URL for uploading a food image to Google Cloud Storage.

**Headers**

| Header | Required | Description |
|--------|----------|-------------|
| Authorization | Yes | Bearer token from verify_code response |

**Response**

Success (200):
```json
{
  "upload_url": "https://storage.googleapis.com/ecs191-login-bucket/...",
  "image_id": "a1b2c3d4-e5f6-7890-abcd-ef1234567890.jpg"
}
```

| Field | Type | Description |
|-------|------|-------------|
| upload_url | string | Signed URL for PUT request to upload image (valid for 10 minutes) |
| image_id | string | URL-safe unique identifier for the image (UUID format with .jpg extension) |

Errors:

| Status | Response | Description |
|--------|----------|-------------|
| 401 | `{"error": "Authorization header required"}` | Missing or malformed Authorization header |
| 401 | `{"error": "Invalid token"}` | Token not found or expired |

**Example**

```bash
curl http://localhost:5001/v1/food/upload_url \
  -H "Authorization: Bearer abc123..."
```

**Uploading the Image**

After receiving the signed URL, upload your JPEG image using a PUT request:

```bash
curl -X PUT \
  -H "Content-Type: image/jpeg" \
  --data-binary @food_photo.jpg \
  "https://storage.googleapis.com/ecs191-login-bucket/..."
```

---

### GET /v1/food/analyze/{image_id}

Analyze a previously uploaded food image and return nutritional estimates.

**Headers**

| Header | Required | Description |
|--------|----------|-------------|
| Authorization | Yes | Bearer token from verify_code response |

**Path Parameters**

| Parameter | Type | Description |
|-----------|------|-------------|
| image_id | string | The URL-safe image ID returned from the upload_url endpoint |

**Response**

Success (200):
```json
{
  "calories": 650,
  "carbohydrates_grams": 45,
  "protein_grams": 35,
  "description": "Burger and fries",
  "image_id": "a1b2c3d4-e5f6-7890-abcd-ef1234567890.jpg",
  "confidence": "high"
}
```

| Field | Type | Description |
|-------|------|-------------|
| calories | integer | Estimated calories in the meal |
| carbohydrates_grams | integer | Estimated carbohydrates in grams |
| protein_grams | integer | Estimated protein in grams |
| description | string | Brief description of the food identified |
| image_id | string | The image ID that was analyzed |
| confidence | string | Confidence level in the estimate: "high", "medium", or "low" |

Errors:

| Status | Response | Description |
|--------|----------|-------------|
| 401 | `{"error": "Authorization header required"}` | Missing or malformed Authorization header |
| 401 | `{"error": "Invalid token"}` | Token not found or expired |
| 404 | `{"error": "Image not found"}` | Image ID does not exist in storage |
| 400 | `{"error": "Invalid image format"}` | Uploaded file is not a valid JPEG image |
| 400 | `{"error": "Could not analyze image: <reason>"}` | Image does not contain food, is too blurry, or food is too obscured |
| 502 | `{"error": "Analysis service error: <details>"}` | Anthropic API returned an error |

**Example**

```bash
curl "http://localhost:5001/v1/food/analyze/a1b2c3d4-e5f6-7890-abcd-ef1234567890.jpg" \
  -H "Authorization: Bearer abc123..."
```
