# UAT Script: C0FHIR Suite v1.2

## Scope
Validate install, endpoint behavior, and basic data extraction for C0FHIR Suite in a test VistA environment.

## Preconditions
- VistA test environment is available.
- KIDS file `c0fhir_v1_2.kid` is accessible.
- Tester has programmer access for routine execution.
- Proxy/service account is available for endpoint testing.

## Test Data
- Known patient DFN (example: `1135`)
- Known patient last name for discovery search (example: `ABBOTT`)
- Start date for filtered extraction (example: `3250101` = Jan 1, 2025 FileMan date)

## Test Cases

### TC-01 Install Package
1. Open KIDS Installation menu.
2. Run `Load a Distribution` and select `c0fhir_v1_2.kid`.
3. Run `Install Package(s)` and select `C0FHIR ENCOUNTER SUITE 1.2`.

Expected Result:
- Install completes without fatal errors.
- Post-install routine `C0FHIRPI` runs.

Pass/Fail: ___  
Notes: ___

### TC-02 Verify Components
1. Execute:
   ```mumps
   D EN^C0FHIRCH
   ```

Expected Result:
- Output includes:
  - `Checking RPC... OK.`
  - `Checking Option... OK.`
  - `Checking Web Service 'GET /fhir'... OK.`
  - `Summary: 6 Passed, 0 Failed.`

Pass/Fail: ___  
Notes: ___

### TC-03 Interactive Developer Test (DFN)
1. Execute:
   ```mumps
   D EN^C0FHIRTS
   ```
2. Enter DFN `1135`.

Expected Result:
- JSON preview is returned.
- Bundle structure is valid FHIR R4 format.

Pass/Fail: ___  
Notes: ___

### TC-04 Endpoint Discovery
1. Call:
   `GET /fhir?name=ABBOTT`

Expected Result:
- HTML list of matching patients is returned.
- Returned list includes DFN links.

Pass/Fail: ___  
Notes: ___

### TC-05 Endpoint Extraction by DFN
1. Call:
   `GET /fhir?dfn=1135`

Expected Result:
- Full FHIR R4 JSON Bundle is returned for the patient.
- Response is valid JSON and not empty.

Pass/Fail: ___  
Notes: ___

### TC-06 Filtered Extraction by Date
1. Call:
   `GET /fhir?dfn=1135&sdt=3250101`

Expected Result:
- FHIR Bundle only includes data on/after Jan 1, 2025 scope.
- Response is valid JSON.

Pass/Fail: ___  
Notes: ___

### TC-07 Security Context Assignment
1. Confirm proxy/service account has `C0FHIR CONTEXT`.

Expected Result:
- Account can access endpoint as configured.
- Unauthorized account behavior follows site policy.

Pass/Fail: ___  
Notes: ___

## Optional Cleanup / Decommission Test
1. Execute:
   ```mumps
   D EN^C0FHIRUN
   ```

Expected Result:
- System configuration is removed.
- M routines remain for audit per design.

Pass/Fail: ___  
Notes: ___

## Sign-Off
- Tester Name: ___
- Role: ___
- Date: ___
- Overall Result: Pass / Fail
- Final Comments: ___
