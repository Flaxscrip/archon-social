# Archon.Social – Server (Express)

### Overview
This folder contains the Express server for Archon.Social, providing DID-based authentication using Keymaster and Gatekeeper. It exposes `/api` routes for login, profile management, name registration, and credential issuance.

### Setup

1. **Install dependencies**:
    - `npm install`

2. **.env configuration**
    - `AD_HOST_PORT=3000`
    - `AD_SERVE_CLIENT=true` (Whether to serve the client build or not)
    - `AD_CORS_SITE_ORIGIN=http://localhost:3001` (URL of remote client)
    - Additional variables like `AD_KEYMASTER_URL`, `AD_GATEKEEPER_URL`, `AD_WALLET_URL` for Keymaster/Gatekeeper integration.

3. **Run**:
    - `npm start`
      Starts the server at `http://localhost:3000`.

### Serving the Client
If `AD_SERVE_CLIENT=true` and you have built the React app (`npm run build` in client), this server will serve that `build/` folder for all non-API requests.

### CORS and Sessions
- This server uses `express-session` for session-based logins. Make sure to keep `credentials: true` if you want cross-origin cookies from your React dev server.

### API Endpoints

**Authentication**
- `/api/challenge` – Creates a DID challenge for the user to scan or respond to.
- `/api/login` – Receives a DID response and logs the user in.
- `/api/check-auth` – Checks if the user is logged in.
- `/api/logout` – Logs the user out.

**Profile & Names**
- `/api/profile/:did` – Get user profile.
- `/api/profile/:did/name` – Get/set user's @name.
- `/api/name/:name` – Resolve a name to DID.
- `/api/name/:name/available` – Check name availability.

**Credentials**
- `/api/credential` – Get user's credential status.
- `/api/credential/request` – Request/update verifiable credential.

**Registry**
- `/api/registry` – Get full name→DID registry.
- `/member/:name` – Get member's DID document by name.
- `/directory.json` – Public registry JSON.

**Admin**
- `/api/admin` – Get full database (admin only).
- `/api/admin/publish` – Publish registry to IPNS (admin only).
