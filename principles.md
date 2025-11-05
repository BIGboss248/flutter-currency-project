# Coding principles and standards

This file will explain coding principles and standards to follow developing. This file is created with the help of chatgpt visit the following [this link](https://chatgpt.com/share/68cfb7df-206c-8012-a896-bb8b9a6a5d4c) to see the full chat

## 1. **Code Quality & Readability**

Clean Code Principles (Robert C. Martin’s guidelines):

- Use meaningful names for variables, functions, and classes.

- Functions should do one thing only (single responsibility).

- Keep functions and classes small.

- Avoid duplication (DRY: Don’t Repeat Yourself).

- Follow a style guide (e.g., PEP8 for Python, Go fmt for Golang, ESLint/Prettier for JS/TS).

- Use comments and docstrings only where necessary (self-documenting code is better).

## 2. **Architecture & Design Principles**

### SOLID principles (object-oriented)

#### **S**ingle Responsibility Principle

A class/module should have one reason to change (i.e., only one job).

#### **O**pen/Closed Principle

Software entities should be open for extension but closed for modification.

#### **L**iskov Substitution Principle

Objects of a subclass should be replaceable with objects of their parent class without breaking the system.

#### **I**nterface Segregation Principle

Clients should not be forced to depend on interfaces they don’t use.

#### **D**ependency Inversion Principle

Depend on abstractions (interfaces), not on concrete implementations.

### Separation of concerns

keep business logic, presentation, and data handling separate.

Meaning splitting a program into distinct sections, where each section addresses a specific concern (responsibility) and doesn’t mix with others.A concern = anything the program is responsible for, like:

- Handling user input

- Validating data

- Business logic

- Database access

- Rendering UI

- Logging and monitoring

### Develop program modularly

means your program is broken into small, self-contained units (modules, packages, or services).

Each module should:

- Do one thing well.

- Be reusable in other parts of the system (or even other projects).

- Have a clear interface (public functions, methods, or APIs) while hiding internal details.

### Loosely Coupled Components

**Coupling**: how much one part of your code depends on another part.

**Loosely coupled**: means components know as little as possible about each other.

This makes your system:

- Easier to change (swap implementations).

- Easier to test (mock dependencies).

- Easier to scale (independent growth of modules).

### Think in layers (API layer, service layer, data layer)

#### API Layer (Presentation Layer)

**What it does**: Handles external requests (HTTP, gRPC, CLI, UI).

**Responsibilities**:

- Parse input (e.g., JSON → Go struct).

- Call the right service method.

- Format and send responses (JSON, HTML, etc.).

#### Service Layer (Business Logic Layer)

**What it does**: Contains core business rules of the app.

**Responsibilities**:

- Validate inputs.

- Apply business policies (e.g., “email must be unique”).

- Orchestrate workflows (e.g., register a user → save to DB → send welcome email).

#### Data Layer (Persistence Layer)

**Responsibilities**:

- Save, query, update, delete.

- Encapsulate SQL/ORM/driver logic.

Now the way it works is that API layer calls service layer -> service layer calls data layer -> data layer returns results this is the flow:

      Client → API → Service → Data → Database

## 3.  **Version control and collaboration**

1. Always use Git (or another VCS).

2. Write clear commit messages.

3. ### Follow a branching strategy (GitFlow, trunk-based, etc.)

#### GitFlow (classic)

 Idea: Use multiple long-lived branches for different purposes.

 Branches:

- main → always production-ready.

- develop → integration branch where features are merged.

- feature/* → for new features.

- release/* → prep branch for testing before merging into main.

- hotfix/* → quick fixes for production.

#### Trunk-Based Development (modern, used at Google, Facebook, etc.)

Everyone commits to main (trunk) frequently — daily or even multiple times a day.

#### GitHub Flow (lightweight)

Idea: Simple branching for continuous deployment.

Flow:

- main is always deployable.

- For new work → create a feature branch from main.

- Open a Pull Request → review & test.

- Merge back to main → deploy immediately.

### Use code reviews and pull requests

## 4. **Testing**

### Write **unit tests** for small components

Unit tests are small, automated tests that check if an individual piece of code (a “unit”) works correctly.

A unit is usually:

- A single function

- A method in a class

- A small module

### Add **integration tests** for interactions between modules

- Integration tests check how multiple components of your system work together.

- Instead of testing a single function in isolation, you test the interaction between modules, layers, or external systems.

- Goal: make sure the units integrate correctly.

### Use **end-to-end tests** for critical workflows

- E2E tests simulate real user behavior from start to finish.

- They test the entire system, including:

  - Frontend (UI, CLI, or API client).

  - Backend services.

  - Database, APIs, third-party services.

- Goal: ensure the system works as a whole, the same way a real user would experience it.

### Follow **TDD/BDD** if suitable

- Test driven delepoment

  - A development workflow where you write tests before writing the actual code.

  - Based on the Red → Green → Refactor cycle:

    - Red: Write a failing test (because code doesn’t exist yet).

    - Green: Write just enough code to make the test pass.

    - Refactor: Clean up code while keeping tests green.

- Behavior-Driven Development (BDD)

  - An evolution of TDD that focuses on business behavior and user stories.

  - Instead of low-level tests, you describe features in a human-readable way (often using Gherkin syntax: Given / When / Then).

  - Goal: make tests understandable to non-programmers (like QA or business analysts).

### Automate tests in CI/CD

---

## 5. **Documentation**

- Maintain **README.md** with setup, usage, deployment instructions.

- Document **API contracts** (Swagger/OpenAPI/GraphQL schema).

- Keep **inline docs** (docstrings, comments for complex logic).

- Update docs with every major change.

---

## 6. **Security & Reliability**

### Follow **security best practices** (input validation, sanitization, authentication, encryption)

#### Input Validation

- What it is: Checking that the data coming into your system meets the expected format, type, and range.

#### Input Sanitization

- What it is: Cleaning or escaping input to remove potentially dangerous content.

#### Authentication

- What it is: Verifying the identity of users or systems.

#### Encryption

- What it is: Converting data into a secure format that unauthorized parties cannot read.

### Keep dependencies updated

#### Why Keeping Dependencies Updated Matters

##### Security 🔒

- Old versions may have known vulnerabilities.

- Attackers can exploit these if you don’t update.

##### Bug Fixes 🐞

- Updates often fix bugs and crashes in libraries.

##### New Features ✨

- Updating gives you access to performance improvements and new functionality.

##### Compatibility ⚙️

- Old libraries may break with newer versions of the language or other libraries.

#### How to updated dependencies

- Pin versions to avoid unexpected breaking changes

- Test after upgrading → unit, integration, and E2E tests ensure nothing breaks.

- Monitor vulnerabilities using services like GitHub Security Alerts

### Handle **errors and exceptions** gracefully

- What Does “Handle Errors Gracefully” Mean?

  - Never ignore errors — always anticipate and manage potential failures.

  - Provide meaningful feedback instead of crashing or exposing sensitive information.

  - Keep the application stable and predictable even when something goes wrong.

- Best Practices

  - Always log the error (developer needs info) and return a friendly message (user sees simple explanation).

  - Don’t expose stack traces or internal data to end users.

  - Avoid panic unless absolutely necessary — prefer returning errors.

  - Handle errors close to where they occur, and propagate them if needed.

### Log important events for monitoring/debugging

#### What Does “Log Important Events” Mean?

- Record **significant events, actions, or errors** that happen during your program’s execution.

- Logs help developers and operators **understand what the system is doing**, troubleshoot issues, and monitor performance.

#### 🔹 Why Logging Matters

1. **Debugging** 🐞

   - When something goes wrong, logs tell you **where and why**.

2. **Monitoring** 📊

   - Track system health, performance metrics, or unusual behavior.

3. **Auditing & Compliance** 🔒

   - Maintain a history of user actions or critical operations.

4. **Alerting** ⚠️

   - Integrate logs with alert systems (e.g., errors trigger notifications).

#### 🔹 What to Log

##### Important Things to Log

- **Errors & exceptions** → failures, crashes, panics.

- **Critical user actions** → login, transactions, configuration changes.

- **System events** → startup, shutdown, deployment, resource usage spikes.

- **Security-related events** → authentication failures, permission changes.

- **Performance metrics** → request latency, DB query times.

---

##### What NOT to Log

- Sensitive info like passwords, private keys, or full credit card numbers.

- Excessive debug logs in production (can overwhelm storage and obscure important events).

#### Logging Best Practices

1. Use **structured logging** (JSON) for easier searching and analysis.

2. Include **timestamps, severity, and context** (user ID, request ID, module).

3. Send logs to a **centralized system** (ELK Stack, Prometheus, Datadog, etc.).

4. Rotate and archive logs to prevent storage issues.

5. Combine logs with **monitoring & alerting** for proactive issue detection.

---

## 7. **Scalability & Performance**

### Write code with **asynchronous/non-blocking patterns** where needed

#### What “Asynchronous / Non-Blocking” Means

- **Synchronous (blocking)**: Each operation waits for the previous one to finish.

  - Example: Reading a file or fetching data blocks the program until done.

- **Asynchronous / Non-blocking**: The program can **continue executing other tasks** while waiting for an operation to complete.

**Goal:** Avoid idle waiting, improve responsiveness, and make programs more scalable.

#### Why Use Asynchronous / Non-Blocking Patterns

1. **Responsiveness** – e.g., a UI doesn’t freeze while loading data.

2. **Scalability** – servers can handle many requests without creating new threads for each one.

3. **Efficiency** – CPU can do other work while waiting for I/O or network operations.

#### When to Use Asynchronous Patterns

- **I/O-bound tasks:** database queries, API calls, file reads/writes.

- **High-concurrency systems:** web servers, message queues.

- **Background tasks:** email sending, notifications, batch processing.

#### Asynchronous Best Practices

1. Don’t overuse concurrency — it adds complexity and potential race conditions.

2. Always **handle errors** in asynchronous operations.

3. Use **timeouts or cancellation** for long-running operations.

4. Log async tasks for debugging.

5. Test concurrency carefully.

### Use **caching** strategies

#### 🔹 What Is Caching?

- **Caching** = storing the result of a computation or a data fetch **temporarily**, so future requests can be served **faster**.

- Instead of repeatedly fetching from a database, API, or computing a value, you **reuse a stored copy**.

**Goal:** Reduce latency, decrease load on resources, and improve user experience.

#### 🔹 Why Use Caching?

1. **Performance** ⚡

   - Serve frequently requested data instantly instead of recomputing or refetching.

2. **Scalability** 📈

   - Reduce load on databases, APIs, or backend services.

3. **Cost efficiency** 💰

   - Fewer database queries or API calls reduce infrastructure costs.

4. **Better User Experience** 🌟

   - Fast responses improve responsiveness, especially for high-traffic systems.

#### 🔹 Common Caching Strategies

##### 1. **In-Memory Cache**

- Stores data in the application’s memory.

- Fastest type of cache.

- Example in Go:

```go

var cache = make(map[string]string)

  

func getUserName(userID string) string {

    if name, ok := cache[userID]; ok {

        return name // return cached value

    }

    name := fetchFromDB(userID)

    cache[userID] = name // store in cache

    return name

}

```

##### 2. **Distributed Cache**

- Shared cache across multiple servers (e.g., Redis, Memcached).

- Used when multiple instances of an application need to share cached data.

##### 3. **Cache Invalidation**

- Cached data can become stale. Strategies to handle this:

  1. **Time-based expiration (TTL)** – cache expires after a set time.

  2. **Event-based invalidation** – cache updates when the underlying data changes.

  3. **Manual eviction** – explicitly remove outdated cache.

##### 4. **Cache Granularity**

- **Full-page caching** – entire webpage stored in cache.

- **Fragment caching** – only parts of the page or data are cached.

- **Object caching** – individual database objects or API responses cached.

## 🔹 Best Practices

1. Cache only **frequently accessed or expensive-to-compute data**.

2. Always consider **cache consistency** — ensure data isn’t stale.

3. Use a **fallback** if cache misses occur.

4. Monitor **cache hit/miss ratio** to optimize performance.

5. Secure sensitive cached data, especially in shared caches.

### Optimize **database queries**

#### What is it

Writing queries that run efficiently and use minimal resources while returning correct results.

Goal: reduce latency, CPU/memory usage, and database load.

#### How to optimize queries

##### Use Indexes

Indexes speed up lookups for frequently queried columns.

```sql

CREATE INDEX idx_user_email ON users(email);

```

Be careful: too many indexes can slow inserts/updates.

##### Select Only Needed Columns

##### Use Proper Joins

Prefer INNER JOIN over CROSS JOIN if possible.

Make sure join columns are indexed.

##### Filter early

Use WHERE clauses to reduce the number of rows processed.

##### Avoid N + 1 problem

Fetch related data in bulk instead of in a loop.

```sql

// Bad: query DB inside a loop

for _, user := range users {

    db.Query("SELECT orders FROM orders WHERE user_id=?", user.ID)

}

  

// Good: join or IN query

db.Query("SELECT * FROM orders WHERE user_id IN (?, ?, ?)", userIDs)

```

##### Limit & Paginate

Don’t fetch thousands of rows at once; use LIMIT and OFFSET.

```sql

SELECT * FROM orders ORDER BY created_at DESC LIMIT 50 OFFSET 0;

```

##### Use Query Caching

Cache results of expensive queries (Redis, Memcached).

##### Analyze & Explain Queries

Use database tools to see query plans

```sql

EXPLAIN SELECT * FROM users WHERE email='test@example.com';

```

---

## 8. **DevOps & Deployment**

### What is deployment

the process of taking your code from development and releasing it into a live environment (production).

### Deployment strategies

#### Manual Deployment

Upload code/files manually to the server Risky: prone to human error.

#### Automated Deployment

CI/CD tools (GitHub Actions, GitLab CI, Jenkins, ArgoCD) deploy automatically after tests pass.

#### Blue-Green Deployment

two identical environments (blue & green). One live, one updated. Switch traffic after tests.

#### Canary Deployment

release to a small % of users, then gradually to everyone.

#### Rolling Deployment

update servers one by one with new version.

### DevOps Workflow (Simplified)

Plan → Define features & tasks.

Code → Write software (best practices, tests).

Build → Compile/assemble code (Docker images, binaries).

Test → Unit, integration, end-to-end tests.

Release → Package and prepare for deployment.

Deploy → Push to production environment.

Monitor → Collect metrics, logs, and feedback.

Iterate → Fix issues & improve continuously.

---

## 9. **Maintainability**

### What is Maintainability?

**Maintainability** = how easy it is to **understand, modify, fix, extend, and improve** a software system **over time**.

It means:

- Future developers (including you!) can read the code easily.

- Bugs can be fixed without breaking other parts.

- New features can be added without rewriting everything.

- Code can adapt to new requirements, platforms, or technologies.

### 🔹 Why is Maintainability Important?

1. **Reduces cost** 💰 – most software costs are in maintenance, not initial development.

2. **Prevents bugs** 🐞 – clean, modular code is less error-prone.

3. **Easier onboarding** 👥 – new developers can understand the system faster.

4. **Supports scaling** 📈 – maintainable systems can grow without chaos.

### 🔹 Factors That Improve Maintainability

#### 1. **Code Readability**

- Consistent formatting (e.g., `gofmt` in Go).

- Clear naming conventions.

- Avoid deeply nested logic.

- Use comments where intent isn’t obvious.

#### 2. **Modularity**

- Break code into small, reusable components.

- Separation of concerns (API layer, service layer, data layer).

#### 3. **Loose Coupling**

- Components depend on each other as little as possible.

- Makes replacing/upgrading parts easier.

#### 4. **Testability**

- Unit, integration, and end-to-end tests.

- Ensures changes don’t break existing features.

#### 5. **Documentation**

- High-level architecture docs.

- Clear API contracts.

- "Why" something is done, not just "what."

#### 6. **Version Control & Branching Strategy**

- GitFlow or trunk-based development.

- Clear commit history for tracking changes.

#### 7. **Automation**

- CI/CD pipelines to test and deploy consistently.

- Automated linting and code quality checks.

---

### 🔹 Measuring Maintainability

Some metrics often used:

#### **Cyclomatic complexity**

→ measures complexity of code paths.

#### **Code churn**

→ how often code changes.

#### **Technical debt**

→ accumulated shortcuts that make future work harder.

## 10. **Mindset & Professionalism**

### What is Mindset in Software Development?

Mindset = how you **think, learn, and approach problems** as a developer.  
It’s the attitude and habits you bring to your work.

#### Key Mindsets

##### 1. **Growth mindset** 🌱

    - Believe skills improve with practice.
        
    - Open to feedback and learning from mistakes.
        
##### 2. **Problem-solving mindset** 🧩

    - Focus on finding solutions, not blaming.
        
    - Break big problems into smaller steps.
        
##### 3. **Continuous learning** 📚

    - Tech changes fast → keep learning new languages, tools, and patterns.
        
##### 4. **User-focused mindset** 👥

    - Remember: software is built to **solve user problems**, not just to be “cool code.”
        
##### 5. **Quality mindset** ✅

    - Write clean, maintainable, and tested code.
        
    - Think long-term, not quick hacks (unless necessary).
        

---

### 🔹 What is Professionalism in Software Development?

Professionalism = how you **act and communicate** as a software engineer in a team or company.

#### Key Traits

##### 1. **Reliability** 🔒

    - Deliver on time. If you can’t, communicate early.
        
##### 2. **Clear communication** 💬

    - Write good commit messages, pull request descriptions, and documentation.
        
    - Explain technical ideas in simple terms to non-technical people.
        
##### 3. **Collaboration** 🤝

    - Work well with teammates.
        
    - Respect code reviews and give constructive feedback.
        
##### 4. **Responsibility** ⚖️

    - Own your code — if it breaks, help fix it.
        
    - Think about security, performance, and long-term impact.
        
##### 5. **Ethics** 🧭

    - Don’t cut corners that put users or data at risk.
        
    - Respect licenses, privacy, and intellectual property.
        

---

### 🔹 Why Mindset & Professionalism Matter

- Code is written by **people** for **people** → your attitude determines how easy it is to work with you and your code.

- Professional developers are **trusted more** with big projects.

- Companies value engineers who can **learn, adapt, and collaborate** — not just code quickly.
