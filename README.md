# Archon.Social

### Overview
Archon.Social is a decentralized naming service built on Archon Protocol. Users can claim `@name` handles, prove DID ownership, and receive verifiable credentials.

This repository is split into two main folders:

- **client/** – A React front-end
- **server/** – An Express/Node back-end

### Features

- **Decentralized Identity** – Login with your DID using challenge-response authentication
- **Name Registration** – Claim your `@name` handle (3-32 characters, alphanumeric + hyphens/underscores)
- **Verifiable Credentials** – Receive credentials proving your name ownership, signed by Archon.Social
- **Member Directory** – Browse registered members and view their DID documents
- **IPNS Publication** – Registry published to IPFS for decentralized resolution

### Running the Demo

You can run the demo in two ways:

1. **Run client and server together** – The server will serve the built React client.
2. **Run client and server separately** – The client dev server communicates via an API URL to the back end.

### Repository Structure

- **client/**  
  A React front-end, with a `.env` controlling its API endpoint and HTTPS dev settings.
- **server/**  
  An Express server that provides `/api` endpoints, using Keymaster for DID-based authentication.

### Quick Start

1. **Install** dependencies for both client and server:
  - `npm run install`  

2. **Run** both in parallel:
  - `npm start`  

3. **Visit** the site in a browser:
  - If you're serving the client from the server, go to `http://localhost:3000`.

### QR Code Authentication

The QR code encodes a URL that includes the challenge DID as a query parameter:

`https://wallet.archon.technology?challenge=did:cid:...`

The wallet URL is specified in an environment variable `AD_WALLET_URL` included in a `.env` file.

An Archon wallet installed on a mobile device can scan the QR code and extract the challenge DID from the URL.

The API offers two ways to submit a response to the challenge, GET and POST.

The GET method uses a query parameter for the `response`:

```
curl https://archon.social/api/login?response=did:cid:...
```

The POST method takes the same parameter in the body:

```
curl -X POST -H "Content-Type: application/json" -d '{"response":"did:cid:..."}' https://archon.social/api/login
```

Both login methods return a JSON object indicating whether the login was successful:
```
{ authenticated: [ true | false ] }
```

### Environment Variables

See `sample.env` for example values including:
- `AD_WALLET_URL` – Wallet URL for QR codes
- `AD_CALLBACK_URL` – Callback URL for authentication
- `AD_GATEKEEPER_URL` – Gatekeeper API endpoint
- `AD_IPFS_API_URL` – IPFS API for registry publication
- `AD_IPNS_KEY_NAME` – IPNS key for publishing

### Further Reading
- **client/README.md** – Explains how to run the React client independently.
- **server/README.md** – Explains how to run the auth server independently.

### License
MIT
