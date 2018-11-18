package nlpparser;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileWriter;
import java.io.IOException;
import java.io.StringReader;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.apache.commons.csv.CSVFormat;
import org.apache.commons.csv.CSVParser;
import org.apache.commons.csv.CSVPrinter;
import org.apache.commons.csv.CSVRecord;

import com.google.common.base.Charsets;
import com.google.common.collect.ImmutableList;
import com.google.common.collect.ImmutableMap;
import com.google.common.collect.ImmutableSet;
import com.google.common.io.Files;

public class PatternMatcher
{
    public static final ImmutableMap<String, Set<String>> patterns = ImmutableMap.<String, Set<String>> builder()
            .put("inclusivity", ImmutableSet.of("everything", "all", "whole", "plenty", "full", "completely"))
            .put("intensification",ImmutableSet.of("really","very","quite","wonderful","great","absolutely","huge","fantastic","so","amazing","important"))
            .put("affirmation",ImmutableSet.of("yeah","yes","yes,"))
            .put("negation",ImmutableSet.of("no","not","nothing","cannot","can't","cant","don't","dont","didn't","didnt","couldn't","couldnt","isn't","isnt","wasn't","wasnt"))
            .build();
            
    public static Map<String, Integer> counts = new HashMap<String, Integer>();
    public static int words = 0;
    
    public static void main(String args[]) throws FileNotFoundException, IOException
    {
        for (String pattern : patterns.keySet())
        {
            counts.put(pattern, 0);
        }

        for (File f : new File("../../corpus/IEMOCAP_full_release/").listFiles())
        {
            if (f.getName().startsWith("Session"))
            {
                for (File dir : new File(f.getAbsolutePath() + "/sentences/ForcedAlignment").listFiles())
                {
                    createPatterns(dir);
                }
            }
        }
        System.out.println(counts);
        System.out.println("Total number of words: "+words);
    }

    private static void writeWdSegWithPattern(List<CSVRecord> records, List<String> sentence, String filename) throws IOException
    {
        List<String> patternIds = ImmutableList.copyOf(patterns.keySet());
        List<String> header = ImmutableList.<String> builder().add("SFrm").add("EFrm").add("SegAScr").add("Word").addAll(patternIds)
                .build();

        CSVPrinter printer = new CSVPrinter(new FileWriter(new File(filename)), CSVFormat.RFC4180.withHeader(header
                .toArray(new String[header.size()])));

        for (CSVRecord record : records)
        {
            String word = record.get("Word");
            if (!word.equals("<s>") && !word.equals("<sil>") && !word.equals("</s>"))
            {
                List<String> items = new ArrayList<String>();
                for (String item : record)
                {
                    items.add(item);
                }
                for (String patternId : patternIds)
                {
                    boolean match = patterns.get(patternId).contains(word.toLowerCase());
                    items.add("" + match);
                    if (match)
                    {
                        counts.put(patternId, counts.get(patternId) + 1);
                    }
                }
                printer.printRecord(items);
            }
        }
        printer.close();
    }

    private static void createPatterns(File dir) throws IOException
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
                        sentence.add(word);
                        words++;
                    }
                }
                parser.close();
                String filename = f.getAbsolutePath().replaceAll(".wdseg", ".wdsegpatterns");
                writeWdSegWithPattern(recs, sentence, filename);
            }
        }
    }
}
