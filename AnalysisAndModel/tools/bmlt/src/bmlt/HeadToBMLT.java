package bmlt;

import hmi.animation.ConfigList;
import hmi.animation.Hanim;
import hmi.animation.SkeletonInterpolator;
import hmi.faceanimation.FaceInterpolator;
import hmi.math.Quat4f;
import hmi.math.Vecf;
import hmi.util.Resources;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Set;

import org.apache.commons.csv.CSVFormat;
import org.apache.commons.csv.CSVParser;
import org.apache.commons.csv.CSVRecord;

import saiba.bml.builder.BehaviourBlockBuilder;
import saiba.bml.core.BehaviourBlock;
import asap.bml.ext.bmlt.BMLTFaceKeyframeBehaviour.Type;
import asap.bml.ext.bmlt.BMLTInfo;
import asap.bml.ext.bmlt.builder.BMLTAudioFileBehaviourBuilder;
import asap.bml.ext.bmlt.builder.BMLTFaceKeyframeBehaviourBuilder;
import asap.bml.ext.bmlt.builder.BMLTKeyframeBehaviourBuilder;
import asap.faceengine.viseme.MorphVisemeDescription;
import asap.faceengine.viseme.VisemeToMorphMapping;

import com.google.common.base.Charsets;
import com.google.common.collect.ImmutableList;
import com.google.common.collect.ImmutableSet;
import com.google.common.io.Files;

public class HeadToBMLT
{
    private static final String LEFT_INNER_BROW_FAPID = "31";
    private static final String RIGHT_INNER_BROW_FAPID = "32";
    private static final String LEFT_MIDDLE_BROW_FAPID = "33";
    private static final String RIGHT_MIDDLE_BROW_FAPID = "34";
    private static final String LEFT_OUTER_BROW_FAPID = "35";
    private static final String RIGHT_OUTER_BROW_FAPID = "36";
    private static final String LEFT_INNER_BROW_SQUEEZE = "37";
    private static final String RIGHT_INNER_BROW_SQUEEZE = "38";
    
    private static final double LIPSYNC_ANTICIPATION_TIME = 0.3;
    private static final float ENS_M = 15;
    private static final float ES_M = 50; 
            
    public static SkeletonInterpolator parseLipSyncJaw(String session, String fileprefix) throws IOException
    {
        String filename = session + "ForcedAlignment" + fileprefix + ".phseg";
        List<String> phsegs = Files.readLines(new File(filename), Charsets.UTF_8);
        phsegs.remove(0);
        phsegs.remove(phsegs.size() - 1);

        ConfigList cl = new ConfigList(4);
        cl.addConfig(0, Quat4f.getIdentity());

        Set<String> voicedPhonemes = ImmutableSet.of("AA", "AE", "AH", "AO", "AW", "AX", "AXR", "AY", "EH", "ER", "EY", "IH", "IX", "IY",
                "JH", "OW", "OY", "UH", "UW", "Y", "+LAUGHTER+");

        for (String phseg : phsegs)
        {
            String[] split = phseg.trim().split("\\s+");
            float start = Float.parseFloat(split[0]);
            float end = Float.parseFloat(split[1]);
            String phoneme = split[3];
            double startTime = (start + 2) / 100;
            double endTime = (end + 2) / 100;

            float config[] = Quat4f.getIdentity();
            if (voicedPhonemes.contains(phoneme))
            {
                Quat4f.setFromAxisAngle4f(config, 1, 0, 0, 0.23f);
            }
            if(phoneme.equals("SIL"))
            {
                double offset = (endTime - startTime) / 2;
                if(offset>LIPSYNC_ANTICIPATION_TIME)offset = LIPSYNC_ANTICIPATION_TIME;
                System.out.println("SIL, offset: "+offset+" start: "+startTime);
                
                //offset=0;
                cl.addConfig(startTime+offset, config);
                cl.addConfig(endTime-offset, config);
            }
            else
            {
                cl.addConfig(startTime + (endTime - startTime) / 2, config);
            }
        }
        return new SkeletonInterpolator(new String[] { Hanim.temporomandibular }, cl, "R");
    }

    public static FaceInterpolator parseLipSyncFace(String session, String fileprefix) throws IOException
    {
        VisemeToMorphMapping vb = new VisemeToMorphMapping();
        vb.readXML(new Resources("").getReader("sphinxvisemebinding.xml"));
        List<String> usedMorphs = new ArrayList<String>(vb.getUsedMorphs());

        String filename = session + "ForcedAlignment" + fileprefix + ".phseg";
        List<String> phsegs = Files.readLines(new File(filename), Charsets.UTF_8);
        phsegs.remove(0);
        phsegs.remove(phsegs.size() - 1);

        ConfigList cl = new ConfigList(usedMorphs.size());
        cl.addConfig(0, new float[usedMorphs.size()]);
        for (String phseg : phsegs)
        {
            String[] split = phseg.trim().split("\\s+");
            float start = Float.parseFloat(split[0]);
            float end = Float.parseFloat(split[1]);
            String phoneme = split[3];
            double startTime = (start + 2) / 100;
            double endTime = (end + 2) / 100;

            float config[] = new float[usedMorphs.size()];
            int i = 0;
            MorphVisemeDescription mvd = vb.getMorphTargetForViseme(phoneme);
            for (String morph : usedMorphs)
            {
                if (mvd.getMorphNames().contains(morph))
                {
                    config[i] = mvd.getIntensity();
                }
                else
                {
                    config[i] = 0;
                }
                i++;
            }
            if(phoneme.equals("SIL"))
            {
                double offset = (endTime - startTime) / 2;
                if(offset>LIPSYNC_ANTICIPATION_TIME)offset = LIPSYNC_ANTICIPATION_TIME;
                cl.addConfig(startTime+offset, config);
                cl.addConfig(endTime-offset, config);
            }
            else
            {
                cl.addConfig(startTime + (endTime - startTime) / 2, config);
            }            
        }
        return new FaceInterpolator(usedMorphs, cl);
    }

    public static SkeletonInterpolator parseHead(String session, String fileprefix) throws IOException
    {
        ConfigList cl = new ConfigList(5);
        String filename = session + "MOCAP_head" + fileprefix + "_elan.csv";
        CSVParser parser = CSVParser.parse(new File(filename), Charsets.UTF_8, CSVFormat.RFC4180.withIgnoreSurroundingSpaces(true)
                .withHeader());
        for (CSVRecord rec : parser.getRecords())
        {
            float pitch = Float.parseFloat(rec.get("pitch"));
            float yaw = -Float.parseFloat(rec.get("yaw"));
            float roll = Float.parseFloat(rec.get("roll"));
            float q[] = Quat4f.getQuat4f();
            Quat4f.setFromRollPitchYawDegrees(q, roll, pitch, yaw);
            cl.addConfig(Double.parseDouble(rec.get("Time")), q);
        }
        SkeletonInterpolator ski = new SkeletonInterpolator(new String[] { Hanim.skullbase }, cl, "R");
        return ski;
    }

    private static void interpolateRegion(float[] a, int start, int end, float startValue, float endValue)
    {
        for (int i = start; i < end; i++)
        {
            double alpha = (double) (i - start) / (double) (end - start);
            a[i] = (float) (alpha * endValue + (1 - alpha) * startValue);
        }
    }

    private static void interpolateNaNValues(float a[])
    {
        boolean inNanRegion = false;
        int nanStart = 0;
        int nanEnd = 0;
        for (int i = 0; i < a.length; i++)
        {
            if (Float.isNaN(a[i]))
            {
                if (!inNanRegion)
                {
                    inNanRegion = true;
                    nanStart = i;
                }
            }
            else
            {
                nanEnd = i;
                if (inNanRegion)
                {
                    inNanRegion = false;
                    float startValue;
                    if (nanStart == 0)
                    {
                        startValue = a[nanEnd];
                    }
                    else
                    {
                        startValue = a[nanStart - 1];
                    }
                    float endValue = a[nanEnd];
                    interpolateRegion(a, nanStart, nanEnd, startValue, endValue);
                }
            }
        }
        if (inNanRegion)
        {
            float startValue = a[nanStart];
            float endValue = 0;
            interpolateRegion(a, nanStart, nanEnd, startValue, endValue);
        }
    }

    public static FaceInterpolator parseBlink(String session, String fileprefix) throws IOException
    {
        String filename = session + "MOCAP_rotated" + fileprefix + "_elan.csv";

        CSVParser parser = CSVParser.parse(new File(filename), Charsets.UTF_8, CSVFormat.RFC4180.withIgnoreSurroundingSpaces(true)
                .withHeader());
        List<CSVRecord> list = parser.getRecords();
        
        float rlid[] = new float[list.size()];
        float llid[] = new float[list.size()];
        double time[] = new double[list.size()];
        int i = 0;
        for (CSVRecord rec : list)
        {
            rlid[i] = Float.parseFloat(rec.get("RLIDz"));
            llid[i] = Float.parseFloat(rec.get("LLIDz"));
            time[i] = Double.parseDouble(rec.get("Time"));            
            i++;
        }        
        ConfigList cl = new ConfigList(1);
        interpolateNaNValues(rlid);
        interpolateNaNValues(llid);
        
        double openr = Vecf.max(rlid);
        double closedr = Vecf.min(rlid);
        double openl = Vecf.max(llid);
        double closedl = Vecf.min(llid);
        
        for (i = 0; i < list.size(); i++)
        {
            double r_lid = (rlid[i]-closedr)/(openr-closedr);
            double l_lid = (llid[i]-closedl)/(openl-closedl);
            cl.addConfig(time[i], new float[] { 1-(0.5f*(float)(r_lid+l_lid)) });
        }
        //TODO: does "BLINK" work?
        return new FaceInterpolator(ImmutableList.of("Body_NG-mesh-morpher-yeux_NG01-1"), cl);
    }
    public static FaceInterpolator parseBrows(String session, String fileprefix) throws IOException
    {
        String filename = session + "MOCAP_rotated" + fileprefix + "_elan.csv";

        CSVParser parser = CSVParser.parse(new File(filename), Charsets.UTF_8, CSVFormat.RFC4180.withIgnoreSurroundingSpaces(true)
                .withHeader());
        List<CSVRecord> list = parser.getRecords();
        float leftOuterBrow[] = new float[list.size()];
        float rightOuterBrow[] = new float[list.size()];
        float leftInnerBrow[] = new float[list.size()];
        float rightInnerBrow[] = new float[list.size()];
        float rightMiddleBrow1[] = new float[list.size()];
        float rightMiddleBrow2[] = new float[list.size()];
        float leftMiddleBrow1[] = new float[list.size()];
        float leftMiddleBrow2[] = new float[list.size()];
        
        float leftBrowSqueeze[]=new float[list.size()];
        float rightBrowSqueeze[]=new float[list.size()];
        double time[] = new double[list.size()];

        // RBRO3y, RBRO2y: middle
        // LBRO4y: outer
        // LBRO1y: inner
        int i = 0;

        for (CSVRecord rec : list)
        {
            rightOuterBrow[i] = Float.parseFloat(rec.get("RBRO4z"));
            leftOuterBrow[i] = Float.parseFloat(rec.get("LBRO4z"));
            leftInnerBrow[i] = Float.parseFloat(rec.get("LBRO1z"));
            rightInnerBrow[i] = Float.parseFloat(rec.get("RBRO1z"));

            rightMiddleBrow1[i] = Float.parseFloat(rec.get("RBRO2z"));
            rightMiddleBrow2[i] = Float.parseFloat(rec.get("RBRO3z"));

            leftMiddleBrow1[i] = Float.parseFloat(rec.get("LBRO2z"));
            leftMiddleBrow2[i] = Float.parseFloat(rec.get("LBRO3z"));

            leftBrowSqueeze[i] = Float.parseFloat(rec.get("LBRO1x"));
            rightBrowSqueeze[i] = -Float.parseFloat(rec.get("RBRO1x"));
            
            time[i] = Double.parseDouble(rec.get("Time"));
            i++;
        }

        interpolateNaNValues(rightOuterBrow);
        interpolateNaNValues(leftOuterBrow);
        interpolateNaNValues(rightMiddleBrow1);
        interpolateNaNValues(leftMiddleBrow1);
        interpolateNaNValues(rightMiddleBrow2);
        interpolateNaNValues(leftMiddleBrow2);
        interpolateNaNValues(rightInnerBrow);
        interpolateNaNValues(leftInnerBrow);
        interpolateNaNValues(leftBrowSqueeze);
        interpolateNaNValues(rightBrowSqueeze);

        float rightOuterBrowBaseline = rightOuterBrow[0];
        float leftOuterBrowBaseline = leftOuterBrow[0];
        float leftInnerBrowBaseline = leftInnerBrow[0];
        float rightInnerBrowBaseline = rightInnerBrow[0];
        float rightMiddleBrow1Baseline = rightMiddleBrow1[0];
        float rightMiddleBrow2Baseline = rightMiddleBrow2[0];
        float leftMiddleBrow1Baseline = leftMiddleBrow1[0];
        float leftMiddleBrow2Baseline = leftMiddleBrow2[0];
        float leftBrowSqueezeBaseline = leftBrowSqueeze[0];
        float rightBrowSqueezeBaseline = rightBrowSqueeze[0];

        for (i = 0; i < leftInnerBrow.length; i++)
        {
            rightOuterBrow[i] -= rightOuterBrowBaseline;
            leftOuterBrow[i] -= leftOuterBrowBaseline;
            rightInnerBrow[i] -= rightInnerBrowBaseline;
            leftInnerBrow[i] -= leftInnerBrowBaseline;
            rightMiddleBrow1[i] -= rightMiddleBrow1Baseline;
            rightMiddleBrow2[i] -= rightMiddleBrow2Baseline;
            leftMiddleBrow1[i] -= leftMiddleBrow1Baseline;
            leftMiddleBrow2[i] -= leftMiddleBrow2Baseline;
            leftBrowSqueeze[i] -= leftBrowSqueezeBaseline;
            rightBrowSqueeze[i] -= rightBrowSqueezeBaseline;            
        }

        float rightMiddleBrow[] = new float[list.size()];
        float leftMiddleBrow[] = new float[list.size()];
        Vecf.add(leftMiddleBrow, leftMiddleBrow1, leftMiddleBrow2);
        Vecf.scale(0.5f, leftMiddleBrow);
        Vecf.add(rightMiddleBrow, rightMiddleBrow1, rightMiddleBrow2);
        Vecf.scale(0.5f, rightMiddleBrow);
        

        Vecf.scale(ENS_M, rightOuterBrow);
        Vecf.scale(ENS_M, leftOuterBrow);
        Vecf.scale(ENS_M, leftInnerBrow);
        Vecf.scale(ENS_M, rightInnerBrow);
        Vecf.scale(ENS_M, leftMiddleBrow);
        Vecf.scale(ENS_M, rightMiddleBrow);
        Vecf.scale(ES_M, rightBrowSqueeze);
        Vecf.scale(ES_M, leftBrowSqueeze);
        
        float[] innerBrow = new float[rightOuterBrow.length];
        float[] outerBrow = new float[rightOuterBrow.length];
        float[] midBrow = new float[rightOuterBrow.length];
        float[] squeezeBrow = new float[rightOuterBrow.length];
        
        Vecf.add(innerBrow, rightInnerBrow, leftInnerBrow);
        Vecf.scale(0.5f, innerBrow);
        Vecf.add(outerBrow, rightOuterBrow, leftOuterBrow);
        Vecf.scale(0.5f, outerBrow);
        Vecf.add(midBrow, leftMiddleBrow, rightMiddleBrow);
        Vecf.scale(0.5f, midBrow);
        Vecf.add(squeezeBrow, leftBrowSqueeze, rightBrowSqueeze);
        Vecf.scale(0.5f, squeezeBrow);
        
        ConfigList cl = new ConfigList(6);
        for (i = 0; i < list.size(); i++)
        {
            // symmetric
            // cl.addConfig(time[i], new float[] { outerBrow[i], outerBrow[i], midBrow[i], midBrow[i],
            // innerBrow[i], innerBrow[i],squeezeBrow[i] });

            cl.addConfig(time[i], new float[] { rightOuterBrow[i], leftOuterBrow[i], rightMiddleBrow[i], leftMiddleBrow[i],
                    rightInnerBrow[i], leftInnerBrow[i],rightBrowSqueeze[i],leftBrowSqueeze[i] });
        }
        return new FaceInterpolator(ImmutableList.of(RIGHT_OUTER_BROW_FAPID, LEFT_OUTER_BROW_FAPID, RIGHT_MIDDLE_BROW_FAPID,
                LEFT_MIDDLE_BROW_FAPID, RIGHT_INNER_BROW_FAPID, LEFT_INNER_BROW_FAPID, RIGHT_INNER_BROW_SQUEEZE, LEFT_INNER_BROW_SQUEEZE), cl);
    }

    public static void main(String args[]) throws IOException
    {
        String corpusdir= "../../corpus/IEMOCAP_full_release/";
        
        //String session = corpusdir + "Session1/sentences/";
        //String fileprefix = "/Ses01F_script01_3/Ses01F_script01_3_F034";
        
        //String session = corpusdir + "Session2/sentences/";
        //String fileprefix = "/Ses02F_script01_3/Ses02F_script01_3_F028";        
        
        //String session = corpusdir+"Session1/sentences/";
        //String fileprefix = "/Ses01M_impro05/Ses01M_impro05_M031";
       
        //String session = corpusdir+"Session1/sentences/";
        //String fileprefix = "/Ses01F_script01_3/Ses01F_script01_3_F033";
       
        //String session = corpusdir+"Session1/sentences/";
        //String fileprefix = "/Ses01F_impro01/Ses01F_impro01_F011";
       
        //String session = corpusdir+"Session3/sentences/";
        //String fileprefix = "/Ses03F_impro02/Ses03F_impro02_F016";
        
        //String session = corpusdir+"Session1/sentences/";
        //String fileprefix = "/Ses01M_impro01/Ses01M_impro01_M002";
        
        //String session = corpusdir+"Session1/sentences/";
        //String fileprefix = "/Ses01M_script03_1/Ses01M_script03_1_M020";

        //String session = corpusdir+"Session5/sentences/";
        //String fileprefix = "/Ses05M_script01_1/Ses05M_script01_1_M027";
        
        //String session = corpusdir+"Session5/sentences/";
        //String fileprefix = "/Ses05M_script01_1/Ses05M_script01_1_M028";
        
        //String session = corpusdir+"Session1/sentences/";
        //String fileprefix = "/Ses01F_impro04/Ses01F_impro04_F002";
        
        //String session = corpusdir+"Session3/sentences/";
        //String fileprefix = "/Ses03M_script02_1/Ses03M_script02_1_M023";
        String session = corpusdir+"Session2/sentences/";
        String fileprefix = "/Ses02F_impro07/Ses02F_impro07_F022";
        
        FaceInterpolator faceLips = parseLipSyncFace(session, fileprefix);
        SkeletonInterpolator jawLips = parseLipSyncJaw(session,fileprefix);
        SkeletonInterpolator ski = parseHead(session, fileprefix);
        FaceInterpolator mi = parseBrows(session, fileprefix);
        FaceInterpolator bli = parseBlink(session, fileprefix);
        
        String sessionabspath = new File(session).toURI().toString();
        BMLTInfo.init();
        BehaviourBlockBuilder builder = new BehaviourBlockBuilder();
        BehaviourBlock bb = builder
                .id("bml1")
                .addBehaviour(new BMLTAudioFileBehaviourBuilder("bml1","audio1",sessionabspath+"wav"+fileprefix+".wav").build())
                .addBehaviour(new BMLTKeyframeBehaviourBuilder("bml1", "kf1").content(ski.toXMLString()).build())
                .addBehaviour(new BMLTKeyframeBehaviourBuilder("bml1", "lipsyncjaw1").content(jawLips.toXMLString()).build())
                .addBehaviour(new BMLTFaceKeyframeBehaviourBuilder("bml1", "fk1").type(Type.FAPS).content(mi.toXMLString()).build())
                .addBehaviour(new BMLTFaceKeyframeBehaviourBuilder("bml1", "fkblink").type(Type.MORPH).content(bli.toXMLString()).build())
                .addBehaviour(
                        new BMLTFaceKeyframeBehaviourBuilder("bml1", "lipsyncface1").type(Type.MORPH).content(faceLips.toXMLString())
                                .build()).build();
        bb.writeXML(new File(fileprefix.split("/")[2]+".xml"));
    }

}
