Based on [Parse-Migrator](https://github.com/JohnMorales/parse-migrator) and [Parse-DB-Import](https://github.com/JohnMorales/parse-db-import).
Originally was taken from https://github.com/ParsePlatform/parse-server/issues/20#issuecomment-183480340.

# Pre-Requirements

```shell
sudo apt-get install python python-pip
sudo pip install python-dateutil
gem install bundler
bundle install
```

# Usage

```shell
./migrate.sh path/to/parse-export.zip db-name [optional-arguments]

Optional arguments:
  --dbuser user          default to current account
  --dbpassword password  default to current account
  --host host            default to localhost
```
