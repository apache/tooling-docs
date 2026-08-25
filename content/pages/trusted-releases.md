Title: Apache Trusted Releases platform
license: https://www.apache.org/licenses/LICENSE-2.0

The main project is the Apache Trusted Releases platform.

Endpoints:

- https://releases.apache.org
- https://release-catalog.apache.org

Repositories:

- https://github.com/apache/tooling-trusted-releases
- https://github.com/apache/tooling-releases-client
- https://github.com/apache/tooling-actions

## Trusted Releases Beta

   - Minimize human interaction.
   - Easily follow release policy.
   - MFA access required.
   - Designate Release Managers and maintain public GPG signing keys.
   - Confirm release catalog and configure sub-projects.
   - Securely compose Release Candidates.
   - Vote includes community through email thread tracking.
   - Finished releases are delivered to `svn:dist:release`.
   - Expedited security releases are completely private.
   - Templated vote and announcement emails.
   - Legacy release awareness in building a full release catalog.

## Committee Configuration

The Apache Trusted Releases (ATR) platform makes a distinction between the two parts of a Project Management Committee.
The committee consists of the PMC Members and includes project committers by reference.
All PMC Members are enabled to be Release Managers. A PMC Member can designate any committer as a Release Manager.
The committee also has an associated set of GPG signing keys found in `svn:dist:release` by convention. ATR can be configured
to maintain the KEYS file for you.

Committees that are approved for CI Release builds require special setup. Permissions are shown on the committee page.
Look into [Tooling actions](https://github.com/apache/tooling-actions) for Github Actions to use for trusted publishing.

## Project Configuration

Most PMCs have only their namesake project. There are many projects that have 2-8 subprojects and there are a few
that have dozens of subprojects. We've determined subprojects via two methods. First via an existing DOAP file
known to https://projects.apache.org, and second by analyzing all existing and archived releases made by the PMC.
This process is imperfect and we require PMCs with multiple projects to confirm these. The best place to verify projects is
by reviewing the PMC's catalog page at https://release-catalog.apache.org/. Engage with the Tooling team
to make corrections.

There are many different project settings. You can review these in the website and then export a yaml fragment to save
it in your project's `.asf.yaml` file.

## User Settings

Each user can manage their access tokens and keys. At a minimum new Release Managers will need to save their GPG public key.
Depending on the method chosen to upload your release candidate artifacts PATs, JWTs, or SSH keys may be required.

## Release Phases

   - Incorporate all PMC Releases.
     - Download page.
     - Release Candidate page.
     - Archived download page.
   - Every PMC has a management interface.
     - Current manual release practice is viewable.
     - Automated release status.
     - **KEYS** file management including revoking keys.
     - Trigger release phases.
     - Tracking performance.
   - Platform includes a RESTful API.
   - Serve release artifacts efficiently.
   - Make switching from current manual release process to a minimal ATR process very simple.
   - System Admins (Infra) have a management interface.
   - Provide operational status to help Infra monitor ATR operations through the Infra Reporting Dashboard (IRD).
   - Develop the platform with consideration about reusability outside of the ASF ecosystem, where feasible with regards to development costs.

   See [Platform Services](platform.html) for detailed requirements for the **ATR**.

## 4. Automate Release Process around Compliance

   - Meet Release Policy
     - Legal Policy
     - Infra Policy
     - Security Policy
   - SBOMs and Attestations
     - Include dependency and license compliance.
     - Provide clear attribution and information about Release Votes.
   - Certificate and Credential Management
     - Manage the signing keys needed for automation.
   - Download Page including available SBOM and verification instructions.
   - Announcement Email.

## 5. Release Lifecycle Phases

   Here is a flow chart showing the [Release Lifecycle Phases](https://github.com/apache/tooling-docs/blob/main/apache-trusted-releases/lifecycle.md).

## 6. Infrastructure Requirements

   - Run book for releases.apache.org
   - Progress on the retirement path for `svn:dist`. See [Legacy Releases from SVN Dist](svn-dist.html)
     for possible transitional states. For the beta test _transition 1B_ is preferred.
   - Legacy urls for dist.apache.org, downloads.apache.org, dlcdn.apache.org, and archive.apache.org remain supported.
   - Path schemes for downloads.apache.org, dlcdn.apache.org, and archive.apache.org remain.

## 7. Future Requirements

   - Integrate with the [Security Advisory Process](https://github.com/apache/tooling-docs/blob/main/apache-trusted-releases/advisory-process.md) to make it easy to track applicable advisories on download pages.
   - Expand support for [Evaluating Build Claims](https://github.com/apache/tooling-docs/blob/main/apache-trusted-releases/evaluate.md) to additional build tools.
   - Expand automated support for additional [Distribution Channels](https://github.com/apache/tooling-docs/blob/main/apache-trusted-releases/distributions.md).
   - Include a [Signing Candidates](https://github.com/apache/tooling-docs/blob/main/apache-trusted-releases/digital-signatures.md) phase during ATR processing.

     > There are policy implications to the automation of digital signatures.
     > For now, creating digital signatures on certain artifact types must be done prior to GPG signing and
     > prior to submission of the release candidate.
