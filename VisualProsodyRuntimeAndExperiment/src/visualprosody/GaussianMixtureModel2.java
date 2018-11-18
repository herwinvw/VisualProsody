package visualprosody;

import java.util.List;

import lombok.Data;

import com.google.common.collect.ImmutableList;

public class GaussianMixtureModel2
{
    private final List<GaussianMixture> mixtures;

    @Data
    public static final class GaussianMixture
    {
        final double weight;
        final MVGaussian distribution;
        
        public int getDimensions()
        {
            return distribution.getK();
        }
        
        public double[][] getSigma()
        {
            return distribution.getSigma();
        }
        
        public double[] getMu()
        {
            return distribution.getMu();
        }
        
        public double P(double x[])
        {
            return distribution.P(x);
        }

        public double Pdiff1(double x[])
        {
            return distribution.Pdiff1(x);
        }
    }

    public GaussianMixtureModel2(List<GaussianMixture> mixtures)
    {
        this.mixtures = ImmutableList.copyOf(mixtures);
    }

    /**
     * Get the weighted average of the means of the mixtures in the GMM
     */
    public double[] getMu()
    {
        double mean[] = new double[mixtures.get(0).getDimensions()];
        for (GaussianMixture gm : mixtures)
        {
            for(int i=0;i<gm.getDimensions();i++)
            {
                mean[i] += gm.getMu()[i] * gm.getWeight();
            }
        }
        return mean;
    }
    
    /**
     * Get the weighted average of the variance of the mixtures in the GMM
     */
    public double[] getVar()
    {
        double var[] = new double[mixtures.get(0).getDimensions()];
        for (GaussianMixture gm : mixtures)
        {
            for(int i=0;i<gm.getDimensions();i++)
            {
                var[i] += gm.getSigma()[i][i] * gm.getWeight();
            }
        }
        return var;
    }
    
    
    public double P(double x[])
    {
        double p = 0;
        for (GaussianMixture gm : mixtures)
        {
            p += gm.P(x) * gm.getWeight();
        }
        return p;
    }
    
    public double Pdiff1(double vals[])
    {
        double p = 0;
        for (GaussianMixture gm : mixtures)
        {
            p += gm.Pdiff1(vals) * gm.getWeight();
        }
        return p;
    }

    /**
     * Calculates dp/dx1 -log(P(x))     
     */
    public double logPDiff1(double x[])
    {
        double p = P(x);
        //System.out.println("p: "+p);
        if(p==0)
        {
            //return 0; //TODO: check this...
            System.err.println("p=0, Pdiff1(x)="+Pdiff1(x));
            return Pdiff1(x)*100;
        }
        else
        {
            return (1 / p) * Pdiff1(x);
        }
    }
}
