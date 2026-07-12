
# Security Judge Report

**Overall Score: 68/100**

A solid foundation with a strong focus on user privacy and on-device data encryption. However, critical flaws in network configuration and incomplete privacy features prevent a higher score. The app correctly uses secure storage for cryptographic keys and implements encryption for PII in the database. The main risks stem from insecure network calls and hardcoded development endpoints.

---

### Strengths

*   **Data Encryption:** The application correctly implements AES-256 encryption for Personally Identifiable Information (PII) before it's stored in the local SQLite database (via Drift). The `student_profile_dao.dart` explicitly uses an `EncryptionService` to encrypt fields like name, email, and phone.
*   **Secure Key Management:** It uses the `flutter_secure_storage` package, which correctly leverages the underlying platform's secure enclaves (Android Keystore, iOS Keychain) to store cryptographic keys. This is the industry-standard approach.
*   **Clear Privacy Communication:** The `privacy_screen.dart` is excellent. It clearly, and in simple terms, explains what data is collected, why it's collected, where it's stored (on-device), and for how long. This transparency is a major plus.
*   **Input Validation:** Key input forms (`profile_edit_screen.dart`, `university_matcher.dart`) use `Form` validation and `TextInputFormatter` to sanitize user input, reducing the risk of data corruption or injection attacks.
*   **No Hardcoded Secrets:** No hardcoded API keys, tokens, or other secrets were found in the codebase. Production configuration is correctly handled via environment variables (`--dart-define`).

### Weaknesses

*   **Insecure Defaults:** The default API endpoint in `api_config.dart` is `http://localhost:8080`. While intended for development, this sets a precedent for insecure, unencrypted communication. Production builds rely entirely on the build process to provide a secure `https://` URL.
*   **Incomplete Privacy Features:** The data export and data viewer features, while present in the UI, are non-functional ("coming soon"). This means users cannot currently exercise their right to data portability.
*   **Vague Error Handling:** Some `catch` blocks display raw error messages from backend responses (`Error: ${response.body}`). This can leak internal server details or stack traces, providing unnecessary information to a potential attacker.

### Critical Issues

*   **Hardcoded HTTP URL for Deletion:** The account deletion function in `privacy_screen.dart` sends a `DELETE` request to a hardcoded `http://localhost:8080/api/users/current`. This is a critical vulnerability. This call will fail in production, preventing users from deleting their data. If it were to hit a real (but insecure) endpoint, it would transmit the deletion request over an unencrypted channel.
*   **Lack of Certificate Pinning:** The application does not appear to implement certificate pinning for its API calls. This makes it vulnerable to man-in-the-middle (MITM) attacks on public Wi-Fi, where an attacker could intercept and tamper with API traffic even if HTTPS is used.

### Recommendations

1.  **Mandate HTTPS:** Modify `api_config.dart` to throw a build-time error if a production build is attempted without a `--dart-define` for a URL that starts with `https://`.
2.  **Fix Deletion Endpoint:** Immediately remove the hardcoded `http://localhost` URL in `privacy_screen.dart` and replace it with the `apiBaseUrl` getter to ensure it uses the correct, configured endpoint.
3.  **Implement Privacy Features:** Prioritize the implementation of the data export feature to fulfill the promises made in the privacy policy.
4.  **Implement Certificate Pinning:** Add certificate pinning to the network layer (e.g., in the Dio client) to protect against MITM attacks.
5.  **Sanitize Error Messages:** Standardize error handling to show generic, user-friendly error messages instead of printing raw backend responses. Log the full error to a secure, remote logging service for debugging.

### Confidence Score: 95%
The analysis is based on a comprehensive search and review of the application's source code. The findings, particularly the hardcoded URL and encryption logic, are clear and unambiguous.
