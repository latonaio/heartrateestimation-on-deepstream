# heartrateestimation-on-deepstream
heartrateestimation-on-deepstream は、DeepStream 上で HeartRateEstimation の AIモデル を動作させるマイクロサービスです。  

## 動作環境
- NVIDIA 
    - DeepStream
- HeartRateEstimation
- Docker
- TensorRT Runtime

## HeartRateEstimationについて
HeartRateEstimation は、画像内の顔を検出し、心拍数を返すAIモデルです。
HeartRateEstimation は、特徴抽出にConvolutional Attention Networksを使用しています。

## 動作手順
### Dockerコンテナの起動
Makefile に記載された以下のコマンドにより、HeartRateEstimation の Dockerコンテナ を起動します。
```
docker-run: ## docker container の立ち上げ
	docker-compose up -d
```

### ストリーミングの開始
Makefile に記載された以下のコマンドにより、DeepStream 上の HeartRateEstimation でストリーミングを開始します。  
```
stream-start: ## ストリーミングを開始する
	xhost +
	docker exec -it heartrate-camera cp /app/mnt/deepstream-heartrate-app /app/src/deepstream_tao_apps/apps/tao_others/deepstream-heartrate-app/
	docker exec -it heartrate-camera cp /app/mnt/heartrate.engine /app/src/deepstream_tao_apps/models/heartrate/heartrate.etlt_b16_gpu0_fp16.engine
	docker exec -it heartrate-camera cp /app/mnt/facedetect.engine /app/src/deepstream_tao_apps/models/faciallandmark/facenet.etlt_b1_gpu0_fp16.engine
	docker exec -it heartrate-camera cp /app/mnt/config_infer_primary_facedetect.txt /app/src/deepstream_tao_apps/configs/facial_tao/config_infer_primary_facenet.txt
	docker exec -it -w /app/src/deepstream_tao_apps/apps/tao_others/deepstream-heartrate-app heartrate-camera ./deepstream-heartrate-app 3 /dev/video0 heeartrate
```

## 相互依存関係にあるマイクロサービス  
本マイクロサービスを実行するために HeartRateEstimation の AIモデルを最適化する手順は、[heartrateestimation-on-tao-toolkit](https://github.com/latonaio/heartrateestimation-on-tao-toolkit)を参照してください。  

## engineファイルについて
engineファイルである heartrate.engine は、[heartrateestimation-on-tao-toolkit](https://github.com/latonaio/heartrateestimation-on-tao-toolkit)と共通のファイルであり、当該レポジトリで作成した engineファイルを、本リポジトリで使用しています。  

## 演算について
本レポジトリでは、ニューラルネットワークのモデルにおいて、エッジコンピューティング環境での演算スループット効率を高めるため、FP16(半精度浮動小数点)を使用しています。  
浮動小数点値の変更は、Makefileの以下の部分を変更し、engineファイルを生成してください。
