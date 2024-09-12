# Entra applications

This example demos creation of Entra applications

- Create one app registration (`app-creator`) manually, or via a script, using your own Global Admin account
- Login to this app

  ```sh
  az login --service-principal --username "<app-client-id>" --password "<password>" --tenant "<tenant-id>" --allow-no-subscriptions
  ```

- Test creating another application

  ```sh
  terraform init
  terraform apply
  ```