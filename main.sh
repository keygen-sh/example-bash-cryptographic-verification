#!/usr/bin/env bash

if [[ -z "$KEYGEN_PUBLIC_KEY" ]]; then
  echo -e "\033[31mError: env var KEYGEN_PUBLIC_KEY is not set\033[0m"
  exit 1
fi

# Prompt for license key
echo -ne "\033[34mPlease enter an RSA PKCS1-PSS signed license key: \033[0m"
read signed_license_key

# Parse the license key
read -r signing_data   enc_sig <<<$(echo "$signed_license_key" | tr "." " ")
read -r signing_prefix enc_key <<<$(echo "$signing_data"       | tr "/" " ")

if [ "$signing_prefix" != "key" ]; then
  echo -e "\033[31mLicense key signing prefix '$signing_prefix' is invalid\033[0m"
  exit 1
fi

# Verify the license key's signature
openssl dgst -verify <(echo -n "$KEYGEN_PUBLIC_KEY") -sha256 \
  -sigopt rsa_padding_mode:pss \
  -sigopt rsa_pss_saltlen:-2 \
  -sigopt rsa_mgf1_md:sha256 \
  -signature <(echo -n "$enc_sig" | base64 --decode) \
  <(echo -n "key/$enc_key") \
  > /dev/null 2>&1

if [ $? -eq 0 ]; then
  dec_key=$(echo -n "$enc_key" | base64 --decode)

  echo -e "\033[32mLicense key is cryptographically valid!\033[0m"
  echo -e "  => \033[34m$dec_key\033[0m"

  exit 0
else
  echo -e "\033[31mLicense key is cryptographically invalid!\033[0m"
  echo -e "  => \033[34mEnsure your key is signed using RSA_2048_PKCS1_PSS_SIGN_V2\033[0m"
  echo -e "  => \033[34mEnsure your public key is valid\033[0m"
  echo -e "  => \033[34mEnsure your key is valid\033[0m"

  exit 1
fi