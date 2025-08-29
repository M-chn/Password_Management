# Password Management Shiny App <img src="https://csiontario.ca/wp-content/uploads/2022/03/logo-CSIO-black.svg" align="right" width=300 alt="" />

**Description:**  

This project contains two example Shiny applications for password management using the [`shinymanager`](https://github.com/datastorm-open/shinymanager) package.  
It demonstrates how to securely store and manage user credentials in either a local SQLite database or a PostgreSQL database (e.g., AWS RDS). The apps are designed to be deployed on Posit Connect Cloud.  

**Status:**  

- `Active ▶️`: development and changes expected. Ready for Posit Connect deployment.  

**Directory Structure:**  

```
.
├── .gitignore
├── .RData
├── .Rhistory
├── app.R
├── app_postgres.R
├── credentials.sqlite
├── manifest.json
├── Password_Management.Rproj
└── README.md


```


**Environment Variables:**  

- **SQLite App (`app.R`)**  
  - `SHINYMGR_DB_PATH` – Path to SQLite database file  
  - `SHINYMGR_PASSPHRASE` – Passphrase for encrypting the SQLite database  

- **PostgreSQL App (`app_postgres.R`)**  
  - `PGHOST` – Hostname of PostgreSQL server  
  - `PGPORT` – Port number  
  - `PGDATABASE` – Database name 
  - `PGUSER` – Database username  
  - `PGPASSWORD` – Database password  

> Note: PostgreSQL deployment requires public accessibility and correct security group settings in AWS.  

**Deployment & Usage:**  

1. **Sync with Posit Connect Cloud:**  
   Connect your GitHub repository to Posit Connect to deploy the app.  

2. **Set Environment Variables:**  
   Add the required environment variables in the Posit Connect dashboard according to the app being used (see above).  

3. **Manifest File:**  
   After changes to the app or dependencies, re-run `rsconnect::writeManifest()` to update `manifest.json` so Posit Connect recognizes package requirements.  

**Additional Documents:**  

- [`shinymanager` GitHub Documentation](https://github.com/datastorm-open/shinymanager)  

**Additional Notes:**  

- PostgreSQL database currently uses a table called `credentials` – can/should be renamed.  
- SQLite database table must be created locally and uploaded along with the app.
- Easily should be able to wrap the app.r in shinymanager's admin mode and access the SQLite DB from the app directly. This is my current recommendation for this project.

**Maintainers & Contacts:**  
- Repository Maintainer: Manjot
---
