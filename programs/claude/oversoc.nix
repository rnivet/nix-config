{lib, ...}: {
  programs.claude-code.settings = {
    extraKnownMarketplaces.oversoc.source = {
      source = "github";
      repo = "oversoc/claude-skills";
    };
    enabledPlugins = {
      "oversoc-marketing@oversoc" = true;
      "oversoc-clients@oversoc" = true;
      "oversoc-donnees@oversoc" = true;
      "oversoc-produit@oversoc" = true;
      "oversoc-dev@oversoc" = true;
    };
  };

  # After the feature-workspace instructions from programs/feature-ws (mkAfter).
  programs.claude-code.context = lib.mkOrder 1600 ''

    ## OverSOC repo map

    Main clones in `~/projects/<repo>` (connectors in `~/projects/connectors/<name>`). Use this to pick the repos a feature needs; check the repo's own CLAUDE.md/README once added.

    Product / backend:
    - `overview`: OverView monorepo. Image `ghcr.io/oversoc/overview`, deployed per tenant by v3-helm-charts. Subdirs:
      - `webui/`: React 19/Vite/PrimeReact SPA (KPIs, dashboards, pipeline settings, os-service UI)
      - `backend/`: FastAPI (credentials via Keeper, org params in MongoDB, Prefect workflows, uploads, s3-gateway creds); publishes bus-events
      - `backend-analytics/`: Go/Fiber KPI, dashboard and query-builder engine over the unicity Postgres
      - `ai-gateway/`: FastAPI LLM gateway orchestrating MCP tools
      - `mcp-backend-analytics/`, `mcp-backend/`: FastMCP servers exposing backend-analytics / backend
      - `rest-api/`: read-only public REST facade over backend-analytics
      - `local-test/`: docker-compose stack built from the worktree
    - `bus-events`: shared event contracts. JSON Schemas (CloudEvents on NATS) generate Go structs and Pydantic models. Any new or changed event starts here. Used by overview, notifier, envoy-auth0-authz, s3-gateway, os-service.
    - `os-service`: OS-string normalization into a curated catalogue (ML classifier + React backoffice). Stack: Python/FastAPI + React. Called by overview webui and overview-data.
    - `notifier`: consumes NATS JetStream events and triggers Novu notification workflows. Stack: Go.
    - `envoy-auth0-authz`: Envoy ext_authz service (Auth0 OAuth2/JWT, Redis sessions, multi-tenant routing, MCP bearer auth). Stack: Go. Consumes `iam` bus-events.
    - `s3-gateway`: multi-tenant S3-compatible upload gateway (SigV4, Keeper creds). Stack: Go.
    - `mcp-auth0`: local MCP server for Auth0 tenant admin. Stack: Python/FastMCP.

    Data pipeline:
    - `overview-data`: uv-workspace monorepo for the data pipeline. Members:
      - `data`: shared models
      - `import-data-tasks`: crawl, parse, upload
      - `unicity-data-tasks`: PASS→TASS→MASS V3 dedup
      - `cleaning-enrichment-data-tasks`
      - `prefect-pipelines`, `prefect-worker`
      Stack: Python/Prefect/MongoDB/Postgres. Installs connectors at runtime.
    - `cyber_nectar_unicity_api`, `cyber_nectar_enrichment_api`: older FastAPI unicity/history and TASS enrichment APIs, still deployed per tenant by v3-helm-charts.
    - `fake-data-generator`: fake datasets for the free-trial demo. Stack: Python.
    - `fake-unicity-generator`: fake unicity-DB data in Postgres. Stack: Go.

    Connectors:
    - `connectors-toolkit`: shared connector library (Crawler/Parser/Credentials/Validator bases, crawlers, pagination, `ImportAsset`/`CrawledResponse` schemas). Stack: Python. Used by every connector and by overview-data.
    - `connectors/<vendor>`: one Python/uv package per vendor (crowdstrike, intune, glpi, entraid, sentinelone, tenable, veeam, vmware, wiz, zscaler-*, …), built from `connectors/connector-template`.
      - API connectors: Crawler + Credentials.
      - FILE connectors: Parser + FileValidator.
      - overview-data installs them at a pinned version.
      - Customer docs live in docs-nuxt.

    Infra / deploy:
    - `v3-helm-charts`: per-tenant Helm charts and values for the OverView stack (`tenants/<t>/environments`, release manifest). Consumed by argo-apps.
    - `argo-apps`: ArgoCD ApplicationSet that creates one app per chart × tenant environment.
    - `infra-helm-charts`: shared cluster infra (Caddy, Envoy, Coraza, Grafana, ArgoCD, Prefect server, Windmill, Tailscale, Kyverno). Deploys envoy-auth0-authz, s3-gateway, notifier, os-service, overdeploy, nats-account-operator.
    - `nats-account-operator`: k8s operator that turns NatsTenantAccount CRs into NATS creds. Stack: Go. Pairs with the `nats-tenant` chart.
    - `overdeploy`: internal backoffice for QA environments and tenant ops (Windmill, ArgoCD/Prefect views). Stack: FastAPI + React.
    - `vm-tailscale-caddy`: Packer-built on-prem gateway VM (Tailscale + Caddy).
    - `gh-actions-workflows`: reusable GitHub Actions (bump, publish, deploy, tests).

    QA / docs / tooling:
    - `overview-qa`: Playwright non-regression harness on a containerized twin env. Targets webui `data-wt` ids.
    - `overview-plans`: design plan required for every feature, infra change or refactor.
    - `docs-nuxt`: customer-facing product and connector docs (FR/EN). Stack: Nuxt 3.
    - `overview-site`: marketing site www.oversoc.com. Stack: Nuxt 4.
    - `claude-skills`: OverSOC Claude skills/plugins.

    Legacy (do not add unless asked):
    - Superseded by `overview` subdirs: `backendv3`, `backend-analytics`, `webuiv3`, `ai-gateway`.
    - Superseded by `overview-data`: `cleaning-enrichment-data-tasks`.
    - Old v2 stack: `kpi-api`, `cyber_nectar_import_api`, `helm-charts`, `docker-compose-stack`.
  '';
}
