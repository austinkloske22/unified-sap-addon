# unified-sap-addon

Unified SAP Add-on for Public Cloud, Steampunk & S/4 HANA

## Overview

This is the **gCTS Enabled Public Cloud Repository** — the central source of truth for the `/COSS/_UNIFIED` software component. It manages the transport delivery of a unified ABAP add-on across three SAP landscapes:

- **SAP Public Cloud** — Origin system (D10) where development occurs
- **BTP ABAP Environment (Steampunk)** — 3-subaccount landscape (DEV → TST → EAT/AMT Provider)
- **S/4 HANA on AWS** — Development (SED) and Test (SET) systems via Add-on Assembly Kit

## Architecture

> View the interactive diagram: [`docs/gcts-transport-diagram.html`](docs/gcts-transport-diagram.html)

```
                        Release Transport
  ┌──────────────┐      Request         ┌─────────────────────┐
  │  SAP Public  │ ───────────────────► │  This Repo          │
  │  Cloud (D10) │                      │  (Source of Truth)   │
  └──────────────┘                      └──────────┬──────────┘
                                           │              │
                                    2-way mirror    Clone/Pull
                                           │              │
                                           ▼              ▼
                                  ┌──────────────┐  ┌───────────┐
                                  │  Clone Repo  │  │  AWS SED  │
                                  │  (BTP ABAP)  │  │  S/4 HANA │
                                  └──────┬───────┘  └─────┬─────┘
                                         │                │
                                   Clone/Pull        Assembly Kit
                                         │                │
                                         ▼                ▼
                                  ┌──────────────┐  ┌───────────┐
                                  │  BTP DEV →   │  │  AWS SET  │
                                  │  TST → EAT   │  │  S/4 HANA │
                                  └──────────────┘  └───────────┘
```

### Transport Flow

1. **D10 → This Repo** — Developers release transport requests in the SAP Public Cloud D10 system. Serialized ABAP objects land in this repository.
2. **This Repo ↔ Clone Repo** — A custom 2-way mirroring solution keeps this source of truth in sync with the [BTP ABAP Environment clone](https://github.com/austinkloske22/unified-sap-addon-clone).
3. **Clone → BTP DEV** — The clone repo feeds the Steampunk DEV system via gCTS Clone/Pull Software Component.
4. **DEV → TST → EAT** — Internal BTP transport chain moves the component through the Steampunk landscape. A Multitenant Application connects at the EAT/Provider layer.
5. **This Repo → SED** — The source of truth also feeds the S/4 HANA Development system on AWS.
6. **SED → SET** — Add-on Assembly Kit propagates from Development to Test within the AWS landscape.

## ABAP System Connections

### D10 — SAP Public Cloud (gCTS)

This repo is linked to the D10 system via Git-Enabled CTS (gCTS).

![D10 gCTS Repository](docs/Public-Cloud-gCTS-repo.png)

| Property | Value |
|----------|-------|
| **System** | Partner Demo Development D10/080 |
| **Repository** | `austinkloske22-unified-sap-addon` |
| **Role** | Development |
| **Status** | READY |
| **Branch** | `main` |

### BTP DEV — ABAP Environment (Software Component)

The [clone repo](https://github.com/austinkloske22/unified-sap-addon-clone) is linked to the BTP DEV system as software component `/COSS/EVENTS`.

![BTP Software Component](docs/BTP-ABAP-Software-component-repo.png)

| Property | Value |
|----------|-------|
| **System** | BTP ABAP Environment (DEV) |
| **Software Component** | `/COSS/EVENTS` |
| **Repository Role** | Source — Allow Pull and Push |
| **Status** | Cloned, `main` checked out |

The **"Allow Pull and Push"** role means the BTP system can both consume and publish changes to the clone repo — this is what enables the bidirectional sync needed for 2-way mirroring.

## Repository Structure

```
unified-sap-addon/
├── objects/                      # Serialized ABAP objects (gCTS JSON format)
├── .gctsmetadata/                # gCTS metadata table definitions
├── .gcts.properties.json         # gCTS repository configuration
├── docs/
│   ├── gcts-transport-diagram.html           # Interactive architecture diagram
│   ├── Public-Cloud-gCTS-repo.png            # D10 gCTS system screenshot
│   └── BTP-ABAP-Software-component-repo.png  # BTP DEV system screenshot
└── CLAUDE.md                     # Development context
```

## Key Details

| Property | Value |
|----------|-------|
| **Namespace** | `/COSS/` |
| **Package** | `/COSS/_UNIFIED` |
| **Delivery Unit** | `ZPARTNER` |
| **gCTS Format** | JSON v6, table content enabled |
| **Role** | Source of truth (Public Cloud) |

## Related Repositories

- [unified-sap-addon-clone](https://github.com/austinkloske22/unified-sap-addon-clone) — gCTS Enabled BTP ABAP Environment Repo (included as submodule)
