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

public class YuToBML
{
    private static SkeletonInterpolator headMotion(String sentenceId) throws IOException
    {
        List<String> header = ImmutableList.<String> builder().add("roll").add("pitch").add("yaw").build();
        CSVPrinter printer = new CSVPrinter(new FileWriter(new File("yu/"+sentenceId+"_head.csv")), CSVFormat.DEFAULT.withEscape('\\')
                .withQuoteMode(QuoteMode.NONE).withHeader(header.toArray(new String[header.size()])));
        
        CSVParser parser = CSVParser.parse(new File("resource/yu/" + sentenceId + ".txt"), Charsets.UTF_8, CSVFormat.RFC4180
                .withIgnoreSurroundingSpaces(true).withHeader().withDelimiter(' '));
        ConfigList cl = new ConfigList(4);
        for (CSVRecord rec : parser.getRecords())
        {
            float roll = Float.parseFloat(rec.get("roll"));
            float pitch = Float.parseFloat(rec.get("pitch"));
            float yaw = Float.parseFloat(rec.get("yaw"));
            printer.printRecord(roll, pitch, yaw);
            float q[] = Quat4f.getQuat4f();
            Quat4f.setFromRollPitchYawDegrees(q, roll, pitch, yaw);
            cl.addConfig(Double.parseDouble(rec.get(0)), q);
        }
        printer.close();
        return new SkeletonInterpolator(new String[] { Hanim.skullbase }, cl, "R");
    }

    public static void main(String args[]) throws IOException
    {
        String session = "";
        //String fileprefix = "/dentist_hannah";
        //String fileprefix = "/hawaii_hannah";
        //String fileprefix = "/garage_hannah";
        //String fileprefix = "/login_hannah";
        String fileprefix = "/shopping_hannah";
        
        String sentenceId = fileprefix.split("/")[fileprefix.split("/").length - 1];

        BMLTInfo.init();
        BehaviourBlockBuilder builder = new BehaviourBlockBuilder();
        builder = builder.id("bml1");
        String speechContent = Files.toString(new File(session + "wav" + fileprefix + ".txt"), Charsets.UTF_8);
        builder = builder.addBehaviour(new SpeechBehaviourBuilder("bml1", "speech1").content(speechContent).build());
        builder.addAtConstraint("gaze1", "start", 0);
        builder.addAtConstraint("gaze1:end", "headmotion:end+0.5");
        builder.addBehaviour(new BMLTKeyframeBehaviourBuilder("bml1", "headmotion").content(headMotion(sentenceId).toXMLString()).build());
        builder.addBehaviour(new GazeBehaviourBuilder("bml1", "gaze1", "camera").influence("EYES").offset(OffsetDirection.UP, 3).build());
        builder.build().writeXML(new File(sentenceId + "_yu.xml"));
    }
}
