# Chapter 5: Landing Page — Lovable Clone Tutorial

Building the landing page with a gradient hero section, input card linking to sign-up, and a responsive navbar with Clerk sign-in/sign-out buttons.

## Component Structure

The landing page uses two components organized with a barrel export:

```
components/
  landing/
    hero.tsx
    navbar.tsx
    index.ts       # barrel export
```

The barrel export keeps imports clean:

```typescript
// components/landing/index.ts
export { Hero } from "./hero";
export { Navbar } from "./navbar";
```

The landing page (`app/page.tsx`) imports both from one path:

```tsx
import { Navbar, Hero } from "@/components/landing";

export default function LandingPage() {
  return (
    <div className="relative min-h-screen overflow-hidden">
      <Navbar />
      <Hero />
    </div>
  );
}
```

## Hero Component

The hero section uses a full-screen gradient background with layered decorative divs, a badge, a headline, a subtitle, and a prompt input card that links to sign-up.

### Gradient Background

Multiple absolutely-positioned divs create the background effect using Tailwind gradient utilities:

```tsx
<section className="relative flex min-h-screen flex-col items-center justify-center px-6">
  {/* Background gradient layers */}
  <div className="pointer-events-none absolute inset-0 overflow-hidden">
    <div
      className="absolute inset-0"
      style={{
        background: "linear-gradient(to bottom, #1A0A53, #0F0A2E, #1C1C1C)",
      }}
    />
    {/* Additional decorative gradient divs */}
  </div>
  {/* Content sits on top */}
</section>
```

### Content Area

The content area is centered with a max width and stacked vertically:

- **Badge** inside a `<Link>` to `/sign-up` with secondary variant, glass-effect styling (`backdrop-blur-sm`, border, translucent background)
- **H1 headline** ("Build something lovable") with responsive text sizes: `text-4xl` base, `sm:text-5xl`, `md:text-6xl`
- **P subtitle** ("Create apps and websites by chatting with AI")
- **Input card** — a `<Link>` to `/sign-up` styled as a dark card with icons, mimicking a chat input prompt

### Key Classes

```
relative z-10 flex w-full max-w-2xl flex-col items-center text-center
```

The `z-10` ensures content renders above the gradient layers.

## Navbar Component

The navbar is a fixed header with the logo on the left and auth buttons on the right.

### Layout

```tsx
<header className="fixed top-0 z-50 w-full">
  <nav className="mx-auto flex h-16 max-w-6xl items-center justify-between gap-2 px-6 text-lg">
    <Link href="/">
      <Image src="/logo.svg" alt="Lovable Clone" ... />
    </Link>
    <div className="flex items-center gap-3">
      {/* Auth buttons */}
    </div>
  </nav>
</header>
```

Key layout decisions:
- **`fixed top-0 z-50`** keeps the navbar pinned at the top above all content.
- **`justify-between`** pushes the logo left and buttons right. An earlier mistake of using `justify-center` caused elements to stack in the middle.
- The logo SVG is a copy of `icon.svg` renamed to `logo.svg` in the `public/` directory.

### Clerk Auth Buttons

The navbar uses Clerk's `<SignedIn>` and `<SignedOut>` wrapper components to conditionally render buttons:

```tsx
import { SignedIn, SignedOut } from "@clerk/nextjs";

<SignedOut>
  <Link href="/sign-in">
    <Button variant="ghost">Login</Button>
  </Link>
  <Link href="/sign-up">
    <Button>Get Started</Button>
  </Link>
</SignedOut>

<SignedIn>
  <Link href="/dashboard">
    <Button>Dashboard</Button>
  </Link>
</SignedIn>
```

- When **signed out**: show "Login" and "Get Started" buttons.
- When **signed in**: show a "Dashboard" button.

### Clerk Version Compatibility

The `<SignedIn>` and `<SignedOut>` components were not available in `@clerk/nextjs` v7. Downgrading to **v6.37.4** resolved the issue:

```json
{
  "@clerk/nextjs": "6.37.4"
}
```

After changing the version in `package.json`, run `npm install` and restart the dev server. Always verify component exports exist in your installed Clerk version before debugging further.
