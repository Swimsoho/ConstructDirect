# BuildConnect.com — Visual Design, UX & User Journeys Teardown (live capture 2026-10-21)

Method note (applies to every section): The company is BuildConnect at **buildconnect.com** (footer: "© 2026 Build Connect Inc.", 806 164th St SW Building A, Lynnwood, WA 98037, (206) 888-2425, support@buildconnect.com). It is not BuildDirect.com. Firecrawl was tried first, as the user asked, but the connected Firecrawl account returned "Insufficient credits", so no Firecrawl screenshots exist. All screenshots and computed-style data came from headless Chromium (Playwright 1.56, pre-installed browser) at 1440×900 desktop and iPhone 13 emulation (390×844 CSS px, 3x DPR, so mobile PNGs are 1170 px wide). Capture was polite: one page at a time, 2.5–3 s apart. There was no login and no account creation, and no form was submitted (the enquiry, quote, contact, catalog-download and register forms were opened or clicked open but never filled and sent). `https://buildconnect.com/robots.txt` returns an Express error page ("Cannot GET /robots.txt"), so no robots rules exist and no paths are disallowed. The user's own scrape (`_source_user_scrape.txt`, a Firecrawl result of /home) was used for raw HTML, the SVG sprite and metadata. All screenshot paths below are relative to this notes folder.

## What do the key pages look like on desktop and mobile?

### Takeaway
BuildConnect is a clean, warm-neutral Angular/Ant Design site. It has a strong first impression: a full-bleed dusk architecture hero, rust CTAs and Manrope type. Behind it is a thin, B2B-RFQ catalogue: 13 categories with mostly 1–3 subcategories each, a 3-product bathtub listing, no prices anywhere, an empty blog, and a Cabinets subcategory link that dead-ends back at /materials. The product detail page is the most complete page. It has a gallery, spec chips, MOQ and lead time, a ZIP-gated "Create Enquiry", spec accordions and "Similar Items".

### Cited Findings
**Screenshot inventory (55 PNGs in `screenshots/`). Each one is listed with what it shows.**

Overview sheets
- `screenshots/overview_mobile_contact-sheet.png` — 8 mobile above-the-fold frames side by side: home hero, open hamburger drawer, Browse by Category, bathtub listing (filters panel open), listing after tapping "Filters", product detail, Business Account register form, Login.
- `screenshots/overview_desktop_about-contact-register-quartz-catalogs.png` — 6 desktop pages tiled: About Us, Contact, Contact with the audience dropdown open, full Register form, Quartz listing (31 SKUs), Catalogs.

Home (`/` redirects to `/home`)
- `screenshots/home_desktop.png` — full desktop home page, top to bottom: sticky white header; full-bleed dusk courtyard hero with "Simplifying Building Materials Procurement" and Shop Materials (taupe) / Get Quotes (rust) buttons; "Why Build Connect — Smarter, Connected, Sustainable" 3 icon cards; "Expertise — Projects We Cater To" image carousel (Commercial Building, Townhomes, Hotels); dark "Built for Enterprise — A Unified Platform for Sourcing and Delivery" panel with a mock order card ("Project: ABD Builders", "In Progress", Quartz $42,500 Shipped, Flooring $118,900 Awaiting Quote); "Customer References" 3 testimonial cards; "The Collection — Featured Materials" carousel (Bath Tubs, Cabinets); dark footer. Note: the Featured Materials, Multi Family and some image slots look blank in this full-page capture. That is a lazy-load or animation artifact of full-page capture; see the two in-viewport shots below, where the images render.
- `screenshots/home_desktop_fold.png` — desktop first screen: header plus hero only.
- `screenshots/home_featured-materials_in-viewport_desktop.png` — Featured Materials section rendered properly: two horizontal cards (Bath Tubs freestanding tub photo, Cabinets kitchen photo), each with a rust uppercase eyebrow and an outline "View Products" button, plus round prev/next arrows.
- `screenshots/home_testimonials_in-viewport_desktop.png` — "What Our Customers Say": three photo-topped cards (Townhomes, Custom Single Family, Multi Family) with italic quotes. All three are attributed to MSR Communities (Amy Marohl, Dante Watts, Mike Winje).
- `screenshots/home_mobile.png` — full mobile home page (7,822 CSS px tall); every section stacks into one column.
- `screenshots/home_mobile_fold.png` — mobile hero: logo with tagline, circular hamburger icon, 37 px hero headline, both CTAs side by side; the reCAPTCHA badge overlaps the bottom-right of the hero.

Navigation and search
- `screenshots/nav_explore-materials_megamenu_desktop.png` — "Explore Materials" mega menu, opened on click: 4 columns of the 13 categories in uppercase with their subcategories, "View More" under Windows, and an underlined "View All" link at the bottom right.
- `screenshots/nav_hamburger-menu_mobile.png` — mobile 300 px right-side drawer: Home (highlighted pill), Explore Materials, Get Quotes, Catalogs, Blogs, About Us, Contact Us, a divider, then Login and Sign Up as plain text links.
- `screenshots/search_open_desktop.png` — clicking the header magnifier opens a full-width search bar under the header ("What are you looking for today?", X to close).
- `screenshots/search_quartz_typeahead_desktop.png` — "quartz" typed into the global search, 5 s later: no suggestions and no results appear.

Materials (category tree)
- `screenshots/materials_desktop.png` / `materials_desktop_fold.png` / `materials_mobile.png` — "/materials — Browse by Category": a 4-column grid (1 column on mobile) of 13 image cards with rust titles (Bath Tubs, Cabinets, Carpets, Doors, Engineered Stone, Faucets, Flooring, Garage Doors, Lighting, Shower Pans, Tiles, Toilets, Windows) and a lone square search button at top right.
- `screenshots/materials_bath-tubs_desktop.png` / `materials_bath-tubs_mobile.png` — /materials/bath-tubs: breadcrumb "Shop Materials > Bath Tubs" and two subcategory cards (Acrylic Bathtub with 3Piece Wall Surround Kit; Freestanding Massage Bathtub).
- `screenshots/materials_cabinets_desktop.png` / `materials_cabinets_mobile.png` — /materials/cabinets: a single subcategory card, "Kitchen Base Cabinets", on an otherwise empty page. Clicking it (/materials/cabinets/kitchen-base-cabinets) redirects back to /materials, so it is a dead end. Its screenshots were deleted because they duplicated /materials.

Product listing pages (subcategory = PLP)
- `screenshots/subcat_freestanding-massage-bathtub_desktop.png` / `screenshots/subcat_freestanding-massage-bathtub_desktop_fold.png` — listing: breadcrumb, top-right "Search" (outline) and "Filters" (rust, sort-arrows icon) buttons; left rail with Categories accordion (5 shown plus "Show More") and 16 collapsed filter accordions (Color, Material, Finish, Surface Finish, Overflow Included, Drain Included, Mold Resistant, Product Dimension (W X L), Product Height, Faucet Included, Overflow Trim Included, Hand shower, Pump, Head rest Included, Drain Type…). Only 3 product cards: image, grey name, "Model# BA-FMB-HYDR-587A", full-width rust "Create Enquiry". No price, no count, no sort, no pagination.
- `screenshots/plp_filters_expanded_desktop.png` — the same listing after clicking the Color and Faucet Included accordions and the Filters button (shows facet checkbox values).
- `screenshots/subcat_freestanding-massage-bathtub_mobile.png` — full mobile listing: the Categories and Filters panel stacks above the products, so products start below the first screen.
- `screenshots/plp_freestanding-massage-bathtub_mobile_fold.png` — mobile listing first screen: breadcrumb, Search and Filters buttons, Categories list, start of Filters. No product is visible.
- `screenshots/plp_filters-drawer_mobile.png` — after tapping "Filters" on mobile, the panel collapses (Filters button turns grey) and the first product card appears.
- `screenshots/plp_engineered-stone_quartz_desktop.png` — /materials/engineered-stone/quartz: the deepest listing, 31 slab SKUs (7 rows of 4 plus 3) such as Aureo Nero, Black Prism, Calacatta Blaze and Taj Majesty. Each card has a slab photo, name, Model# and "Create Enquiry". The only facet is "Finish: Polished". No pagination.

Product detail page (PDP)
- `screenshots/product_detail_hydrotherapy-bathtub-bl_desktop.png` — PDP at /materials/bath-tubs/freestanding-massage-bathtub/BA-FMB-HYDR-587A/BA-FMB-HYDR-WHI-00249-V1. Left: large lifestyle image plus 3 thumbnails (the third is the black faucet set on white). Right: title "Hydrotherapy Bathtub - BL", a heart (favorite) icon button, Model# and Store SKU#, then a scrolling stack of spec cards (Surface Finish : Smooth Gloss, Color : White, Accent Color, Material : Acrylic, Finish…), each with a single tan chip. Below that: a "Made to Order" tab with Minimum Order Quantity 36 PCS and Estimated Delivery Time (EDT) 120 Days (in red), a required "Delivery Location" ZIP field, and a rust "Create Enquiry" button. Under the fold: a "Product Details" accordion with marketing copy and Key Benefits bullets, a collapsed "Tech Spec" accordion, and "Similar Items You May Like" (2 cards).
- `screenshots/plp_create-enquiry_click_desktop.png` — clicking "Create Enquiry" on a listing card navigates to the PDP with `?openEnquiry=true`. No modal or drawer opened; the user lands on the PDP top.
- `screenshots/product_detail_hydrotherapy-bathtub-bl_mobile.png` — mobile PDP: gallery, then title with Model# and SKU wrapped into cramped two-column text ("Model# BA- / FMB-HYDR- / 587A"), the heart icon under it, then the spec cards.

Quotes
- `screenshots/tools_desktop.png` / `tools_mobile.png` — /tools ("Get Quotes" in the nav): just two centered cards, "Instant Quote — Get a quick quote for your materials." and "Project Quote — Get a comprehensive quote for your whole project.", each with a tan icon tile.
- `screenshots/tools_instant-quote_click_desktop.png` — /instant-quote: a blue info box ("This form provides an Instant Quote for one shipping container of material… * Minimum Order Quantity (MOQ): One Shipping Container"), an Email field and a radio choice of 3 categories (Engineered Stone, Flooring, Tiles). Right: a dark "The Instant Quote Steps" panel numbered 1, 2, 3, 4, 4 (numbering bug).
- `screenshots/tools_project-quote_click_desktop.png` — /project-quote: a long RFQ form with PROJECT DETAILS (Email, Company Website, Quote Due Date, Project Name, Project Type, Project Start Date), MATERIAL DETAILS (multi-select category chips), DELIVERY DETAILS (dashed "+ Add Address"), a "Calculate Price" segmented control (Only for Material | Material With Installation), "Upload Your Project Plan" dropzone (PNG, JPEG, ZIP, PDF) or a cloud link, Project Information and Special Notes (0/2000), and a "Request for Quote" button. Right: a dark 6-step panel (Submit Project Details, Create Your Account, Select Products, RFQ Creation, Plan Review & BOQ Preparation, Review Quote & Place Order).

Catalogs
- `screenshots/catalogs_desktop.png` / `catalogs_desktop_fold.png` / `catalogs_mobile.png` — /catalogs: centered pill filter row (All Categories [rust, active], Doors, Flooring, Carpets, Windows, Engineered Stone) and 6 catalog cover cards in editorial magazine style with vertical spine text (Interior Doors, Spc Flooring, Mineral Crest Carpet, Tailored Motif Carpet, Windows, Quartz).
- `screenshots/catalogs_card-hover_view-download-icons_desktop.png` — hovering a cover shows a dark blurred overlay with two round white icons: download (arrow-to-line) and view (eye).
- `screenshots/catalogs_view-eye_click_desktop.png` — the eye opens an ungated modal preview of the PDF catalog ("DOORS COLLECTION — Built for Beautiful Living", BuildConnect-branded pages).
- `screenshots/catalogs_download_click_desktop.png` — the download icon opens a lead-capture modal: "Fill your contact information below, to download the catalog." with First Name, Last Name, Email Id, US +1 Mobile Number, a rust Submit button and "Already registered user ? Login". It was not submitted.

Content and company pages
- `screenshots/blog_desktop.png` / `blog_mobile.png` — /blog: a "Latest Insights" header with an "All" pill and an empty state, "No Data Found", with a grey inbox illustration. There are zero posts.
- `screenshots/about-us_desktop.png` / `about-us_desktop_fold.png` / `about-us_mobile.png` — /about-us, in order: "OUR COMPANY — Building a Smarter, More Connected Building Materials Experience." with a photo of their 806 A office building; Our Vision / Our Mission cards; a dark "Our Culture & Values" band with pill tags (INNOVATION, TRANSPARENCY, EFFICIENCY, SUSTAINABILITY, CUSTOMER SUCCESS); "What Sets Us Apart?" numbered 1–3 beside a warehouse-racking photo; "Meet the Team" (6 portraits); and a "Ready to source smarter? Get Started Today / Contact Us" CTA band.
- `screenshots/about-us_team_in-viewport_desktop.png` — team row in the viewport: Devi K. (Co-Founder), Sivagopal M. (Founder & Chairman), Nethaji T., Srinivas T., Damodar N., Prasad Illapani (Partners). The Srinivas T. and Prasad Illapani tiles are blank. prasad.png has naturalWidth 0, so that image is broken.
- `screenshots/contact_desktop.png` / `contact_desktop_fold.png` / `contact_mobile.png` — /contact: 3 info cards (Give us a call, Send us an email, Address) above a centered "Get in touch with us" form card: "Tell us more about you" select, names, email, mobile, company name and website, ZIP, State, City, address lines, "What Are You Looking For?" textarea, consent checkbox and Submit.
- `screenshots/contact_audience-dropdown_desktop.png` — the "Tell us more about you" select opened. The only options are Buyer/Purchasing Agent, Logistics Service Provider and Supplier.

Auth (opened only, never submitted)
- `screenshots/register_desktop.png` / `register_full-form_desktop.png` / `register_mobile.png` — /register: split screen. Left is the photo of their office building with "Simplifying Building Materials Procurement — Create an account to get accurate quotes…". Right is "Business Account (Industry Professionals)" with Contact Details (First, Last, Email, Mobile +1 "*For account recovery", Password, Confirm) and Company Details (Company Name, Company Website https://, Zip, City, State, Address Line 1, Line 2 optional), a T&C checkbox, Register, and "Already registered user? Login". The full-page desktop shot cuts off at 900 px because the form scrolls inside its own panel; the 1440×1900 shot shows the whole form.
- `screenshots/login_desktop.png` / `login_mobile.png` — /login: the same split layout with "Welcome Back". Email (person icon), Password (key icon, eye toggle), underlined "Forgot Password?", full-width rust Login button, an "OR" divider, an outline "Login with OTP" button, and "New to the platform? Create an Account".
- `screenshots/login_otp-mode_desktop.png` — after clicking "Login with OTP": an Email field with "Get OTP" and "Login with username".

**Page facts**
- The home page H2 hero reads "Simplifying Building Materials Procurement". Sections in order: Why Build Connect, Projects We Cater To, Built for Enterprise, Customer References, Featured Materials — [buildconnect.com/home](https://buildconnect.com/home); [user scrape](./_source_user_scrape.txt)
- /materials lists 13 categories. The mega menu lists their subcategories: Bath Tubs (2), Cabinets (1), Carpets (1: Broadloom), Doors (1: Slab), Engineered Stone (1: Quartz), Faucets (2), Flooring (1: Spc), Garage Doors (1: Aluminum), Lighting (3), Shower Pans (1: SMC Shower Tray), Tiles (1: Ceramic), Toilets (2), Windows (3 shown plus "View More") — [buildconnect.com/materials](https://buildconnect.com/materials)
- /materials/cabinets/kitchen-base-cabinets redirects to /materials (observed final URL), even though Cabinets is one of only two "Featured Materials" on the home page — [buildconnect.com/materials/cabinets](https://buildconnect.com/materials/cabinets)
- The freestanding massage bathtub listing shows 3 products and 16 facet groups. The Quartz listing shows 31 SKUs and 1 facet — [freestanding-massage-bathtub](https://buildconnect.com/materials/bath-tubs/freestanding-massage-bathtub); [quartz](https://buildconnect.com/materials/engineered-stone/quartz)
- The PDP shows "Made to Order", "Minimum Order Quantity: 36 PCS", "Estimated Delivery Time (EDT): 120 Days", a required Delivery Location ZIP, and "Create Enquiry". No price is displayed anywhere on the public site — [PDP](https://buildconnect.com/materials/bath-tubs/freestanding-massage-bathtub/BA-FMB-HYDR-587A/BA-FMB-HYDR-WHI-00249-V1)
- The blog shows "Latest Insights … No Data Found" — [buildconnect.com/blog](https://buildconnect.com/blog)
- The /tools page's `<title>` is "Construction Tools | Reliable & Professional Tools – BuildConnect", but the page only contains the two quote-type cards — [buildconnect.com/tools](https://buildconnect.com/tools)
- Page titles: Materials "Build Connect - Material"; PDP "Build Connect - HYDROTHERAPY BATHTUB - BL" (all caps); Blog "Build Connect - Blog"; Catalog "Build Connect - Catalog". Home og:title is "BuildConnect | Construction Materials, Tools & Technical Solutions" — live DOM capture; [user scrape](./_source_user_scrape.txt)

### Inferences
- The catalogue is shallow (roughly 20 subcategories, many holding a handful of SKUs) and is presented with a full e-commerce chrome: facets, search, breadcrumbs and favorites. Empty states (blog), dead ends (Kitchen Base Cabinets) and 16 facets over 3 products make the site feel unfinished, or like a staging site pushed to production. A competitor with even modestly deeper, priced inventory would look far more credible.
- The PDP is the strongest template to borrow structurally: gallery, spec cards, MOQ and lead-time block, ZIP-based delivery check, Details and Tech Spec accordions, similar items. Beat it by adding price or price bands, real variant selectors (each spec chip currently has only one value), downloadable spec sheets, and sample ordering.

### Gaps
- Full mobile captures exist for every page listed, but mobile mega-menu expansion and the mobile Create Enquiry flow were not captured.
- Login-gated pages (dashboard, order tracking, quotes) were deliberately not accessed. The behavior after a ZIP is entered and "Create Enquiry" is clicked was not tested, because that would submit a form.
- The favorite (heart) icon's behavior for anonymous users was not verified; two automated attempts clicked the header search icon instead.
- The Firecrawl `branding` format could not be used because the account was out of credits. The tokens below come from computed styles instead.

## What is the brand system (logo, colors, type, components, icons, imagery, tone)?

### Takeaway
The brand system is a coherent "warm industrial" palette built around a rust primary (#A04423) with a navy ring in the logo, warm off-white and greige surfaces, charcoal footer and panels, and taupe/tan secondary accents. It uses one typeface (Manrope), 10 px rounded Ant Design buttons, and Lucide outline icons alongside a custom filled SVG sprite. Execution is inconsistent: section titles are `<h5>`, no page has an `<h1>`, colors are hard-coded inline, and a cyan `--accent` token is declared but unused.

### Cited Findings
**Logo**
- "BC" monogram inside a navy ring next to the wordmark "Build Connect" and the tagline "Source Smart, Stay Connected". The SVG fills are navy ring `#121B26`, rust "BC" `#A04424` and near-black wordmark `#0D0C0A`. The logo is served as `BC-logo.svg` (240×67) from the `buildconnectstouat` Azure blob — [logo SVG](https://buildconnectstouat.blob.core.windows.net/buildconnect/assets/BC-logo.svg); [home](https://buildconnect.com/home)

**Color tokens** (computed styles from the live DOM, plus CSS custom properties on `:root`)

| Role | Hex | Where seen |
|---|---|---|
| Primary (CSS `--primary`) | #A04423 | Sign Up, Get Quotes, Create Enquiry, Register and Login buttons; eyebrows; active nav underline; category card titles; footer social tiles |
| Accent (CSS `--accent`) | #3FDBF1 | Declared, but not found among rendered colors (unused) |
| Border (CSS `--border`) | #CBD5E1 | Default border (Tailwind slate-300) |
| Secondary button (hard-coded) | #8C765C | Hero "Shop Materials" (`!bg-[#8C765C]` inline Tailwind class) |
| Spec chip | #A3815F | PDP spec value chips, with white text |
| Page background | #FCF9F8 | `body` |
| Section bands | #E8E4DF / #E3DBD0 | Greige section backgrounds (Why, Featured) |
| Body text | #3C4949 | `body` color (dark slate-teal) |
| Headings | #1C1917 | `h5` section titles (Tailwind stone-900) |
| Default/outline button | #6D6E71 | Login button text and border |
| Header border | #E7E5E4 | Header bottom border (stone-200) plus shadow-sm |
| Footer and dark panels | #282727 (footer), ~#2E2E2E | Footer; "Built for Enterprise" panel; quote-steps side panels |
| Light tan | #D9C3A8 | Icon tiles and accents (13 occurrences) |

— [home](https://buildconnect.com/home); [PDP](https://buildconnect.com/materials/bath-tubs/freestanding-massage-bathtub/BA-FMB-HYDR-587A/BA-FMB-HYDR-WHI-00249-V1)
- The scrape's inline SVG sprite contains illustration colors (#99A1B7, #C7D2E5, #3D706F, #576574, #1FB35B green, #E15F78, #54A0FF, #FF6B6B, #FECA57). These belong to icon artwork, not the UI palette — [user scrape](./_source_user_scrape.txt)

**WCAG contrast (computed from the hex values above)**
- White on primary rust: 6.28:1 (passes AA).
- White on spec chip #A3815F: 3.58:1 (fails AA for 14 px text).
- White on taupe #8C765C "Shop Materials": 4.32:1 (fails AA for 16 px/600 text, just under 4.5).
- Rust on page background: 5.99:1. Body text on page background: 8.94:1.
- — computed by the researcher from colors observed on [home](https://buildconnect.com/home) and the PDP

**Typography**
- Manrope everywhere (`Manrope, system-ui, -apple-system, sans-serif`); no second typeface.
- Hero `<h2>`: 60/66 px, weight 400, white (37.4 px on mobile).
- Section titles are `<h5>` at 28.8/43.2 px, weight 600.
- Enterprise panel `<h3>`: 40/48 px, weight 700.
- Eyebrows (`.bc:eyebrow`): 16 px, weight 600, uppercase, 1.6 px letter-spacing, rust.
- Body: 16/24.
- Buttons: 16 px, weight 600 (PDP CTA 18 px, weight 600).
- No captured page (home, materials, PDP, about, contact, login, register) contains an `<h1>`.
- — live DOM computed styles, [home](https://buildconnect.com/home)

**Shape, spacing and elevation**
- Border radius: 10 px is dominant (buttons, cards; 22 occurrences on home), plus 50% (round icon buttons and carousel arrows), 20 px, 12 px, 8 px, 6 px (spec chips) and 999 px (catalog filter pills).
- Buttons are about 40 px tall with 24 px horizontal padding.
- Header: white, about 77 px tall, with `shadow-sm` (0 1px 3px rgba(0,0,0,.1)) and a 1 px #E7E5E4 bottom border.
- Category grid: 4 columns of about 305 px cards with 40 px gaps and about 50 px side gutters at 1440.
- Listing left rail: about 240 px.
- Cards: white with a soft shadow, image on top, rust title below.
- — live DOM and [materials](https://buildconnect.com/materials)

**Component library and stack**
- Angular 19.2.14 with server-side rendering (`ng-version="19.2.14" ng-server-context="ssr"`).
- ng-zorro (Ant Design): `ant-btn`, `nz-button`, `ant-select`.
- Tailwind utility classes alongside custom `bc:`-namespaced classes (`bc:section:hero`, `bc:why:card`, `bc:eyebrow`).
- Icons via `@ng-icons` with Lucide (`lucideArrowLeft`, `lucideCheckCircle`, `lucideX`, `lucideLogOut`, `lucideEye`, `lucideArrowDownToLine`).
- Google reCAPTCHA badge on every page.
- Images go through a Thumbor resizer at `buildconnect-thumbor-uat.azurewebsites.net/unsafe/filters:quality(60):format(webp)/…`.
- — [user scrape](./_source_user_scrape.txt); [home](https://buildconnect.com/home)

**Custom icon sprite**
- The page ships 49 hidden `<symbol>`s, including:
  - symbol-join, symbol-request, symbol-request-callback, symbol-request-meet
  - symbol-register-* (accessto, browse-sku, check, direct-sales, doorstep, exclusive, fast-check, genrate-professional, get-quotes, save-fav, support, track-order, your-dashboard)
  - symbol-what-we-offer-one/two/three, symbol-hassle-free-delivery, symbol-quality-assurance, symbol-value-engineering
  - symbol-excel-upload, symbol-uploaded-excel-file-show, symbol-drop-whatsapp, symbol-payment-error, symbol-print, symbol-file-pdf, symbol-download-file, symbol-chat-stars, symbol-instant-message, symbol-calendar, symbol-trash, symbol-duplicate
- These are filled 51×51 glyphs using `currentColor`, distinct from the 24 px stroke-2 Lucide outline icons used in the visible UI.
- — [user scrape](./_source_user_scrape.txt)

**Imagery**
- Warm-lit architecture and staged interiors: dusk courtyard hero; Commercial / Townhomes / Hotels project cards; bathroom and kitchen lifestyle shots per category; quartz slab swatches.
- Real photography of their own Lynnwood office building ("806 A") on Register, Login and About.
- Editorial magazine-style catalog covers with vertical spine typography.
- Featured-material images have `alt="undefined"`.
- — [home](https://buildconnect.com/home); [catalogs](https://buildconnect.com/catalogs); [user scrape](./_source_user_scrape.txt)

**Tone of voice**
- Headlines are procurement/B2B-SaaS abstractions: "Simplifying Building Materials Procurement", "Smarter, Connected, Sustainable", "A Unified Platform for Sourcing and Delivery", "Ready to source smarter?", "Building a Smarter, More Connected Building Materials Experience."
- CTAs: Shop Materials, Get Quotes, Learn More (links to /register), View Products, Create Enquiry, Request for Quote, Get Started Today, Register.
- Trust row: "Proud Member of" Built Green, NAHB and Quality Builders Warranty.
- — [home](https://buildconnect.com/home); [about-us](https://buildconnect.com/about-us)

**Copy and finish defects observed**
- Placeholder "(eg) Deo" (for "Doe") and "Johndeo@gmail.com".
- Register ZIP placeholder "(eg) 111024" (a 6-digit, non-US format).
- Instant Quote steps numbered 1, 2, 3, 4, 4, with the typo "quanities".
- The contact form's consent checkbox reads "By creating an account on BuildConnect.com…" although it is a contact form.
- "Acrylic Bathtub with 3Piece Wall Surround Kit"; "Spc Flooring" casing.
- — [instant-quote](https://buildconnect.com/instant-quote); [contact](https://buildconnect.com/contact); [register](https://buildconnect.com/register)

### Inferences
- The palette and type are worth borrowing in spirit, since warm rust and greige read as "building materials" rather than generic tech blue. A competitor can beat it by adding the missing pieces: a true `<h1>` hierarchy, a tokenized secondary color with AA contrast, one icon family, and a used or removed accent color.
- The sprite hints at logged-in features BuildConnect has built or planned but does not show publicly: Excel/BOQ upload, WhatsApp contact, request-a-callback/meeting, value engineering, order tracking, a dashboard, saved favorites, payments and printing. Expect their logged-in app to compete on RFQ, BOQ and order-tracking workflow, not on browse UX.
- Production pages load the logo, hero, og:image and most imagery from hosts named `…stouat…` and `…thumbor-uat…`, mixed with `…stopr…` for category images. That indicates UAT/staging asset hosts leaking into production; it is fragile and reads as unpolished to technical buyers.

### Gaps
- Exact spacing scale and breakpoints were inferred from screenshots, not from source CSS. Tailwind config and design tokens beyond the three `:root` variables were not found.
- It is unclear whether imagery is licensed photography, CGI or AI-generated. Several lifestyle and hero images have a render-like look, but this could not be verified.

## What are the navigation structure, header/footer, search, filters, sorting, pagination, comparison, favorites and CTAs?

### Takeaway
Navigation is conventional and clear: a 7-item top nav, a click-to-open mega menu, and a right-side mobile drawer. Discovery features beyond that are weak or broken:
- **Search:** the global search returned nothing for "quartz" despite a 31-SKU Quartz category.
- **Filters:** they live in a left rail and push products below the fold on mobile.
- **Missing listing basics:** there is no sort, result count, pagination, comparison or price.
- **Favorites:** a heart icon exists only on the PDP.
- **Conversion:** almost everything converts through "Create Enquiry", the quote forms or a lead-gated catalog download.

### Cited Findings
- **Header (desktop):**
  - Logo on the left.
  - Center nav: Home, Explore Materials (mega menu on click), Get Quotes (/tools), Catalogs, Blogs, About Us, Contact Us. The active item is shown in rust text with an underline.
  - On the right: a search magnifier, an outline "Login" button and a filled rust "Sign Up" button.
  - Mobile: logo plus a circular hamburger that opens a 300 px drawer with the same links plus Login and Sign Up.
  - — [home](https://buildconnect.com/home); `screenshots/nav_hamburger-menu_mobile.png`
- **Mega menu:** 4 columns, uppercase category headings with subcategory links, "View More" and "View All" — `screenshots/nav_explore-materials_megamenu_desktop.png`
- **Footer:**
  - Charcoal #282727 with "Proud Member of" and logos for Built Green, NAHB and Quality Builders Warranty.
  - 10 category links. Tiles, Toilets and Windows are missing even though they are live categories.
  - Company links: About Us, Blogs, Contact, FAQs, Disclaimer.
  - Address, phone and email with rust outline icons.
  - Rust square social tiles: YouTube @Build-Connect, Facebook, Instagram @build_connect_llc, LinkedIn.
  - Bottom bar: Privacy Policy, Terms & Conditions, Cookie Policy.
  - — [materials](https://buildconnect.com/materials)
- **Global search:**
  - The magnifier reveals a full-width input ("What are you looking for today?").
  - Typing "quartz" (slowly, then waiting 5 s) produced no suggestions.
  - Pressing Enter did not navigate (the URL stayed /home), and no network request containing search/suggest/query was observed.
  - — `screenshots/search_quartz_typeahead_desktop.png`; [home](https://buildconnect.com/home)
- **In-listing search:** listings and /materials also have a separate in-page "Search" button (not tested).
- **Filters and facets:**
  - Left-rail accordions generated from product attributes. The bathtub listing has 16 facets, some with near-duplicate values (e.g., "Black Finished", "Chrome Finished" and "Gold Finished" repeated under Faucet Included, Overflow Trim Included and Hand shower).
  - A rust "Filters" button with a sort-arrows icon toggles the panel; on mobile the panel is open by default above the products.
  - — [freestanding-massage-bathtub](https://buildconnect.com/materials/bath-tubs/freestanding-massage-bathtub); `screenshots/plp_filters-drawer_mobile.png`
- **Sorting, pagination, comparison:**
  - No sort control, result count or pagination on any listing; the Quartz listing renders all 31 SKUs on one page.
  - No compare checkbox or compare tray anywhere, even though the home copy promises "easy material comparisons".
  - — [quartz](https://buildconnect.com/materials/engineered-stone/quartz); [home](https://buildconnect.com/home)
- **Favorites:**
  - The PDP has a heart icon button next to the title; there is no favorites control on listing cards.
  - The SVG sprite includes `symbol-register-save-fav`, which suggests favorites are a registered-user benefit.
  - — [PDP](https://buildconnect.com/materials/bath-tubs/freestanding-massage-bathtub/BA-FMB-HYDR-587A/BA-FMB-HYDR-WHI-00249-V1); [user scrape](./_source_user_scrape.txt)
- **Calls to action:**
  - Home: Shop Materials (→/materials), Get Quotes (→/tools), Learn More (→/register), View Products (→category).
  - Listings and PDP: Create Enquiry.
  - Quotes: Request for Quote (Project); a multi-step Instant Quote.
  - Catalogs: View (ungated) and Download (lead form).
  - About: Get Started Today, Contact Us.
  - Global: Sign Up.
  - — live captures above
- **Product grids are client-rendered:** the server-rendered HTML of three listings (quartz, freestanding bathtub, flooring) contains zero "Model#" strings. The PDP has no JSON-LD structured data and no `<h1>` — curl of [quartz](https://buildconnect.com/materials/engineered-stone/quartz); live DOM of the PDP

### Inferences
- The visible information architecture is fine to copy (category, then subcategory, then listing, then PDP, with breadcrumbs). Discovery is where a competitor can win outright: working instant search with typeahead (SKU, color names like "Calacatta", and categories), price and lead-time facets, sort by price or lead time, and side-by-side compare. Each is missing or broken here.
- Client-rendered listings, missing `<h1>`s, generic titles and no Product schema mean BuildConnect's catalog is probably weak in organic search. Server-rendered, schema-rich PDPs and listings are an easy SEO edge.
- Putting the enquiry button on every listing card is a good pattern for RFQ commerce. But it links to the PDP (`?openEnquiry=true`) without opening anything, so the CTA's promise is not kept.

### Gaps
- The in-listing "Search" button and the facet checkbox results (whether checking a value actually filters) were not exercised.
- It is unclear whether search works for logged-in users or for other terms. Only "quartz" was tested, to keep request volume low.

## What are the user journeys for each audience, and where is the friction?

### Takeaway
The site is really built for one audience: business buyers (builders, developers, purchasing agents) placing large, made-to-order RFQs. Their journey is rich but slow (a 6-step project quote with manual BOQ preparation) and forces account creation mid-funnel. Homeowners are mentioned in copy but effectively excluded: business-only registration, MOQs of 36 pieces or a full container, and no prices. Architects and designers have no samples, boards or spec downloads. Suppliers and manufacturers have no onboarding path beyond a Contact dropdown option.

### Cited Findings
- **Contractor/builder: project RFQ (primary journey)**
  1. Home hero "Get Quotes" → /tools → "Project Quote".
  2. /project-quote form: Email, Company Website, Quote Due Date, Project Name, Project Type, Project Start Date; category chips; Delivery Address (+ Add Address); Calculate Price (Only for Material / Material With Installation); plan upload (PNG, JPEG, ZIP, PDF) or a Dropbox / Google Drive link; Project Information and Special Notes; "Request for Quote".
  3. The side panel lists the remaining steps: Create Your Account → Select The Products Of Interest → RFQ Creation ("assigned to our team for review and processing") → Plan Review & BOQ Preparation ("Our team reviews your drawings, prepares the Bill of Quantities (BOQ), and finalizes the project pricing") → Review Quote & Place Order.
  4. — [project-quote](https://buildconnect.com/project-quote)
- **Container buyer: Instant Quote**
  1. /tools → "Instant Quote" → /instant-quote. The banner states that the MOQ is one shipping container and sends smaller buyers back to "explore our materials".
  2. Email, then one of 3 categories (Engineered Stone, Flooring, Tiles).
  3. Steps: Submit Material Details → Create Your Account → Select A Design → Review Instant Quote ("pricing, quanities and estimated delivery") → Place Your Order ("our team will follow up").
  4. — [instant-quote](https://buildconnect.com/instant-quote)
- **Browse-to-enquiry (any pro)**
  1. Home "Shop Materials" or mega menu → /materials → category → subcategory listing → card "Create Enquiry".
  2. That lands on the PDP (`?openEnquiry=true`, no modal) → enter Delivery Location ZIP → "Create Enquiry" (post-click behavior not tested).
  3. The PDP shows MOQ 36 PCS and EDT 120 Days for a bathtub.
  4. Friction: the Cabinets path dead-ends, global search returns nothing, and there is no price.
  5. — [PDP](https://buildconnect.com/materials/bath-tubs/freestanding-massage-bathtub/BA-FMB-HYDR-587A/BA-FMB-HYDR-WHI-00249-V1); [cabinets](https://buildconnect.com/materials/cabinets)
- **Registration**
  - /register offers only "Business Account (Industry Professionals)", with 13 required fields including Company Name, Company Website, Zip, City, State and Address Line 1, plus a T&C checkbox and reCAPTCHA.
  - Login supports password or "Login with OTP" by email.
  - — [register](https://buildconnect.com/register); [login](https://buildconnect.com/login)
- **Homeowner**
  - Home copy says "Everyone involved, from builders to homeowners, gets the latest updates…", and the hero says "residential and commercial projects".
  - There is no consumer sign-up, and the contact form's "Tell us more about you" options are only Buyer/Purchasing Agent, Logistics Service Provider and Supplier.
  - — [home](https://buildconnect.com/home); [contact](https://buildconnect.com/contact); `screenshots/contact_audience-dropdown_desktop.png`
- **Architect/designer**
  - No sample ordering, mood boards, project lists or BIM/CAD downloads are visible.
  - PDPs have a "Tech Spec" accordion (contents not captured).
  - Catalog PDFs can be previewed free, but downloading requires a name, email and mobile number (lead form).
  - — [catalogs](https://buildconnect.com/catalogs); `screenshots/catalogs_download_click_desktop.png`
- **Supplier/manufacturer and logistics**
  - No "Sell on BuildConnect" or "Become a supplier" page, nav item or footer link exists. The only entry is the Contact form's "Supplier" or "Logistics Service Provider" option.
  - Demo content shows "Supplier: Build Connect" on order lines, implying BuildConnect sells as the merchant rather than as an open multi-vendor marketplace.
  - — [contact](https://buildconnect.com/contact); [home](https://buildconnect.com/home)
- **Social proof**
  - All three testimonials are attributed to a single company, MSR Communities.
  - Projects We Cater To lists Commercial Building, Townhomes and Hotels.
  - — [home](https://buildconnect.com/home)

### Inferences
**Friction to beat**

| Friction | Impact | Cited above |
|---|---|---|
| Zero price transparency | Every path ends in an enquiry or RFQ | Yes |
| Account wall after data entry | Steps 1 then 2 of both quote flows | Yes |
| Manual BOQ turnaround | Pricing waits on a team | Yes |
| High MOQs and long lead times | 36 PCS; one container; 120 days | Yes |
| Dead ends and empty states | Cabinets; empty blog | Yes |
| Broken global search | No results, no request fired | Yes |
| Filter-first mobile listing | Products start below the fold | Yes |
| Lead-gated catalog download | Name, email and mobile required | Yes |
| Single-company testimonials | Credibility risk | Yes |

**Opportunities for ConstructDirect**
- Serve homeowners and small contractors with low or no MOQ and visible pricing, since BuildConnect explicitly pushes sub-container buyers away.
- Give architects and designers samples and boards.
- Offer an explicit supplier onboarding funnel.
- Keep a project-RFQ path with plan upload. It is a genuinely strong feature to match, especially the "Material With Installation" toggle and cloud-link fallback for large plan sets. But return indicative pricing instantly and defer account creation until the quote is ready.

### Gaps
- Post-submission states (enquiry confirmation, quote review, order tracking) are behind login or form submission and were not observed.
- Time-to-quote and BOQ turnaround SLAs are not stated publicly.
- Whether BuildConnect also lists third-party suppliers' products could not be confirmed.

## How do the visuals and UX compare with polished peers (BuildDirect, Houzz, ArchiPro, Material Bank, Home Depot Pro)?

### Takeaway
BuildConnect's visual polish (hero, palette, catalog covers, PDP layout) is roughly on par with mid-market peers. Its functional UX trails every peer on the dimension that peer is known for: Material Bank on free overnight sampling, BuildDirect on pro pricing tiers and samples, Home Depot Pro on online quoting tied to known pricing, Houzz on saving and visualizing products, and ArchiPro on linking products, professionals and projects with direct messaging.

### Cited Findings
- **Material Bank:** sampling is free for approved architects and designers. Next-day delivery is available (US cutoff midnight ET, delivered by 10:30 AM). Multiple brands' samples arrive in one box via FedEx Priority Overnight, with prepaid returns. Users can request pricing and save samples to boards — [Material Bank FAQs](https://www.materialbank.com/faqs); [Material Bank EU how it works](https://materialbank.eu/how-it-works)
- **BuildDirect Pro:** "5 free samples + expert help from selection through delivery". Tiered pro pricing on rolling 12-month spend (Pro Select under $20k, Pro Preferred $20k–$49,999, Pro VIP $50k+), Net 30 for qualifying tiers, jobsite delivery and a trade support line. Tiers may have changed since the 2023 launch — [BuildDirect Pro page](https://www.builddirect.com/pages/pro); [BuildDirect BDPros](https://www.builddirect.com/BDPros)
- **Home Depot Pro:** Pros can "create quotes and collaborate with the Pro Desk", track costs and "lock in Preferred Pricing to create better Quotes across your jobs". Store Pro Desks offer custom quotes, bulk pricing and jobsite delivery — [Home Depot Pro Resource Center](https://www.homedepot.com/c/pro_resource_center); [Home Depot Pro Desk](https://www.homedepot.com/l/Peoria/AZ/Peoria/85345/453/pro-desk)
- **Houzz:** "View in My Room" places Houzz Shop products into the user's room via the camera and saves captures to ideabooks. A universal Save button lets users save photos, products and pros to ideabooks. A UX case study found users struggled to find saved items and to discover the feature — [Houzz blog](https://blog.houzz.com/houzz-app-introduces-view-in-my-room/); [Houzz Ideabook features](https://blog.houzz.com/how-to-use-the-latest-ideabook-features-for/); [UX case study](https://uxdesign.cc/houzz-a-ux-case-study-98843fbdfcba)
- **ArchiPro:** professional profiles bundle featured products, projects, articles and videos. Users can message professionals directly and keep items on a personal design board. Professionals receive enquiries in an ArchiPro inbox, and projects are tagged to service providers and product suppliers — [ArchiPro about us](https://resources.archipro.co.nz/about-us); [ArchiPro for professionals](https://business.archipro.co.nz/for-professionals)
- **BuildConnect comparison:** no samples, no visible pricing or price tiers, no boards or saved projects for visitors (a favorites heart only on the PDP), no supplier profiles, and no direct supplier messaging. It does have a project-RFQ form with plan upload and an installation toggle, which peers above do not show publicly in this form — [project-quote](https://buildconnect.com/project-quote); [PDP](https://buildconnect.com/materials/bath-tubs/freestanding-massage-bathtub/BA-FMB-HYDR-587A/BA-FMB-HYDR-WHI-00249-V1)

### Inferences
**Concrete "do better than BuildConnect" list for ConstructDirect**

| # | Recommendation | Benchmark |
|---|---|---|
| 1 | Show price (or price bands and tiered trade pricing) on listing cards and PDPs | BuildDirect |
| 2 | Free or low-cost sample ordering consolidated into one box | Material Bank |
| 3 | Boards/projects that save products, catalogs and quotes, with sharing | Houzz, ArchiPro, Material Bank |
| 4 | Working typeahead search across SKU, color name and category | Fixes BuildConnect's broken search |
| 5 | Sort, result counts, compare tray and price/lead-time facets | — |
| 6 | Supplier profiles with direct messaging and a "Sell with us" funnel | ArchiPro |
| 7 | Keep BuildConnect's best idea: plan-upload project RFQ with a "material + installation" toggle | Return an instant indicative estimate and defer signup |

- Visually, keep the warm rust/greige aesthetic and the editorial catalog covers, which test well against peers. Then fix hierarchy (one `<h1>` per page) and AA contrast on secondary buttons and chips, and server-render listings and PDPs with Product schema.

### Gaps
- Peer claims come from peers' own marketing pages and secondary write-ups. Terms (sample limits, tier thresholds) may have changed; BuildDirect's tiers in particular are described as illustrative.
- No side-by-side screenshots of peer sites were captured. Only BuildConnect was screenshotted, to stay in scope and keep request volume low.
- No usage, traffic or conversion data for BuildConnect was available, so friction severity is a design judgment, not a measured value.
