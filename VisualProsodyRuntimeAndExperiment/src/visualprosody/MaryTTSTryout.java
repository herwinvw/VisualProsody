package visualprosody;

import hmi.math.signalproc.Framer;
import hmi.math.signalproc.HammingWindow;
import hmi.math.signalproc.MovingAverage;
import hmi.math.signalproc.RootMeanSquared;

import java.io.File;
import java.io.FileOutputStream;
import java.io.FileWriter;
import java.io.StringWriter;
import java.nio.ByteBuffer;
import java.nio.ByteOrder;
import java.util.Arrays;

import javax.sound.sampled.AudioFileFormat;
import javax.sound.sampled.AudioInputStream;
import javax.xml.transform.OutputKeys;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;

import marytts.LocalMaryInterface;
import marytts.datatypes.MaryDataType;
import marytts.util.data.audio.MaryAudioUtils;

import org.apache.commons.csv.CSVFormat;
import org.apache.commons.csv.CSVPrinter;
import org.w3c.dom.Document;

import com.sun.media.sound.WaveFileWriter;

public class MaryTTSTryout
{
    private static String toString(Document doc)
    {
        try
        {
            StringWriter sw = new StringWriter();
            TransformerFactory tf = TransformerFactory.newInstance();
            Transformer transformer = tf.newTransformer();
            transformer.setOutputProperty(OutputKeys.OMIT_XML_DECLARATION, "no");
            transformer.setOutputProperty(OutputKeys.METHOD, "xml");
            transformer.setOutputProperty(OutputKeys.INDENT, "yes");
            transformer.setOutputProperty(OutputKeys.ENCODING, "UTF-8");

            transformer.transform(new DOMSource(doc), new StreamResult(sw));
            return sw.toString();
        }
        catch (Exception ex)
        {
            throw new RuntimeException("Error converting to String", ex);
        }
    }

    public static void main(String args[]) throws Exception
    {
        LocalMaryInterface marytts = new LocalMaryInterface();
        System.out.println("voices: " + marytts.getAvailableVoices());
        marytts.setVoice("dfki-prudence-hsmm");
        String speech = "Welcome to Greta's team page! "
                + "We work on making human-computer interactions more emotion-oriented and social. We develop an interactive embodied conversational agent platform technology. "
                + "Our methodology is based on the quality and property of humans’ communication. We are interested in improving communicative skills of virtual agents and learning "
                + "about human behaviour and communication."
                + "Our team is centered on research involving Greta, the embodied conversational agent. The agent is autonomous and expressive. "
                + "Greta can express her emotional states and intentions through verbal and nonverbal behaviours, and be socially aware. She can endorse different roles, "
                + "e.g. be a dialog companion, a storyteller, a virtual tutor, an actor in different games. "
                + "Greta is part of the SEMAINE platform where she is endowed with the capabilities to recognise emotional states, to process speech and to express"
                + " verbal and nonverbal behaviours.";

        speech = "Hello world";
        long startTimeWav = System.currentTimeMillis();
        marytts.setInputType(MaryDataType.TEXT.toString());
        marytts.setOutputType(MaryDataType.AUDIO.toString());
        AudioInputStream audio = marytts.generateAudio(speech);
        WaveFileWriter wr = new WaveFileWriter();
        File f = new File("helloworld2.wav");
        FileOutputStream fo = new FileOutputStream(f);
        wr.write(audio, AudioFileFormat.Type.WAVE, fo);
        fo.close();
        // MaryAudioUtils.writeWavFile(MaryAudioUtils.getSamplesAsDoubleArray(audio), "helloworld.wav", audio.getFormat());
        System.out.println("Wav file full generation time " + (System.currentTimeMillis() - startTimeWav) + " ms.");

        long startTime = System.currentTimeMillis();
        marytts.setInputType(MaryDataType.TEXT.toString());
        marytts.setOutputType(MaryDataType.REALISED_ACOUSTPARAMS.toString());
        Document acoustics = marytts.generateXML(speech);
        System.out.println("Acoustic parameter generation duration " + (System.currentTimeMillis() - startTime) + " ms.");

        startTime = System.currentTimeMillis();
        marytts.setInputType(MaryDataType.ACOUSTPARAMS.toString());
        marytts.setOutputType(MaryDataType.AUDIO.toString());
        audio = marytts.generateAudio(acoustics);
        System.out.println("Wav from acoustic parameter generation duration " + (System.currentTimeMillis() - startTime) + " ms.");

        // assumes mono, 16 bit audio
        byte data[] = new byte[(int) (audio.getFrameLength() * audio.getFormat().getFrameSize())];
        audio.read(data);
        ByteBuffer bb = ByteBuffer.wrap(data);
        bb.order(ByteOrder.LITTLE_ENDIAN);
        if (audio.getFormat().isBigEndian())
        {
            bb.order(ByteOrder.BIG_ENDIAN);
        }
        double frame[] = new double[data.length / 2];
        for (int i = 0; i < frame.length; i++)
        {
            frame[i] = (double) bb.getShort() / 32768d;
        }

        marytts.setInputType(MaryDataType.TEXT.toString());
        marytts.setOutputType(MaryDataType.AUDIO.toString());
        audio = marytts.generateAudio(speech);
        float frameRate = audio.getFormat().getFrameRate();
        // double frame[] = MaryAudioUtils.getSamplesAsDoubleArray(audio);
        double I0 = 0.000001d;
        // System.out.println(Arrays.toString(frame));
        // frameSize: 0.050 s
        // frameStep: 0.00833333333 s
        double frames[][] = Framer.frame(frame, (int) (0.050d * frameRate), (int) (0.00833333333d * frameRate));
        double intensity[] = new double[frames.length];
        double loudness[] = new double[frames.length];
        double rmsEnergy[] = new double[frames.length];
        for (int i = 0; i < frames.length; i++)
        {
            double hammSum = 0;
            for (int j = 0; j < frames[i].length; j++)
            {
                double h = HammingWindow.hamming(j, frames[i].length);
                hammSum += h;
                intensity[i] += h * frames[i][j] * frames[i][j];
            }
            rmsEnergy[i] = RootMeanSquared.rootMeanSquared(frames[i]);
            System.out.println(hammSum + " framelength: " + frames[i].length + "intensity: " + intensity[i]);
            intensity[i] /= hammSum;
            loudness[i] = Math.pow(intensity[i] / I0, 0.3);
        }
        double[] outputIntensity = MovingAverage.movingAverageFilter(intensity, 3);
        double outputLoudness[] = MovingAverage.movingAverageFilter(loudness, 3);
        double outputRMSEnergy[] = MovingAverage.movingAverageFilter(rmsEnergy, 3);
        System.out.println(Arrays.toString(outputIntensity));
        System.out.println("Numframes: " + outputIntensity.length);
        System.out.println(Arrays.toString(outputLoudness));

        CSVPrinter printer = new CSVPrinter(new FileWriter(new File("prosody.csv")), CSVFormat.RFC4180.withHeader("intensity", "loudness",
                "rmsEnergy"));
        for (int i = 0; i < outputIntensity.length; i++)
        {
            printer.printRecord(outputIntensity[i], outputLoudness[i], outputRMSEnergy[i]);
        }
        printer.close();

        printer = new CSVPrinter(new FileWriter(new File("frame.csv")), CSVFormat.RFC4180.withHeader("frame", "pcm"));
        for (int i = 0; i < frame.length; i++)
        {
            printer.printRecord(i, frame[i]);
        }
        printer.close();

        audio = marytts.generateAudio(speech);
        double[] ddata = MaryAudioUtils.getSamplesAsDoubleArray(audio);
        System.out.println("data length:"+frame.length+", "+"data length:"+ddata.length);
        for(int i=0;i<frame.length;i++)
        {
            if(Math.abs(frame[i])>0.1)
            System.out.println(frame[i]+" "+ddata[i]);
        }
    }
}
