#!/bin/bash
smtp_server() {
	docker run --rm \
		--net=host \
		maildev/maildev
}
