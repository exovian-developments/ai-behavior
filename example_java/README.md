# Spring Boot Authentication Service Example

This directory demonstrates how **ai-behavior** schemas work in a Java Spring Boot microservice.

## About This Example

**Project:** JWT Authentication Microservice
**Stack:** Spring Boot 3 + Java 17 + Spring Security
**Architecture:** Layered Architecture (Controller → Service → Repository)

### What's Demonstrated

1. **Project Manifest** (`ai_files/project_manifest.json`)
   - Spring Boot microservice architecture
   - JWT-based authentication system
   - REST API design

2. **Project Rules** (`ai_files/project_rules.json`)
   - Java/Spring best practices
   - Layer-specific conventions
   - Security patterns

3. **Development Logbook** (`ai_files/logbooks/AUTH-001.json`)
   - JWT authentication implementation
   - Spring Security configuration workflow

## Structure

```
example_java/
├── ai_files/
│   ├── schemas/
│   ├── logbooks/
│   │   └── AUTH-001.json
│   ├── project_manifest.json
│   ├── project_rules.json
│   └── user_pref.json
├── src/main/java/com/example/auth/
│   ├── controller/
│   ├── service/
│   ├── repository/
│   ├── security/
│   └── dto/
├── pom.xml
└── README.md
```

---

**Part of ai-behavior examples**
https://github.com/exovian-developments/ai-behavior
