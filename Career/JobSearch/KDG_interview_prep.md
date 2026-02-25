# KDG Lead Developer — Interview Talking Points

Interview with Rob Sweeney (Assistant Vice President of Custom Development) — February 26, 2026 at 3pm Eastern via Microsoft Teams

---

## Rob Sweeney — Interviewer Profile

**Title:** Team Lead, Software Development (KDG website) / Assistant Vice President of Custom Development (per recruiter)
**Education:** Associate's in Computer Science, Lehigh Carbon Community College

**His quote about KDG:** "KDG offers the best employee growth program that I've seen. They allow and encourage their employees to continue to improve and hone their skills as they work."

**Bio:** Focused on complex web and mobile apps in cloud environments. Range from single-page sites for local businesses to complex custom apps for large medical firms. Known for quickly learning new code and platforms — described as "one of KDG's most diverse programmers." Strong client relationships — can simplify complex cases for non-technical people. Trains his own development team on best practices.

**Experience highlights:**
- Event sourcing for a real estate company (payroll, reporting, accounting)
- Custom mobile app for real estate agents (Customer Relationship Management in the field)
- On-site client launch with real-time bug fixes
- Medical client — custom app for equipment and patient records
- WordPress site for a private school (events, donations, calendar)
- Credential/security app for a major sports league using Zoho Creator

**Tech stack:** PHP, JavaScript, MySQL, Vue, jQuery, React, React Native, Angular
**Certified in:** Zoho Creator

**Common ground with you:** React, client-facing communication, simplifying technical concepts for non-technical people, training/mentoring developers, managing projects independently.

---

**Azure (Microsoft Azure)** — Microsoft's cloud platform. You haven't used it directly but your Amazon Web Services experience transfers. Same concepts: virtual machines, managed databases, identity management, storage. Azure is the likely choice at KDG given their Microsoft stack.

**C# (C Sharp)** — Microsoft's primary programming language. You built Revit plugins with it at Trinam, including Windows Presentation Foundation interfaces and Blazor web interfaces. This is the backbone of the KDG sample project.

**Cloud Infrastructure** — The job posting asks for "high-load applications using cloud infrastructure." Be ready to talk about how you'd deploy a C# application with a PostgreSQL database. On Amazon Web Services that's Elastic Container Service or Elastic Beanstalk + Relational Database Service PostgreSQL. On Azure it's Azure App Service + Azure Database for PostgreSQL.

**Bootstrapping / Scaffolding** — Industry terms for generating a project's starter files and folder structure. React uses `npm create vite@latest` (current) or `create-react-app` (deprecated). Next.js uses `create-next-app`. .NET uses `dotnet new webapi` or `dotnet new react`. Entity Framework Core also has scaffolding for generating controllers and views from models (`dotnet aspnet-codegenerator`). One-liner for the interview: "I'd scaffold the API with `dotnet new webapi` and the client with `create-next-app`, then wire them together with Cross-Origin Resource Sharing in development."

**Code Reviews and Pull Requests** — The posting calls this out specifically, including identifying performance issues and security concerns. Talk about your Git workflow: feature branches, pull requests with meaningful descriptions, reviewing for readability and edge cases, not just correctness.

**Common Table Expressions** — The `WITH` keyword in SQL. Lets you name intermediate result sets for readability. Shows you write maintainable SQL, not spaghetti subqueries.

**Content Delivery Network** — Caches static assets (JavaScript bundles, images) closer to users geographically. Relevant for the React front end in production.

**Cybersecurity Principles** — Listed as a requirement. Think: input validation, parameterized queries (preventing SQL injection), authentication/authorization, HTTPS everywhere, Cross-Site Scripting prevention in React (which handles most of it by default through escaping).

**Docker** — Containerization tool. You use it for development environments at ScriptHammer. Relevant for deploying C# applications consistently across environments. Mention your experience if it comes up under cloud/deployment questions.

**Entity Framework Core** — Microsoft's Object-Relational Mapper for .NET. Maps C# classes to database tables so you write Language Integrated Query instead of raw Structured Query Language. Uses the Npgsql provider to talk to PostgreSQL specifically.

**Generalized Inverted Index** — A PostgreSQL index type used for JSON Binary columns, arrays, and full-text search. Indexes the contents inside complex data types so queries into them are fast.

**Git** — Not an acronym. Named by Linus Torvalds (creator of Linux). Distributed version control. The posting requires "source control technologies such as Git." You use it daily.

**Identity and Access Management** — Controls who can access what in cloud environments. Amazon Web Services calls it Identity and Access Management, Azure calls it Azure Active Directory (now rebranded to Entra ID). Relevant when the interviewer asks about security.

**JSON Binary (JSONB)** — PostgreSQL's binary-stored JSON format. Parsed once on insert, fast to query, indexable. Use it when you need flexible schema alongside relational data — like storing product metadata or user preferences without creating a new column for every field.

**Language Integrated Query (LINQ)** — C# feature that lets you write database queries as native C# code. Entity Framework Core translates it to Structured Query Language under the hood. Keeps your data access type-safe and readable.

**Microsoft Technology Stack** — The posting says "be proficient in Microsoft technology stacks." For you that's: C#, .NET, Entity Framework Core, Blazor, Windows Presentation Foundation. TypeScript/React isn't Microsoft-originated but TypeScript is Microsoft-maintained, so it fits.

**Npgsql** — The "N" stands for .NET, "pgsql" is the common abbreviation for PostgreSQL. It's the open-source .NET data provider for PostgreSQL — the driver that lets C# applications talk to PostgreSQL databases. Entity Framework Core uses it through the `Npgsql.EntityFrameworkCore.PostgreSQL` package.

**Object-Relational Mapper (ORM)** — Software that maps database rows to programming language objects. Entity Framework Core is .NET's Object-Relational Mapper. You write C# classes, it generates Structured Query Language. Know when to use it (most of the time) and when to drop to raw queries (performance-critical operations).

**Platform as a Service (PaaS)** — The posting mentions "PaaS databases" specifically. These are managed database services where the cloud provider handles backups, patching, scaling — you just use it. Amazon Relational Database Service and Azure Database for PostgreSQL are examples. You don't manage the server, just the data.

**PostgreSQL** — Named after the Ingres database project at Berkeley. Post-Ingres became Postgres became PostgreSQL. Open-source relational database. The KDG sample project uses it. Know: table creation, joins, indexes, foreign keys, JSON Binary, Common Table Expressions, and how it connects to C# through Npgsql.

**Relational Database Service** — Amazon Web Services' managed database hosting. You pick the engine (PostgreSQL, MySQL, etc.) and Amazon handles backups, patching, failover. Azure's equivalent is Azure Database for PostgreSQL.

**Representational State Transfer (REST)** — The standard pattern for web APIs. Your React front end makes HTTP requests (GET, POST, PUT, DELETE) to your C# back end, which queries PostgreSQL and returns JSON. This is likely the architecture of KDG's sample project.

**Single Page Application (SPA)** — The posting requires "full development competency with SPA pattern/framework experience." React is a Single Page Application framework. The browser loads once, then JavaScript handles navigation and rendering without full page reloads. That's your 10+ years of React/TypeScript experience.

**Structured Query Language (SQL)** — The language for talking to relational databases. PostgreSQL is one implementation. Know your SELECT, JOIN, GROUP BY, HAVING, indexes, and constraints.

**TypeScript** — Microsoft-maintained typed superset of JavaScript. Catches bugs at compile time instead of runtime. The KDG sample project specifies TypeScript React. This is core to your experience.

**User Interface / User Experience (UI/UX)** — The posting asks you to "assist in UI/UX design, focusing on empathy-based solutions." Talk about how you gathered requirements from the Trinam drafters by watching how they actually worked, not assuming what they needed.

**Virtual Private Cloud** — An isolated network inside a cloud provider. Your application, database, and services live inside one. Traffic rules control what can talk to what. Think of it as your own private section of the cloud.

**Windows Presentation Foundation (WPF)** — Microsoft's desktop UI framework for .NET. You built WPF interfaces for the Trinam Revit plugins. Shows depth in the Microsoft stack beyond just web.

---

## React + C# Integration (The KDG Sample Project Stack)

### Architecture

```
React (TypeScript)  →  HTTP/JSON  →  ASP.NET Core Web API (C#)  →  Entity Framework Core  →  PostgreSQL
     Frontend                              Backend                        ORM                   Database
```

Two separate projects that talk over HTTP. The React app runs in the browser, makes fetch calls to the C# API, gets JSON back.

<details>
<summary>Project Structure</summary>

```
MyApp/
├── MyApp.sln                    # Visual Studio Solution file
├── MyApp.Api/                   # C# ASP.NET Core Web API
│   ├── Controllers/             # API endpoints
│   ├── Models/                  # Database entities
│   ├── Data/                    # DbContext, migrations
│   ├── Services/                # Business logic
│   ├── Program.cs               # App startup and configuration
│   └── appsettings.json         # Connection strings, config
├── MyApp.Client/                # React TypeScript app
│   ├── src/
│   │   ├── components/
│   │   ├── pages/
│   │   ├── services/            # API call functions
│   │   └── types/               # TypeScript interfaces matching C# models
│   ├── package.json
│   └── tsconfig.json
└── MyApp.Tests/                 # Unit/integration tests
```

</details>

<details>
<summary>C# Side — API Controller (Create, Read, Update, Delete)</summary>

```csharp
[ApiController]
[Route("api/[controller]")]
public class CustomersController : ControllerBase
{
    private readonly AppDbContext _context;

    public CustomersController(AppDbContext context)
    {
        _context = context;
    }

    [HttpGet]
    public async Task<ActionResult<List<Customer>>> GetAll()
    {
        return await _context.Customers
            .Include(c => c.Orders)
            .ToListAsync();
    }

    [HttpGet("{id}")]
    public async Task<ActionResult<Customer>> GetById(int id)
    {
        var customer = await _context.Customers.FindAsync(id);
        if (customer == null) return NotFound();
        return customer;
    }

    [HttpPost]
    public async Task<ActionResult<Customer>> Create(Customer customer)
    {
        _context.Customers.Add(customer);
        await _context.SaveChangesAsync();
        return CreatedAtAction(nameof(GetById), new { id = customer.Id }, customer);
    }

    [HttpPut("{id}")]
    public async Task<IActionResult> Update(int id, Customer customer)
    {
        if (id != customer.Id) return BadRequest();
        _context.Entry(customer).State = EntityState.Modified;
        await _context.SaveChangesAsync();
        return NoContent();
    }

    [HttpDelete("{id}")]
    public async Task<IActionResult> Delete(int id)
    {
        var customer = await _context.Customers.FindAsync(id);
        if (customer == null) return NotFound();
        _context.Customers.Remove(customer);
        await _context.SaveChangesAsync();
        return NoContent();
    }
}
```

</details>

<details>
<summary>React Side — TypeScript Types (Mirror the C# Models)</summary>

```typescript
// types/Customer.ts
interface Customer {
  id: number;
  name: string;
  email: string;
  createdAt: string;
  orders: Order[];
}

interface Order {
  id: number;
  customerId: number;
  total: number;
  status: string;
  createdAt: string;
}
```

</details>

<details>
<summary>React Side — API Service Layer</summary>

```typescript
// services/customerService.ts
const API_BASE = '/api/customers';

export async function getCustomers(): Promise<Customer[]> {
  const response = await fetch(API_BASE);
  return response.json();
}

export async function getCustomer(id: number): Promise<Customer> {
  const response = await fetch(`${API_BASE}/${id}`);
  return response.json();
}

export async function createCustomer(customer: Omit<Customer, 'id'>): Promise<Customer> {
  const response = await fetch(API_BASE, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(customer),
  });
  return response.json();
}
```

</details>

<details>
<summary>React Side — Component</summary>

```typescript
// components/CustomerList.tsx
import { useEffect, useState } from 'react';
import { getCustomers } from '../services/customerService';

export function CustomerList() {
  const [customers, setCustomers] = useState<Customer[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    getCustomers()
      .then(setCustomers)
      .finally(() => setLoading(false));
  }, []);

  if (loading) return <p>Loading...</p>;

  return (
    <table>
      <thead>
        <tr><th>Name</th><th>Email</th></tr>
      </thead>
      <tbody>
        {customers.map(c => (
          <tr key={c.id}><td>{c.name}</td><td>{c.email}</td></tr>
        ))}
      </tbody>
    </table>
  );
}
```

</details>

<details>
<summary>The Glue — Cross-Origin Resource Sharing (CORS)</summary>

In development, React runs on port 3000 and the API on port 5000. Configure in Program.cs:

```csharp
builder.Services.AddCors(options =>
{
    options.AddDefaultPolicy(policy =>
    {
        policy.WithOrigins("http://localhost:3000")
              .AllowAnyHeader()
              .AllowAnyMethod();
    });
});
```

In production, the C# app serves the React build files as static assets or both sit behind a reverse proxy, so Cross-Origin Resource Sharing isn't needed.

</details>

### Key Interview Points

1. **TypeScript interfaces mirror C# models** — keeps the contract between front and back end explicit
2. **The API is stateless** — each request contains everything needed, React manages state on the client
3. **Entity Framework Core handles the database** — you rarely write raw Structured Query Language, but you can when performance requires it
4. **Separation of concerns** — React handles presentation, C# handles business logic and data access, PostgreSQL stores data

---

## PostgreSQL Quick Reference

<details>
<summary>Create a table</summary>

```sql
CREATE TABLE customers (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    created_at TIMESTAMP DEFAULT NOW()
);
```

</details>

<details>
<summary>Foreign key relationship</summary>

```sql
CREATE TABLE orders (
    id SERIAL PRIMARY KEY,
    customer_id INTEGER NOT NULL REFERENCES customers(id),
    total DECIMAL(10, 2) NOT NULL,
    status VARCHAR(20) DEFAULT 'pending',
    created_at TIMESTAMP DEFAULT NOW()
);
```

</details>

<details>
<summary>Index for performance</summary>

```sql
CREATE INDEX idx_orders_customer_id ON orders(customer_id);
```

</details>

<details>
<summary>Join query</summary>

```sql
SELECT c.name, o.total, o.status
FROM customers c
JOIN orders o ON o.customer_id = c.id
WHERE o.status = 'pending';
```

</details>

<details>
<summary>JSON Binary column</summary>

```sql
CREATE TABLE products (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    metadata JSONB DEFAULT '{}'
);

-- Query into JSON (->> extracts as text, -> extracts as JSON)
SELECT name, metadata->>'color' AS color
FROM products
WHERE metadata->>'color' = 'blue';

-- Index JSON Binary with Generalized Inverted Index
CREATE INDEX idx_products_metadata ON products USING GIN (metadata);
```

</details>

<details>
<summary>Common Table Expression</summary>

```sql
WITH high_value_customers AS (
    SELECT customer_id, SUM(total) AS lifetime_spend
    FROM orders
    GROUP BY customer_id
    HAVING SUM(total) > 1000
)
SELECT c.name, h.lifetime_spend
FROM high_value_customers h
JOIN customers c ON c.id = h.customer_id
ORDER BY h.lifetime_spend DESC;
```

</details>

<details>
<summary>Case-insensitive search (PostgreSQL-specific)</summary>

```sql
SELECT * FROM customers WHERE name ILIKE '%jonathan%';
```

</details>

---

## C# + Entity Framework Core + Npgsql

<details>
<summary>Connection string (appsettings.json)</summary>

```json
{
  "ConnectionStrings": {
    "DefaultConnection": "Host=localhost;Database=myapp;Username=postgres;Password=secret"
  }
}
```

</details>

<details>
<summary>Register in Program.cs</summary>

```csharp
builder.Services.AddDbContext<AppDbContext>(options =>
    options.UseNpgsql(builder.Configuration.GetConnectionString("DefaultConnection")));
```

</details>

<details>
<summary>Models</summary>

```csharp
public class Customer
{
    public int Id { get; set; }
    public string Name { get; set; }
    public string Email { get; set; }
    public DateTime CreatedAt { get; set; }
    public List<Order> Orders { get; set; }
}

public class Order
{
    public int Id { get; set; }
    public int CustomerId { get; set; }
    public Customer Customer { get; set; }
    public decimal Total { get; set; }
    public string Status { get; set; }
    public DateTime CreatedAt { get; set; }
}
```

</details>

<details>
<summary>DbContext</summary>

```csharp
public class AppDbContext : DbContext
{
    public AppDbContext(DbContextOptions<AppDbContext> options) : base(options) { }

    public DbSet<Customer> Customers { get; set; }
    public DbSet<Order> Orders { get; set; }
}
```

</details>

<details>
<summary>Migrations</summary>

```bash
dotnet ef migrations add InitialCreate
dotnet ef database update
```

</details>

<details>
<summary>Language Integrated Query example</summary>

```csharp
var highValueCustomers = await context.Orders
    .GroupBy(o => o.CustomerId)
    .Where(g => g.Sum(o => o.Total) > 1000)
    .Select(g => new {
        CustomerId = g.Key,
        LifetimeSpend = g.Sum(o => o.Total)
    })
    .Join(context.Customers,
        h => h.CustomerId,
        c => c.Id,
        (h, c) => new { c.Name, h.LifetimeSpend })
    .OrderByDescending(x => x.LifetimeSpend)
    .ToListAsync();
```

</details>
