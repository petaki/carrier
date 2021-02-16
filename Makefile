VERSION := $(if $(RELEASE_VERSION),$(RELEASE_VERSION),"master")

all: pre_clean ui darwin linux windows post_clean

pre_clean:
	rm -rf dist

ui:
	yarn prod
	mkdir dist dist/resources
	cp .env.example dist/.env
	cp -r public dist
	cp -r resources/views dist/resources

darwin:
	GOOS=darwin GOARCH=amd64 go build -o dist/satellite ./cmd/cli
	cd dist && zip -r satellite_$(VERSION)_darwin_amd64.zip public resources .env satellite
	rm -f dist/satellite

linux:
	GOOS=linux GOARCH=amd64 go build -o dist/satellite ./cmd/cli
	cd dist && zip -r satellite_$(VERSION)_linux_amd64.zip public resources .env satellite
	rm -f dist/satellite

windows:
	GOOS=windows GOARCH=amd64 go build -o dist/satellite.exe ./cmd/cli
	cd dist && zip -r satellite_$(VERSION)_windows_amd64.zip public resources .env satellite.exe
	rm -f dist/satellite.exe

post_clean:
	rm -rf dist/public dist/resources dist/.env