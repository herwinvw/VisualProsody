package visualprosody;

import hmi.animation.ConfigList;
import hmi.animation.Hanim;
import hmi.animation.SkeletonInterpolator;
import hmi.faceanimation.FaceInterpolator;
import hmi.math.Quat4f;
import hmi.util.Resources;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import lombok.Data;

import org.apache.commons.csv.CSVFormat;
import org.apache.commons.csv.CSVParser;
import org.apache.commons.csv.CSVRecord;
import org.apache.commons.math3.distribution.NormalDistribution;

import saiba.bml.BMLInfo;
import saiba.bml.builder.BehaviourBlockBuilder;
import saiba.bml.core.BehaviourBlock;
import asap.bml.ext.bmlt.BMLTFaceKeyframeBehaviour.Type;
import asap.bml.ext.bmlt.BMLTInfo;
import asap.bml.ext.bmlt.builder.BMLTAudioFileBehaviourBuilder;
import asap.bml.ext.bmlt.builder.BMLTFaceKeyframeBehaviourBuilder;
import asap.bml.ext.bmlt.builder.BMLTKeyframeBehaviourBuilder;
import asap.bml.ext.ssml.SSMLBehaviour;
import bmlt.HeadToBMLT;

import com.google.common.base.Charsets;
import com.google.common.primitives.Doubles;

public class VisualProsodyOfflineBML
{
    private static final String corpusdir = "../IEMOCAP_analysis/corpus/IEMOCAP_full_release/";

    private static GaussianMixtureModel2 getGMM(String filename) throws IOException
    {
        GMMParser gmmParser = new GMMParser();
        gmmParser.readXML(new Resources("").getReader(filename));
        return gmmParser.constructMixtureModel2();
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
            rmsValues.add(Double.parseDouble(rec.get("pcm_RMSenergy_sma")));
        }
        return new AudioFeatures(Doubles.toArray(f0Values), Doubles.toArray(rmsValues));
    }

    private static SkeletonInterpolator silentHeadMotion(double[] rpyStart, double velocityMean, double velocityVar, VisualProsodyLe prosody, int frames, double frameDuration)
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
            for (int j=0;j<3;j++)
            {
                rpySearchStart[j]=rpyPrev[j]+velocityDist.sample()/3;
            }
            System.out.println("rpySearchStart:"+Arrays.toString(rpySearchStart));
            //rpy = prosody.generateHeadPose(rpyPrev, rpyPrevPrev, 0, (Math.random()+1)*0.1d);
            rpy = prosody.generateHeadPose(rpySearchStart, rpyPrev, rpyPrevPrev, 0, 0);
            System.out.println("rpy(" + i + ")=" + Arrays.toString(rpy));
            cl.addConfig(i * frameDuration, Quat4f.getQuat4fFromRollPitchYawDegrees((float) rpy[0], (float) rpy[1], (float) rpy[2]));
        }
        return new SkeletonInterpolator(new String[] { Hanim.skullbase }, cl, "R");

    }

    private static SkeletonInterpolator headMotion(double[] rpyStart, VisualProsodyLe prosody, AudioFeatures audio, double frameDuration)
    {
        ConfigList cl = new ConfigList(4);
        double[] rpy = Arrays.copyOf(rpyStart, 3);
        double[] rpyPrev = Arrays.copyOf(rpyStart, 3);
        double[] rpyPrevPrev = Arrays.copyOf(rpyStart, 3);
        
        for (int i = 0; i < audio.getF0().length; i++)
        {
            rpyPrevPrev = rpyPrev;
            rpyPrev = rpy;
            System.out.println("f0: "+audio.getF0()[i]+"rms energy: "+audio.getRmsEnergy()[i]);
            rpy = prosody.generateHeadPose(rpyPrev, rpyPrev, rpyPrevPrev, audio.getF0()[i], audio.getRmsEnergy()[i]);
            System.out.println("rpy(" + i + ")=" + Arrays.toString(rpy));
            cl.addConfig(i * frameDuration, Quat4f.getQuat4fFromRollPitchYawDegrees((float) rpy[0], (float) rpy[1], (float) rpy[2]));
        }
        return new SkeletonInterpolator(new String[] { Hanim.skullbase }, cl, "R");
    }

    public static void main(String args[]) throws IOException
    {
        String session = corpusdir + "Session1/sentences/";
        String fileprefix = "/Ses01F_script01_3/Ses01F_script01_3_F033";
        FaceInterpolator faceLips = HeadToBMLT.parseLipSyncFace(session, fileprefix);
        SkeletonInterpolator jawLips = HeadToBMLT.parseLipSyncJaw(session, fileprefix);
        String sessionabspath = new File(session).toURI().toString();

        GaussianMixtureModel2 gmmPitchVoiced = getGMM("gmmVoicedpitch11.xml");
        GaussianMixtureModel2 gmmYawVoiced = getGMM("gmmVoicedyaw11.xml");
        GaussianMixtureModel2 gmmRollVoiced = getGMM("gmmVoicedroll11.xml");
        GaussianMixtureModel2 gmmVVoiced = getGMM("gmmVoicedv11.xml");
        GaussianMixtureModel2 gmmAVoiced = getGMM("gmmVoiceda11.xml");

        GaussianMixtureModel2 gmmPitchUnvoiced = getGMM("gmmUnvoicedPitch6.xml");
        GaussianMixtureModel2 gmmYawUnvoiced = getGMM("gmmUnvoicedYaw6.xml");
        GaussianMixtureModel2 gmmRollUnvoiced = getGMM("gmmUnvoicedRoll6.xml");
        GaussianMixtureModel2 gmmVUnvoiced = getGMM("gmmUnvoicedV6.xml");
        GaussianMixtureModel2 gmmAUnvoiced = getGMM("gmmUnvoicedA6.xml");

        double rpyMean[] = new double[3];
        rpyMean[0] = gmmRollUnvoiced.getMu()[0];
        rpyMean[1] = gmmPitchUnvoiced.getMu()[0];
        rpyMean[2] = gmmYawUnvoiced.getMu()[0];
        System.out.println("rpy mean unvoiced: " + Arrays.toString(rpyMean));
        double rpyVar[] = new double[3];
        rpyVar[0] = gmmRollUnvoiced.getVar()[0];
        rpyVar[1] = gmmPitchUnvoiced.getVar()[0];
        rpyVar[2] = gmmYawUnvoiced.getVar()[0];
        System.out.println("rpy var unvoiced: " + Arrays.toString(rpyVar));

        VisualProsodyLe vpModel = new VisualProsodyLe(gmmPitchVoiced, gmmYawVoiced, gmmRollVoiced, gmmVVoiced, gmmAVoiced,
                gmmPitchUnvoiced, gmmYawUnvoiced, gmmRollUnvoiced, gmmVUnvoiced, gmmAUnvoiced);
        AudioFeatures af = getAudioFeatures(session, fileprefix);
        SkeletonInterpolator headSki = headMotion(rpyMean, vpModel,af,1d/120d);
        //SkeletonInterpolator headSki = silentHeadMotion(rpyMean, gmmVUnvoiced.getMu()[0], gmmVUnvoiced.getVar()[0], vpModel, 1000, 1d / 120d);

        BMLTInfo.init();        
        BehaviourBlockBuilder builder = new BehaviourBlockBuilder();
        BehaviourBlock bb = builder.id("bml1")
                .addBehaviour(new BMLTAudioFileBehaviourBuilder("bml1", "audio1", sessionabspath + "wav" + fileprefix + ".wav").build())
                .addBehaviour(new BMLTKeyframeBehaviourBuilder("bml1", "headmotion").content(headSki.toXMLString()).build())
                .addBehaviour(new BMLTKeyframeBehaviourBuilder("bml1", "lipsyncjaw1").content(jawLips.toXMLString()).build())
                .addBehaviour(
                new BMLTFaceKeyframeBehaviourBuilder("bml1", "lipsyncface1").type(Type.MORPH).content(faceLips.toXMLString())
                .build())
                .build();
        bb.writeXML(new File("headmove.xml"));
    }
}
