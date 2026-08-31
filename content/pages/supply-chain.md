Title: Supply Chain Attacks FAQ
license: https://www.apache.org/licenses/LICENSE-2.0

Releases that flow through ATR with proper settings mitigate the following Supply Chain attack scenarios:

1. MFA signin prevents password theft attacks
2. Trusted Voting prevents unauthorised publication of a release
3. Prevent tampered artifacts (we ensure there's a signature for every artifact and we provide it alongside the artifact in the catalog. Automated
   verification as a possible future enhancement),
4. Guarantee the release matches what was voted on (since the whole release flows through ATR)
5. Hidden or malicious archive content (since we validate archives and prevent things like abs paths, traversal, etc)
6. Dependency issues - we don't explicitly prevent these, but we provide the tools to do so by analysing and exposing any SBOMs uploaded,
   and in making those available in the catalog we help downstream consumers avoid such attacks
7. Addition of files to source archives that weren't in the repository root, through our GitHub source comparison check
8. Various attacks prevented by OIDC in Trusted Publishing from GitHub, especially use of exfiltrated long term credentials
9. Cannot maliciously remove a key revocation from a block in a KEYS file if managed by ATR, since ATR key packets are additive only
