IMG = helm-env-checker
REGISTRY = registry.cn-hangzhou.aliyuncs.com/goodrain
TAG = latest


# build and push helm-env-checker image
all: build push

# building...
build:
	docker build -t ${REGISTRY}/${IMG}:${TAG} .

# push...
push:
	docker push ${REGISTRY}/${IMG}:${TAG}

# arm64 building...

buildarm64:
	docker build -t ${REGISTRY}/${IMG}:${TAG}-arm64 .
	docker push ${REGISTRY}/${IMG}:${TAG}-arm64
	docker manifest create ${REGISTRY}/${IMG}:${TAG} ${REGISTRY}/${IMG}:${TAG} ${REGISTRY}/${IMG}:${TAG}-arm64
	docker manifest annotate ${REGISTRY}/${IMG}:${TAG} ${REGISTRY}/${IMG}:${TAG} --os linux --arch amd64
	docker manifest annotate ${REGISTRY}/${IMG}:${TAG} ${REGISTRY}/${IMG}:${TAG}-arm64 --os linux --arch arm64 --variant v8
	docker manifest push ${REGISTRY}/${IMG}:${TAG}
	docker manifest rm ${REGISTRY}/${IMG}:${TAG}