package nlpparser;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStream;
import java.io.StringReader;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import opennlp.tools.postag.POSModel;
import opennlp.tools.postag.POSTaggerME;

import org.apache.commons.csv.CSVFormat;
import org.apache.commons.csv.CSVParser;
import org.apache.commons.csv.CSVPrinter;
import org.apache.commons.csv.CSVRecord;

import com.google.common.base.Charsets;
import com.google.common.collect.ImmutableList;
import com.google.common.io.Files;

/**
 * Produces POS tags for all word segments in the corpus
 * @author herwinvw
 *
 */
public class PosGenerator
{
    private static void writeWdSegWithPOS(List<CSVRecord> records, String[] pos, String filename) throws IOException
    {
        CSVPrinter printer = new CSVPrinter(new FileWriter(new File(filename)),CSVFormat.RFC4180.withHeader("SFrm", "EFrm","SegAScr","Word","POS"));
        int i =0;
        for(CSVRecord record:records)
        {
            String word = record.get("Word");
            if (!word.equals("<s>") && !word.equals("<sil>") && !word.equals("</s>"))
            {
                List<String>items = new ArrayList<String>();
                for(String item:record)
                {
                    items.add(item);
                }
                items.add(pos[i]);
                printer.printRecord(items);
                i++;
            }
        }
        printer.close();
    }
    
    
    public static void main(String args[]) throws FileNotFoundException, IOException
    {
        InputStream modelIn = new FileInputStream("resource/en-pos-maxent.bin");
        POSModel model = new POSModel(modelIn);
        POSTaggerME tagger = new POSTaggerME(model);
        
        for(File f:new File("../../corpus/IEMOCAP_full_release/").listFiles())
        {
            if(f.getName().startsWith("Session"))
            {
                for(File dir:new File(f.getAbsolutePath()+"/sentences/ForcedAlignment").listFiles())
                {
                    createPos(tagger, dir);
                }
            }
        }        
    }


    private static void createPos(POSTaggerME tagger, File dir) throws IOException
    {
        for (File f : dir.listFiles())
        {
            if (f.getName().endsWith(".wdseg"))
            {
                String text = Files.toString(f, Charsets.UTF_8);
                text = text.replaceAll("\t", " ");
                text = text.trim();
                text = text.replaceAll("\n +", "\n");
                text = text.replaceAll(" +", ",");
                text = text.replaceAll("\nTotal.+", "");

                CSVParser parser = new CSVParser(new StringReader(text), CSVFormat.RFC4180.withIgnoreSurroundingSpaces(true).withHeader());
                List<String> sentence = new ArrayList<String>();
                
                List<CSVRecord> recs = ImmutableList.copyOf(parser.getRecords());
                for (CSVRecord rec : recs)
                {
                    String word = rec.get("Word");
                    if (!word.equals("<s>") && !word.equals("<sil>") && !word.equals("</s>"))
                    {
                        word = word.replaceAll("\\(.+", "").toLowerCase();
                        if(word.equals("i"))
                        {
                            word = "I";
                        }
                        word = word.replaceAll("i\'", "I\'");
                        sentence.add(word);
                    }                    
                }
                sentence.set(0, sentence.get(0).substring(0,1).toUpperCase()+sentence.get(0).substring(1));
                sentence.add(".");
                String tags[] = tagger.tag(sentence.toArray(new String[sentence.size()]));
                tags = Arrays.copyOfRange(tags, 0, tags.length-1);
                parser.close();  
                String filename = f.getAbsolutePath().replaceAll(".wdseg", ".wdsegpos");
                writeWdSegWithPOS(recs, tags, filename);
            }
        }
    }
}
