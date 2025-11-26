# Data Model

Here is an introduction to the ATR's data model.

> The view here is descriptive of a JSON model, but the implementation will be a combination of filesystem files and subdirs along with a database schema.

## PMCs

Projects are run by a PMC with members and committers, have metadata, vote policy settings, and product lines.

1. Key
2. Project Name
9. Product Lines
4. User role lists:
   - PMC Members
   - Committers
   - Release Managers
5. Public Signing Keys
8. Vote Policy

### Product Lines

One or more product lines with separate releases including the main one. A product line may override PMC vote policy.

1. Key
2. PMC
3. Product Name
4. Latest Version
5. Distribution Channels
8. Vote Policy
9. Release lists:
    - Candidates
    - Current
    - Archived

### Public Signing Keys

Public Signing Keys are stored using the User ID of the owner as the key.

1. User
2. Public Signing Key
3. Type
4. Expiration

### Vote Policy

These are a set of choices which control how a release vote is conducted by the ATR.

1. Mailto Addresses for Emails - defaults to the project dev list, but the PMC can change these and add contacts.
   This will be helpful in getting dependent projects to check releases early.
3. Manual Vote Process flag - if this is set then the vote will be completely manual and following policy is ignored.
4. Minimum Number of Hours - the minimum time to run the vote. If set to `0` then wait until 3 +1 votes and more +1 than -1.
5. Release Checklist - Markdown text describing how to test release candidates.
6. Pause for RM check if any -1 votes flag - normally when the vote passes we proceed to the next steps,
   but we should allow the RM a chance to confirm if a -1 vote should stop the release.

## Releases

Releases are related groups of packages. Candidate releases go through stages and these have phases.
When approved to be released the stage is moved to current.
Current releases have initial phases to distribute and announce the release.

1. Storage key
2. Stage
3. Phase
4. PMC
5. Product Line
6. Package Managers
3. Version
5. Packages - List of triples of file, signature, and checksum that are the downloadable components of a release.
   > Should we use Artifacts instead of Packages?
6. SBOMs - in an acceptable SBOM format and maintained in Phases using standard Python libraries.
8. Vote Policy
5. Votes
   - Pass or Fail
   - Summary
   - Binding votes
   - Community votes
   - Start
   - End

## Distribution Channels

Distribution channels are where PMCs distribute release packages. These need to be defined in the ATR.
Distribution channels may be for test packages. Package Managers will be automated over time.

1. Name
2. Key
3. URL
4. Credentials
5. Is Test?
6. Automation endpoint

## User Roles

Multiple roles are possible and available actions are composed. Empty cells denote "no".

| Activity            | PMC Member | Release Manager | Committer | Visitor | ASF Member | SysAdmin |
|---------------------|------------|-----------------|-----------|---------|------------|----------|
| binding vote        | yes        |                 |           |         |            |          |
| vote                | yes        | yes             | yes       | yes     | yes        |          |
| release admin       | yes        | yes             |           |         |            | yes      |
| project admin       | yes        |                 |           |         |            | yes      |
| product admin       | yes        |                 |           |         |            | yes      |
| manage key          | yes        | yes             |           |         |            |          |
| run phase           | yes        | yes             |           |         |            | yes      |
| channel admin       |            |                 |           |         |            | yes      |
| view release events | yes        | yes             | yes       | yes     | yes        | yes      |
| view project events | yes        | yes             | yes       | yes     | yes        | yes      |
| search all events   |            |                 |           |         | yes        | yes      |

> To vote _visitors_ must provide PII and we need to explain how we are protecting their privacy.

> The authorization and authentication for `GitHub PATs` will be specific and fine-grained, but should be similar to a "release manager"
