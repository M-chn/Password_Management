# Password Management Shiny App

This repository contains two example Shiny applications for password management using the [`shinymanager`](https://github.com/datastorm-open/shinymanager) package.

---

## `app.R` (SQLite Example)

- **Use Case:**  
  A local setup of a SQLite database for storing user credentials.
- **How it works:**  
  The app reads the SQLite database path and passphrase from environment variables (`SHINYMGR_DB_PATH` and `SHINYMGR_PASSPHRASE`).


---

## `app_postgres.R` (PostgreSQL Example)

- **Use Case:**  
  Designed for use with a PostgreSQL database, such as AWS RDS, for storing user credentials.
- **How it works:**  
  The app expects PostgreSQL connection details (host, port, database, user, password) to be provided via environment variables (`PGHOST`, `PGPORT`, `PGDATABASE`, `PGUSER`, `PGPASSWORD`).
- **Note:**  
  The PostgreSQL database connection is not setup and would require the public accessibility and the appropriate security group settings (inbound rules) in AWS. (Didn't have access to creating/editting VPC settings)

---

## Deployment & Usage

1. **Sync with Posit Connect Cloud:**  
   To use these apps in production, sync your github repository with Posit Connect.

2. **Set Environment Variables:**  
   In the Posit Connect dashboard, add the required environment variables for your chosen app:
   - For `app.R`:  
     - `SHINYMGR_DB_PATH`
     - `SHINYMGR_PASSPHRASE`
   - For `app_postgres.R`:  
     - `PGHOST`
     - `PGPORT`
     - `PGDATABASE`
     - `PGUSER`
     - `PGPASSWORD`

3. **Manifest File:**  
   Whenever you make changes to your app or its dependencies, re-run the creation of `manifest.json` , ```rsconnect::writeManifest()``` to ensure Posit Connect recognizes the correct package requirements and app metadata.

---

## Additional Notes

- Currently postgres using a database called `credentials`, can/should be changed
- SQLite table should be created locally and then uploaded along with the app.
 