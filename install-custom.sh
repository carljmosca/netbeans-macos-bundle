#!/bin/bash

# these need to be updated for new versions.
NETBEANS_VERSION='9'
NETBEANS_URI="http://apache.mirrors.pair.com/incubator/netbeans/incubating-netbeans-java/incubating-9.0/incubating-netbeans-java-9.0-bin.zip"

show_help() {
    echo "./install-custom.sh [--install-dir /Applications] [--netbeans-uri http://some.apache.netbeans.mirror] [--non-root-install]"
}

# the trailing space is required
SUDO_COMMAND='sudo '
INSTALL_DIR='/Applications'

while [[ $# -gt 0 ]]
do
key="$1"
case $key in
    -n|--non-root-install)
    unset SUDO_COMMAND
    shift
    ;;
    -d|--install-dir)
    INSTALL_DIR="$2"
    shift
    shift
    ;;
    -v|--netbeans-version)
    NETBEANS_VERSION="$2"
    shift
    shift
    ;;
    -u|--netbeans-uri)
    NETBEANS_URI="$2"
    shift
    shift
    ;;    
    -*)
    echo "Unknown option: $1"
    show_help
    exit 1
    ;;
    *)
    arg_num=$(( $arg_num + 1 ))
    case $arg_num in
        1)
        first_normal_arg="$1"
        shift
        ;;
        2)
        second_normal_arg="$1"
        shift
        ;;
        *)
        bad_args=TRUE
    esac
    ;;
esac
done

${SUDO_COMMAND}mkdir -p "${INSTALL_DIR}/NetBeans/NetBeans ${NETBEANS_VERSION}.app/Contents/MacOS"
${SUDO_COMMAND}mkdir -p "${INSTALL_DIR}/NetBeans/NetBeans ${NETBEANS_VERSION}.app/Contents/Resources"

cat >> "${INSTALL_DIR}/NetBeans/NetBeans ${NETBEANS_VERSION}.app/Contents/Info.plist" << EOT
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
    <string>NetBeans "$NETBEANS_VERSION"</string>

    <key>CFBundleVersion</key>
    <string>"$NETBEANS_VERSION"</string>

    <key>CFBundleExecutable</key>
    <string>netbeans</string>

    <key>CFBundlePackageType</key>
    <string>APPL</string>

    <key>CFBundleShortVersionString</key>
    <string>"$NETBEANS_VERSION"</string>

    <key>CFBundleIdentifier</key>
    <string>org.netbeans.ide.baseide."$NETBEANS_VERSION"</string>

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

curl $NETBEANS_URI > temp.zip
${SUDO_COMMAND}unzip temp.zip -d "${INSTALL_DIR}/NetBeans/NetBeans $NETBEANS_VERSION.app/Contents/Resources/"
${SUDO_COMMAND}mv "$INSTALL_DIR/NetBeans/NetBeans $NETBEANS_VERSION.app/Contents/Resources/netbeans" "$INSTALL_DIR/NetBeans/NetBeans $NETBEANS_VERSION.app/Contents/Resources/NetBeans"
rm temp.zip
${SUDO_COMMAND}ln -s "$INSTALL_DIR/NetBeans/NetBeans $NETBEANS_VERSION.app/Contents/Resources/NetBeans/bin/netbeans" "$INSTALL_DIR/NetBeans/NetBeans $NETBEANS_VERSION.app/Contents/MacOS/netbeans"
${SUDO_COMMAND}cp "$INSTALL_DIR/NetBeans/NetBeans $NETBEANS_VERSION.app/Contents/Resources/NetBeans/nb/netbeans.icns" "$INSTALL_DIR/NetBeans/NetBeans $NETBEANS_VERSION.app/Contents/Resources/"
