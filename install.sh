#!/bin/bash

# these need to be updated for new versions.
NETBEANS_VERSION='13'
NETBEANS_URI="https://dlcdn.apache.org/netbeans/netbeans/${NETBEANS_VERSION}/netbeans-${NETBEANS_VERSION}-bin.zip"
NETBEANS_SHA512_URI="https://downloads.apache.org/netbeans/netbeans/${NETBEANS_VERSION}/netbeans-${NETBEANS_VERSION}-bin.zip.sha512"

show_help() {
    echo "./install-custom.sh [options]"
    echo
    echo "Available Options:"
    echo "    -d | --install-dir <path>"
    echo "        (Default: /Applications):"
    echo "        Change the directory where the app is going to be installed in."
    echo
    echo "    -v|--netbeans-version <version>"
    echo "        (Default: ${NETBEANS_VERSION})"
    echo "        Creates an application with the corresponding version number."
    echo "        Please note that this does not change the downloaded version,"
    echo "        but just affects the created package name."
    echo
    echo "    -u | --netbeans-uri <URI>"
    echo "        (Default: ${NETBEANS_URI})"
    echo "        Change the download URI from where to get the Netbeans package."
    echo "        You can use a mirror closer to you to get higher download speeds."
    echo "        Please note that this will disable the integrity check."
    echo
    echo "    -n | --non-root-install"
    echo "        Do not install as root using sudo."
    echo "        Please note that the default installation path requires root permissions."
    echo "        You need to specify a different path using --install-dir to change this."
    echo
    echo "    --verbose"
    echo "        Displays extra information during a run. Namely a more detailed progress "
    echo "        from curl for the download and the list of extracted files from the archive."
    echo
    echo "    -f | --force"
    echo "        Allows the script to remove an existing package before installing. Otherwise"
    echo "        the script will refuse to install the package if it already exists."
    echo
    echo "    -h | --help"
    echo "        Show this help."
}

# the trailing space is required
SUDO_COMMAND='sudo '
INSTALL_DIR='/Applications'
PROGRESSBAR='--progress-bar'
QUIETUNZIP='-q'
FORCE=0

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
    echo "Disabling the integrity check because -u | --netbeans-uri has been used."
    echo
    NETBEANS_SHA512_URI=""
    shift
    shift
    ;;    
    --verbose)
    unset PROGRESSBAR
    unset QUIETUNZIP
    shift
    ;;
    -f|--force)
    FORCE=1
    shift
    ;;
    -h | --help)
    show_help
    exit
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

if [ ! -z "${SUDO_COMMAND}" ]
then
    echo "The script might ask for a password. This is because sudo is used to"
    echo "gain root permissions to create the software package"
    echo
fi

# check if target directory already exists and allow the user to delete
# it by using the --force | -f command line option
if [ -d "${INSTALL_DIR}/NetBeans/Apache NetBeans ${NETBEANS_VERSION}.app/" ]; then

    if [ "${FORCE}" -eq 0 ]
    then
        echo "Refusing to overwrite the existing app ${INSTALL_DIR}/NetBeans/Apache NetBeans ${NETBEANS_VERSION}.app."
        echo "Please delete the old app first before trying to create a new one"
        echo "or specify -f|--force as an option to have the script delete it for you."
        exit 1
    else
        echo "Deleting ${INSTALL_DIR}/NetBeans/Apache NetBeans ${NETBEANS_VERSION}.app..."

        read -r -p "Are you sure? [y/N] " response
        case "${response}" in [yY][eE][sS]|[yY])
            ${SUDO_COMMAND}rm -r "${INSTALL_DIR}/NetBeans/Apache NetBeans ${NETBEANS_VERSION}.app/"
            ;;
        *)
            echo "Exiting without creating the app."
            exit 0
            ;;
        esac
    fi
fi

# TODO: There should be a check if we can write to the target folder
# but I have no idea how to do that at the moment ;)

${SUDO_COMMAND}mkdir -p "${INSTALL_DIR}/NetBeans/Apache NetBeans ${NETBEANS_VERSION}.app/Contents/MacOS"
${SUDO_COMMAND}mkdir -p "${INSTALL_DIR}/NetBeans/Apache NetBeans ${NETBEANS_VERSION}.app/Contents/Resources"

# while you can use " | sudo tee" to write to a file as a superuser,
# the easier method is to just create a temporary file and 
# move it using sudo (this also avoids the content being printed on stdout)

TMPFILE=`mktemp`

cat >> "${TMPFILE}" << EOT
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
    <string>NetBeans ${NETBEANS_VERSION}</string>

    <key>CFBundleVersion</key>
    <string>${NETBEANS_VERSION}</string>

    <key>CFBundleExecutable</key>
    <string>netbeans</string>

    <key>CFBundlePackageType</key>
    <string>APPL</string>

    <key>CFBundleShortVersionString</key>
    <string>${NETBEANS_VERSION}</string>

    <key>CFBundleIdentifier</key>
    <string>org.netbeans.ide.baseide.${NETBEANS_VERSION}</string>

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

${SUDO_COMMAND}mv "${TMPFILE}" \
                  "${INSTALL_DIR}/NetBeans/Apache NetBeans ${NETBEANS_VERSION}.app/Contents/Info.plist"

# don't use temp.zip, but a file created with mktmp
TMPFILE=`mktemp`

echo "Downloading ${NETBEANS_URI}..."
curl ${PROGRESSBAR} -o "${TMPFILE}" "${NETBEANS_URI}"

# if $NETBEANS_SHA512_URI is set, verify the integrity
if [ ! -z "${NETBEANS_SHA512_URI}" ]; then
    EXPECTED_SHA512=`curl -fsSL "${NETBEANS_SHA512_URI}" |cut -d " " -f 1`
    REAL_SHA512=`shasum -a 512 "${TMPFILE}" |cut -d " " -f 1`
    echo "Expected SHA512 checksum: ${EXPECTED_SHA512}"
    echo "File SHA512 checksum:     ${REAL_SHA512}"

    if [ "${EXPECTED_SHA512}" != "${REAL_SHA512}" ]; then
        echo "Cleaning up..."
        rm "${TMPFILE}"
        echo "Checksum mismatch (using URI below)! Exiting."
        echo "$NETBEANS_SHA512_URI"
        exit
    fi
fi

echo "Unpacking Netbeans archive..."
${SUDO_COMMAND}unzip ${QUIETUNZIP} "${TMPFILE}" -d "${INSTALL_DIR}/NetBeans/Apache NetBeans ${NETBEANS_VERSION}.app/Contents/Resources/"

echo "Finishing touches on NetBeans ${NETBEANS_VERSION}.app..."
${SUDO_COMMAND}mv "${INSTALL_DIR}/NetBeans/Apache NetBeans ${NETBEANS_VERSION}.app/Contents/Resources/netbeans" \
                  "${INSTALL_DIR}/NetBeans/Apache NetBeans ${NETBEANS_VERSION}.app/Contents/Resources/NetBeans"

cd "${INSTALL_DIR}/NetBeans/Apache NetBeans ${NETBEANS_VERSION}.app/Contents/MacOS"
${SUDO_COMMAND}ln -s ../Resources/NetBeans/bin/netbeans
cd
${SUDO_COMMAND}cp "${INSTALL_DIR}/NetBeans/Apache NetBeans ${NETBEANS_VERSION}.app/Contents/Resources/NetBeans/nb/netbeans.icns" \
                  "${INSTALL_DIR}/NetBeans/Apache NetBeans ${NETBEANS_VERSION}.app/Contents/Resources/"

echo "Cleaning up..."
rm "${TMPFILE}"

if ! $(/usr/libexec/java_home &> /dev/null); then
    echo "Please note that you need to install java to run Netbeans."
fi

echo "All done."
