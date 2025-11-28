Title: ASF standard for scannable secret tokens
license: https://www.apache.org/licenses/LICENSE-2.0

[DRAFT STANDARD]

**NOTE: This is an ASF Tooling proposal only. This is not ASF policy.**

## Scope and definitions

This standard defines a common syntax for secret tokens used within applications developed by the ASF for the ASF. In other words, it is relevant for applications developed by teams including but not limited to Marketing and Publicity, Infrastructure, Security, and Tooling. It does not apply to top level projects (TLPs). This token syntax is mandatory for all new tokens in applications covered by this scope after the date of publication, [DATE OF PUBLICATION].

The regular expression syntax used throughout this standard is POSIX Extended Regular Expressions as defined in IEEE Std 1003.1-2017 Section 9.4. EREs are case sensitive. The base62 alphabet used throughout this standard contains, in order, the 62 characters `0-9`, `A-Z`, and `a-z`.

## Purpose

Secret tokens are used by bearers to prove their right to access resources or services. They are akin to passwords, but must be transmitted over the network, and therefore run the risk of being leaked e.g. by inclusion in configuration files or application logs.

In addition to standard procedures to mitigate leaks, one defence in depth approach is to structure secret tokens in a standardised way which is amenable to automated scanning. Several tools exist for the purpose of such scanning and are widely used. This document standardises one universal format for use at the ASF within the scope defined in the previous section.

## Requirements

There is no existing universally accepted standard for the syntax of secret tokens, but existing secret scanning tools make recommendations with documented rationales. These rationales are often relevant to the ASF, and can therefore be treated as requirements. There are also some extra ASF specific requirements.

Scannable secret tokens at the ASF must:

* Start with a prefix which acts as an issuer namespace, to allow a direct link with a remediation policy.
* Use `_` rather than `-` as a separator so that double clicking selects the whole token in common interfaces.
* Include a checksum of a significant portion of the rest of the token to reduce false positives during scanning.
* Use a subset of token68 characters (from RFC 9110), i.e. a subset of the regular expression `^[A-Za-z0-9._~+/-]+=*$`, to ensure compatibility with DPoP (RFC 9449).
* Include enough secure entropy, measured in bits from a secure random or pseudorandom source, to avoid collisions or guessing of issued values.
* Not exceed common application length bounds, e.g. on the length of header field values or storage columns in databases.

## Syntax

ASF scannable secret tokens must match the following regular expression:

    ^asf_([a-z]{3,6})_([0-9A-Za-z]{27})([0-4][0-9A-Za-z]{5})$

With the following constraints:

* The first match group, called the **component**, forms part of the namespace, and must not already be allocated. Allocations are tracked and approved by the Security team. The allocation process and currently allocated values are documented by Security at <[URL]>.
* Each character in the second match group, the **entropy**, must be generated from a secure random or pseudorandom number generator with a uniform distribution across all base62 characters permitted in the regular expression.
* The third match group, the **checksum**, must be the base62 encoded IEEE 802.3 CRC-32 of the second group, with the most significant digit in base62 first, using `0` for left padding to six characters. The CRC-32 result `0xFFFFFFFF`, for example, is encoded as `4gfFC3`. The CRC-32 is of the actual base62 characters, not, for example, a decoded version of the base62 characters in binary. It is an invariant that every byte used as input to the CRC-32 algorithm in this construction is within the base62 alphabet.

One consequence of these constraints is that the first and second match groups allow every possible value permitted by their regular expressions, but the third match group does not.

The IEEE 802.3 CRC-32 algorithm uses the reflected polynomial `0xEDB88320`, initial value `0xFFFFFFFF`, and final XOR with `0xFFFFFFFF`.

The complete token length can vary between 41 and 44 characters depending on the chosen component length.

## Rationale

We use 27 characters from the base62 alphabet because that is the minimum equivalent to at least 160 bits, and because this follows a convention set by GitHub.

    >>> import math
    >>> math.log2(62 ** 27)
    160.76330038044563

ASVS v5.0.0 criteria 7.2.3 and 11.5.1 require at least 128 bits of entropy for tokens and unguessable values respectively. One motivation for using slightly over 160 bits, in addition to following the convention set by GitHub, is that it prevents implementers from using 128 bit UUIDs as a source of "randomness" for the syntax defined in this specification; no existing UUID version contains 128 bits of entropy, and some contain far less. Using just over 160 bits instead of just over 128 bits requires five extra base62 encoded characters.

We use base62 to follow a convention set by GitHub.

We use IEEE 802.3 CRC-32 because that algorithm is recommended by GitHub in their recipe for "high quality, identifiable secrets".

The regular expression for our syntax is a subset of the token68 production, and therefore compatible with DPoP.

Six digits in base62 are enough to express the entire range of CRC-32 values, because `(2 ** 32) < (62 ** 6)`.

    >>> (2 ** 32) < (62 ** 6)
    True

Because the maximum value of a CRC-32, `0xFFFFFFFF`, is encoded by this specification as `4gfFC3`, no base62 encoded checksums beyond that value can be generated. One consequence is that the leading base62 digit must be in the range `0-4`, and this is reflected in the regular expression. Further constraints to the regular expression would be possible, but the chosen constraint level balances accuracy with concision.

## Sample generator code

    def asf_secret_token(component: str) -> str:
        import secrets
        import zlib
        lower = "abcdefghijklmnopqrstuvwxyz"
        if len(component) not in (3, 4, 5, 6):
            raise ValueError("Component must be between 3 and 6 letters")
        if not (set(component) <= set(lower)):
            raise ValueError("Component must use lowercase letters only")
        alphabet = "0123456789" + lower.upper() + lower
        entropy = "".join(secrets.choice(alphabet) for _ in range(27))
        n = zlib.crc32(entropy.encode("ascii"))
        checksum = ""
        for _ in range(6):
            n, rem = divmod(n, 62)
            checksum = alphabet[rem] + checksum
        return f"asf_{component}_{entropy}{checksum}"

## Sample generated tokens

These values must not be used in any application. The `sample` component will be registered by Security as the first known component, and can be used for documentation examples where an arbitrary component is suitable.

    asf_sample_mXBgIOwUcV44oJElFX4LCMhWkEs2gaLe2
    asf_sample_63Uo76APFVkmVyTpHpi3W7zlmxJ1dGuWP
    asf_sample_PfCdJHSP5C8vM4hkQRMImIzAFm90LW1gM

## Test vectors

    Entropy:  000000000000000000000000000
    CRC-32:   0x816710BC
    Checksum: 2MvMGi
    Token:    asf_sample_0000000000000000000000000002MvMGi

    Entropy:  zzzzzzzzzzzzzzzzzzzzzzzzzzz
    CRC-32:   0x39DF34DC
    Checksum: 13hv5A
    Token:    asf_sample_zzzzzzzzzzzzzzzzzzzzzzzzzzz13hv5A

## Detection guidance

To detect tokens, the regular expression presented in the Syntax section above can be used alone, without anchoring, as a heuristic with a high probability of matches. For better prevention of false positives in detection, the suffix matching the CRC-32 can be validated. Components can also be validated against the list maintained by Security.
