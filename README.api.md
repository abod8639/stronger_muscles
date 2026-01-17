# Stronger Muscles API Documentation 🚀

This document provides the necessary information for integrating the **Mobile App (Flutter)** and **Admin Dashboard** with the backend.

---

## 📌 General Information

### 🌐 Base URLs
- **Development (Local):** `http://192.168.1.17:8080/api/v1`
- **Production:** `https://api.strongermuscles.com/api/v1`

### 🔑 Authentication
The API uses **Laravel Sanctum** for authentication.
- All protected routes require a `Bearer {token}` in the `Authorization` header.
- Headers required:
  ```http
  Accept: application/json
  Authorization: Bearer {your_token}
  ```

---

## 🛠 Authentication Endpoints

### 1. Login
- **URL:** `POST /auth/login`
- **Body:**
  ```json
  {
    "email": "user@example.com",
    "password": "password123"
  }
  ```
- **Response:**
  ```json
  {
    "status": "success",
    "token": "12|v8...token...v8",
    "user": { "id": "uuid", "name": "John Doe", ... }
  }
  ```

### 2. Google Sign-In
- **URL:** `POST /auth/google-signin`
- **Body:** `{ "email": "...", "name": "...", "photo_url": "..." }`

---

## 📦 Data Models

### 🍎 Category
```json
{
  "id": "slug-or-uuid",
  "name": "Whey Protein",
  "description": "Premium protein supplements",
  "imageUrl": "https://api.../categories/image.png",
  "sortOrder": 1,
  "isActive": true
}
```

### 💊 Product
```json
{
  "id": "uuid",
  "name": "Gold Standard Whey",
  "price": 2500.00,
  "discountPrice": 2200.00,
  "imageUrls": ["url1", "url2"],
  "description": "Best protein",
  "categoryId": "category-id",
  "stockQuantity": 50,
  "averageRating": 4.5,
  "brand": "Optimum Nutrition",
  "servingSize": "30g",
  "servingsPerContainer": 70,
  "flavors": ["Chocolate", "Vanilla"],
  "isActive": true
}
```

---

## 🛒 Shop & Catalog (Public)

- `GET /shop/categories`: List all active categories.
- `GET /shop/categories/{id}`: Show specific category.
- `GET /shop/products`: List all active products.
  - **Query Params:** `?category={id}&search={keyword}&page=1`
- `GET /shop/products/{id}`: Product details.

---

## 👤 Customer API (Protected)

- `GET /customer/profile`: Get current user profile and addresses.
- `POST /auth/update-profile`: Update name, email, phone, and addresses.
- `GET /customer/cart`: Get user's cart items.
- `POST /customer/cart`: Add/Update item in cart.
- `GET /customer/orders`: List user's order history.
- `POST /customer/orders`: Place a new order (Implementation pending).

---

## ⚙️ Admin Dashboard API (Protected + Admin Only)

- `GET /admin/products`: List all products (including inactive).
- `POST /admin/products`: Create new product.
- `PUT /admin/products/{id}`: Update product details.
- `DELETE /admin/products/{id}`: Delete product.
- `GET /admin/orders`: List all customer orders.
- `PATCH /admin/orders/{id}`: Update order status (`pending`, `processing`, `shipped`, `delivered`, `cancelled`).
- `GET /admin/users`: List all registered users.

### 🖼 Image Uploads (Admin)
- `POST /admin/upload/product-image`: Upload image for product.
- `POST /admin/upload/category-image`: Upload image for category.
- **Request:** `Multipart/form-data` with field `image`.

---

## ⚠️ Error Handling

Errors return a JSON object with `errors` or `message`.
- `401 Unauthorized`: Token missing or invalid.
- `403 Forbidden`: User is not an admin (for admin routes).
- `422 Unprocessable Entity`: Validation failed.
  ```json
  {
    "errors": { "email": ["The email field is required."] }
  }
  ```
- `404 Not Found`: Resource does not exist.
