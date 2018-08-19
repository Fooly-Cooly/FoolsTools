Text := "SAPI voice test text"

voiceObj := ComObjCreate("SAPI.SpVoice")
voiceObj.Speak(Text)
voiceObj.Volume := 50
voiceObj.Speak(Text)
voiceObj.Volume := 100
voiceObj.Rate := 5
voiceObj.Speak(Text)

XML TTS Tutorial (SAPI 5.3)

Text = 
(Join`r`n
	<rate absspeed="5">
		This text should be spoken at rate five.
		<rate absspeed="-5">
			This text should be spoken at rate negative five.
		</rate>
	</rate>
)
ComObjCreate("SAPI.SpVoice").Speak(Text)