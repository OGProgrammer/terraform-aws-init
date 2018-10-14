#!/usr/bin/env bash
echo "SCRIPT: empty-s3-bucket <bucket>"
echo "EXECUTING: empty-s3-bucket"

echo "Checking for aws cli..."
if ! [ -x "$(command -v aws)" ]; then
    echo 'Error: aws cli is not installed.' >&2
    exit 1
fi

bucket=$1
if [ -z "$bucket" ]; then
    echo "A bucket must be provided! Failing out."
    exit 1
fi

set -e

echo "Removing all versions from $bucket"

versions=`aws s3api list-object-versions --bucket $bucket |jq '.Versions'`
markers=`aws s3api list-object-versions --bucket $bucket |jq '.DeleteMarkers'`

echo "removing files"
for version in $(echo "${versions}" | jq -r '.[] | @base64'); do
    version=$(echo ${version} | base64 --decode)

    key=`echo $version | jq -r .Key`
    versionId=`echo $version | jq -r .VersionId `
    cmd="aws s3api delete-object --bucket $bucket --key $key --version-id $versionId"
    echo $cmd
    $cmd
done

echo "removing delete markers"
for marker in $(echo "${markers}" | jq -r '.[] | @base64'); do
    marker=$(echo ${marker} | base64 --decode)

    key=`echo $marker | jq -r .Key`
    versionId=`echo $marker | jq -r .VersionId `
    cmd="aws s3api delete-object --bucket $bucket --key $key --version-id $versionId"
    echo $cmd
    $cmd
done
