# 🏃 RaceDay - Event Management System

![GitHub Actions](https://github.com/Decent210810/Raceday/actions/workflows/ci-cd.yml/badge.svg)

## 📖 Overview

**RaceDay** is a full-stack web-based event management system designed specifically for the South African road running, walking, and cycling community.

> **Module:** PROG6212 - Programming 2B  
> **Assessment:** POE - Part 1  
> **Year:** 2026

---

## 👥 System Roles

### 🏗️ Organiser
- Create, edit, and delete events
- Manage event categories
- Capture participant results
- View all event enrolments

### 🏃 Participant
- Create an account
- Browse upcoming events
- Enter an event by selecting a category
- View their own enrolments
- Track personal race results

---

## 📂 Part 1: System Planning and Database

| File | Location | Description |
|------|----------|-------------|
| [ERD Diagram](docs/ERD.png) | `/docs/ERD.png` | Entity Relationship Diagram |
| [API Endpoint Plan](docs/API_Endpoint_Plan.md) | `/docs/API_Endpoint_Plan.md` | API endpoint plan |
| [Database Script](docs/Database_Script.sql) | `/docs/Database_Script.sql` | SQL database script |

---

## 🗄️ Database Schema

### Tables (7 Entities)

| # | Table Name | Type | Description |
|---|------------|------|-------------|
| 1 | `User` | Core | Stores user information |
| 2 | `Event` | Core | Stores event details |
| 3 | `EventCategory` | Core | Defines event categories |
| 4 | `Enrolment` | Linking | Links Participants to Events |
| 5 | `Result` | Core | Stores finish times and positions |
| 6 | `EventImage` | Storage | References event banner images |
| 7 | `UserProfileImage` | Storage | References user profile images |

---

## 🤖 CI/CD - GitHub Actions

![Green Build](docs/ci-cd-success.png)

**Workflow File:** `.github/workflows/ci-cd.yml`


## 📋 Submission Checklist

- [x] ERD submitted as PNG in `/docs`
- [x] API Endpoint Plan submitted as MD in `/docs`
- [x] SQL Database Script submitted as `.sql` in `/docs`
- [x] CI/CD workflow validates repository structure
- [x] README includes system description and roles

---

## 📞 Student Information

**Student Name: Engetelo Decent Nukeri  
**Student Number: ST10466215  
**Module Code:** PROG6212/w 2B 

---

## 🚀 Next Steps

- **Part 2:** Build the RESTful API in C#
- **Part 3:** Build the MVC web application and containerize with Docker
