# Zikula/Distribution

A basic distribution of Zikula with no third party modules

----

Files that are copied from zikula/core repo (via github action)
 - config/*
   - not dynamic/generated.yaml
   - not packages/dev or packages/test
   - not routes/dev
   - not services_custom.yaml
   - not routes_dev.yaml
 - src/Kernel.php
 - public/index.php
 - .env

should we copy?
 - public/favicon.ico
 - public/robots.txt (I think no)
 - public/uploads/.htaccess (I think no - directory gets auto-created)
 - translations/ (guessing this should be generated in a build process)
