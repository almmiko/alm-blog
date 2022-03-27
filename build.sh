#!/usr/bin/env bash

if [ -z ${BASE_URL} ]; then
    echo "BASE_URL is unset, use VERCEL_URL: '$VERCEL_URL'";
    hugo -b https://$VERCEL_URL -D --gc
else
    echo "BASE_URL is set to '$BASE_URL'";
    hugo -b https://$BASE_URL --gc
fi
