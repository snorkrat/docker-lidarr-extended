FROM linuxserver/lidarr:amd64-nightly
LABEL maintainer="RandomNinjaAtk"

ENV dockerTitle="lidarr-extended"
ENV dockerVersion="1.0.0013"
ENV LANG=en_US.UTF-8
ENV autoStart=true
ENV configureLidarrWithOptimalSettings=false
ENV audioFormat=native
ENV audioBitrate=lossless
ENV audioLyricType=both
ENV addDeezerTopArtists=false
ENV addDeezerTopAlbumArtists=false
ENV addDeezerTopTrackArtists=false
ENV topLimit=10
ENV addRelatedArtists=false
ENV tidalCountryCode=US
ENV numberOfRelatedArtistsToAddPerArtist=5

RUN \
	echo "************ install packages ************" && \
	apk add  -U --update --no-cache \
		musl-locales \
		musl-locales-lang \
		flac \
		beets \
		jq \
		git \
		gcc \
		ffmpeg \
		python3-dev \
		libc-dev \
		gpgme-dev \
		py3-pip \
		yt-dlp && \
	echo "************ install python packages ************" && \
	pip install \
		yq \
		r128gain \
		pyacoustid \
		deemix && \
	echo "************ install tidal-dl ************" && \
	mkdir -p /Tidal-Media-Downloader && \
	mkdir -p /config/xdg && \
	git clone https://github.com/yaronzz/Tidal-Media-Downloader.git /Tidal-Media-Downloader && \
	cd /Tidal-Media-Downloader/TIDALDL-PY && \
	pip install -r requirements.txt && \
	python3 setup.py install && \
	rm -rf /config/xdg

# copy local files
COPY root/ /

WORKDIR /config

# ports and volumes
EXPOSE 8686
VOLUME /config /music /music-videos /downloads
