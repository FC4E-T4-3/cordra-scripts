# cordra-scripts

This repository contains a few small shellscripts to quickly and easily populate any running cordra instance. Download from https://www.cordra.org/download.html and run, either directly or via docker.

In the ```env.config``` file set the domain to reach the cordra instance, as well as the username and password of a user with admin access.

The folder ```schemas``` should contain the json files of all the schemas that should be imported. Some basic schemas that are currently under discussion are already provided. The folder ```instances``` should contain for each desired type a json list of instances of that type. An example is also included. Note that even when there is only one instance it must be in a list. The names of the files have to correspond to the desired types, i.e. a list of users in the folder ```instances``` should be named ```User.json```, since that is the reference to the corresponding schema.

Three scripts are provided, but they can also serve as a foundation for further more complex tasks. The ```populate.sh``` script simply iterates all schemas and instances in both folders and imports them into the cordra instance. Both ```importInstances.sh``` and ```importSchema.sh``` import one schema or one list of instances respectively. They must be executed with a commandline argument, corresponding to the desired json file. 
