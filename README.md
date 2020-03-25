# Cobalt KeyStore

Following the [official documentation](https://www.cobaltstrike.com/help-malleable-c2#validssl) on implementing custom SSL certs in Cobalt Strike, this script loosely follows along and really just saves some time and manual typing.

This assumes you've already submitted a Certificate Signing Request (CSR) and gone through the necessary steps to get a valid SSL cert from a trusted third-party.

If you haven't done so, check out the linked guides from Namecheap. It's probably similar with other hosting providers.

Just a quick refresher:

```
openssl req -new -newkey rsa:2048 -nodes -keyout example.key -out example.csr
```

You now have a CSR and accompanying private key.

![.csr and .key screenshot](https://github.com/Luct0r/assets/blob/master/CSR-and-Key.png)

Submit the CSR for validation via your hosting provider.

You'll then receive a .ca-bundle file combining the root and intermediate certificates and a .crt file which is the signed certificate.

![SSL bundle email](https://github.com/Luct0r/assets/blob/master/SSL-bundle.png)

![All needed SSL files](https://github.com/Luct0r/assets/blob/master/SSL-files.png)

# Usage

```
./cobaltkeystore.sh /path/to/domain.crt /path/to/domain.ca-bundle /path/to/domain.key *.domain.com /path/to/save/domain.store
```

![Usage screenshot](https://github.com/Luct0r/assets/blob/master/cobaltkeystore.png)

# Additional Resources
* [Generating CSR on Apache + OpenSSL/ModSSL/Nginx + Heroku](https://www.namecheap.com/support/knowledgebase/article.aspx/9446/14/generating-csr-on-apache--opensslmodsslnginx--heroku/)
* [Steps to Get SSL Certificate Activated](https://www.namecheap.com/support/knowledgebase/article.aspx/794/67/how-do-i-activate-an-ssl-certificate)
