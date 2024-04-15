# `arradio-player`

Play internet audio streams on your macOS or Linux terminal

![Last Commit](https://img.shields.io/github/last-commit/sepen/arradio-player)
![Repo Size](https://img.shields.io/github/repo-size/sepen/arradio-player)
![Code Size](https://img.shields.io/github/languages/code-size/sepen/arradio-player)
![Written in Go](https://img.shields.io/badge/written%20in-go-ff69b4)

`arradio-player` is a command line player initially designed as part of the [arradio](https://github.com/sepen/arradio) project.

## Installation

Check out the [Github Releases](https://github.com/sepen/arradio-player/releases) page for release info or to install a specific version.

Alternatively you can clone this repository and run `build.sh` to build a new binary.

## Usage

If you have a stream link that you already know you can simply run
```
$ arradio-player [stream_url]
```

For example, to play DanceWave radio station:
```
$ arradio-player 'https://dancewave.online:443/dance.mp3'
2024/04/14 23:57:06 [INFO] Opening https://dancewave.online:443/dance.mp3
2024/04/14 23:57:06 [DEBUG] HTTP header Icy-Main-Stream-Url: https://dancewave.online/dance.mp3
2024/04/14 23:57:06 [DEBUG] HTTP header Icy-Name: Dance Wave!
2024/04/14 23:57:06 [DEBUG] HTTP header Cf-Cache-Status: BYPASS
2024/04/14 23:57:06 [DEBUG] HTTP header Content-Type: audio/mpeg
2024/04/14 23:57:06 [DEBUG] HTTP header X-Robots-Tag: none
2024/04/14 23:57:06 [DEBUG] HTTP header Icy-Br: 128
2024/04/14 23:57:06 [DEBUG] HTTP header Icy-Pub: 0
2024/04/14 23:57:06 [DEBUG] HTTP header Icy-Vbr: 1
2024/04/14 23:57:06 [DEBUG] HTTP header Icy-Metaint: 16384
2024/04/14 23:57:06 [DEBUG] HTTP header Report-To: {"endpoints":[{"url":"https:\/\/a.nel.cloudflare.com\/report\/v4?s=HT9ZmtPEirbMq4tMtwWybvwn9BCWg5EhT0MTlMQGT4iy9vAii%2Fty3lJN%2BcsoIXZdWxPW3nGnJvq4q1GC8VjVv9dL4PVhRGXA%2Be%2BOQD6WiFBK%2FFMzQPFU2TGyZAJvdMCWXFcv2CdhhFepkmZt29cS"}],"group":"cf-nel","max_age":604800}
2024/04/14 23:57:06 [DEBUG] HTTP header Connection: keep-alive
2024/04/14 23:57:06 [DEBUG] HTTP header Icy-Sr: 44100
2024/04/14 23:57:06 [DEBUG] HTTP header Access-Control-Allow-Credentials: *
2024/04/14 23:57:06 [DEBUG] HTTP header X-Powered-By: MSCP Pro (https://mscp.pro)
2024/04/14 23:57:06 [DEBUG] HTTP header Icy-Index-Metadata: 1
2024/04/14 23:57:06 [DEBUG] HTTP header Icy-Logo: https://dancewave.online/dw_logo.png
2024/04/14 23:57:06 [DEBUG] HTTP header Ice-Audio-Info: channels=2;bitrate=128;samplerate=44100
2024/04/14 23:57:06 [DEBUG] HTTP header Icy-Url: https://dancewave.online
2024/04/14 23:57:06 [DEBUG] HTTP header Server: cloudflare
2024/04/14 23:57:06 [DEBUG] HTTP header Alt-Svc: h3=":443"; ma=86400
2024/04/14 23:57:06 [DEBUG] HTTP header Access-Control-Allow-Origin: *
2024/04/14 23:57:06 [DEBUG] HTTP header Nel: {"success_fraction":0,"report_to":"cf-nel","max_age":604800}
2024/04/14 23:57:06 [DEBUG] HTTP header Expires: Thu, 19 Nov 1981 08:52:00 GMT
2024/04/14 23:57:06 [DEBUG] HTTP header Cache-Control: no-store, no-cache, private
2024/04/14 23:57:06 [DEBUG] HTTP header Strict-Transport-Security: max-age=0;
2024/04/14 23:57:06 [DEBUG] HTTP header Icy-Description: All about Dance from 2000 till today!
2024/04/14 23:57:06 [DEBUG] HTTP header Icy-Genre: Club Dance Electronic House Trance
2024/04/14 23:57:06 [DEBUG] HTTP header Date: Sun, 14 Apr 2024 21:57:06 GMT
2024/04/14 23:57:06 [DEBUG] HTTP header Pragma: no-cache
2024/04/14 23:57:06 [DEBUG] HTTP header Vary: Origin, Accept-Encoding
2024/04/14 23:57:06 [DEBUG] HTTP header Access-Control-Allow-Headers: *
2024/04/14 23:57:06 [DEBUG] HTTP header Cf-Ray: 8746f31bce9f1bb7-MAD
2024/04/14 23:57:07 [DEBUG] Received metadata: [StreamTitle='All about Dance from 2000 till today!' ]
>>> All about Dance from 2000 till today!
```

Follow these steps to play radio stations from SomaFM (https://somafm.com):

1. Locate a radio station and use curl to get a valid stream url from a playlist link
```
$ curl https://somafm.com/defcon256.pls
[playlist]
numberofentries=4
File1=https://ice2.somafm.com/defcon-256-mp3
Title1=SomaFM: DEF CON Radio (#1): Music for Hacking. The DEF CON Year-Round Channel.
Length1=-1
File2=https://ice4.somafm.com/defcon-256-mp3
Title2=SomaFM: DEF CON Radio (#2): Music for Hacking. The DEF CON Year-Round Channel.
Length2=-1
File3=https://ice6.somafm.com/defcon-256-mp3
Title3=SomaFM: DEF CON Radio (#3): Music for Hacking. The DEF CON Year-Round Channel.
Length3=-1
File4=https://ice5.somafm.com/defcon-256-mp3
Title4=SomaFM: DEF CON Radio (#4): Music for Hacking. The DEF CON Year-Round Channel.
Length4=-1
Version=2
```

2. Once you have the stream url
```
$ arradio-player https://ice2.somafm.com/defcon-256-mp3
2024/04/14 23:53:51 [INFO] Opening https://ice2.somafm.com/defcon-256-mp3
2024/04/14 23:53:52 [DEBUG] HTTP header Icy-Br: 256
2024/04/14 23:53:52 [DEBUG] HTTP header Icy-Notice1: <BR>This stream requires <a href="http://www.winamp.com/">Winamp</a><BR>
2024/04/14 23:53:52 [DEBUG] HTTP header Icy-Url: https://somafm.com/defcon
2024/04/14 23:53:52 [DEBUG] HTTP header Access-Control-Allow-Origin: *
2024/04/14 23:53:52 [DEBUG] HTTP header Access-Control-Allow-Methods: GET, OPTIONS, SOURCE, PUT, HEAD, STATS
2024/04/14 23:53:52 [DEBUG] HTTP header Icy-Metaint: 16000
2024/04/14 23:53:52 [DEBUG] HTTP header Date: Sun, 14 Apr 2024 21:53:52 GMT
2024/04/14 23:53:52 [DEBUG] HTTP header Icy-Name: DEF CON Radio: SomaFM's year-round channel for DEF CON [SomaFM]
2024/04/14 23:53:52 [DEBUG] HTTP header Server: Icecast 2.4.0-kh15
2024/04/14 23:53:52 [DEBUG] HTTP header Cache-Control: no-cache, no-store
2024/04/14 23:53:52 [DEBUG] HTTP header Icy-Genre: Electronic Hacking
2024/04/14 23:53:52 [DEBUG] HTTP header Icy-Pub: 0
2024/04/14 23:53:52 [DEBUG] HTTP header Expires: Mon, 26 Jul 1997 05:00:00 GMT
2024/04/14 23:53:52 [DEBUG] HTTP header Connection: Close
2024/04/14 23:53:52 [DEBUG] HTTP header Content-Type: audio/mpeg
2024/04/14 23:53:52 [DEBUG] HTTP header Icy-Notice2: SHOUTcast Distributed Network Audio Server/Linux v1.9.5<BR>
2024/04/14 23:53:52 [DEBUG] HTTP header Access-Control-Allow-Headers: Origin, Accept, X-Requested-With, Content-Type, Icy-MetaData
2024/04/14 23:53:53 [DEBUG] Received metadata: [StreamTitle='BistroBoy - Waltz With Me' StreamUrl='http://somafm.com/logos/logos/512/defcon512.jpg' ]
>>> BistroBoy - Waltz With Me
```
