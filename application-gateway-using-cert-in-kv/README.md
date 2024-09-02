# README

- Deploy an AGW with WAF policy, backend pool (a web app)
- For testing AGW and WAF related policies
- Create a public listener, with port 80
- Create a private listener, with port 80 (not accessible, possibly one way to access it is via vNet integrated CloudShell)
- Create three WAF policies
  - Global policy
  - Site policy, associate to a listener
  - Path policy, associate to a path routhing rule

## Test

You could test the WAF policy by sending a request to the public IP of the AGW with a query string.

```sh
curl -I 'http://20.11.107.197/?<queryString>'

curl -I 'http://20.11.107.197/?siteBlock'
# blocked

curl -I 'http://20.11.107.197/?globalAllow_siteBlock'
# still blocked, site policy overrides global policy
```