# `pass` + GPG Setup Guide
> Encrypted local API key storage using `pass`, GPG, and `exports.zsh`

---

## Why This Setup

- API keys are **encrypted at rest** via GPG — unreadable without your passphrase
- Keys are **never stored in plain text** on disk
- Keys are **automatically available** in every terminal via `exports.zsh`
- `exports.zsh` is **safe to commit** to GitHub — it only contains `pass` lookup commands, not actual keys
- No cloud dependency, no supply chain risk, no third-party apps

---

## Key Choices & Why

| Choice | Option Picked | Why |
|---|---|---|
| Key type | `(16) ECC and Kyber` | Post-quantum hybrid — future-proof against quantum attacks |
| Elliptic curve | `Curve 25519` | Modern, fast, widely trusted standard |
| Kyber variant | `Kyber 768 (X25519)` | Pairs natively with Curve 25519, standard security level (AES-128 equivalent), not overkill |
| Expiration | `0` (never) | Personal local key — expiration would force re-encrypting all secrets |

---

## Setup

### Step 1 — Install and configure pinentry-mac

Do this **before** generating your GPG key so macOS prompts work correctly during key generation.

```bash
brew install pass gnupg pinentry-mac
mkdir -p ~/.gnupg
chmod 700 ~/.gnupg
echo "pinentry-program $(brew --prefix)/bin/pinentry-mac" >> ~/.gnupg/gpg-agent.conf
echo "default-cache-ttl 3600" >> ~/.gnupg/gpg-agent.conf
echo "max-cache-ttl 86400" >> ~/.gnupg/gpg-agent.conf
gpgconf --kill gpg-agent
```

> `default-cache-ttl 3600` caches your passphrase for 1 hour.
> `max-cache-ttl 86400` extends cache up to 24 hours max.
> This means you only enter your passphrase once per session.

---

### Step 2 — Generate your GPG key

```bash
gpg --full-generate-key
```

When prompted:

| Prompt | Answer |
|---|---|
| Key type | `16` (ECC and Kyber) |
| Elliptic curve | `1` (Curve 25519) |
| Kyber variant | `3` (Kyber 768 X25519) |
| Expiration | `0` (never expires) |
| Real name | your name |
| Email | your email |
| Comment | leave blank |
| Passphrase | strong passphrase — **do not forget this** |

---

### Step 3 — Verify your key was created

```bash
gpg --list-keys
```

Output looks like:
```
pub   ed25519 2024-01-01 [SC]
      AB12CD34EF56GH78IJ90KL12MN34OP56QR78ST90
uid           [ultimate] Your Name <you@email.com>
```

---

### Step 4 — Initialize pass

Use your email — easier than copying the fingerprint:

```bash
pass init "you@email.com"
```

---

### Step 5 — Insert your API keys

```bash
pass insert api-keys/openai
pass insert api-keys/anthropic
pass insert api-keys/groq
```

Each command prompts you to type the value twice. Type keys **without quotes**.

Your keys are now stored encrypted under:
```
~/.password-store/
└── api-keys/
    ├── openai.gpg
    ├── anthropic.gpg
    └── groq.gpg
```

---

### Step 6 — Verify it works

```bash
pass api-keys/openai
```

Should prompt for your GPG passphrase and return your key.

---

### Step 7 — Add to `exports.zsh`

`GPG_TTY` must come **before** the `pass` lookups:

```bash
# API Keys
export GPG_TTY=$(tty)
export OPENAI_API_KEY="$(pass api-keys/openai)"
export ANTHROPIC_API_KEY="$(pass api-keys/anthropic)"
export GROQ_API_KEY="$(pass api-keys/groq)"
```

---

### Step 8 — Test

Open a new terminal and run:

```bash
echo $OPENAI_API_KEY
```

Should print your key. Done.

---

## Day-to-Day Usage

### Add a new key
```bash
pass insert api-keys/newservice
```
Then add to `exports.zsh`:
```bash
export NEWSERVICE_API_KEY="$(pass api-keys/newservice)"
```

### View a key
```bash
pass api-keys/openai
```

### Edit a key
```bash
pass edit api-keys/openai
```

### List all keys
```bash
pass ls
```

### Delete a key
```bash
pass rm api-keys/openai
```

### Copy a key to clipboard (clears after 45 seconds)
```bash
pass -c api-keys/openai
```

---

## Troubleshooting

**GPG passphrase prompt not appearing**
```bash
export GPG_TTY=$(tty)
gpgconf --kill gpg-agent
```

**pass can't find GPG key**
```bash
gpg --list-keys   # verify key exists
```

**Slow terminal startup**
Normal on first terminal after reboot — GPG cache is cold. After first passphrase entry, subsequent terminals load instantly for up to 24 hours.
