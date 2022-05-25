:# Self-Documented Makefile
# https://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

docker-build: ## docker image の作成
	docker-compose build

docker-run: ## docker container の立ち上げ
	docker-compose up -d

docker-login: ## docker container にログイン
	docker exec -it heartrate-camera bash

stream-start: ## ストリーミングを開始する
	xhost +
	docker exec -it heartrate-camera cp /app/mnt/deepstream-heartrate-app /app/src/deepstream_tao_apps/apps/tao_others/deepstream-heartrate-app/
	docker exec -it heartrate-camera cp /app/mnt/heartrate.engine /app/src/deepstream_tao_apps/models/heartrate/heartrate.etlt_b16_gpu0_fp16.engine
	docker exec -it heartrate-camera cp /app/mnt/facedetect.engine /app/src/deepstream_tao_apps/models/faciallandmark/facenet.etlt_b1_gpu0_fp16.engine
	docker exec -it heartrate-camera cp /app/mnt/config_infer_primary_facedetect.txt /app/src/deepstream_tao_apps/configs/facial_tao/config_infer_primary_facenet.txt
	docker exec -it heartrate-camera cp /app/mnt/libnvds_heartrateinfer.so /app/src/deepstream_tao_apps/apps/tao_others/deepstream-heartrate-app/heartrateinfer_impl/
	docker exec -it -w /app/src/deepstream_tao_apps/apps/tao_others/deepstream-heartrate-app heartrate-camera ./deepstream-heartrate-app 1 /dev/video0 heeartrate
	
