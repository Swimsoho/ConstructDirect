# MaterialFaire Tracker — Setup Steps

Three files. No build step, no terminal, no npm.

| File | What it is |
|---|---|
| `index.html` | The whole app — deploy this |
| `schema.sql` | Run once in Supabase |
| `SETUP-STEPS.md` | This file |

Total time: about 15 minutes.

---

## Part 1 — Supabase (5 min)

**1.** Go to **supabase.com** → sign in → **New project**

**2.** Name it `materialfaire`, set a database password (save it somewhere), pick the region closest to your team → **Create new project**

**3.** Wait about 2 minutes for it to finish provisioning

**4.** Left sidebar → **SQL Editor** → **New query**

**5.** Open `schema.sql`, copy everything, paste it into the query box

**6.** Click **Run** (or Ctrl+Enter). You should see *"Success. No rows returned"*

**7.** Left sidebar → **Project Settings** (gear icon, bottom) → **API**

**8.** Copy these two values into a scratch note:
- **Project URL** — looks like `https://abcdefgh.supabase.co`
- **anon public** key — a long string starting with `eyJ`

---

## Part 2 — Edit the file (2 min)

**9.** Open `index.html` in a plain text editor — Notepad, TextEdit, or VS Code. **Not Word.**

**10.** Find these two lines, roughly 15 lines below `<script>`:

```js
const SUPABASE_URL      = "https://YOUR-PROJECT-REF.supabase.co";
const SUPABASE_ANON_KEY = "YOUR-ANON-PUBLIC-KEY";
```

**11.** Replace the placeholder text *inside the quotes* with your two values from step 8. Keep the quotes and the semicolons.

**12.** Save the file.

---

## Part 3 — GitHub (3 min)

**13.** Go to **github.com** → **+** (top right) → **New repository**

**14.** Name it `materialfaire-tracker`, select **Private**, leave all the "Initialize this repository" checkboxes unchecked → **Create repository**

**15.** On the empty repo page, click the **"uploading an existing file"** link

**16.** Drag in all three files: `index.html`, `schema.sql`, `SETUP-STEPS.md`

**17.** Click **Commit changes**

---

## Part 4 — Vercel (3 min)

**18.** Go to **vercel.com** → **Add New** → **Project**

**19.** First time only: click **Continue with GitHub** and authorize it

**20.** Find `materialfaire-tracker` in the list → **Import**

**21.** Set **Framework Preset** to **Other**

**22.** Leave **Build Command** and **Output Directory** empty — don't change them

**23.** Click **Deploy**, wait about 30 seconds

**24.** Click **Visit** to open your live URL

---

## Part 5 — First run (1 min)

**25.** The page loads with a yellow banner saying *"Table is empty"* → click **Seed tasks**

**26.** The 15 tasks appear. Bottom-left shows a green dot and *"live"*

**27.** Type your name in the **"you are"** box, top right

**28.** Copy the URL from your browser and send it to the other founders. Each of them types their own name in that box once.

---

## Making changes later

**Task content** (titles, owners, dates, status) — just edit on the live site. It saves to Supabase immediately.

**The app itself** (colours, columns, new workstreams) — GitHub → click `index.html` → pencil icon → edit → **Commit changes**. Vercel redeploys automatically in about 30 seconds.

**Adding a new task** — Supabase → **Table Editor** → `tasks` → **Insert row**. Give it a unique `id`, set `ws` to one of `Foundation` / `Platform` / `Supply Side` / `Demand Side` / `Funding`, and a `sort_order` number that places it where you want. The `deps` field is a Postgres array — type `{F3,S1}`.

**Adding a new workstream** — you also need to add its name to `WS_ORDER` in `index.html`, or its rows won't display.

---

## If something goes wrong

**Red banner, "Could not reach Supabase"** — the URL or key from step 11 has a typo, or step 6 didn't actually run. The banner text tells you which. Check for a missing quote mark first.

**Page is blank** — `index.html` didn't land at the root of the repo. In GitHub it should sit at the top level, not inside a folder.

**Vercel build fails** — you set a Framework Preset other than "Other", or filled in a build command. Go to Project Settings → General and clear both.

**Nothing happens when you click Seed tasks** — the RLS policies from `schema.sql` weren't applied. Re-run the whole file in the SQL editor; it's safe to run twice.

---

## Security — read before sharing the URL

The anon key ships in the browser, so **anyone with the URL can read and edit the board.** That's the deliberate tradeoff for a small founder team with an unadvertised link. `schema.sql` grants select, insert, and update but **not delete**, so a stray click can't wipe the table.

If that stops being acceptable:

- **Quick fix:** Vercel → Project Settings → Deployment Protection → **Password Protection** (requires a paid plan). One shared password, no code changes.
- **Proper fix:** enable Supabase Auth with magic links, then change the RLS policies from `to anon` to `to authenticated`. Roughly an hour of work.

Until one of those is in place, don't put anything in the Notes field you wouldn't want a stranger reading.
