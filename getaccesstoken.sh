#!/bin/sh
set -eu

usage() {
    cat <<ENDUSAGE
$0: Get an access token from a Matrix server
Required arguments:
-s | --server    The Matrix server base URI, like https://matrix.example.com
-u | --user      The name of the user, like blahadmin (not @blahadmin:example.com)
-p | --password  The user's password
An automated version of this:
https://t2bot.io/docs/access_tokens/
Suggested here:
https://github.com/spantaleev/matrix-docker-ansible-deploy/blob/master/docs/configuring-playbook-email2matrix.md#obtaining-an-access-token-for-the-sender-user
ENDUSAGE
}

server=
user=
password=
while test $# -gt 0; do
    case "$1" in
        -h | --help ) usage; exit;;
        -s | --server ) server=$2; shift 2;;
        -u | --user ) user=$2; shift 2;;
        -p | --password ) password=$2; shift 2;;
        *) usage; exit 1;;
    esac
done

uri=https://$server/_matrix/client/r0/login
data="{'identifier': {'type': 'm.id.user', 'user': '$user' }, 'password': '$password', 'type': 'm.login.password', 'device_id': '$user-curl', 'initial_device_display_name': '$user-curl'}"
echo "Will curl url '$uri' with data:"
echo "$data"

curl --data "$data" "$uri"

