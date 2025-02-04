# Requirements

While reading consider these Notes:

- This list attempts to avoid implementation details aside from existing practices.
- See the [README](../README.md) for where to discuss these requirements.

## 1. Automate the Release Process

   - Minimize human interaction.
   - Community participation on **Release Votes** remains via email.
   - Record all of the key events for tracking operations and performance.
   - PMCs can quickly benefit.
   - Infra costs and management complexity are decreased.

## 2. Community

   - Work with a selection of **Apache** PMCs and **Infra** for **User Acceptance Testing (UAT)**.
   - Co-ordinate with **Infra** on roles and responsibility on this complex stack.
   - Assure that the **ATR platform** follows industry best practices especially regarding **SBOMs** and **Certificate Management**.
   - Help lead the industry to better practices.
   - If necessary, work within the **ASF** on **Release Policy** improvements. 

## 3. Apache Trusted Release Platform (ATR)

   - Incorporate all PMC Releases.
     - Download page. (migrated/mirrored from dist/release)
     - Release Candidate pages. (migrated/mirrored from dist/dev)
     - Archived download page. (migrated from archives)
   - Every PMC has a management interface.
     - Current manual release practice is viewable.
     - Automated release status.
     - **KEYS** file management including revoking keys.
     - Manual triggers.
     - Tracking performance.
   - Platform includes a RESTful API.
   - Platform perfers to serve static content.
   - Make switching from current manual release process to a minimal ATR process very simple.
   - Provide operational status to help Infra monitor ATR operations through the IRD.

   See [Platform Services](./platform.md) for detailed requirements for the **ATR**.

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

   Here is a flow chart showing the [Release Lifecycle Phases](lifecycle.md).

## 6. Additional Requirements

   - Retire dist.apache.org svn repository once all 200+ PMCs having fully switched over to directly using the **ATR**.
   - Map legacy urls for https://dist.apache.org, https://download.apache.org, and https://archive.apache.org to https://releases.apache.org

## 7. Future Requirements

   - Integrate with the [Security Advisory Process](advisory-process.md) to make it easy to track applicable advisories on download pages.
