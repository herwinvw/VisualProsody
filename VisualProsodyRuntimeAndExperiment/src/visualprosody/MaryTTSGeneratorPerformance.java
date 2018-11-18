package visualprosody;

import hmi.tts.mary5.MaryTTSGenerator;

import java.io.IOException;

import javax.sound.sampled.AudioInputStream;

import marytts.LocalMaryInterface;
import marytts.datatypes.MaryDataType;
import marytts.exceptions.MaryConfigurationException;
import marytts.exceptions.SynthesisException;
import marytts.util.data.audio.MaryAudioUtils;

public class MaryTTSGeneratorPerformance
{
    public static void main(String args[]) throws MaryConfigurationException, SynthesisException, IOException
    {
        String speech = "Welcome to Greta's team page! "
                + "We work on making human-computer interactions more emotion-oriented and social. We develop an interactive embodied conversational agent platform technology. "
                + "Our methodology is based on the quality and property of humans’ communication. We are interested in improving communicative skills of virtual agents and learning "
                + "about human behaviour and communication."
                + "Our team is centered on research involving Greta, the embodied conversational agent. The agent is autonomous and expressive. "
                + "Greta can express her emotional states and intentions through verbal and nonverbal behaviours, and be socially aware. She can endorse different roles, "
                + "e.g. be a dialog companion, a storyteller, a virtual tutor, an actor in different games. "
                + "Greta is part of the SEMAINE platform where she is endowed with the capabilities to recognise emotional states, to process speech and to express"
                + " verbal and nonverbal behaviours.";
        LocalMaryInterface marytts = new LocalMaryInterface();
        marytts.setVoice("dfki-prudence");
        MaryTTSGenerator mary = new MaryTTSGenerator();
        mary.setVoice("dfki-prudence");

        long startTimeWav = System.currentTimeMillis();
        marytts.setInputType(MaryDataType.TEXT.toString());
        marytts.setOutputType(MaryDataType.AUDIO.toString());
        marytts.setStreamingAudio(false);
        AudioInputStream audio = marytts.generateAudio(speech);
        MaryAudioUtils.writeWavFile(MaryAudioUtils.getSamplesAsDoubleArray(audio), "testdirect.wav", audio.getFormat());
        System.out.println("Wav file full generation time " + (System.currentTimeMillis() - startTimeWav) + " ms.");

        long startTime = System.currentTimeMillis();
        mary.getBMLTiming(speech);
        System.out.println("getBMLTiming time " + (System.currentTimeMillis() - startTime) + " ms.");

        startTime = System.currentTimeMillis();
        mary.speakBMLToFile(speech, "test.wav");
        System.out.println("speakBML time " + (System.currentTimeMillis() - startTime) + " ms.");

    }
}
