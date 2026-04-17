# Unified SAP Add-on (unified-sap-addon)

## What This Repo Is

This is the **gCTS Enabled Public Cloud Repository** — the central source of truth for the `/COSS/_UNIFIED` software component ("Unified Software Product"). It is a gCTS-managed ABAP repository using JSON serialization format (v6) with table content enabled.

ABAP development objects created in the SAP Public Cloud D10 system are serialized and stored here. From this repo, the software component fans out to both the BTP Steampunk and S/4 HANA landscapes.

## Architecture (gCTS Transport Delivery Process)

See `docs/gcts-transport-diagram.html` for the visual diagram.

### Three Environments

- **SAP Public Cloud (D10)** — The origin system. Developers release transport requests here, which flow into this repo.
- **BTP ABAP Environment (Steampunk)** — A 3-subaccount landscape: DEV → TST → EAT (AMT via ABAP Solution). A Multitenant Application connects to the EAT/Provider system.
- **AWS (S/4 HANA)** — SED (Development) and SET (Test), connected via Add-on Assembly Kit.

### Transport Flow

1. **D10 → this repo** — Transport requests released from the Public Cloud D10 system land here as serialized ABAP objects.
2. **This repo ↔ unified-sap-addon-clone** — 2-way mirroring keeps the source of truth (this repo) and the BTP clone repo in sync. This mirroring is a custom solution that needs to be built.
3. **Clone → DEV** — The clone repo feeds the Steampunk DEV system via gCTS Clone/Pull Software Component.
4. **DEV → TST → EAT** — Internal BTP transport chain moves the software component through the Steampunk landscape.
5. **This repo → SED** — The source of truth also feeds the S/4 HANA Development system on AWS via Clone/Pull.
6. **SED → SET** — Add-on Assembly Kit propagates from SED to SET within the AWS landscape.

### Repo Relationships

- **This repo (`unified-sap-addon`)** = "gCTS Repository — gCTS Enabled Public Cloud Repo" (source of truth)
- **Submodule (`unified-sap-addon-clone`)** = "gCTS Repository Clone — gCTS Enabled BTP ABAP Environment Repo" (clone that feeds Steampunk DEV)

The two repos must stay in sync via a custom 2-way mirroring solution. This is the core integration challenge for this project.

## ABAP System Connections

### D10 — SAP Public Cloud (gCTS)

- **System:** Partner Demo Development D10/080 (`my430884.s4hana.cloud.sap`)
- **App:** Git-Enabled CTS (gCTS)
- **Repository name:** `austinkloske22-unified-sap-addon`
- **Git URL:** `https://github.com/austinkloske22/unified-sap-addon`
- **Role:** Development
- **Status:** READY
- **vSID:** 1GT
- **Owner:** CB9980000003 (`austin.kloske@contax.com`)
- **Branch:** `main` (current commit: `f64ed29`)
- **Visibility:** Public

See `docs/Public-Cloud-gCTS-repo.png` for screenshot.

### BTP DEV — ABAP Environment (Software Component)

- **System:** DEV (BTP ABAP Environment, expires 13 July 2026)
- **App:** Available Software Component
- **Software Component:** `/COSS/EVENTS` ("Sample SaaS Product")
- **Type:** Development
- **Git Provider:** GITHUB
- **Git URL:** `https://github.com/austinkloske22/unified-sap-addon-clone`
- **Repository Role:** Source — Allow Pull and Push
- **Created by:** `austin.kloske@contax.com` (04/17/2026, 14:55:28)
- **Status:** Cloned, branch `main` checked out
- **Pull/Checkout Rollback Enabled:** Yes

The "Allow Pull and Push" role is significant — it means the BTP system can both consume and publish changes to the clone repo, enabling the bidirectional sync needed for 2-way mirroring.

See `docs/BTP-ABAP-Software-component-repo.png` for screenshot.

## Repo Structure

- `objects/` — Serialized ABAP objects (JSON format, gCTS layout)
- `.gctsmetadata/` — gCTS metadata table definitions (E070, E071, TADIR, etc.)
- `.gcts.properties.json` — gCTS repository configuration
- `docs/` — Architecture diagrams, screenshots, and documentation
- `unified-sap-addon-clone/` — Local clone of the BTP ABAP Environment repo (git-ignored, not tracked)

## Key Details

- **Namespace:** `/COSS/`
- **Package:** `/COSS/_UNIFIED`
- **Delivery Unit:** `ZPARTNER`
- **gCTS Format:** JSON v6, table content enabled
