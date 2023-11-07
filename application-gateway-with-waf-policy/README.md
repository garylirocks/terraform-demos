# Application gateway with WAF policy associated

Deploy an Application Gateway (AGW) with an associated WAF policy, and a backend (a web app)

Can be used to test AGW and WAF policy.

Access the app via `http://<ip>`

This should be blocked by the OWASP rules in WAF:

```sh
curl -I "http://xx.xx.xx.xx?1=1"

# HTTP/1.1 403 Forbidden
# ...
```

There is a custom rule, which allows you to bypass the managed rules:

```sh
curl -I "http://xx.xx.xx.xx?1=1&bypass_owasp=1"

# HTTP/1.1 200 OK
# ...
```