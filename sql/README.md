# SQL Server

Create a PaaS SQL Server and a database for testing.

- The database is loaded with sample data "AdventureWorksLT"
- Current user is added as Entra admin of the server
- A SQL auth admin account is added as well
- Create a file `localonly.auto.tfvars` with content below to avoid type in variables everytime.

  ```terraform
  administrator_login_password = "<password>"
  ```
