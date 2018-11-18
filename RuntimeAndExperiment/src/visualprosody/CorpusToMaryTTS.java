package visualprosody;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;

import javax.sound.sampled.AudioFileFormat;
import javax.sound.sampled.AudioInputStream;

import marytts.LocalMaryInterface;
import marytts.datatypes.MaryDataType;
import marytts.exceptions.MaryConfigurationException;
import marytts.exceptions.SynthesisException;

import org.apache.commons.io.FileUtils;

import com.google.common.base.Charsets;
import com.google.common.io.Files;
import com.sun.media.sound.WaveFileWriter;

public class CorpusToMaryTTS
{
    private static final String CORPUSDIR = "../IEMOCAP_analysis/corpus/IEMOCAP_full_release/";
    // private static final String VOICE = "dfki-prudence";
    private static final String VOICE = "dfki-prudence-hsmm";

    // private static final String VOICE = "dfki-poppy";
    // private static final String VOICE = "cmu-slt-hsmm";

    private static String getSentence(String file, String sentence) throws IOException
    {
        File f = new File(file);
        String text = Files.toString(f, Charsets.UTF_8);

        for (String str : text.split("\n"))
        {
            if (str.startsWith(sentence)) return str.split(":")[1].trim();
        }
        return "";
    }

    private static void createAudio(String text, String sentenceId) throws MaryConfigurationException, SynthesisException, IOException
    {
        LocalMaryInterface marytts = new LocalMaryInterface();
        System.out.println("voices: " + marytts.getAvailableVoices());
        marytts.setVoice(VOICE);
        marytts.setInputType(MaryDataType.TEXT.toString());
        marytts.setOutputType(MaryDataType.AUDIO.toString());

        AudioInputStream audio = marytts.generateAudio(text);
        WaveFileWriter wr = new WaveFileWriter();
        File f = new File("wav/" + sentenceId + "_" + VOICE + ".wav");
        FileOutputStream fo = new FileOutputStream(f);
        wr.write(audio, AudioFileFormat.Type.WAVE, fo);
        fo.close();
    }

    public static void main(String args[]) throws IOException, MaryConfigurationException, SynthesisException
    {
        // String session = corpusdir+"Session1/sentences/";
        // String fileprefix = "/Ses01M_impro05/Ses01M_impro05_M031";

        String file = CORPUSDIR + "Session1/dialog/transcriptions/Ses01F_script01_3.txt";
        // String sentence = "Ses01F_script01_3_F033";
        String sentence = "Ses01F_script01_3_F034";

        // String session = corpusdir+"Session1/sentences/";
        // String fileprefix = "/Ses01F_impro01/Ses01F_impro01_F011";

        // String session = corpusdir+"Session3/sentences/";
        // String fileprefix = "/Ses03F_impro02/Ses03F_impro02_F016";

        // String session = corpusdir+"Session1/sentences/";
        // String fileprefix = "/Ses01M_impro01/Ses01M_impro01_M002";

        // String session = corpusdir+"Session1/sentences/";
        // String fileprefix = "/Ses01M_script03_1/Ses01M_script03_1_M020";

        // String session = corpusdir+"Session5/sentences/";
        // String fileprefix = "/Ses05M_script01_1/Ses05M_script01_1_M027";
        String textToSpeak = getSentence(file, sentence);

        //textToSpeak = "Your plane to Hawaii leaves on Saturday at 10 pm, so you should take the train at 7:10, what do you think about that?";
        //sentence = "hawaii";
        
        textToSpeak = "Your plane to Hawaii leaves on Saturday at 10 pm, so you should take the train at 7:10, what do you think about that?";
        sentence = "hawaii";
        
        textToSpeak = "This afternoon, after two pm, you can pick up your car from the garage.";
        sentence = "garage";
        
        System.out.println(textToSpeak);
        createAudio(textToSpeak, sentence);
        FileUtils.writeStringToFile(new File("wav/" + sentence + "_" + VOICE + ".txt"), textToSpeak);
    }
}
