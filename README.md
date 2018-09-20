# NetBeans MacOS Bundle

When I originally put this little project together it was intended to be a tempoary quick way to get NetBeans installed on a Mac.  I did not anticipate the amount of feedback I have received (which is very much appreciated) and that has caused me to make a few changes along the way.

The fast way is paste this at a Terminal prompt.

```
sh -c "$(curl -fsSL https://raw.githubusercontent.com/carljmosca/netbeans-macos-bundle/master/install-custom.sh)"
```

## Download script

First off, you should either clone or download this project if you want to use the original install script.

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

Based on some feedback, some folks prefer not to install applications in the /Applications folder and others would prefer not to "sudo" to install an application.  Still others prefer not to download the entire project.  I don't think folks were concerned about the size, they just wanted a way to download a single script instead of doing a git clone or an unzip after a download.

After [downloading the custom script](https://github.com/carljmosca/netbeans-macos-bundle/blob/master/install-custom.sh), the following options are provided:

* install in the directory of your choosing: --install-dir /Installation/directory
* install from an alternate URI or local file --netbeans-uri http://some.apache.netbeans.mirror or file:///netbeans
* install without sudo --non-root-install

For example:

```
./install-custom.sh --non-root-install --install-dir ~/Applications
```

Happy coding
