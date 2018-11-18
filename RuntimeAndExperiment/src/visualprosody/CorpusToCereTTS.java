package visualprosody;

import hmi.tts.TimingInfo;

import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;

import marytts.exceptions.MaryConfigurationException;
import marytts.exceptions.SynthesisException;

import org.apache.commons.io.FileUtils;

import asap.tts.ipaaca.IpaacaTTSGenerator;

import com.google.common.base.Charsets;
import com.google.common.io.Files;

public class CorpusToCereTTS
{
    private static final String CORPUSDIR = "../IEMOCAP_analysis/corpus/IEMOCAP_full_release/";
    private static final String VOICE = "hannah";

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
        IpaacaTTSGenerator ttsGen = new IpaacaTTSGenerator();

        String filename = sentenceId + "_" + VOICE + ".wav";
        TimingInfo info = ttsGen.speakToFile(text, filename);
        
        PrintWriter out = new PrintWriter("wav/"+sentenceId + "_" + VOICE + ".dur");
        out.println(""+info.getDuration());
        out.close();
        
        File f = new File(System.getProperty("java.io.tmpdir")+"/_"+filename);
        Files.copy(f,new File("wav/"+filename));
        ttsGen.close();
    }

    public static void main(String args[]) throws IOException, MaryConfigurationException, SynthesisException
    {
        // String session = corpusdir+"Session1/sentences/";
        // String fileprefix = "/Ses01M_impro05/Ses01M_impro05_M031";

        String file = CORPUSDIR + "Session1/dialog/transcriptions/Ses01F_script01_3.txt";
        // String sentence = "Ses01F_script01_3_F033";
        //String sentence = "Ses01F_script01_3_F034";

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
        //String textToSpeak = getSentence(file, sentence);
        //textToSpeak = "Your plane to Hawaii leaves on Saturday at 10 pm, so you should take the train at 7:10, what do you think about that?";
        //sentence = "hawaii";
        
        
        //String textToSpeak = getSentence(file, sentence);
        //String textToSpeak = "Your plane to Hawaii leaves on Saturday at 10 am, so you should take the train at 7:10, what do you think about that?";
        //rate: x-slow slow medium fast x-fast
        //volume: 0..100, x-soft soft medium loud x-loud
        //String textToSpeak = "<prosody range=\"medium\">"
        //        + "Your plane to Hawaii leaves on Saturday at 10 am, so you should take the train at 7:10, what do you think about that?"+
        //        "</prosody>";
        
        String textToSpeak = "<emphasis level=\"strong\">That</emphasis> is a huge bank account!";                
        String sentence = "bank_account";
        
        //String textToSpeak = "This afternoon, after two pm, you can pick up your car from the garage.";
        //String sentence = "garage";
        
        //String textToSpeak = "On Sunday you'll go shopping with your sister in New York. Are you looking forward to that?";
        //String sentence = "shopping";
        
        //String textToSpeak = "You have a dentist appointment on Friday morning, at 11:30.";
        //String sentence = "dentist";
        
        //String textToSpeak = "Your login code is: X, W, 5, C.";
        //String sentence = "login";
        
        createAudio(textToSpeak, sentence);
        FileUtils.writeStringToFile(new File("wav/" + sentence + "_" + VOICE + ".txt"), textToSpeak);
    }
}
