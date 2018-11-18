package visualprosody;

import hmi.animation.ConfigList;
import hmi.animation.Hanim;
import hmi.animation.SkeletonInterpolator;
import hmi.faceanimation.FaceInterpolator;
import hmi.math.Quat4f;
import hmi.math.Vec3f;
import hmi.util.Resources;

import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import lombok.Data;

import org.apache.commons.csv.CSVFormat;
import org.apache.commons.csv.CSVParser;
import org.apache.commons.csv.CSVPrinter;
import org.apache.commons.csv.CSVRecord;
import org.apache.commons.csv.QuoteMode;
import org.apache.commons.math3.distribution.NormalDistribution;

import saiba.bml.BMLInfo;
import saiba.bml.builder.BehaviourBlockBuilder;
import saiba.bml.builder.GazeBehaviourBuilder;
import saiba.bml.builder.SpeechBehaviourBuilder;
import saiba.bml.core.BehaviourBlock;
import saiba.bml.core.OffsetDirection;
import asap.bml.ext.bmlt.BMLTFaceKeyframeBehaviour.Type;
import asap.bml.ext.bmlt.BMLTInfo;
import asap.bml.ext.bmlt.builder.BMLTAudioFileBehaviourBuilder;
import asap.bml.ext.bmlt.builder.BMLTFaceKeyframeBehaviourBuilder;
import asap.bml.ext.bmlt.builder.BMLTKeyframeBehaviourBuilder;
import asap.bml.ext.ssml.SSMLBehaviour;
import asap.bml.ext.ssml.builder.SSMLBehaviourBuilder;
import bmlt.HeadToBMLT;

import com.google.common.base.Charsets;
import com.google.common.collect.ImmutableList;
import com.google.common.io.Files;
import com.google.common.primitives.Doubles;

public class VisualProsodyNumericalDiffOfflineBML
{
    private static final String corpusdir = "../IEMOCAP_analysis/corpus/IEMOCAP_full_release/";
    private static final float[] HEAD_OFFSET = new float[] { 0f, -15f, 5f };
    // private static final float[] HEAD_OFFSET = new float[] { 2f, 0f, -12f };
    private static double[] prevRPY;
    private static final double ENERGY_MULTIPLIER = 0.2d;
    private static double likelyhoodDensity = 0;

    private static GaussianMixtureModel getGMM(String filename) throws IOException
    {
        GMMParser gmmParser = new GMMParser();
        gmmParser.readXML(new Resources("").getReader(filename));
        return gmmParser.constructMixtureModel();
    }

    @Data
    private static class AudioFeatures
    {
        final double[] f0;
        final double[] rmsEnergy;
    }

    private static AudioFeatures getAudioFeatures(String session, String fileprefix) throws IOException
    {
        String filename = session + "wav" + fileprefix + ".wavAcf.csv";
        CSVParser parser = CSVParser.parse(new File(filename), Charsets.UTF_8, CSVFormat.RFC4180.withIgnoreSurroundingSpaces(true)
                .withHeader());
        List<Double> f0Values = new ArrayList<>();
        List<Double> rmsValues = new ArrayList<>();
        for (CSVRecord rec : parser.getRecords())
        {
            f0Values.add(Double.parseDouble(rec.get("F0_sma")));
            rmsValues.add(ENERGY_MULTIPLIER * Double.parseDouble(rec.get("pcm_RMSenergy_sma")));
        }
        return new AudioFeatures(Doubles.toArray(f0Values), Doubles.toArray(rmsValues));
    }

    private static SkeletonInterpolator silentHeadMotion(double[] rpyStart, double velocityMean, double velocityVar,
            VisualProsodyLe prosody, int frames, double frameDuration)
    {
        ConfigList cl = new ConfigList(4);
        double[] rpy = Arrays.copyOf(rpyStart, 3);
        double[] rpyPrev = Arrays.copyOf(rpyStart, 3);
        double[] rpyPrevPrev = Arrays.copyOf(rpyStart, 3);
        double rpySearchStart[] = new double[3];

        NormalDistribution velocityDist = new NormalDistribution(0, Math.sqrt(velocityVar));

        for (int i = 0; i < frames; i++)
        {
            rpyPrevPrev = rpyPrev;
            rpyPrev = rpy;
            for (int j = 0; j < 3; j++)
            {
                rpySearchStart[j] = rpyPrev[j] + velocityDist.sample() / 3;
            }
            System.out.println("rpySearchStart:" + Arrays.toString(rpySearchStart));
            // rpy = prosody.generateHeadPose(rpyPrev, rpyPrevPrev, 0, (Math.random()+1)*0.1d);
            rpy = prosody.generateHeadPose(rpySearchStart, rpyPrev, rpyPrevPrev, 0, 0);
            System.out.println("rpy(" + i + ")=" + Arrays.toString(rpy));
            cl.addConfig(i * frameDuration, Quat4f.getQuat4fFromRollPitchYawDegrees((float) rpy[0], (float) rpy[1], (float) rpy[2]));
        }
        return new SkeletonInterpolator(new String[] { Hanim.skullbase }, cl, "R");

    }

    private static SkeletonInterpolator headMotion(String csvFile, float[] offset, double[] rpyStart, VisualProsodyLeNumericalDiff prosody,
            AudioFeatures audio, double frameDuration) throws IOException
    {
        ConfigList cl = new ConfigList(4);
        double[] rpy = Arrays.copyOf(rpyStart, 3);
        double[] rpyPrev = Arrays.copyOf(rpyStart, 3);
        double[] rpyPrevPrev = Arrays.copyOf(rpyStart, 3);

        List<String> header = ImmutableList.<String> builder().add("roll").add("pitch").add("yaw").build();

        CSVPrinter printer = new CSVPrinter(new FileWriter(new File(csvFile)), CSVFormat.DEFAULT.withEscape('\\')
                .withQuoteMode(QuoteMode.NONE).withHeader(header.toArray(new String[header.size()])));

        for (int i = 0; i < audio.getF0().length; i++)
        {
            rpyPrevPrev = rpyPrev;
            rpyPrev = rpy;
            // rpy = prosody.generateHeadPose(rpyPrev, rpyPrevPrev, audio.getF0()[i], audio.getRmsEnergy()[i]);
            if (audio.getF0()[i] > 0)
            {
                rpy = prosody.generateHeadPoseWEKA(rpyPrev, rpyPrevPrev, audio.getF0()[i], audio.getRmsEnergy()[i]);
            }
            else
            {
                /*
                 * for (int j = 0; j < 3; j++)
                 * {
                 * rpy[j] = rpyPrev[j];
                 * }
                 */
                rpy = new double[3];
                // simple PD controller
                double v[] = Arrays.copyOf(rpyPrev, 3);
                for (int j = 0; j < 3; j++)
                {
                    v[j] -= rpyPrevPrev[j];
                    //rpy[j] = 0.2 * rpyPrev[j] + 0.8 * (rpyPrev[j]+v[j]);
                    //rpy[j] = rpyPrev[j] + 0.4 * v[j] + 0.02 * (offset[j]-rpyPrev[j]);
                    rpy[j] = rpyPrev[j];
                }
                System.out.println("i: "+i+" f0==0"+", v:"+ Arrays.toString(v));         
                
                
            }
            // rpy = prosody.generateHeadPoseDelta(rpyPrev, rpyPrevPrev, audio.getF0()[i], audio.getRmsEnergy()[i]);
            likelyhoodDensity -= prosody.minplog(rpy, rpyPrev, rpyPrevPrev, audio.getF0()[i], audio.getRmsEnergy()[i]);
            printer.printRecord(rpy[0], rpy[1], rpy[2]);
            cl.addConfig(
                    i * frameDuration,
                    Quat4f.getQuat4fFromRollPitchYawDegrees((float) rpy[0] - offset[0], (float) rpy[1] - offset[1], (float) rpy[2]
                            - offset[2]));
        }
        prevRPY = Arrays.copyOf(rpy, 3);
        printer.close();
        return new SkeletonInterpolator(new String[] { Hanim.skullbase }, cl, "R");
    }

    public static void createHeadMoveForSentences() throws IOException
    {
        GaussianMixtureModel gmmPitchVoiced = getGMM("gmmVoicedpitch11.xml");
        GaussianMixtureModel gmmYawVoiced = getGMM("gmmVoicedyaw11.xml");
        GaussianMixtureModel gmmRollVoiced = getGMM("gmmVoicedroll11.xml");
        GaussianMixtureModel gmmVVoiced = getGMM("gmmVoicedv11.xml");
        GaussianMixtureModel gmmAVoiced = getGMM("gmmVoiceda11.xml");

        GaussianMixtureModel gmmPitchUnvoiced = getGMM("gmmUnvoicedPitch6.xml");
        GaussianMixtureModel gmmYawUnvoiced = getGMM("gmmUnvoicedYaw6.xml");
        GaussianMixtureModel gmmRollUnvoiced = getGMM("gmmUnvoicedRoll6.xml");
        GaussianMixtureModel gmmVUnvoiced = getGMM("gmmUnvoicedV6.xml");
        GaussianMixtureModel gmmAUnvoiced = getGMM("gmmUnvoicedA6.xml");

        double rpyMean[] = new double[3];
        rpyMean[0] = gmmRollUnvoiced.getMu()[0];
        rpyMean[1] = gmmPitchUnvoiced.getMu()[0];
        rpyMean[2] = gmmYawUnvoiced.getMu()[0];

        System.out.println("rpy mean unvoiced: " + Arrays.toString(rpyMean));
        rpyMean = new double[] { HEAD_OFFSET[0], HEAD_OFFSET[1], HEAD_OFFSET[2] };

        String session = corpusdir + "Session1/sentences/";
        String fileprefixp = "/Ses01F_script01_3/Ses01F_script01_3_F0";

        VisualProsodyLeNumericalDiff vpModel = new VisualProsodyLeNumericalDiff(gmmPitchVoiced, gmmYawVoiced, gmmRollVoiced, gmmVVoiced,
                gmmAVoiced, gmmPitchUnvoiced, gmmYawUnvoiced, gmmRollUnvoiced, gmmVUnvoiced, gmmAUnvoiced);
        prevRPY = Arrays.copyOf(rpyMean, 3);
        BMLTInfo.init();
        BehaviourBlockBuilder builder = new BehaviourBlockBuilder();
        builder = builder.id("bml1");

        // for (int i = 10; i <= 44; i++)
        for (int i = 10; i <= 35; i++)
        {
            String fileprefix = fileprefixp + i;
            AudioFeatures af = getAudioFeatures(session, fileprefix);
            SkeletonInterpolator headSki = headMotion("headmove.csv", HEAD_OFFSET, prevRPY, vpModel, af, 1d / 120d);
            String sessionabspath = new File(session).toURI().toString();
            FaceInterpolator faceLips = HeadToBMLT.parseLipSyncFace(session, fileprefix);
            SkeletonInterpolator jawLips = HeadToBMLT.parseLipSyncJaw(session, fileprefix);

            builder.addBehaviour(
                    new BMLTAudioFileBehaviourBuilder("bml1", "audio" + i, sessionabspath + "wav" + fileprefix + ".wav").build())
                    .addBehaviour(new BMLTKeyframeBehaviourBuilder("bml1", "headmotion" + i).content(headSki.toXMLString()).build())
                    .addBehaviour(new BMLTKeyframeBehaviourBuilder("bml1", "lipsyncjaw" + i).content(jawLips.toXMLString()).build())
                    .addBehaviour(
                            new BMLTFaceKeyframeBehaviourBuilder("bml1", "lipsyncface" + i).type(Type.MORPH)
                                    .content(faceLips.toXMLString()).build());
            if (i > 10)
            {
                builder.addAtConstraint("bml1:audio" + (i - 1) + ":end", "bml1:audio" + i + ":start")
                        .addAtConstraint("bml1:audio" + (i - 1) + ":end", "bml1:headmotion" + i + ":start")
                        .addAtConstraint("bml1:audio" + (i - 1) + ":end", "bml1:lipsyncjaw" + i + ":start")
                        .addAtConstraint("bml1:audio" + (i - 1) + ":end", "bml1:lipsyncface" + i + ":start");
            }

        }
        builder.build().writeXML(new File("headmovelong.xml"));
    }

    public static void main(String args[]) throws IOException
    {
        //boolean TTS = false;
        boolean TTS = true;
        // createHeadMoveForSentences();

        //String session = corpusdir + "Session1/sentences/";
        //String fileprefix = "/Ses01F_script01_3/Ses01F_script01_3_F034";

        // String session = corpusdir + "Session1/sentences/";
        // String fileprefix = "/Ses01F_script01_3/Ses01F_script01_3_F033";

        // String session = corpusdir+"Session1/sentences/";
        // String fileprefix = "/Ses01F_impro01/Ses01F_impro01_F011";

        // String session = corpusdir+"Session1/sentences/";
        // String fileprefix = "/Ses01M_impro05/Ses01M_impro05_M031";

        // String session = corpusdir+"Session3/sentences/";
        // String fileprefix = "/Ses03F_impro02/Ses03F_impro02_F016";

        // String session = corpusdir + "Session5/sentences/";
        // String fileprefix = "/Ses05M_script01_1/Ses05M_script01_1_M027";

        // String session = corpusdir + "Session2/sentences/";
        // String fileprefix = "/Ses02F_script01_3/Ses02F_script01_3_F028";

        String session = "";
        // String fileprefix = "/Ses01F_script01_3_F034_dfki-prudence";
        // String fileprefix = "/Ses01F_script01_3_F034_dfki-prudence-hsmm";
        // String fileprefix = "/Ses01F_script01_3_F034_hannah";
        // String fileprefix = "/Ses01F_script01_3_F034_cmu-bdl-hsmm.wav";
        // String fileprefix = "/garage_hannah";

        //String fileprefix = "/dentist_hannah";
        //String fileprefix = "/garage_hannah";
        //String fileprefix = "/hawaii_hannah";
        //String fileprefix = "/login_hannah";
        //String fileprefix = "/shopping_hannah";
        //String fileprefix = "/hawaii_xfast_hannah";
        String fileprefix = "/hawaii_pitchrange_medium_hannah";
        String sentenceId = fileprefix.split("/")[fileprefix.split("/").length - 1];

        //String fileprefix = "/login_hannah";
        //String sentenceId = fileprefix.split("/")[fileprefix.split("/").length - 1];

        FaceInterpolator faceLips = null;
        SkeletonInterpolator jawLips = null;
        if (!TTS)
        {
            faceLips = HeadToBMLT.parseLipSyncFace(session, fileprefix);
            jawLips = HeadToBMLT.parseLipSyncJaw(session, fileprefix);
        }

        String sessionabspath = new File(session).toURI().toString();

        GaussianMixtureModel gmmPitchVoiced = getGMM("gmmVoicedpitch11.xml");
        GaussianMixtureModel gmmYawVoiced = getGMM("gmmVoicedyaw11.xml");
        GaussianMixtureModel gmmRollVoiced = getGMM("gmmVoicedroll11.xml");
        GaussianMixtureModel gmmVVoiced = getGMM("gmmVoicedv11.xml");
        GaussianMixtureModel gmmAVoiced = getGMM("gmmVoiceda11.xml");
        //GaussianMixtureModel gmmAVoiced = getGMM("gmmVoicedCVfiltered_A11.xml");
        

        GaussianMixtureModel gmmPitchUnvoiced = getGMM("gmmUnvoicedPitch6.xml");
        GaussianMixtureModel gmmYawUnvoiced = getGMM("gmmUnvoicedYaw6.xml");
        GaussianMixtureModel gmmRollUnvoiced = getGMM("gmmUnvoicedRoll6.xml");
        GaussianMixtureModel gmmVUnvoiced = getGMM("gmmUnvoicedV6.xml");
        GaussianMixtureModel gmmAUnvoiced = getGMM("gmmUnvoicedA6.xml");

        double rpyMean[] = new double[3];
        rpyMean[0] = gmmRollUnvoiced.getMu()[0];
        rpyMean[1] = gmmPitchUnvoiced.getMu()[0];
        rpyMean[2] = gmmYawUnvoiced.getMu()[0];

        System.out.println("rpy mean unvoiced: " + Arrays.toString(rpyMean));

        rpyMean = new double[3];
        rpyMean[0] = gmmRollVoiced.getMu()[0];
        rpyMean[1] = gmmPitchVoiced.getMu()[0];
        rpyMean[2] = gmmYawVoiced.getMu()[0];
        System.out.println("rpy mean voiced: " + Arrays.toString(rpyMean));
        rpyMean = new double[] { HEAD_OFFSET[0], HEAD_OFFSET[1], HEAD_OFFSET[2] };

        double rpyVar[] = new double[3];
        rpyVar[0] = gmmRollUnvoiced.getVar()[0];
        rpyVar[1] = gmmPitchUnvoiced.getVar()[0];
        rpyVar[2] = gmmYawUnvoiced.getVar()[0];

        System.out.println("rpy var unvoiced: " + Arrays.toString(rpyVar));

        VisualProsodyLeNumericalDiff vpModel = new VisualProsodyLeNumericalDiff(gmmPitchVoiced, gmmYawVoiced, gmmRollVoiced, gmmVVoiced,
                gmmAVoiced, gmmPitchUnvoiced, gmmYawUnvoiced, gmmRollUnvoiced, gmmVUnvoiced, gmmAUnvoiced);
        AudioFeatures af = getAudioFeatures(session, fileprefix);
        vpModel.setPositionWeight(0.2);
        vpModel.setVelocityWeight(2);
        long start = System.currentTimeMillis();
        SkeletonInterpolator headSki = headMotion(sentenceId + "_head.csv", HEAD_OFFSET, rpyMean, vpModel, af, 1d / 120d);
        System.out.println("Duration " + (System.currentTimeMillis() - start) + " ms");
        // SkeletonInterpolator headSki = silentHeadMotion(rpyMean, gmmVUnvoiced.getMu()[0], gmmVUnvoiced.getVar()[0], vpModel, 1000, 1d / 120d);

        BMLTInfo.init();
        BMLInfo.supportedExtensions.add(SSMLBehaviour.class);
        BehaviourBlockBuilder builder = new BehaviourBlockBuilder();
        builder = builder.id("bml1")
                .addBehaviour(new BMLTKeyframeBehaviourBuilder("bml1", "headmotion").content(headSki.toXMLString()).build())
                .addBehaviour(new GazeBehaviourBuilder("bml1", "gaze1", "camera").influence("EYES").offset(OffsetDirection.UP, 3).build())
                .addAtConstraint("gaze1:end", "headmotion:end+0.5").addAtConstraint("gaze1", "start", 0);

        if (TTS)
        {
            String speechContent = Files.toString(new File(session + "wav" + fileprefix + ".txt"), Charsets.UTF_8);
            builder = builder.addBehaviour(new SSMLBehaviourBuilder("bml1", "speech1").ssmlContent(speechContent).build());
        }
        else
        {
            builder = builder
                    .addBehaviour(new BMLTAudioFileBehaviourBuilder("bml1", "audio1", sessionabspath + "wav" + fileprefix + ".wav").build())
                    .addBehaviour(new BMLTKeyframeBehaviourBuilder("bml1", "lipsyncjaw1").content(jawLips.toXMLString()).build())
                    .addBehaviour(
                            new BMLTFaceKeyframeBehaviourBuilder("bml1", "lipsyncface1").type(Type.MORPH).content(faceLips.toXMLString())
                                    .build());

        }
        builder.build().writeXML(new File(sentenceId + ".xml"));
        System.out.println("total log likelihood density: " + likelyhoodDensity);
    }
}
