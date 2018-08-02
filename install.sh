#!/bin/bash

NETBEANS_VERSION=${NETBEANS_VERSION:-9}
NETBEANS_URI=${NETBEANS_URI:-http://apache.mirrors.pair.com/incubator/netbeans/incubating-netbeans-java/incubating-9.0/incubating-netbeans-java-9.0-bin.zip}

curl $NETBEANS_URI > temp.zip
mkdir -p "/Applications/NetBeans/NetBeans $NETBEANS_VERSION.app/Contents/MacOS"
mkdir -p "/Applications/NetBeans/NetBeans $NETBEANS_VERSION.app/Contents/Resources"
sed "s/NETBEANS_VERSION/$NETBEANS_VERSION/g" Info.plist > "/Applications/NetBeans/NetBeans $NETBEANS_VERSION.app/Contents/Info.plist"
unzip temp.zip -d "/Applications/NetBeans/NetBeans $NETBEANS_VERSION.app/Contents/Resources/"
mv "/Applications/NetBeans/NetBeans $NETBEANS_VERSION.app/Contents/Resources/netbeans" "/Applications/NetBeans/NetBeans $NETBEANS_VERSION.app/Contents/Resources/NetBeans"
rm temp.zip
ln -s "/Applications/NetBeans/NetBeans $NETBEANS_VERSION.app/Contents/Resources/NetBeans/bin/netbeans" "/Applications/NetBeans/NetBeans $NETBEANS_VERSION.app/Contents/MacOS/netbeans"
cp "/Applications/NetBeans/NetBeans $NETBEANS_VERSION.app/Contents/Resources/NetBeans/nb/netbeans.icns" "/Applications/NetBeans/NetBeans $NETBEANS_VERSION.app/Contents/Resources/"