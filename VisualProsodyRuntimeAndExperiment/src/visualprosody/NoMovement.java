package visualprosody;

import java.io.File;
import java.io.IOException;

import saiba.bml.builder.BehaviourBlockBuilder;
import saiba.bml.builder.GazeBehaviourBuilder;
import saiba.bml.builder.SpeechBehaviourBuilder;
import saiba.bml.core.OffsetDirection;
import asap.bml.ext.bmlt.BMLTInfo;

import com.google.common.base.Charsets;
import com.google.common.io.Files;

public class NoMovement
{
    public static void main(String args[]) throws IOException
    {
        String session = "";
        //String fileprefix = "/shopping_hannah";
        //String fileprefix = "/dentist_hannah";
        //String fileprefix = "/garage_hannah";
        //String fileprefix = "/hawaii_hannah";
        String fileprefix = "/login_hannah";
        String sentenceId = fileprefix.split("/")[fileprefix.split("/").length - 1];

        BMLTInfo.init();
        BehaviourBlockBuilder builder = new BehaviourBlockBuilder();
        builder = builder.id("bml1");
        String speechContent = Files.toString(new File(session + "wav" + fileprefix + ".txt"), Charsets.UTF_8);
        builder = builder.addBehaviour(new SpeechBehaviourBuilder("bml1", "speech1").content(speechContent).build());
        builder.addAtConstraint("gaze1", "start", 0);
        builder.addAtConstraint("gaze1:end", "speech1:end+0.5");
        builder.addBehaviour(new GazeBehaviourBuilder("bml1", "gaze1", "camera").influence("EYES").offset(OffsetDirection.UP, 3).build());
        builder.build().writeXML(new File(sentenceId + "_nomovement.xml"));
    }
}
