# NetBeans macOS Bundle

When I originally put this little project together it was intended to be a tempoary quick way to get NetBeans installed on a Mac.  I did not anticipate the amount of feedback I have received (which is very much appreciated) and that has caused me to make a few changes along the way.

Java should be installed before running either the installation script.

Thank you to Geertjan Wielenga for putting this [video](https://www.youtube.com/watch?v=I8gdC7BBtbs) together.  He has, to me, been a very positive face to NetBeans and the Java community for a long time.


First off, you should either clone or download this project if you want to use the original install script.

To run it, use the install.sh script.  The user is prompted for the password because the script includes "sudo's" to gain permission to the /Applications folder.

```
./install.sh
```

There are two environment variables that may be set to change the defaults before running.
For example:

```
export NETBEANS_VERSION=13
export NETBEANS_URI=http://apache.osuosl.org/incubator/netbeans/incubating-netbeans/incubating-10.0/incubating-netbeans-10.0-bin.zip
./install.sh
```

Based on some feedback, some folks prefer not to install applications in the /Applications folder and others would prefer not to "sudo" to install an application.  Still others prefer not to download the entire project.  I don't think folks were concerned about the size, they just wanted a way to download a single script instead of doing a git clone or an unzip after a download.

Therefore the following options are provided:

* install in the directory of your choosing: -d | --install-dir /Installation/directory
* install NetBeans version of your choosing: -v | --netbeans-version <version>
* install NetBeans from an alternate URI: -u | --netbeans-uri <URI> 
* display extra information: --verbose
* remove existing package before install: -f | --force
* install without sudo: -n | --non-root-install
* show help -h | --help

Tip: You can use `file:///filename.zip` to specify local file as a parameter for -u | --netbeans-uri.

For example:

```
./install.sh --non-root-install --install-dir ~/Applications
```

The fast way is paste this at a Terminal prompt.

```
bash -c "$(curl -fsSL https://raw.githubusercontent.com/carljmosca/netbeans-macos-bundle/master/install.sh)"
```

Happy coding
