#function sayang
#    set output (tgpt $argv)
#    edge-playback --volume=+50% --voice id-ID-GadisNeural --text "$output"
#end

function rts
    tgpt $argv
end    

function bicara
    edge-playback --volume=+50% --voice id-ID-GadisNeural --text "$argv"
end

function speak
    edge-playback --volume=+50% --voice en-US-JennyNeural --text "$argv"
end

