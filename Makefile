# RocketMQ Exporter Makefile

# 项目信息
COMPONENT=rocketmq
DOCKER_IMAGE=registry-svc:25000/library/rocketmq-exporter
DOCKER_TAG=latest

# 构建目录
BUILD_DIR=./weops/pipe-tools/docker
BIN_DIR=./weops/pipe-tools/bin

# Go 环境配置
GOPROXY=https://goproxy.cn,direct
GOSUMDB=sum.golang.google.cn
CGO_ENABLED=0

# 获取版本信息
GIT_TAG := $(shell git describe --tags --exact-match 2>/dev/null)
ifdef GIT_TAG
    VERSION := $(GIT_TAG)
else
    VERSION := $(shell git describe --tags --always --dirty 2>/dev/null || echo "v0.1.0")
endif

BRANCH := $(shell git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "unknown")
REVISION := $(shell git rev-parse --short HEAD 2>/dev/null || echo "unknown")
BUILD_USER := $(shell whoami)
BUILD_DATE := $(shell date -u '+%Y-%m-%d %H:%M:%S UTC')

# Go 构建参数
LDFLAGS := -X github.com/prometheus/common/version.Version=$(VERSION) \
           -X github.com/prometheus/common/version.Branch=$(BRANCH) \
           -X github.com/prometheus/common/version.Revision=$(REVISION) \
           -X github.com/prometheus/common/version.BuildUser=$(BUILD_USER) \
           -X 'github.com/prometheus/common/version.BuildDate=$(BUILD_DATE)'

# 默认目标
.PHONY: all
all: build

# 构建所有二进制文件
.PHONY: build
build: build-linux-amd64 build-linux-arm64 build-windows-amd64
	@echo "All binaries built successfully"
	@chmod a+x $(BIN_DIR)/$(COMPONENT)_exporter_linux_amd64 $(BIN_DIR)/$(COMPONENT)_exporter_linux_arm64 $(BIN_DIR)/$(COMPONENT)_exporter_windows_amd64.exe

# 构建 Linux AMD64 二进制
.PHONY: build-linux-amd64
build-linux-amd64:
	@echo "Building $(COMPONENT)_exporter_linux_amd64..."
	@mkdir -p $(BIN_DIR)
	CGO_ENABLED=$(CGO_ENABLED) GOPROXY=$(GOPROXY) GOSUMDB=$(GOSUMDB) GOOS=linux GOARCH=amd64 go build -ldflags "$(LDFLAGS)" -o $(BIN_DIR)/$(COMPONENT)_exporter_linux_amd64 main.go

# 构建 Linux ARM64 二进制
.PHONY: build-linux-arm64
build-linux-arm64:
	@echo "Building $(COMPONENT)_exporter_linux_arm64..."
	@mkdir -p $(BIN_DIR)
	CGO_ENABLED=$(CGO_ENABLED) GOPROXY=$(GOPROXY) GOSUMDB=$(GOSUMDB) GOOS=linux GOARCH=arm64 go build -ldflags "$(LDFLAGS)" -o $(BIN_DIR)/$(COMPONENT)_exporter_linux_arm64 main.go

# 构建 Windows AMD64 二进制
.PHONY: build-windows-amd64
build-windows-amd64:
	@echo "Building $(COMPONENT)_exporter_windows_amd64.exe..."
	@mkdir -p $(BIN_DIR)
	CGO_ENABLED=$(CGO_ENABLED) GOPROXY=$(GOPROXY) GOSUMDB=$(GOSUMDB) GOOS=windows GOARCH=amd64 go build -ldflags "$(LDFLAGS)" -o $(BIN_DIR)/$(COMPONENT)_exporter_windows_amd64.exe main.go

# 构建 Docker 镜像用的 Linux AMD64 二进制
.PHONY: build-docker-binary
build-docker-binary:
	@echo "Building binary for Docker image..."
	@mkdir -p $(BUILD_DIR)
	CGO_ENABLED=$(CGO_ENABLED) GOPROXY=$(GOPROXY) GOSUMDB=$(GOSUMDB) GOOS=linux GOARCH=amd64 go build -ldflags "$(LDFLAGS)" -o $(BUILD_DIR)/rocketmq_exporter-linux-amd64 main.go

# 构建 Docker 镜像
.PHONY: build-image
build-image: build-docker-binary
	@echo "Building Docker image..."
	cd $(BUILD_DIR) && docker build -f Dockerfile -t $(DOCKER_IMAGE):$(DOCKER_TAG) .
	@echo "Docker image built: $(DOCKER_IMAGE):$(DOCKER_TAG)"

# 清理构建产物
.PHONY: clean
clean:
	@echo "Cleaning build artifacts..."
	rm -f $(BIN_DIR)/$(COMPONENT)_exporter_linux_amd64
	rm -f $(BIN_DIR)/$(COMPONENT)_exporter_linux_arm64
	rm -f $(BIN_DIR)/$(COMPONENT)_exporter_windows_amd64.exe
	rm -f $(BUILD_DIR)/rocketmq_exporter-linux-amd64
	@echo "Clean completed"

# 显示构建信息
.PHONY: info
info:
	@echo "Building $(COMPONENT) exporter with:"
	@echo "  Version:      $(VERSION)"
	@echo "  Branch:       $(BRANCH)"
	@echo "  Revision:     $(REVISION)"
	@echo "  Build User:   $(BUILD_USER)"
	@echo "  Build Date:   $(BUILD_DATE)"
	@echo "  Output Dir:   $(BIN_DIR)"
	@echo "  GOPROXY:      $(GOPROXY)"
	@echo "  CGO_ENABLED:  $(CGO_ENABLED)"

# 帮助信息
.PHONY: help
help:
	@echo "Available targets:"
	@echo "  build             - Build all binaries (Linux AMD64/ARM64, Windows AMD64)"
	@echo "  build-linux-amd64 - Build Linux AMD64 binary"
	@echo "  build-linux-arm64 - Build Linux ARM64 binary"
	@echo "  build-windows-amd64 - Build Windows AMD64 binary"
	@echo "  build-image       - Build Docker image (Linux AMD64)"
	@echo "  clean             - Clean build artifacts"
	@echo "  info              - Show build information"
	@echo "  help              - Show this help"
	@echo ""
	@echo "Output directory: $(BIN_DIR)"
	@echo "GOPROXY: $(GOPROXY)"
	@echo "CGO_ENABLED: $(CGO_ENABLED)"
