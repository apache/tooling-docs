# Data Model

Here is an introduction to the ATR's data model.

> The view here is descriptive of a json model, but the implementation will be a combination of filesytem files and subdirs along with an SQLite database schema.

## Projects

Projects are run by a PMC with members and committers, have metadata, vote policy settings, and products.

1. Key
2. Project Name
3. Version String
9. Products
4. User role lists:
   - PMC Members
   - Committers
   - Release Managers
5. Public Signing Keys
8. Vote Policy Settings
9. CVEs
10. Release lists:
    - Candidates
    - Current
    - Revoked

### Products

Zero or more products with separate releases from the main one. A product may override vote policy settings.

1. Key
2. Product Name
3. Version String
8. Vote Policy Settings
9. CVEs
10. Release lists:
    - Candidates
    - Current
    - Revoked

### Public Signing Keys

Public Signing Keys are stored using the User id of the owner as the key. When attached

1. User
2. Public Signing Key
3. Type
4. Expiration

### Vote Policy Settings

These are a set of choices which control how a release vote is conducted by the ATR. 

1. Manual Vote Process flag - if this is set then the vote will be completely manual and following policy is ignored.
2. Minimum Number of Hours - the minimum time to run the vote. If set to `0` then wait until 3 +1 votes and more +1 than -1.
3. Release Checklist - markdown text describing how to test release candidates.
4. Pause for RM check if any -1 votes flag - normally when the vote passes we proceed to the next steps,
   but we should allow the RM a chance to confirm if a -1 vote should stop the release.

### CVEs

CVEs are can be stored by id and are associated to other objects through lists.

1. ID
2. Date
3. Title
4. Projects
5. Products
6. Releases

## Releases

Releases are related groups of packages. Candidate releases go through stages and these have phases.
When approved to be released the stage is moved to current.
Currrent releases have initial phases to distribute and announce the release.

1. Storage key
2. Stage
3. Phase
3. Version String
4. CVEs
3. Packages - List of triples of file, signature, and checksum that are the downloadable components of a release.
6. SBOMs - in an acceptable SBOM format and maintained in Phases using standard python libraries.
5. Votes
   - Pass or Fail
   - Summary
   - Binding votes
   - Votes
   - Start
   - End

## User Roles

Multiple roles are possible and available actions are composed.

| Activity   | PMC Member | Release Manager | Committer | Visiter | ASF Member | Admin
| ---------- | ---------- | --------------- | --------- | ------- | ---------- | -----
| binding vote | yes |  | | |  | 
| vote         | yes | yes | yes | yes | yes | 
| manage release | yes | yes | | | | yes
| manage policy | yes | yes | | | | yes
| manage metadata | yes | yes | | | | yes
| manage keys | yes | | | | | yes
| manage own key | yes | yes | | | |
| perform actions | yes | yes | | | | yes
| view release events | yes | yes | yes | yes | yes | yes
| view all events | | | | | yes | yes

> To vote _visiters_ must provide PII and we'll need to assure that this is affirmatively agreed and revocable.

> The authorization and authentication for `GitHub PATs` will be specific and fine-grained, but should be similar to a "release manager"
