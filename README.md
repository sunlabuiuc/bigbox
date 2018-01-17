# BigBox

Yet another integrated envoronment.

Please refere to [http://sunlab.org/teaching/cse6250/spring2018/lab/env-local-docker/](http://sunlab.org/teaching/cse6250/spring2018/lab/env-local-docker/) for detail.

```
docker run -it --privileged=true \
  --cap-add=SYS_ADMIN \
  -m 8192m -h bootcamp1.docker \
  --name bigbox -p 2222:22 -p 9530:9530 -p 8888:8888\
  sunlab/bigbox:latest \
  /bin/bash
```

