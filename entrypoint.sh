#!/bin/sh -l

set -e  # stops execution
set -u  # undefined variable

echo "Cloning git repository"
git config --global user.name "${GIT_USER}"
git config --global user.email "${GIT_EMAIL}"
mkdir /tmp/git
git clone --single-branch --branch "$GIT_BRANCH" "https://x-access-token:$GIT_USER_API_TOKEN@github.com/$GIT_REPOSITORY_OWNER/$GIT_REPOSITORY_NAME.git" /tmp/git
cd /tmp/git
#
TAG=$(echo ${GITHUB_REF} | sed -e "s/refs\/tags\/${INPUT_TAG_NAME_SKIP}//")
DOCKER_IMAGE=$(printf "%s/%s" $DOCKER_REPOSITORY_NAME $DOCKER_IMAGE_NAME)
echo DOCKER_IMAGE=$DOCKER_IMAGE
#
for i in $(grep -rn $DOCKER_IMAGE: ./ | awk -F: '{print $1}')
do
  echo Processing $i
  sed -E "s/${DOCKER_IMAGE}:.+$/${DOCKER_IMAGE}:${TAG}/" $i 
  #mv $i.tmp $i
done
#
#git add -A
#git diff --cached
#git commit -m "Test commit ${TAG}"
#git push
#git log -2
