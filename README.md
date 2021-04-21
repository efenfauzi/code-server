# code-server
containerize from [visual code server](https://github.com/cdr/code-server) with some costumize tools and settings.

This project deploy and running with orcinus tools.

Thanks credits to: https://github.com/orcinustools

1. build image from Dockefile: `docker build -t code-server:dev .`
2. install orcinus tools: [link reference](https://github.com/orcinustools/orcinus)
3. File to change :
  - change password on `config.yaml` as you like
  - change project dir mount host to container on `orcinus.yml`  
4. run and deploy with command  `orcinus create` on project dir   
