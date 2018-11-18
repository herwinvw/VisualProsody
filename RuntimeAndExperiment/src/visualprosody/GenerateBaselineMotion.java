package visualprosody;

import hmi.animation.ConfigList;
import hmi.animation.Hanim;
import hmi.animation.SkeletonInterpolator;
import hmi.math.Quat4f;

import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.util.List;

import org.apache.commons.csv.CSVFormat;
import org.apache.commons.csv.CSVParser;
import org.apache.commons.csv.CSVPrinter;
import org.apache.commons.csv.CSVRecord;
import org.apache.commons.csv.QuoteMode;

import saiba.bml.builder.BehaviourBlockBuilder;
import saiba.bml.builder.GazeBehaviourBuilder;
import saiba.bml.builder.SpeechBehaviourBuilder;
import saiba.bml.core.OffsetDirection;
import asap.bml.ext.bmlt.BMLTInfo;
import asap.bml.ext.bmlt.builder.BMLTKeyframeBehaviourBuilder;

import com.google.common.base.Charsets;
import com.google.common.collect.ImmutableList;
import com.google.common.io.Files;

public class GenerateBaselineMotion
{
    public static SkeletonInterpolator headMotion(String sentenceId, String session, String fileprefix, double endTime) throws IOException
    {
        List<String> header = ImmutableList.<String> builder().add("roll").add("pitch").add("yaw").build();
        CSVPrinter printer = new CSVPrinter(new FileWriter(new File("baseline/"+sentenceId+"_head.csv")), CSVFormat.DEFAULT.withEscape('\\')
                .withQuoteMode(QuoteMode.NONE).withHeader(header.toArray(new String[header.size()])));
        
        ConfigList cl = new ConfigList(4);
        String filename = session + "MOCAP_head" + fileprefix + "_elan.csv";
        CSVParser parser = CSVParser.parse(new File(filename), Charsets.UTF_8, CSVFormat.RFC4180.withIgnoreSurroundingSpaces(true)
                .withHeader());
        for (CSVRecord rec : parser.getRecords())
        {
            double time = Double.parseDouble(rec.get("Time"));
            if(time>endTime)break;
            float pitch = Float.parseFloat(rec.get("pitch"));
            float yaw = -Float.parseFloat(rec.get("yaw"));
            float roll = Float.parseFloat(rec.get("roll"));
            printer.printRecord(roll, pitch, yaw);
            float q[] = Quat4f.getQuat4f();
            Quat4f.setFromRollPitchYawDegrees(q, roll, pitch, yaw);
            cl.addConfig(time, q);
        }
        printer.close();
        SkeletonInterpolator ski = new SkeletonInterpolator(new String[] { Hanim.skullbase }, cl, "R");
        return ski;
    }
    
    public static void main(String args[]) throws IOException
    {
        String corpusdir= "../IEMOCAP_analysis/corpus/IEMOCAP_full_release/";
        String session = corpusdir+"Session2/sentences/";
        String fileprefix = "/Ses02M_script01_1/Ses02M_script01_1_M002";
        String sentenceId = "hawaii_hannah";
        
        //String corpusdir= "../IEMOCAP_analysis/corpus/IEMOCAP_full_release/";
        //String session = corpusdir+"Session3/sentences/";
        //String fileprefix = "/Ses03M_script02_2/Ses03M_script02_2_M006";
        //String sentenceId = "shopping_hannah";

        //String corpusdir= "../IEMOCAP_analysis/corpus/IEMOCAP_full_release/";
        //String session = corpusdir+"Session3/sentences/";
        //String fileprefix = "/Ses03M_impro08a/Ses03M_impro08a_M002";
        //String sentenceId = "garage_hannah";
        
        //String corpusdir= "../IEMOCAP_analysis/corpus/IEMOCAP_full_release/";
        //String session = corpusdir+"Session3/sentences/";
        //String fileprefix = "/Ses03M_script02_2/Ses03M_script02_2_M045";
        //String sentenceId = "dentist_hannah";

        //String corpusdir= "../IEMOCAP_analysis/corpus/IEMOCAP_full_release/";
        //String session = corpusdir+"Session3/sentences/";
        //String fileprefix = "/Ses03M_impro07/Ses03M_impro07_M020";
        //String sentenceId = "login_hannah";
        //Ses03M_impro07_M020
        
        String mocapId = fileprefix.split("/")[fileprefix.split("/").length - 1];
        String dur = Files.toString(new File("wav/"+sentenceId+".dur"), Charsets.UTF_8);
        double endTime = Double.parseDouble(dur);
       
        
        BMLTInfo.init();
        BehaviourBlockBuilder builder = new BehaviourBlockBuilder();
        builder = builder.id("bml1");
        String speechContent = Files.toString(new File("wav/" + sentenceId + ".txt"), Charsets.UTF_8);
        builder = builder.addBehaviour(new SpeechBehaviourBuilder("bml1", "speech1").content(speechContent).build());
        builder.addAtConstraint("gaze1","start",0);
        builder.addAtConstraint("gaze1:end","speech1:end+0.5");
        builder.addBehaviour(new GazeBehaviourBuilder("bml1","gaze1","camera")
            .influence("EYES")  
            .offset(OffsetDirection.UP, 3)                    
            .build());        
        builder.addBehaviour(new BMLTKeyframeBehaviourBuilder("bml1", "headmotion").content(headMotion(sentenceId,session, fileprefix, endTime).toXMLString()).build());
        builder.build().writeXML(new File(sentenceId + "_mocap"+mocapId+".xml"));
    }
}
