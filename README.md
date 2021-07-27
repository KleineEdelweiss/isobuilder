### INFORMATION ###
This is a GNU+Linux 🐧 script or gem 💎 (written in Ruby ⛏️), that can be used to help implement the creation of ISO files from CDs and DVDs 💿, such as to make backups 🗄. I plan to add a bit more to it, but I initially wrote it up in a night 🌙, due to issues with some old game consoles and their disks. Some disks were no longer playable on the console 🎮 (possibly due to the scratches, possibly due to the console's age).

Essentially, this is a program for the preservation of dated optical media. 🦕 📸

Additional functionality will be added, however, to allow more complex ISO creation, perhaps even simplify the creation of bootable Linux ISOs 🕴, ideally -- depends when I have the time to go over it, further (although I intend to make a few near-future tweaks to fix some of the haphazard operations I implemented at like 3 AM). I would _probably_ like to make this into a native extension 🗜, if I take it further, depending on how complex the functionality will be and if the various associated libraries 📚 will be ideal for such.

### DEPENDENCIES ###
Not sure, yet. Will have to see what works, first, but possibly ``mkisofs`` (part of packages that supply ``cdrtools`` or similar) -- however, initial tests proved that does not work for at least some types of CDs/DVDs, so for now, it only uses ``dd`` -- standard on any Linux system.

### TO-DO ###
1) Bring back the (commented out) ``mkisofs`` functionality -- I deleted some confirmations that ensured it didn't crash, when I got a bit impatient 🤦🏻 (after the backups failed to load the content in an emulator) and switched the whole thing to call ``dd``, instead. I don't think this swap was a mistake, but it limited alternative functionality [soon, probably]
2) Find some way to simplify the ``dd`` operation, as the current handling and way to get the system block special device is kinda trash 🗑 [possibly somewhat soon??]
3) Make it work for other disk file systems (currently works with ``udf`` for PS2 games -- so you can at least back those up if your system died or the drive won't read your well-scratched and Cheetos-encrusted game CDs. But I've had issues with ``iso9660`` (PS1)) [hopefully soon?????]

### USAGE ###
As of this **EARLY** version (2021-Jul-27), it's strictly a command-line app. You use it like this:
```sh
ruby [/path/to/lib/isobuilder.rb] [/path/to/mounted_cd or /dev/whatever_your_cd_drive_is]
```
ex:
```sh
# In .bashrc
alias isobuilder="ruby /home/[username]/scripts/isobuilder/lib/isobuilder.rb"

# In your terminal
build-iso /dev/sr0 # Where sr0 or similar is often the optical drive device

# Or, if mounted
build-iso '/run/media/username/Some Old Game That Barely Works (2003) v1.3.37'
```

### NOTES ###
1) ***Please ensure you read the prompts! ESPECIALLY if you are using the mounted directory, instead of the block device -- Ruby will stat the folder and read in the device it is located on, and then compare the path with the mount point, but check the size in the ``::INFO::`` outputs, as it tells you the size to be copied -- careful not to copy a whole hard drive or something (unless that is your intent, I guess 🤷🏻)***

### DISCLAIMER ###
I am *not* intending to promote the use of this for any forms of copyright infringement. I made it to back up some of my legally-purchased media that was either too damaged to run in the normal systems, or that is otherwise only playable on systems that are starting to fail (and, subsequently, emulators of such). Especially when such games are *no longer even available for sale*.

I am not responsible for how you use this, and it is not even _exclusively_ usable for backing up games, necessarily -- in fact, it _intends_ to **eventually** be useful for _more_ than that.