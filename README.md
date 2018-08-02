# NetBeans MacOS Bundle

This project is a quick-and-dirty method to "install" NetBeans 9.x on a Mac.  Currently, to my knowledge, the NetBeans sources and binaries can be downloaded but I have not happened across an installation method for Macs.

I have been running it from the command line during the release candidate period but after putting it into the /Applications folder manually, I though a script might be nice.

To run it, use the install.sh script.  The user is prompted for the password because the script includes "sudo's" to gain permission to the /Applications folder.

```
./install.sh
```

There are two environment variables that may be set to change the defaults before running.
For example:

```
export NETBEANS_VERSION=9.0
export NETBEANS_URI=http://some.mirror.com/incubating-netbeans-java-9.0-bin.zip
./install.sh
```