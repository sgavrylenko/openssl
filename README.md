build image
```bash
docker build -t bigboo/openssl-x.x.x
```

push image
```bash
docker push bigboo/openssl-x.x.x
```

run check
```bash
docker run --network bbq \
	-v "/usr/local/share/ca-certificates/CA_consul.crt:/data/CA_consul.crt" \
	--rm bigboo/openssl-1.1.1 \
	s_client -CAfile /data/CA_consul.crt -starttls ldap ldap-proxy.service.consul:389
```