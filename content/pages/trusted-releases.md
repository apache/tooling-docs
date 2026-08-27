Title: Apache Trusted Releases platform
license: https://www.apache.org/licenses/LICENSE-2.0

[TOC]

The main project for the Tooling Initiative is the Apache Trusted Releases (ATR) platform.

1. Websites:

   - https://releases.apache.org - this is the ATR UX which is dynamic requiring ASF login credentials.
   - https://release-catalog.apache.org - this is the full ASF release catalog in a static website hosted by httpd.

2. Repositories:

   - https://github.com/apache/tooling-trusted-releases - the ATR UX and API.
   - https://github.com/apache/tooling-releases-client - a Python client for Release Managers.
   - https://github.com/apache/tooling-actions - Github Actions for Trusted Publishing.

## Beta platform features {#features}

   - Minimize human interaction
   - Easily follow release policy
   - Require MFA for access
   - Designate Release Managers and maintain their GPG public signing keys
   - Confirm the derived release catalog and properly configure sub-projects
   - Securely compose Release Candidates
   - Enforce vote standards while continuing to include community
   - Releases are still delivered to `svn:dist:release`
   - Legacy release awareness in building a full release catalog.
   - Expedited security releases are completely private
   - Templated vote and announcement emails

## Configuration {#configuration}

The Apache Trusted Releases (ATR) platform makes a distinction between the two parts of a Project Management Committee.
First the PMC is a management committee with associated committers. Second, the PMC manages one or more projects.
To start to use ATR for your releases there is PMC configuration to review and adjust.

### Committee {#committee}

For the Committee ATR tracks Projects, Release Managers, and Signing Keys.
The committee consists of the PMC Members and includes project committers by reference.
All PMC Members are enabled to be Release Managers. A PMC Member can designate any committer as a Release Manager.

The committee also has an associated set of GPG signing keys found in `svn:dist:release` by convention.
ATR can be configured to maintain the KEYS file for you.

Committees that are approved for CI Release builds require special setup. Permissions are shown on the committee page.
Look into [Tooling actions](https://github.com/apache/tooling-actions) for Github Actions to use for
[Trusted Publishing](https://releases.apache.org/docs/trusted-publishing).

### Projects {#projects}

Most PMCs have only their namesake project. There are many projects that have 2-8 subprojects and there are a few
that have dozens of subprojects. We've determined subprojects via two methods. First via an existing DOAP file
known to https://projects.apache.org, and second by analyzing all existing and archived releases.
This process was imperfect and we require PMCs with multiple projects to correct and confirm these. The best place to verify projects is
by reviewing the PMC's catalog page at https://release-catalog.apache.org/. Engage with the Tooling team
to make corrections.

There are many different project settings. These are categorized according to their aspect.

1. Releases - start a new release version and view the project's current releases.
2. Metadata - the project name, description, and other urls. Some of these are required.
3. Security - security emails and threat model urls.
4. Lifecycle - how the project handles versioning. `semver`, `calver`, or `simple`.
5. Trusted Publishing - what GitHub repositories, branch, and workflows to trust.
6. Compose - license checking and other composition settings.
7. Vote - voting options and email templates.
8. Finish - distribution subdirectory and announcement email templates.

You can review these in the ATR website and then export a yaml fragment to save it in your project repository's `.asf.yaml` file.

### Release Manager {#release-manager}

Each Release Manager should manage their access tokens and keys. At a minimum new Release Managers will need to save their GPG public key.
Depending on the method chosen to upload your release candidate artifacts PATs, JWTs, or SSH keys may be required.

## Release Candidate Phases {#phases}

ATR has three phases for a Release Candidate. The Release Manager will guide the Release Candidate through these phases in order
to make a Release of a new Version of a Project.

A Release Candidate can be started in several ways.

1. The ATR UX provides a few places to start a release. If you are making a secret Expedited Release then the UX is the only place.
2. The Python client provides a command. You must provide a PAT created in the UX.
3. The ATR Maven Plugin will start a new version when you run the target. You must configure Maven with a PAT created in the UX.
4. If you have permission to build releases in CI then you can use a GitHub Action.

### 1. Compose {#compose}

This phase starts when a new release version is created. Every uploaded artifact is checked in several ways. New revisions may be made.
If you cancel a Vote you can return to the Compose phase and replace your artifacts with new revisions. There are several ways to upload.

1. The ATR UX provides a few methods
   - Browser upload. This is best for small source only releases.
   - SVN Dev directory. If you are still creating your release and checking in your artifacts in SVN then ATR can upload from there.
   - Rsync. This is best when you have many convenience binary artifacts. You will need to provide you SSH public key to ATR.
2. The Python client provides a command. You must provide a PAT created in the UX.
3. The ATR Maven Plugin will start a new version when you run the target. You must configure Maven with a PAT created in the UX.
4. If you have permission to build releases in CI then you can use a GitHub Action. The UX provides instructions.

After artifacts are uploaded they go through two steps.

1. Quarantine. Here each artifact is checked for defects like zip bombs and path traversal issues. Problems you would not to give your
   downstream users and ones we cannot allow on the ATR server.
2. Checks. Here we perform license, signature, and checksum checks. We make sure that you have included at least one source release
   artifact. We validate and evaluate any SBOM artifact provided. Because our excludes checks are imperfect, we expect Release Managers
   to exercise judgment about license exceptions.

### 2. Vote {#vote}

This phase provides a supervised voting period. Voters are provided with a public view of the candidate artifacts and check results.
(Expedited vote pages are only available to PMC Members.)

Votes are tabulated and reflected in a vote thread in one of three ways

1. Trusted. ATR announces the vote, but votes are cast on the ATR vote page and recorded as ballots, with receipts sent to the thread.
   The vote can be resolved automatically. For an Expedited release this is the only way to vote and that is limited to the private@ mailing list.
2. Email. ATR announces the vote, and votes are cast by replying to the thread. ATR tabulates the replies when the vote is resolved.
3. Manual. The vote is held entirely outside ATR. You provide the vote thread URL and record the result manually.

ATR assures that VOTEs are open for a PMC chosen minimum of from 72 hours to 168 hours. Expedited releases will automatically be completed when
enough +1 (binding) votes have occurred.

### 3. Finish {#finish}

This phase allows for the distribution of the release and ends with the announcement. In this phase the release artifacts are pushed to
`svn:dist:release`, you wait for them to propagate to downloads.apache.org, do any distributions like to Maven Central, and then you announce
the release!

## Release Catalog {#catalog}

ATR maintains a Release Catalog in its database. It watches `svn:dist:release` with `pubsub` and catalogs legacy releases along with ATR releases.
A record of each release is sent to the `releases@tooling.apache.org` mailbox. With each release and archival of a release a static
[Release Catalog](https://release-catalog.apache.org) is updated.
