#!/bin/sh

BASEDIR=$(cd "$(dirname "$0")"; pwd)

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

(cat <<EOT
<?xml version="1.0" encoding="UTF-8"?>
<!--
DO NOT ALTER OR REMOVE COPYRIGHT NOTICES OR THIS HEADER.

Copyright (c) 2008, 2016 Oracle and/or its affiliates. All rights reserved.

Oracle and Java are registered trademarks of Oracle and/or its affiliates.
Other names may be trademarks of their respective owners.

The contents of this file are subject to the terms of either the GNU
General Public License Version 2 only ("GPL") or the Common
Development and Distribution License("CDDL") (collectively, the
"License"). You may not use this file except in compliance with the
License. You can obtain a copy of the License at
http://www.netbeans.org/cddl-gplv2.html
or nbbuild/licenses/CDDL-GPL-2-CP. See the License for the
specific language governing permissions and limitations under the
License.  When distributing the software, include this License Header
Notice in each file and include the License file at
nbbuild/licenses/CDDL-GPL-2-CP.  Oracle designates this
particular file as subject to the "Classpath" exception as provided
by Oracle in the GPL Version 2 section of the License file that
accompanied this code. If applicable, add the following below the
License Header, with the fields enclosed by brackets [] replaced by
your own identifying information:
"Portions Copyrighted [year] [name of copyright owner]"

If you wish your version of this file to be governed by only the CDDL
or only the GPL Version 2, indicate your decision by adding
"[Contributor] elects to include this software in this distribution
under the [CDDL or GPL Version 2] license." If you do not indicate a
single choice of license, a recipient has the option to distribute
your version of this file under either the CDDL, the GPL Version 2 or
to extend the choice of license to its licensees as provided above.
However, if you add GPL Version 2 code and therefore, elected the GPL
Version 2 license, then the option applies only if the new code is
made subject to such option by the copyright holder.

Contributor(s):
-->
<!DOCTYPE plist SYSTEM "file://localhost/System/Library/DTDs/PropertyList.dtd">
<plist version="1.0">
  <dict>
    <key>CFBundleName</key>
    <string>NetBeans NETBEANS_VERSION</string>

    <key>CFBundleVersion</key>
    <string>NETBEANS_VERSION</string>

    <key>CFBundleExecutable</key>
    <string>netbeans</string>

    <key>CFBundlePackageType</key>
    <string>APPL</string>

    <key>CFBundleShortVersionString</key>
    <string>NETBEANS_VERSION</string>

    <key>CFBundleIdentifier</key>
    <string>org.netbeans.ide.baseide.NETBEANS_VERSION</string>

    <key>CFBundleSignature</key>
    <string>NETB</string>

    <key>CFBundleInfoDictionaryVersion</key>
    <string>6.0</string>

    <key>CFBundleIconFile</key>
    <string>netbeans.icns</string>

    <key>CFBundleDocumentTypes</key>
    <array>
	<dict>
		<key>CFBundleTypeName</key>
		<string>public.shell-script</string>
		<key>CFBundleTypeRole</key>
		<string>Editor</string>
		<key>LSItemContentTypes</key>
		<array>
			<string>public.shell-script</string>
		</array>
	</dict>
    </array>
    
    <key>NSHighResolutionCapable</key>
    <true/>

    <key>NSSupportsAutomaticGraphicsSwitching</key>
    <true/>
    
  </dict>
</plist>
EOT
) | sed "s/NETBEANS_VERSION/${NETBEANS_VERSION}/g" >"${NETBEANS_INSTALL_DIR}/Contents/Info.plist"

unzip "${NETBEANS_PACKAGE}" -d "${NETBEANS_INSTALL_DIR}/Contents/Resources/"
mv "${NETBEANS_INSTALL_DIR}/Contents/Resources/netbeans" "${NETBEANS_INSTALL_DIR}/Contents/Resources/NetBeans"
(cd "${NETBEANS_INSTALL_DIR}/Contents/MacOS" && ln -s ../Resources/NetBeans/bin/netbeans netbeans)
cp "${NETBEANS_INSTALL_DIR}/Contents/Resources/NetBeans/nb/netbeans.icns" "${NETBEANS_INSTALL_DIR}/Contents/Resources/"
mv "${NETBEANS_INSTALL_DIR}" "${NETBEANS_PREFIX}/${NETBEANS_BUNDLE_NAME}"

if [ "${PKG_TYPE}" = "U" ]; then
rm "${NETBEANS_PACKAGE}"
fi
