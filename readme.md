Hi again!

https://i.imgur.com/ZLSueai.png

#### Was is das?
Das is a program to run `.au3` files from anywhere. Just like `php` can run php files anywhere. *(If you have them installed via XAMPP or similar packages)*

#### Why?

For convenience sake, this allows you expand the possibilites when creating `Autoit-Art` just like `php` allows `composer` to autoload your dependencies.

#### What happends when if I run the file?

1. The script compiles itself to `%appdata%\au3\au3.exe`
2. Adds `%appdata%\au3` to the windows `PATH` envoirment variable
3. Refreshes Windows envoirment variables (Its like logging in and out)


### How to install
1. Download and run `au3.au3` from anywhere.
2. Restart any open CMD instance (That includes built-in ones like **Scite** and other IDE's)
3. Done

### Scripts (For "Advanced users")
Scripts can be used to make aliases for any command(s) you wish to run often

Scripts are looked for in `au3.ini` under the section `[scripts]`. Each key represents the `<Script name>` and each value represents the command(s) to be ran. You can run multiple commands by separating them with the pipe-char `|`

#### Example
 **au3.ini**
```
[scripts]
my-script=ping google.se|au3 run my-script
my-second-script=ping yahoo.co.uk
```
When running `au3 run my-script` the script will first `ping google.se` and then start a second script `my-second-script` which will run `ping yahoo.co.uk`.