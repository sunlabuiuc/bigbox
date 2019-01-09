# BigBox

Yet another integrated envoronment.

Please see <http://sunlab.org/teaching/cse6250/spring2019/env/env-local-docker.html> for detail instruction.

```
docker run -it -m 8192m -h bootcamp.local \
  --name bigbox -p 2222:22 -p 9530:9530 -p 8888:8888\
  sunlab/bigbox:latest \
  /bin/bash
```

Related Links:

+ Docker Image: [https://hub.docker.com/r/sunlab/bigbox/](https://hub.docker.com/r/sunlab/bigbox/)
+ FAQs: [https://github.com/sunlabga/bigbox/wiki/FAQ](https://github.com/sunlabga/bigbox/wiki/FAQ)
+ Sample Code: [https://bitbucket.org/realsunlab/bigdata-bootcamp](https://bitbucket.org/realsunlab/bigdata-bootcamp)
+ Scripts: [https://github.com/sunlabga/bigbox-scripts](https://github.com/sunlabga/bigbox-scripts)



