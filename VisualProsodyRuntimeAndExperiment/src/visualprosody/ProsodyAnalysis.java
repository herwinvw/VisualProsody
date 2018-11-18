package visualprosody;

import hmi.tts.mary5.MaryTTSGenerator;
import hmi.tts.mary5.prosody.MaryProsodyInfo;

import java.io.File;
import java.io.FileWriter;

import org.apache.commons.csv.CSVFormat;
import org.apache.commons.csv.CSVPrinter;

public class ProsodyAnalysis
{
    public static void main(String args[]) throws Exception
    {
        String speech = "Welcome to Greta's team page.";
//        
//                + "We work on making human-computer interactions more emotion-oriented and social. We develop an interactive embodied conversational agent platform technology. "
//                + "Our methodology is based on the quality and property of humans� communication. We are interested in improving communicative skills of virtual agents and learning "
//                + "about human behaviour and communication. "
//                + "Our team is centered on research involving Greta, the embodied conversational agent. The agent is autonomous and expressive. "
//                + "Greta can express her emotional states and intentions through verbal and nonverbal behaviours, and be socially aware. She can endorse different roles, "
//                + "e.g. be a dialog companion, a storyteller, a virtual tutor, an actor in different games. "
//                + "Greta is part of the SEMAINE platform where she is endowed with the capabilities to recognise emotional states, to process speech and to express"
//                + " verbal and nonverbal behaviours.";
        MaryTTSGenerator maryGen = new MaryTTSGenerator();
        maryGen.setVoice("dfki-prudence-hsmm");
        
        
        MaryProsodyInfo info = maryGen.getProsodyInfo(speech);
        System.out.println("Phonemes: "+info.getPhonemes().size());
        System.out.println("Phonemes: "+info.getPhonemes());
        double contour[] = info.getF0Contour(100);
        CSVPrinter printer = new CSVPrinter(new FileWriter(new File("contour_hsmm.csv")),CSVFormat.RFC4180.withHeader("Frame","Time","F0"));
        for(int i=0;i<contour.length;i++)
        {
            printer.printRecord(i, i*info.getDuration()/(contour.length-1)*0.001d, contour[i]);            
        }
        printer.close();
        System.out.println("Duration: " + info.getDuration());
        
        System.out.println("Duration (getTiming()):"+maryGen.getTiming(speech).getDuration());
               
        maryGen.speakToFile(speech, "welcome_hsmm.wav");
    }
}
