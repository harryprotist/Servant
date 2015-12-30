Servant
--------------

Servant is the name that I've given to a collection of scripts and agents
that I'm working on. They are meant to run on a VPS, and communicate with me
through Jabber, Email (planned), and SMS (planned).

Commands in the `passive` directory run in the background.  Commands in the
`active` directory run in the foreground, and are usually invoked by the
passive scripts. Most of the scripts are written in ruby, but they are
connected through the shell using stdout so any language can be used.

Directories containing possibly sensitive information will have
`.skel` files, outlining how to set them up.

## Directories

- `passive` - Background scripts
- `active` - Scripts invoked by `passive`
- `auth` - Authorization for different services
- `conf` - Data meant to be changed by user
- `data` - Data created and used by programs
- `log` - Script logs

## Functions right now

- `passive/xmpp.rb` - listens for xmpp messages and responds using `active/parse.rb`
- `active/parse.rb` - takes message as input and outputs response
- `active/update.rb` - outputs a link to any files in `conf/update.yml` that have been updated
- `active/email.rb` - _in progress_ generates an email with news and other information
