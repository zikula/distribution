# Zikula/Distribution

A basic distribution of Zikula with no third party modules

----

Files that are copied from zikula/core repo (via github action)
 - src/Kernel.php
 - public/*
 - .env
 - config/*
   - dynamic/* except dynamic/generated.yaml
   - packages/* except packages/dev or packages/test
   - routes/* routes/dev
   - workflows/*
   - not routes_dev.yaml

should we copy?
 - translations/ (guessing this should be generated in a build process)
