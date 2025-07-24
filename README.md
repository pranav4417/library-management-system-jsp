# 📚 Library Management System (Java + JSP + MySQL)

A full-stack web-based Library Management System built using **Java**, **JSP**, **Servlets**, and **MySQL**. This project allows users to register, log in, borrow books, view their borrowed books, and lets the admin manage book inventory and user records.

---

## 🚀 Features

- 👤 User Registration and Login
- 🔐 Secure Session-Based Authentication
- 📖 View Available Books
- 📥 Borrow & Return Books
- 🧾 User Dashboard with Borrowed Book History
- 📧 Email Update Feature
- 📊 Admin Dashboard (books & user management)
- ☁️ MySQL Database Integration

---

## 🛠️ Tech Stack

| Layer         | Technology                  |
|---------------|------------------------------|
| Frontend      | HTML, CSS, JSP               |
| Backend       | Java, Servlets, JDBC         |
| Database      | MySQL                        |
| Web Server    | Apache Tomcat                |
| IDE           | Eclipse / IntelliJ / NetBeans|

---

---

## 🧪 How to Run the Project Locally

### ✅ Prerequisites

- Java JDK 8+
- MySQL
- Apache Tomcat 9+
- Eclipse / IntelliJ / NetBeans
- MySQL Workbench (optional)

### 🧩 Setup Instructions
⚙️ Configure in Eclipse (or your IDE)
Import project as Dynamic Web Project

Link Apache Tomcat in the project

Place all .jsp files in WebContent/

Place your .java servlet files under src/ package

Add MySQL JDBC Driver to project build path:

Download MySQL Connector/J

Add mysql-connector-java-x.x.xx.jar to project's lib folder

Update DB credentials in JSP/Servlet files as needed
### Database Creation
CREATE DATABASE librarydb;
USE librarydb;
-- Table to store users
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    email VARCHAR(100) NOT NULL
);

-- Table to store available books
CREATE TABLE books (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(100),
    author VARCHAR(100),
    genre VARCHAR(50),
    quantity INT
);

-- Table to track borrowed books
CREATE TABLE borrowed_books (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL,
    book_title VARCHAR(100) NOT NULL,
    borrowed_date DATE
);
### Configure Database in Project
Connection con = DriverManager.getConnection(
    "jdbc:mysql://localhost:3306/librarydb", "your-name", "your-password");


