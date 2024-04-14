# `arradio-player`

Play internet audio streams on your macOS or Linux terminal

![Last Commit](https://img.shields.io/github/last-commit/sepen/arradio-player)
![Repo Size](https://img.shields.io/github/repo-size/sepen/arradio-player)
![Code Size](https://img.shields.io/github/languages/code-size/sepen/arradio-player)
![Written in Go](https://img.shields.io/badge/written%20in-go-ff69b4)

`arradio-player` is a command line player initially designed as part of the [arradio](https://github.com/sepen/arradio) project.

## Installation

Check out the [Github Releases](https://github.com/sepen/arradio-player/releases) page for release info or to install a specific version.

## Usage

Locate a radio station a get a valid stream url. For example DefCon256 by SomaFM
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

Run `arradio-player` from a stream url from above results
```
$ arradio-player https://ice2.somafm.com/defcon-256-mp3
2024/04/13 02:04:07 [INFO] Opening https://ice2.somafm.com/defcon-256-mp3
2024/04/13 02:04:09 [DEBUG] HTTP header Content-Type: audio/mpeg
2024/04/13 02:04:09 [DEBUG] HTTP header Icy-Name: DEF CON Radio: SomaFM's year-round channel for DEF CON [SomaFM]
2024/04/13 02:04:09 [DEBUG] HTTP header Icy-Pub: 0
2024/04/13 02:04:09 [DEBUG] HTTP header Access-Control-Allow-Origin: *
2024/04/13 02:04:09 [DEBUG] HTTP header Access-Control-Allow-Headers: Origin, Accept, X-Requested-With, Content-Type, Icy-MetaData
2024/04/13 02:04:09 [DEBUG] HTTP header Date: Sat, 13 Apr 2024 00:04:09 GMT
2024/04/13 02:04:09 [DEBUG] HTTP header Cache-Control: no-cache, no-store
2024/04/13 02:04:09 [DEBUG] HTTP header Expires: Mon, 26 Jul 1997 05:00:00 GMT
2024/04/13 02:04:09 [DEBUG] HTTP header Icy-Metaint: 16000
2024/04/13 02:04:09 [DEBUG] HTTP header Access-Control-Allow-Methods: GET, OPTIONS, SOURCE, PUT, HEAD, STATS
2024/04/13 02:04:09 [DEBUG] HTTP header Icy-Br: 256
2024/04/13 02:04:09 [DEBUG] HTTP header Icy-Genre: Electronic Hacking
2024/04/13 02:04:09 [DEBUG] HTTP header Icy-Notice1: <BR>This stream requires <a href="http://www.winamp.com/">Winamp</a><BR>
2024/04/13 02:04:09 [DEBUG] HTTP header Icy-Notice2: SHOUTcast Distributed Network Audio Server/Linux v1.9.5<BR>
2024/04/13 02:04:09 [DEBUG] HTTP header Icy-Url: https://somafm.com/defcon
2024/04/13 02:04:09 [DEBUG] HTTP header Server: Icecast 2.4.0-kh15
2024/04/13 02:04:09 [DEBUG] HTTP header Connection: Close
2024/04/13 02:04:09 [DEBUG] Received metadata: [StreamTitle='Ganja Beats - Space Is High' StreamUrl='http://somafm.com/logos/logos/512/defcon512.jpg' ]
** Playing Ganja Beats - Space Is High
```
