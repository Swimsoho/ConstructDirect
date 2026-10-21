# BuildConnect.com: System Architecture, Tech Stack, Data Model and Site Structure

Scope and method. Evidence was collected on 2026-10-21 from public pages only:
- server-rendered HTML fetched with curl;
- the public JS bundles those pages load;
- the JSON the pages themselves request from `api.buildconnect.com`, captured in the Angular TransferState block of the SSR HTML or from the same GET calls the storefront makes;
- DNS resolution of public hostnames;
- the user's own scrape (`_source_user_scrape.txt`, a Firecrawl JSON dump of `/home`; capture date unknown, treat it as historical).

There was no login, no form submission and no admin-path probing.

Limits on what was checked:
- **The Firecrawl MCP returned "Insufficient credits" on the first call.** No live JS-rendered scrape was possible.
- **Fetching the catalog JSON file from Azure Blob was blocked by this session's permission classifier**, so product-level data was not inspected.

Bundle file names are content-hashed and will change on the next deploy. The `chunk-*.js` URLs cited below are as of 2026-10-21.

Identity check: the footer reads "© 2026 Build Connect Inc.", 806 164th St SW Building A, 1st Floor, Lynnwood, WA 98037, (206) 888-2425, support@buildconnect.com ([/materials](https://buildconnect.com/materials)). This is not BuildDirect.com and not Autodesk's "BuildingConnected".

---

## 1. What is the full stack (front end, rendering, hosting, CDN, image pipeline, storage, back end, third parties)?

### Takeaway
BuildConnect is an **Angular 19.2.14 SPA with SSR and hydration**, served by an **Express (Node) SSR server** on **Azure App Service, Central US**. It has no CDN in front. It talks to a separate **REST API at `https://api.buildconnect.com/api`**, also on App Service; the backend language is unconfirmed and probably Java/Spring.

Supporting services:
- a separate **Python AI service** for floor-plan takeoff;
- a self-hosted **Thumbor** image server;
- **Azure Blob Storage** for assets, catalog PDFs and the product catalog JSON.

Third-party scripts are Google Tag Manager, Google reCAPTCHA, Google Maps, Stripe, PayPal and HubSpot Meetings.

The production build ships **two environment configs**. The image loader is wired to the **UAT** config, so every product and marketing image on production is served from **UAT Thumbor plus the UAT storage account**.

### Cited Findings

**Framework and rendering**
- The root element is `<app-root ng-version="19.2.14" ng-server-context="ssr">`. `<html lang="en" data-beasties-container dir="ltr">` shows Beasties critical-CSS inlining. — [user scrape](/home/user/ConstructDirect/research_notes/BuildConnect%20platform%20teardown/_source_user_scrape.txt); confirmed live on [/home](https://buildconnect.com/home)
- SSR output carries non-destructive hydration markers and an event-replay contract:
  - the `<!--nghm-->` marker;
  - `<script id="ng-state">` holding `__nghData__`;
  - an inline `ng-event-dispatch-contract` script (`window.__jsaction_bootstrap(document.body,"ng",["click"],[])`).
  — [/home](https://buildconnect.com/home)
- The JS build is Angular's esbuild application builder:
  - `main-AXWYUE3F.js` (197 KB) and `polyfills-B6TNHZQ6.js` (35 KB), both `type="module"`;
  - 10 `modulepreload` chunks, about 476 KB of uncompressed initial JS in total;
  - 47 lazily loaded route components via `loadComponent: () => import("./chunk-*.js")`.
  — [main bundle](https://buildconnect.com/main-AXWYUE3F.js)
- CSS:
  - `styles-XDPAX7BW.css` is 828 KB uncompressed;
  - about 82 KB of critical CSS is inlined in `<style>` on the home page;
  - the full sheet is loaded with the `media="print" onload="this.media='all'"` swap;
  - fonts: 90 inlined `@font-face` rules (Google Fonts are inlined, with a preconnect to `fonts.gstatic.com`) plus self-hosted `/Figtree_Normal.woff2` and `/Figtree_Italic.woff2`.
  — [/home](https://buildconnect.com/home)
- Libraries visible in the bundles:
  - Swiper web components (`swiper-container`, `swiper-slide`);
  - `ngx-cookie-service` (a GitHub issue URL `stevermeister/ngx-cookie-service/issues/86` is embedded);
  - `ng-recaptcha` (`ng2recaptchaloaded` callback, `recaptcha-v3-site-key` token);
  - an angular-google-tag-manager service (`gtm_auth`, `gtm_preview`, injects `https://www.googletagmanager.com/gtm.js`).
  — [main bundle](https://buildconnect.com/main-AXWYUE3F.js)
- Images use Angular `NgOptimizedImage` (`ng-img="true"`, `srcset`, `fill`, `placeholder`, `fetchpriority`, `loading="lazy"`) with a **custom Thumbor loader**. The loader builds URLs as `{imageCDNUrl}/unsafe/{W}x0/filters:quality(60):format(webp)/{blobPath}`. — [image loader in chunk-3YAEHGNB.js](https://buildconnect.com/chunk-3YAEHGNB.js); example `https://buildconnect-thumbor-uat.azurewebsites.net/unsafe/640x0/filters:quality(60):format(webp)/buildconnectstouat.blob.core.windows.net/...` on [/home](https://buildconnect.com/home)

**Hosting, server and DNS**
- HTML responses carry `x-powered-by: Express`. There is no `server`, `cache-control`, HSTS, CSP or X-Frame-Options header on HTML. Unknown paths such as `/robots.txt` return Express's default `Cannot GET /robots.txt` 404 with `content-security-policy: default-src 'none'`. — curl of [/home](https://buildconnect.com/home) and [/robots.txt](https://buildconnect.com/robots.txt)
- DNS on 2026-10-21: every hostname CNAMEs to an Azure App Service app on the same stamp `waws-prod-dm1-339` (centralus.cloudapp.azure.com, IP 20.118.48.11). No CDN or Front Door hostname was seen. — DNS resolution of [www](https://www.buildconnect.com), [api](https://api.buildconnect.com), [app](https://app.buildconnect.com), [thumbor](https://thumbor.buildconnect.com)

  | Public host | App Service app |
  |---|---|
  | `www.buildconnect.com` | `web-buildconnect-frontend-pr.azurewebsites.net` |
  | `api.buildconnect.com` | `web-buildconnect-backend-pr.azurewebsites.net` |
  | `app.buildconnect.com` (admin/back-office portal) | `web-buildconnect-frontend-admin-pr.azurewebsites.net` |
  | `thumbor.buildconnect.com` | `buildconnect-thumbor-pr.azurewebsites.net` |

**Environment configs shipped in the production bundle**
- Production config (`production:!0`):
  - `baseUrl: https://buildconnect.com`, `adminUrl: https://app.buildconnect.com`
  - `apiUrl: https://api.buildconnect.com/api`
  - `imageCDNUrl: https://thumbor.buildconnect.com`
  - `assetsUrl: https://buildconnectstopr.blob.core.windows.net/buildconnect/assets/`
  - `aiApiUrl: https://web-buildconnect-python-pr.azurewebsites.net`
  - `ecommerceUrl: https://buildconnectstopr.blob.core.windows.net/buildconnect/explore/material/ecommercejson`
  - `metaUrl: .../buildconnect/metadata/metadata.json`
  - `gtmId: "GTM-597FXBXW"`
  - a reCAPTCHA site key, a Google Maps API key (`AIzaSyAGt-…`, redacted here), and a HubSpot Meetings link for a sales rep.
  — [chunk-AWSVZ7T7.js](https://buildconnect.com/chunk-AWSVZ7T7.js)
- A **second, non-production config** (`production:!1`) ships in a chunk that `main` imports eagerly:
  - `apiUrl: http://api3.buildconnect.test:8080`, `baseUrl: http://admin.buildconnect.test:4300`, `storeFrontUrl: http://buildconnect.test:4400`
  - `aiApiUrl` on a private RFC1918 10.x address, port 8121
  - `imageCDNUrl: https://buildconnect-thumbor-uat.azurewebsites.net`, `assetsUrl` on `buildconnectstouat`
  - `salesEmail: "salestest@test.com"`
  — [chunk-3YAEHGNB.js](https://buildconnect.com/chunk-3YAEHGNB.js)
- The HTTP interceptor turns off `withCredentials` only for requests to `ecommerceUrl` and `metaUrl` (blob). On an HTTP **406** it calls `refreshToken()` and retries, otherwise it redirects to `/login`. It also leaves a `console.log(i)` on every request. — [main bundle](https://buildconnect.com/main-AXWYUE3F.js)

**Storage**
- Two storage accounts appear in production HTML: `buildconnectstopr` (prod: favicon, preconnect, catalog PDFs) and `buildconnectstouat` (UAT: hero image, og:image, Thumbor sources). — [user scrape metadata](/home/user/ConstructDirect/research_notes/BuildConnect%20platform%20teardown/_source_user_scrape.txt); [/home](https://buildconnect.com/home)
- The single container `buildconnect` has these path conventions:
  - `assets/`, `assets/new/` (marketing images)
  - `explore/material/ecommercejson` (catalog JSON)
  - `metadata/metadata.json`
  - `categories/{CategoryName}/catelogues/{id}/{File}_{epochms}.pdf` and `.../thumbnail/{name}_{epochms}.png`

  Catalog PDF links are **read-only SAS URLs** (`sv=2022-11-02&sr=b&sp=r`, about a 10-hour window `st`→`se`) minted per API call. — TransferState on [/catalogs](https://buildconnect.com/catalogs)

**Third-party scripts and services**
- Google Tag Manager `GTM-597FXBXW` is injected at runtime by the GTM service, not hard-coded in HTML. Google reCAPTCHA appears on the home page in the user's scrape (`gstatic.com/recaptcha/.../styles__ltr.css`). — [chunk-AWSVZ7T7.js](https://buildconnect.com/chunk-AWSVZ7T7.js); [user scrape](/home/user/ConstructDirect/research_notes/BuildConnect%20platform%20teardown/_source_user_scrape.txt)
- Payments go through **Stripe and PayPal**:
  - endpoints `/payments/orders`, `/payments/stripe/payment/check`, `/payments/orders/getPaypalCredentials`, `/payments/checkTransaction`, `/paypal/pay?intent=CAPTURE&orderId=`, `/paypal/success|cancel`;
  - storefront routes `/stripe-payment-success|fail` and `/paypal-payment-success|fail|cancel`.
  — [chunk-AWSVZ7T7.js](https://buildconnect.com/chunk-AWSVZ7T7.js), [main bundle](https://buildconnect.com/main-AXWYUE3F.js)
- Social links in the footer go to Facebook, Instagram, LinkedIn and YouTube. — [/home](https://buildconnect.com/home)

**API behaviour**
- CORS on the API is locked to the storefront: `access-control-allow-origin: https://buildconnect.com` and `access-control-allow-credentials: true`. No `server` header is exposed. — response headers of [GET /api/common/products/category](https://api.buildconnect.com/api/common/products/category)
- Every response uses one envelope: `{success, statusCode, responseMsg, errorMsg, response, recordCount, id, accessToken, statusMessage}`. Timestamps come as epoch milliseconds (`createdOn: 1784304395825`) next to ISO strings with offsets (`"modified":"2026-09-01T10:14:01.265+00:00"`). — [/catalogs TransferState](https://buildconnect.com/catalogs)

### Inferences
- **The mixed environment is probably a build-config bug.** The Thumbor image-loader module most likely imports `environment.development.ts`, or another environment file not covered by `fileReplacements`. As a result:
  - production depends on the UAT Thumbor app and the UAT storage account for imagery;
  - the `preconnect` hints to `thumbor.buildconnect.com` and `buildconnectstopr` are wasted;
  - dev-only hostnames ship to every visitor.
  - For ConstructDirect: use a single injected runtime config (for example an `APP_CONFIG` token loaded from `/config.json`, or SSR-injected), and add a CI check that greps build output for `.test`, `uat` and RFC1918 addresses.
- **The backend is likely Java with Spring Boot and Jackson** (moderate confidence):
  - the envelope pattern with `accessToken`/`statusMessage` fields;
  - epoch-millisecond longs next to `OffsetDateTime`-style ISO strings;
  - camelCase REST verbs such as `/user/sendingTokenForMail` and `/rfqs/estimation/convertExcelToPdf`;
  - category IDs like `TIL/002`.
  
  No header confirms it.
- **The AI service is Python**, per the app name `web-buildconnect-python-pr`. Its trailing-slash routes (`/highlightObject/`, `/prompt_search/`, `/pdf_search/`, `/search-text-in-image/`, `/predict`) suggest FastAPI or Django.
- **Everything runs on one App Service stamp with no CDN or WAF**: SSR, API, admin, Thumbor and probably Python. Each SSR request pays the full API round-trip; `/catalogs` took about 2.5 s versus about 0.4 s for `/tools`. A CDN with HTML caching and a signed Thumbor (no `/unsafe/`) are easy wins to do better.
- Thumbor runs in **`/unsafe/` (unsigned URL) mode**. Third parties could use it as a free resize proxy for any source the server is allowed to fetch.

### Gaps
- The backend language and framework are not confirmed: no `server`/`x-powered-by` header on the API, and no public job postings were found ([search 1](https://www.indeed.com/q-angular-java-developer-jobs.html) returned only unrelated listings).
- The database engine and search engine are unknown.
- I did not check whether the Google Maps key is HTTP-referrer-restricted. That should not be tested.
- I did not verify what GTM loads in turn (GA4, Meta Pixel, HubSpot tracking). The GTM container contents were not fetched.
- BuiltWith and Wappalyzer pages were not consulted: Firecrawl was out of credits and nothing relevant came up in web search.

---

## 2. Which public routes exist? How deep is the category tree, and how big is the catalog?

### Takeaway
The storefront has about **35 public routes plus 9 account routes**, defined in one Angular route table. Route-name constants shared with the admin app expose about 30 more back-office route names.

- The material tree is **Category → Subcategory → Product** (4 URL segments to a product).
- There are **16 top-level categories**, **9 PDF catalogs** (6 featured) and **0 blog posts**.
- There is **no robots.txt and no sitemap.xml**.

### Cited Findings
- `/robots.txt` and `/sitemap.xml` both return HTTP 404 "Cannot GET" from Express. — [robots.txt](https://buildconnect.com/robots.txt), [sitemap.xml](https://buildconnect.com/sitemap.xml)

**Full storefront route table** (path, page title, component), from the lazy-route config in [main-AXWYUE3F.js](https://buildconnect.com/main-AXWYUE3F.js) and the constants in [chunk-QDZWIGSS.js](https://buildconnect.com/chunk-QDZWIGSS.js):

Home and marketing
- `/` → redirects to `/home`
- `/home`: "BuildConnect | Construction Materials, Tools & Technical Solutions" (HomeComponent)
- `/about-us`: "About BuildConnect | Trusted Construction Solutions Partner"
- `/contact`: "Contact BuildConnect | Get Support & Product Information"
- `/contact-form`: "Build Connect - Contact Form"
- `/faqs`: "FAQs | BuildConnect Help & Support Center"
- `/blog`: "Build Connect - Blog"
- `/blog/:blogUrl`: "Build Connect - Blog Details". This route is declared twice.

Legal
- `/privacy-policy`
- `/terms-and-conditions`
- `/cookie-policy`
- `/disclaimer`

Materials
- `/materials`: "Build Connect - Material" (ExploreMaterialsCategoryComponent)
- `/materials/:category` (ExploreMaterialsSubcategoryComponent), for example `/materials/cabinets` and `/materials/bath-tubs`. No route title; the page renders "Build Connect".
- `/materials/:category/:subcategory` (ExploreMaterialsProductsComponent)
- `/materials/:category/:subcategory/:id/:sku` (ExploreMaterialsProductsDetailViewComponent)

Commerce
- `/view-cart`
- `/checkout`
- `/checkout/:id`
- `/stripe-payment-success`, `/stripe-payment-fail` (auth guard)
- `/paypal-payment-success`, `/paypal-payment-fail`, `/paypal-payment-cancel` (auth guard)

Tools and quotes
- `/tools`: "Construction Tools | Reliable & Professional Tools – BuildConnect"
- `/instant-quote` (InstantQuote2Component)
- `/project-quote`: "Build Connect - Estimate" (EstimateComponent)
- `/quote-register`
- `/catalogs`: "Build Connect - Catalog"
- `/docs` (DocsComponent, outside the main layout)

Auth (AuthComponent layout)
- `/login`
- `/register`: BusinessRegistrationComponent, "Register at BuildConnect | Create Your Account"
- `/createaccount` (CreateAccountComponent)
- `/forgot-password`
- `/reset-password`
- `/set-password`

Account (guarded: `canActivate:[auth, role]`, `data:{roles:[9]}`)
- `/account` → `/account/dashboard`
- `/account/profile`
- `/account/change-password`
- `/account/wishlist`
- `/account/addresses`
- `/account/notifications`
- `/account/orders`
- `/account/orders/track`
- `/account/orders/view/:id`

**Route constants with no storefront route** (they live in the shared constants file, so they belong to the admin app at `app.buildconnect.com`):
- `quality`, `warranty`, `technical-data-sheet`, `our-projects`
- `categories`, `subcategories`, `products/:id`, `materials/:id/update`
- `my-tasks`
- `rfqs`, `rfqs/:id`, `rfqs/enquiryview-detail/:id`, `rfqs/admincartorder-detail/:id`, `rfqs/usercartorder-detail/:id`
- `enquiry`, `users`, `staff`
- `takeoffs`, `takeoffs-new`
- `blogs-list`, `blog-new`, `blog-update/:id`
- `supplier-request-list`, `get-estimation`, `assigned-rfqs`, `quote-for-approval`, `reports`, `junior-estimator`, `quotes`
- `api-settings`, `unauthorized`, `page-not-found`

— [chunk-QDZWIGSS.js](https://buildconnect.com/chunk-QDZWIGSS.js)

**Catalog size**
- **16 categories**, from the public storefront call [GET /api/common/products/category](https://api.buildconnect.com/api/common/products/category):
  - Tiles `TIL/002`, Flooring `FLO/003`, Engineered Stone `ENG/001`, Carpets `CAR/004`
  - "Mirros" (sic) `MIR/016`, Decking `DEC/015`, Fencing `FEN/014`, Cabinets `CAB/013`
  - Shower Pans `SHO/012`, Lighting `LIG/007`, Doors `DOO/008`, Windows `WIN/009`
  - Garage Doors `GAR/010`, Bath Tubs `BAT/011`, Faucets `FAU/006`, Toilets `TOI/005`
- **9 catalogs** in total, from [GET /api/catelogue/list](https://api.buildconnect.com/api/catelogue/list):

  | id | Catalog | Category | Featured |
  |---|---|---|---|
  | 5 | Interior Doors | Doors | yes |
  | 7 | Spc Flooring | Flooring | yes |
  | 8 | Windows | Windows | yes |
  | 12 | Mirrors | Mirros | no |
  | 15 | Fencing | Fencing | no |
  | 16 | Quartz | Engineered Stone | yes |
  | 22 | Mineral Crest Carpet | Carpets | yes |
  | 23 | Tailored Motif Carpet | Carpets | yes |
  | 24 | Decking | Decking | no |

  Lifetime `downloadCount` is at most 2 and `viewCount` is 0 for all of them.
- **0 blog posts and 0 blog categories.** `/api/blogs/home` and `/api/blogs/category/list` return `response: []`, `recordCount: 0`, as embedded in the [/blog](https://buildconnect.com/blog) TransferState.
- The product filter API returns an empty object: [GET /api/products/filters](https://api.buildconnect.com/api/products/filters) → `"response":{}`.
- The home page "Featured Materials" section links only Bath Tubs and Cabinets. The marketing sections are "Projects We Cater To" (Commercial Building, Townhomes, Hotels, Custom Single Family) and testimonials. — [user scrape markdown](/home/user/ConstructDirect/research_notes/BuildConnect%20platform%20teardown/_source_user_scrape.txt)

### Inferences
- The low catalog download counts and the empty blog point to **very low traffic and content maturity** as of October 2026, even though the stack is relatively elaborate.
- Category slugs (`bath-tubs`, `cabinets`) are derived from category names, while category IDs use a `PREFIX/NNN` scheme with a slash. That makes the IDs unusable directly in URLs, which is probably why slugs exist.

### Gaps
- **Subcategory and product counts are not known.** Category, subcategory and product pages render client-side only. The SSR HTML of `/materials` contains just "Browse by Category" with no items, and `/materials/cabinets` contains only a breadcrumb. Firecrawl, the JS renderer, was out of credits, and fetching the catalog JSON from blob storage was blocked by the session permission classifier.
- Manufacturer and brand counts are not known for the same reason.

---

## 3. What does the JSON reveal about the data model?

### Takeaway
The catalog is **"API returns a pointer, browser downloads a whole-catalog static JSON from Blob"**. The product detail page downloads the entire `ecommercejson` file and **filters it in the browser by model number and SKU**.

The transactional model, reconstructed from the about 180 endpoint names in the API service, centres on:
- Users and Companies (head office and branches);
- Cart → OrderRequest → Order → Payment;
- RFQ → Quote, with an estimator workflow;
- InstantQuote, a form-driven configurator.

### Cited Findings

**Catalog loading**
- The store service has these calls:
  - `productsUrl(t)` → `GET /products/material/{t}`
  - `productsJSON(url)` → `GET {url}`, a raw blob fetch
  - `categories()` → `GET /common/products/category`
  - `products(body)` → `POST /products/home/productIds`
  - `productFilters()` → `GET /products/filters`
  - `productDetails(id)` → `GET /products/{id}/details`
  - `deliveryExpected(id)` → `GET /orderRequests/deliveryDays/{id}`

  — [chunk-AWSVZ7T7.js](https://buildconnect.com/chunk-AWSVZ7T7.js)
- The product detail component calls `productsJSON(this.apiService.ecommerceJson)` (the full blob file), reads `r.data.products`, then `filterProductByModelNoAndSku(products, id, sku)`. It also handles `?addToWishlist=true` after login, warehouse selection (`SELECTEDWAREHOUSE` in local storage) and links into the admin app with `{adminUrl}/?returnUrl=rfqs/enquiryview-detail/&enquiryId={id}`. — [chunk-LOPJT7UH.js](https://buildconnect.com/chunk-LOPJT7UH.js)
- The product listing component:
  - posts `requObj` to `/products/home/productIds`;
  - reads `data.products`;
  - counts stock with `is_available_in_warehouse === true/false`, logging `{instock, outofstock, total}`;
  - uses a range-slider filter (min/max/offset % code).

  — [chunk-IV5RXV46.js](https://buildconnect.com/chunk-IV5RXV46.js)

**Catalog record** (verbatim keys): `id, name, category` (a category *name* string, not an ID), `pdfUrl` (SAS), `imageUrl` (thumbnail), `createdOn` (epoch ms), `modifiedOn`, `modified` (ISO), `modifiedBy` (user id), `lastModifiedBy` (display name, for example "Super Admin"), `downloadCount`, `viewCount`, `isFeatured`. The API groups the list by category name: `response: {"Doors":[…], "Flooring":[…]}`. — [/api/catelogue/list](https://api.buildconnect.com/api/catelogue/list)

**Category record**: `{categoryId: "CAB/013", categoryName: "Cabinets"}`. — [/api/common/products/category](https://api.buildconnect.com/api/common/products/category)

**Transactional endpoints**, grouped by domain (all from [chunk-AWSVZ7T7.js](https://buildconnect.com/chunk-AWSVZ7T7.js)):

- **User and auth**
  - `/user/login`, `/user/create`, `/user/sendOTP`, `/user/loginWithOtp`, `/user/verifyOTP`
  - `/user/otp/resend`, `/user/otp/verify`
  - `/user/sendingTokenForMail`, `/user/validateToken/{t}`, `/user/resetPassword`, `/user/setPassword`
  - `/user/refreshToken`, `/user/logout`
  - `/user/countries`, `/user/countries/{id}/states`
  - `/user/{id}/details`, `/user/{id}/profile`, `/user/profile/update`
  - `/user/roles/list`, `/user/menu`, `/user/document`, `/user/email/validate`
  - `/user/groupValues/18000` (a lookup-value group)
- **Company**
  - `/company`, `/company/office`, `/company/{id}/offices`, `/company/{id}/users`
  - `/company/checkIfHOExists/{id}`, `/company/addressTypes`
- **Address and tax**
  - `/user/address?userId=&office=`, `/user/address/add`
  - `/address/validate`, `/address/tax`, `/address/info/{zip}`
- **Cart and orders**
  - `/userCart/{user|random}/products`, `/userCart/user/{id}/products`, `/userCart/random/products/list`, `/userCart/products/update`
  - `/orderRequests/create|list|modify|item/update`, `/orderRequests/preview/{id}`, `/orderRequests/tax/{zip}`, `/orderRequests/deliveryDays/{id}`
  - `/orders/create|list`, `/orders/preview/{id}`
- **Warehouse**: `/warehouse/{id}`, `/warehouse/distance/{zip}`
- **Wishlist**: `/wishlist/add`, `/wishlist/checkIfExists/{a}/{b}`
- **Enquiries**: `/enquiries/guestUser`, `/enquiries`
- **RFQs and estimating**
  - `/rfqs/create|temp/create|list|formDetails|properties`
  - `/rfqs/floorPlan/upload|list|details/{id}`
  - `/rfqs/assign`, `/rfqs/assign/list`, `/rfqs/user/assign/list`, `/rfqs/approval/list`
  - `/rfqs/declined/{id}?remarks=`
  - `/rfqs/estimationFile/upload`, `/rfqs/estimation/convertExcelToPdf`
  - `/rfq/feedbacks/*`, `/rfq/user/notes/*`
  - `/estimator/juniors`, `/estimator/rfq/statuses`, `/categories/estimator-categories`
- **Quotes**
  - `/quote/{id}`, `/quote/details/{id}`, `/quote/updateStatus`, `/quote/approveOrReject`, `/quote/remarks`
  - `/quote/status/counts?id=&roleId=`
  - `/remarks/save`
- **Instant quote**
  - `/instantquote/types`
  - `/instantquote/formfields/{type}`, `/instantquote/formfields/{type}/subcontrols/{id}`
  - `/instantquote/questions?categoryId=&subCategoryId=&ecommerce=ecommerce`
  - `/quote-temp/create`, `/quote-temp/create/new`, `/quote-temp/{id}`
  - `/instantquote/products/{id}`, `/instantquote/capacity?id={containerCapacityId}&zipCode=`
  - `/instantquote/calculateEstimate?category=quartz`
  - `/instantquote/productQuote`, `/instantquote/finalizeDesign`, `/instantquote/modify`
  - `/instantquote/lite/{id}`, `/instantquote/status/{id}`, `/instantquote/data/{id}`, `/instantquote/list`
- **Content**
  - `/blogs/*`, `/faq/*`, `/catelogue/upload|list|delete/{id}|activity/track`
  - `/contactus`, `/contactus/userTypes`, `/project-source`
- **Operations**
  - `/notification/user|view/{id}|delete?ids=|read-all`
  - `/instant-chat/history/{a}/{b}?senderId=&receiverId=`, `/instant-chat/notifications`, `/user/list/chat-support`
  - `/apiSettings`, `/apiSettings/update`, `/deployment/getMenuOptions`

**AI service** (`aiApiUrl`): `POST /predict`, `/highlightObject/`, `/search-text-in-image/`, `/prompt_search/`, `/pdf_search/`, and `GET /requests/{id}/history`, used on "build plan" (floor-plan) files. — [chunk-AWSVZ7T7.js](https://buildconnect.com/chunk-AWSVZ7T7.js)

**Reconstructed entity-relationship model** (text form). This is inferred from endpoint shapes; field lists are only those actually observed.

```
Category {categoryId "ABC/NNN", categoryName}  1──*  Subcategory {slug}  1──*  Product {id, sku, modelNo*, is_available_in_warehouse, …}
Category(name) 1──* Catalogue {id, name, category(name), pdfUrl(SAS), imageUrl, isFeatured, downloadCount, viewCount, createdOn, modifiedOn, modified, modifiedBy, lastModifiedBy}
Product *──* Warehouse {id}   (stock flag per product; distance(zip) → delivery days)
User {userId, roleId} *──1 Role ; User *──1 Company {HO + branch Offices} ; User 1──* Address {office flag, addressType} ; User 1──* Document
User|GuestRandomId 1──1 Cart 1──* CartItem(Product, qty) → OrderRequest {items, charges, tax(zip), deliveryDays} → Order → Payment {Stripe|PayPal}
User 1──* Wishlist(Product) ; Guest|User 1──* Enquiry(Product)
User 1──* RFQ {properties, floorPlans*, status, assignedEstimator, feedback*, notes*, remarks*} 1──* Quote {status, approval, estimationFile(xlsx→pdf)}
User 1──* InstantQuote {type, formFields/subcontrols, tempDraft, designs(Product*), containerCapacity, zip, estimate}
Blog {blogUrl} *──1 BlogCategory ; FAQ *──1 FAQCategory ; Notification ; ChatMessage(sender, receiver)
```
(* `modelNo` is inferred from the function name `filterProductByModelNoAndSku`; the exact key name was not observed.)

### Inferences
- **The whole catalog is a single blob JSON document**, probably regenerated by the admin app on publish. Product detail and listing pages therefore cost one large download, no product data is SSR-rendered, and there is no per-product SEO.
  - For ConstructDirect: per-product API or JSON plus SSR, with the transfer cache, beats this design for SEO, time to first render and data hygiene.
- **Pricing is quote- and order-request-driven, not list-price checkout.** The flow is OrderRequest → admin `modify` (charges) → Checkout `/:id` → payment. The homepage mock shows "Awaiting Quote" and "Shipped" states.
- Container-capacity-by-ZIP plus warehouse distance suggests **import or container-load logistics** with US warehouses (inference).
- `calculateEstimate?category=quartz` is hard-coded, so the instant estimator is currently implemented **only for quartz (engineered stone) countertops**.

### Gaps
- Product-level fields are not confirmed: pricing fields, specs, manufacturer/brand, supplier, spec sheets, CAD/BIM documents, image arrays. They require reading the `ecommercejson` blob, which was blocked here. Recommended follow-up, if the user approves: a single GET of the `ecommerceUrl` blob listed in [chunk-AWSVZ7T7.js](https://buildconnect.com/chunk-AWSVZ7T7.js), the same file the public product page downloads.
- I found no evidence of manufacturer or brand entities in endpoint names. Brand may be a product attribute only.
- I found no CAD/BIM endpoints. "technical-data-sheet" exists only as an unused route constant.

---

## 4. What do the "tools" do, and how are they implemented?

### Takeaway
"Tools" (nav label "Get Quotes") is **not calculators**. It is two quote-intake flows:
- **Instant Quote**: a dynamic, server-defined form configurator with autosaved drafts, design selection and an estimate, so far quartz-specific;
- **Project Quote**: an RFQ with floor-plan upload, processed by a back-office estimator team assisted by a Python AI takeoff service.

### Cited Findings
- The `/tools` SSR HTML shows two cards: "Instant Quote: Get a quick quote for your materials." → `/instant-quote`, and "Project Quote: Get a comprehensive quote for your whole project." → `/project-quote`. — [/tools](https://buildconnect.com/tools)
- The home page calls to action are "Shop Materials" → `/materials` and "Get Quotes" → `/tools`. — [user scrape](/home/user/ConstructDirect/research_notes/BuildConnect%20platform%20teardown/_source_user_scrape.txt)
- Instant Quote (InstantQuote2Component) works like this:
  1. Load quote types.
  2. Load form fields and sub-controls per type from the API (`/instantquote/formfields/{type}/subcontrols/{id}`).
  3. Autosave drafts (`/quote-temp/create`).
  4. Fetch available designs (`/instantquote/products/{id}`) and container capacity by ZIP.
  5. `calculateEstimate?category=quartz`, then `productQuote` and `finalizeDesign`.

  — [chunk-AWSVZ7T7.js](https://buildconnect.com/chunk-AWSVZ7T7.js), [route table](https://buildconnect.com/main-AXWYUE3F.js)
- Project Quote (EstimateComponent, titled "Build Connect - Estimate") uses `/rfqs/create`, `/rfqs/temp/create`, `/rfqs/floorPlan/upload`, `/project-source` and the AI service endpoints `/predict`, `/highlightObject/`, `/prompt_search/`, `/pdf_search/` and `/search-text-in-image/`. — [chunk-AWSVZ7T7.js](https://buildconnect.com/chunk-AWSVZ7T7.js)
- The back-office side, from route constants:
  - `takeoffs`, `takeoffs-new`
  - `assigned-rfqs`, `junior-estimator`, `quote-for-approval`, `get-estimation`
  - endpoints for assigning RFQs to engineers, uploading the estimator's Excel (converted to PDF) and approve/reject flows.

  — [chunk-QDZWIGSS.js](https://buildconnect.com/chunk-QDZWIGSS.js), [chunk-AWSVZ7T7.js](https://buildconnect.com/chunk-AWSVZ7T7.js)

### Inferences
- The "AI" is **plan-reading assistance for human estimators**: object detection or prediction, text and OCR search, and prompt search over uploaded plans. It is not a customer-facing calculator.
- Quote turnaround is human-in-the-loop, through junior estimator, approver and customer.
- The ConstructDirect opportunity is a self-serve calculator with instant pricing across more than one category.

### Gaps
- I could not see the live Instant Quote form fields, the question sets or the AI accuracy. They render client-side and need a JS renderer.

---

## 5. How does a user move through the system, and what requires registration?

### Takeaway
The journey runs: discover (home → materials → category → subcategory → product) → enquire, add to wishlist or add to cart. Guests get a random-ID cart and guest enquiries.

Checkout, payment, wishlist, account, order tracking and quote follow-up all **require login**. Enquiries and RFQs are then viewed in the **admin portal app.buildconnect.com**, not the storefront.

### Cited Findings
- **Guest capabilities**: a cart keyed `random` (`/userCart/random/products`, `/userCart/random/products/list`) and guest enquiries (`/enquiries/guestUser`). — [chunk-AWSVZ7T7.js](https://buildconnect.com/chunk-AWSVZ7T7.js)
- **Login-gated actions**:
  - the `/account/*` routes are guarded by auth plus role `roles:[9]`;
  - the Stripe and PayPal result routes are auth-guarded;
  - wishlist from a product page uses a `?addToWishlist=true` round-trip.

  — [main bundle](https://buildconnect.com/main-AXWYUE3F.js), [chunk-LOPJT7UH.js](https://buildconnect.com/chunk-LOPJT7UH.js)
- **Authentication options**: email and password (`/user/login`) or email OTP login (`/user/sendOTP` → `/user/loginWithOtp`).
- **Registration flows**:
  - `/register`: business registration ("Register at BuildConnect | Create Your Account");
  - `/createaccount`;
  - `/quote-register`: registration within the quote flow;
  - email OTP verification (`/user/otp/resend`, `/user/otp/verify`);
  - set or reset password via an emailed token (`/user/sendingTokenForMail`, `/user/validateToken/{t}`).

  — [chunk-AWSVZ7T7.js](https://buildconnect.com/chunk-AWSVZ7T7.js), [route table](https://buildconnect.com/main-AXWYUE3F.js)
- **Sessions** use cookies `access_token`, `refresh_token` and `userId`, sent with `withCredentials`. A 406 response triggers a refresh. Logout clears the cookies and local storage, stops notification polling and resets the cart count. — [chunk-ZZHNMQTX.js](https://buildconnect.com/chunk-ZZHNMQTX.js), [main bundle](https://buildconnect.com/main-AXWYUE3F.js)
- **Hand-off to the admin portal**: after an enquiry, the product page links to `https://app.buildconnect.com/?returnUrl=rfqs/enquiryview-detail/&enquiryId={id}`. The profile view is also reachable there (`returnUrl=profile&view=7`). — [chunk-LOPJT7UH.js](https://buildconnect.com/chunk-LOPJT7UH.js)
- **Support and engagement**: in-app support chat (`/instant-chat/*`, `/user/list/chat-support`), notification polling on an interval, and a HubSpot Meetings link for booking sales calls. — [chunk-AWSVZ7T7.js](https://buildconnect.com/chunk-AWSVZ7T7.js)

### Inferences
- The two-app split forces customers into a back-office-style portal for RFQ and enquiry detail. That is a UX seam ConstructDirect can avoid with one customer workspace.
- The flow is B2B-first (business registration, company HQ and branches, staff roles), with B2C traces such as `updateB2CUserProfile`.

### Gaps
- I did not verify which fields registration requires or whether reCAPTCHA is v2 or v3 per form. Form submission was out of scope.

---

## 6. Signs of maturity: environment leakage, SEO, performance, accessibility, i18n, error handling

### Takeaway
The architecture is reasonably modern: Angular 19 SSR, hydration, optimized images and lazy routes. Operational hygiene is weak:
- UAT dependencies and dev configuration ship in production;
- there is no robots.txt or sitemap;
- there is no structured data or canonical tags, and catalog pages are client-rendered;
- the CSS is very large;
- there are no security headers;
- debug logging is left in production;
- naming typos run through the API and data.

### Cited Findings
- **Environment leakage**: production HTML references `buildconnect-thumbor-uat.azurewebsites.net` (60 references on `/home`) and `buildconnectstouat` (29 references), including `og:image`. The bundle contains `.test` hosts, a private IP and `salestest@test.com`. — [/home](https://buildconnect.com/home), [chunk-3YAEHGNB.js](https://buildconnect.com/chunk-3YAEHGNB.js)
- **SEO plumbing**:
  - no `robots.txt`, no `sitemap.xml`, no `<link rel="canonical">`, no JSON-LD;
  - checked on `/home`, `/materials`, `/materials/cabinets`, `/tools`, `/catalogs` and `/blog`.
  
  What exists:
  - Open Graph tags (`og:title`, `og:description`, `og:image` 600×600, `og:type`) plus a non-standard `<meta name="title">`;
  - no `og:url` and no Twitter card tags.
  
  Title quality:
  - generic titles such as "Build Connect - Material" and "Build Connect - Catalog";
  - category pages have no category-specific title.
  
  — [/home](https://buildconnect.com/home), [/materials/cabinets](https://buildconnect.com/materials/cabinets), [robots.txt](https://buildconnect.com/robots.txt)
- **SSR coverage**:
  - `/catalogs` and `/blog` embed their API responses in TransferState;
  - `/materials` and `/materials/:category` SSR output contains no category or product content: "Browse by Category" with no items, or a breadcrumb only.
  
  — [/catalogs](https://buildconnect.com/catalogs), [/materials](https://buildconnect.com/materials)
- **Performance**:
  - 828 KB uncompressed global CSS, with an 82 KB inline critical block;
  - about 476 KB uncompressed initial JS;
  - SSR fetch times from this vantage were about 0.40 s (`/tools`), 0.70 s (`/materials`), 1.4 s (`/blog`) and 2.5 s (`/catalogs`);
  - API calls took 1.1–1.6 s each;
  - there is no CDN.
  
  Images, by contrast, are done well: webp at quality 60, responsive `srcset`, `loading="lazy"` on 9 of 11 home images, and a high-priority preload of the logo.
  
  — [/home](https://buildconnect.com/home), curl timings 2026-10-21
- **Accessibility basics**:
  - all 11 `<img>` on `/home` have non-empty `alt`;
  - the home page has **no `<h1>`** (1 h2, 1 h3, 3 h4, 4 h5);
  - there are 9 `aria-label`s and 21 `role=` attributes.
  
  — [/home](https://buildconnect.com/home)
- **i18n**: `lang="en"`, `dir="ltr"`. The configuration is US-only: country code "US +1", date format `MM-dd-yyyy`, no hreflang. — [/home](https://buildconnect.com/home), [chunk-ZZHNMQTX.js](https://buildconnect.com/chunk-ZZHNMQTX.js)
- **Code hygiene**:
  - production `console.log`s: an interceptor log on every request, `this.matJson`, stock counts, notification polling;
  - typos baked into contracts: `/catelogue/*`, category "Mirros", constants `BUSSINESS_REGISTER`, `SUBCATGORY_DETAIL_PATH`, `ENQURY_DETAIL`, `modifyInsatntQuote`;
  - copy-paste endpoint mistakes: `blogCategories` and `userViewBlogs` both point to `/user/updateStatus`; `terms:""` and `raiseRfi:""` are empty;
  - `/blog/:blogUrl` is declared twice.
  
  — [chunk-AWSVZ7T7.js](https://buildconnect.com/chunk-AWSVZ7T7.js), [chunk-QDZWIGSS.js](https://buildconnect.com/chunk-QDZWIGSS.js), [main bundle](https://buildconnect.com/main-AXWYUE3F.js)
- **Error handling**:
  - non-route paths fall through to Express's default HTML 404 ("Cannot GET …");
  - there is no `**` wildcard route in the storefront route table, although a `page-not-found` constant exists;
  - toast-based errors (`toastr.showError("Prod…")` when a product is not found).
  
  — [robots.txt 404](https://buildconnect.com/robots.txt), [main bundle](https://buildconnect.com/main-AXWYUE3F.js), [chunk-LOPJT7UH.js](https://buildconnect.com/chunk-LOPJT7UH.js)
- **Security headers**: none on HTML apart from `x-content-type-options` on 404s; `x-powered-by: Express` is exposed. CORS on the API is correctly origin-restricted. — curl of [/home](https://buildconnect.com/home), [API](https://api.buildconnect.com/api/common/products/category)

### Inferences
- The small team behind this (inference: the code style and shared-constants monorepo suggest an outsourced or small agency build) has invested in workflow depth (RFQ, estimators, AI takeoff, payments, chat) ahead of discoverability. **SEO is the clearest gap ConstructDirect can exploit**:
  - SSR every category and product page with TransferState;
  - per-page titles and descriptions plus canonical tags;
  - `Product`, `BreadcrumbList` and `Organization` JSON-LD;
  - a generated sitemap and robots.txt;
  - an h1 per page.
- **Things worth copying**:
  - Angular or Next-style SSR with hydration and event replay;
  - an `NgOptimizedImage`-style loader in front of an image proxy (use signed URLs, imgproxy or a managed CDN rather than unsafe Thumbor);
  - the single API envelope;
  - read-only, short-lived SAS links for PDFs, with download tracking.
- **Things to avoid**:
  - shipping a whole-catalog JSON to the browser;
  - two environment files in one build;
  - storing category as a name string on catalogs;
  - a slash in IDs;
  - no CDN.

### Gaps
- Lighthouse/CWV scores were not measured: no headless browser was available and Firecrawl was out of credits.
- Uptime and error rates are not measurable from public data.
