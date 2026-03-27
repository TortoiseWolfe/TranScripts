# Billing and Credits System — Lovable Clone Tutorial

Implements the full billing flow: credit deduction, plan upgrade/downgrade, Clerk webhook handling, ngrok tunneling for local development, Clerk Billing configuration with free/pro plans, and frontend UI components (credits display, upgrade CTA, pricing page, checkout).

---

## Credit Service Functions

The **credit service** (`credits.ts`) needs three exported functions: `deductCredits`, `upgradePlan`, and `downgradePlan`.

### deductCredits

```typescript
export async function deductCredits(userId: string, creditCost: number, env): Promise<UserCredits> {
  const credits = await getCredits(userId, env);
  if (credits.isUnlimited) return credits;

  const remaining = Math.max(0, credits.remaining - creditCost);
  // update metadata with new remaining value
  return credits;
}
```

- If the user has **unlimited credits** (pro plan), return credits unchanged.
- Otherwise, calculate `remaining` using `Math.max(0, credits.remaining - creditCost)` to prevent negative balances.
- Update the KV metadata and return the updated credits object.

### upgradePlan

```typescript
export async function upgradePlan(userId: string, env): Promise<UserCredits> {
  const credits = await getCredits(userId, env);
  const upgraded: UserCredits = {
    ...credits,
    plan: "pro",
    remaining: "unlimited",
  };
  // update metadata
  return upgraded;
}
```

### downgradePlan

```typescript
export async function downgradePlan(userId: string, env): Promise<UserCredits> {
  const { remaining, total, plan, periodStart, periodEnd } = createBillingPeriod();
  const downgraded: UserCredits = { remaining, total, plan: "free", periodStart, periodEnd };
  // update metadata
  return downgraded;
}
```

---

## Billing Route

Create `billing.ts` in the worker routes directory.

```typescript
import { Hono } from "hono";
import { Env, AppVariables } from "./types";
import { upgradePlan, downgradePlan } from "./services/credits";

const billingRoutes = new Hono<{ Bindings: Env; Variables: AppVariables }>();

billingRoutes.get("/plan-change", async (c) => {
  const userId = /* extract from auth */;
  const body = await c.req.json();
  // body.action is "upgrade" or "downgrade"

  if (!body.action) return c.json({ error: "missing action" }, 400);

  let credits;
  if (body.action === "upgrade") {
    credits = await upgradePlan(userId, c.env);
  } else {
    credits = await downgradePlan(userId, c.env);
  }

  return c.json({
    success: true,
    remaining: credits.remaining,
    total: credits.total,
    plan: credits.plan,
    periodEnd: credits.periodEnd,
    isUnlimited: credits.isUnlimited,
  });
});

export default billingRoutes;
```

---

## Webhook Route (Clerk Billing Webhooks)

Create `webhooks.ts` in the worker routes directory. Clerk uses **Svix** internally for webhook verification.

### Install Svix

```bash
npm install svix
```

### Webhook Payload Interface

```typescript
interface ClerkBillingWebhookPayload {
  data: {
    id: string;
    plan: {
      id: string;
      name: string;
      slug: string;
    };
    payer: {
      userId: string;
      email: string;
    };
    status: string;
    periodId: string;
  };
  type: string;
  timestamp: number;
}
```

- **data.id** — subscription item ID
- **data.plan** — plan info (id, name, slug)
- **data.payer** — who paid (userId, email)
- **type** — event type (e.g., `subscription_item.active`)

### Webhook Handler

```typescript
import { Webhook } from "svix";

webhookRoutes.post("/", async (c) => {
  // 1. Extract Svix headers
  const svixId = c.req.header("svix-id");
  const svixTimestamp = c.req.header("svix-timestamp");
  const svixSignature = c.req.header("svix-signature");

  if (!svixId || !svixTimestamp || !svixSignature) {
    return c.json({ error: "missing svix headers" }, 400);
  }

  // 2. Get raw body and initialize webhook verifier
  const body = await c.req.text();
  const wh = new Webhook(c.env.CLERK_WEBHOOK_SECRET);

  // 3. Verify signature
  let event: ClerkBillingWebhookPayload;
  try {
    event = wh.verify(body, {
      "svix-id": svixId,
      "svix-timestamp": svixTimestamp,
      "svix-signature": svixSignature,
    }) as ClerkBillingWebhookPayload;
  } catch {
    return c.json({ error: "invalid webhook signature" }, 400);
  }

  // 4. Process event by type
  const eventType = event.type;
  console.log("Webhook received:", eventType);

  switch (eventType) {
    case "subscription_item.active": {
      const userId = event.data.payer.userId;
      const planSlug = event.data.plan.slug;
      if (!userId) { console.error("Missing userId in webhook"); break; }
      if (planSlug === "pro") {
        console.log(`Upgrading user ${userId} to pro plan`);
        await upgradePlan(userId, c.env);
      }
      break;
    }
    case "subscription_item.cancelled": {
      const userId = event.data.payer.userId;
      console.log(`Downgrading user ${userId} to free plan`);
      await downgradePlan(userId, c.env);
      break;
    }
    case "subscription_item.ended": {
      const userId = event.data.payer.userId;
      if (!userId) { console.error("Missing userId in webhook"); break; }
      if (event.data.plan.slug === "pro") {
        console.log(`Downgrading user ${userId} to free plan`);
        await downgradePlan(userId, c.env);
      }
      break;
    }
    case "subscription.past_due":
      console.warn(`Payment past due for user — Clerk will retry automatically`);
      break;
    default:
      console.log("Unhandled webhook type:", eventType);
  }

  return c.json({ received: true, type: eventType });
});
```

---

## Mount Routes in Worker

In `index.ts` (worker entry point), mount the new routes:

```typescript
// Webhook route — BEFORE auth middleware (no auth needed for webhooks)
app.route("/webhooks/clerk-billing", webhookRoutes);

// Billing route — after auth middleware
app.route("/api/billing", billingRoutes);
```

- Webhook routes go **before** the auth middleware because Clerk sends them server-to-server.
- Billing routes go after auth middleware (user must be authenticated).

---

## Frontend Webhook Route (Not Needed)

A Next.js API route at `app/api/webhooks/clerk-billing/route.ts` was initially considered but is unnecessary. The Cloudflare Worker backend handles all webhook processing directly.

---

## Credits Display Component

Create `credits-display.tsx` in the editor components directory.

```typescript
const proPlanId = process.env.NEXT_PUBLIC_CLERK_PRO_PLAN_ID;

interface CreditsData {
  remaining: number;
  total: number;
  plan: "free" | "pro";
  periodEnd: string;
  isUnlimited: boolean;
}
```

### Component Logic

- Uses `useAuth()` from `@clerk/nextjs` to get `getToken`.
- Fetches credits from the API on mount via `useEffect`.
- Creates an API client with the auth token: `createApiClient(getToken)`.
- Calls `client.credits.get()` to retrieve credit data.
- Shows a **Skeleton** while loading, "Credits unavailable" if fetch fails.

### Display Behavior

- **Pro plan users**: Show infinity symbol and "Unlimited" label.
- **Free plan users**: Show a progress bar indicating credits used vs. remaining.
- **Plan label and CTA**:
  - Pro users see a "Manage Subscription" link.
  - Free users see a **CheckoutButton** from `@clerk/nextjs/experimental`.

```tsx
import { CheckoutButton } from "@clerk/nextjs/experimental";

// Inside JSX for free plan users:
<CheckoutButton planId={proPlanId} planPeriod="month" />
```

Place the `<CreditsDisplay />` component in the **app sidebar layout** where the credits TODO placeholder was.

---

## Upgrade CTA Component

Create `upgrade-cta.tsx` in the editor components directory. This modal appears when free-plan users try to use premium features.

### Trigger Conditions

- User sends a message with **zero credits remaining**
- User selects a **premium model** on the free plan
- User tries to create a **fourth project** on the free plan
- User tries to **export** on the free plan

```typescript
export interface UpgradeCTAProps {
  reason: string;
  resetDays?: number;
}

const proFeatures = [
  "Unlimited credits",
  "Unlimited projects",
  "Export functionality",
  "Premium AI models",
  // ...
];
```

### Usage in Chat Panel

In `chat-panel.tsx`, add the CTA before the chat input when credits are exhausted:

```tsx
{isCreditsExhausted && (
  <div className="border-t border p-3">
    <UpgradeCTA reason="You have used all 50 free messages this month" />
  </div>
)}
```

---

## Testing Credits in Cloudflare KV

To test the zero-credits state:

1. Go to **Cloudflare Dashboard** > Workers > KV namespace.
2. Find the user's credits key (e.g., `credits:user_xxx`).
3. Edit the `remaining` value to `0`.
4. Refresh the app — the upgrade CTA should appear and chat input should be disabled.

---

## Clerk Webhook Configuration

### ngrok Setup for Local Development

Webhooks require a publicly accessible URL. Use **ngrok** to tunnel the local Wrangler dev server.

```bash
npm install -g ngrok
ngrok http 8787
```

ngrok provides a public URL (e.g., `https://abc123.ngrok.io`). Verify it works by visiting `https://abc123.ngrok.io/health`.

### Configure Webhook in Clerk Dashboard

1. Go to **Clerk Dashboard** > Configure > Developers > Webhooks.
2. Add endpoint: `<ngrok-url>/webhooks/clerk-billing`.
3. Subscribe to events:
   - `subscription_item.active`
   - `subscription_item.cancelled`
   - `subscription_item.ended`
   - `subscription.past_due`
4. Copy the **Signing Secret** from the webhook endpoint.

### Add Webhook Secret to Environment

Add to `dev.vars` (Wrangler environment file):

```
CLERK_WEBHOOK_SECRET=whsec_xxxxxxxxxxxxx
```

Restart the Wrangler dev server after adding the secret.

### Test the Webhook

Use Clerk's "Send test event" in the webhook dashboard. A successful test logs:

```
Webhook received: subscription_item.cancelled
Downgrading user <userId> to free plan
```

---

## Clerk Billing Setup

### Why Clerk Billing

- Clerk uses **Stripe** internally but abstracts away Stripe dashboard configuration.
- Only **0.7% per transaction** cost.
- Integrates seamlessly with Clerk's auth ecosystem.
- Reduces payment integration from thousands of lines of code to a few components.

### Enable Billing

1. **Clerk Dashboard** > Billing > Enable user billing > Turn on individual subscriptions.

### Configure Free Plan

- **Name**: Free
- **Key**: `free`
- **Publicly available**: Yes
- **Features** (add each with name, key, description):
  - 50 credits per month (`credits_50`)
  - 3 projects (`projects_3`)
  - Basic models (`basic_models`)
  - Live preview (`live_preview`)
  - Code editor (`code_editor`)

### Configure Pro Plan

- **Name**: Pro
- **Key**: `pro`
- **Monthly price**: $25
- **Annual price**: $20/month ($240/year)
- **Publicly available**: Yes
- **Features**:
  - Unlimited credits (`unlimited_credits`)
  - Unlimited projects (`unlimited_projects`)
  - Premium models (`premium_models`)
  - Export functionality (`export`)
  - Priority support (`priority_support`)

After saving the Pro plan, copy the **Plan ID** and add it to `.env.local`:

```
NEXT_PUBLIC_CLERK_PRO_PLAN_ID=plan_xxxxxxxxxxxxx
```

---

## Pricing Page

Create `app/(marketing)/pricing/page.tsx`.

```tsx
import { PricingTable } from "@clerk/nextjs";
import Link from "next/link";
import { ArrowLeft } from "lucide-react";
import { Navbar } from "@/components/landing/navbar";

export default function PricingPage() {
  return (
    <div className="relative min-h-screen bg-background">
      <Navbar />
      <main className="mx-auto max-w-5xl px-6 pb-20 pt-28">
        <Link href="/">
          <ArrowLeft /> Back to home
        </Link>
        <h1>Pricing</h1>
        <PricingTable />
        <p>All plans include live preview, code editor, version control, and dark mode.</p>
      </main>
    </div>
  );
}
```

- The `<PricingTable />` component from `@clerk/nextjs` renders the plans configured in the Clerk dashboard.
- Clicking "Subscribe" on the pro plan opens the **Clerk checkout** flow.

### Checkout Flow

The **CheckoutButton** in the credits display component needs the `planPeriod` prop:

```tsx
<CheckoutButton planId={proPlanId} planPeriod="month" />
```

After a test card payment succeeds, the user is upgraded to pro with unlimited credits. Revenue appears in the Clerk Billing dashboard.
