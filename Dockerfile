FROM debian as build

ARG OPENSSL_VERSION="1_1_1"
ENV OPENSSL_VERSION="${OPENSSL_VERSION}"

RUN apt-get update -y && \
	apt-get install -y \
		git \
		libghc-zlib-dev \
		build-essential

WORKDIR /data
RUN git clone https://github.com/openssl/openssl.git

WORKDIR /data/openssl
RUN git checkout OpenSSL_${OPENSSL_VERSION}-stable \
	&& ./config --prefix=/usr/local/ssl --openssldir=/usr/local/ssl shared zlib \
	&& make \
	&& make test \
	&& make install

FROM debian:stretch-slim

COPY --from=build /usr/local/ssl/ /usr/local/ssl/
RUN echo "/usr/local/ssl/lib" > /etc/ld.so.conf.d/openssl-1.1.1.conf && ldconfig -v
WORKDIR /usr/local/ssl/bin
ENTRYPOINT ["/usr/local/ssl/bin/openssl"]
CMD ["version"]