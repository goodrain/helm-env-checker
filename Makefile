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