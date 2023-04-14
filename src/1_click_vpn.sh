#!/bin/bash

first_api="https://1clickvpn.net/api/v1"
second_api="https://api.1clickvpn.net/api/v1"
token=null

function get_servers() {
	curl --request GET \
		--url "$first_api/servers" \
		--user-agent "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/103.0.0.0 Safari/537.36" \
		--header "content-type: application/json"
}

function get_current_ip() {
	curl --request GET \
		--url "$second_api/checks/ip" \
		--user-agent "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/103.0.0.0 Safari/537.36" \
		--header "content-type: application/json"
}

function sign_in() {
	# 1 - email: (string): <email>
	# 2 - password: (string): <password>
	response=$(curl --request POST \
		--url "$second_api/auth/signin" \
		--user-agent "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/103.0.0.0 Safari/537.36" \
		--header "content-type: application/json" \
		--data '{
			"email": "'$1'",
			"password": "'$2'"
		}')
	if [ -n $(jq -r ".token" <<< "$response") ]; then
		token=$(jq -r ".token" <<< "$response")
	fi
	echo $response
}

function sign_up() {
	# 1 - email: (string): <email>
	# 2 - password: (string): <password>
	curl --request POST \
		--url "$second_api/auth/signup" \
		--user-agent "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/103.0.0.0 Safari/537.36" \
		--header "content-type: application/json" \
		--data '{
			"email": "'$1'",
			"password": "'$2'",
			"passwordConfirmation": "'$2'"
		}'
}

function change_password() {
	# 1 - current_password: (string): <current_password>
	# 1 - new_password: (string): <new_password>
	curl --request POST \
		--url "$second_api/auth/signup" \
		--user-agent "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/103.0.0.0 Safari/537.36" \
		--header "content-type: application/json" \
		--header "cookie: token=$token" \
		--data '{
			"currentPassword": "'$1'",
			"newPassword": "'$2'",
			"newPasswordConfirmation": "'$2'"
		}'
}
