# VistA-FHIR-Server

This Quick Start README provides the essential commands and steps to deploy, verify, and use the C0FHIR Suite.

## Quick Start Guide: C0FHIR Suite v1.2

### 1. Installation

To install the suite on a new VistA environment, use the KIDS distribution file.

1. Load the distribution: `KIDS Menu -> Installation -> Load a Distribution`  
   Select `c0fhir_v1_2.kid`.
2. Install the package: `KIDS Menu -> Installation -> Install Package(s)`  
   Select `C0FHIR ENCOUNTER SUITE 1.2`.
3. Automatic setup: the post-install routine `C0FHIRPI` automatically registers:
   - RPC
   - Context Option
   - Web Service endpoint

### 2. Verification

Once installed, run the validation tool to ensure all components are active.

```mumps
D EN^C0FHIRCH
```

Expected output:

```text
Checking RPC... OK.
Checking Option... OK.
Checking Web Service 'GET /fhir'... OK.
Summary: 6 Passed, 0 Failed.
```

### 3. Developer Testing

Use the interactive tester to verify that clinical data is being extracted correctly for a specific patient.

```mumps
D EN^C0FHIRTS
```

- Search by DFN: Enter a patient IEN (for example, `1135`) to see a JSON preview of the FHIR Bundle.
- Search by Date: Leave the encounter blank and provide a date range to test bulk extraction.

### 4. Web Service Usage

The suite provides a single endpoint that handles both patient discovery and data extraction.

| Request Type | Example URL | Result |
|---|---|---|
| Discovery | `GET /fhir?name=ABBOTT` | HTML list of matching patients with DFN links. |
| Extraction | `GET /fhir?dfn=1135` | Full FHIR R4 JSON Bundle for the patient. |
| Filtered | `GET /fhir?dfn=1135&sdt=3250101` | FHIR Bundle restricted to data since Jan 1, 2025. |

### 5. Decommissioning

To remove the system configuration while keeping the M routines for audit:

```mumps
D EN^C0FHIRUN
```

### 6. Technical Inventory

- RPC: `C0FHIR GET FULL BUNDLE`
- Context Option: `C0FHIR CONTEXT`
- Web Endpoint: `/fhir`
- Security: Assign `C0FHIR CONTEXT` to the Proxy User or Service Account.
