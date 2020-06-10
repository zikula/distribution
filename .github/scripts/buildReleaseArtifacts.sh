#!/bin/bash

SOURCE_PATH="${GITHUB_WORKSPACE}"
BUILD_PATH="${GITHUB_WORKSPACE}/build_work"
BRANCH_PREFIX="refs/heads/"
BRANCH_NAME=${GITHUB_REF#"$BRANCH_PREFIX"}
EXPORT_PATH="${BUILD_PATH}/export"
PACKAGE_PATH="${EXPORT_PATH}/zikula"
ARCHIVE_PATH="${BUILD_PATH}/archive"
PHP_BUILD="./build.php"

echo "Copying sources to package directory..."
# prevent copying sub directory into itself
cp -r . /tmp/ZKTEMP
mkdir -p "${PACKAGE_PATH}" "${ARCHIVE_PATH}"
# exclude . and ..
mv /tmp/ZKTEMP/{*,.[^.]*} "${PACKAGE_PATH}"

cd "${PACKAGE_PATH}"

echo "Composer Install"
composer install --no-progress --no-suggest --prefer-dist --optimize-autoloader --no-scripts
echo "Post autoload dump"
composer run-script post-autoload-dump
echo "Post install command"
composer run-script post-install-cmd

rm -rf "${PACKAGE_PATH}/.git" "${PACKAGE_PATH}/.github"

echo "Creating archives..."
#if [ -e "${PACKAGE_PATH}/var/log" ]; then # Zikula 3+
#    ${PHP_BUILD} build:package --name="${BRANCH_NAME}" --build-dir="${ARCHIVE_PATH}" --source-dir="${PACKAGE_PATH}"
#else
    ARCHIVE_BASE_PATH="${ARCHIVE_PATH}/zikula"
    cd "${EXPORT_PATH}"; zip -q -D -r "${ARCHIVE_BASE_PATH}.zip" .
    cd "${EXPORT_PATH}"; tar cp "zikula" > "${ARCHIVE_BASE_PATH}.tar"; gzip "${ARCHIVE_BASE_PATH}.tar"

    echo "Creating MD5 and SHA1 checksums..."
    CHECKSUM_PATH="${ARCHIVE_PATH}/zikula-checksums"
    TMP_FILE="${CHECKSUM_PATH}.tmp"
    echo "-----------------md5sums-----------------" > "${TMP_FILE}"
    md5sum "${ARCHIVE_PATH}/"*.tar.gz "${ARCHIVE_PATH}/"*.zip >> "${TMP_FILE}"
    echo "-----------------sha1sums-----------------" >> "${TMP_FILE}"
    sha1sum "${ARCHIVE_PATH}/"*.tar.gz "${ARCHIVE_PATH}/"*.zip >> "${TMP_FILE}"

    cat "${TMP_FILE}" | sed "s!${ARCHIVE_PATH}/!!g" > "${CHECKSUM_PATH}.txt"
    rm -f "${TMP_FILE}"
#fi
