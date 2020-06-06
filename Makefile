#!make
include .env


build:
	
	$(info Make: Building "$(DOMAIN)" environment images.)
	docker-compose build --no-cache
	@make -s clear

start:
	
	$(info Make: Starting "$(DOMAIN)" environment containers.)
	docker-compose up -d

stop:

	$(info Make: Stopping "$(DOMAIN)" environment containers.)
	@docker-compose stop

down:

	$(info Make: Down "$(DOMAIN)" environment containers.)
	@docker-compose down

restart:

	$(info Make: Restarting "$(DOMAIN)" environment containers.)
	@make -s stop
	@make -s start

ssl-start:
	
	rm -rf docker/nginx/ssl/*
	
	$(info The certificate created.)
	openssl req -x509 -nodes -days 365 -subj "/C=CA/ST=QC/O=${DOMAIN}, Inc./CN=${DOMAIN}" -addext "subjectAltName=DNS:${DOMAIN}" -newkey  rsa:4096 -keyout docker/nginx/ssl/${DOMAIN}.key -out docker/nginx/ssl/${DOMAIN}.crt;

	$(info System restart.)
	@make -s restart

ssl-start-mac:
	
	rm -rf docker/nginx/ssl/*
	
	$(info The certificate created.)
	$(info $(shell tput setaf 1)Sudo authority may be required for this.$(shell tput sgr0))
	openssl req -x509 -nodes -days 365 -subj "/C=CA/ST=QC/O=${DOMAIN}, Inc./CN=${DOMAIN}" -addext "subjectAltName=DNS:${DOMAIN}" -newkey  rsa:4096 -keyout docker/nginx/ssl/${DOMAIN}.key -out docker/nginx/ssl/${DOMAIN}.crt;

	$(info The certificate is add to the system directory.)
	sudo security add-trusted-cert -d -r trustRoot -k /Library/Keychains/System.keychain docker/nginx/ssl/${DOMAIN}.crt
	
	$(info System restart.)
	@make -s restart

ssl-refresh:
	
	$(info The certificate is delete to the system directory and docker folder.)
	$(info $(shell tput setaf 1)Sudo authority may be required for this.$(shell tput sgr0))

	sudo security delete-certificate -c "${DOMAIN}"
	rm -rf docker/nginx/ssl/*

	@make -s sslbuild

php:

	docker-compose exec php bash

nginx:

	docker-compose exec nginx bash

clear:
	
	@clear
