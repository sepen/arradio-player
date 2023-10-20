package main

import (
	os "os"
	time "time"

	oto "github.com/ebitengine/oto/v3"
	mp3 "github.com/hajimehoshi/go-mp3"

	shoutcast "github.com/romantomjak/shoutcast"
)

func main() {

	streamUrl := ""
	if len(os.Args) > 1 {
		streamUrl = os.Args[1]
	} else {
		panic("Usage: arradio-player [streamUrl]")
	}

	// Open the stream for reading. Do NOT close before you finish playing!
	stream, err := shoutcast.Open(streamUrl)
	if err != nil {
		panic("Reading stream failed: " + err.Error())
	}

	// Register a callback function to be called when song changes
	stream.MetadataCallbackFunc = func(m *shoutcast.Metadata) {
		println("** Playing", m.StreamTitle)
	}

	// Decode file. This process is done as the file plays so it won't
	// load the whole thing into memory.
	decodedMp3, err := mp3.NewDecoder(stream)
	if err != nil {
		panic("Decoding stream failed: " + err.Error())
	}

	// Prepare an Oto context (this will use your default audio device) that will
	// play all our sounds. Its configuration can't be changed later.
	op := &oto.NewContextOptions{}

	// SampleRate specifies the number of samples that should be played during one second.
	// Usual numbers are 44100 or 48000. One context has only one sample rate. You cannot play multiple audio
	// sources with different sample rates at the same time.
	//SampleRate int
	op.SampleRate = 44100

	// ChannelCount specifies the number of channels. One channel is mono playback. Two
	// channels are stereo playback. No other values are supported.
	//ChannelCount int
	op.ChannelCount = 2

	// Format specifies the format of sources.
	//Format Format
	// Format of the source. go-mp3's format is signed 16bit integers.
	op.Format = oto.FormatSignedInt16LE

	// BufferSize specifies a buffer size in the underlying device.
	// If 0 is specified, the driver's default buffer size is used.
	// Set BufferSize to adjust the buffer size if you want to adjust latency or reduce noises.
	// Too big buffer size can increase the latency time.
	// On the other hand, too small buffer size can cause glitch noises due to buffer shortage.
	//BufferSize time.Duration
	op.BufferSize = 0

	// Remember that you should **not** create more than one context
	otoCtx, readyChan, err := oto.NewContext(op)
	if err != nil {
		panic("oto.NewContext failed: " + err.Error())
	}
	// It might take a bit for the hardware audio devices to be ready, so we wait on the channel.
	<-readyChan

	// Create a new 'player' that will handle our sound. Paused by default.
	player := otoCtx.NewPlayer(decodedMp3)

	// Play starts playing the sound and returns without waiting for it (Play() is async).
	player.Play()

	// We can wait for the sound to finish playing using something like this
	for player.IsPlaying() {
		time.Sleep(time.Millisecond)
	}

	// Close file only after you finish playing
	stream.Close()

	// If you don't want the player/sound anymore simply close
	err = player.Close()
	if err != nil {
		panic("player.Close failed: " + err.Error())
	}

}
