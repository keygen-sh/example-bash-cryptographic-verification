# Example Bash Cryptographic Verification

This is an example of cryptographically verifying a license key's authenticity
using Bash and OpenSSL using your Keygen account's public key. In addition, the
license verification script will also extract any embedded tamper-proof data
within the key. You can find your public key within [your account's settings page](https://app.keygen.sh/settings).

This example implements the [`RSA_2048_PKCS1_PSS_SIGN_V2` scheme](https://keygen.sh/docs/api/#policies-create-attrs-scheme).
Cryptographically verifying signed license keys can be used to implement
offline licensing capabilities, as well as to add additional security measures
to an online software licensing system.

All that is needed to cryptographically verify a signed license key is
your account's public key.

## Running the example

First up, add an environment variable containing your public key:
```bash
# Your Keygen account's public key (make sure it is *exact* - newlines and all)
export KEYGEN_PUBLIC_KEY=$(printf %b \
  '-----BEGIN PUBLIC KEY-----\n' \
  'zdL8BgMFM7p7+FGEGuH1I0KBaMcB/RZZSUu4yTBMu0pJw2EWzr3CrOOiXQI3+6bA\n' \
  # …
  'efK41Ml6OwZB3tchqGmpuAsCEwEAaQ==\n' \
  '-----END PUBLIC KEY-----')
```

You can either run each line above within your terminal session before
starting the app, or you can add the above contents to your `~/.bashrc`
file and then run `source ~/.bashrc` after saving the file.

Next, grant the `main.sh` bash script execute privileges:
```bash
chmod +x main.sh
```

Then run the script, entering the signed key when prompted:
```bash
./main.sh
```

The license key's authenticity will be verified using RSA-SHA256 with PKCS1
PSS padding. Be sure to copy your public key and license key correctly - your
key will fail validation if either of these are copied or included incorrectly.
You can find your public key in [your account's settings](https://app.keygen.sh/settings).

## Questions?

Reach out at [support@keygen.sh](mailto:support@keygen.sh) if you have any
questions or concerns!
