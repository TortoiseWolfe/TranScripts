# KDG Lead Developer — Interview Talking Points

Interview with Rob Sweeney (Assistant Vice President of Custom Development) — February 26, 2026 at 3pm Eastern via Microsoft Teams

---

## Follow-Up Prep — What Rob Will Dig Into From Your Video Answers

### Q1 — Why interested in the role

You said "I've been a lead developer at Collective Mines" and "I'm a mentor at TechJoy."

- **"Tell me more about your role at Collective Minds. What did you build there?"** — Be ready with specifics: what the product was, your tech stack, team size, how long you were there.
- **"What does mentoring at TechJoy look like?"** — Be specific: how many people, what you teach, how often. This directly relates to the mentoring expectation of a Lead Developer.
- **"You said this stack is one you're already familiar with. How much PostgreSQL have you actually used?"** — Be honest: "Most of my database work has been with SQL Server and MySQL. PostgreSQL is the same SQL fundamentals — the differences are syntax-level, not conceptual. I've been brushing up on PostgreSQL-specific features like JSON Binary and the Npgsql driver for .NET."

### Q2 — Why KDG

Solid answer, unlikely to get deep follow-ups. But be ready for:

- **"What do you mean by 'I put the service in software as a service'?"** — Have a concrete example ready beyond Trinam. Maybe Collective Minds or a freelance project.
- The auto-transcript has a glitch at the end repeating "I'm going to have a lot of work." If Rob read the transcript instead of watching the video and asks about it, just say "That was a transcription error, not something I said."

### Q3 — Trinam plugin (most likely to get follow-ups)

This is your strongest answer and Rob will want details. Answers sourced from the actual codebase ([Trinam_23 repo](https://github.com/TortoiseWolfe/Trinam_23)):

- **"What was the Revit API like to work with? What challenges did you run into?"**
  - .NET 4.8 targeting Revit 2023 (RevitAPI.dll, RevitAPIUI.dll)
  - Manual transaction management throughout — every operation wrapped in `Transaction` with explicit Start/Commit/Rollback
  - Used Rollback creatively for read-only operations: create a SketchPlane just to extract the Plane geometry, then roll back so the document stays unchanged
  - Heavy use of `ReferenceArray` for dimensioning — 15+ reference arrays per command
  - Mix of `BuiltInParameter` and `LookupParameter` for accessing element properties — two different access patterns depending on whether it's a built-in Revit property or a custom parameter
  - Complex geometry operations: `Transform.CreateTranslation()`, coordinate system transformations, curve endpoint extraction
  - 2,378 try/catch blocks across the codebase for error handling

- **"You mentioned automated testing. What did that look like for a Revit plugin?"**
  - No formal unit test framework (NUnit/xUnit/MSTest) — Revit's API requires a running Revit instance, which makes traditional unit testing impractical
  - Instead: comprehensive logging infrastructure — every major command logs execution time, operations performed, and failures with parameter-level diagnostics using StringBuilder
  - 2,378 try/catch blocks with detailed failure logs so you could trace exactly what went wrong and on which element
  - Configuration-based testing via `app.config` for test settings (dimension offsets, checkbox states, text values)
  - WinForms input validation dialogs before operations ran — catch bad input before it hits the API
  - Quality control commands built into the plugin itself: `NumCheck` validates module numbering sequences, `QC_001`/`QC_002` validate parameters
  - (Abstract the business logic away from the Revit API using the Repository pattern and dependency injection. That way the geometry calculations, numbering logic, and data transformations can be unit tested with xUnit without needing a running Revit instance. Only the thin layer that actually talks to Revit stays untestable in isolation. For integration tests, Dynamo's RevitTestFramework can run tests inside a live Revit session against a known test model — that's how you verify the API calls work end-to-end. I'd also use Revit's journal file automation to replay scripted actions for regression testing across version updates.)

- **"How did you deploy updates to the drafters?"**
  - Built an MSI installer using WiX Toolset v4 (`Trinam'23 Plugin.msi`, 1.1 MB)
  - Installer dropped `Trinam_23.dll` and `Trinam_23.addin` manifest into `%CommonAppData%\Autodesk\Revit\Addins\2023\`
  - Plugin auto-loaded when Revit started — drafters didn't have to do anything after running the installer
  - Also had ZIP distribution (`Trinam23'0.2.5.3.zip`) for manual installs
  - Versioning tracked in the ZIP filename and installer metadata
  - Supported x86, x64, ARM64, and AnyCPU build configurations

- **"You said you kept pushing what was possible. What else did you automate beyond dimensioning?"**
  - **400+ commands total** — dimensioning was just one category
  - **95+ dimensioning variations** — shop dims, fab dims, floor plan dims, curtain wall dims, split infills
  - **45+ elevation/view creation** — auto-generate elevation views, section views, fabrication sections from selected elements
  - **21+ wall duplication commands** — copy walls across building levels with parameter propagation and workset mapping (e.g., duplicate 99+ walls from one level to another in one click)
  - **Module/panel numbering** — 10+ numbering commands with chain numbering, shift-key reordering, and QC validation
  - **Sheet automation** — auto-create sheets and place views on them
  - **Data import/export** — CSV and JSON round-tripping for element data
  - **29+ detailing commands** — auto-place detail tags
  - **Excel integration** — change module family types from a spreadsheet (`Microsoft.Office.Interop.Excel`)
  - **REST API integration** — HTTP calls from within Revit using `Microsoft.Extensions.Http`
  - **13 shared library classes** — geometry transforms (`Geo_MeTry.cs`), selection utilities (`Sel_EcTion.cs`), graphics overrides (`Graph_Ical.cs`), extensible storage, data extraction, tag helpers
  - **WPF and WinForms UI** — dockable panels, copy-with-positioning controls, module numbering forms, level pickers

### Q4 — Collaboration and communication

You described being a solo developer bridging two sides. Rob may probe:

- **"You were the only developer. How would you handle working on a team where you're NOT the only technical voice?"** — This is the big one. KDG has teams. Show you can collaborate, not just own everything. Talk about code reviews, pull requests, deferring to teammates with more domain expertise.
- **"Can you give me an example of a disagreement or conflict with a stakeholder?"** — Have one ready. How did you handle pushback on scope or timeline? What was the outcome?
- **"What project management tools did you use?"** — Even if it was simple (a spreadsheet, Trello, Jira), name it.

### Q5 — System upgrades and risk

You mentioned Docker, Playwright, feature branches. Rob might go deeper:

- **"Tell me about ScriptHammer. What is that?"** — Be ready to explain: your personal development environment / portfolio site / project. What's the stack, what's it for.
- **"You mentioned Playwright for end-to-end testing. Walk me through how you set that up."** — Browser selection, test structure, what you're actually testing, how it runs in your pipeline.
- **"Have you ever had an upgrade go wrong? What happened?"** — Have a real story. The Revit version updates are perfect — was there one that broke something? How did you catch it? How did you fix it?
- **"You said you avoid big rewrites. What if the client insists on one?"** — Talk about presenting the risks, proposing an incremental alternative, and ultimately deferring to the client's decision while documenting the tradeoffs.

### Q6 — Salary: NEEDS PREP

You anchored at 70k. The posting range is 70k-90k. You went to the bottom.

- **If Rob brings up salary:** "I said 70k because I wanted to show I'm not chasing the highest number — I'm looking for the right fit. But I also know the posted range goes to 90k, and I'm confident I'd earn my way there quickly based on what I deliver."
- **Don't volunteer to renegotiate** — just be ready if he opens the door.
- **If they offer 70k flat:** You can negotiate after you've proven value, or negotiate before accepting based on the scope of the role being larger than expected.

### Q7 — Monthly commute

You were honest about the logistics. Rob might want a firmer answer:

- **"So are you saying yes or no to the monthly visit?"** — "Yes. I'll make it work. Pre-scheduled flights, I can plan around them. I just wanted to be upfront that I'm flying, not driving."
- **Know your numbers:** A round-trip flight from Chattanooga or Knoxville to Lehigh Valley (ABE airport) or Philadelphia is typically $200-400 if booked in advance. Show you've thought it through.

---

## Questions to Ask Rob (pick 4-5)

**About the day-to-day work:**
- What does a typical project lifecycle look like here — from when a client signs on to delivery?
- How many projects would I manage at once as a Lead Developer?
- What's the split between writing code and client-facing work in this role?

**About the team and how they work:**
- Who would I be working with on a project — do Lead Developers have dedicated QA, designers, or is it more fluid?
- What does your code review process look like?
- What source control workflow do you use — feature branches, pull requests, trunk-based?

**About the tech stack:**
- The sample project lists C#, TypeScript React, and PostgreSQL — is that representative of most projects, or does the stack vary by client?
- Are you deploying to Azure, or does it depend on the client?
- How do you handle database migrations on client projects — Entity Framework Core migrations, or something else?

**About Rob (builds rapport — shows you did your research):**
- You've been here 9+ years — what's kept you at KDG that long?
- You train developers on best practices — what's the biggest thing you see new developers need to ramp up on when they join?

**About growth and culture:**
- What does success look like in the first 90 days for this role?
- The posting mentions KDG encourages continued learning — what does that look like in practice?

**Practical:**
- What's the timeline for the hiring process from here?

---

## What "Lead Developer" Means at KDG

A developer builds what they're told. A Lead Developer figures out what to build, tells the client when it'll be done, builds it, and makes sure it works.

What KDG's Lead Developer does beyond writing code:
- **Manages your own projects and deadlines** — you figure out the timeline, nobody hands you a sprint board
- **Gathers requirements from clients directly** — you're in the room with the client, not getting requirements filtered through a project manager
- **Main point of communication and deliverables** — the client calls you. You own the relationship
- **Makes technical decisions** — you pick the approach, architecture, and tradeoffs
- **Code reviews** — you review other people's work for performance and security
- **Mentoring** — Rob trains his team on best practices, they'd expect the same from you

**Why you're ready:** You've been doing Lead Developer work without the title. At Trinam you were the only developer — owned the client relationship, gathered requirements, made all technical decisions. At Collective Minds you managed timelines and were the main point of contact for technical decisions across a distributed team.

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

**ASP.NET Core Web API** — The specific .NET framework KDG uses for the sample project backend. It serves Representational State Transfer endpoints to the React frontend. Not a desktop or mobile framework — it's a web server. Scaffolded with `dotnet new webapi`. This is the C# "app type" that matters most for this role.

**.NET Application Types** — The full ecosystem of what you can build with C#:

| Framework | What it builds | Relevant to KDG? |
|-----------|---------------|-------------------|
| **ASP.NET Core Web API** | Backend APIs for web/mobile frontends | Yes — the sample project |
| **ASP.NET Core MVC** | Server-rendered web pages (older pattern) | Maybe — legacy client projects |
| **Blazor Server / WebAssembly** | Single Page Applications in C# instead of JavaScript | Possible — but they specified React |
| **WPF (Windows Presentation Foundation)** | Windows desktop apps | Your Trinam experience, not KDG's focus |
| **WinForms (Windows Forms)** | Older Windows desktop apps | Legacy, unlikely |
| **MAUI (.NET Multi-platform App UI)** | Cross-platform mobile and desktop (replaced Xamarin) | Unlikely — Rob's mobile work used React Native |
| **Console Apps** | Command line tools, background jobs | Supporting role |
| **Worker Services** | Background processes, scheduled tasks | Supporting role |

Interview line: "I've built with Windows Presentation Foundation at Trinam for desktop interfaces and Blazor for web, but I'm most interested in the ASP.NET Core Web API plus React pattern you're using here — that separation of concerns makes the most sense to me."

**Azure (Microsoft Azure)** — Microsoft's cloud platform. You haven't used it directly but your Amazon Web Services experience transfers. Same concepts: virtual machines, managed databases, identity management, storage. Azure is the likely choice at KDG given their Microsoft stack.

**C# (C Sharp)** — Microsoft's primary programming language. You built Revit plugins with it at Trinam, including Windows Presentation Foundation interfaces and Blazor web interfaces. This is the backbone of the KDG sample project.

**Cloud Infrastructure** — The job posting asks for "high-load applications using cloud infrastructure." Be ready to talk about how you'd deploy a C# application with a PostgreSQL database. On Amazon Web Services that's Elastic Container Service or Elastic Beanstalk + Relational Database Service PostgreSQL. On Azure it's Azure App Service + Azure Database for PostgreSQL.

**Bootstrapping / Scaffolding** — Industry terms for generating a project's starter files and folder structure. React uses `npm create vite@latest` (current) or `create-react-app` (deprecated). Next.js uses `create-next-app`. .NET uses `dotnet new webapi` or `dotnet new react`. Entity Framework Core also has scaffolding for generating controllers and views from models (`dotnet aspnet-codegenerator`). One-liner for the interview: "I'd scaffold the API with `dotnet new webapi` and the client with `create-next-app`, then wire them together with Cross-Origin Resource Sharing in development."

**Code Reviews and Pull Requests** — The posting calls this out specifically, including identifying performance issues and security concerns. Talk about your Git workflow: feature branches, pull requests with meaningful descriptions, reviewing for readability and edge cases, not just correctness.

**Common Table Expressions** — The `WITH` keyword in SQL. Lets you name intermediate result sets for readability. Shows you write maintainable SQL, not spaghetti subqueries.

**Content Delivery Network** — Caches static assets (JavaScript bundles, images) closer to users geographically. Relevant for the React front end in production.

**Cybersecurity Principles** — Listed as a requirement. Think: input validation, parameterized queries (preventing SQL injection), authentication/authorization, HTTPS everywhere, Cross-Site Scripting prevention in React (which handles most of it by default through escaping).

**Docker** — Containerization tool. You use it for development environments at ScriptHammer. Relevant for deploying C# applications consistently across environments. Mention your experience if it comes up under cloud/deployment questions.

**Expo / Expo Go** — Expo is the framework and CLI for building React Native apps. Expo Go is the companion phone app that lets you preview projects in real time by scanning a QR code — no full native build needed. Rob has React Native on his profile. If mobile comes up: "I'd scaffold with Expo and use Expo Go for live previewing on device during development."

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
