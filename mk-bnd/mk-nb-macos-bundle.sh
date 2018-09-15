#!/bin/sh

NETBEANS_PACKAGE=
NETBEANS_VERSION=
NETBEANS_PREFIX="."

while getopts v:p:f: ARGS; do
  case "$ARGS" in
    v) NETBEANS_VERSION=$OPTARG;;
    i) NETBEANS_PREFIX=$OPTARG;;
    f) NETBEANS_PACKAGE=$OPTARG;;
  esac
done

if [ -z "${NETBEANS_PACKAGE}" ] || [ -z "${NETBEANS_VERSION}" ] || [ -z "${NETBEANS_PREFIX}" ] ; then
>&2 echo "Syntax: $0 -v <NetBeans-version> [ -p<NetBeans-install-dir> ] -f <NetBeans-pkg(file|URL)>"
exit 1
fi

PKG_TYPE=
if curl --output /dev/null --silent --head --fail "${NETBEANS_PACKAGE}"; then
#URL downloaded
>&2 printf "Downloading ${NETBEANS_PACKAGE}... "
curl -O --silent "${NETBEANS_PACKAGE}"
>&2 echo "done."
PKG_TYPE=U
NETBEANS_PACKAGE=$(basename "${NETBEANS_PACKAGE}")
else if [ -f "${NETBEANS_PACKAGE}" ] ; then
PKG_TYPE=F
else
>&2 echo "File ${NETBEANS_PACKAGE} not found."
exit 2
fi
fi

NETBEANS_BUNDLE_NAME="NetBeans ${NETBEANS_VERSION}.app"

NETBEANS_INSTALL_DIR="${NETBEANS_PREFIX}/bundle.tmp"

mkdir -p "${NETBEANS_INSTALL_DIR}/Contents/MacOS"
mkdir -p "${NETBEANS_INSTALL_DIR}/Contents/Resources"
sed "s/NETBEANS_VERSION/${NETBEANS_VERSION}/g" Info.plist.template >"${NETBEANS_INSTALL_DIR}/Contents/Info.plist"
unzip "${NETBEANS_PACKAGE}" -d "${NETBEANS_INSTALL_DIR}/Contents/Resources/"
mv "${NETBEANS_INSTALL_DIR}/Contents/Resources/netbeans" "${NETBEANS_INSTALL_DIR}/Contents/Resources/NetBeans"
(cd "${NETBEANS_INSTALL_DIR}/Contents/MacOS" && ln -s ../Resources/NetBeans/bin/netbeans netbeans)
cp "${NETBEANS_INSTALL_DIR}/Contents/Resources/NetBeans/nb/netbeans.icns" "${NETBEANS_INSTALL_DIR}/Contents/Resources/"
mv "${NETBEANS_INSTALL_DIR}" "${NETBEANS_PREFIX}/${NETBEANS_BUNDLE_NAME}"

if [ "${PKG_TYPE}" = "U" ]; then
rm "${NETBEANS_PACKAGE}"
fi
